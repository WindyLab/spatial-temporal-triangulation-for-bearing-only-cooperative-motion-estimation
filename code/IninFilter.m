function filters = IninFilter(num_agent,p)

filters.ckf.x = [mean(p,2);zeros(3,1)];
filters.ckf.P = eye(6);
filters.ckf.t = 0;
filters.stt.t = 0;
filters.castt.t = 0;

% initial distributed filters
for i = 1:num_agent
    filters.stt.agent(i).x = [p(:,i);zeros(3,1)];
    filters.castt.agent(i).x = [p(:,i);zeros(3,1)];

    filters.stt.agent(i).M = eye(6);
    filters.castt.agent(i).M = eye(6);

    % confidence-aware states for per-observer/per-time quality adaptation
    filters.castt.agent(i).q_bar = ones(num_agent,1);
    filters.castt.agent(i).n_hit = zeros(num_agent,1);
    filters.castt.agent(i).n_lost = zeros(num_agent,1);
    filters.castt.agent(i).sigma2 = ones(num_agent,1);
end
