function target = GetTargetState(dt,total_time_step,target_motion) 
%target motion  0|static    1|constant velocity  2| 8 shape 3| square

switch target_motion
    case 0
        target_cur_p = zeros(3,1);
        target_cur_v = zeros(3,1);
        target.p = kron(target_cur_p,ones(1,total_time_step));
        target.v = kron(target_cur_v,ones(1,total_time_step));
        
    case 1
        target_cur_p = [-30,0,0]';
        target_cur_v = [3,0,0]';
        target.v = kron(target_cur_v,ones(1,total_time_step));
        for i =1:total_time_step
            target_cur_p = target_cur_p + dt*target_cur_v;
            target.p(:,i) = target_cur_p;
           
        end
    case 2
        target_cur_p = [15,0,0]';
        norm_vel = 5;
        target_cur_v = [0,norm_vel,0]';
        for i =1:total_time_step
            current_time = i*dt;
            target.v(:,i) = target_cur_v;
            target_cur_p = target_cur_p + dt*target_cur_v;
            target.p(:,i) = target_cur_p;
            target_cur_v = [-sin(current_time/10*pi),cos(current_time/10*pi),0]'*norm_vel;
        end
     case 3
        target_cur_p = [25,0,0]';
        norm_vel = 10;
        target_cur_v = [0,norm_vel,0]';
        
        for i =1:total_time_step
            current_time = i*dt;
            target.v(:,i) = target_cur_v;
            target_cur_p = target_cur_p + dt*target_cur_v;
            target.p(:,i) = target_cur_p;
            
            target_cur_v = [-sin(current_time/10*pi),cos(current_time/5*pi),0]'*norm_vel;
        end
    case 4 
        target_cur_p = [20,20,5]';
        target_cur_v = [0,-4,0]';
        R = [0,1,0;-1,0,0;0,0,1];
        for i =1:total_time_step
            if mod(i,5/dt)==0
               target_cur_v = R*target_cur_v;
            end
            target.v(:,i) = target_cur_v;
            target_cur_p = target_cur_p + dt*target_cur_v;
            target.p(:,i) = target_cur_p;
            
        end
end


