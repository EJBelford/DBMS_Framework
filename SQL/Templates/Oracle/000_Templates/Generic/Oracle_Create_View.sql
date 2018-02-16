CREATE OR REPLACE FORCE EDITIONABLE VIEW vw_atis_resources_training 
  (
  "RESOURCE_ID" , 
  "RESOURCE_NAME" , 
  "RESOURCE_TYPE" ,
  "RESOURCE_CONTACT" , 
  "POST" , 
  "EVENT_NAME" , 
  "EVENT_START" , 
  "EVENT_END" , 
  "EVENT_CONTACT" , 
  "EVENT_NOTES"
  ) 
  
AS 

/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: %YourObjectName%
--      PURPOSE: %Description%
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-08
--
--       SOURCE: vw_atis_resources_training.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who           - RDP / ECP # - Details..
-- 2017-12-08 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 230 Views  -----*/

-- DROP VIEW vw_atis_resources_training;

SELECT artr.resource_id , 
    artr.resource_name , 
    artr.resource_type , 
	artr.resource_contact , 
	artr.post , 
	artr.event_name , 
	artr.event_start , 
	artr.event_end , 
	artr.event_contact , 
	artr.event_notes
FROM atis_resources_training_ref artr 
ORDER BY artr.resource_name, 
    artr.event_start;
