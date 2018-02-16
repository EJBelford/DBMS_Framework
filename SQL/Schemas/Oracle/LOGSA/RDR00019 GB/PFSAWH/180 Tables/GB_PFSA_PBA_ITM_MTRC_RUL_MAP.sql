DROP TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP; 
	
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: GB_PFSA_PBA_ITM_METRIC_RUL_MAP
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: GB_PFSA_PBA_ITM_METRIC_RUL_MAP.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 19 March 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- 19MAR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP 
(
    rec_id                           NUMBER              NOT NULL ,
--
    pba_id                           NUMBER              DEFAULT 0 ,
    physical_item_id                 NUMBER              DEFAULT 0 ,
    metric_id                        NUMBER              DEFAULT 0 ,
    rule_id                          NUMBER              DEFAULT 0 ,
--
    status                           VARCHAR2(1)         DEFAULT 'N' ,
    updt_by                          VARCHAR2(30)        DEFAULT USER ,
    lst_updt                         DATE                DEFAULT SYSDATE ,
--
    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
    active_date                      DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900' ,
CONSTRAINT pk_PFSA_PBS_ITM_METRIC_RUL_MAP PRIMARY KEY 
    (
    rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_PFSA_PBS_ITM_MET_RUL_MAP;

CREATE UNIQUE INDEX ixu_PFSA_PBA_ITM_MET_RUL_MAP 
    ON GB_PFSA_PBA_ITM_METRIC_RUL_MAP
    (
    pba_id ,
    physical_item_id ,
    metric_id ,
    rule_id 
    );

/*----- Foreign Key -----*/

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT fk_pfsawh_item_id;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT fk_pfsawh_item_id 
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT fk_pfsa_code_item_id;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT fk_pfsa_code_item_id 
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsa_pba_items_ref(rec_id);

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT fk_pfsa_code_metric_id;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT fk_pfsa_code_metric_id 
    FOREIGN KEY (metric_id) 
    REFERENCES gb_pfsa_pba_metrics_ref(metric_id);

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT fk_pfsa_code_rule_id;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT fk_pfsa_code_rule_id 
    FOREIGN KEY (metric_id, rule_id) 
    REFERENCES gb_pfsa_pba_rules_ref(metric_id, rule_id);

/*----- Constraints -----*/

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_act_fl;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_act_fl 
    CHECK (active_flag='I' OR active_flag='N' OR active_flag='Y');

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_del_fl;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_del_fl 
    CHECK (delete_flag='N' OR delete_flag='Y');

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_hide_fl;       

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_hide_fl 
    CHECK (hidden_flag='N' OR hidden_flag='Y');

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    DROP CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_status;        

ALTER TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP  
    ADD CONSTRAINT ck_PBA_ITM_MET_RUL_MAP_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='T' OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE PFSA_PBA_ITM_MET_RUL_MAP_seq;

CREATE SEQUENCE PFSA_PBA_ITM_MET_RUL_MAP_seq
    START WITH 1000000
    MAXVALUE   9999999
    MINVALUE   1
    NOCYCLE
    NOCACHE
    NOORDER; 

/*----- Create the Trigger now -----*/

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE GB_PFSA_PBA_ITM_METRIC_RUL_MAP 
IS 'GB_PFSA_PBA_ITM_METRIC_RUL_MAP - '; 


COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.rec_id 
IS 'REC_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.pba_id 
IS 'PBA_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.physical_item_id 
IS 'PHYSICAL_ITEM_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.metric_id 
IS 'METRIC_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.rule_id 
IS 'RULE_ID - '; 

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.status 
IS 'STATUS - The status of the record in question.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.active_date 
IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.inactive_date 
IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN gb_pfsa_pba_itm_metric_rul_map.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('GB_PFSA_PBA_ITM_METRIC_RUL_MAP'); 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        b.data_default,  
        a.comments 
--        , '|', b.*  
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('GB_PFSA_PBA_ITM_METRIC_RUL_MAP') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('GB_PFSA_PBA_ITM_METRIC_RUL_MAP') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%ITEM_SYS_EI_ID%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM GB_PFSA_PBA_ITM_METRIC_RUL_MAP a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    INSERT INTO GB_PFSA_PBA_ITM_METRIC_RUL_MAP (xx_id, xx_code, xx_description) 
        VALUES (1, 'N/A', 'NOT APPLICABLE');
    
    DBMS_OUTPUT.ENABLE(1000000);
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(code_rec.xx_ID || ', ' || code_rec.xx_CODE 
            || ', ' || code_rec.xx_DESCRIPTION
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  
    
/*

SELECT * FROM GB_PFSA_PBA_ITM_METRIC_RUL_MAP; 

*/
