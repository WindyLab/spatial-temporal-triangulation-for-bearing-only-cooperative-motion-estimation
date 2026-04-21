function castt = CASTTUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,castt)

A = params.A;
c = eye(6)*params.c;
gamma1 = params.gamma1;
gamma2 = params.gamma2;
R1 = eye(3)*params.r1;
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
    for j = 1:num_neighbor+1
        x_j = x_secq(:,get_neighbor_sec(j));
        position = agent_p(:,get_neighbor_sec(j));
        neighbor_x = neighbor_x + x_j;
        g = g_measurement(:,get_neighbor_sec(j));

        P_g = eye(3)-g*g';
        H1 =  [P_g,zeros(3)];
        z1 =  P_g*position;

        S = S + H1'*R1^(-1)*H1;
        y = y + H1'*R1^(-1)*z1;
    end

    e_meas = c*(y - S*x);
    e_consensus = A*neighbor_x/(num_neighbor+1) - x;
    S = c*S+eye(6);

    % correction
    M = (gamma2*M + S)^(-1);
    x = x+M*(e_meas + e_consensus);

    temp(i).x = x;
    temp(i).M = M;
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
castt.t = castt.t+used_time;
for i = 1:num_agent
    castt.agent(i).x(:,end+1) = temp(i).x;
    castt.agent(i).M = temp(i).M;
end
