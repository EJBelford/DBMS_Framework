/*  

-- FUNCTIONS -- 

fn_date_id_to_date(#####)                            -- returns 'dd-mon-yyyy' 
SELECT fn_date_to_date_id('01-JUN-2008') from dual;  -- returns 31337 
SELECT fn_date_to_date_id('31-DEC-2012') from dual;  -- returns 33011 

UPDATE pfsa_pba_items_ref 
SET    item_from_date_id = 31337, 
       item_to_date_id = 33011; 
       
COMMIT; 

fn_time_id_to_time(#####)                       
fn_time_to_timeid('dd-mon-yyyy')                

frz_rec(pba_id, item_type, item_value, report_date, record_date)  returns 0 or greater than 0  

  Add these FRZ_INPUT_DATE (date) and FRZ_INPUT_DATE_ID (number) to every table 
  feeding to the PFSA tables with records to be frozen.   

    bld_pfsa_equip_avail    => pfsa_equip_avail  
        [lst_updt] 
    
    bld_pfsa_maint_event    => pfsa_maint_event 
        [ ] 
    
    bld_pfsa_maint_task     => pfsa_maint_task  
        [ ] 
    
    bld_pfsa_maint_items    => pfsa_maint_items   
        [ ] 
    
    bld_pfsa_maint_work      > pfsa_maint_work 
        [ ] 
    
    bld_pfsa_usage_event    => pfsa_usage_event  
        [ ] 
    
    bld_pfsa_cwt            => pfsa_cwt 
        [ ] 
    

-- PSEUDO-CODE 

Are there freeze dates for this PBA_Id. 

New Item 

    Create a freeze records for all the dates between Item freeze dates.  
    If the Item freeze dates are NULL, use the PBA agreement dates. 
    
    
Change agreement dates 

    Start early 
        Update Item freeze start date for all items?  
    
    Start later 
    
    End early 
    
    End later     

    Change Item Freeze dates 

        Freeze starts early 
            Drop all the item freeze dates and re-insert 
        
        Freeze starts later 
            Drop only the freeze dates before the new date 
        
        Freeze ends early 
            Drop only the freeze records after the new end date 
        
        Freeze end later 
            Add new between old end date and new end date 


Drop Item 

    Delete all the freeze dates for the PBA and Item 


*/  

BEGIN 

    SELECT * 
    FROM   pfsa_pba_ref; 

    SELECT * 
    FROM   pfsa_pba_frz_rules_ref; 
    
    SELECT COUNT(*) 
    FROM   pfsa_pba_frz_dates_ref 
    WHERE  pba_id = 1000006; 

    SELECT TO_CHAR(sysdate, 'DD-Mon-YYYY') AS today, 
        date_id_to_date(ir.item_from_date_id) AS pba_fr, 
        ADD_MONTHS(TO_DATE(frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY'))+1, -1) AS frz_fr, 
        frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY') AS frz_to, 
        frz_day_mnth_cd + frz_cutoff_adj_val || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY') AS cutoff_, 
        date_to_date_id(frz_day_mnth_cd + frz_cutoff_adj_val || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY')) AS cutoff_id, 
        date_id_to_date(ir.item_to_date_id) AS pba_to, 
        ir.item_to_date_id - item_from_date_id AS pba_lngth, 
        ir.item_type_value, 
        '|', r.*, '||', 
        ir.* 
    FROM   pfsa_pba_items_ref ir 
    LEFT OUTER JOIN pfsa_pba_ref r ON ir.pba_id = r.pba_id 
    LEFT OUTER JOIN pfsa_pba_frz_rules_ref frr ON ir.pba_id = frr.pba_id 
    WHERE  ir.pba_id = 1000006 
        AND ir.item_identifier_type_id = 13;  
        
    INSERT 
    INTO   pfsa_pba_frz_dates_ref 
        (
        pba_id ,
        item_identifier_type_id ,
        item_type_value,
        frz_rule_typ_cd ,
        frz_fr_date ,
        frz_fr_date_id ,
        frz_to_date ,
        frz_to_date_id ,
        frz_cutoff_date ,
        frz_cutoff_date_id 
        )
    SELECT 
        1000006, 
        ir.item_identifier_type_id,
        ir.item_type_value, 
        frr.rec_id,
        ADD_MONTHS(TO_DATE(frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY'))+1, -1),
        date_to_date_id(ADD_MONTHS(TO_DATE(frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY'))+1, -1)),
        frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY'), 
        date_to_date_id(frz_day_mnth_cd || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY')), 
        frz_day_mnth_cd + frz_cutoff_adj_val || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY'),
        date_to_date_id(frz_day_mnth_cd + frz_cutoff_adj_val || TO_CHAR(date_id_to_date(ir.item_from_date_id), '-Mon-YYYY')) 
    FROM   pfsa_pba_items_ref ir 
    LEFT OUTER JOIN pfsa_pba_ref r ON ir.pba_id = r.pba_id 
    LEFT OUTER JOIN pfsa_pba_frz_rules_ref frr ON ir.pba_id = frr.pba_id 
    WHERE  ir.pba_id = 1000006 
        AND ir.item_identifier_type_id = 13;  
        
--    DELETE pfsa_pba_frz_dates_ref;
        
    COMMIT; 

    SELECT * 
    FROM   pfsa_pba_frz_dates_ref; 
 
    SELECT COUNT(pea.sys_ei_niin) 
    FROM   pfsa_equip_avail pea;
       
    SELECT date_to_date_id(TO_DATE(pea.ready_date, 'dd-mon-yyyy')),  
           pea.* 
    FROM   pfsa_equip_avail pea, 
           pfsa_pba_frz_dates_ref fd
    WHERE  fd.pba_id = 1000006 
        AND fd.item_identifier_type_id = '13' 
        AND pea.sys_ei_niin = fd.item_type_value  
        AND date_to_date_id(TO_DATE(pea.ready_date, 'dd-mon-yyyy')) BETWEEN frz_fr_date_id AND frz_to_date_id;
    
    SELECT COUNT(pea.sys_ei_niin) 
    FROM   pfsa_equip_avail pea, 
           pfsa_pba_frz_dates_ref fd
    WHERE  fd.pba_id = 1000006 
        AND fd.item_identifier_type_id = '13' 
        AND pea.sys_ei_niin = fd.item_type_value  
        AND date_to_date_id(TO_DATE(pea.ready_date, 'dd-mon-yyyy')) BETWEEN fd.frz_fr_date_id AND fd.frz_to_date_id
        AND date_to_date_id(TO_DATE(pea.ready_date, 'dd-mon-yyyy')) < fd.frz_cutoff_date_id;
    
END;     


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DROP TABLE tmp_pba_item;

CREATE GLOBAL TEMPORARY TABLE tmp_pba_item 
    (
    REC_ID                      NUMBER            NOT NULL,
    PBA_ID                      NUMBER            DEFAULT -2,
    ITEM_IDENTIFIER_TYPE_ID     NUMBER            DEFAULT -2,
    ITEM_TYPE_VALUE             VARCHAR2(30 BYTE) DEFAULT 'unk',
    ITEM_FROM_DATE_ID           NUMBER,
    ITEM_TO_DATE_ID             NUMBER,
--    ITEM_CHANGE_REASON_DESC     VARCHAR2(100 BYTE),
--    ITEM_IMPLEMENTATION_LVL_CD  VARCHAR2(2 BYTE),
    PHYSICAL_ITEM_ID            NUMBER            DEFAULT 0,
    PHYSICAL_ITEM_SN_ID         NUMBER            DEFAULT 0,
    FORCE_ID                    NUMBER            DEFAULT 0 
    )
ON COMMIT PRESERVE ROWS;
    
DECLARE

    v_ItemCnt   NUMBER; 
    v_LoopCnt   NUMBER; 
    v_RuleCnt   NUMBER; 
    
    v_REC_ID                      NUMBER;
    v_PBA_ID                      NUMBER;
    v_ITEM_IDENTIFIER_TYPE_ID     NUMBER;
    v_ITEM_TYPE_VALUE             VARCHAR2(30 BYTE);
    v_ITEM_FROM_DATE_ID           NUMBER;
    v_ITEM_TO_DATE_ID             NUMBER;
    v_PHYSICAL_ITEM_ID            NUMBER;
    v_PHYSICAL_ITEM_SN_ID         NUMBER;
    v_FORCE_ID                    NUMBER;
    
    v_frz_day_mnth_cd             VARCHAR2(3 BYTE);
    v_frz_cutoff_adj_val          NUMBER;
    
    v_frz_fr_date                 DATE;
    v_frz_fr_date_id              NUMBER;
    v_frz_to_date                 DATE;
    v_frz_to_date_id              NUMBER;
    v_frz_cutoff_date             DATE;
    v_frz_cutoff_date_id          NUMBER;
       
BEGIN 

    DELETE tmp_pba_item;  
    
    DELETE pfsa_pba_frz_dates_ref;  
    
    COMMIT; 
    
    INSERT 
    INTO     tmp_pba_item 
        (
        rec_id,
        pba_id,
        item_identifier_type_id,
        item_type_value,
        item_from_date_id,
        item_to_date_id,
        physical_item_id,
        physical_item_sn_id,
        force_id 
        )
    SELECT 
        rec_id,
        pba_id,
        item_identifier_type_id,
        item_type_value,
        item_from_date_id,
        item_to_date_id,
        physical_item_id,
        physical_item_sn_id,
        force_id 
    FROM   pfsa_pba_items_ref
    WHERE  pba_id IN ( 1000006, 1000007 )
    ORDER BY pba_id, item_identifier_type_id, item_type_value; 
    
    SELECT COUNT(pba_id)
    INTO   v_LoopCnt  
    FROM   tmp_pba_item; 
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    WHILE v_LoopCnt > 0 
    LOOP 
    
        SELECT 
            REC_ID,
            PBA_ID,
            ITEM_IDENTIFIER_TYPE_ID,
            ITEM_TYPE_VALUE,
            ITEM_FROM_DATE_ID,
            ITEM_TO_DATE_ID,
            PHYSICAL_ITEM_ID,
            PHYSICAL_ITEM_SN_ID,
            FORCE_ID
        INTO   
            v_REC_ID,
            v_PBA_ID,
            v_ITEM_IDENTIFIER_TYPE_ID,
            v_ITEM_TYPE_VALUE,
            v_ITEM_FROM_DATE_ID,
            v_ITEM_TO_DATE_ID,
            v_PHYSICAL_ITEM_ID,
            v_PHYSICAL_ITEM_SN_ID,
            v_FORCE_ID 
        FROM   tmp_pba_item 
        WHERE  ROWNUM = 1
        ORDER BY pba_id, item_identifier_type_id, item_type_value; 
            
        DBMS_OUTPUT.PUT_LINE
             (
             v_LoopCnt           || ', ' || v_ITEM_IDENTIFIER_TYPE_ID || ', ' ||
             v_ITEM_TYPE_VALUE   || ', ' ||  
             v_ITEM_FROM_DATE_ID || ', ' || v_ITEM_TO_DATE_ID
             );
             
        SELECT frz_day_mnth_cd, frz_cutoff_adj_val
        INTO   v_frz_day_mnth_cd,
               v_frz_cutoff_adj_val
        FROM   pfsa_pba_frz_rules_ref 
        WHERE  pba_id = v_PBA_ID;              
            
        WHILE v_ITEM_FROM_DATE_ID <= v_ITEM_TO_DATE_ID 
        LOOP     
                 
            v_frz_fr_date        := ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY'))+1, 0);
            v_frz_fr_date_id     := fn_date_to_date_id(ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY'))+1, 0));
            v_frz_to_date        := ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY')), 1);
            v_frz_to_date_id     := fn_date_to_date_id(ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY')), 1));
            v_frz_cutoff_date    := ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd + v_frz_cutoff_adj_val || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY')), 1); 
            v_frz_cutoff_date_id := fn_date_to_date_id(ADD_MONTHS(TO_DATE(v_frz_day_mnth_cd + v_frz_cutoff_adj_val || TO_CHAR(fn_date_id_to_date(v_item_from_date_id), '-Mon-YYYY')), 1));

            DBMS_OUTPUT.PUT_LINE
                 (
                 v_frz_fr_date 
                 || ', ' || v_frz_fr_date_id 
                 || ', ' || v_frz_to_date   
                 || ', ' || v_frz_to_date_id 
                 || ', ' || v_frz_cutoff_date   
                 || ', ' || v_frz_cutoff_date_id 
                 );

            INSERT 
            INTO   pfsa_pba_frz_dates_ref 
                (
                pba_id ,
                item_identifier_type_id ,
                item_type_value,
                frz_rule_typ_cd ,
                frz_fr_date ,
                frz_fr_date_id ,
                frz_to_date ,
                frz_to_date_id ,
                frz_cutoff_date ,
                frz_cutoff_date_id 
                )
            VALUES  
                (
                v_pba_id, 
                v_item_identifier_type_id, 
                v_item_type_value,  
                v_rec_id, 
                v_frz_fr_date, 
                v_frz_fr_date_id, 
                v_frz_to_date, 
                v_frz_to_date_id, 
                v_frz_cutoff_date,
                v_frz_cutoff_date_id 
                ); 
            
            SELECT fn_date_to_date_id(ADD_MONTHS(fn_date_id_to_date(v_ITEM_FROM_DATE_ID), 1)) 
            INTO   v_ITEM_FROM_DATE_ID  
            FROM   dual; 

/*            DBMS_OUTPUT.PUT_LINE
                 (
                 fn_date_id_to_date(v_ITEM_FROM_DATE_ID) 
                 || ', ' || v_ITEM_FROM_DATE_ID 
                 || ', ' || fn_date_id_to_date(v_ITEM_TO_DATE_ID)   
                 || ', ' || v_ITEM_TO_DATE_ID
                 ); */
            
        END LOOP; 
        
/*        SELECT uic 
        INTO   v_uic 
        FROM   tmp_uic 
        WHERE  ROWNUM = 1; 
            
        v_force_id := fn_pfsawh_get_dim_identity('pfsawh_force_unit_dim');
            
        UPDATE pfsawh_force_unit_dim 
        SET    force_unit_id = v_force_id 
        WHERE  uic = v_uic;  */
        
        DELETE tmp_pba_item 
        WHERE  REC_ID = v_REC_ID; 
        
        COMMIT; 
    
        SELECT v_LoopCnt - 1
        INTO   v_LoopCnt  
        FROM   dual; 
    
    END LOOP; -- v_LoopCnt 
    
    DBMS_OUTPUT.NEW_LINE;
    
COMMIT;    

END;  
    
/*

SELECT * 
FROM   pfsa_pba_frz_dates_ref
ORDER BY pba_id, frz_fr_date_id, item_identifier_type_id, item_type_value; 

ROLLBACK;

*/ 
 