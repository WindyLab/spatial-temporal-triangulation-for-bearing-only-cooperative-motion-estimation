function agent = GetAgentState(dt,total_time_step,num_neighbor,num_agent,env_range,is_static_obseved_position,is_periodic_connection) % observer number, the environment range

% agent.p = [-38.1302617970429
% 1.29019014522883
% 20.4992506381569
% -26.2969701903255
% 36.8087458327444
% 21.9356140209724
% -16.2311487966690
% -20.4102571636404
% -23.2344595697100
% 7.70143228565058
% -2.59918871897510
% 4.07667026022094
% 41.7744936873145
% -8.60486306331709
% -9.01197474835092
% 5.40734517845133
% -33.7173776467348
% -8.93813995692834];

agent.p = [-26.7479536001115	5.97879069802922	-12.9122474989695	-26.8115470806662	34.4187346072475	-7.47023718162715	22.2767825133615	37.6446816650379	-34.0130100417117	36.9621587227301 -6.41656697013157	-19.1130898217642	15.9560085427048	10.8019577943791	-16.6926655026746	-23.7609823031385	11.9758825276354	38.9630631674099	-37.5803918901555	-7.84877427678396 13.7164615056577	0.143563320371038	18.2062509819998	0.365099287400428	-9.04026768641223	-15.4256764188321	6.67564864265168	-12.6658032071978	-5.74253008029820	-5.08259320434903]';

% agent.p = reshape((rand(3,num_agent)-0.5).*env_range,num_agent*3,1);
if is_static_obseved_position
    v= zeros(3,num_agent);
else
    v = (rand(3,num_agent)-0.5);
    v(3,:) = 0;
    v = v./sqrt(sum(v.*v,1))*7;
end
agent.v = reshape(v,num_agent*3,1);


for i = 1:num_agent
    omega = (rand(1)-0.5);
    if omega>0
        omega = max(0.3,omega);
    else
        omega = min(-0.3,omega);
    end
    R = eul2rotm([0,0,dt*omega*1],'XYZ');
    vel_i = v(:,i);
    position_i = agent.p(i*3-2:i*3,1);
    for j = 1:total_time_step
        vel_i = R*vel_i;
        agent.v(i*3-2:i*3,j) = vel_i;
        position_i = position_i + dt*vel_i;
        agent.p(i*3-2:i*3,j) = position_i;
        agent_i_p = agent.p(:,i);
    end
end


switch is_periodic_connection
    case 1
    secq_sum(:,1) = get_full_link_undirect_graph(num_agent);
    secq_sum(:,2) = get_no_full_link_undirect_graph1(num_agent);
    secq_sum(:,3) = get_no_full_link_undirect_graph2(num_agent);
    
    secq_sum(:,4) = get_no_full_link_undirect_graph3(num_agent);
    
    agent.neighbor_secq = kron(ones(1,total_time_step/4),secq_sum);
    case 2
    secq_sum(:,1) =reshape([1:num_agent;zeros(num_agent-1,num_agent)],num_agent*num_agent,1);
%     secq_sum(:,3) =reshape([randperm(10);zeros(num_agent-1,num_agent)],num_agent*num_agent,1);
%     secq_sum(:,2) =  get_full_link_undirect_graph(num_agent);
    secq_sum(:,2) =  get_full_link_undirect_graph(num_agent);
        secq_sum(:,3) =reshape([1:num_agent;zeros(num_agent-1,num_agent)],num_agent*num_agent,1);

%     secq_sum(:,4) =reshape([randperm(10);zeros(num_agent-1,num_agent)],num_agent*num_agent,1);
    secq_sum(:,4) =  get_full_link_undirect_graph(num_agent);
    agent.neighbor_secq = kron(ones(1,total_time_step/4),secq_sum);
    case 0
    secq_sum = [];
    for i = 1:num_agent
        dis = agent.p;
        for j = 1:3
            dis(j:3:end,:) = agent.p(j:3:end,:) - agent.p((i-1)*3+j,:);
        end
        dis = dis.*dis;
        for j = 1:num_agent
            r(j,:) = sqrt(sum(dis(j*3-2:j*3,:),1));
        end
        [~,secq] = sort(r);
        secq_sum = [secq_sum;secq];
    end
    agent.neighbor_secq = secq_sum;
end

end

function secq_sum = get_full_link_undirect_graph(num_agent) % only for 10 agents with three neighbors
secq_sum= [1,8,9,10,ones(1,6)*1;
           2,4,6,10,ones(1,6)*2;
           3,4,5,9,ones(1,6)*3;
           4,2,3,6,ones(1,6)*4;
           5,3,7,8,ones(1,6)*5;
           6,4,2,8,ones(1,6)*6;
           7,5,9,10,ones(1,6)*7;
           8,1,5,6,ones(1,6)*8;
           9,1,3,7,ones(1,6)*9;
           10,1,2,7,ones(1,6)*10]';
secq_sum = reshape(secq_sum,num_agent*num_agent,1);
end

function secq_sum = get_no_full_link_undirect_graph1(num_agent) % only for 10 agents with three neighbors
secq_sum= [1,8,9,10,ones(1,6)*1;
           2,3,5,7,ones(1,6)*2;
           3,2,4,7,ones(1,6)*3;
           4,3,5,6,ones(1,6)*4;
           5,2,4,6,ones(1,6)*5;
           6,4,5,7,ones(1,6)*6;
           7,5,9,10,ones(1,6)*7;
           8,1,9,10,ones(1,6)*8;
           9,1,8,10,ones(1,6)*9;
           10,1,8,9,ones(1,6)*10]';
secq_sum = reshape(secq_sum,num_agent*num_agent,1);
end

function secq_sum = get_no_full_link_undirect_graph2(num_agent) % only for 10 agents with three neighbors
secq_sum= [1,8,9,10,ones(1,6)*1;
           2,3,4,2,ones(1,6)*2;
           3,2,4,3,ones(1,6)*3;
           4,2,3,4,ones(1,6)*4;
           5,6,7,5,ones(1,6)*5;
           6,5,7,6,ones(1,6)*6;
           7,5,6,7,ones(1,6)*7;
           8,1,9,10,ones(1,6)*8;
           9,1,8,10,ones(1,6)*9;
           10,1,8,9,ones(1,6)*10]';
secq_sum = reshape(secq_sum,num_agent*num_agent,1);
end
% function secq_sum = get_no_full_link_undirect_graph3(num_agent) % only for 10 agents with three neighbors
% secq_sum= ones(1,10).*[1:10]';
% secq_sum = reshape(secq_sum,num_agent*num_agent,1);
% end

function secq_sum = get_no_full_link_undirect_graph3(num_agent) % only for 10 agents with three neighbors
secq_sum= [ones(1,10)*1;
           2,3,2,2,ones(1,6)*2;
           3,2,4,3,ones(1,6)*3;
           4,3,4,4,ones(1,6)*4;
           5,6,5,5,ones(1,6)*5;
           6,5,7,6,ones(1,6)*6;
           7,6,7,7,ones(1,6)*7;
           8,9,8,8,ones(1,6)*8;
           9,8,10,9,ones(1,6)*9;
           10,9,10,10,ones(1,6)*10]';
secq_sum = reshape(secq_sum,num_agent*num_agent,1);
end



