/* filename: C1018-10-0005 GCS_CLOE_RefDB_inserts_Step_5.sql  Control Point Corp. CM filename */

/***************************************************************/
/* Author: Control Point Corporation, Pilar Montes             */
/* CLOE Ground Combat System configuration of the MIMOSA CRIS  */
/* updated: 05/21/08                                           */
/* filename: C1018-10-0005 GCS_CLOE_RefDB_inserts_Step_5.sql   */
/***************************************************************/
/* Recieved enterprise values from Ken Bever 2/19/08. */  
/* Using ARMY enterprise, new user tag ident ARMY.MIL hex: 000003F9 */
/* 5/08/08 added segment types for Event Code Resolution.  These are the same as event types
because and resolution cluster is represented as a segment and events.*/
/* 05/21/08 add ev_num_data_type quantity on hand for supply advisory */

/* These are the LDB SV-11 configured reference database types. */

/**** Reference DB where segment_type will reside.  ***/
INSERT INTO enterprise(
enterprise_id,ent_db_site,ent_db_id,ent_type_code,user_tag_ident,name,
gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) 
VALUES (1017,'0000000000000000',2,5,'ARMY.MIL','United States Department of the Army',
to_date('08-OCT-2008'),'0000000000000000',2,1);

INSERT INTO site(site_code,enterprise_id,site_id,st_db_site,st_db_id,st_type_code,user_tag_ident,name,
template_yn,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) 
VALUES ('000003F900000001',1017,1,'0000000000000000',2,1,'US ARMY - LIA site','U.S. Army - Logistics Innovation Agency (LIA) site',
'N',to_date('21-FEB-2008'),'0000000000000000',2,1);

--/* This site database is used for the meta data for all ground systems */
--/* DELETE FROM site_database WHERE db_site = '000003F900000001'; -- too many FKs to work! */
INSERT INTO site_database(db_site,db_id,user_tag_ident,name,
gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) 
VALUES ('000003F900000001',1,'CLOE Configured Reference Database','CLOE Reference DB',sysdate,'000003F900000001',1,1);

/*********************/
/**** Alarm Type *****/
/*********************/
/* Used to set alarm regions */ 
DELETE FROM alarm_type WHERE al_db_site = '000003F900000001';
/* severity level type currently set to undetermined. 02/12/08 */
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'0000000000000000',0,0,'Consumable Threshold Advisory','Consumable Threshold Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'0000000000000000',0,0,'Usage Stress Threshold Advisory','Usage Stress Threshold Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'0000000000000000',0,0,'Calibration Threshold Advisory','Calibration Threshold Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,'0000000000000000',0,0,'PMCS Step','PMCS Step',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,5,'0000000000000000',0,0,'Influential Parameter','Influential Parameter',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,6,'0000000000000000',0,0,'Personnel Activity','Personnel Activity',sysdate,'000003F900000001',1,1);
INSERT INTO alarm_type (al_db_site,al_db_id, al_type_code,severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,7,'0000000000000000',0,0,'Driving Time Limit','Driving Time Limit',sysdate,'000003F900000001',1,1);

/**************/
/* asset type */
/**************/
/* used for solution package representation of IETM software. */
DELETE FROM asset_type_child WHERE as_db_site = '000003F900000001';
DELETE FROM asset_type WHERE as_db_site = '000003F900000001';
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'IETM Support','IETM Support',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'IETM Software','IETM Software',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Viewer','Viewer',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,'Engine Application','Engine Application',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,5,'GS Interface','GS Interface',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,6,'IETM Content Document Set','IETM Content Document Set',sysdate,'000003F900000001',1,1);
INSERT INTO asset_type(as_db_site,as_db_id,as_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,7,'IETM Content Document','IETM Content Document',sysdate,'000003F900000001',1,1);

/***************************/
/**** asset type child ****/
/**************************/
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'000003F900000001',1,2,sysdate,'000003F900000001',1,1);
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'000003F900000001',1,3,sysdate,'000003F900000001',1,1);
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'000003F900000001',1,4,sysdate,'000003F900000001',1,1);
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'000003F900000001',1,5,sysdate,'000003F900000001',1,1);
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'000003F900000001',1,6,sysdate,'000003F900000001',1,1);
INSERT INTO asset_type_child (as_db_site,as_db_id,as_type_code,child_as_db_site,child_as_db_id,child_as_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,'000003F900000001',1,7,sysdate,'000003F900000001',1,1);

/*********************/
/* blob content type */
/*********************/
DELETE FROM blob_content_type WHERE blct_db_site = '000003F900000001';
INSERT INTO blob_content_type(blct_db_site,blct_db_id,blc_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Interactive Electronic Technical Manual','Interactive Electronic Technical Manual',sysdate,'000003F900000001',1,1);
INSERT INTO blob_content_type(blct_db_site,blct_db_id,blc_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'Interactive Electronic Technical Manual, S1000D Format','Interactive Electronic Technical Manual, S1000D Format',sysdate,'000003F900000001',1,1);
INSERT INTO blob_content_type(blct_db_site,blct_db_id,blc_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Interactive Electronic Technical Manual, IADS Format','Interactive Electronic Technical Manual, IADS Format',sysdate,'000003F900000001',1,1);

/******************/
/* blob data type */
/******************/
DELETE FROM blob_data_type WHERE bd_db_site = '000003F900000001';
INSERT INTO blob_data_type(bd_db_site,bd_db_id,bd_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'S1000D Format','S1000D Format',sysdate,'000003F900000001',1,1);
INSERT INTO blob_data_type(bd_db_site,bd_db_id,bd_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'IADS Format','IADS Format',sysdate,'000003F900000001',1,1);

/********************/
/* data source type */
/********************/
DELETE FROM data_source_type WHERE ds_db_site = '000003F900000001';
INSERT INTO data_source_type(ds_db_site,ds_db_id,ds_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Calibration Data Source','Calibration Data Source',sysdate,'000003F900000001',1,1);
INSERT INTO data_source_type(ds_db_site,ds_db_id,ds_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'PMCS Step Data Source','PMCS Step Data Source',sysdate,'000003F900000001',1,1);

/*************************/
/**** Eng Unit Types *****/
/*************************/ 
DELETE FROM eng_unit_enum WHERE eu_db_site = '000003F900000001'; /* need to do this one first in delete. */

DELETE FROM eng_unit_type WHERE eu_db_site = '000003F900000001';
/* These are new engineering types that define eumerated value types. */
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,101,1,0,'Detection Method','Detection Method',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,101,1,0,'Active Status','Active Status',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,101,1,0,'Criticality','Criticality',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,101,1,0,'Resolution Status','Resolution Status',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,101,1,0,'Severity','Severity',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,101,1,0,'Combat Power Impact','Combat Power Impact',sysdate,'000003F900000001',1,1);
/* The following engineering unit types define enumerated values that are defined in Prime reference database.  They are REQUIRED in order to support attributes defined in the SV-11.
The template inserts to create the eng_unit_type are here.  The related enum insert template is below.
Change the site, db and code values.
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,101,1,0,'Effect Name','Effect Name',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,8,101,1,0,'Effect Description','Effect Description',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_type (eu_db_site,eu_db_id,eu_type_code,ru_type_code,mult_fact_to_ref,refer_off_to_ref,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,101,1,0,'COA','COA',sysdate,'000003F900000001',1,1);
*/

/************************/
/**** Eng Unit Enum *****/
/************************/ 
/* Detection Method */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,1,'Automated',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,2,'PMCS',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,3,'Manual',sysdate,'000003F900000001',1,1);
/* Active status */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,1,'Active',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,2,'Inactive',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,3,'Intermittent',sysdate,'000003F900000001',1,1);
/* Criticality */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,1,'Not Mission Capable',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,2,'Mission Capable with Major Deficiencies',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,3,'Mission Capable with Minor Deficiencies',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,4,'Full Strength',sysdate,'000003F900000001',1,1);
/* Resolution Status */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,1,'Unacknowledged',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,2,'Undeclared',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,3,'Unresolved',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,4,'Resolved',sysdate,'000003F900000001',1,1);
/* Severity */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,1,'Catastrophic',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,2,'Critical',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,3,'Marginal',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,4,'Minor',sysdate,'000003F900000001',1,1);
/* Combat power capability */
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,1,'Movement and Maneuver',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,2,'Fires',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,3,'Intelligence',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,4,'Sustainment',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,5,'Command and Control',sysdate,'000003F900000001',1,1);
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,6,'Protection',sysdate,'000003F900000001',1,1);

/* Effect name */
/* These are defined as part of the Prime Reference database. For example, effects for a ground system model series. */
/* Insert format example:  - change enterprise and site to Prime's database and type code.
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,1,'TBD: Effect name text',sysdate,'000003F900000001',1,1);
*/
/* Effect description */
/* These are defined as part of the Prime Reference database. For example, effect descriptions for a ground system model series. */
/* Insert format example:  - change enterprise and site to Prime's database and type code.
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,8,1,'TBD: Effect description text',sysdate,'000003F900000001',1,1);
*/
/* COA */
/* These are defined as part of the Prime Reference database. For example, COAs for a ground system model series. */
/* Insert format example:  - change enterprise and site to Prime's database and type code.
INSERT INTO eng_unit_enum (eu_db_site,eu_db_id,eu_type_code,data_value,data_name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,4,'TDB: COA text',sysdate,'000003F900000001',1,1);
*/

/****************************/
/**** Event Type Child ****/
/****************************/
/* event_type_child put after sg_as_event because of dependency */

/***************************/
/* event numeric data type */
/***************************/
DELETE FROM ev_num_data_type WHERE en_db_site = '000003F900000001';
INSERT INTO ev_num_data_type(en_db_site,en_db_id,en_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Event Status','Event Status',sysdate,'000003F900000001',1,1);
INSERT INTO ev_num_data_type(en_db_site,en_db_id,en_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'Operating Hours','Operating Hours',sysdate,'000003F900000001',1,1);
INSERT INTO ev_num_data_type(en_db_site,en_db_id,en_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Operating Miles','Operating Miles',sysdate,'000003F900000001',1,1);
/* 05/21/08 quantity on hand for supply advisory */
INSERT INTO ev_num_data_type(en_db_site,en_db_id,en_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,'Quantity on Hand','Quantity on Hand',sysdate,'000003F900000001',1,1);

/*****************************/
/* measurement location type */
/*****************************/
DELETE FROM meas_loc_type WHERE ml_db_site = '000003F900000001';
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Consumable Monitor','Consumable Monitor',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'Usage Stress Monitor','Usage Stress Monitor',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Time Based','Time Based',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,'Distance', 'Distance',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,5,'Operational Tempo','Operational Tempo',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,6,'Calibration','Calibration',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,7,'PMCS Step', 'PMCS Step',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,8,'Influential Parameter','Influential Parameter',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,9,'Personnel Activity','Personnel Activity',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,10,'Driving Time','Driving Time',sysdate,'000003F900000001',1,1);
INSERT INTO meas_loc_type(ml_db_site,ml_db_id,ml_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,11,'Correlated Symptom Data','Correlated Symptom Data',sysdate,'000003F900000001',1,1);

/*******************************/
/* measurement event blob type */
/*******************************/
DELETE FROM mevent_blob_type WHERE mebt_db_site = '000003F900000001';
INSERT INTO mevent_blob_type(mebt_db_site,mebt_db_id,meb_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Calibration Data Attachment','Calibration Data Attachment',sysdate,'000003F900000001',1,1);
INSERT INTO mevent_blob_type(mebt_db_site,mebt_db_id,meb_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'Influential Parameter Attachment','Influential Parameter Attachment',sysdate,'000003F900000001',1,1);
INSERT INTO mevent_blob_type(mebt_db_site,mebt_db_id,meb_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Correlated Symptom Data Attachment','Correlated Symptom Data Attachment',sysdate,'000003F900000001',1,1);

/****************************/
/**** CLOE Network Types ****/
/****************************/
DELETE FROM network_type WHERE nt_db_site = '000003F900000001';
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'Command and Control','Command and Control',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'Support Unit','Support Unit',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,'Property Unit','MTOE Property Unit',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'Unit Authorized Item','Unit Authorized Item',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,'Component','Component',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,'Consumable','Consumable',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,'Furnished Equipment','Furnished Equipment',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,8,'Personnel','Personnel',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,'Cargo','Cargo',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,10,'Capability','Capability',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,11,'Causal','Causal',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,12,'Report','Report',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,13,'CTIL','CTIL',sysdate,'000003F900000001',1,1);
INSERT INTO network_type(nt_db_site,nt_db_id,nt_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,14,'Crypto Controlled Item','Crypto Controlled Item',sysdate,'000003F900000001',1,1);

/*****************************/
/**** priority_level_type ****/
/*****************************/
DELETE FROM priority_level_type WHERE priority_lev_db_site ='000003F900000001'; 
INSERT INTO priority_level_type (priority_lev_db_site,priority_lev_db_id,priority_lev_type_code
,priority_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,1,100,'Highest','Highest',sysdate,'000003F900000001',1,1);
INSERT INTO priority_level_type (priority_lev_db_site,priority_lev_db_id,priority_lev_type_code
,priority_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,2,75,'High','High',sysdate,'000003F900000001',1,1);
INSERT INTO priority_level_type (priority_lev_db_site,priority_lev_db_id,priority_lev_type_code
,priority_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,3,50,'Moderate','Moderate',sysdate,'000003F900000001',1,1);
INSERT INTO priority_level_type (priority_lev_db_site,priority_lev_db_id,priority_lev_type_code
,priority_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,4,25,'Low','Low',sysdate,'000003F900000001',1,1);
INSERT INTO priority_level_type (priority_lev_db_site,priority_lev_db_id,priority_lev_type_code
,priority_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,5,0,'Lowest','Lowest',sysdate,'000003F900000001',1,1);
/* Can use 'Undetermined' in MIMOSA Reference database 0000000000000000,0 */

/****************************/
/**** CLOE Segment Types ****/
/****************************/
DELETE FROM segment_type_child WHERE sg_db_site = '000003F900000001';
DELETE FROM segment_type WHERE sg_db_site = '000003F900000001';
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'Army','Army',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'Corps','Corps',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,'Division','Division',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'Brigade','Brigade',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,'Battalion','Battalion',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,'Company','Company',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,'Platoon','Platoon',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,8,'Squad','Squad',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,'Ground System','Ground System',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,10,'Ground Combat System','Ground Combat System',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,11,'Ground Platform','Ground Platform',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,12,'Tactical Wheel Vehicle (TWV) System','Tactical Wheel Vehicle (TWV) System',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,13,'Component','Component',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,14,'Assembly','Assembly',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,15,'LRU','LRU',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,16,'SRU','SRU',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,17,'Software','Software',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'Consumable','Consumable',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,19,'Fuel ','Fuel ',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,20,'Ammunition','Ammunition',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,21,'Water','Water',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,22,'Rations','Rations',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,23,'Medical Supply','Medical Supply',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'Capability','Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,25,'Movement and Maneuver Capability','Movement and Maneuver Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,26,'Movement and Maneuver Subcapability','Movement and Maneuver Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,27,'Fires Capability','Fires Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,28,'Fires Subcapability','Fires Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,29,'Intelligence Capability','Intelligence Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,30,'Intelligence Subcapability','Intelligence Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,31,'Sustainment Capability','Sustainment Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,32,'Sustainment Subcapability','Sustainment Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,33,'Command and Control Capability','Command and Control Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,34,'Command and Control Subcapability','Command and Control Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,35,'Protection Capability','Protection Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,36,'Protection Subcapability','Protection Subcapability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,37,'Intrinsic Capability','Intrinsic Capability',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,38,'Fault','Fault',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,39,'Condition Advisory','Condition Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,40,'Supply Advisory','Supply Advisory',sysdate,'000003F900000001',1,1);
/* new 05/08/08 */
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,41,'Support Issue','Support',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,42,'Maint Issue','Maint',sysdate,'000003F900000001',1,1);
INSERT INTO segment_type( sg_db_site, sg_db_id,sg_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,43,'Supply Issue','Supply Issue',sysdate,'000003F900000001',1,1);

/****************************/
/**** Segment Type Child ****/
/****************************/
DELETE FROM segment_type_child WHERE sg_db_site = '000003F900000001';
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,'000003F900000001',1,10,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,'000003F900000001',1,12,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,10,'000003F900000001',1,11,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,13,'000003F900000001',1,14,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,14,'000003F900000001',1,15,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,15,'000003F900000001',1,16,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,15,'000003F900000001',1,17,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'000003F900000001',1,19,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'000003F900000001',1,20,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'000003F900000001',1,21,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'000003F900000001',1,22,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,18,'000003F900000001',1,23,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,25,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,25,'000003F900000001',1,26,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,27,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,27,'000003F900000001',1,28,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,29,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,29,'000003F900000001',1,30,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,31,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,31,'000003F900000001',1,32,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,33,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,33,'000003F900000001',1,34,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,24,'000003F900000001',1,35,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,35,'000003F900000001',1,36,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,37,'000003F900000001',1,38,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,37,'000003F900000001',1,39,sysdate,'000003F900000001',1,1);
INSERT INTO segment_type_child (sg_db_site,sg_db_id,sg_type_code,child_sg_db_site,child_sg_db_id,child_sg_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,37,'000003F900000001',1,40,sysdate,'000003F900000001',1,1);

/******************************/
/**** Severity Level Type *****/
/******************************/ 
/* MIMOSA ref DB values: Undetermined, Lowest to Highest Severity Levels. */
DELETE FROM severity_level_type WHERE severity_lev_db_site = '000003F900000001';
INSERT INTO severity_level_type (severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,severity_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,100,'Catastrophic','Catastrophic',sysdate,'000003F900000001',1,1);
INSERT INTO severity_level_type (severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,severity_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,75,'Critical','Critical',sysdate,'000003F900000001',1,1);
INSERT INTO severity_level_type (severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,severity_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,50,'Marginal','Marginal',sysdate,'000003F900000001',1,1);
INSERT INTO severity_level_type (severity_lev_db_site,severity_lev_db_id,severity_lev_type_code,severity_scale,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,25,'Minor','Minor',sysdate,'000003F900000001',1,1);

/*********************/
/**** Event Types ****/
/*********************/ 
DELETE FROM sg_as_event_type WHERE ev_db_site = '000003F900000001';
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'Informational','Informational',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,2,'Maint Check','Maint Check',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,3,'Calibration','Calibration',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,4,'Trigger Event','Trigger Event',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,5,'Maint Advisory','Maint Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,6,'Fault','Fault',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,7,'Supply Advisory','Supply Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,8,'Fuel Level Advisory','Fuel Level Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,9,'Ammo Level Advisory','Ammo Level Advisory',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,10,'Exception Condition','Exception Condition',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,11,'Support Issue','Support Issue',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,12,'Maint Issue','Maint Issue',sysdate,'000003F900000001',1,1);
INSERT INTO sg_as_event_type(ev_db_site,ev_db_id,event_type_code,name,user_tag_ident,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,13,'Supply Issue','Supply Issue',sysdate,'000003F900000001',1,1);

/**************************/
/**** Event Type Child ****/
/**************************/
DELETE FROM event_type_child WHERE ev_db_site = '000003F900000001';
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'000003F900000001',1,2,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'000003F900000001',1,3,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'000003F900000001',1,5,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'000003F900000001',1,6,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'000003F900000001',1,7,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,'000003F900000001',1,8,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,'000003F900000001',1,9,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'000003F900000001',1,10,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,11,'000003F900000001',1,12,sysdate,'000003F900000001',1,1);
INSERT INTO event_type_child (ev_db_site,ev_db_id,event_type_code,child_ev_db_site,child_ev_db_id,child_ev_type_code,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,11,'000003F900000001',1,13,sysdate,'000003F900000001',1,1);

/*********************************/
/**** Segment Char Data Types ****/
/*********************************/ 
DELETE FROM sg_chr_dat_type WHERE sc_db_site = '000003F900000001';
INSERT INTO sg_chr_dat_type(sc_db_site, sc_db_id, sc_type_code,name,user_tag_ident,default_ru_type, gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'Resolution','Resolution',100,sysdate,'000003F900000001',1,1);
INSERT INTO sg_chr_dat_type(sc_db_site, sc_db_id, sc_type_code,name,user_tag_ident,default_ru_type, gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'Receipt Description','Receipt Description',100,sysdate,'000003F900000001',1,1);

/*********************************/
/**** Segment Num Data Types *****/
/*********************************/ 
DELETE FROM sg_num_dat_type WHERE sn_db_site = '000003F900000001';
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,1,'Severity','Severity',101, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,2,'Detection Method','Detection Method',101,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,3,'Occurrence count','Occurrence Count',1, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,4,'Criticality','Criticality',101,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,5,'Issue Status','Issue Status',101, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,6,'Battle Damage','Battle Damage',101,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,7,'Resolution Status','Resolution Status',101, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,8,'Combat Power Impact','Combat Power Impact',101,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,9,'Effect Name','Effect Name',101, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,10,'Effect Description','Effect Description',101,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,11,'Quantity on Hand','Quantity on Hand',2, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,12,'Need Quantity','Need Quantity',2,sysdate,'000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,13,'Receipt Timestamp','Receipt Timestamp',106, sysdate, '000003F900000001',1,1);
INSERT INTO sg_num_dat_type(sn_db_site,sn_db_id,sn_type_code,name,user_tag_ident,default_ru_type,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES ('000003F900000001',1,14,'COA','COA',101,sysdate,'000003F900000001',1,1);

/*************************/
/* solution package type */
/*************************/
DELETE FROM solution_pack_type WHERE sol_db_site = '000003F900000001';
INSERT INTO solution_pack_type(sol_db_site,sol_db_id,sol_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES('000003F900000001',1,1,'IETM','IETM',sysdate,'000003F900000001',1,1);

/*************************/
/**** work_task_type  ****/
/*************************/
/* In addition to work_task_types defined in the MIMOSA reference db 0000000000000000,0 */
DELETE FROM work_task_type WHERE task_db_site='000003F900000001';
INSERT INTO work_task_type
(task_db_site,task_db_id,task_type_code,name,user_tag_ident
,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,1,'Troubleshoot','Troubleshoot',sysdate,'000003F900000001',1,1);
INSERT INTO work_task_type
(task_db_site,task_db_id,task_type_code,name,user_tag_ident
,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code)
VALUES('000003F900000001',1,2,'Calibrate','Calibrate',sysdate,'000003F900000001',1,1);

