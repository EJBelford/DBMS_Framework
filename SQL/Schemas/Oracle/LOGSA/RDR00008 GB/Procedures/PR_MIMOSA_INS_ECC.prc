CREATE OR REPLACE PROCEDURE pr_mimosa_ins_ecc 
    (
    in_rec_Id                IN      NUMBER  
    )

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_mimosa_ins_ecc
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: 4 February 2008 
--
--          SP Source: pr_mimosa_ins_ecc.sql
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
-- 04FEB08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_mimosa_ins_ecc';  /*  */
ps_location                      pfsa_debug_stat.ps_location%TYPE  
    := 'Begin';              /*  */
ps_oerr                          pfsa_debug_stat.ps_oerr%TYPE   
    := null;                 /*  */
ps_msg                           pfsa_debug_stat.ps_msg%TYPE 
    := null;                 /*  */
ps_id_key                        pfsa_debug_stat.ps_id_key%TYPE 
    := 'pr_mimosa_ins_ecc';  /*  */
    -- coder responsible for identying key for debug

-- MIMOSA variables (mms_)

mms_as_db_site                   VARCHAR(16)   
    := '0000043000000001';   /*  */
mms_as_db_id                     NUMBER(10)
    := '1';                  /*  */
mms_as_type_code                 NUMBER(10)
    := '1007';              /*  */
mms_last_upd_db_site             VARCHAR(16)                                                                                                                                                                                                         
    := '0000043000000001';   /*  */
mms_last_upd_db_id               NUMBER(10)
    := '1';                  /*  */
mms_rstat_type_code              NUMBER(5)
    := '1';                  /*  */
    
-- Process status variables (s0_)

s0_rec_Id                        pfsawh_process_log.process_RecId%TYPE
    := NULL;                 /* NUMBER */

s0_processRecId                  pfsawh_process_log.process_RecId%TYPE   
    := 902;                  /* NUMBER */
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
        
CURSOR code_def_ref_cur IS
    SELECT   a.cat_code, a.code_name
    FROM     PFSAWH_CODE_DEFINITION_REF a
    WHERE    a.cat_code IN (/*'1011', '1012', '1013', '1014', 
                            '1016', '1017', '1018',*/ '1019'/*, '1020'*/ ) 
    ORDER BY a.cat_code;
        
code_def_ref_rec   code_def_ref_cur%ROWTYPE;
        
CURSOR ecc_grp_cur IS
    SELECT   a.rec_id, a.cat_code, a.item_code, a.item_text
    FROM     pfsawh_code_ref a
    WHERE    a.cat_code = '1015' 
        AND a.item_code NOT IN ('-1', '0')  
    ORDER BY a.item_code;
        
ecc_grp_rec   ecc_grp_cur%ROWTYPE;
        
TYPE ecc_type IS REF CURSOR RETURN pfsawh_code_ref%ROWTYPE;
cv_ecc_cur  ecc_type;
v_ecc_rec   pfsawh_code_ref%ROWTYPE;
        
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

-- Extract pfsawh_code_def_ref for asset_type 

    OPEN  code_def_ref_cur;

    LOOP
        FETCH code_def_ref_cur 
        INTO  code_def_ref_rec;
    
        EXIT WHEN code_def_ref_cur%NOTFOUND;
    
        s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
/*    
        DBMS_OUTPUT.PUT_LINE
            ( 
            'INSERT INTO asset_type(' 
            || 'as_db_site, as_db_id, as_type_code, '
            || 'user_tag_ident, name, '                                                                                                                                                                                                             
            || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
            || 'last_upd_db_id, rstat_type_code) ' || 
            'VALUES ('''
            || mms_as_db_site || ''', ' 
            || mms_as_db_id || ', ' 
            || code_def_ref_rec.cat_code || ', ''' 
            || code_def_ref_rec.code_name || ''', ''' 
            || code_def_ref_rec.code_name || ''', SYSTIMESTAMP, '''
            || mms_last_upd_db_site || ''', ' 
            || mms_last_upd_db_id || ', ' 
            || mms_rstat_type_code
            || ');'
            );

        DBMS_OUTPUT.PUT_LINE
            ( 
            'INSERT INTO asset_type_child(' 
            || 'as_db_site, as_db_id, as_type_code, '
            || 'child_as_db_site, child_as_db_id, child_as_type_code, '                                                                                                                                                                                                             
            || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
            || 'last_upd_db_id, rstat_type_code) ' || 
            'VALUES ('''
            || '0000000000000000' || ''', ''' 
            || '0' || ''', ''' 
            || '974' || ''', ''' 
            || mms_as_db_site || ''', ''' 
            || mms_as_db_id || ''', ''' 
            || code_def_ref_rec.cat_code || ''', SYSTIMESTAMP, '''
            || mms_last_upd_db_site || ''', ' 
            || mms_last_upd_db_id || ', ' 
            || mms_rstat_type_code
            || ');'
            );
*/
    END LOOP;

    CLOSE  code_def_ref_cur;

    DBMS_OUTPUT.NEW_LINE;
    
-- Extract ECC for asset_type 

    OPEN ecc_grp_cur;

    LOOP
        FETCH ecc_grp_cur 
        INTO  ecc_grp_rec;
    
        EXIT WHEN ecc_grp_cur%NOTFOUND;
    
        s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
/*    
        DBMS_OUTPUT.PUT_LINE
            ( 
            'INSERT INTO asset_type(' 
            || 'as_db_site, as_db_id, as_type_code, '
            || 'user_tag_ident, name, '                                                                                                                                                                                                             
            || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
            || 'last_upd_db_id, rstat_type_code) ' || 
            'VALUES ('''
            || mms_as_db_site || ''', ' 
            || mms_as_db_id || ', ' 
            || ecc_grp_rec.rec_id || ', ''' 
            || UPPER(ecc_grp_rec.item_code) || ''', ''' 
            || UPPER(ecc_grp_rec.item_text) || ''', SYSTIMESTAMP, '''
            || mms_last_upd_db_site || ''', ' 
            || mms_last_upd_db_id || ', ' 
            || mms_rstat_type_code
            || ');'
            );
            
        DBMS_OUTPUT.PUT_LINE
            ( 
            'INSERT INTO asset_type_child(' 
            || 'as_db_site, as_db_id, as_type_code, '
            || 'child_as_db_site, child_as_db_id, child_as_type_code, '                                                                                                                                                                                                             
            || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
            || 'last_upd_db_id, rstat_type_code) ' || 
            'VALUES ('''
            || mms_as_db_site || ''', ''' 
            || mms_as_db_id || ''', ''' 
            || 1012 || ''', ''' 
            || mms_as_db_site || ''', ''' 
            || mms_as_db_id || ''', ''' 
            || ecc_grp_rec.rec_id || ''', SYSTIMESTAMP, '''
            || mms_last_upd_db_site || ''', ' 
            || mms_last_upd_db_id || ', ' 
            || mms_rstat_type_code
            || ');'
            );
*/
        DBMS_OUTPUT.NEW_LINE;
    
        OPEN cv_ecc_cur FOR 
            SELECT c.* 
            FROM   pfsawh_code_ref c
            WHERE  c.cat_code = '1012' 
                AND SUBSTR(c.item_code, 1, 1) = ecc_grp_rec.item_code; 
                
        LOOP
        
            FETCH cv_ecc_cur 
            INTO v_ecc_rec; 
            
            EXIT WHEN cv_ecc_cur%NOTFOUND;
    
            s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
/*        
            DBMS_OUTPUT.PUT_LINE
                ( 
                'INSERT INTO asset_type(' 
                || 'as_db_site, as_db_id, as_type_code, '
                || 'user_tag_ident, name, '                                                                                                                                                                                                             
                || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
                || 'last_upd_db_id, rstat_type_code) ' || 
                'VALUES ('''
                || mms_as_db_site || ''', ' 
                || mms_as_db_id || ', ' 
                || v_ecc_rec.rec_id || ', ''' 
                || UPPER(v_ecc_rec.item_code) || ''', ''' 
                || UPPER(v_ecc_rec.item_text) || ''', SYSTIMESTAMP, '''
                || mms_last_upd_db_site || ''', ' 
                || mms_last_upd_db_id || ', ' 
                || mms_rstat_type_code
                || ');'
                );
            
            DBMS_OUTPUT.PUT_LINE
                ( 
                'INSERT INTO asset_type_child(' 
                || 'as_db_site, as_db_id, as_type_code, '
                || 'child_as_db_site, child_as_db_id, child_as_type_code, '                                                                                                                                                                                                             
                || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
                || 'last_upd_db_id, rstat_type_code) ' || 
                'VALUES ('''
                || mms_as_db_site || ''', ''' 
                || mms_as_db_id || ''', ''' 
                || ecc_grp_rec.rec_id || ''', ''' 
                || mms_as_db_site || ''', ''' 
                || mms_as_db_id || ''', ''' 
                || v_ecc_rec.rec_id || ''', SYSTIMESTAMP, '''
                || mms_last_upd_db_site || ''', ' 
                || mms_last_upd_db_id || ', ' 
                || mms_rstat_type_code
                || ');'
                );
*/
        END LOOP;         
                
        CLOSE cv_ecc_cur;
            
        DBMS_OUTPUT.NEW_LINE;
    
    END LOOP;

    CLOSE ecc_grp_cur;

-- Extract ECC for logistic_resourc 

    OPEN ecc_grp_cur;

    LOOP
        FETCH ecc_grp_cur 
        INTO  ecc_grp_rec;
    
        EXIT WHEN ecc_grp_cur%NOTFOUND;
    
--        s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
    
    END LOOP;

    CLOSE ecc_grp_cur;

-- Extract ECC for material_master_item  

    OPEN ecc_grp_cur;

    LOOP
        FETCH ecc_grp_cur 
        INTO  ecc_grp_rec;
    
        EXIT WHEN ecc_grp_cur%NOTFOUND;
    
        s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
    
    END LOOP;

    CLOSE ecc_grp_cur;

-- Extract ??? for asset_type 

    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('/*-----------------------------------------------*/');
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN  code_def_ref_cur;

    LOOP
        FETCH code_def_ref_cur 
        INTO  code_def_ref_rec;
    
        EXIT WHEN code_def_ref_cur%NOTFOUND;
    
        OPEN cv_ecc_cur FOR 
            SELECT c.* 
            FROM   pfsawh_code_ref c
            WHERE  c.cat_code = code_def_ref_rec.cat_code 
                AND item_code > 'VFG' 
            ORDER BY item_code; 
                
        LOOP
        
            FETCH cv_ecc_cur 
            INTO v_ecc_rec; 
            
            EXIT WHEN cv_ecc_cur%NOTFOUND;
    
            s0_recReadInt := NVL(s0_recReadInt, 0) + 1; 
        
            DBMS_OUTPUT.PUT_LINE
                ( 
                'INSERT INTO asset_type(' 
                || 'as_db_site, as_db_id, as_type_code, '
                || 'user_tag_ident, name, '                                                                                                                                                                                                             
                || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
                || 'last_upd_db_id, rstat_type_code) ' || 
                'VALUES ('''
                || mms_as_db_site || ''', ' 
                || mms_as_db_id || ', ' 
                || v_ecc_rec.rec_id || ', ''' 
                || UPPER(v_ecc_rec.item_code) || ''', ''' 
                || UPPER(v_ecc_rec.item_text) || ''', SYSTIMESTAMP, '''
                || mms_last_upd_db_site || ''', ' 
                || mms_last_upd_db_id || ', ' 
                || mms_rstat_type_code
                || ');'
                );
            
            DBMS_OUTPUT.PUT_LINE
                ( 
                'INSERT INTO asset_type_child(' 
                || 'as_db_site, as_db_id, as_type_code, '
                || 'child_as_db_site, child_as_db_id, child_as_type_code, '                                                                                                                                                                                                             
                || 'gmt_last_updated, last_upd_db_site, '                                                                                                                                                                                                         
                || 'last_upd_db_id, rstat_type_code) ' || 
                'VALUES ('''
                || mms_as_db_site || ''', ''' 
                || mms_as_db_id || ''', ''' 
                || code_def_ref_rec.cat_code /*code_def_ref_rec.cat_code*/ || ''', ''' 
                || mms_as_db_site || ''', ''' 
                || mms_as_db_id || ''', ''' 
                || v_ecc_rec.rec_id || ''', SYSTIMESTAMP, '''
                || mms_last_upd_db_site || ''', ' 
                || mms_last_upd_db_id || ', ' 
                || mms_rstat_type_code
                || ');'
                );

        END LOOP;         
                
        CLOSE cv_ecc_cur;
            
        DBMS_OUTPUT.NEW_LINE;
    
    END LOOP;

    CLOSE code_def_ref_cur;
    
/*-----  -----*/

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
            NULL;
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
            
END pr_mimosa_ins_ecc;
/
