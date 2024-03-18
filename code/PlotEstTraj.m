function PlotEstTraj(num_sim,num_agent,data_save)
analysis_stt = 0;

delta_width = 0.4;
plot_width_1 = 0.38;
plot_hight = 0.4;
delta_h = 0.45;
subplot_position = [0*delta_width+0.1,1*0.15+delta_h,plot_width_1,plot_hight;
                    1*delta_width+0.1,1*0.15+delta_h,plot_width_1,plot_hight; 
                    0.1,              0.15,          plot_width_1,plot_hight;
                    1*delta_width+0.1,0.15,          plot_width_1,plot_hight;                   
                    2*delta_width+0.1,delta_h,plot_width_1,plot_hight;
                    5*delta_width+0.1,delta_h,plot_width_1,plot_hight];


est_traj_mean = data_save(1);

for i = 2:num_sim
    est_traj_mean.ckf.x = est_traj_mean.ckf.x + data_save(i).ckf.x;
    for j = 1:num_agent
    est_traj_mean.cikf.agent(j).x = est_traj_mean.cikf.agent(j).x + data_save(i).cikf.agent(j).x;
    est_traj_mean.cmkf.agent(j).x = est_traj_mean.cmkf.agent(j).x + data_save(i).cmkf.agent(j).x;
    est_traj_mean.hcmci.agent(j).x = est_traj_mean.hcmci.agent(j).x + data_save(i).hcmci.agent(j).x;
    est_traj_mean.stt.agent(j).x = est_traj_mean.stt.agent(j).x + data_save(i).stt.agent(j).x;
    est_traj_mean.sttr.agent(j).x = est_traj_mean.sttr.agent(j).x + data_save(i).sttr.agent(j).x;
    end
end

est_traj_mean.ckf.x = est_traj_mean.ckf.x/num_sim;
for i = 1:num_agent
    est_traj_mean.cikf.agent(i).x = est_traj_mean.cikf.agent(i).x/num_sim;
    est_traj_mean.cmkf.agent(i).x = est_traj_mean.cmkf.agent(i).x/num_sim;
    est_traj_mean.hcmci.agent(i).x = est_traj_mean.hcmci.agent(i).x/num_sim;
    est_traj_mean.stt.agent(i).x = est_traj_mean.stt.agent(i).x/num_sim;
    est_traj_mean.sttr.agent(i).x = est_traj_mean.sttr.agent(i).x/num_sim;
end
figure(5)
if analysis_stt
    pause(0.1);
else
    % ckf mean traj
    subplot('position',subplot_position(2,:));
    hold on
    G(1) = plot3(est_traj_mean.ckf.x(1,:),est_traj_mean.ckf.x(2,:),est_traj_mean.ckf.x(3,:),'--','color',[0.60,0.20,0.80],'LineWidth',2);
    % stt mean traj
    legend(G(1),'estimation','color','none','edgecolor','none','FontSize',20,'position',[0.72377429948271,0.008799275945294,0.150960942343459,0.05641592920354])
    title('CKF','Position',[13.5,20,45])
    subplot('position',subplot_position(3,:))
    hold on
    
    for j = 1:num_agent
    plot3(est_traj_mean.stt.agent(j).x(1,:),est_traj_mean.stt.agent(j).x(2,:),est_traj_mean.stt.agent(j).x(3,:),'--','color',[0.60,0.20,0.80],'LineWidth',2);
    plot3(est_traj_mean.stt.agent(j).x(1,end),est_traj_mean.stt.agent(j).x(2,end),est_traj_mean.stt.agent(j).x(3,end),'^','color',[0.90,0.40,0.20],'LineWidth',2)
    hold on
    end
    title('STT (Previous)','Position',[13.5,20,45])
    % sttr mean traj
    subplot('position',subplot_position(4,:))
    hold on
    for j = 1:num_agent
    plot3(est_traj_mean.sttr.agent(j).x(1,:),est_traj_mean.sttr.agent(j).x(2,:),est_traj_mean.sttr.agent(j).x(3,:),'--','color',[0.60,0.20,0.80],'LineWidth',2);
    plot3(est_traj_mean.sttr.agent(j).x(1,end),est_traj_mean.sttr.agent(j).x(2,end),est_traj_mean.sttr.agent(j).x(3,end),'^','color',[0.90,0.40,0.20],'LineWidth',2);
    end
    title('STT-R (Ours)','Position',[13.5,20,45])
end

