[X,Y] = meshgrid(0.01:0.01:0.1);
% ckf_data =[];
% stt_data =[];
% sttr_data =[];
% for i = 0.01:0.01:0.1
%     for j = 0.01:0.01:0.1
%         [error_struct,error_mean] = main(i,j);
%         ckf_data = [ckf_data;error_mean(1,1:2)];
%         stt_data = [stt_data;error_mean(5,1:2)];
%         sttr_data = [sttr_data;error_mean(6,1:2)];
%     end
% end


load('20231218-sim3.mat')
stt_p = reshape(stt_data(:,1),10,10);
stt_v = reshape(stt_data(:,2),10,10);
sttr_p = reshape(sttr_data(:,1),10,10);
sttr_v = reshape(sttr_data(:,2),10,10);
figure(6)
hold off
mesh(X,Y,sttr_p,'FaceColor','none','LineWidth',2);
hold on
mesh(X,Y,stt_p,'linestyle','--','FaceColor','none','LineWidth',1);

figure(7)
hold off
mesh(X,Y,sttr_v,'FaceColor','none','LineWidth',2);
hold on
mesh(X,Y,stt_v,'linestyle','--','FaceColor','none','LineWidth',1);

load('20231218-sim3-0.05.mat')
sttr_p = reshape(sttr_data(:,1),10,10);
sttr_v = reshape(sttr_data(:,2),10,10);
stt_p = reshape(stt_data(:,1),10,10);
stt_v = reshape(stt_data(:,2),10,10);
figure(6)
mesh(X,Y,sttr_p,'FaceColor','none','LineWidth',2);
mesh(X,Y,stt_p,'linestyle','--','FaceColor','none','LineWidth',1);

figure(7)
mesh(X,Y,sttr_v,'FaceColor','none','LineWidth',2);
mesh(X,Y,stt_v,'linestyle','--','FaceColor','none','LineWidth',1);

load('20231218-sim3-0.01.mat')
sttr_p = reshape(sttr_data(:,1),10,10);
sttr_v = reshape(sttr_data(:,2),10,10);
stt_p = reshape(stt_data(:,1),10,10);
stt_v = reshape(stt_data(:,2),10,10);
figure(6)
mesh(X,Y,sttr_p,'FaceColor','none','LineWidth',2);
mesh(X,Y,stt_p,'linestyle','--','FaceColor','none','LineWidth',1);

colorbar
grid on
xtxt = xlabel('$$\sigma_{\omega_c}$$ (rad/s)','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('$$\sigma_{\mathbf{h}_c}$$ (rad/s)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
ztxt = zlabel('RMSE of $\mathbf{p}_{\rm T}$','Interpreter','latex','FontSize',25);
set(ztxt,'Interpreter','latex');
legend('STT-R $$\sigma_{\mathbf{g}}=0.1$$ rad','STT $$\sigma_{\mathbf{g}}=0.1$$ rad', ...
    'STT-R $$\sigma_{\mathbf{g}}=0.05 $$ rad ','STT $$\sigma_{\mathbf{g}}=0.05 $$ rad ', ...
    'STT-R $$\sigma_{\mathbf{g}}=0.01 $$ rad ','STT $$\sigma_{\mathbf{g}}=0.01 $$ rad', ...
    'Interpreter','latex','Numcolumns',3,'Location','best','edgecolor','none','color','none')
set(gca,'FontName','Times New Roman',"FontSize",20)
axis([-inf,inf,-inf,inf,-inf,2.1])
view(-1.047878413850977e+02,16.540497711542226);

figure(7)
mesh(X,Y,sttr_v,'FaceColor','none','LineWidth',2);
mesh(X,Y,stt_v,'linestyle','--','FaceColor','none','LineWidth',1);

colorbar
grid on
xtxt = xlabel('$$\sigma_{\omega_c}$$ (rad/s)','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('$$\sigma_{\mathbf{h}_c}$$ (rad/s)','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
ztxt = zlabel('RMSE of $\mathbf{v}_{\rm T}$','Interpreter','latex','FontSize',25);
set(ztxt,'Interpreter','latex');
legend('STT-R $$\sigma_{\mathbf{g}}=0.1$$ rad','STT $$\sigma_{\mathbf{g}}=0.1$$ rad', ...
    'STT-R $$\sigma_{\mathbf{g}}=0.05 $$ rad ','STT $$\sigma_{\mathbf{g}}=0.05 $$ rad ', ...
    'STT-R $$\sigma_{\mathbf{g}}=0.01 $$ rad ','STT $$\sigma_{\mathbf{g}}=0.01 $$ rad', ...
    'Interpreter','latex','Numcolumns',3,'Location','best','edgecolor','none','color','none')
set(gca,'FontName','Times New Roman',"FontSize",20)
axis([-inf,inf,-inf,inf,-inf,4.3])
view(-1.047878413850977e+02,16.540497711542226)
