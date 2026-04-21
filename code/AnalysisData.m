function [error_struct,mean_error] = AnalysisData(t_secq,num_sim,num_agents,data_save,target)

for i = 1:num_sim
% ckf
delta_p_temp = target.p - data_save(i).ckf.x(1:3,2:end);
delta_v_temp = target.v - data_save(i).ckf.x(4:6,2:end);
error_struct.ckf.p(i,:) = sqrt(sum(delta_p_temp.*delta_p_temp,1));
error_struct.ckf.v(i,:) = sqrt(sum(delta_v_temp.*delta_v_temp,1));

% stt
temp_p = target.p - data_save(i).stt.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).stt.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).stt.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).stt.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p + sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v + sqrt(sum(temp_v.*temp_v,1));
end
error_struct.stt.p(i,:) = sum_est_p/num_agents;
error_struct.stt.v(i,:) = sum_est_v/num_agents;

% castt
temp_p = target.p - data_save(i).castt.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).castt.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).castt.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).castt.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p + sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v + sqrt(sum(temp_v.*temp_v,1));
end
error_struct.castt.p(i,:) = sum_est_p/num_agents;
error_struct.castt.v(i,:) = sum_est_v/num_agents;
end

error_struct.ckf.mean_p_traj = mean(error_struct.ckf.p,1);
error_struct.stt.mean_p_traj = mean(error_struct.stt.p,1);
error_struct.castt.mean_p_traj = mean(error_struct.castt.p,1);

error_struct.ckf.mean_v_traj = mean(error_struct.ckf.v,1);
error_struct.stt.mean_v_traj = mean(error_struct.stt.v,1);
error_struct.castt.mean_v_traj = mean(error_struct.castt.v,1);

mean_error(1,1) = mean(error_struct.ckf.mean_p_traj);
mean_error(2,1) = mean(error_struct.stt.mean_p_traj);
mean_error(3,1) = mean(error_struct.castt.mean_p_traj);

mean_error(1,2) = mean(error_struct.ckf.mean_v_traj);
mean_error(2,2) = mean(error_struct.stt.mean_v_traj);
mean_error(3,2) = mean(error_struct.castt.mean_v_traj);

figure(1)
hold off
plot(t_secq,error_struct.ckf.mean_p_traj,'b','LineWidth',3);
hold on
plot(t_secq,error_struct.stt.mean_p_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
plot(t_secq,error_struct.castt.mean_p_traj,'--','color',[0.15,0.59,0.38],'LineWidth',3);
grid on
xtxt = xlabel('$$t$$ (s)','FontSize',4);
set(xtxt,'Interpreter','latex');
yt = ylabel('position error (m)','Interpreter','latex','FontSize',25);
set(yt,'Interpreter','latex');
legend('CKF','STT','confidence-aware-STT','Location','best');
set(gca,'FontName','Times New Roman','FontSize',20)

figure(2)
hold off
plot(t_secq,error_struct.ckf.mean_v_traj,'b','LineWidth',3);
hold on
plot(t_secq,error_struct.stt.mean_v_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
plot(t_secq,error_struct.castt.mean_v_traj,'--','color',[0.15,0.59,0.38],'LineWidth',3);
grid on
xtxt = xlabel('$$t$$ (s)','FontSize',4);
set(xtxt,'Interpreter','latex');
yt = ylabel('velocity error (m/s)','Interpreter','latex','FontSize',25);
set(yt,'Interpreter','latex');
legend('CKF','STT','confidence-aware-STT','Location','best');
set(gca,'FontName','Times New Roman','FontSize',20)

error_struct.box_graph_p(:,1) = mean(error_struct.ckf.p,2)';
error_struct.box_graph_p(:,2) = mean(error_struct.stt.p,2)';
error_struct.box_graph_p(:,3) = mean(error_struct.castt.p,2)';

error_struct.box_graph_v(:,1) = mean(error_struct.ckf.v,2)';
error_struct.box_graph_v(:,2) = mean(error_struct.stt.v,2)';
error_struct.box_graph_v(:,3) = mean(error_struct.castt.v,2)';

sum_t = zeros(3,1);
for i = 1:num_sim
    sum_t = sum_t + [data_save(i).ckf.t;
                     data_save(i).stt.t;
                     data_save(i).castt.t];
end
sum_t = sum_t/num_sim

figure(6)
box = error_struct.box_graph_p;
G = boxplot(box,'Notch','marker','Labels',{'CKF','STT','confidence-aware-STT'},'Widths',0.6);
yt = ylabel('position error (m)','Interpreter','latex','FontSize',25);
set(yt,'Interpreter','latex');
set(G,'LineWidth',2);
set(gca,'FontName','Times New Roman','FontSize',20);
grid on

figure(7)
box = error_struct.box_graph_v;
G = boxplot(box,'Notch','marker','Labels',{'CKF','STT','confidence-aware-STT'});
set(G,'LineWidth',2);
yt = ylabel('velocity error (m/s)','Interpreter','latex','FontSize',25);
set(yt,'Interpreter','latex');
set(gca,'FontName','Times New Roman','FontSize',20);
grid on
