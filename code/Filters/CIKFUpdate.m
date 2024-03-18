function cikf = CIKFUpdate(num_agent,num_neighbor,params,link_neighbor,agent_p,g_measurement,cikf)

A = params.A;
Q = params.Q;%[eye(3)*params.q1,zeros(3);zeros(3),eye(3)*params.q2];
R1 = eye(3)*params.r1;

x_secq  = [];
for i =1:num_agent
x_secq = [x_secq,cikf.agent(i).x(:,end)];
end

tic
for i = 1:num_agent
    % prediction
    x = x_secq(:,i);
    P = cikf.agent(i).P;
    x = A * x;
    P = A*P*A'+Q;
    
    % correction
    g = g_measurement(:,i);    
    position = agent_p(:,i);

%     r = norm(position - x(1:3));
    P_g = eye(3)-g*g';
    H1 =  [P_g,zeros(3)];
    z1 =  P_g*position;
    
    S = H1'*R1^(-1)*H1;
    y = H1'*R1^(-1)*z1;
    
    K = (P^(-1)+S)^(-1);
    x = x+K*(y-S*x);
    P = (eye(6)-K*S)*P;

    cikf.agent(i).x(:,end+1) = x;
    cikf.agent(i).P = P;
end
%=========consensus==============%

if num_neighbor~=0

for i = 1:num_agent
    get_neighbor_sec = link_neighbor(2:num_neighbor+1,i);
    neighbor_x = zeros(6,1);
    neighbor_P = zeros(6);
    
    for j = 1:num_neighbor
        neighbor_x = neighbor_x + cikf.agent(get_neighbor_sec(j)).x(:,end);
        neighbor_P = neighbor_P + cikf.agent(get_neighbor_sec(j)).P;
    end
    consensus(i).neighbor_x = neighbor_x/num_neighbor;
    consensus(i).neighbor_P = neighbor_P/num_neighbor;
end

for i = 1:num_agent
    consensus_value = 0.25;
    cikf.agent(i).x(:,end) = consensus_value*cikf.agent(i).x(:,end) + (1-consensus_value )*consensus(i).neighbor_x;
    cikf.agent(i).P = consensus_value*cikf.agent(i).P + (1-consensus_value )*consensus(i).neighbor_P;
end
end
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*num_neighbor*comm_dt;
cikf.t = cikf.t+used_time;