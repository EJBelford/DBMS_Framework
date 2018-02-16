CREATE OR REPLACE PROCEDURE pr_PFSAWH_item_part_load 

IS

/*--*----|----*----|----*----|---- Team ITSS ----|----*----|----*----|----*---*/
--
--            SP Name: pr_PHSAWH_blank
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_PHSAWH_blank.sql
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

ps_procedure_name       VARCHAR2(30)  := 'pr_PFSAWH_item_part_load';
ps_location             VARCHAR2(10)  := 'Begin'; 
ps_oerr                 VARCHAR2(6)   := null;
ps_msg                  VARCHAR2(200) := null;
ps_id_key               VARCHAR2(200) := null;              -- coder responsible 
                                                            -- for identying key 
                                                            -- for debug

-- Process status variables (s0_ & s1_)

s0_rec_Id               PLS_INTEGER   := NULL; 

s0_processRecId         PLS_INTEGER   := 101; 
s0_processKey           PLS_INTEGER   := NULL;
s0_moduleNum            PLS_INTEGER   := 0;
s0_stepNum              PLS_INTEGER   := 0;
s0_processStartDt       DATE          := sysdate;
s0_processEndDt         DATE          := NULL;
s0_processStatusCd      PLS_INTEGER   := NULL;
s0_sqlErrorCode         PLS_INTEGER   := NULL;
s0_recReadInt           PLS_INTEGER   := NULL;
s0_recValidInt          PLS_INTEGER   := NULL;
s0_recLoadInt           PLS_INTEGER   := NULL;
s0_recInsertedInt       PLS_INTEGER   := NULL;
s0_recSelectedInt       PLS_INTEGER   := NULL;
s0_recUpdatedInt        PLS_INTEGER   := NULL;
s0_recDeletedInt        PLS_INTEGER   := NULL;
s0_userLoginId          VARCHAR2(30)  := user;
s0_message              VARCHAR2(255) := ''; 

s1_rec_Id               NUMBER        := NULL; 

s1_processKey           PLS_INTEGER   := NULL;
s1_moduleNum            PLS_INTEGER   := NULL;
s1_stepNum              PLS_INTEGER   := NULL;
s1_processStartDt       DATE          := NULL;
s1_processEndDt         DATE          := NULL;
s1_processStatusCd      PLS_INTEGER   := NULL;
s1_sqlErrorCode         PLS_INTEGER   := NULL;
s1_recReadInt           PLS_INTEGER   := NULL;
s1_recValidInt          PLS_INTEGER   := NULL;
s1_recLoadInt           PLS_INTEGER   := NULL;
s1_recInsertedInt       PLS_INTEGER   := NULL;
s1_recSelectedInt       PLS_INTEGER   := NULL;
s1_recUpdatedInt        PLS_INTEGER   := NULL;
s1_recDeletedInt        PLS_INTEGER   := NULL;
s1_userLoginId          VARCHAR2(30)  := user;
s1_message              VARCHAR2(255) := ''; 
    
-- module variables (v_)

v_debug                 PLS_INTEGER   := 1;    -- Controls debug option (0 -Off)

l_max_prd_rowcnt        PLS_INTEGER   := NULL; -- # rowsa found in target 
                                               -- production PFSADW table.  
l_max_prd_lst_updt      DATE          := NULL; -- The most recent update to the  
                                               -- production PFSADW table.  
l_max_src_rowcnt        PLS_INTEGER   := NULL; -- # rowsa found in target 
                                               -- production table.  
l_max_src_lst_updt      DATE          := NULL; -- The most recent update to the  
                                               -- production table.  
l_src_lst_chck_date     DATE          := NULL; -- The last time the source table
                                               -- was checked.  
                                               
l_cnt_updt              PLS_INTEGER   := NULL; -- 

l_run_flg               PLS_INTEGER   := 0;    -- Run additional modules

/*----- Populate -----*/

CURSOR part_cur IS
    SELECT   a.niin
    FROM     gb_pfsa_item_part_bld a
    ORDER BY a.niin;
    
part_rec    part_cur%ROWTYPE;
        
BEGIN 

    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.NEW_LINE;
    
    ps_location := '00-Start';

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Debug: ' || ps_procedure_name || ', ' 
            || ps_location);
    END IF;

    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 00, 00,
        s0_processStartDt, NULL, 
        NULL, NULL, 
        NULL, NULL, NULL, 
        NULL, NULL, NULL, NULL, 
        s0_userLoginId, NULL, s0_rec_Id);

-- Collect facts about source and DW tables.

/*----- manufacturer_part@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   manufacturer_part@pfsawh.lidbdev 
    WHERE  rncc = '3'; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   manufacturer_part@pfsawh.lidbdev 
    WHERE  rncc = '3'; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   manufacturer_part@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt 
        AND rncc = '3'; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    SOURCE_LAST_CHECKED_DATE = sysdate, 
           SOURCE_LAST_RECORD_COUNT = l_max_prd_rowcnt,
           SOURCE_LAST_UPDATE_DATE  = l_max_prd_lst_updt,
           SOURCE_LAST_UPDATE_COUNT = l_cnt_updt,
           SOURCE_LAST_INSERT_COUNT = NULL,
           SOURCE_LAST_DELETE_COUNT = NULL
    WHERE  source_table = 'MANUFACTURER_PART';
    
    COMMIT;
    
/*----- item_control@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   item_control@pfsawh.lidbdev; 
--    WHERE  rncc = '3'; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   item_control@pfsawh.lidbdev; 
--    WHERE  rncc = '3'; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   item_control@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
--        AND rncc = '3'; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'ITEM_CONTROL';
    
    COMMIT;
    
/*----- item_control@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   item_data@pfsawh.lidbdev; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   item_data@pfsawh.lidbdev; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   item_data@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'ITEM_DATA';
    
    COMMIT;
    
/*----- auth_item@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   auth_item@pfsawh.lidbdev; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   auth_item@pfsawh.lidbdev; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   auth_item@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'AUTH_ITEM';
    
    COMMIT;
    
/*----- lin@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   lin@pfsawh.lidbdev; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   lin@pfsawh.lidbdev; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   lin@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'LIN';
    
    COMMIT;
    
/*----- gcssa_lin@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   gcssa_lin@pfsawh.lidbdev; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   gcssa_lin@pfsawh.lidbdev; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   gcssa_lin@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'GCSSA_LIN';
    
    COMMIT;
    
/*----- gcssa_hr_asset@pfsawh.lidbdev -----*/

    SELECT COUNT(*) 
    INTO   l_max_prd_rowcnt 
    FROM   gcssa_hr_asset@pfsawh.lidbdev; 

    SELECT MAX(lst_updt) 
    INTO   l_max_prd_lst_updt 
    FROM   gcssa_hr_asset@pfsawh.lidbdev; 
    
    SELECT COUNT(lst_updt) 
    INTO   l_cnt_updt 
    FROM   gcssa_hr_asset@pfsawh.lidbdev 
    WHERE  lst_updt = l_max_prd_lst_updt; 
    
    UPDATE gb_pfsawh_source_hist_ref 
    SET    source_last_checked_date = sysdate, 
           source_last_record_count = l_max_prd_rowcnt,
           source_last_update_date  = l_max_prd_lst_updt,
           source_last_update_count = l_cnt_updt,
           source_last_insert_count = NULL,
           source_last_delete_count = NULL
    WHERE  source_table = 'GCSSA_HR_ASSET';
    
    COMMIT;
    
/*---------------------------*/
/*--  manufacturuer parts  --*/    
/*---------------------------*/

-- Test - delete a row to force a refresh 
-- DELETE gb_pfsa_item_part_bld WHERE niin = '015148052'

    SELECT NVL(COUNT(*), 0) 
    INTO   l_max_src_rowcnt  
    FROM   gb_pfsa_item_part_bld
    WHERE  record_source = UPPER('manufacturer_part');

    SELECT NVL(MAX(part_lst_updt), '01-Jan-1990') 
    INTO   l_max_src_lst_updt 
    FROM   gb_pfsa_item_part_bld 
    WHERE  record_source = UPPER('manufacturer_part');

    SELECT source_last_record_count  
    INTO   l_max_prd_rowcnt 
    FROM   gb_pfsawh_source_hist_ref 
    WHERE  source_table = UPPER('manufacturer_part');
    
    ps_location := '01-Load';

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Debug: ' || ps_procedure_name || ', ' 
            || ps_location || ', ' 
            || l_max_prd_rowcnt  || ', ' || l_max_src_rowcnt );
    END IF;

    IF  l_max_src_rowcnt < 1 
        OR 
        ( l_max_prd_rowcnt > l_max_src_rowcnt 
         --    AND l_max_src_lst_updt > l_max_prd_lst_updt
        ) THEN 

        s1_processKey      := 1;
        s1_moduleNum       := 1;
        s1_stepNum         := 0;
        s1_processStartDt  := sysdate;

        s1_recReadInt      := NULL;
        s1_recValidInt     := NULL;
        s1_recLoadInt      := NULL;
        s1_recInsertedInt  := NULL;
        s1_recSelectedInt  := NULL;
        s1_recUpdatedInt   := NULL;
        s1_recDeletedInt   := NULL;
        
        pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s1_processKey, 
            s1_moduleNum, s1_stepNum, 
            s1_processStartDt, NULL, 
            NULL, NULL, 
            NULL, NULL, NULL, 
            NULL, NULL, NULL, NULL, 
            s0_userLoginId, NULL, s1_rec_Id);

-- Changes or updates have been found, clear the build table.

        DELETE  gb_pfsa_item_part_bld; 
    
        s1_recDeletedInt := SQL%ROWCOUNT;

        COMMIT;     
        
-- Load the bld table from the manufacturer part list  

        INSERT 
        INTO   gb_pfsa_item_part_bld 
            (
            niin, 
            part_CAGE_CD, 
            part_MFG_PART_NUM, 
            part_ACT_MEAS,
            part_DAC,
            part_RADIONUCLIDE,
            part_RNAAC,
            part_RNCC,
            part_RNJC,
            part_RNVC,
            part_SADC,
            part_LST_UPDT,
            part_STATUS,
            part_UPDT_BY, 
            record_source  
            )
        SELECT  niin, 
            NVL(cage_cd, -1), 
            NVL(mfg_part_num, -1),  
            ACT_MEAS,
            DAC,
            RADIONUCLIDE,
            RNAAC,
            RNCC,
            RNJC,
            RNVC,
            SADC,
            LST_UPDT,
            STATUS,
            UPDT_BY, 
            'MANUFACTURER_PART' 
        FROM    manufacturer_part@pfsawh.lidbdev
        WHERE   rncc = '3'; 
  
        s1_recInsertedInt := SQL%ROWCOUNT;
        l_run_flg         := s1_recInsertedInt; 

        COMMIT;
        
        s1_processEndDt := sysdate;
        s1_sqlErrorCode := sqlcode;
        s1_processStatusCd := NVL(s1_sqlErrorCode, sqlcode);
        s1_message := sqlcode || ' - ' || sqlerrm; 
        
        pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s1_processKey, 
            s1_moduleNum, s1_stepNum, 
            s1_processStartDt, s1_processEndDt, 
            s1_processStatusCd, s1_sqlErrorCode, 
            s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
            s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
            s1_userLoginId, s1_message, s1_rec_Id); 
            
    ELSE         

        s0_message := s0_message || ' - No additions or updates found'; 
        
    END IF; 
    
/*---------------------------*/
/*--  items                --*/    
/*---------------------------*/
    
    SELECT NVL(COUNT(*), 0) 
    INTO   l_max_src_rowcnt  
    FROM   gb_pfsa_item_part_bld
    WHERE  record_source = UPPER('item_control');

    SELECT NVL(MAX(part_lst_updt), '01-Jan-1990') 
    INTO   l_max_src_lst_updt 
    FROM   gb_pfsa_item_part_bld 
    WHERE  record_source = UPPER('item_control');

    SELECT source_last_record_count, 
           source_last_checked_date   
    INTO   l_max_prd_rowcnt, 
           l_src_lst_chck_date 
    FROM   gb_pfsawh_source_hist_ref 
    WHERE  source_table = UPPER('item_control');
    
    ps_location := '02-Upd Itm';

    IF l_src_lst_chck_date + 1 > sysdate THEN
        l_run_flg := l_max_prd_rowcnt - l_max_src_rowcnt;  
    END IF;

    IF v_debug > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Debug: ' || ps_procedure_name || ', ' 
            || ps_location || ', ' 
            || l_max_prd_rowcnt  || ', ' || l_max_src_rowcnt || ', ' 
            || l_run_flg);
    END IF;
    
-- Update the bld table with item_control@pfsawh.lidbdev values  

    IF l_run_flg > 0 THEN 
    
        s1_rec_Id          := NULL; 
        s1_processKey      := 1;
        s1_moduleNum       := 2;
        s1_stepNum         := 1;
        s1_processStartDt  := sysdate;

        s1_recReadInt      := NULL;
        s1_recValidInt     := NULL;
        s1_recLoadInt      := NULL;
        s1_recInsertedInt  := NULL;
        s1_recSelectedInt  := NULL;
        s1_recUpdatedInt   := NULL;
        s1_recDeletedInt   := NULL;
        
        pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s1_processKey, 
            s1_moduleNum, s1_stepNum, 
            s1_processStartDt, NULL, 
            NULL, NULL, 
            NULL, NULL, NULL, 
            NULL, NULL, NULL, NULL, 
            s0_userLoginId, NULL, s1_rec_Id);

        UPDATE gb_pfsa_item_part_bld 
        SET    (fsc, item_ctrl_NOMEN_35) = 
               ( SELECT NVL(ic.fsc, '-2'), 
                     NVL(ic.NOMEN_35, '-2') 
                 FROM   item_control@pfsawh.lidbdev ic 
                 WHERE  gb_pfsa_item_part_bld.niin = ic.niin 
               ) 
        WHERE niin LIKE '01%'; 
         
        s1_recUpdatedInt := SQL%ROWCOUNT;
        
        COMMIT;

-- Insert item_control@pfsawh.lidbdev values into the bld table for missing niin. 

--    SELECT * FROM item_control@pfsawh.lidbdev WHERE niin = '015148052'
    
        INSERT 
        INTO   gb_pfsa_item_part_bld 
            (
            niin, 
            item_ctrl_nomen_35,
            item_data_full_nomen, 
            nsn, 
            fsc, 
            ecc, 
            cl_of_supply_cd, 
            part_LST_UPDT,
            part_STATUS,
            part_UPDT_BY,
            record_source 
            )
        SELECT  niin.niin, 
            niin.nomen_35, 
            niin.nomen_35, 
            NVL(fsc, '0000') || NVL(niin, '000000000'), 
            NVL(fsc, '0000'), 
            niin.ecc, 
            niin.cl_of_supply_cd, 
            niin.LST_UPDT,
            'Z',
            niin.updt_by, 
            'ITEM_CONTROL' 
        FROM    item_control@pfsawh.lidbdev niin    
        WHERE NOT EXISTS ( 
                            SELECT niin 
                            FROM   gb_pfsa_item_part_bld 
                            WHERE  niin = niin.niin 
                         );
        
        s1_recSelectedInt := SQL%ROWCOUNT; 
        
        COMMIT; 
        
        s1_processEndDt := sysdate;
        s1_sqlErrorCode := sqlcode;
        s1_processStatusCd := NVL(s1_sqlErrorCode, sqlcode);
        s1_message := sqlcode || ' - ' || sqlerrm; 
        
        pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s1_processKey, 
            s1_moduleNum, s1_stepNum, 
            s1_processStartDt, s1_processEndDt, 
            s1_processStatusCd, s1_sqlErrorCode, 
            s1_recReadInt, s1_recValidInt, s1_recLoadInt, 
            s1_recInsertedInt, s1_recSelectedInt, s1_recUpdatedInt, s1_recDeletedInt, 
            s1_userLoginId, s1_message, s1_rec_Id);

    END IF;
    
-- Update the bld table with item_data values 

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (item_data_FULL_NOMEN) = 
               ( SELECT NVL(ida.FULL_NOMEN, -2)  
                 FROM   item_data@pfsawh.lidbdev ida 
                 WHERE  gb_pfsa_item_part_bld.niin = ida.niin 
               ) 
        WHERE  niin LIKE '01%'; 
           
        COMMIT;

--    SELECT * FROM item_data@pfsawh.lidbdev WHERE niin = '015148052'
    
    END IF; 
    
/*---------------------------*/
/*--  authorized items     --*/    
/*---------------------------*/
    
-- Update the bld table with auth_item values  

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (lin, auth_item_shrt_nomen) = 
            ( SELECT NVL(ai.lin, -2), 
                  NVL(ai.shrt_nomen, -2) 
              FROM   auth_item@pfsawh.lidbdev ai 
              WHERE  gb_pfsa_item_part_bld.niin = ai.niin 
            ) 
        WHERE niin LIKE '01%'; 
    
        COMMIT; 
    
--        SELECT * FROM auth_item@pfsawh.lidbdev WHERE niin = '015148052';
    
    END IF; 
     
/*---------------------------*/
/*--  lin items            --*/    
/*---------------------------*/
    
-- Update the bld table with lin values  

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (lin_gen_nomen) = 
            ( SELECT NVL(ln.gen_nomen, -2)  
              FROM   lin@pfsawh.lidbdev ln 
              WHERE  gb_pfsa_item_part_bld.lin = ln.lin 
            ) 
        WHERE  niin LIKE '01%';
    
        COMMIT; 

-- Insert LIN items not in bld table from GCSSA_LIN

        DELETE gb_pfsa_item_part_bld 
        WHERE  part_UPDT_BY = 'GCSSA_LIN';
    
        INSERT 
        INTO   gb_pfsa_item_part_bld 
            (
            niin, 
            lin,
            item_ctrl_nomen_35,
            item_data_full_nomen, 
            nsn, 
            fsc, 
            ecc, 
            cl_of_supply_cd, 
            part_LST_UPDT,
            part_STATUS,
            part_UPDT_BY 
            )
        SELECT  NVL(SUBSTR(lin.nsn, 5, 9), '000000000'), 
            lin.lin, 
            lin.item_nomen, 
            lin.gen_nomen, 
            nsn, 
            NVL(SUBSTR(lin.nsn, 1, 4), '0000'), 
            lin.ecc, 
            lin.supply_class, 
            lin.LST_UPDT,
            'Z',
            'GCSSA_LIN' 
        FROM    GCSSA_LIN@pfsawh.lidbdev lin    -- SELECT * FROM GCSSA_LIN@pfsawh.lidbdev
        WHERE NOT EXISTS ( 
                            SELECT lin 
                            FROM   gb_pfsa_item_part_bld 
                            WHERE  lin = lin.lin 
                         );
        
-- Insert LIN items not in bld table from GCSSA_HR_ASSET 

        DELETE gb_pfsa_item_part_bld 
        WHERE  part_UPDT_BY = 'GCSSA_HR_ASSET';
    
        INSERT 
        INTO   gb_pfsa_item_part_bld 
            (
            niin, 
            lin,
            nsn,
            fsc, 
            part_LST_UPDT,
            part_STATUS,
            part_UPDT_BY 
            )
        SELECT  
        DISTINCT NVL(SUBSTR(lin.nsn, 5, 9), '000000000'), 
            lin.lin, 
            nsn, 
            NVL(SUBSTR(lin.nsn, 1, 4), '0000'), 
            '01-JAN-1900', -- lin.LST_UPDT,
            'Z',
            'GCSSA_HR_ASSET' 
        FROM    GCSSA_HR_ASSET@pfsawh.lidbdev lin    -- SELECT * FROM GCSSA_HR_ASSET@pfsawh.lidbdev
        WHERE NOT EXISTS ( 
                            SELECT lin 
                            FROM   gb_pfsa_item_part_bld 
                            WHERE  lin = lin.lin 
                         )
            AND LENGTH(TRIM(nsn)) = 13;
        
    END IF;
    
-- Debug  
    
    IF v_debug > 1000 THEN 

        OPEN part_cur;
    
        LOOP
            FETCH part_cur 
            INTO  part_rec;
        
            EXIT WHEN part_cur%NOTFOUND 
                OR part_cur%ROWCOUNT > 1000;
        
            DBMS_OUTPUT.PUT_LINE(part_rec.niin || ', ' || 
                'x' );
        
        END LOOP;
    
        CLOSE part_cur;
        
    END IF;
    
    ps_location := '99-Close';

    --    s_recUpdatedInt := SQL%ROWCOUNT;
    s0_processEndDt := sysdate;
    s0_sqlErrorCode := sqlcode;
    s0_processStatusCd := NVL(s0_sqlErrorCode, sqlcode);
    s0_message := sqlcode || ' - ' || sqlerrm || s0_message; 
    
    pr_PFSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 00, 00, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, s0_rec_Id);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
		     ps_oerr   := sqlcode;
            ps_msg    := sqlerrm;
            ps_id_key := '';
		    INSERT 
           INTO   std_pfsa_debug_tbl 
               (
               ps_procedure, ps_oerr, ps_location, called_by, 
               ps_id_key, ps_msg, msg_dt
               )
		    VALUES 
               (
               ps_procedure_name, ps_oerr, ps_location, s0_userLoginId, 
               ps_id_key, ps_msg, sysdate
               );
                   
--        RAISE;

--        ROLLBACK;
            
END pr_PFSAWH_item_part_load;
/
