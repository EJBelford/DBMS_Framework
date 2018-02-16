DROP TABLE PFSAWH.gb_pfsawh_item_sn_dim;

/*
-- Added 06Mar08 to populate physical_item_id  

UPDATE gb_pfsawh_item_sn_dim 
SET    physical_item_id = item_id,
       physical_item_sn_id = item_sn_id; 

COMMIT; 
*/ 

/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: gb_pfsawh_item_sn_dim 
--      PURPOSE: A major grouping End Items.  
--
-- TABLE SOURCE: gb_pfsawh_item_sn_dim.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 9 January 2008 
--
--  ASSUMPTIONS:
--
--  LIMITATIONS:
--
--        NOTES:
--
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--	
--
CREATE TABLE gb_pfsawh_item_sn_dim
(
    rec_id                        NUMBER              NOT NULL,
    physical_item_sn_id           NUMBER              DEFAULT 0,
    mimosa_item_sn_id             VARCHAR2(8)         DEFAULT '00000000' , 
    item_serial_number            VARCHAR2(48)        DEFAULT '-1' ,    
    pfsa_subject_flag             VARCHAR2(1)         DEFAULT 'N',                          
--  
    physical_item_id              NUMBER              NOT NULL ,  
    item_niin                     VARCHAR2(9)         NOT NULL ,  
    item_registration_num         VARCHAR2(30)        DEFAULT 'UNK' , 
    item_location                 VARCHAR2(4)         DEFAULT '-1' ,  
    item_location_id              NUMBER              DEFAULT '-1' ,  
    item_uic                      VARCHAR2(6)         DEFAULT '-1' , 
    item_force_id                 NUMBER              DEFAULT '-1' ,  
    item_uic_location             VARCHAR2(4)         DEFAULT '-1' ,
    item_soc_flag                 VARCHAR2(2)         DEFAULT 'N' , 
    item_acq_date                 DATE                DEFAULT '01-JAN-1950',  
    item_acq_date_id              NUMBER              DEFAULT '-1' ,  
    item_notes                    VARCHAR2(255) , 
--  
    item_army_type_designator     VARCHAR2(30),
    item_manufacturer             VARCHAR2(30),
    item_manufacturer_cd          VARCHAR2(6),
    item_manufactured_date        DATE,      
    item_manufactured_date_id     NUMBER              DEFAULT '-1' ,      
--     
    status                        VARCHAR2(1)         DEFAULT 'I' ,
    lst_updt                      DATE                DEFAULT SYSDATE ,
    updt_by                       VARCHAR2(20)        DEFAULT USER ,
--
    active_flag                   VARCHAR2(1)         DEFAULT 'I' , 
    active_date                   DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                     VARCHAR2(20)        DEFAULT USER , 
    insert_date                   DATE                DEFAULT SYSDATE , 
    update_by                     VARCHAR2(20)        NULL ,
    update_date                   DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                   DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                   DATE                DEFAULT '01-JAN-1900' 
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING; 

/*----- Primary Key -----*/

ALTER TABLE gb_pfsawh_item_sn_dim  
    DROP CONSTRAINT pk_pfsawh_itm_sn_dim_itm_sn_id;        

ALTER TABLE gb_pfsawh_item_sn_dim 
	ADD CONSTRAINT pk_pfsawh_itm_sn_dim_itm_sn_id 
    PRIMARY KEY 
        (
        physical_item_id,
        physical_item_sn_id     
        );

/*----- Foreign Key -----*/
 
ALTER TABLE gb_pfsawh_item_sn_dim  
    DROP CONSTRAINT fk_pfsawh_itm_id_itm;        

ALTER TABLE gb_pfsawh_item_sn_dim  
    ADD CONSTRAINT fk_pfsawh_itm_id_itm
    FOREIGN KEY (physical_item_id) 
    REFERENCES gb_pfsawh_item_dim(physical_item_id);
 
/*----- Indexs -----*/

DROP INDEX idx_pfsawh_item_sn_dim_rec_id; 

CREATE UNIQUE INDEX idx_pfsawh_item_sn_dim_rec_id 
    ON gb_pfsawh_item_sn_dim
    (
    rec_id
    )
    LOGGING
    NOPARALLEL;

DROP INDEX idx_pfsawh_itm_sn_dim_sn; 

CREATE INDEX idx_pfsawh_itm_sn_dim_sn 
    ON gb_pfsawh_item_sn_dim
    (
    physical_item_sn_id     
    )
    LOGGING
    NOPARALLEL;

DROP INDEX idx_pfsawh_itm_sn_dim_itm_sn; 

CREATE UNIQUE INDEX idx_pfsawh_itm_sn_dim_itm_sn 
    ON gb_pfsawh_item_sn_dim
    (
    item_id,
    item_sn_id     
    )
    LOGGING
    NOPARALLEL;

-- Alter tables columns 
/*
ALTER TABLE gb_pfsawh_item_sn_dim 
DROP ( 
    );

ALTER TABLE gb_pfsawh_item_sn_dim 
ADD (
    );
*/
-- Constraints 

ALTER TABLE gb_pfsawh_item_sn_dim  
    DROP CONSTRAINT ck_item_sn_dim_subj_flg;        

ALTER TABLE gb_pfsawh_item_sn_dim  
    ADD CONSTRAINT ck_item_sn_dim_subj_flg 
    CHECK (pfsa_subject_flag='Y'    OR pfsa_subject_flag='N');
    
/*----- Table Meta-Data -----*/ 
    
COMMENT ON TABLE gb_pfsawh_item_sn_dim 
IS 'PFSAWH_ITEM_SN_DIM - This table contains the serial numbered items in the PFSA world.  It therefore reflects the current information from the PFSA_SN_EI_HIST table  and other sources. It is populated and controlled by TBD process.'; 

    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.rec_id 
IS 'REC_ID - Sequence/identity for dimension.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_sn_id 
IS 'ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the PFSAWH_ITEM_SN_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the PFSAWH_ITEM_SN_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number. HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_serial_number 
IS 'ITEM_SERIAL_NUMBER - Serial number of the item.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.pfsa_subject_flag 
IS 'PFSA_SUBJECT_FLAG - Indicates if the item with this serial number is of interest to PFSA.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_id 
IS 'ITEM_ID - LIW/PFSAWH identitier for the item/part as represented in the PFSAWH_ITEM_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.physical_item_id 
IS 'PHYSICAL_ITEM_ID - LIW/PFSAWH identitier for the item/part as represented in the PFSAWH_ITEM_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_niin 
IS 'ITEM_NIIN - National Item Identification Number for the item/part.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_registration_num 
IS 'ITEM_REGISTRATION_NUM - REGISTRATION NUMBER - The U.S. Army Registration (Serial) Number.  A combination of numbers and letters assigned in a unique manner to each item of vehicular equipment for ready identification and control during the item''s service life.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_location 
IS 'ITEM_LOCATION - LOCATION - Identifies the location as CONUS (Continental United States) or OCONUS (Outside the Continental United States).'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_location_id 
IS 'ITEM_LOCATION_ID - LOCATION - Identifies the location as CONUS (Continental United States) or OCONUS (Outside the Continental United States) as represented in the PFSAWH_LOCATION_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_uic 
IS 'ITEM_UIC - FORCE UIC - The unit identifier of valid Force UICs.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_force_id 
IS 'ITEM_FORCE_ID - FORCE UIC - The unit identifier of valid Force UICs as represented in the PFSAWH_FORCE_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_uic_location 
IS 'ITEM_UIC_LOCATION - Force location'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_soc_flag 
IS 'ITEM_SOC_FLAG - Special Operations flag.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_acq_date 
IS 'ITEM_ACQ_DATE - ACQUISITION DATE - Indicates the date an item was acquired.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_acq_date 
IS 'ITEM_ACQ_DATE_ID - ACQUISITION DATE - Indicates the date an item was acquired as represented by the PFSAWH_DATE_DIM.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_notes 
IS 'ITEM_NOTES - This will be NULL if the record is good.  Records information about the record error.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_army_type_designator 
IS 'ITEM_ARMY_TYPE_DESIGNATOR - Model number';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_manufacturer 
IS 'ITEM_MANUFACTURER - MANUFACTURER - Identifies the manufacturer of the item.';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_manufacturer_cd 
IS 'ITEM_MANUFACTURER_CD - MANUFACTURER - Identifies the manufacturer of the item.';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_manufactured_date 
IS 'ITEM_MANUFACTURED_DATE - The date the item was manufactuerd.';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_manufactured_date_id 
IS 'ITEM_MANUFACTURED_DATE_ID - The date the item was manufactuerd as represented by the PFSAWH_DATE_DIM.';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';
   
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Flag indicating when the record became active.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.INACTIVE_DATE 
IS 'INACTIVE_DATE - Additional control for active_Flag indicating when the record went inactive.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.INSERT_BY 
IS 'INSERT_BY - Reports who initially created the record.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.INSERT_DATE 
IS 'INSERT_DATE - Reports when the record was initially created.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.UPDATE_BY 
IS 'UPDATE_BY - Reports who last updated the record.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.UPDATE_DATE 
IS 'UPDATE_DATE - Reports when the record was last updated.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.DELETE_FLAG 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.DELETE_DATE 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.HIDDEN_FLAG 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.HIDDEN_DATE 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';
    
/*----- Check to see if the table comment is present -----*/
    
SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('gb_pfsawh_item_sn_dim'); 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.column_id, 
    a.table_name, 
    a.column_name, 
    b.data_type, 
    b.data_length, 
    b.nullable, 
    a.comments 
FROM user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('gb_pfsawh_item_sn_dim') 
    AND a.column_name = b.column_name
WHERE a.table_name = UPPER('gb_pfsawh_item_sn_dim') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%MANUFACTURER%')
ORDER BY a.col_name; 
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%MANUFACTURER%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

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

DECLARE

CURSOR ei_avail_cur IS
    SELECT 
    DISTINCT ei.sys_ei_niin, 
--             ei.pfsa_item_id, 
--             ei.record_type, 
--             ei.from_dt, 
--             ei.to_dt, 
--             ei.ready_date, 
--             ei.pfsa_org, 
           ei.sys_ei_sn --, 
--             ei.item_days, 
--             ei.period_hrs,
--             ei.mc_hrs
    FROM   pfsa_equip_avail@pfsawh.lidbdev ei
--    WHERE  ei.sys_ei_sn NOT IN ('AGGREGATE')
--        AND ei.sys_ei_niin LIKE 'F%' 
    ORDER BY ei.sys_ei_sn;
    
ei_avail_rec    ei_avail_cur%ROWTYPE;
    
CURSOR fact_cur IS
    SELECT a.availability_t_fact_rec_id, 
           a.availability_item_id, 
           a.availability_mc_flag
    FROM   gb_pfsawh_availability_t_fact a
    ORDER BY a.availability_t_fact_rec_id, 
           a.availability_item_id;
    
fact_rec    fact_cur%ROWTYPE;
    
-- Exception handling variables (ps_)

ps_procedure_name                pfsa_debug_stat.ps_procedure%TYPE  
    := 'pr_phsawh_item_sn';  /*  */
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
    := 102;                  /* NUMBER */
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

v_nsn                        gb_pfsawh_item_dim.nsn%TYPE            := '';
v_niin                       gb_pfsawh_item_dim.niin%TYPE           := '';

v_item_id                    gb_pfsawh_item_sn_dim.item_id%TYPE     := '';
v_status                     gb_pfsawh_item_sn_dim.status%TYPE      := '';
v_notes                      gb_pfsawh_item_sn_dim.item_notes%TYPE  := '';

v_gcssa_hr_asset_sn_found  NUMBER        := 0;
v_pfsawh_item_dim_nsn_fnd  NUMBER        := 0;

----------------------------------- START --------------------------------------
   
BEGIN 

    ps_location := '00 - Start';

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

    DELETE gb_pfsawh_item_sn_dim;
    s0_recDeletedInt  := SQL%ROWCOUNT;
    
    s0_recInsertedInt := 0;
    s0_recReadInt     := 0;
    s0_recValidInt    := 0; 
    
-- Check pfsa_equip_avail@pfsawh.lidbdev for new serial numbers     
    
    OPEN ei_avail_cur;
    
    LOOP
        FETCH ei_avail_cur 
        INTO  ei_avail_rec;
        
        EXIT WHEN ei_avail_cur%NOTFOUND;
        
        s0_recReadInt := s0_recReadInt + 1;
        v_notes := '';
        
        DBMS_OUTPUT.PUT_LINE
            (
               'ei_sn ' || ei_avail_rec.sys_ei_sn 
            );
            
-- Does the serial number exist in gcssa_hr_asset@pfsawh.lidbdev item

        v_gcssa_hr_asset_sn_found := 0;
            
        SELECT COUNT(nsn)
        INTO   v_gcssa_hr_asset_sn_found  
        FROM   gcssa_hr_asset@pfsawh.lidbdev item
        WHERE  item.serial_num = ei_avail_rec.sys_ei_sn; 
            
-- Skip the record if it is a 'AGGREGATE'             
            
        IF v_gcssa_hr_asset_sn_found = 0  
            AND ei_avail_rec.sys_ei_sn = 'AGGREGATE' THEN
        
            v_item_id := 0; 
            v_status := 'C';
            v_notes  := 'aggregate';
         
            s0_recValidInt := s0_recValidInt + 1;
        
        ELSIF v_gcssa_hr_asset_sn_found = 0 THEN
        
            v_item_id := -1; 
            v_status  := 'E';  
            v_notes   := 'sn not found: ' || ei_avail_rec.sys_ei_sn;
                        
        ELSIF v_gcssa_hr_asset_sn_found > 0 THEN  
            
            SELECT MAX(nsn), SUBSTR(MAX(nsn), 5, 9)
            INTO   v_nsn, 
                   v_niin 
            FROM   gcssa_hr_asset@pfsawh.lidbdev item
            WHERE  item.serial_num = ei_avail_rec.sys_ei_sn; 
            
            SELECT COUNT(item_id)
            INTO   v_pfsawh_item_dim_nsn_fnd
            FROM   gb_pfsawh_item_dim 
            WHERE  niin = v_niin; 
            
            IF v_pfsawh_item_dim_nsn_fnd > 0 THEN 
                SELECT item_id 
                INTO   v_item_id 
                FROM   gb_pfsawh_item_dim 
                WHERE  niin = v_niin; 

                v_notes  := '';
            ELSE 
                v_item_id := -2; 
                v_notes   := 'item not found: ' || NVL(v_nsn, 'no nsn') || 
                    ' - ' || NVL(ei_avail_rec.sys_ei_sn, 'no sn');
            END IF; 
            
            v_status := 'C'; 
            
            s0_recValidInt := s0_recValidInt + 1;
            
        ELSE 
        
            v_status := 'E';
            v_notes  := 'Error not found';
            
        END IF;
        
        DBMS_OUTPUT.PUT_LINE
            (
               ' v_item_id ' || v_item_id 
            || '    v_niin ' || v_niin
            || ' sys_ei_sn ' || ei_avail_rec.sys_ei_sn
            || '   v_notes ' || v_notes
            );
            
        IF v_item_id > 0 THEN 

            INSERT INTO gb_pfsawh_item_sn_dim 
                (
                item_sn_id ,
                item_id , 
                item_niin , 
                item_serial_number, 
                status, 
                item_notes  
                ) 
                VALUES 
                (
                fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
                v_item_id, 
                v_niin,  
                ei_avail_rec.sys_ei_sn, 
                v_status, 
                v_notes 
                );
            
            s0_recInsertedInt := s0_recInsertedInt + 1; 
            
        END IF;
    
    END LOOP;
    
    CLOSE ei_avail_cur;
    
    DBMS_OUTPUT.NEW_LINE;
    
    OPEN fact_cur;
    
    LOOP
        FETCH fact_cur 
        INTO  fact_rec;
        
        EXIT WHEN fact_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE
            (
               'rec_id ' || fact_rec.availability_t_fact_rec_id 
            || '  item_id ' || fact_rec.availability_item_id 
            || '  mc_flag ' || fact_rec.availability_mc_flag
            );
        
    END LOOP;
    
    CLOSE fact_cur;
    
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

SELECT item_sn_id, 
    mimosa_item_sn_id,  
    LPAD(LTRIM(TO_CHAR( item_sn_id, 'XXXXXXXX' )), 8, '0') 
FROM   gb_pfsawh_item_sn_dim
ORDER BY item_sn_id;  

UPDATE gb_pfsawh_item_sn_dim 
SET physical_item_sn_id = item_sn_id, 
    mimosa_item_sn_id = LPAD(LTRIM(TO_CHAR( item_sn_id, 'XXXXXXXX' )), 8, '0'); 

COMMIT;  

*/ 
    
/*

SELECT sn.item_id, 
    sn.item_sn_id, 
    sn.item_niin, 
    sn.item_serial_number, 
    sn.item_notes, 
    ' | ', 
    sn.* 
FROM   gb_pfsawh_item_sn_dim sn
ORDER BY sn.item_id, sn.item_notes, sn.item_sn_id; 

*/



/*

INSERT INTO gb_pfsawh_item_sn_dim 
    (
    item_sn_id ,
    item_id , 
    item_niin , 
    item_serial_number, 
    status  
    ) 
SELECT fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
    141157, 
    sys_ei_niin,  
    sys_ei_sn, 
    status
FROM  pfsa_sn_ei
WHERE SYS_EI_NIIN = '012984532'; 

COMMIT; 

INSERT INTO gb_pfsawh_item_sn_dim 
    (
    item_sn_id ,
    item_id , 
    item_niin , 
    item_serial_number, 
    status  
    ) 
SELECT fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
    141165, 
    sys_ei_niin,  
    sys_ei_sn, 
    status
FROM  pfsa_sn_ei
WHERE SYS_EI_NIIN = '010350266'; 

COMMIT; 

INSERT INTO gb_pfsawh_item_sn_dim 
    (
    item_sn_id ,
    item_id , 
    item_niin , 
    item_serial_number, 
    status  
    ) 
SELECT fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
    141161, 
    sys_ei_niin,  
    sys_ei_sn, 
    status
FROM  pfsa_sn_ei
WHERE SYS_EI_NIIN = '013558250'; 

COMMIT; 

INSERT INTO gb_pfsawh_item_sn_dim 
    (
    item_sn_id ,
    item_id , 
    item_niin , 
    item_serial_number, 
    status  
    ) 
SELECT fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
    141154, 
    sys_ei_niin,  
    sys_ei_sn, 
    status
FROM  pfsa_sn_ei
WHERE SYS_EI_NIIN = '011069519'; 

COMMIT; 

SELECT *
FROM  pfsa_sn_ei
WHERE SYS_EI_NIIN IN ('012984532', '010350266', '013558250', '011069519'); 
            
                       141157       141165       141161       141154
            
*/