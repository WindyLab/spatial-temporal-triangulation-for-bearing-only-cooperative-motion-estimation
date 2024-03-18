function sttr = STTRUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,agent_v,g_measurement,g_rate_measurement,sttr)

A = params.A;
c1 = eye(6)*params.c1;
c2 = eye(6)*params.c2;
gamma1 = 1/params.gamma1;
gamma2 = params.gamma2;
R1 = eye(3)*params.r1;
R2 = eye(3)*params.r2;
tic
for i = 1:num_agent
    % prediction
    x = sttr.agent(i).x(:,end);
    M = sttr.agent(i).M;
    x = A * x;
    M = gamma1*(A*M*A')^(-1);
    
    % correction
    S1 = zeros(6);
    y1 = zeros(6,1);
    S2 = zeros(6);
    y2 = zeros(6,1);
    neighbor_x = zeros(6,1);
    get_neighbor_sec = link_neighbor(1:num_neighbor+1,i);
    for j = 1:num_neighbor+1
        x_j = sttr.agent(get_neighbor_sec(j)).x(:,end);
        if j >1
        neighbor_x = neighbor_x + x_j;
        end
        g = g_measurement(:,get_neighbor_sec(j));    
        position = agent_p(:,get_neighbor_sec(j));
        
%         r = norm(position - x_j(1:3));
        P_g = eye(3)-g*g';
        H1 =  [P_g,zeros(3)];
        z1 =  P_g*position;
        
        g_rate = g_rate_measurement(:,get_neighbor_sec(j));
        velocity = agent_v(:,get_neighbor_sec(j));
        
        H2 = [-g_rate*g',P_g];
        z2 = -g_rate*g'*position + P_g*velocity;

        S1 = S1 + H1'*R1^(-1)*H1;
        y1 = y1 + H1'*R1^(-1)*z1;

        S2 = S2 +  H2'*R2^(-1)*H2;
        y2 = y2 + H2'*R2^(-1)*z2;
    end
    
    e_g = c1*(y1 - S1*x);
    e_g_rate = c2*(y2 - S2*x);
    
    e_consensus = A*neighbor_x/(num_neighbor) - x;
    S = (c1*S1+c2*S2)+eye(6);

    % correction
    M = (gamma2*M + S)^(-1);
    x = x+M*(e_g + e_g_rate + e_consensus);
    temp(i).x = x;
    temp(i).M = M;
    
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
sttr.t = sttr.t+used_time;
for i = 1:num_agent
    sttr.agent(i).x(:,end+1) = temp(i).x;
    sttr.agent(i).M = temp(i).M;
end

