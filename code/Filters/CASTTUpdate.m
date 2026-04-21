function castt = CASTTUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,castt)

A = params.A;
c = eye(6)*params.c;
gamma1 = params.gamma1;
gamma2 = params.gamma2;
conf = params.conf;

% normalize enabled quality weights (detector confidence disabled by setting w1=0)
w = conf.w(:);
if sum(w(2:4)) > 0
    w(2:4) = w(2:4)/sum(w(2:4));
end
w(1) = 0;

x_secq  = [];
for i =1:num_agent
x_secq = [x_secq,castt.agent(i).x(:,end)];
end

tic
for i = 1:num_agent
    % prediction
    x = castt.agent(i).x(:,end);
    M = castt.agent(i).M;
    x = A * x;
    M = (A*M*A')^(-1)/(1+gamma1)/norm(A);

    % correction
    S = zeros(6);
    y = zeros(6,1);
    neighbor_x = zeros(6,1);
    get_neighbor_sec = link_neighbor(1:num_neighbor+1,i);

    % observer-wise quality memory for agent i
    q_bar = castt.agent(i).q_bar;
    n_hit = castt.agent(i).n_hit;
    n_lost = castt.agent(i).n_lost;
    sigma2_mem = castt.agent(i).sigma2;

    for j = 1:num_neighbor+1
        obs_id = get_neighbor_sec(j);
        x_j = x_secq(:,obs_id);
        position = agent_p(:,obs_id);
        neighbor_x = neighbor_x + x_j;
        g = g_measurement(:,obs_id);

        % geometric prediction terms
        delta_p_pred = x(1:3) - position;
        r_pred = max(norm(delta_p_pred),1e-6);
        g_pred = delta_p_pred/r_pred;

        % quality score components
        s_det = 0;
        theta = acos(max(min(conf.e_cam'*g,1),-1));
        s_center = clip(1 - theta/conf.theta_max,0,1);
        s_area = clip((conf.r_ref^2)/(r_pred^2),0,1);

        innovation_angle = acos(max(min(g_pred'*g,1),-1));
        is_hit = innovation_angle <= conf.track_gate;
        if is_hit
            n_hit(obs_id) = n_hit(obs_id) + 1;
            n_lost(obs_id) = 0;
        else
            n_hit(obs_id) = 0;
            n_lost(obs_id) = n_lost(obs_id) + 1;
        end
        s_track = min(n_hit(obs_id)/conf.N_ref,1)*exp(-n_lost(obs_id)/conf.tau);
        s_track = clip(s_track,0,1);

        q_raw = w(1)*s_det + w(2)*s_center + w(3)*s_area + w(4)*s_track;
        q_bar(obs_id) = (1-conf.eta)*q_bar(obs_id) + conf.eta*q_raw;
        q_bar(obs_id) = clip(q_bar(obs_id),conf.q_min,1);

        sigma2_jk = conf.sigma_good^2 + (conf.sigma_bad^2-conf.sigma_good^2)*(1-q_bar(obs_id))^conf.gamma;
        sigma2_mem(obs_id) = sigma2_jk;

        % Use covariance form R_jk = sigma^2_jk I  --> lower quality => larger variance => lower weight
        Rinv_jk = eye(3)/sigma2_jk;
        Rinv_fixed = eye(3)*conf.fixed_Rinv_scale;
        P_g = eye(3)-g*g';
        H1 =  [P_g,zeros(3)];
        z1 =  P_g*position;

        switch upper(conf.ablation_mode)
            case "A" % only e_meas uses adaptive weight
                W_S = Rinv_fixed;
                W_y = Rinv_jk;
            case "B" % only S_{i,k} uses adaptive weight
                W_S = Rinv_jk;
                W_y = Rinv_fixed;
            otherwise  % "C": both terms use adaptive weight
                W_S = Rinv_jk;
                W_y = Rinv_jk;
        end

        S = S + H1'*W_S*H1;
        y = y + H1'*W_y*z1;
    end

    e_meas = c*(y - S*x);
    e_consensus = A*neighbor_x/(num_neighbor+1) - x;
    S = c*S+eye(6);

    % correction
    M = (gamma2*M + S)^(-1);
    x = x+M*(e_meas + e_consensus);

    temp(i).x = x;
    temp(i).M = M;
    temp(i).q_bar = q_bar;
    temp(i).n_hit = n_hit;
    temp(i).n_lost = n_lost;
    temp(i).sigma2 = sigma2_mem;
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
castt.t = castt.t+used_time;
for i = 1:num_agent
    castt.agent(i).x(:,end+1) = temp(i).x;
    castt.agent(i).M = temp(i).M;
    castt.agent(i).q_bar = temp(i).q_bar;
    castt.agent(i).n_hit = temp(i).n_hit;
    castt.agent(i).n_lost = temp(i).n_lost;
    castt.agent(i).sigma2 = temp(i).sigma2;
end

function y = clip(x,lb,ub)
y = min(max(x,lb),ub);
