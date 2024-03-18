% p mean vmean p_min p_max v_min v_max   
error_secq = [10:2:20];
data = [ 
    0.9195    0.4950         0         0         0         0
    1.3812    3.4528    0.1099    4.2520    0.7182    7.1314
    1.0549    1.4340    0.0870    3.1396    0.8542    2.1344
    0.9073    0.5336         0         0         0         0
    1.4214    4.3548    0.1144    4.2290    1.3697    7.9717
    1.0540    1.9150    0.0906    3.0702    1.2763    2.6223
    0.9051    0.5952         0         0         0         0
    1.5420    5.4501    0.1273    4.6167    2.0764    9.2994
    1.1202    2.4936    0.0907    3.3623    1.7857    3.2566
    0.9260    0.6927         0         0         0         0
    1.7344    6.9118    0.1562    5.0622    3.1417   11.0530
    1.2852    3.2509    0.1140    3.8178    2.4711    4.1462
    0.9976    0.8218         0         0         0         0
    1.9788    8.7690    0.1829    5.7245    4.6375   13.3126
    1.5783    4.3144    0.1478    4.4946    3.3960    5.3932
    1.0873    1.0045         0         0         0         0
    2.1737   11.0382    0.2389    5.9004    6.6512   15.5663
    1.6719    5.6508    0.1825    4.4751    4.6611    6.7596];
figure(3)
hold off
G(1) = plot(error_secq,data(1:3:end,1),'black','LineWidth',2);
hold on
G(2) = plot(error_secq,data(2:3:end,1),'color',[0.60,0.20,0.80],'LineWidth',2);
G(3) = fill([error_secq,error_secq(end:-1:1)],[data(2:3:end,3);data((end-1):-3:1,4)],[0.60,0.20,0.80],'FaceAlpha',0.3,'EdgeColor','none');
G(4) = plot(error_secq,data(3:3:end,1),'color',[0.90,0.40,0.20],'LineWidth',2);
G(5) = fill([error_secq,error_secq(end:-1:1)],[data(3:3:end,3);data(end:-3:1,4)],[0.90,0.40,0.20],'FaceAlpha',0.3,'EdgeColor','none');
grid on
legend(G,'CKF','STT(Previous)','99% error bounds of STT','STT-R(Ours)','99% error bounds of STT-R', ...
    'Numcolumns',2,'Location','best','edgecolor','none','color','none')
axis([-inf,inf,0,10])
xtxt = xlabel('$$\mathbf{v}_{\rm T}~(m/s)$$','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('RMSE of $$\mathbf{p}_{\rm T}$$','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
set(gca,'FontName','Times New Roman',"FontSize",20)

figure(4)
hold off
G(1) = plot(error_secq,data(1:3:end,2),'black','LineWidth',2);
hold on
G(2) = plot(error_secq,data(2:3:end,2),'color',[0.60,0.20,0.80],'LineWidth',2);
G(3) = fill([error_secq,error_secq(end:-1:1)],[data(2:3:end,5);data((end-1):-3:1,6)],[0.60,0.20,0.80],'FaceAlpha',0.3,'EdgeColor','none');
G(4) = plot(error_secq,data(3:3:end,2),'color',[0.90,0.40,0.20],'LineWidth',2);
G(5) = fill([error_secq,error_secq(end:-1:1)],[data(3:3:end,5);data(end:-3:1,6)],[0.90,0.40,0.20],'FaceAlpha',0.3,'EdgeColor','none');
grid on

% legend(G,'CKF','STT(Previous)','99% error bounds of STT','STT-R(Ours)','99% error bounds of STT-R', ...
%     'Numcolumns',2,'Location','best','edgecolor','none','color','none')
axis([-inf,inf,0,20])
xtxt = xlabel('$$\mathbf{v}_{\rm T}~(m/s)$$','FontSize',4);
set(xtxt,'Interpreter','latex');
ytxt = ylabel('RMSE of $$\mathbf{v}_{\rm T}$$','Interpreter','latex','FontSize',25);
set(ytxt,'Interpreter','latex');
set(gca,'FontName','Times New Roman',"FontSize",20)
