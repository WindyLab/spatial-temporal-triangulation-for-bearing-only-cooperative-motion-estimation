function filters = IninFilter(num_agent,p)

filters.ckf.x = [mean(p,2);zeros(3,1)];
filters.ckf.P = eye(6);
filters.ckf.t = 0;
filters.cikf.t = 0;
filters.cmkf.t = 0;
filters.hcmci.t = 0;
filters.stt.t = 0;
filters.tkf.t = 0;
filters.sttr.t = 0;
% initial distributed filters
for i = 1:num_agent
filters.cikf.agent(i).x = [p(:,i);zeros(3,1)];
filters.cmkf.agent(i).x =  [p(:,i);zeros(3,1)];
filters.hcmci.agent(i).x =  [p(:,i);zeros(3,1)];
filters.tkf.agent(i).x = [p(:,i);zeros(3,1)];
filters.stt.agent(i).x =  [p(:,i);zeros(3,1)];
filters.sttr.agent(i).x =  [p(:,i);zeros(3,1)];

filters.cikf.agent(i).P = eye(6);
filters.cmkf.agent(i).P = eye(6);
filters.hcmci.agent(i).P = eye(6);
filters.tkf.agent(i).P = eye(6);
filters.stt.agent(i).M = eye(6);
filters.sttr.agent(i).M = eye(6);

end
