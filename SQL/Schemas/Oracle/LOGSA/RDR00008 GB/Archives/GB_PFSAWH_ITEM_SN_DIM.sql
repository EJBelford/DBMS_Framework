DROP TABLE PFSAWH.gb_pfsawh_item_sn_dim;

/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
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
    item_sn_id                    NUMBER              DEFAULT 0,
--  
    item_id                       NUMBER              NOT NULL ,  
    item_serial_number            VARCHAR2(30)        DEFAULT '-1' ,    
    item_notes                    VARCHAR2(255) ,    
--     
    status                        VARCHAR2(1)         DEFAULT 'I' ,
    lst_updt                      DATE                DEFAULT sysdate ,
    updt_by                       VARCHAR2(20)        DEFAULT user ,
--
    active_flag                   VARCHAR2(1)         DEFAULT 'I' , 
    active_date                   DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                     VARCHAR2(20)        DEFAULT user , 
    insert_date                   DATE                DEFAULT sysdate , 
    update_by                     VARCHAR2(20)        NULL ,
    update_date                   DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                   DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                   VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                   DATE                DEFAULT '01-JAN-1900' 
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

CREATE UNIQUE INDEX pk_gb_pfsawh_item_sn_dim ON gb_pfsawh_item_sn_dim
    (
    rec_id
    )
    LOGGING
    NOPARALLEL;

ALTER TABLE gb_pfsawh_item_sn_dim  
    DROP CONSTRAINT pk_gb_item_dim;        

ALTER TABLE gb_pfsawh_item_sn_dim 
	 ADD CONSTRAINT pk_gb_item_dim 
    PRIMARY KEY 
        (
        item_id,
        item_sn_id     
        );

-- Constraints 
/*
ALTER TABLE gb_pfsawh_item_sn_dim  
    DROP CONSTRAINT CK_item_DIM_FLT_CAPAB_DSC        

ALTER TABLE gb_pfsawh_item_sn_dim  
    ADD CONSTRAINT CK_item_DIM_FLT_CAPAB_DSC 
    CHECK (FLEET_CAPABILITY_DESC='CARGO'    OR FLEET_CAPABILITY_DESC='UTILITY' 
        OR FLEET_CAPABILITY_DESC='ATTACK'   OR FLEET_CAPABILITY_DESC='CAVALRY' 
        OR FLEET_CAPABILITY_DESC='INFANTRY' OR FLEET_CAPABILITY_DESC='FIRE SUPPORT'
        OR FLEET_CAPABILITY_DESC='SCOUT'    OR FLEET_CAPABILITY_DESC='NOT APPLICABLE'
        );
*/
/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_item_sn_seq;

CREATE SEQUENCE pfsawh_item_sn_seq
    START WITH 1
    MAXVALUE 99999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- Trigger 

DROP TRIGGER tr_i_gb_pfsa_item_sn_seq;

CREATE OR REPLACE TRIGGER tr_i_gb_pfsa_item_sn_seq
BEFORE INSERT
ON gb_pfsawh_item_sn_dim
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_item_sn_dim_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    tr_i_gb_pfsa_item_sn_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

begin
   v_item_sn_dim_id := 0;

   select pfsawh_item_sn_seq.nextval into v_item_sn_dim_id from dual;
   :new.rec_id := v_item_sn_dim_id;
--   :new.status := 'Z';
   :new.lst_updt := sysdate;
   :new.updt_by  := user;

   exception
     when others then
       -- consider logging the error and then re-raise
       raise;
       
end tr_i_gb_pfsa_item_sn_seq;

/*----- Table Meta-Data -----*/ 
    
COMMENT ON TABLE gb_pfsawh_item_sn_dim 
IS 'PFSA_ITEM_DIM - Primary field is LIN.';
    
COMMENT ON COLUMN gb_pfsawh_item_sn_dim.rec_id 
IS 'Sequence/identity for dimension.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_sn_id 
IS 'Identitier for item/part.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_id 
IS 'Identitier for item/part.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_serial_number 
IS 'Serial number of the item.'; 

COMMENT ON COLUMN gb_pfsawh_item_sn_dim.item_notes 
IS 'This will be NULL if the record is good.  Records information about the record error.'; 

comment on column gb_pfsawh_item_sn_dim.status 
is 'The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]'

comment on column gb_pfsawh_item_sn_dim.updt_by 
is 'The date/timestamp of when the record was created/updated.'
    
comment on column gb_pfsawh_item_sn_dim.lst_updt 
is 'Indicates either the program name or user ID of the person who updated the record.'
    
comment on column gb_pfsawh_item_sn_dim.active_flag 
is 'Flag indicating if the record is active or not.'
   
comment on column gb_pfsawh_item_sn_dim.active_date 
is 'Additional control for active_Flag indicating when the record became active.'
    
comment on column gb_pfsawh_item_sn_dim.INACTIVE_DATE 
is 'Additional control for active_Flag indicating when the record went inactive.'
    
comment on column gb_pfsawh_item_sn_dim.INSERT_BY 
is 'Reports who initially created the record.'
    
comment on column gb_pfsawh_item_sn_dim.INSERT_DATE 
is 'Reports when the record was initially created.'
    
comment on column gb_pfsawh_item_sn_dim.UPDATE_BY 
is 'Reports who last updated the record.'
    
comment on column gb_pfsawh_item_sn_dim.UPDATE_DATE 
is 'Reports when the record was last updated.'
    
comment on column gb_pfsawh_item_sn_dim.DELETE_FLAG 
is 'Flag indicating if the record can be deleted.'
    
comment on column gb_pfsawh_item_sn_dim.DELETE_DATE 
is 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'
    
comment on column gb_pfsawh_item_sn_dim.HIDDEN_FLAG 
is 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'
    
comment on column gb_pfsawh_item_sn_dim.HIDDEN_DATE 
is 'Additional control for HIDDEN_FLAG indicating when the record was hidden.'
    
/*----- Check to see if the table comment is present -----*/
    
SELECT TABLE_NAME, COMMENTS 
FROM   USER_TAB_COMMENTS 
WHERE  Table_Name = UPPER('gb_pfsawh_item_sn_dim') 
    
/*----- Check to see if the table column comments are present -----*/
    
SELECT b.COLUMN_ID, 
    a.TABLE_NAME, 
    a.COLUMN_NAME, 
    b.DATA_TYPE, 
    b.DATA_LENGTH, 
    b.NULLABLE, 
    a.COMMENTS 
FROM USER_COL_COMMENTS a
LEFT OUTER JOIN USER_TAB_COLUMNS b ON b.TABLE_NAME = UPPER('gb_pfsawh_item_sn_dim') 
    AND a.COLUMN_NAME = b.COLUMN_NAME
WHERE a.TABLE_NAME = UPPER('gb_pfsawh_item_sn_dim') 
ORDER BY b.COLUMN_ID 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%type_cl%')
ORDER BY a.col_name 
   
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
--    WHERE  ei.sys_ei_niin LIKE 'F%' 
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

    pr_PHSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
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
            
            SELECT MAX(nsn)
            INTO   v_nsn 
            FROM   gcssa_hr_asset@pfsawh.lidbdev item
            WHERE  item.serial_num = ei_avail_rec.sys_ei_sn; 
            
            SELECT COUNT(item_id)
            INTO   v_pfsawh_item_dim_nsn_fnd
            FROM   gb_pfsawh_item_dim 
            WHERE  nsn = v_nsn; 
            
            IF v_pfsawh_item_dim_nsn_fnd > 0 THEN 
                SELECT item_id
                INTO   v_item_id 
                FROM   gb_pfsawh_item_dim 
                WHERE  nsn = v_nsn; 

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
        
        INSERT INTO gb_pfsawh_item_sn_dim 
            (
            item_sn_id ,
            item_id , 
            item_serial_number, 
            status, 
            item_notes  
            ) 
            VALUES 
            (
            fn_pfsawh_get_dim_identity('PFSAWH_ITEM_SN_DIM'), 
            v_item_id, 
            ei_avail_rec.sys_ei_sn, 
            v_status, 
            v_notes
            );
            
            s0_recInsertedInt := s0_recInsertedInt + 1;
    
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
    
    pr_PHSAWH_InsUpd_ProcessLog (s0_processRecId, s0_processKey, 0, 0, 
        s0_processStartDt, s0_processEndDt, 
        s0_processStatusCd, s0_sqlErrorCode, 
        s0_recReadInt, s0_recValidInt, s0_recLoadInt, 
        s0_recInsertedInt, s0_recSelectedInt, s0_recUpdatedInt, s0_recDeletedInt, 
        s0_userLoginId, s0_message, in_rec_id); 
        
    COMMIT;

END;  
    
/*

SELECT sn.item_id, 
    sn.item_sn_id, 
    sn.item_serial_number, 
    sn.item_notes, 
    ' | ', 
    sn.* 
FROM   gb_pfsawh_item_sn_dim sn
ORDER BY sn.item_id, sn.item_notes, sn.item_sn_id; 

*/

