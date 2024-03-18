function tkf =TKFUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,tkf)

A = params.A;
Q = params.Q;%[eye(3)*params.q1,zeros(3);zeros(3),eye(3)*params.q2];
R1 = eye(3)*params.r1;
H = [eye(3),zeros(3)];
tic
for i = 1:num_agent
    % prediction
    x = tkf.agent(i).x(:,end);
    P = tkf.agent(i).P;
    x = A * x;
    P = A*P*A'+Q;
    
    % correction
    if num_neighbor~=0
    S = zeros(3);
    y = zeros(3,1);
    get_neighbor_sec = link_neighbor(1:num_neighbor+1,i);
    for j = 1:num_neighbor+1
        g = g_measurement(:,get_neighbor_sec(j));    
        position = agent_p(:,get_neighbor_sec(j));
    
        P_g = eye(3)-g*g';
        z1 =  P_g*position;
        
        S = S + P_g;
        y = y + z1;
    end
    
    z_p = (S'*S)^(-1)*S'*y;
    
    K = (P*H')*(H*P*H'+R1)^(-1);
    x = x+K*(z_p-H*x);
    P = (eye(6)-K*H)*P;
    end
    
    tkf.agent(i).x(:,end+1) = x;
    tkf.agent(i).P = P;
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
tkf.t = tkf.t+used_time;