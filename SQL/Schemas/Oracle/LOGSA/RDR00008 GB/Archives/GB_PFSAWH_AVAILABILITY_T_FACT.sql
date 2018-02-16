DROP TABLE gb_pfsawh_availability_t_fact;
	
/*--*----|----*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*---*/
--
--         NAME: PFSAWH_AVAILABILITY_T_FACT
--      PURPOSE: n/a. 
--
-- TABLE SOURCE: PFSAWH_AVAILABILITY_T_FACT.sql
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 19 November 2007
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
CREATE TABLE pfsawh.gb_pfsawh_availability_t_fact
    (
    availability_t_fact_rec_id       NUMBER          NOT NULL ,
    availability_item_id             NUMBER          NOT NULL ,
    availability_date_id             NUMBER          NOT NULL ,
    availability_time_from           NUMBER          NOT NULL ,
    availability_time_to             NUMBER          NOT NULL ,
--
    availability_mc_flag             VARCHAR2(1)     DEFAULT    'N',
    availability_fmc_flag            VARCHAR2(1)     DEFAULT    'N',
    availability_pmc_flag            VARCHAR2(1)     DEFAULT    'N',
    availability_nmc_flag            VARCHAR2(1)     DEFAULT    'N',
    availability_nmc_cause_code      VARCHAR2(2)     DEFAULT    'N',
    availability_most_crit_part_cd   VARCHAR2(2)     DEFAULT    'N',
    availability_defer_maint_flag    VARCHAR2(1)     DEFAULT    'N',
--
    availability_public_flag         VARCHAR2(1)     DEFAULT    'N' ,
    availability_public_code         VARCHAR2(6)     DEFAULT    'PUBLIC' ,
--
    status                           VARCHAR2(1)     DEFAULT    'C',
    updt_by                          VARCHAR2(30)    NULL ,
    lst_updt                         DATE            DEFAULT    SYSDATE ,
--
    active_flag                      VARCHAR2(1)     DEFAULT    'I' , 
    active_date                      DATE            DEFAULT    '31-DEC-2099' , 
    inactive_date                    DATE            DEFAULT    '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)    DEFAULT    USER , 
    insert_date                      DATE            DEFAULT    SYSDATE , 
    update_by                        VARCHAR2(20)    NULL ,
    update_date                      DATE            NULL ,
    delete_flag                      VARCHAR2(1)     NULL ,
    delete_date                      DATE            NULL ,
    hidden_flag                      VARCHAR2(1)     NULL ,
    hidden_date                      DATE            NULL ,
CONSTRAINT pk_availability_t_fact PRIMARY KEY 
    (
    availability_t_fact_rec_id
    )    
) 
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

/*----- Indexs -----*/

DROP INDEX ixu_pfsawh_availability_t_fact;

CREATE /*UNIQUE*/ INDEX ixu_pfsawh_availability_t_fact 
    ON pfsawh.gb_pfsawh_availability_t_fact
    (
    availability_date_id, 
    availability_time_from,
    availability_time_to
    );

/*----- Constraints -----*/

ALTER TABLE pfsawh.gb_pfsawh_availability_t_fact  
    DROP CONSTRAINT ck_availability_t_fact_status        

ALTER TABLE pfsawh.gb_pfsawh_availability_t_fact  
    ADD CONSTRAINT ck_availability_t_fact_status 
    CHECK (status='C' OR status='D' OR status='E' OR status='H' 
        OR status='L' OR status='P' OR status='Q' OR status='R'
        OR status='Z' OR status='N'
        );

/*----- Sequence  -----*/

DROP SEQUENCE pfsawh_availability_t_fact_seq; 

CREATE SEQUENCE pfsawh_availability_t_fact_seq
    START WITH 1
    MAXVALUE 9999999
    MINVALUE 1
    NOCYCLE
    NOCACHE
    NOORDER;

-- trigger 

CREATE OR REPLACE TRIGGER tr_i_pfsawh_avail_t_fact_seq
BEFORE INSERT
ON gb_pfsawh_availability_t_fact
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
v_fact_id NUMBER;

/******************** TEAM ITSS ************************************************

       NAME:    tr_i_pfsawh_avail_t_fact_seq

    PURPOSE:    To perform work as each row is inserted.
   
ASSUMPTIONS:

LIMITATIONS:

      NOTES:

  Date      ECP #            Author           Description
----------  ---------------  ---------------  ---------------------------------
12/04/2007                   Gene Belford     Trigger Created
*/

BEGIN
   v_fact_id := 0;

   SELECT pfsawh_availability_t_fact_seq.nextval 
   INTO   v_fact_id 
   FROM   dual;
   
   :new.availability_t_fact_rec_id := v_fact_id;
   :new.status := 'C';
   :new.lst_updt := SYSDATE;
   :new.updt_by  := USER;

   EXCEPTION
     WHEN others THEN
       -- consider logging the error and then re-raise
       raise;
       
END tr_i_pfsawh_avail_t_fact_seq;

/*----- Table Meta-Data -----*/ 

COMMENT ON TABLE gb_pfsawh_availability_t_fact 
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_t_fact_rec_id
IS '' 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_date_id 
IS '' 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_time_from
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_time_to
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_mc_flag
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_fmc_flag
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_pmc_flag
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_nmc_flag
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_nmc_cause_code
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_most_crit_part_cd
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.availability_defer_maint_flag
IS ''; 

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.status 
IS 'The status of the record in question.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.updt_by 
IS 'The date/timestamp of when the record was created/updated.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.lst_updt 
IS 'Indicates either the program name or user ID of the person who updated the record.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.active_flag 
IS 'Flag indicating if the record is active or not.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.active_date 
IS 'Additional control for active_Fl indicating when the record became active.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.inactive_date 
IS 'Additional control for active_Fl indicating when the record went inactive.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.insert_by 
IS 'Reports who initially created the record.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.insert_date 
IS 'Reports when the record was initially created.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.update_by 
IS 'Reports who last updated the record.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.update_date 
IS 'Reports when the record was last updated.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.delete_flag 
IS 'Flag indicating if the record can be deleted.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.delete_date 
IS 'Additional control for DELETE_FLAG indicating when the record was marked for deletion.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.hidden_flag 
IS 'Flag indicating if the record should be hidden from the general user in things like drop-down lists.'

COMMENT ON COLUMN gb_pfsawh_availability_t_fact.hidden_date 
IS 'Addition control for HIDDEN_FLAG indicating when the record was hidden.'

/*----- Check to see if the table comment is present -----*/

SELECT   table_name, comments 
FROM     user_tab_comments 
WHERE    table_name = UPPER('GB_PFSAWH_AVAILABILITY_T_FACT') 

/*----- Check to see if the table column comments are present -----*/

SELECT  b.column_id, 
        a.table_name, 
        a.column_name, 
        b.data_type, 
        b.data_length, 
        b.nullable, 
        a.comments 
FROM    user_col_comments a
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('GB_PFSAWH_AVAILABILITY_T_FACT') 
    AND a.column_name = b.column_name
WHERE    a.table_name = UPPER('GB_PFSAWH_AVAILABILITY_T_FACT') 
ORDER BY b.column_id 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%supply%')
ORDER BY a.col_name 
   
/*----- Populate -----*/

DECLARE

    CURSOR ei_avail_cur IS
        SELECT ei.sys_ei_niin, 
               ei.pfsa_item_id, 
               ei.record_type, 
               ei.from_dt, 
               ei.to_dt, 
               ei.ready_date, 
               ei.pfsa_org, 
               ei.sys_ei_sn, 
               ei.item_days, 
               ei.period_hrs,
               ei.mc_hrs
        FROM   pfsa_equip_avail@pfsawh.lidbdev ei
        WHERE  ei.sys_ei_niin LIKE 'F%' 
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
    
-- module variables (v_)

v_debug                 NUMBER        := 0;   -- Controls debug options (0 -Off)

v_item_id               gb_pfsawh_item_dim.item_id%TYPE  := '';
v_nsn                   gb_pfsawh_item_dim.nsn%TYPE      := '';
v_niin                  gb_pfsawh_item_dim.niin%TYPE     := '';
   
BEGIN 

    DELETE gb_pfsawh_availability_t_fact;

    OPEN ei_avail_cur;
    
    LOOP
        FETCH ei_avail_cur 
        INTO  ei_avail_rec;
        
        EXIT WHEN ei_avail_cur%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE
            (
               'ei_sn ' || ei_avail_rec.sys_ei_sn 
            );
            
        IF ei_avail_rec.sys_ei_sn = 'AGGREGATE' THEN
        
            v_item_id := 0; 
            
        ELSIF ei_avail_rec.sys_ei_sn 
            IN (
               '17076V', '17087U', 'D5193L15036', 'DR57', 'JZ0859', 'L11034U', 
               'L15025', 'L150484', 'L150514', 'L15093UJZ07P6', 'L17035U', 
               'L17044U', 'LA25208U', 'LAZ25204U', 'LE70870' 
               ) THEN
        
            v_item_id := -1; 
            
        ELSE  
            
            SELECT MAX(nsn)
            INTO   v_nsn 
            FROM   gcssa_hr_asset@pfsawh.lidbdev item
            WHERE  item.serial_num = ei_avail_rec.sys_ei_sn; 
            
            SELECT item_id
            INTO   v_item_id 
            FROM   gb_pfsawh_item_dim 
            WHERE  nsn = v_nsn; 
            
        END IF;
        
        INSERT INTO gb_pfsawh_availability_t_fact 
            (
            availability_item_id ,
            availability_date_id ,
            availability_time_from ,
            availability_time_to , 
            availability_mc_flag
            ) 
            VALUES 
            (
            v_item_id, 
            1, 
            1, 
            1, 
            CASE  
                WHEN ei_avail_rec.mc_hrs > 0 THEN 'Y'
                ELSE 'N'
            END
            );
    
    END LOOP;
    
    CLOSE ei_avail_cur;
    
    DBMS_OUTPUT.ENABLE(1000000);
    
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
    
END;  
    
-- COMMIT    

/*

SELECT item.lin, item.gen_nomen, 
    t_fact.*, 
    ' | ',
    item.*  
FROM   gb_pfsawh_availability_t_fact t_fact, 
       gb_pfsawh_item_dim item 
WHERE t_fact.availability_item_id = item.item_id  (+); 

*/

/* 

SELECT * 
FROM   pfsa_equip_avail@pfsawh.lidbdev ei
WHERE  sys_ei_niin LIKE 'F%' 
ORDER BY pfsa_item_id, from_dt 

SELECT ei.* 
FROM   pfsa_sn_ei@pfsawh.lidbdev ei

SELECT sn.pot_sys_ei_niin, 
    sn.pot_sys_ei_sn, 
    sn.source_id, 
    sn.act_sys_ei_niin, 
    sn.act_sys_ei_sn, 
    sn.status, 
    sn.lst_updt, 
    sn.updt_by, 
    sn.create_dt, 
    sn.created_by, 
    sn.processed_dt  
--    , ' | ', 
--    sn.* 
FROM   potential_pfsa_sn_ei@pfsawh.lidbdev sn 
ORDER BY sn.pot_sys_ei_sn 

SELECT item.niin , ' | ',
    ei.* 
FROM   gb_pfsawh_item_dim item, 
       potential_pfsa_sys_ei@pfsawh.lidbdev ei 
WHERE ei.lin =  item.lin 
ORDER BY ei.sys_ei_niin 

SELECT * 
FROM   gcssa_hr_asset@pfsawh.lidbdev 
WHERE  serial_num = 'LA20097U'

*/ 

