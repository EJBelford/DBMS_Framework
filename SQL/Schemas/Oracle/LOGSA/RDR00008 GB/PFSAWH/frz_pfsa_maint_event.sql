/*----- Sequence  -----*/

DROP SEQUENCE frz_pfsa_maint_event_seq;

CREATE SEQUENCE frz_pfsa_maint_event_seq
    START WITH 1
    MINVALUE   1
--    MAXVALUE   9999999 
    NOCYCLE
    NOCACHE
    NOORDER; 

DROP TABLE frz_pfsa_equip_avail;
    
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--         NAME: frz_pfsa_maint_event 
--      PURPOSE: To calculate the desired information.
--
-- TABLE SOURCE: frz_pfsa_maint_event.sql 
--
--   CREATED BY: Gene Belford 
-- CREATED DATE: 11 April 2008 
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
-- 11APR08 - GB  -          -      - Created 
--
/*--*----|----*----|----*----|---- TEAM ITSS ----*----|----|----*----|----*---*/
--
--
CREATE TABLE frz_pfsa_maint_event
(
    rec_id                           NUMBER              NOT NULL, 
    source_rec_id                    NUMBER              DEFAULT  0, 
---    
    pba_id                           NUMBER              NOT NULL, 
    phyiscal_item_id                 NUMBER              DEFAULT  0,
    phyiscal_item_sn_id              NUMBER              DEFAULT  0,
    force_unit_id                    NUMBER              DEFAULT  0,
    mimosa_item_sn_id                VARCHAR2(8)         DEFAULT '00000000',
--    
    MAINT_EV_ID                      VARCHAR2(40)        NOT NULL,
    MAINT_ORG                        VARCHAR2(32),
    MAINT_UIC                        VARCHAR2(6),
    MAINT_LVL_CD                     VARCHAR2(1),
    MAINT_ITEM                       VARCHAR2(37),
    MAINT_ITEM_NIIN                  VARCHAR2(9),
    MAINT_ITEM_SN                    VARCHAR2(32),
    NUM_MAINT_ITEM                   NUMBER,
    SYS_EI_NIIN                      VARCHAR2(9),
    SYS_EI_SN                        VARCHAR2(32),
    NUM_MI_NRTS                      NUMBER,
    NUM_MI_RPRD                      NUMBER,
    NUM_MI_CNDMD                     NUMBER,
    NUM_MI_NEOF                      NUMBER,
    DT_MAINT_EV_EST                  DATE,
    DT_MAINT_EV_CMPL                 DATE,
    SYS_EI_NMCM                      VARCHAR2(1),
    PHASE_EV                         VARCHAR2(1),
    SOF_EV                           VARCHAR2(1),
    ASAM_EV                          VARCHAR2(1),
    MWO_EV                           VARCHAR2(1),
    ELAPSED_ME_WK_TM                 NUMBER,
    SOURCE_ID                        VARCHAR2(20),
    HEIR_ID                          VARCHAR2(20),
    PRIORITY                         NUMBER,
    CUST_ORG                         VARCHAR2(32),
    CUST_UIC                         VARCHAR2(6),
--    
    STATUS                           VARCHAR2(1),
    LST_UPDT                         DATE,
    UPDT_BY                          VARCHAR2(30),
--
--    active_flag                      VARCHAR2(1)         DEFAULT 'I' , 
--    active_date                      DATE                DEFAULT '01-JAN-1900' , 
--    inactive_date                    DATE                DEFAULT '31-DEC-2099' ,
--
    insert_by                        VARCHAR2(20)        DEFAULT USER , 
    insert_date                      DATE                DEFAULT SYSDATE , 
    update_by                        VARCHAR2(20)        NULL ,
    update_date                      DATE                DEFAULT '01-JAN-1900' ,
    delete_flag                      VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                      DATE                DEFAULT '01-JAN-1900' ,
    hidden_flag                      VARCHAR2(1)         DEFAULT 'Y' ,
    hidden_date                      DATE                DEFAULT '01-JAN-1900'  
)
TABLESPACE ECPTBS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1536K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE frz_pfsa_maint_event 
IS 'FRZ_PFSA_MAINT_EVENT - All maintenance data in the PFSA World is tied to a specific maintenance event.  This table documents all maintenance events.  Maintenance events are assumed to be tied to a specific instance of a system/end item.';


COMMENT ON COLUMN frz_pfsa_maint_event.rec_id 
IS 'REC_ID - Primary, blind key of the pfsawh_item_sn_p_fact table.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.source_rec_id 
IS 'SOURCE_REC_ID - Identifier to the orginial record received from the outside source.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.pba_id 
IS 'PBA_ID - PFSAW identitier for a particular Performance Based Agreement.'; 
 
COMMENT ON COLUMN frz_pfsa_maint_event.phyiscal_item_id 
IS 'PHYSICAL_ITEM_ID - Foreign key of the PFSAWH_ITEM_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.phyiscal_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - Foreign key of the PFSAWH_ITEM_SN_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.force_unit_id 
IS 'FORCE_UNIT_ID - Foreign key of the PFSAWH_FORCE_UNIT_DIM table.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number.  HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN frz_pfsa_maint_event.NUM_MI_NRTS 
IS 'NUM_MI_NRTS - The number of maintenance items which were not repairable this station.';

COMMENT ON COLUMN frz_pfsa_maint_event.NUM_MI_RPRD 
IS 'NUM_MI_RPRD - The number of maintenance items which were repaired in the maintenance event.';

COMMENT ON COLUMN frz_pfsa_maint_event.NUM_MI_CNDMD 
IS 'NUM_MI_CNDMD - The number of maintenance items which were condemned during the maintenance event.';

COMMENT ON COLUMN frz_pfsa_maint_event.NUM_MI_NEOF 
IS 'NUM_MI_NEOF - The number of maintenance items where no evidence of failure could be found.';

COMMENT ON COLUMN frz_pfsa_maint_event.DT_MAINT_EV_EST 
IS 'DT_MAINT_EV_EST - The date/time stamp of when the maintenance event was established.';

COMMENT ON COLUMN frz_pfsa_maint_event.DT_MAINT_EV_CMPL 
IS 'DT_MAINT_EV_CMPL - The date/time stamp of when the maintenance event was completed/closed.';

COMMENT ON COLUMN frz_pfsa_maint_event.SYS_EI_NMCM 
IS 'SYS_EI_NMCM - A flag identifying the system/end item was not mission capabile for some portion of the mainteannce event.  Values are Y or N.';

COMMENT ON COLUMN frz_pfsa_maint_event.PHASE_EV 
IS 'PHASE_EV - A flag used in PFSA to identify phased maintenance events for aircraft.  values are Y, N, U (unknown, but aircraft) and null, for not applicable.';

COMMENT ON COLUMN frz_pfsa_maint_event.SOF_EV 
IS 'SOF_EV - A flag indicating a Safety of Flight (SOF) event.  Values of Y or N';

COMMENT ON COLUMN frz_pfsa_maint_event.ASAM_EV 
IS 'ASAM_EV - A flag indicating an Aviation safety Action Message (ASAM) event.  Used to quickly alert field to potential/pending safety issues with aircraft and/or components.  Values are Y or N';

COMMENT ON COLUMN frz_pfsa_maint_event.MWO_EV 
IS 'MWO_EV - A flag indicating an Modification Work Order(MWO) event.  Values are Y or N';

COMMENT ON COLUMN frz_pfsa_maint_event.ELAPSED_ME_WK_TM 
IS 'ELAPSED_ME_WK_TM - The total elapsed time during the maintenance event when work was being performed, when available from the data source.';

COMMENT ON COLUMN frz_pfsa_maint_event.SOURCE_ID 
IS 'SOURCE_ID - The PFSA maintained identification for the source of the data';

COMMENT ON COLUMN frz_pfsa_maint_event.HEIR_ID 
IS 'HEIR_ID - A PFSA generated identification used to ensure heirarchical data source integrity is maintained.';

COMMENT ON COLUMN frz_pfsa_maint_event.PRIORITY 
IS 'PRIORITY - The relative prioirty of the data source.  Care should be taken to leave gaps in numbers to ensure additions can be made later.  The lower the number, the higher the priority.';

COMMENT ON COLUMN frz_pfsa_maint_event.CUST_ORG 
IS 'CUST_ORG - The customer organization orginating the maintenance event.';

COMMENT ON COLUMN frz_pfsa_maint_event.CUST_UIC 
IS 'CUST_UIC - The uic which owns the equipment.';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_EV_ID 
IS 'MAINT_EV_ID - A PFSA generated key used to accomodate the multiple sources of maintenance data used in the metrics.  The structure used to build the key is dependent on the source.  LIDB maintenance data is a concatenation of the won and accept_dt.  AMAC source data is a concatenation of mwo and ac_serial_number';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_ORG 
IS 'MAINT_ORG - The organization accomplishing the maintenance event.  If a UIC, the value will match the maint_uic.  Field used to identify manufacturer/non-UIC identified contractor maintenance';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_UIC 
IS 'MAINT_UIC - The UIC provided by the STAMIS system for the Maintenance Event';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_LVL_CD 
IS 'MAINT_LVL_CD - MAINTENANCE LEVEL CODE - A code assigned to support items to indicate the lowest maintenance level authorized to remove and replace the support item and the lowest maintenance level authorized to completely repair the support item.  The following codes are valid:  O - Organizational maintenance (AVUM); F - Direct support maintenance (AVIM); H - General support maintenance; D - Depot maintenance; C - Crew; L - Special repair activity.  Publications: [(MIL-STD-1388-2B 28 MARCH 1991) C -- Operator/Crew/Unit-Crew.  O -- Organizational/On Equipment/Unit-Organizational.  F -- Intermediate/Direct Support/Afloat/Third Echelon/Off Equipment/Intermediate-Forward.  H -- Intermediate/General Support/Ashore\Fourth Echelon/Intermediate-Rear.  G -- Intermediate/Ashore and Afloat.  D -- Depot/Shipyards.  L -- Specialized Repair Activity.]  [(DA PAM 731-751 15 MARCH 1999) O -- Aviation Unit Maintenance (AVUM), F -- Aviation Intermediate Maintenance (AVIM), D -- Depot, K -- Contractor, L -- Special Repair Activity.] Codes that are assigned to indicate the maintenance levels authorized to perform the required maintenance function (see DED 277 for definitions of the individual O/M Levels).  C -- Operator/Crew/Unit-Crew.  O -- Organizational/On Equipment/Unit-Organizational.  F -- Intermediate/Direct Support/Afloat/Third Echelon/Off quipment/Intermediate-Forward.  H -- Intermediate/General Support/Ashore\Fourth Echelon/Intermediate-Rear.  G -- Intermediate/Ashore and Afloat.  D -- Depot/Shipyards.  L -- Specialized Repair Activity';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_ITEM 
IS 'MAINT_ITEM - The item maintenance is being performed on';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_ITEM_NIIN 
IS 'MAINT_ITEM_NIIN - The niin of the item maintenance is being performed on.';

COMMENT ON COLUMN frz_pfsa_maint_event.MAINT_ITEM_SN 
IS 'MAINT_ITEM_SN - The serial number of the specific item maintenance is being performed on.';

COMMENT ON COLUMN frz_pfsa_maint_event.NUM_MAINT_ITEM 
IS 'NUM_MAINT_ITEM - The number of items identified for the maintenance action.  Frequently 1.';

COMMENT ON COLUMN frz_pfsa_maint_event.SYS_EI_NIIN 
IS 'SYS_EI_NIIN - The system\end item niin to which the maintenance event is tied to.  All maintenance events in the PFSA world are tied to a specific system end item type.';

COMMENT ON COLUMN frz_pfsa_maint_event.SYS_EI_SN 
IS 'SYS_EI_SN - The serial number of the system end item which the maintenance event is tied to.  Can be aggregated.';

COMMENT ON COLUMN frz_pfsa_maint_event.STATUS 
IS 'STATUS - The status of the record.  Values are Q/R/P or D';

COMMENT ON COLUMN frz_pfsa_maint_event.LST_UPDT 
IS 'LST_UPDT - The date/time stamp the record was last updated';

COMMENT ON COLUMN frz_pfsa_maint_event.UPDT_BY 
IS 'UPDT_BY - Who/what updated the record.';

--COMMENT ON COLUMN frz_pfsa_maint_event.active_flag 
--IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';

--COMMENT ON COLUMN frz_pfsa_maint_event.active_date 
--IS 'ACTIVE_DATE - Additional control for active_Fl indicating when the record became active.';

--COMMENT ON COLUMN frz_pfsa_maint_event.inactive_date 
--IS 'INACTIVE_DATE - Additional control for active_Fl indicating when the record went inactive.';

COMMENT ON COLUMN frz_pfsa_maint_event.insert_by 
IS 'INSERT_BY - Reports who initially created the record.';

COMMENT ON COLUMN frz_pfsa_maint_event.insert_date 
IS 'INSERT_DATE - Reports when the record was initially created.';

COMMENT ON COLUMN frz_pfsa_maint_event.update_by 
IS 'UPDATE_BY - Reports who last updated the record.';

COMMENT ON COLUMN frz_pfsa_maint_event.update_date 
IS 'UPDATE_DATE - Reports when the record was last updated.';

COMMENT ON COLUMN frz_pfsa_maint_event.delete_flag 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';

COMMENT ON COLUMN frz_pfsa_maint_event.delete_date 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';

COMMENT ON COLUMN frz_pfsa_maint_event.hidden_flag 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';

COMMENT ON COLUMN frz_pfsa_maint_event.hidden_date 
IS 'HIDDEN_DATE - Addition control for HIDDEN_FLAG indicating when the record was hidden.';

/*----- Check to see if the table comment is present -----*/

SELECT table_name, comments 
FROM   user_tab_comments 
WHERE  table_name = UPPER('frz_pfsa_maint_event'); 

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
LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('frz_pfsa_maint_event') 
    AND  a.column_name = b.column_name
WHERE    a.table_name = UPPER('frz_pfsa_maint_event') 
ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

SELECT a.* 
FROM   lidb_cmnt@pfsawh.lidbdev a
WHERE  a.col_name LIKE UPPER('%UIC%')
ORDER BY a.col_name;  
   
SELECT a.* 
FROM   user_col_comments a
WHERE  a.column_name LIKE UPPER('%UIC%'); 
   

/*----- Constraints - Primary Key -----*/ 

ALTER TABLE frz_pfsa_maint_event  
    DROP CONSTRAINT pk0_frz_pfsa_maint_event;        

ALTER TABLE frz_pfsa_maint_event  
    ADD CONSTRAINT pk0_frz_pfsa_maint_event 
    PRIMARY KEY 
    (
    rec_id
    );    


/*----- Non Foreign Key Constraints -----*/ 

ALTER TABLE frz_pfsa_maint_event 
    ADD (   CONSTRAINT pk_frz_pfsa_maint_event
            UNIQUE
            (
            MAINT_EV_ID
            )
            USING INDEX 
            TABLESPACE ECPTBSNDX
            PCTFREE    10
            INITRANS   2
            MAXTRANS   255
            STORAGE    (
                        INITIAL          4584K
                        NEXT             1M
                        MINEXTENTS       1
                        MAXEXTENTS       UNLIMITED
                        PCTINCREASE      0
                       )
        );


/*----- Indexs -----*/

CREATE UNIQUE INDEX idu_frz_pfsa_maint_event 
    ON frz_pfsa_maint_event
        (
        MAINT_EV_ID
        )
    LOGGING
    TABLESPACE ECPTBSNDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          2M
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
                BUFFER_POOL      DEFAULT
               )
    NOPARALLEL;

/*----- Create the Trigger now -----*/


/*----- Synonyms -----*/   

CREATE PUBLIC SYNONYM frz_pfsa_maint_event FOR pfsawh.pfsawh_force_unit_dim; 

/*----- Grants-----*/

GRANT SELECT ON frz_pfsa_maint_event TO LIW_BASIC; 

GRANT SELECT ON frz_pfsa_maint_event TO LIW_RESTRICTED; 

GRANT SELECT ON frz_pfsa_maint_event TO S_PFSAW; 

-- GRANT SELECT ON frz_pfsa_maint_event TO MD2L043; 

-- GRANT SELECT ON frz_pfsa_maint_event TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON frz_pfsa_maint_event TO S_PBUSE; 

-- GRANT SELECT ON frz_pfsa_maint_event TO S_WEBPROP; 

GRANT SELECT ON frz_pfsa_maint_event TO C_PFSAW; 


/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR code_cur IS
        SELECT a.xx_ID, a.xx_DESCRIPTION
        FROM xx_pfsawh_blank_dim a
        ORDER BY a.catcode;
        
    code_rec    code_cur%ROWTYPE;
        
BEGIN 

    SELECT 
    DISTINCT sys_ei_niin 
    FROM   pfsa_maint_event; 
    
    SELECT ir.pba_id, pme.* 
    FROM   bld_pfsa_maint_event pme, 
           pfsa_pba_items_ref ir 
    WHERE  pme.sys_ei_niin = ir.item_type_value 
    ORDER BY pme.sys_ei_sn;
    
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

SELECT * FROM frz_pfsa_maint_event; 

*/
