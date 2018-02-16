/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: gb_load_pfsawh_item_dim
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 07 January 2008 
--
--          SP Source: gb_load_pfsawh_item_dim.sql
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--      SP Parameters: 
--              Input: 
-- 
--             Output:   
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- Used in the following:
--
--         
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 07JAN07 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

CREATE OR REPLACE PROCEDURE gb_load_pfsawh_item_dim

IS 

-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_phsawh_item';     /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := null;                 /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

in_rec_Id                        gb_pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  gb_pfsawh_process_log.process_RecId%TYPE   
    := 104;                  /* NUMBER */
s0_processKey                    gb_pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_processStartDt                gb_pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  gb_pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               gb_pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  gb_pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    gb_pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   gb_pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    gb_pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                gb_pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                gb_pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 gb_pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 gb_pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   gb_pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       gb_pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                    NUMBER        
     := 0;   -- Controls debug options (0 -Off)

----------------------------------- START --------------------------------------

BEGIN 

    s0_recInsertedInt := 0;
    s0_recUpdatedInt  := 0;
    s0_recDeletedInt  := 0;
    
    ps_location := '00-Start';

    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, in_rec_id);

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);
    END IF;  

    DELETE gb_pfsawh_item_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
        
    INSERT 
    INTO	gb_pfsawh_item_dim 
    ( 
    item_id, 
    lin, 
    chap,  
    lin_active_date,
    lin_inactive_date,
    gen_nomen, 
    lin_inactive_statement, 
    ricc_item_code, 
    mat_cat_cd_1, 
    sb_700_20_publication_date, 
    status, 
    lst_updt, 
    updt_by, 
    active_flag, 
    active_date
    ) 
    SELECT	
    fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'),
    lin, 
    chap, 
    dt_assigned, 
    dt_inact,  
    NVL(gen_nomen, 'unk'),  
    inactive_statement, 
    lin_ricc, 
    mat_cat_cd_1, 
    pub_dt_sb_700_20, 
    status, 
    lst_updt, 
    updt_by, 
    'Y', 
    dt_assigned 
    FROM	lin@pfsawh.lidbdev lin 
    WHERE	status = 'C';  
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT;
    
    UPDATE gb_pfsawh_item_dim 
    SET    (niin) = 
               ( SELECT MAX(auth.niin)  
                 FROM   auth_item@pfsawh.lidbdev auth
                 WHERE  lin = auth.lin 
                     AND auth.status = 'C' 
               ); 
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    COMMIT;

    INSERT 
    INTO	gb_pfsawh_item_dim 
    ( 
    item_id, 
    niin, 
    army_type_designator,
    lin, 
    mscr, 
    lin_active_date,
    lin_inactive_date,
    gen_nomen, 
    --lin_inactive_statement, 
    --ricc_item_code, 
    --mat_cat_cd_1, 
    sb_700_20_publication_date, 
    status, 
    lst_updt, 
    updt_by, 
    active_flag, 
    active_date
    ) 
    SELECT	
    fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'),
    niin, 
    NVL(army_type_design, 'unk'),
    lin, 
    mscr, 
    '01-JAN-1990', 
    dt_inact,  
    NVL(shrt_nomen, 'unk'),  
    --inactive_statement, 
    --lin_ricc, 
    --mat_cat_cd_1, 
    sb_pub_dt, 
    status, 
    lst_updt, 
    updt_by, 
    'Y', 
    dt_assigned 
    FROM	auth_item@pfsawh.lidbdev lin 
    WHERE	status = 'C'; 
    
    s0_recInsertedInt  := s0_recInsertedInt + SQL%ROWCOUNT;
    
    UPDATE gb_pfsawh_item_dim a
    SET    (fsc, nsn) = 
               ( SELECT fsc, NVL(nsn, fsc || niin)  
                 FROM   item_control@pfsawh.lidbdev ctrl
                 WHERE  a.niin = ctrl.niin  
               )
    WHERE  UPPER(a.fsc) = 'UNK';        
    
    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    UPDATE gb_pfsawh_item_dim 
    SET    nsn = fsc || niin
    WHERE  UPPER(nsn) = 'UNK' 
        AND fsc IS NOT NULL 
        AND niin IS NOT NULL;

    s0_recUpdatedInt  := s0_recUpdatedInt + SQL%ROWCOUNT;
    
    ps_location := '99 - Close';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, in_rec_id); 
        
    COMMIT;

END; 

/*

SELECT item.fsc, item.niin, item.nsn, 
    '|', item.* 
FROM   gb_pfsawh_item_dim item 
ORDER BY item.fsc, item.niin; 

SELECT item.fsc, item.niin, item.nsn, 
    '|', auth.*, 
    '|', item.* 
FROM   gb_pfsawh_item_dim item, 
       auth_item@pfsawh.lidbdev auth
WHERE  fsc = '2355' 
    AND item.lin = auth.lin 
    AND auth.status = 'C' 
ORDER BY item.fsc, auth.niin; 

SELECT * 
FROM	lin@pfsawh.lidbdev lin 
WHERE  gen_nomen LIKE '%ICV%'
ORDER BY lin; 

*/
    
