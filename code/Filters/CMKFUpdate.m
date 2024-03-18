function cmkf = CMKFUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,cmkf)

A = params.A;
Q = params.Q;%[eye(3)*params.q1,zeros(3);zeros(3),eye(3)*params.q2];
R1 = eye(3)*params.r1;
tic
for i = 1:num_agent
    % prediction
    x = cmkf.agent(i).x(:,end);
    P = cmkf.agent(i).P;
    x = A * x;
    P = A*P*A'+Q;
    
    % correction
    S = zeros(6);
    y = zeros(6,1);
    get_neighbor_sec = link_neighbor(1:num_neighbor+1,i);
    for j = 1:num_neighbor+1
        g = g_measurement(:,get_neighbor_sec(j));    
        position = agent_p(:,get_neighbor_sec(j));
%         r = norm(position - x(1:3));
        P_g = eye(3)-g*g';
        H1 =  [P_g,zeros(3)];
        z1 =  P_g*position;
        
        S = S + H1'*R1^(-1)*H1;
        y = y + H1'*R1^(-1)*z1;
    end
    
    K = (P^(-1)+S)^(-1);
    x = x+K*(y-S*x);
    P = (eye(6)-K*S)*P;

    cmkf.agent(i).x(:,end+1) = x;
    cmkf.agent(i).P = P;
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
cmkf.t = cmkf.t+used_time;