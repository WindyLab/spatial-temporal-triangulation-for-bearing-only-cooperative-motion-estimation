clc
clear
load("agent_location_data.mat")
addpath("./Filters/");
num_sim = 10; % sim number
env_r = [80,80,40]';    %the range of the environment
num_agent = 10; % observer number
num_neighbor = 3; % observer neighbor
is_same_obseved_position = 1; % is the same position
is_static_obseved_position = 1; % is static position
is_periodic_connection = 0;% 0|nomral   1|is periodic connection
is_used_agent_truth_p = 1; % 1| use the agent truth position,  0| the agent position with noise
Noise_model = 0; % 0|generation algorithm optimazation 1|discrete time 2|continus-time
target_motion = 2; % 0|stati c    1| constant velocity 2|circle shape 3| 8 shape 4| square
comm_cost_time = 0; % the data exchange time cost  0.00093s in reality

total_time = 20;
dt = 0.1;
total_time_step = total_time/dt;

position_noise = 0.1;
bearing_noise = 0.1;
bearing_rate_noise = 0.01;
camera_angluar_rate_noise = 0.01;

filters_params = GetParams(Noise_model,comm_cost_time,dt,bearing_noise,max(camera_angluar_rate_noise,bearing_rate_noise));

% get original data
if is_same_obseved_position
    original_data(1).agent = GetAgentState(dt,total_time_step,num_neighbor,num_agent,env_r,is_static_obseved_position,is_periodic_connection);
    original_data(1).target = GetTargetState(dt,total_time_step,target_motion);

    for i = 1:num_sim
        original_data(i).agent = original_data(1).agent;
        original_data(i).target = original_data(1).target;
        original_data(i).measurement = GetOriginalData(position_noise,bearing_noise,bearing_rate_noise,camera_angluar_rate_noise,num_agent,total_time_step,original_data(i).agent,original_data(i).target);
    end
else
    for i = 1:num_sim
        original_data(i).agent = GetAgentState(dt,total_time_step,num_neighbor,num_agent,env_r,is_static_obseved_position,is_periodic_connection);
        original_data(i).target = GetTargetState(dt,total_time_step,target_motion);
        original_data(i).measurement = GetOriginalData(position_noise,bearing_noise,bearing_rate_noise,camera_angluar_rate_noise,num_agent,total_time_step,original_data(i).agent,original_data(i).target);
    end
end

PlotEnv(original_data(1),num_agent,num_neighbor,is_static_obseved_position);

pause(0.1)
for i = 1:num_sim
    measurement = original_data(i).measurement;
    filters = IninFilter(num_agent,reshape(original_data(i).agent.p(:,1),3,num_agent));
    for j = 1:total_time_step
        agent_state.p = reshape(original_data(i).agent.p(:,j),3,num_agent);
        agent_state.v = reshape(original_data(i).agent.v(:,j),3,num_agent);
        link_neighbor = reshape(original_data(i).agent.neighbor_secq(:,j),num_agent,num_agent);
        if ~isempty(find(link_neighbor==0))
            num_neighbor_temp = 0;
        else
            num_neighbor_temp=num_neighbor;
        end
        g_measurement = reshape(measurement.g(:,j),3,num_agent);
        g_rate_measurement = reshape(measurement.g_rate(:,j),3,num_agent);
        p_measurement = reshape(measurement.p(:,j),3,num_agent);
        filters = FilterUpdate(is_used_agent_truth_p,num_agent,num_neighbor_temp,link_neighbor, filters_params,agent_state,g_measurement,p_measurement,g_rate_measurement,filters);
    end
    data_save(i) = filters;
end
t_secq = dt:dt:total_time;
PlotEstTraj(num_sim,num_agent,data_save);
[error_struct,error_mean] = AnalysisData(t_secq,num_sim,num_agent,data_save,original_data(1).target);


