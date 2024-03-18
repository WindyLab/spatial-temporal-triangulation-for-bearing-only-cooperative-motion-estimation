function ckf = CKFUpdate(num_agent,params,agent_p,agent_v,g_measurement,g_rate_measurement,ckf)

S = zeros(6);
y = zeros(6,1);
A = params.A;
% Q = eye(6)*params.q1;
Q = params.Q;%[eye(3)*params.q1,zeros(3);zeros(3),eye(3)*params.q2];
R1 = eye(3)*params.r1;
R2 = eye(3)*params.r2;
tic
use_rate = params.use_g_rate;
% prediction
x = ckf.x(:,end);
P = ckf.P;
x = A * x;
P = A*P*A'+num_agent*Q;
%measurements
for i = 1:num_agent
    g = g_measurement(:,i);
    g_rate = g_rate_measurement(:,i);

    position = agent_p(:,i);
    velocity = agent_v(:,i);
    
%     r = norm(position - x(1:3));
    P_g = eye(3)-g*g';
    H1 =  [P_g,zeros(3)];
    z1 =  P_g*position;
    
    H2 = [-g_rate*g',P_g];
    z2 = -g_rate*g'*position + P_g*velocity;
    
    S = S + H1'*R1^(-1)*H1 + use_rate*H2'*R2^(-1)*H2;
    y = y + H1'*R1^(-1)*z1 + use_rate* H2'*R2^(-1)*z2;

end
% correction
S = S/num_agent;
y = y/num_agent;
K = (P^(-1)+S)^(-1);
x = x+K*(y-S*x);
P = (eye(6)-K*S)*P;
%------------------------------------%
ckf.x(:,end+1) = x;
ckf.P = P;
used_time = toc;
comm_dt = params.comm_cost_time;
used_time = used_time + num_agent*comm_dt;
ckf.t = ckf.t+used_time;

