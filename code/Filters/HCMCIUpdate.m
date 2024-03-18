function hcmci = HCMCIUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,hcmci)

A = params.A;
Q = params.Q;%[eye(3)*params.q1,zeros(3);zeros(3),eye(3)*params.q2];
R1 = eye(3)*params.r1;

x_secq  = [];
for i =1:num_agent
x_secq = [x_secq,hcmci.agent(i).x(:,end)];
end

tic
for i = 1:num_agent
    % communication
    S = zeros(6);
    y = zeros(6,1);
    x = zeros(6,1);
    P = zeros(6);
    get_neighbor_sec = link_neighbor(1:num_neighbor+1,i);
    for j = 1:num_neighbor+1
        x_j = x_secq(:,get_neighbor_sec(j));
        x = x + x_j;
        P = P + hcmci.agent(get_neighbor_sec(j)).P;
        
        g = g_measurement(:,get_neighbor_sec(j));    
        position = agent_p(:,get_neighbor_sec(j));
    
%         r = norm(position - x_j(1:3));
        P_g = eye(3)-g*g';
        H1 =  [P_g,zeros(3)];
        z1 =  P_g*position;
        
        S = S + H1'*R1^(-1)*H1;
        y = y + H1'*R1^(-1)*z1;
    end
    consensus_value = 0.25;
    x = consensus_value*hcmci.agent(i).x(:,end) + (1-consensus_value)*x/(num_neighbor+1);
    P = consensus_value*hcmci.agent(i).P+ (1-consensus_value)*P/(num_neighbor+1);

    x = A*x;
    P = A*P*A'+(num_neighbor+1)*Q;
    S = S/(num_neighbor+1);
    y = y/(num_neighbor+1);
    
    K = (P^(-1)+S)^(-1);
    x = x+K*(y-S*x);
    P = (eye(6)-K*S)*P;

%     hcmci.agent(i).x(:,end+1) = x;
    temp(i).x = x;
    temp(i).P = P;
end
for i = 1:num_agent
    hcmci.agent(i).x(:,end+1) = temp(i).x;
    hcmci.agent(i).P = temp(i).P;
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
hcmci.t = hcmci.t+used_time;
