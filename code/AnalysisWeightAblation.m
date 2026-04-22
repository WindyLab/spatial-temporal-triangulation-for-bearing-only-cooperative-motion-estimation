function ablation_result = AnalysisWeightAblation(t_secq,num_sim,num_agents,data_save_cfg,castt_label_list,target)

num_cfg = length(data_save_cfg);

% use cfg-1 (default) for CKF/STT references
[ref_error_struct,~] = AnalysisData(t_secq,num_sim,num_agents,data_save_cfg{1},target);
ablation_result.reference = ref_error_struct;

for cfg_id = 1:num_cfg
    for i = 1:num_sim
        % castt
        temp_p = target.p - data_save_cfg{cfg_id}(i).castt.agent(1).x(1:3,2:end);
        temp_v = target.v - data_save_cfg{cfg_id}(i).castt.agent(1).x(4:6,2:end);
        sum_est_p = sqrt(sum(temp_p.*temp_p,1));
        sum_est_v = sqrt(sum(temp_v.*temp_v,1));
        for j = 2:num_agents
            temp_p = target.p - data_save_cfg{cfg_id}(i).castt.agent(j).x(1:3,2:end);
            temp_v = target.v - data_save_cfg{cfg_id}(i).castt.agent(j).x(4:6,2:end);
            sum_est_p = sum_est_p + sqrt(sum(temp_p.*temp_p,1));
            sum_est_v = sum_est_v + sqrt(sum(temp_v.*temp_v,1));
        end
        ablation_result.castt(cfg_id).p(i,:) = sum_est_p/num_agents;
        ablation_result.castt(cfg_id).v(i,:) = sum_est_v/num_agents;
    end

    ablation_result.castt(cfg_id).mean_p_traj = mean(ablation_result.castt(cfg_id).p,1);
    ablation_result.castt(cfg_id).mean_v_traj = mean(ablation_result.castt(cfg_id).v,1);
    ablation_result.castt(cfg_id).box_graph_p = mean(ablation_result.castt(cfg_id).p,2)';
    ablation_result.castt(cfg_id).box_graph_v = mean(ablation_result.castt(cfg_id).v,2)';
    ablation_result.castt(cfg_id).mean_error_p = mean(ablation_result.castt(cfg_id).mean_p_traj);
    ablation_result.castt(cfg_id).mean_error_v = mean(ablation_result.castt(cfg_id).mean_v_traj);

    sum_t = 0;
    for i = 1:num_sim
        sum_t = sum_t + data_save_cfg{cfg_id}(i).castt.t;
    end
    ablation_result.castt(cfg_id).mean_t = sum_t/num_sim;
end

% trajectory: position error
figure(11)
hold off
plot(t_secq,ablation_result.reference.ckf.mean_p_traj,'b','LineWidth',3);
hold on
plot(t_secq,ablation_result.reference.stt.mean_p_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
for cfg_id = 1:num_cfg
    plot(t_secq,ablation_result.castt(cfg_id).mean_p_traj,'LineWidth',2.5);
end
grid on
xlabel('$$t$$ (s)','Interpreter','latex');
ylabel('position error (m)','Interpreter','latex');
legend_entries = [{'CKF','STT'},cellstr(castt_label_list)'];
legend(legend_entries{:},'Location','best');
set(gca,'FontName','Times New Roman','FontSize',20)

% trajectory: velocity error
figure(12)
hold off
plot(t_secq,ablation_result.reference.ckf.mean_v_traj,'b','LineWidth',3);
hold on
plot(t_secq,ablation_result.reference.stt.mean_v_traj,'color',[0.90,0.40,0.20],'LineWidth',3);
for cfg_id = 1:num_cfg
    plot(t_secq,ablation_result.castt(cfg_id).mean_v_traj,'LineWidth',2.5);
end
grid on
xlabel('$$t$$ (s)','Interpreter','latex');
ylabel('velocity error (m/s)','Interpreter','latex');
legend_entries = [{'CKF','STT'},cellstr(castt_label_list)'];
legend(legend_entries{:},'Location','best');
set(gca,'FontName','Times New Roman','FontSize',20)

% boxplot: position error
figure(13)
box_p = zeros(num_sim,num_cfg+2);
box_p(:,1) = mean(ablation_result.reference.ckf.p,2);
box_p(:,2) = mean(ablation_result.reference.stt.p,2);
for cfg_id = 1:num_cfg
    box_p(:,cfg_id+2) = ablation_result.castt(cfg_id).box_graph_p';
end
labels_p = [{'CKF','STT'},cellstr(castt_label_list)'];
G = boxplot(box_p,'Notch','marker','Labels',labels_p);
set(G,'LineWidth',2);
ylabel('position error (m)','Interpreter','latex','FontSize',25);
set(gca,'FontName','Times New Roman','FontSize',20);
grid on

% boxplot: velocity error
figure(14)
box_v = zeros(num_sim,num_cfg+2);
box_v(:,1) = mean(ablation_result.reference.ckf.v,2);
box_v(:,2) = mean(ablation_result.reference.stt.v,2);
for cfg_id = 1:num_cfg
    box_v(:,cfg_id+2) = ablation_result.castt(cfg_id).box_graph_v';
end
labels_v = [{'CKF','STT'},cellstr(castt_label_list)'];
G = boxplot(box_v,'Notch','marker','Labels',labels_v);
set(G,'LineWidth',2);
ylabel('velocity error (m/s)','Interpreter','latex','FontSize',25);
set(gca,'FontName','Times New Roman','FontSize',20);
grid on

% runtime bar chart
figure(15)
runtime_vec = zeros(1,num_cfg+2);
runtime_vec(1) = mean([data_save_cfg{1}.ckf].t);
runtime_vec(2) = mean([data_save_cfg{1}.stt].t);
for cfg_id = 1:num_cfg
    runtime_vec(cfg_id+2) = ablation_result.castt(cfg_id).mean_t;
end
bar(runtime_vec);
set(gca,'XTickLabel',[{'CKF','STT'},cellstr(castt_label_list)'],'FontName','Times New Roman','FontSize',16);
ylabel('mean runtime (s)');
grid on
