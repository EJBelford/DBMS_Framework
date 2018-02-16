/*--*----|----*----|----*----|---- TEAM ITSS ----|----*----|----*----|----*---*/
--
--         NAME: cbmwh_item_sn_dim 
--      PURPOSE: A major grouping End Items.  
--
-- TABLE SOURCE: cbmwh_item_sn_dim.sql 
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

-- DROP TABLE cbmwh_item_sn_dim;

CREATE TABLE cbmwh_item_sn_dim
(
    rec_id                        NUMBER              NOT NULL,
    physical_item_id              NUMBER              NOT NULL ,  
    item_niin                     VARCHAR2(9)         NOT NULL ,  
    physical_item_sn_id           NUMBER              DEFAULT 0,
    item_serial_number            VARCHAR2(48)        DEFAULT '-1' ,    
    item_sn_w_dashes              VARCHAR2(48),
    item_sn_wo_dashes             VARCHAR2(48),
--    
    mimosa_enterprise_id          VARCHAR2(8)         DEFAULT '00000430' NOT NULL,
    mimosa_site_id                VARCHAR2(8)         DEFAULT '00000001' NOT NULL,
    mimosa_item_sn_id             VARCHAR2(8)         DEFAULT '00000000' , 
--  
    item_registration_num         VARCHAR2(30)        DEFAULT 'UNK' , 
    item_location                 VARCHAR2(4)         DEFAULT '-1' ,  
    item_location_id              NUMBER              DEFAULT '-1' ,  
    item_uic                      VARCHAR2(6)         DEFAULT '-1' , 
    item_force_unit_id            NUMBER              DEFAULT '-1' ,  
    item_uic_location             VARCHAR2(4)         DEFAULT '-1' , 
    force_parent_unit_code        VARCHAR2(6),
    force_parent_unit_id          NUMBER              DEFAULT 0,
    force_command_unit_code       VARCHAR2(6),
    force_command_unit_id         NUMBER              DEFAULT 0,
    item_acq_date                 DATE                DEFAULT '01-JAN-1950',  
    item_acq_date_id              NUMBER              DEFAULT '-1' ,  
    item_notes                    VARCHAR2(255) , 
--  
    item_army_type_designator     VARCHAR2(30),
    item_manufacturer             VARCHAR2(30),
    item_manufacturer_cd          VARCHAR2(6),
    item_manufactured_date        DATE,      
    item_manufactured_date_id     NUMBER              DEFAULT '-1' ,      
    oem_mimosa_enterprise_id      VARCHAR2(8)         DEFAULT '00000000' NOT NULL,
    oem_mimosa_site_id            VARCHAR2(8)         DEFAULT '00000000' NOT NULL,
    oem_mimosa_item_sn_id         VARCHAR2(8)         DEFAULT '00000000' NOT NULL, 
--     
    status                        VARCHAR2(1)         DEFAULT 'I' ,
    lst_updt                      DATE                DEFAULT SYSDATE ,
    updt_by                       VARCHAR2(30)        DEFAULT USER ,
--
    active_flag                   VARCHAR2(1)         DEFAULT 'I' , 
    active_date                   DATE                DEFAULT '01-JAN-1900' , 
    inactive_date                 DATE                DEFAULT '31-DEC-2099' , 
--  
    wh_data_source                VARCHAR2(25) ,
    wh_effective_date             DATE ,
    wh_expiration_date            DATE ,
    wh_last_update_date           DATE                DEFAULT '01-JAN-1900' ,
    wh_record_status              VARCHAR2(10) ,
    wh_flag                       VARCHAR2(1)         DEFAULT 'N',
    wh_earliest_fact_rec_dt       DATE,
    wh_earliest_fact_rec_source   VARCHAR2(65),
--
    source_rec_id                 NUMBER              DEFAULT 0 ,
    insert_by                     VARCHAR2(30)        DEFAULT USER , 
    insert_date                   DATE                DEFAULT SYSDATE , 
    lst_update_rec_id             NUMBER              DEFAULT 0 ,
    update_by                     VARCHAR2(30)        NULL ,
    update_date                   DATE                DEFAULT '01-JAN-1900' ,
    delete_by                     VARCHAR2(30)        NULL ,
    delete_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    delete_date                   DATE                DEFAULT '01-JAN-1900' ,
    hidden_by                     VARCHAR2(30)        NULL ,
    hidden_flag                   VARCHAR2(1)         DEFAULT 'N' ,
    hidden_date                   DATE                DEFAULT '01-JAN-1900'  
)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          32M
            NEXT             4M
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

/*----- Table Meta-Data -----*/ 
    
COMMENT ON TABLE cbmwh_item_sn_dim 
IS 'CBMWH_ITEM_SN_DIM - This table contains the serial numbered items in the PFSA world.  It therefore reflects the current information from the PFSA_SN_EI_HIST table  and other sources. It is populated and controlled by TBD process.'; 

    
COMMENT ON COLUMN cbmwh_item_sn_dim.rec_id 
IS 'REC_ID - Sequence/identity for dimension.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.physical_item_sn_id 
IS 'PHYSICAL_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number as represented in the cbmwh_ITEM_SN_DIM.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.mimosa_item_sn_id 
IS 'MIMOSA_ITEM_SN_ID - PFSAWH identitier for item/part for a particular serial number/tail number. HEX version of the PHYSICAL_ITEN_SN_ID for use with the MIMOSA standard.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_serial_number 
IS 'ITEM_SERIAL_NUMBER - Serial number of the item.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.physical_item_id 
IS 'PHYSICAL_ITEM_ID - LIW/PFSAWH identitier for the item/part as represented in the cbmwh_ITEM_DIM.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_niin 
IS 'ITEM_NIIN - National Item Identification Number for the item/part.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_registration_num 
IS 'ITEM_REGISTRATION_NUM - REGISTRATION NUMBER - The U.S. Army Registration (Serial) Number.  A combination of numbers and letters assigned in a unique manner to each item of vehicular equipment for ready identification and control during the item''s service life.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_location 
IS 'ITEM_LOCATION - LOCATION - Identifies the location as CONUS (Continental United States) or OCONUS (Outside the Continental United States).'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_location_id 
IS 'ITEM_LOCATION_ID - LOCATION - Identifies the location as CONUS (Continental United States) or OCONUS (Outside the Continental United States) as represented in the cbmwh_LOCATION_DIM.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_uic 
IS 'ITEM_UIC - FORCE UIC - The unit identifier of valid Force UICs.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_force_unit_id 
IS 'ITEM_FORCE_UNIT_ID - FORCE UIC - The unit identifier of valid Force UICs as represented in the cbmwh_FORCE_unit_DIM.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_uic_location 
IS 'ITEM_UIC_LOCATION - Force location'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_acq_date 
IS 'ITEM_ACQ_DATE - ACQUISITION DATE - Indicates the date an item was acquired.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_acq_date_id 
IS 'ITEM_ACQ_DATE_ID - ACQUISITION DATE - Indicates the date an item was acquired as represented by the cbmwh_DATE_DIM.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_notes 
IS 'ITEM_NOTES - This will be NULL if the record is good.  Records information about the record error.'; 

COMMENT ON COLUMN cbmwh_item_sn_dim.item_army_type_designator 
IS 'ITEM_ARMY_TYPE_DESIGNATOR - Model number';

COMMENT ON COLUMN cbmwh_item_sn_dim.item_manufacturer 
IS 'ITEM_MANUFACTURER - MANUFACTURER - Identifies the manufacturer of the item.';

COMMENT ON COLUMN cbmwh_item_sn_dim.item_manufacturer_cd 
IS 'ITEM_MANUFACTURER_CD - MANUFACTURER - Identifies the manufacturer of the item.';

COMMENT ON COLUMN cbmwh_item_sn_dim.item_manufactured_date 
IS 'ITEM_MANUFACTURED_DATE - The date the item was manufactuerd.';

COMMENT ON COLUMN cbmwh_item_sn_dim.item_manufactured_date_id 
IS 'ITEM_MANUFACTURED_DATE_ID - The date the item was manufactuerd as represented by the cbmwh_DATE_DIM.';

COMMENT ON COLUMN cbmwh_item_sn_dim.status 
IS 'STATUS - The Extract-Transform-Load (ETL) status of the record in question.  [C - Current, D - Duplicate, E - Error, H - Historical, L - Logical, P - Processed, Q - Questionable, R - Ready to Process, T- ?????, Z - Future]';

COMMENT ON COLUMN cbmwh_item_sn_dim.updt_by 
IS 'UPDT_BY - The date/timestamp of when the record was created/updated.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.lst_updt 
IS 'LST_UPDT - Indicates either the program name or user ID of the person who updated the record.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.active_flag 
IS 'ACTIVE_FLAG - Flag indicating if the record is active or not.';
   
COMMENT ON COLUMN cbmwh_item_sn_dim.active_date 
IS 'ACTIVE_DATE - Additional control for active_Flag indicating when the record became active.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.INACTIVE_DATE 
IS 'INACTIVE_DATE - Additional control for active_Flag indicating when the record went inactive.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.source_rec_id 
IS 'SOURCE_REC_ID - ';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.INSERT_BY 
IS 'INSERT_BY - Reports who initially created the record.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.INSERT_DATE 
IS 'INSERT_DATE - Reports when the record was initially created.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.LST_UPDATE_REC_ID 
IS 'LST_UPDATE_REC_ID - ';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.UPDATE_BY 
IS 'UPDATE_BY - Reports who last updated the record.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.UPDATE_DATE 
IS 'UPDATE_DATE - Reports when the record was last updated.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.DELETE_FLAG 
IS 'DELETE_FLAG - Flag indicating if the record can be deleted.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.DELETE_DATE 
IS 'DELETE_DATE - Additional control for DELETE_FLAG indicating when the record was marked for deletion.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.HIDDEN_FLAG 
IS 'HIDDEN_FLAG - Flag indicating if the record should be hidden from the general user in things like drop-down lists.';
    
COMMENT ON COLUMN cbmwh_item_sn_dim.HIDDEN_DATE 
IS 'HIDDEN_DATE - Additional control for HIDDEN_FLAG indicating when the record was hidden.';

COMMENT ON COLUMN cbmwh_item_sn_dim.wh_data_source 
IS 'WH_DATA_SOURCE - '; 

COMMENT ON COLUMN cbmwh_item_sn_dim.wh_effective_date 
IS 'WH_EFFECTIVE_DATE - ';  

COMMENT ON COLUMN cbmwh_item_sn_dim.wh_expiration_date 
IS 'WH_EXPIRATION_DATE - '; 

COMMENT ON COLUMN cbmwh_item_sn_dim.wh_last_update_date 
IS 'WH_LAST_UPDATE_DATE - '; 

COMMENT ON COLUMN cbmwh_item_sn_dim.wh_record_status 
IS 'WH_RECORD_STATUS - '; 
    
/*----- Check to see if the table comment is present -----*/
    
-- SELECT table_name, comments 
-- FROM   user_tab_comments 
-- WHERE  table_name = UPPER('cbmwh_item_sn_dim'); 
    
/*----- Check to see if the table column comments are present -----*/
    
-- SELECT b.column_id, 
--     a.table_name, 
--     a.column_name, 
--     b.data_type, 
--     b.data_length, 
--     b.nullable, 
--     a.comments 
-- FROM user_col_comments a
-- LEFT OUTER JOIN user_tab_columns b ON b.table_name = UPPER('cbmwh_item_sn_dim') 
--     AND a.column_name = b.column_name
-- WHERE a.table_name = UPPER('cbmwh_item_sn_dim') 
-- ORDER BY b.column_id; 

/*----- Look-up field description from master LIDB table -----*/

-- SELECT a.* 
-- FROM   lidb_cmnt@pfsawh.lidbdev a
-- WHERE  a.col_name LIKE UPPER('%MANUFACTURER%')
-- ORDER BY a.col_name; 
   
-- SELECT a.* 
-- FROM   user_col_comments a
-- WHERE  a.column_name LIKE UPPER('%MANUFACTURER%'); 
   
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 Populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/

/*

MERGE 
INTO cbmwh_item_sn_dim cisd
USING (
    SELECT 
        rec_id,
        item_serial_number,
        item_niin,
        item_registration_num,
        item_location,
        item_uic,
        item_uic_location,
        item_soc_flag,
        item_acq_date,
        item_notes,
        status,
        lst_updt,
        updt_by,
        active_flag,
        active_date,
        inactive_date,
        insert_by,
        insert_date,
        update_by,
        update_date,
        delete_flag,
        delete_date,
        hidden_flag,
        hidden_date,
        physical_item_id,
        physical_item_sn_id,
        item_location_id,
        item_force_id,
        item_army_type_designator,
        item_manufacturer,
        item_manufacturer_cd,
        item_manufactured_date,
        item_manufactured_date_id,
        mimosa_item_sn_id,
        wh_flag,
        wh_earliest_fact_rec_dt,
        wh_earliest_fact_rec_source,
        force_parent_unit_code,
        force_parent_unit_id,
        force_command_unit_code,
        force_command_unit_id,
        item_sn_w_dashes,
        item_sn_wo_dashes,
        mimosa_enterprise_id,
        mimosa_site_id,
        oem_mimosa_enterprise_id,
        oem_mimosa_site_id,
        oem_mimosa_item_sn_id 
    FROM pfsawh.pfsawh_item_sn_dim) pisd 
    ON ( 
--       cisd.rec_id = pisd.rec_id AND 
       cisd.physical_item_sn_id = pisd.physical_item_sn_id
       )
    WHEN MATCHED THEN 
        UPDATE
        SET -- cisd.rec_id = pisd.rec_id,  
            cisd.physical_item_id = pisd.physical_item_id,  
            cisd.item_niin = pisd.item_niin,  
--            cisd.physical_item_sn_id = pisd.physical_item_sn_id,
            cisd.item_serial_number = pisd.item_serial_number,    
            cisd.item_sn_w_dashes = pisd.item_sn_w_dashes,
            cisd.item_sn_wo_dashes = pisd.item_sn_wo_dashes,
--    
            cisd.mimosa_enterprise_id = pisd.mimosa_enterprise_id,
            cisd.mimosa_site_id = pisd.mimosa_site_id,
            cisd.mimosa_item_sn_id = pisd.mimosa_item_sn_id, 
--  
            cisd.item_registration_num = pisd.item_registration_num, 
            cisd.item_location = pisd.item_location,  
            cisd.item_location_id = pisd.item_location_id,  
            cisd.item_uic = pisd.item_uic, 
            cisd.item_force_unit_id = pisd.item_force_id,  
            cisd.item_uic_location = pisd.item_uic_location, 
            cisd.force_parent_unit_code = pisd.force_parent_unit_code,
            cisd.force_parent_unit_id = pisd.force_parent_unit_id,
            cisd.force_command_unit_code = pisd.force_command_unit_code,
            cisd.force_command_unit_id = pisd.force_command_unit_id,
            cisd.item_acq_date = pisd.item_acq_date,  
--            cisd.item_acq_date_id = pisd.item_acq_date_id,  
            cisd.item_notes = pisd.item_notes, 
--  
            cisd.item_army_type_designator = pisd.item_army_type_designator,
            cisd.item_manufacturer = pisd.item_manufacturer,
            cisd.item_manufacturer_cd = pisd.item_manufacturer_cd,
            cisd.item_manufactured_date = pisd.item_manufactured_date,      
            cisd.item_manufactured_date_id = pisd.item_manufactured_date_id,      
            cisd.oem_mimosa_enterprise_id = pisd.oem_mimosa_enterprise_id,
            cisd.oem_mimosa_site_id = pisd.oem_mimosa_site_id,
            cisd.oem_mimosa_item_sn_id = pisd.oem_mimosa_item_sn_id,
--     
            cisd.status   = pisd.status,
            cisd.lst_updt = pisd.lst_updt,
            cisd.updt_by  = pisd.updt_by,
--
            cisd.active_flag                 = pisd.active_flag, 
            cisd.active_date                 = pisd.active_date, 
            cisd.inactive_date               = pisd.inactive_date, 
--  
--            cisd.wh_data_source              = pisd.wh_data_source,
--            cisd.wh_effective_date           = pisd.wh_effective_date,
--            cisd.wh_expiration_date          = pisd.wh_expiration_date,
--            cisd.wh_last_update_date         = pisd.wh_last_update_date,
--            cisd.wh_record_status            = pisd.wh_record_status,
            cisd.wh_flag                     = pisd.wh_flag,
            cisd.wh_earliest_fact_rec_dt     = pisd.wh_earliest_fact_rec_dt,
            cisd.wh_earliest_fact_rec_source = pisd.wh_earliest_fact_rec_source,
--
--            cisd.source_rec_id     = ,
            cisd.insert_by         = pisd.insert_by, 
            cisd.insert_date       = pisd.insert_date, 
--            cisd.lst_update_rec_id = pisd.lst_update_rec_id,
            cisd.update_by         = pisd.update_by,
            cisd.update_date       = pisd.update_date,
--            cisd.delete_by         = pisd.delete_by,
            cisd.delete_flag       = pisd.delete_flag,
            cisd.delete_date       = pisd.delete_date,
--            cisd.hidden_by         = pisd.hidden_by,
            cisd.hidden_flag       = pisd.hidden_flag,
            cisd.hidden_date       = pisd.hidden_date
    WHEN NOT MATCHED THEN 
        INSERT (    
--            rec_id,  
            physical_item_id,  
            item_niin,  
            physical_item_sn_id,
            item_serial_number,    
            item_sn_w_dashes,
            item_sn_wo_dashes,
--    
            mimosa_enterprise_id,
            mimosa_site_id,
            mimosa_item_sn_id, 
--  
            item_registration_num, 
            item_location,  
            item_location_id,  
            item_uic, 
            item_force_unit_id,  
            item_uic_location, 
            force_parent_unit_code,
            force_parent_unit_id,
            force_command_unit_code,
            force_command_unit_id,
            item_acq_date,  
--            item_acq_date_id,  
            item_notes, 
--  
            item_army_type_designator,
            item_manufacturer,
            item_manufacturer_cd,
            item_manufactured_date,      
            item_manufactured_date_id,      
            oem_mimosa_enterprise_id,
            oem_mimosa_site_id,
            oem_mimosa_item_sn_id,
--     
            status,
            lst_updt,
            updt_by,
--
            active_flag, 
            active_date, 
            inactive_date, 
--  
--            wh_data_source,
--            wh_effective_date,
--            wh_expiration_date,
--            wh_last_update_date,
--            wh_record_status,
            wh_flag,
            wh_earliest_fact_rec_dt,
            wh_earliest_fact_rec_source,
--
--            source_rec_id,
            insert_by, 
            insert_date, 
--            lst_update_rec_id,
            update_by,
            update_date,
--            delete_by,
            delete_flag,
            delete_date,
--            hidden_by,
            hidden_flag,
            hidden_date
            )
        VALUES (
--            pisd.rec_id,  
            pisd.physical_item_id,  
            pisd.item_niin,  
            pisd.physical_item_sn_id,
            pisd.item_serial_number,    
            pisd.item_sn_w_dashes,
            pisd.item_sn_wo_dashes,
--    
            pisd.mimosa_enterprise_id,
            pisd.mimosa_site_id,
            pisd.mimosa_item_sn_id, 
--  
            pisd.item_registration_num, 
            pisd.item_location,  
            pisd.item_location_id,  
            pisd.item_uic, 
            pisd.item_force_id,  
            pisd.item_uic_location, 
            pisd.force_parent_unit_code,
            pisd.force_parent_unit_id,
            pisd.force_command_unit_code,
            pisd.force_command_unit_id,
            pisd.item_acq_date,  
--            pisd.item_acq_date_id,  
            pisd.item_notes, 
--  
            pisd.item_army_type_designator,
            pisd.item_manufacturer,
            pisd.item_manufacturer_cd,
            pisd.item_manufactured_date,      
            pisd.item_manufactured_date_id,      
            pisd.oem_mimosa_enterprise_id,
            pisd.oem_mimosa_site_id,
            pisd.oem_mimosa_item_sn_id,
--     
            pisd.status,
            pisd.lst_updt,
            pisd.updt_by,
--
            pisd.active_flag, 
            pisd.active_date, 
            pisd.inactive_date, 
--  
--            pisd.wh_data_source,
--            pisd.wh_effective_date,
--            pisd.wh_expiration_date,
--            pisd.wh_last_update_date,
--            pisd.wh_record_status,
            pisd.wh_flag,
            pisd.wh_earliest_fact_rec_dt,
            pisd.wh_earliest_fact_rec_source,
--
--            pisd.source_rec_id,
            pisd.insert_by, 
            pisd.insert_date, 
--            pisd.lst_update_rec_id,
            pisd.update_by,
            pisd.update_date,
--            pisd.delete_by,
            pisd.delete_flag,
            pisd.delete_date,
--            pisd.hidden_by,
            pisd.hidden_flag,
            pisd.hidden_date
            );

COMMIT;

*/

