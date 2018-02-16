
SET echo on
SPOOL Step0_ORACLE_Drop_Tables.log

DROP TABLE row_status_type ;
DROP TABLE enterprise_type ;
DROP TABLE enterprise ;
DROP TABLE site_type ;
DROP TABLE site_type_child ;
DROP TABLE site ;
DROP TABLE site_database ;
DROP TABLE manufacturer ;
DROP TABLE segment_type ;
DROP TABLE segment_type_child ;
DROP TABLE SEGMENT ;
DROP TABLE purchase_cond_type ;
DROP TABLE as_readiness_type ;
DROP TABLE mloc_calc_type ;
DROP TABLE segment_child ;
DROP TABLE ref_unit_type ;
DROP TABLE eng_unit_type ;
DROP TABLE eng_unit_enum ;
DROP TABLE sg_num_dat_type ;
DROP TABLE sg_chr_dat_type ;
DROP TABLE segment_num_data ;
DROP TABLE segment_chr_data ;
DROP TABLE sg_as_event_type ;
DROP TABLE segment_event ;
DROP TABLE asset_type ;
DROP TABLE asset_type_child ;
DROP TABLE model ;
DROP TABLE model_child ;
DROP TABLE as_num_dat_type ;
DROP TABLE as_chr_dat_type ;
DROP TABLE model_num_data ;
DROP TABLE model_chr_data ;
DROP TABLE asset ;
DROP TABLE asset_child ;
DROP TABLE asset_num_data ;
DROP TABLE asset_chr_data ;
DROP TABLE asset_event ;
DROP TABLE asset_on_segment ;
DROP TABLE asset_owner ;
DROP TABLE meas_loc_type ;
DROP TABLE data_source_type ;
DROP TABLE trans_type ;
DROP TABLE tr_axis_dir_type ;
DROP TABLE meas_location ;
DROP TABLE ordered_list ;
DROP TABLE meas_loc_list ;
DROP TABLE mloc_unit_list ;
DROP TABLE data_source ;
DROP TABLE transducer ;
DROP TABLE data_qual_type ;
DROP TABLE meas_event ;
DROP TABLE meas_event_assoc ;
DROP TABLE meas_event_rem ;
DROP TABLE mevent_num_data ;
DROP TABLE mevent_chr_data ;
DROP TABLE severity_level_type ;
DROP TABLE alarm_type ;
DROP TABLE num_alarm_reg ;
DROP TABLE agent_type ;
DROP TABLE AGENT ;
DROP TABLE src_detect_type ;
DROP TABLE post_scaling_type ;
DROP TABLE mevent_num_alarm ;
DROP TABLE num_al_assoc_reg ;
DROP TABLE spa_alarm_reg ;
DROP TABLE signal_proc_type ;
DROP TABLE signal_proc_blk ;
DROP TABLE sp_num_dat_type ;
DROP TABLE sp_blk_num_data ;
DROP TABLE sp_stream_type ;
DROP TABLE sp_stream ;
DROP TABLE sp_stream_block ;
DROP TABLE average_type ;
DROP TABLE ave_weight_type ;
DROP TABLE ave_synch_type ;
DROP TABLE sp_ampl_data ;
DROP TABLE sp_ampl_alarm ;
DROP TABLE spa_al_assoc_reg ;
DROP TABLE window_type ;
DROP TABLE sp_fft_data ;
DROP TABLE sp_time_data ;
DROP TABLE sp_cpb_data ;
DROP TABLE sp_ampl_setup ;
DROP TABLE sp_fft_setup ;
DROP TABLE sp_time_setup ;
DROP TABLE sp_cpb_setup ;
DROP TABLE mloc_ulist_sp_ampl ;
DROP TABLE mloc_ulist_sp_fft ;
DROP TABLE mloc_ulist_sp_time ;
DROP TABLE mloc_ulist_sp_cpb ;
DROP TABLE mim_tech_type ;
DROP TABLE mim_support_type ;
DROP TABLE mim_data_cat_type ;
DROP TABLE mim_func_type ;
DROP TABLE mim_access_type ;
DROP TABLE mim_interface_type ;
DROP TABLE network_type ;
DROP TABLE event_type_child ;
DROP TABLE sample_test_type ;
DROP TABLE sample_ndata_type ;
DROP TABLE sample_cdata_type ;
DROP TABLE test_result_ntype ;
DROP TABLE test_result_ctype ;
DROP TABLE test_result_btype ;
DROP TABLE blob_data_type ;
DROP TABLE blob_content_type ;
DROP TABLE mevent_blob_type ;
DROP TABLE highlight_type ;
DROP TABLE agent_role_type ;
DROP TABLE ev_num_data_type ;
DROP TABLE health_level_type ;
DROP TABLE priority_level_type ;
DROP TABLE work_manage_type ;
DROP TABLE work_task_type ;
DROP TABLE wtask_type_child ;
DROP TABLE change_patt_type ;
DROP TABLE work_audit_type ;
DROP TABLE work_num_data_type ;
DROP TABLE work_chr_data_type ;
DROP TABLE solution_pack_type ;
DROP TABLE network ;
DROP TABLE sg_network_connect ;
DROP TABLE as_network_connect ;
DROP TABLE agent_role ;
DROP TABLE agent_role_with_agent ;
DROP TABLE mloc_test_alrm_rg ;
DROP TABLE meas_sample ;
DROP TABLE meas_sample_child ;
DROP TABLE sample_num_data ;
DROP TABLE sample_chr_data ;
DROP TABLE sample_remark ;
DROP TABLE meas_sample_test ;
DROP TABLE test_num_results ;
DROP TABLE test_chr_results ;
DROP TABLE test_remark ;
DROP TABLE test_histogram ;
DROP TABLE test_nres_alarm ;
DROP TABLE test_al_assoc_reg ;
DROP TABLE test_blob_results ;
DROP TABLE test_bres_alarm ;
DROP TABLE sg_type_blob_data ;
DROP TABLE segment_blob_data ;
DROP TABLE model_blob_data ;
DROP TABLE as_type_blob_data ;
DROP TABLE asset_blob_data ;
DROP TABLE olist_blob_data ;
DROP TABLE mevent_blob_data ;
DROP TABLE blob_grid_data ;
DROP TABLE blob_alarm ;
DROP TABLE blob_area_alarm ;
DROP TABLE segment_function ;
DROP TABLE asset_function ;
DROP TABLE sg_type_function ;
DROP TABLE as_type_function ;
DROP TABLE model_function ;
DROP TABLE sg_ev_sg_func_link ;
DROP TABLE as_ev_as_func_link ;
DROP TABLE sg_event_num_data ;
DROP TABLE as_event_num_data ;
DROP TABLE sg_ev_meas_event ;
DROP TABLE as_ev_meas_event ;
DROP TABLE segment_event_link ;
DROP TABLE asset_event_link ;
DROP TABLE sg_hyp_event ;
DROP TABLE as_hyp_event ;
DROP TABLE sg_typ_hyp_event ;
DROP TABLE as_typ_hyp_event ;
DROP TABLE model_hyp_event ;
DROP TABLE sg_hyp_event_link ;
DROP TABLE as_hyp_event_link ;
DROP TABLE sg_typ_hyp_ev_link ;
DROP TABLE as_typ_hyp_ev_link ;
DROP TABLE model_hyp_ev_link ;
DROP TABLE sg_hyp_ev_num_data ;
DROP TABLE as_hyp_ev_num_data ;
DROP TABLE sg_typ_hyp_ev_num_data ;
DROP TABLE as_typ_hyp_ev_num_data ;
DROP TABLE model_hyp_ev_num_data ;
DROP TABLE sg_hyp_ev_sg_func ;
DROP TABLE as_hyp_ev_as_func ;
DROP TABLE sg_typ_hyp_ev_func ;
DROP TABLE as_typ_hyp_ev_func ;
DROP TABLE model_hyp_ev_func ;
DROP TABLE sg_proposed_event ;
DROP TABLE as_proposed_event ;
DROP TABLE sg_prop_ev_link ;
DROP TABLE as_prop_ev_link ;
DROP TABLE sg_prop_ev_ndat ;
DROP TABLE as_prop_ev_ndat ;
DROP TABLE sg_prop_ev_sg_func ;
DROP TABLE as_prop_ev_as_func ;
DROP TABLE sg_prop_ev_hyp_ev ;
DROP TABLE as_prop_ev_hyp_ev ;
DROP TABLE sg_prop_ev_sg_ev ;
DROP TABLE as_prop_ev_as_ev ;
DROP TABLE sg_prop_ev_meas_ev ;
DROP TABLE as_prop_ev_meas_ev ;
DROP TABLE segment_health ;
DROP TABLE asset_health ;
DROP TABLE sg_health_sg_event ;
DROP TABLE as_health_as_event ;
DROP TABLE sg_health_sg_prop_ev ;
DROP TABLE as_health_as_prop_ev ;
DROP TABLE sg_remaining_life ;
DROP TABLE as_remaining_life ;
DROP TABLE sg_recommendation ;
DROP TABLE as_recommendation ;
DROP TABLE ol_recommendation ;
DROP TABLE sg_type_recomm ;
DROP TABLE as_type_recomm ;
DROP TABLE model_recomm ;
DROP TABLE sg_rec_remark ;
DROP TABLE as_rec_remark ;
DROP TABLE ol_rec_remark ;
DROP TABLE sg_type_rec_remark ;
DROP TABLE model_rec_remark ;
DROP TABLE sg_rec_blob ;
DROP TABLE as_rec_blob ;
DROP TABLE sg_type_rec_blob ;
DROP TABLE as_type_rec_blob ;
DROP TABLE model_rec_blob ;
DROP TABLE sg_rec_sg_health ;
DROP TABLE as_rec_as_health ;
DROP TABLE sg_rec_sg_event ;
DROP TABLE as_rec_as_event ;
DROP TABLE sg_rec_sg_hyp_ev ;
DROP TABLE as_rec_as_hyp_ev ;
DROP TABLE sg_type_rec_hyp_ev ;
DROP TABLE as_type_rec_hyp_ev ;
DROP TABLE model_rec_hyp_ev ;
DROP TABLE sg_rec_sg_prop_ev ;
DROP TABLE as_rec_as_prop_ev ;
DROP TABLE sg_rec_mevent ;
DROP TABLE as_rec_mevent ;
DROP TABLE work_request ;
DROP TABLE solution_package ;
DROP TABLE request ;
DROP TABLE sg_req_for_work ;
DROP TABLE as_req_for_work ;
DROP TABLE ol_req_for_work ;
DROP TABLE work_req_sg_recomm ;
DROP TABLE work_req_as_recomm ;
DROP TABLE work_req_sol_pack ;
DROP TABLE work_req_num_data ;
DROP TABLE work_req_chr_data ;
DROP TABLE work_request_audit ;
DROP TABLE work_order ;
DROP TABLE work_order_child ;
DROP TABLE work_order_num_data ;
DROP TABLE work_order_chr_data ;
DROP TABLE work_order_audit ;
DROP TABLE work_order_step ;
DROP TABLE wo_step_num_data ;
DROP TABLE wo_step_chr_data ;
DROP TABLE wo_step_audit ;
DROP TABLE wo_step_sg_recomm ;
DROP TABLE wo_step_as_recomm ;
DROP TABLE wo_step_work_req ;
DROP TABLE sg_completed_work ;
DROP TABLE as_completed_work ;
DROP TABLE ol_completed_work ;
DROP TABLE db_mim_interface ;
DROP TABLE mloc_type_child ;
DROP TABLE as_sol_pack ;
DROP TABLE sg_sol_pack ;
DROP TABLE ol_sol_pack ;
DROP TABLE meas_loc_assoc ;
DROP TABLE amb_set_type ;
DROP TABLE log_connector_type ;
DROP TABLE ev_chr_data_type ;
DROP TABLE mloc_num_data_type ;
DROP TABLE mloc_chr_data_type ;
DROP TABLE sg_hyp_ev_amb_set ;
DROP TABLE sg_hyp_ev_log_conn ;
DROP TABLE sg_prop_ev_amb_set ;
DROP TABLE sg_prop_ev_log_conn ;
DROP TABLE sg_pr_ev_amb_set_sg_ev ;
DROP TABLE num_al_reg_num_data ;
DROP TABLE num_al_reg_chr_data ;
DROP TABLE num_al_reg_blob_data ;
DROP TABLE meas_loc_num_data ;
DROP TABLE meas_loc_chr_data ;
DROP TABLE meas_loc_blob_data ;
DROP TABLE geo_position ;
DROP TABLE gps_datum_type ;
DROP TABLE gps_precision_type ;
DROP TABLE gps_elevation_type ;
DROP TABLE gps_location ;
DROP TABLE segment_geo_position ;
DROP TABLE asset_geo_position ;
DROP TABLE sg_event_chr_data ;
DROP TABLE as_event_chr_data ;
DROP TABLE logistic_resource_type ;
DROP TABLE logistic_resource_type_child ;
DROP TABLE mat_item_conn_type ;
DROP TABLE resource_num_dat_type ;
DROP TABLE resource_chr_dat_type ;
DROP TABLE ord_list_num_dat_type ;
DROP TABLE ord_list_chr_dat_type ;
DROP TABLE ordered_list_type ;
DROP TABLE test_type ;
DROP TABLE test_comp_type ;
DROP TABLE test_comp_group_type ;
DROP TABLE criticality_scale_type ;
DROP TABLE eng_study_type ;
DROP TABLE eng_study_code ;
DROP TABLE eng_study_entry ;
DROP TABLE network_conn_type ;
DROP TABLE standard_data_type ;
DROP TABLE network_num_dat_type ;
DROP TABLE network_chr_dat_type ;
DROP TABLE ordered_list_child ;
DROP TABLE valid_as_type_on_sg_type ;
DROP TABLE valid_sg_type_eng_study_entry ;
DROP TABLE valid_segment_eng_study_entry ;
DROP TABLE valid_as_type_eng_study_entry ;
DROP TABLE valid_asset_eng_study_entry ;
DROP TABLE asset_model_history ;
DROP TABLE segment_config_network_history ;
DROP TABLE model_config_network_history ;
DROP TABLE asset_config_network_history ;
DROP TABLE ag_role_type_config_net_hist ;
DROP TABLE child_network_config_history ;
DROP TABLE logistic_resource ;
DROP TABLE resource_child ;
DROP TABLE resource_num_data ;
DROP TABLE resource_chr_data ;
DROP TABLE resource_blob_data ;
DROP TABLE materiel_master_item ;
DROP TABLE materiel_item ;
DROP TABLE valid_model_for_mat_item ;
DROP TABLE valid_mat_item_on_sg ;
DROP TABLE valid_mat_item_on_sg_num_data ;
DROP TABLE valid_mat_item_on_sg_chr_data ;
DROP TABLE valid_mat_item_on_sg_blob_data ;
DROP TABLE ord_list_resource ;
DROP TABLE ord_list_resource_num_data ;
DROP TABLE ord_list_resource_chr_data ;
DROP TABLE ord_list_resource_blob_data ;
DROP TABLE sg_config_ord_list_history ;
DROP TABLE as_config_ord_list_history ;
DROP TABLE md_config_ord_list_history ;
DROP TABLE sg_prop_event_chr_data ;
DROP TABLE as_prop_event_chr_data ;
DROP TABLE sg_prop_event_blob_data ;
DROP TABLE as_prop_event_blob_data ;
DROP TABLE sg_event_blob_data ;
DROP TABLE as_event_blob_data ;
DROP TABLE binary_num_data ;
DROP TABLE ord_list_num_data ;
DROP TABLE ord_list_chr_data ;
DROP TABLE ord_list_blob_data ;
DROP TABLE mloc_test_comp_alarm_rg ;
DROP TABLE TEST ;
DROP TABLE test_component ;
DROP TABLE test_comp_group ;
DROP TABLE test_comp_in_group ;
DROP TABLE test_comp_alarm_rg ;
DROP TABLE test_comp_alarm ;
DROP TABLE test_comp_alarm_assoc_mloc_rg ;
DROP TABLE test_comp_alarm_assoc_num_rg ;
DROP TABLE request_ord_list_needed ;
DROP TABLE solution_package_num_data ;
DROP TABLE solution_package_chr_data ;
DROP TABLE solution_package_blob_data ;
DROP TABLE solution_package_step ;
DROP TABLE solution_package_step_num_data ;
DROP TABLE solution_package_step_chr_data ;
DROP TABLE solution_package_step_blob_dat ;
DROP TABLE sol_pack_step_ord_list_needed ;
DROP TABLE work_req_blob_data ;
DROP TABLE work_order_blob_data ;
DROP TABLE work_step ;
DROP TABLE work_step_num_data ;
DROP TABLE work_step_chr_data ;
DROP TABLE work_step_blob_data ;
DROP TABLE work_step_ord_list_needed ;
DROP TABLE work_step_audit ;
DROP TABLE work_step_sg_recomm ;
DROP TABLE work_step_as_recomm ;
DROP TABLE sg_completed_work_asset_util ;
DROP TABLE sg_completed_work_num_data ;
DROP TABLE sg_completed_work_chr_data ;
DROP TABLE sg_completed_work_blob_data ;
DROP TABLE sg_completed_work_olist_used ;
DROP TABLE sg_completed_work_olist_rem ;
DROP TABLE sg_comp_work_for_sg_prop_event ;
DROP TABLE sg_comp_work_for_as_prop_event ;
DROP TABLE sg_completed_work_for_sg_event ;
DROP TABLE sg_completed_work_for_as_event ;
DROP TABLE as_completed_work_asset_util ;
DROP TABLE as_completed_work_num_data ;
DROP TABLE as_completed_work_chr_data ;
DROP TABLE as_completed_work_blob_data ;
DROP TABLE as_completed_work_olist_used ;
DROP TABLE as_completed_work_olist_rem ;
DROP TABLE as_comp_work_for_sg_prop_event ;
DROP TABLE as_comp_work_for_as_prop_event ;
DROP TABLE as_completed_work_for_sg_event ;
DROP TABLE as_completed_work_for_as_event ;
DROP TABLE ol_completed_work_asset_util ;
DROP TABLE ol_completed_work_num_data ;
DROP TABLE ol_completed_work_chr_data ;
DROP TABLE ol_completed_work_blob_data ;
DROP TABLE ol_completed_work_olist_used ;
DROP TABLE ol_completed_work_olist_rem ;
DROP TABLE ol_comp_work_for_sg_prop_event ;
DROP TABLE ol_comp_work_for_as_prop_event ;
DROP TABLE ol_completed_work_for_sg_event ;
DROP TABLE ol_completed_work_for_as_event ;
DROP TABLE request_num_data ;
DROP TABLE request_chr_data ;
DROP TABLE request_blob_data ;
DROP TABLE request_for_sg_prop_event ;
DROP TABLE request_for_as_prop_event ;
DROP TABLE work_request_for_sg_prop_event ;
DROP TABLE work_request_for_as_prop_event ;
DROP TABLE work_order_for_sg_prop_event ;
DROP TABLE work_order_for_as_prop_event ;
DROP TABLE request_for_sg_event ;
DROP TABLE request_for_as_event ;
DROP TABLE work_request_for_sg_event ;
DROP TABLE work_request_for_as_event ;
DROP TABLE work_order_for_sg_event ;
DROP TABLE work_order_for_as_event ;
DROP TABLE network_num_data ;
DROP TABLE network_chr_data ;
DROP TABLE network_blob_data ;
DROP TABLE cris_instance ;

SPOOL off