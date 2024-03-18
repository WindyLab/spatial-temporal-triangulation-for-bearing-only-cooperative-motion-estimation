function [error_struct,mean_error] = AnalysisData(t_secq,num_sim,num_agents,data_save,target)

is_plot_tkf = 0;
for i = 1:num_sim
% ckf
delta_p_temp = target.p - data_save(i).ckf.x(1:3,2:end);
delta_v_temp = target.v - data_save(i).ckf.x(4:6,2:end);
error_struct.ckf.p(i,:) = sqrt(sum(delta_p_temp.*delta_p_temp,1));
error_struct.ckf.v(i,:) = sqrt(sum(delta_v_temp.*delta_v_temp,1));
% cikf
temp_p = target.p - data_save(i).cikf.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).cikf.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).cikf.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).cikf.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p +sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v +sqrt(sum(temp_v.*temp_v,1));
end
error_struct.cikf.p(i,:) = sum_est_p/num_agents;
error_struct.cikf.v(i,:) = sum_est_v/num_agents;
% cmkf
temp_p = target.p - data_save(i).cmkf.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).cmkf.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).cmkf.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).cmkf.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p +sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v +sqrt(sum(temp_v.*temp_v,1));
end
error_struct.cmkf.p(i,:) = sum_est_p/num_agents;
error_struct.cmkf.v(i,:) = sum_est_v/num_agents;
% tkf
temp_p = target.p - data_save(i).tkf.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).tkf.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).tkf.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).tkf.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p +sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v +sqrt(sum(temp_v.*temp_v,1));
end
error_struct.tkf.p(i,:) = sum_est_p/num_agents;
error_struct.tkf.v(i,:) = sum_est_v/num_agents;
%hcmci
sum_est_p = data_save(i).hcmci.agent(1).x;
for j = 2:num_agents
    sum_est_p = sum_est_p + data_save(i).hcmci.agent(j).x;
end
delta_p_temp = target.p - sum_est_p(1:3,2:end)/num_agents;
delta_v_temp = target.v - sum_est_p(4:6,2:end)/num_agents;
error_struct.hcmci.p(i,:) = sqrt(sum(delta_p_temp.*delta_p_temp,1));
error_struct.hcmci.v(i,:) = sqrt(sum(delta_v_temp.*delta_v_temp,1));

% stt
temp_p = target.p - data_save(i).stt.agent(1).x(1:3,2:end);
temp_v = target.v - data_save(i).stt.agent(1).x(4:6,2:end);
sum_est_p = sqrt(sum(temp_p.*temp_p,1));
sum_est_v = sqrt(sum(temp_v.*temp_v,1));
for j = 2:num_agents
    temp_p = target.p - data_save(i).stt.agent(j).x(1:3,2:end);
    temp_v = target.v - data_save(i).stt.agent(j).x(4:6,2:end);
    sum_est_p = sum_est_p +sqrt(sum(temp_p.*temp_p,1));
    sum_est_v = sum_est_v +sqrt(sum(temp_v.*temp_v,1));
end
error_struct.stt.p(i,:) = sum_est_p/num_agents;
error_struct.stt.v(i,:) = sum_est_v/num_agents;
end

error_struct.ckf.mean_p_traj = mean(error_struct.ckf.p,1);
error_struct.cikf.mean_p_traj = mean(error_struct.cikf.p,1);
error_struct.cmkf.mean_p_traj = mean(error_struct.cmkf.p,1);
error_struct.hcmci.mean_p_traj = mean(error_struct.hcmci.p,1);
error_struct.tkf.mean_p_traj = mean(error_struct.tkf.p,1);
error_struct.stt.mean_p_traj = mean(error_struct.stt.p,1);

error_struct.ckf.mean_v_traj = mean(error_struct.ckf.v,1);
error_struct.cikf.mean_v_traj = mean(error_struct.cikf.v,1);
error_struct.cmkf.mean_v_traj = mean(error_struct.cmkf.v,1);
error_struct.hcmci.mean_v_traj = mean(error_struct.hcmci.v,1);
error_struct.tkf.mean_v_traj = mean(error_struct.tkf.v,1);
error_struct.stt.mean_v_traj = mean(error_struct.stt.v,1);

mean_error(1,1) = mean(error_struct.ckf.mean_p_traj);
mean_error(2,1) = mean(error_struct.cikf.mean_p_traj);
mean_error(3,1)= mean(error_struct.cmkf.mean_p_traj);
mean_error(4,1) = mean(error_struct.tkf.mean_p_traj);
mean_error(5,1) = mean(error_struct.hcmci.mean_p_traj);
mean_error(6,1) = mean(error_struct.stt.mean_p_traj);

mean_error(1,2) = mean(error_struct.ckf.mean_v_traj);
mean_error(2,2) = mean(error_struct.cikf.mean_v_traj);
mean_error(3,2) = mean(error_struct.cmkf.mean_v_traj);
mean_error(4,2)= mean(error_struct.tkf.mean_v_traj);
mean_error(5,2) = mean(error_struct.hcmci.mean_v_traj);
mean_error(6,2) = mean(error_struct.stt.mean_v_traj);

figure(1)
hold off
plot(t_secq,error_struct.ckf.mean_p_traj,'b','LineWidth',3);
hold on
plot(t_secq,error_struct.cikf.mean_p_traj,'--','color',[0.15,0.59,0.38],'LineWidth',2);
plot(t_secq,error_struct.cmkf.mean_p_traj,'--','color',[0.80,0.39,0.29],'LineWidth',2);
if is_plot_tkf
plot(t_secq,error_struct.tkf.mean_p_traj,'--','color',[0.90,0.70,0.20],'LineWidth',2)
end
plot(t_secq,error_struct.hcmci.mean_p_traj,'color',[0.60,0.20,0.80],'LineWidth',2);
plot(t_secq,error_struct.stt.mean_p_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
grid on
xtxt = xlabel('$$t$$ (s)','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('position error (m)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
axis([-inf,inf,-inf,4]);
if is_plot_tkf
legend('CKF','CIKF','CMKF','two-strage KF','HCMCIKF', ...
    'STT(Ours)','Location','best');
else
legend('CKF','CIKF','CMKF','HCMCIKF', ...
    'STT(Ours)','Location','best');
end
set(gca,'FontName','Times New Roman',"FontSize",20)

figure(2)
hold off
plot(t_secq,error_struct.ckf.mean_v_traj,'b','LineWidth',3);
hold on
plot(t_secq,error_struct.cikf.mean_v_traj,'--','color',[0.15,0.59,0.38],'LineWidth',2);
plot(t_secq,error_struct.cmkf.mean_v_traj,'--','color',[0.80,0.39,0.29],'LineWidth',2);
if is_plot_tkf
plot(t_secq,error_struct.tkf.mean_v_traj,'--','color',[0.90,0.70,0.20],'LineWidth',2);
end
plot(t_secq,error_struct.hcmci.mean_v_traj,'color',[0.60,0.20,0.80],'LineWidth',2);
plot(t_secq,error_struct.stt.mean_v_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
grid on
xtxt = xlabel('$$t$$ (s)','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('velocity error (m/s)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
axis([-inf,inf,-inf,5]);
if is_plot_tkf
legend('CKF','CIKF','CMKF','two-strage KF','HCMCIKF', ...
    'STT(Ours)','Location','best');
else
legend('CKF','CIKF','CMKF','HCMCIKF', ...
    'STT(Ours)','Location','best');
end
set(gca,'FontName','Times New Roman',"FontSize",20)

error_struct.box_graph_p(:,1) = mean(error_struct.ckf.p,2)';
error_struct.box_graph_p(:,2) = mean(error_struct.cikf.p,2)';
error_struct.box_graph_p(:,3) = mean(error_struct.cmkf.p,2)';
error_struct.box_graph_p(:,4) = mean(error_struct.hcmci.p,2)';
error_struct.box_graph_p(:,5) = mean(error_struct.stt.p,2)';
error_struct.box_graph_v(:,1) = mean(error_struct.ckf.v,2)';
error_struct.box_graph_v(:,2) = mean(error_struct.cikf.v,2)';
error_struct.box_graph_v(:,3) = mean(error_struct.cmkf.v,2)';
error_struct.box_graph_v(:,4) = mean(error_struct.hcmci.v,2)';
error_struct.box_graph_v(:,5) = mean(error_struct.stt.v,2)';
sum_t = zeros(7,1);
for i = 1:num_sim
    sum_t = sum_t + [data_save(i).ckf.t;
                    data_save(i).cikf.t;
                    data_save(i).cmkf.t;
                    data_save(i).tkf.t;
                    data_save(i).hcmci.t;
                    data_save(i).stt.t;
                    data_save(i).sttr.t];
end
sum_t = sum_t/num_sim
figure(6)
box = error_struct.box_graph_p;
G = boxplot(box,'Notch','marker', ...
    'Labels',{'CKF','CIKF','CMKF','HCMCI-KF','STT (Ours)'}, ...
    'Widths',0.6);
ytxt = ylabel('position error (m)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
set(G,'LineWidth',2);
set(gca,'FontName','Times New Roman','FontSize',25);
grid on
axis([-inf,inf,0,inf]);
set(gca,'FontName','Times New Roman',"FontSize",20)

figure(7)    
box = error_struct.box_graph_v;
G = boxplot(box,'Notch','marker','Labels',{'CKF','CIKF','CMKF','HCMCI-KF','STT (Ours)'});
set(G,'LineWidth',2);
ytxt = ylabel('velocity error (m/s)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
set(gca,'FontName','Times New Roman','FontSize',25);
grid on
axis([-inf,inf,0,inf]);
set(gca,'FontName','Times New Roman',"FontSize",20)

