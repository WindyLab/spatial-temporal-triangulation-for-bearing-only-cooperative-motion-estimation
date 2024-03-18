function filters = FilterUpdate(use_truth_agent_p,num_agent,num_neighbor, link_neighbor,params,agent_state,g_measurement,p_measurement,g_rate_measurement,filters)
if use_truth_agent_p
filters.ckf = CKFUpdate(num_agent,params.ckf,agent_state.p,agent_state.v,g_measurement,g_rate_measurement,filters.ckf);
filters.cmkf = CMKFUpdate(num_agent,num_neighbor,params.cmkf,link_neighbor,agent_state.p,g_measurement,filters.cmkf);
filters.cikf = CIKFUpdate(num_agent,num_neighbor,params.cikf,link_neighbor,agent_state.p,g_measurement,filters.cikf);
filters.tkf = TKFUpdate(num_agent,num_neighbor,params.tkf,link_neighbor,agent_state.p,g_measurement,filters.tkf);
filters.hcmci = HCMCIUpdate(num_agent,num_neighbor,params.hcmci,link_neighbor,agent_state.p,g_measurement,filters.hcmci);
filters.stt =  STTUpdate(num_agent,num_neighbor,params.stt,link_neighbor,agent_state.p,g_measurement,filters.stt);
else
    filters.ckf = CKFUpdate(num_agent,params.ckf,p_measurement,agent_state.v,g_measurement,g_rate_measurement,filters.ckf);
filters.cmkf = CMKFUpdate(num_agent,num_neighbor,params.cmkf,link_neighbor,p_measurement,g_measurement,filters.cmkf);
filters.cikf = CIKFUpdate(num_agent,num_neighbor,params.cikf,link_neighbor,p_measurement,g_measurement,filters.cikf);
filters.tkf = TKFUpdate(num_agent,num_neighbor,params.tkf,link_neighbor,p_measurement,g_measurement,filters.tkf);
filters.hcmci = HCMCIUpdate(num_agent,num_neighbor,params.hcmci,link_neighbor,p_measurement,g_measurement,filters.hcmci);
filters.stt =  STTUpdate(num_agent,num_neighbor,params.stt,link_neighbor,p_measurement,g_measurement,filters.stt);
end