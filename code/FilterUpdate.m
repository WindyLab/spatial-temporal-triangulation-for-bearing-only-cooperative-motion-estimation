function filters = FilterUpdate(use_truth_agent_p,num_agent,num_neighbor, link_neighbor,params,agent_state,g_measurement,p_measurement,g_rate_measurement,filters)
if use_truth_agent_p
    filters.ckf = CKFUpdate(num_agent,params.ckf,agent_state.p,agent_state.v,g_measurement,g_rate_measurement,filters.ckf);
    filters.stt = STTUpdate(num_agent,num_neighbor,params.stt,link_neighbor,agent_state.p,g_measurement,filters.stt);
    filters.castt = CASTTUpdate(num_agent,num_neighbor,params.castt,link_neighbor,agent_state.p,g_measurement,filters.castt);
else
    filters.ckf = CKFUpdate(num_agent,params.ckf,p_measurement,agent_state.v,g_measurement,g_rate_measurement,filters.ckf);
    filters.stt = STTUpdate(num_agent,num_neighbor,params.stt,link_neighbor,p_measurement,g_measurement,filters.stt);
    filters.castt = CASTTUpdate(num_agent,num_neighbor,params.castt,link_neighbor,p_measurement,g_measurement,filters.castt);
end

% Disabled algorithms in task-A:
% filters.cmkf = ...
% filters.cikf = ...
% filters.tkf = ...
% filters.hcmci = ...
