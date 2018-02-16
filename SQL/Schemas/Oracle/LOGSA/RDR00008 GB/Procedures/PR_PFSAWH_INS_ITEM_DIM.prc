CREATE OR REPLACE PROCEDURE pr_pfsawh_ins_item_dim 
    (
    in_rec_id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_pfsawh_ins_item_dim
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_pfsawh_ins_item_dim.sql
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
-- ddmmmyy - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_pfsawh_ins_item_dim';  /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := 'pr_pfsawh_ins_item_dim';  /*  */
    -- coder responsible for identying key for debug

-- Process status variables (s0_)

s0_rec_Id                        pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  pfsawh_process_log.process_RecId%TYPE   
    := 311;                  /* NUMBER */
s0_processKey                    pfsawh_process_log.process_Key%TYPE     
    := NULL;                 /* NUMBER */
s0_moduleNum                     pfsawh_process_log.Module_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_stepNum                       pfsawh_process_log.Step_Num%TYPE   
    := NULL;                 /* NUMBER */
s0_processStartDt                pfsawh_process_log.process_Start_Date%TYPE      
    := sysdate;              /* DATE */
s0_processEndDt                  pfsawh_process_log.process_End_Date%TYPE      
    := NULL;                 /* DATE */
s0_processStatusCd               pfsawh_process_log.process_Status_Code%TYPE  
    := NULL;                 /* NUMBER */
s0_sqlErrorCode                  pfsawh_process_log.sql_Error_Code%TYPE    
    := NULL;                 /* NUMBER */
s0_recReadInt                    pfsawh_process_log.rec_Read_Int%TYPE      
    := NULL;                 /* NUMBER */
s0_recValidInt                   pfsawh_process_log.rec_Valid_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recLoadInt                    pfsawh_process_log.rec_Load_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recInsertedInt                pfsawh_process_log.rec_Inserted_Int%TYPE     
    := NULL;                 /* NUMBER */
s0_recSelectedInt                pfsawh_process_log.rec_Selected_Int%TYPE  
    := NULL;                 /* NUMBER */
s0_recUpdatedInt                 pfsawh_process_log.rec_Updated_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_recDeletedInt                 pfsawh_process_log.rec_Deleted_Int%TYPE    
    := NULL;                 /* NUMBER */
s0_userLoginId                   pfsawh_process_log.user_Login_Id%TYPE  
    := user;                 /* VARCHAR2(30) */
s0_message                       pfsawh_process_log.message%TYPE 
    := '';                   /* VARCHAR2(255) */
    
-- module variables (v_)

v_debug                    NUMBER        
    := 0;   -- Controls debug options (0 -Off)

CURSOR process_cur IS
    SELECT   a.process_key, a.message
    FROM     PFSAWH_Process_Log a
    ORDER BY a.process_key DESC;
        
process_rec    process_cur%ROWTYPE;
        
CURSOR ei_cur IS
    SELECT	
        ei.sys_ei_niin,
        ei.lin, 
        ei.eic, 
        NVL(ei.sys_ei_nomen, 'unk') AS sys_ei_nomen,  
        ei.status, 
        ei.lst_updt, 
        ei.updt_by  
--    FROM	pfsa_sys_ei@pfsawh.lidbdev ei  
    FROM	pfsa_sys_ei ei  
    WHERE NOT EXISTS    (
                        SELECT item.niin 
                        FROM   pfsawh_item_dim item 
                        WHERE  item.niin = ei.sys_ei_niin  
                        ) 
    ORDER BY ei.lin, ei.lst_updt;  
        
ei_rec    ei_cur%ROWTYPE;
        
CURSOR pot_ei_cur IS
    SELECT	
        ei.sys_ei_niin,
        ei.sys_ei_fsc,
        ei.lin, 
        ei.eic, 
        ei.ecc, 
        ei.mat_cat_cd_2, 
        ei.mat_cat_cd_4_5, 
        NVL(ei.sys_ei_nomen, 'unk') AS sys_ei_nomen,  
        ei.status, 
        ei.lst_updt, 
        ei.updt_by  
    FROM	potential_pfsa_sys_ei@pfsawh.lidbdev ei  
    WHERE NOT EXISTS    (
                        SELECT item.niin 
                        FROM   pfsawh_item_dim item 
                        WHERE  item.niin = ei.sys_ei_niin  
                        ) 
    ORDER BY ei.lin, ei.lst_updt;  
        
pot_ei_rec    pot_ei_cur%ROWTYPE;
        
----------------------------------- START --------------------------------------

BEGIN

    ps_location := '00-Start';

    pr_pfsawh_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, 0, 
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, s0_rec_id);

    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('in_rec_Id: ' || in_rec_id || ', ' 
           || s0_processRecId || ', ' || s0_processKey);

--        dbms_lock.sleep(1);
    END IF;  

--
    DELETE pfsawh_item_dim WHERE status = 'P' /*AND lst_updt > '31-JAN-2008'*/; 
    s0_recDeletedInt := SQL%ROWCOUNT;
-- 

    DBMS_OUTPUT.NEW_LINE;

----- pfsa_sys_ei@pfsawh.lidbdev ------    
    
    OPEN ei_cur;

    LOOP
        FETCH ei_cur 
        INTO  ei_rec;
    
        EXIT WHEN ei_cur%NOTFOUND; 
        
        s0_recReadInt := NVL(s0_recReadInt, 0) + 1;
    
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE(ei_rec.sys_ei_niin || ', ' || 
                ei_rec.lin || ', ' ||  
                ei_rec.eic || ', ' ||  
                ei_rec.sys_ei_nomen || ', ' ||   
                ei_rec.status || ', ' ||  
                ei_rec.lst_updt || ', ' ||  
                ei_rec.updt_by ); 
        END IF; 
        
        IF LENGTH(LTRIM(RTRIM(ei_rec.sys_ei_niin))) = 9 THEN 
    
            s0_recValidInt := NVL(s0_recValidInt, 0) + 1; 
            
            INSERT 
            INTO   pfsawh_item_dim 
            (
            item_id,
            pfsa_subject_flag,                          
            niin, 
            lin,
            eic_code,
            eic_model,
            item_nomen_short,
            item_nomen_standard,
            item_nomen_long, 
            status 
            )
            VALUES
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'), 
            'Y', 
            ei_rec.sys_ei_niin, 
            ei_rec.lin, 
            fn_pfsawh_vaild_code_ref   (1019, pot_ei_rec.eic),  
            fn_pfsawh_get_code_ref_desc(1019, pot_ei_rec.eic),   
            UPPER(ei_rec.sys_ei_nomen),
            UPPER(ei_rec.sys_ei_nomen),
            UPPER(ei_rec.sys_ei_nomen), 
            ei_rec.status 
            );
            
            s0_recLoadInt := NVL(s0_recLoadInt, 0) + 1; 
            s0_recInsertedInt := NVL(s0_recInsertedInt, 0) + 1; 
            
        END IF;
    
    END LOOP;

    CLOSE ei_cur;
    
----- potential_pfsa_sys_ei@pfsawh.lidbdev -----     

    OPEN pot_ei_cur;

    LOOP
        FETCH pot_ei_cur 
        INTO  pot_ei_rec;
    
        EXIT WHEN pot_ei_cur%NOTFOUND; 
        
        s0_recReadInt := NVL(s0_recReadInt, 0) + 1;
    
        IF v_debug > 0 THEN 
            DBMS_OUTPUT.PUT_LINE(pot_ei_rec.sys_ei_niin || ', ' || 
                pot_ei_rec.lin || ', ' ||  
                pot_ei_rec.eic || ', ' ||  
                pot_ei_rec.ecc || ', ' ||  
                pot_ei_rec.mat_cat_cd_2 || ', ' ||  
                pot_ei_rec.mat_cat_cd_4_5 || ', ' ||  
                pot_ei_rec.sys_ei_nomen || ', ' ||   
                pot_ei_rec.status || ', ' ||  
                pot_ei_rec.lst_updt || ', ' ||  
                pot_ei_rec.updt_by ); 
        END IF; 
        
        IF LENGTH(LTRIM(RTRIM(pot_ei_rec.sys_ei_niin))) = 9 THEN 
    
            s0_recValidInt := NVL(s0_recValidInt, 0) + 1; 
            
            INSERT 
            INTO   pfsawh_item_dim 
            (
            item_id,
            pfsa_subject_flag,                          
            niin, 
            lin,
            eic_code,
            eic_model,
            ecc_code,
            ecc_desc,
            mat_cat_cd_2_code, 
            mat_cat_cd_2_desc, 
            mat_cat_cd_4_5_code, 
            mat_cat_cd_4_5_desc, 
            item_nomen_short,
            item_nomen_standard,
            item_nomen_long, 
            status 
            )
            VALUES
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_DIM'), 
            'N', 
            pot_ei_rec.sys_ei_niin, 
            pot_ei_rec.lin, 
            fn_pfsawh_vaild_code_ref   (1019, pot_ei_rec.eic),  
            fn_pfsawh_get_code_ref_desc(1019, pot_ei_rec.eic),   
            fn_pfsawh_vaild_code_ref   (1012, pot_ei_rec.ecc),  
            fn_pfsawh_get_code_ref_desc(1012, pot_ei_rec.ecc),   
            fn_pfsawh_vaild_code_ref   (1020, pot_ei_rec.mat_cat_cd_2),  
            fn_pfsawh_get_code_ref_desc(1020, pot_ei_rec.mat_cat_cd_2),   
            fn_pfsawh_vaild_code_ref   (1014, pot_ei_rec.mat_cat_cd_4_5),
            fn_pfsawh_get_code_ref_desc(1014, pot_ei_rec.mat_cat_cd_4_5),   
            UPPER(pot_ei_rec.sys_ei_nomen),
            UPPER(pot_ei_rec.sys_ei_nomen),
            UPPER(pot_ei_rec.sys_ei_nomen), 
            'P'
            );
            
            s0_recLoadInt := NVL(s0_recLoadInt, 0) + 1; 
            s0_recInsertedInt := NVL(s0_recInsertedInt, 0) + 1; 
            
        END IF;
    
    END LOOP;

    CLOSE pot_ei_cur;

    IF v_debug > 0 THEN 
    
        DBMS_OUTPUT.NEW_LINE;

        OPEN process_cur;
    
        LOOP
            FETCH process_cur 
            INTO  process_rec;
        
            EXIT WHEN process_cur%NOTFOUND;
        
            DBMS_OUTPUT.PUT_LINE(process_rec.process_key || ', ' 
                || process_rec.message);
        
        END LOOP;
    
        CLOSE process_cur;
    
    END IF;

    ps_location := '99-Close';

    --    s0_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := SUBSTR(sqlcode || ' - ' || sqlerrm, 1, 255); 
    
    pr_pfsawh_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 
        0, 0, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_id); 
        
    COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		     INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, s0_userLoginId, 
                ps_id_key, ps_msg, sysdate);
                
        WHEN OTHERS THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		     INSERT 
            INTO std_pfsa_debug_tbl 
                (
                ps_procedure, ps_oerr, ps_location, called_by, 
                ps_id_key, ps_msg, msg_dt
                )
		     VALUES 
                (
                ps_procedure_name, ps_oerr, ps_location, s0_userLoginId, 
                ps_id_key, ps_msg, sysdate);
                
--     RAISE;

--     ROLLBACK;
            
END pr_pfsawh_ins_item_dim;
/
