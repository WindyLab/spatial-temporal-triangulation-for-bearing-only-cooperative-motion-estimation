clc
clear

dt = 0.1;
t_step = 100;

cv_motion_A = kron([1,dt;0,1],eye(3));
ca_motion_A = kron([1,dt,0.5*dt^2;0,1,dt;0,0,1],eye(3));
NDDI_motion_A =  kron([1,dt;0,1],eye(3));

motion.cv.x =  [zeros(3,1);10;2;3];
motion.ca.x =  [zeros(3,1);1;-1;3;0.1;-1;-0.1];
motion.NDDI.x =  [zeros(3,1);1;-1;0] ;

figure(1)
for fig_id=1:12
    subplot(2,6,fig_id)
for i = 1:t_step
    motion.cv.x(:,i+1) =cv_motion_A* motion.cv.x(:,i);
    motion.ca.x(:,i+1) =ca_motion_A* motion.ca.x(:,i);
    motion.NDDI.x(:,i+1) =NDDI_motion_A* motion.NDDI.x(:,i)+ [zeros(3,1);randn(3,1)*20]*dt;
end
plot3(motion.NDDI.x(1,:),motion.NDDI.x(2,:),motion.NDDI.x(3,:),'LineWidth',2);
grid on
axis equal
% legend('cv model','ca model','NDDI model','Location','best');
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');

set(gca,'FontName','Times New Roman',"FontSize",10)
end



% hold off
% plot3(motion.cv.x(1,:),motion.cv.x(2,:),motion.cv.x(3,:),'LineWidth',2);
% hold on
% plot3(motion.ca.x(1,:),motion.ca.x(2,:),motion.ca.x(3,:),'LineWidth',2);
% 




