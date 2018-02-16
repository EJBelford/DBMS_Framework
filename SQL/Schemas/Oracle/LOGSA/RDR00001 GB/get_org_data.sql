--
-- GET_ORG_DATA  (Procedure)
--
CREATE OR REPLACE PROCEDURE RDR00001.get_org_data (
    called_by           in        varchar2,   -- calling procedure name,
used in debugging, calling procedure responsible for maintaining heirachy
    i_niin              in        varchar2,
    in_ps_start         in        date,
    unexpected_error    in out    varchar2
)
is
/***********************************************************************
*******
   NAME:       GET_ORG_DATA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------
------------------------------------
   1.0        5/21/2007    STEVE PANICH
   1.1        2/04/2008    j.southworth    use org_parts_gnd.fault_dt
instead of
                                           org_mh_gnd.rpt_date for dt_maint_ev_est

   NOTES:
THE PROCEDURE WILL POPULATE BLD_PFSA_MAINT_* TABLES WITH ORG MAINTENANCE DATA


   Automatically available Auto Replace Keywords:
      Object Name:     GET_ORG_DATA
      Sysdate:         5/21/2007
      Date and Time:


************************************************************************
******/

    -- standard variables
    ps_oerr                       varchar2 ( 6 ) := null;
    ps_location                   varchar2 ( 10 ) := 'BEGIN';
    ps_procedure_name             varchar2 ( 30 ) := 'GET_ORG_DATA';
    ps_msg                        varchar2 ( 200 ) := 'no message
defined';
    ps_id_key                     varchar2 ( 200 ) := null;   -- coder
responsible for identifying key for debug
    lst_date                      date;
-- pfsa process control variables, applicable only if this is a data processing procedure
    ps_last_process               pfsa_processes%rowtype;
    ps_this_process               pfsa_processes%rowtype;
    maint_event                   bld_pfsa_maint_event%rowtype;
    ls_cust_uic                   bld_pfsa_maint_event.cust_uic%type;
    new_cust_geo_cd               bld_pfsa_maint_event.cust_geo_cd%type;
    new_cust_uic                  bld_pfsa_maint_event.cust_uic%type;
    new_cust_cmd_uic
bld_pfsa_maint_event.cust_cmd_uic%type;
    m_events                      bld_pfsa_maint_event%rowtype;
    m_tasks                       bld_pfsa_maint_task%rowtype;
    m_work                        bld_pfsa_maint_work%rowtype;
    m_items                       bld_pfsa_maint_items%rowtype;
    tmp_holder                    bld_pfsa_maint_work.mil_civ_kon%type;
    last_maint_ev_id              bld_pfsa_maint_event.maint_ev_id%type;
    last_maint_task_id
bld_pfsa_maint_task.maint_task_id%type;
    -- common variables accross tables
    in_maint_ev_id                bld_pfsa_maint_event.maint_ev_id%type;
    in_maint_task_id
bld_pfsa_maint_task.maint_task_id%type;
    in_status                     bld_pfsa_maint_event.status%type;
    in_lst_updt                   bld_pfsa_maint_event.lst_updt%type;
    in_updt_by                    bld_pfsa_maint_event.updt_by%type;
    in_proc_stamp                 bld_pfsa_maint_event.proc_stamp%type;
    in_heir_id                    bld_pfsa_maint_event.heir_id%type;
    in_parent_maint_ev_id
bld_pfsa_maint_event.parent_maint_ev_id%type;
    --maint_event variables
    in_maint_org                  bld_pfsa_maint_event.maint_org%type;
    in_maint_uic                  bld_pfsa_maint_event.maint_uic%type;
    in_maint_lvl_cd
bld_pfsa_maint_event.maint_lvl_cd%type;
    in_maint_item                 bld_pfsa_maint_event.maint_item%type;
    in_maint_item_niin
bld_pfsa_maint_event.maint_item_niin%type;
    in_maint_item_sn
bld_pfsa_maint_event.maint_item_sn%type;
    in_num_maint_item
bld_pfsa_maint_event.num_maint_item%type;
    in_sys_ei                     bld_pfsa_maint_event.sys_ei%type;
    in_sys_ei_niin                bld_pfsa_maint_event.sys_ei_niin%type;
    in_sys_ei_sn                  bld_pfsa_maint_event.sys_ei_sn%type;
    in_num_mi_nrts                bld_pfsa_maint_event.num_mi_nrts%type;
    in_num_mi_rprd                bld_pfsa_maint_event.num_mi_rprd%type;
    in_num_mi_cndmd
bld_pfsa_maint_event.num_mi_cndmd%type;
    in_num_mi_neof                bld_pfsa_maint_event.num_mi_neof%type;
    in_dt_maint_ev_est
bld_pfsa_maint_event.dt_maint_ev_est%type;
    in_dt_maint_ev_cmpl
bld_pfsa_maint_event.dt_maint_ev_cmpl%type;
    in_sys_ei_nmcm                bld_pfsa_maint_event.sys_ei_nmcm%type;
    in_phase_ev                   bld_pfsa_maint_event.phase_ev%type;
    in_sof_ev                     bld_pfsa_maint_event.sof_ev%type;
    in_asam_ev                    bld_pfsa_maint_event.asam_ev%type;
    in_mwo_ev                     bld_pfsa_maint_event.mwo_ev%type;
    in_type_maint_ev
bld_pfsa_maint_event.type_maint_ev%type;
    in_elapsed_me_wk_tm
bld_pfsa_maint_event.elapsed_me_wk_tm%type;
    in_cust_uic                   bld_pfsa_maint_event.cust_uic%type;
    in_cust_cmd_uic
bld_pfsa_maint_event.cust_cmd_uic%type;
    in_cust_geo_cd                bld_pfsa_maint_event.cust_geo_cd%type;
    in_source_id                  bld_pfsa_maint_event.source_id%type;
    in_proj_cd                    bld_pfsa_maint_event.proj_cd%type;
    --usage variables
    in_usage_amount
bld_pfsa_maint_event.usage_amount%type;
    in_usage_cd                   bld_pfsa_maint_event.usage_cd%type;
    in_ready_state                bld_pfsa_sn_ei_hist.ready_state%type;
    in_sys_ei_state               bld_pfsa_sn_ei_hist.sys_ei_state%type;
    in_event                      bld_pfsa_sn_ei_hist.event%type;
    in_event_dt_time
bld_pfsa_sn_ei_hist.event_dt_time%type;
    in_reading                    bld_pfsa_sn_ei_hist.reading%type;
    in_usage                      bld_pfsa_sn_ei_hist.usage%type;
    in_usage_mb                   bld_pfsa_sn_ei_hist.usage_mb%type;
    in_gen_mb                     bld_pfsa_sn_ei_hist.gen_mb%type;
    --maint_task variables
    in_elapsed_tsk_wk_tm
bld_pfsa_maint_task.elapsed_tsk_wk_tm%type;
    in_elapsed_part_wt_tm
bld_pfsa_maint_task.elapsed_part_wt_tm%type;
    in_tsk_begin                  bld_pfsa_maint_task.tsk_begin%type;
    in_tsk_end                    bld_pfsa_maint_task.tsk_end%type;
    in_inspect_tsk                bld_pfsa_maint_task.inspect_tsk%type;
    in_tsk_was_def                bld_pfsa_maint_task.tsk_was_def%type;
    in_sched_unsched
bld_pfsa_maint_task.sched_unsched%type;
    in_essential                  bld_pfsa_maint_task.essential%type;
    --maint_work variables
    in_maint_work_id
bld_pfsa_maint_work.maint_work_id%type;
    in_maint_work_mh
bld_pfsa_maint_work.maint_work_mh%type;
    in_mil_civ_kon                bld_pfsa_maint_work.mil_civ_kon%type;
    in_mos                        bld_pfsa_maint_work.mos%type;
    in_spec_person                bld_pfsa_maint_work.spec_person%type;
    in_repair                     bld_pfsa_maint_work.repair%type;
    in_mos_sent                   bld_pfsa_maint_work.mos_sent%type;
    --maint_items variables
    in_maint_item_id
bld_pfsa_maint_items.maint_item_id%type;
    in_cage_cd                    bld_pfsa_maint_items.cage_cd%type;
    in_part_num                   bld_pfsa_maint_items.part_num%type;
    in_niin                       bld_pfsa_maint_items.niin%type;
    in_part_sn                    bld_pfsa_maint_items.part_sn%type;
    in_num_items                  bld_pfsa_maint_items.num_items%type;
    in_cntld_exchng
bld_pfsa_maint_items.cntld_exchng%type;
    in_removed                    bld_pfsa_maint_items.removed%type;
    in_failure                    bld_pfsa_maint_items.failure%type;
    in_mb                         varchar2 ( 2 );
    out_mb                        varchar2 ( 2 );
    out_factor                    varchar2 ( 10 );
    out_gen_mb                    varchar2 ( 2 );

    cursor org_data
    is
        select   org_mh_gnd.uic uic, org_mh_gnd.eic eic,
                 org_mh_gnd.equip_sn equip_sn, org_mh_gnd.fault_seq_no fault_seq_no,
                 pfsa_sys_ei.sys_ei_niin sys_ei_niin,
                 pfsa_sys_ei.sys_ei_nomen sys_ei_nomen,
                 potential_pfsa_item.item_niin item_niin,
                 potential_pfsa_item.item_nomen item_nomen, org_mh_gnd.flt_symb,
                 nvl ( org_mh_gnd.wpn_eic, org_mh_gnd.eic ) wpn_eic,
                 nvl ( org_mh_gnd.wpn_ser, org_mh_gnd.equip_sn ) wpn_sn,
                 org_mh_gnd.fail_cd fail_cd,
                 org_mh_gnd.type_maint_act_compl_cd
type_maint_act_compl_cd,
                 org_mh_gnd.tot_hrs tot_hrs, org_mh_gnd.fail_det_cd fail_det_cd,
                 org_mh_gnd.usag_cd usag_cd, org_mh_gnd.usage usage,
                 org_dtl_mh_gnd.mos mos, org_dtl_mh_gnd.hrsofcat hrsofcat,
                 org_dtl_mh_gnd.tymnpwr tymnpwr, org_mh_gnd.mainttype mainttype,
                 org_dtl_mh_gnd.category, org_parts_gnd.part_num, org_parts_gnd.fsc,
                 org_parts_gnd.niin, org_parts_gnd.proj_cd, org_parts_gnd.compl_dt,
                 org_mh_gnd.rpt_date, org_parts_gnd.qty_rcv, org_parts_gnd.fault_dt,
                 org_mh_gnd.updt_by, org_mh_gnd.lst_updt
            from maintenance.org_dtl_mh_gnd,
                 maintenance.org_mh_gnd,
                 maintenance.org_parts_gnd,
                 pfsa_sys_ei,
                 process_sys_ei,
                 potential_pfsa_item
           where (     ( org_mh_gnd.uic = org_dtl_mh_gnd.uic )
                   and ( org_mh_gnd.eic = org_dtl_mh_gnd.eic )
                   and ( org_mh_gnd.equip_sn = org_dtl_mh_gnd.equip_sn )
                   and ( org_mh_gnd.fault_seq_no = org_dtl_mh_gnd.fault_seq_no )
                   and ( org_mh_gnd.uic = org_parts_gnd.uic )
                   and ( org_mh_gnd.eic = org_parts_gnd.eic )
                   and ( org_mh_gnd.equip_sn = org_parts_gnd.equip_sn )
                   and ( org_mh_gnd.fault_seq_no = org_parts_gnd.fault_seq_no )
                   and ( nvl ( org_mh_gnd.wpn_eic, org_mh_gnd.eic ) = pfsa_sys_ei.eic
                       )
                   and ( pfsa_sys_ei.sys_ei_niin = process_sys_ei.sys_ei_niin )
                   and ( pfsa_sys_ei.sys_ei_niin = i_niin )
                   and ( process_sys_ei.data_source = 'VG_PFSA_ORG_DATA'
)
--                   and ( org_mh_gnd.rpt_date > '1-JAN-2001' )
02/04/2008 jas
                   and ( org_parts_gnd.fault_dt > '1-JAN-2001' )
                   and ( org_mh_gnd.lst_updt > process_sys_ei.last_run_compl )
                   and ( nvl ( org_mh_gnd.wpn_eic, org_mh_gnd.eic ) = pfsa_sys_ei.eic
                       )
                   and ( org_mh_gnd.eic = potential_pfsa_item.eic )
                 )
        order by pfsa_sys_ei.sys_ei_niin, org_mh_gnd.lst_updt; begin
    -- housekepp process control variables and set the records
    ps_location := 'HOUSEKEEP';
    ps_this_process.last_run := in_ps_start;
    ps_this_process.pfsa_process := ps_procedure_name;
    ps_this_process.who_ran := called_by;   -- either ps_procedure_name
or called_by, depending on whether a parent process exists
    ps_this_process.last_run_status := 'BEGAN';
    ps_this_process.last_run_status_time := in_ps_start;
    ps_this_process.last_run_compl := null;
    last_maint_ev_id := '|';
    last_maint_task_id := '|';
    -- get the last run information
    get_pfsa_process_info ( ps_procedure_name, ps_procedure_name,
                            ps_last_process.last_run, ps_last_process.who_ran,
                            ps_last_process.last_run_status,
                            ps_last_process.last_run_status_time,
                            ps_last_process.last_run_compl );
    -- update the record to indicate process has begun
    updt_pfsa_processes ( ps_procedure_name, ps_this_process.pfsa_process,
                          ps_this_process.last_run, ps_this_process.who_ran,
                          ps_this_process.last_run_status,
                          ps_this_process.last_run_status_time,
                          ps_this_process.last_run_compl );
    commit;

    for r1 in org_data
    loop
        ps_location := 'NEWREC';
        ps_id_key := r1.sys_ei_niin;
        lst_date := ps_this_process.last_run_compl;
        out_mb := null;
        out_factor := null;
        out_gen_mb := null;
        -- fetch common variables
        in_maint_ev_id :=
             r1.uic || '|' || r1.eic || '|' || r1.equip_sn || '|' || r1.fault_seq_no;
        in_maint_task_id := '1';
        in_status := 'Q';
        in_lst_updt := r1.lst_updt;
        in_updt_by := 'GRAB_MAINT_ORG';
        in_proc_stamp := sysdate;
        in_heir_id := 'ORG';
        in_parent_maint_ev_id := null;
        --fetch maint_event variables
        in_maint_org := r1.uic;
        in_maint_uic := r1.uic;
        in_maint_lvl_cd := 'O';
        in_maint_item := substr ( r1.item_nomen, 1, length ( in_maint_item ));
        in_maint_item_niin := r1.item_niin;
        in_maint_item_sn := r1.equip_sn;
        in_num_maint_item := 1;
        in_sys_ei := substr ( r1.sys_ei_nomen, 1, length ( in_sys_ei ));
        in_sys_ei_niin := r1.sys_ei_niin;
        in_sys_ei_sn := r1.wpn_sn;
        in_num_mi_nrts := 0;
        in_num_mi_rprd := 1;
        in_num_mi_cndmd := 0;
        in_num_mi_neof := 0;
--        in_dt_maint_ev_est := r1.rpt_date;  02/02/2008 jas
        in_dt_maint_ev_est := r1.fault_dt;
        in_dt_maint_ev_cmpl := null;   -- to be filled when correct date
is available in source tables
        in_sys_ei_nmcm := 'Y';
        in_phase_ev := 'N';
        in_sof_ev := 'N';
        in_asam_ev := 'N';
        in_mwo_ev := 'N';
        in_type_maint_ev := r1.mainttype;
        in_elapsed_me_wk_tm := null;
        in_cust_uic := null;
        in_cust_cmd_uic := null;
        in_cust_geo_cd := null;
        in_source_id := 'ORG';
        in_proj_cd := r1.proj_cd;
        --fetch usage variables
        in_usage_amount := r1.usage;
        in_usage_cd := r1.usag_cd;
        in_ready_state := '|';
        in_sys_ei_state := '|';
        in_event := 'USAGE';
--        in_event_dt_time := r1.rpt_date; 02/04/2008 jas
        in_event_dt_time := r1.fault_dt;
        in_reading := r1.usage;
        in_usage := null;
        in_usage_mb := r1.usag_cd;
        in_gen_mb := null;

        -- convert here
        if in_usage_mb is not null then
            pfsa_usage_mb_conversion ( ps_procedure_name, unexpected_error, 'ULLS',
                                       in_usage_mb, out_mb, out_factor, out_gen_mb );

            if out_factor is null then
                out_factor := 0;
            end if;
        else
            out_mb := null;
            out_factor := 0;
            out_gen_mb := 'na';
        end if;

        in_reading := in_reading * out_factor;
        in_usage_mb := out_mb;
        in_gen_mb := out_gen_mb;
        --fetch maint_task variables
        in_elapsed_tsk_wk_tm := null;
        in_elapsed_part_wt_tm := null;
        in_tsk_begin := null;
        in_tsk_end := null;

        if ( r1.fail_det_cd = 'F' ) then
            in_inspect_tsk := 'T';
        else
            in_inspect_tsk := 'F';
        end if;

        in_tsk_was_def := 'F';
        in_sched_unsched := r1.mainttype;
        in_essential := 'Y';
        --fetch maint_work variables
        in_maint_work_id := r1.category;
        in_maint_work_mh := r1.hrsofcat;

        if ( r1.tymnpwr = 'L' ) then
            in_mil_civ_kon := 'C';
        elsif ( r1.tymnpwr = null ) then
            in_mil_civ_kon := 'U';
        else
            in_mil_civ_kon := r1.tymnpwr;
        end if;

        in_spec_person := null;

        if ( r1.type_maint_act_compl_cd = 'C' ) then
            in_repair := 'Y';
        else
            in_repair := 'N';
        end if;

        --process MOS data
        in_mos_sent := r1.mos;
        get_mos_data ( called_by, in_mos_sent, tmp_holder, in_mos );
        --fetch maint_items variables
        in_maint_item_id := r1.item_niin;
        in_cage_cd := null;
        in_part_num := r1.part_num;
        in_niin := r1.niin;
        in_part_sn := null;
        in_num_items := r1.qty_rcv;
        in_cntld_exchng := 'U';
        in_removed := 'U';
        in_failure := 'U';
        ins_updt_bld_pfsa_maint_event ( called_by, in_maint_ev_id, in_maint_org,
                                        in_maint_uic, in_maint_lvl_cd, in_maint_item,
                                        in_maint_item_niin, in_maint_item_sn,
                                        in_num_maint_item, in_sys_ei, in_sys_ei_niin,
                                        in_sys_ei_sn, in_num_mi_nrts, in_num_mi_rprd,
                                        in_num_mi_cndmd, in_num_mi_neof,
                                        in_dt_maint_ev_est, in_dt_maint_ev_cmpl,
                                        in_sys_ei_nmcm, in_phase_ev, in_sof_ev,
                                        in_asam_ev, in_mwo_ev, in_type_maint_ev,
                                        in_elapsed_me_wk_tm, in_cust_uic,
                                        in_cust_cmd_uic, in_cust_geo_cd,
                                        in_source_id, in_status, in_lst_updt,
                                        in_updt_by, in_proc_stamp, in_heir_id,
                                        in_parent_maint_ev_id, in_usage_amount,
                                        in_usage_cd, in_proj_cd, null );

        -- write a new usage record
        if in_usage_mb is not null and in_reading is not null then
            ins_updt_bld_pfsa_sn_ei_hist ( called_by, in_sys_ei_niin, in_sys_ei_sn,
                                           in_maint_org, null, in_ready_state,
                                           in_sys_ei_state, in_source_id, in_event,
                                           in_event_dt_time, in_updt_by,
                                           in_proc_stamp, in_proc_stamp, in_reading,
                                           in_usage, in_usage_mb, in_status,
                                           in_gen_mb, unexpected_error );
        end if;

        ins_updt_bld_pfsa_maint_task ( called_by, in_maint_ev_id, in_maint_task_id,
                                       in_elapsed_tsk_wk_tm, in_elapsed_part_wt_tm,
                                       in_tsk_begin, in_tsk_end, in_inspect_tsk,
                                       in_tsk_was_def, in_sched_unsched,
                                       in_essential, in_status, in_lst_updt,
                                       in_updt_by, in_proc_stamp, in_heir_id, null );
        ins_updt_bld_pfsa_maint_work ( called_by, in_maint_ev_id, in_maint_task_id,
                                       in_maint_work_id, in_maint_work_mh,
                                       in_mil_civ_kon, in_mos, in_spec_person,
                                       in_repair, in_status, in_lst_updt, in_updt_by,
                                       in_proc_stamp, in_heir_id, in_mos_sent, null );
        ins_updt_bld_pfsa_maint_items ( called_by, in_maint_ev_id, in_maint_task_id,
                                        in_maint_item_id, in_cage_cd, in_part_num,
                                        in_niin, in_part_sn, in_num_items,
                                        in_cntld_exchng, in_removed, in_failure,
                                        in_status, in_lst_updt, in_updt_by,
                                        in_proc_stamp, in_heir_id, null );
        commit;
    end loop;

    update process_sys_ei
       set last_run_status = 'COMPLETE',
           last_run_status_time = sysdate,
           last_run_compl = in_ps_start
     where sys_ei_niin = i_niin and data_source = 'VG_PFSA_ORG_DATA';

    commit;

    if ( unexpected_error <> null ) then
        insert into std_pfsa_debug_tbl
                    ( ps_procedure, ps_oerr, ps_location, called_by,
                      ps_id_key, ps_msg, msg_dt
                    )
             values ( ps_procedure_name, unexpected_error, ps_location, called_by,
                      ps_id_key, ps_msg, sysdate
                    );
    end if;

    ps_location := 'HOUSEKEEPf';
    -- complete the housekeeping for the process
    ps_this_process.last_run_status := 'COMPLETE';
    ps_this_process.last_run_status_time := sysdate;
    ps_this_process.last_run_compl := sysdate;
    updt_pfsa_processes ( ps_procedure_name, ps_this_process.pfsa_process,
                          ps_this_process.last_run, ps_this_process.who_ran,
                          ps_this_process.last_run_status,
                          ps_this_process.last_run_status_time,
                          ps_this_process.last_run_compl );
    commit;
exception
    when no_data_found then
        null;
    when others then
        ps_oerr := sqlcode;

        insert into std_pfsa_debug_tbl
                    ( ps_procedure, ps_oerr, ps_location, called_by,
                      ps_id_key, ps_msg, msg_dt
                    )
             values ( ps_procedure_name, ps_oerr, ps_location, called_by,
                      ps_id_key, ps_msg, sysdate
                    );

        raise;
end;
/
