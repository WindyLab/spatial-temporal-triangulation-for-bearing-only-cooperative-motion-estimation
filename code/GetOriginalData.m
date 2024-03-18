function measurement = GetOriginalData(position_noise,bearing_noise,bearing_rate_noise,camera_angluar_rate_noise,num_agent,total_time_step,agent,target)

for i = 1:total_time_step
    target_p = target.p(:,i);
    target_v = target.v(:,i);
    g_truth = [];
    g_rate_truth = [];
    g_rate = [];
    g = [];
    for j = 1:num_agent
        
        agentj_p = agent.p(j*3-2:j*3,i);
        agentj_v = agent.v(j*3-2:j*3,i);
        
        delta_p = target_p - agentj_p;
        delta_v = target_v - agentj_v;
        r = norm(delta_p);
        g_j = delta_p/r;
        Pg_j = eye(3) - g_j*g_j';
        % add bearing noise
        rand_v = rand(3,1)-0.5;
        rand_v = rand_v/norm(rand_v);
        n_g_v = cross(g_j,rand_v);
        nu = randn(1)*bearing_noise;
        w = cos(nu/2);
        x = n_g_v(1)*sin(nu/2);
        y = n_g_v(2)*sin(nu/2);
        z = n_g_v(3)*sin(nu/2);
        x2 = x^2;
        y2 = y^2;
        z2 = z^2;
        R = [1-2*y2- 2*z2,2*x*y-2*z*w,2*x*z+2*y*w;...
            2*x*y+2*z*w,1-2*x2-2*z2,2*y*z - 2*x*w;...
            2*x*z-2*y*w , 2*y*z+2*x*w,1-w*x2-2*y2];
        g_j_noise = R*g_j;
        g_rate_j = Pg_j*delta_v/r;
         %相机模型
        angle = GetAngle(g_j);
        g_pre_j = g_j-g_rate_j*0.000000001;
        g_pre_j = g_pre_j/norm(g_pre_j);
        pre_angle = GetAngle(g_pre_j);
        angle_dot = (angle - pre_angle)/0.000000001;
        angle_dot_body = GetBodyFrameAngleDot(angle_dot,angle); % w_B
        angle_dot_body = angle_dot_body + randn(3,1)*camera_angluar_rate_noise;
        R = eul2rotm(angle','XYZ');  
        g_rate_j_noise = -Pg_j*R'*CrossProcess(angle_dot_body)*[1,randn(1,2)*bearing_rate_noise]';
%         g_rate_j_noise = Pg_j*(g_rate_j+randn(3,1)*bearing_rate_noise);
    
        g_truth = [g_truth;g_j];
        g = [g;g_j_noise];
        g_rate_truth = [g_rate_truth;g_rate_j];
        g_rate = [g_rate;g_rate_j_noise];
    end
    measurement.gtruth(:,i) = g_truth;
    measurement.g_rate_truth(:,i) = g_rate_truth; 
    measurement.g_rate(:,i) = g_rate; 
    measurement.g(:,i) = g; 
    measurement.p(:,i) = agent.p(:,i)+ randn(num_agent*3,1)*position_noise; 
    
end
end


function angle = GetAngle(g)
    psi = atan2(g(2),g(1));
    psi = -psi;
    theta = atan2(g(3),sqrt(g(1)*g(1) + g(2)*g(2)));
    angle = [0,theta,psi]';
end

function angle_dot_body = GetBodyFrameAngleDot(angle_dot,angle)
    p = angle_dot(1) - angle_dot(3)*sin(angle(2));
    q = angle_dot(2)*cos(angle(1)) + angle_dot(3)*cos(angle(2))*sin(angle(1));
    r = -angle_dot(2)*sin(angle(1)) + angle_dot(3)*cos(angle(2))*cos(angle(1));
    angle_dot_body = [p,q,r]';
end

function R_a = CrossProcess(a)
    R_a = [0,-a(3),a(2);
           a(3),0,-a(1);
           -a(2),a(1),0];
end
