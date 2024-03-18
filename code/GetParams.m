function filters_params = GetParams(Noise_model,comm_cost_time,dt,bearing_noise, bearing_rate_noise)
switch Noise_model
    case 0
filters_params.ckf.r2 = bearing_rate_noise^2* 2.54101;
filters_params.ckf.Q = diag([ones(1,3)*0.000325,ones(1,3)*0.000696]);
filters_params.ckf.r1 = bearing_noise^2*1.354101;
filters_params.ckf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.ckf.use_g_rate = 0;
filters_params.ckf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.cikf.r1 = bearing_noise^2*23.1375;
filters_params.cikf.Q = diag([ones(1,3)*0.8987,ones(1,3)*0.2988]);
filters_params.cikf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cikf.comm_cost_time = comm_cost_time*(6+6*3);% x,P

filters_params.cmkf.r1 = bearing_noise^2*26.5483;
filters_params.cmkf.Q =diag([ones(1,3)*0.1325,ones(1,3)*0.2390]);
filters_params.cmkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cmkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.tkf.r1 = bearing_noise^2*26.5483;
filters_params.tkf.Q = diag([ones(1,3)*0.1325,ones(1,3)*0.2390]);
filters_params.tkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.tkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.hcmci.r1 = bearing_noise^2*1.9219;
filters_params.hcmci.Q = diag([ones(1,3)*0.0542,ones(1,3)*0.0804]);
filters_params.hcmci.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.hcmci.comm_cost_time = comm_cost_time*(3+3+6+6*3);% p,g,x,P

filters_params.stt.r1 = bearing_noise^2*10;
filters_params.stt.gamma1 = 6/0.96;
filters_params.stt.gamma2 =6;
filters_params.stt.c = 2;
filters_params.stt.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.stt.comm_cost_time = comm_cost_time*(3+3+6); % p,g,x

filters_params.sttr.r1 = bearing_noise^2*10.3286341760749;
filters_params.sttr.r2 = bearing_rate_noise^2*1042.4;
filters_params.sttr.gamma1 = 6/0.9;
filters_params.sttr.gamma2 = 6;
filters_params.sttr.c1 = 2;
filters_params.sttr.c2 = 2;
filters_params.sttr.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.sttr.comm_cost_time = comm_cost_time*(3+3+3+3+6);% p,g,v,gdot,x

    case 1
filters_params.ckf.r2 = bearing_rate_noise^2* 2.54101;
filters_params.ckf.Q = kron([dt^4/4, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.ckf.r1 = bearing_noise^2*1.354101;
filters_params.ckf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.ckf.use_g_rate = 0;
filters_params.ckf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.cikf.r1 = bearing_noise^2*23.1375;
filters_params.cikf.Q = kron([dt^4/4, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.cikf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cikf.comm_cost_time = comm_cost_time*(6+6*3);% x,P

filters_params.cmkf.r1 = bearing_noise^2*26.5483;
filters_params.cmkf.Q = kron([dt^4/4, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.cmkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cmkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.tkf.r1 = bearing_noise^2*26.5483;
filters_params.tkf.Q = kron([dt^4/4, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.tkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.tkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.hcmci.r1 = bearing_noise^2*1.9219;
filters_params.hcmci.Q = kron([dt^4/4, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.hcmci.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.hcmci.comm_cost_time = comm_cost_time*(3+3+6+6*3);% p,g,x,P

filters_params.stt.r1 = bearing_noise^2*10;
filters_params.stt.gamma1 = 6/0.96;
filters_params.stt.gamma2 =6;
filters_params.stt.c = 2;
filters_params.stt.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.stt.comm_cost_time = comm_cost_time*(3+3+6); % p,g,x

filters_params.sttr.r1 = bearing_noise^2*10.3286341760749;
filters_params.sttr.r2 = bearing_rate_noise^2*1042.4;
filters_params.sttr.gamma1 = 6/0.9;
filters_params.sttr.gamma2 = 6;
filters_params.sttr.c1 = 2;
filters_params.sttr.c2 = 2;
filters_params.sttr.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.sttr.comm_cost_time = comm_cost_time*(3+3+3+3+6);% p,g,v,gdot,x
    case 2  % continuous time 
filters_params.ckf.r2 = bearing_rate_noise^2* 2.54101;
filters_params.ckf.Q = kron([dt^3/3, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.ckf.r1 = bearing_noise^2*1.354101;
filters_params.ckf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.ckf.use_g_rate = 0;
filters_params.ckf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.cikf.r1 = bearing_noise^2*23.1375;
filters_params.cikf.Q = kron([dt^3/3, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.cikf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cikf.comm_cost_time = comm_cost_time*(6+6*3);% x,P

filters_params.cmkf.r1 = bearing_noise^2*26.5483;
filters_params.cmkf.Q = kron([dt^3/3, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.cmkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.cmkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.tkf.r1 = bearing_noise^2*26.5483;
filters_params.tkf.Q = kron([dt^3/3, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.tkf.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.tkf.comm_cost_time = comm_cost_time*(3+3);% p,g

filters_params.hcmci.r1 = bearing_noise^2*1.9219;
filters_params.hcmci.Q = kron([dt^3/3, dt^2/2;dt^2/2,dt]*0.000696,eye(3));
filters_params.hcmci.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.hcmci.comm_cost_time = comm_cost_time*(3+3+6+6*3);% p,g,x,P

filters_params.stt.r1 = bearing_noise^2*10;
filters_params.stt.gamma1 = 6/0.96;
filters_params.stt.gamma2 =6;
filters_params.stt.c = 2;
filters_params.stt.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.stt.comm_cost_time = comm_cost_time*(3+3+6); % p,g,x

filters_params.sttr.r1 = bearing_noise^2*10.3286341760749;
filters_params.sttr.r2 = bearing_rate_noise^2*1042.4;
filters_params.sttr.gamma1 = 6/0.9;
filters_params.sttr.gamma2 = 6;
filters_params.sttr.c1 = 2;
filters_params.sttr.c2 = 2;
filters_params.sttr.A = [eye(3),eye(3)*dt;zeros(3),eye(3)];
filters_params.sttr.comm_cost_time = comm_cost_time*(3+3+3+3+6);% p,g,v,gdot,x
end
