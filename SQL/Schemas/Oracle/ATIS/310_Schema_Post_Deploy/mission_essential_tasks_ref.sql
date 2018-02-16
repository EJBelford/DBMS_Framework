
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: mission_essential_tasks_ref
--      PURPOSE: Load data into the mission_essential_tasks_ref table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: mission_essential_tasks_ref.sql
--
--        NOTES:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
-- CHANGE HISTORY
-- YYYY-MM-DD - Who         - RDP / ECP # - Details..
-- 2017-12-04 - Gene Belford  - RDPTSK00xxx - Created.. 
--
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*---*/

/*----- 310_Schema_Post_Deploy  -----*/

DELETE FROM mission_essential_tasks_ref;

-- Load records --

INSERT INTO mission_essential_tasks_ref (met_code, met_desc) 
          SELECT 'OP 1.1.1', 'Formulate Request for Strategic Deployment to a Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.1.2', 'Conduct Intratheater Deployment and Redeployment of Forces Within the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.1.3', 'Conduct Joint Reception, Staging, Onward Movement, and Integration (JRSOI) in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.2.3', 'Assemble Forces in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.2.4.1', 'Conduct a Show of Force' FROM DUAL 
UNION ALL SELECT 'OP 1.2.4.8', 'Conduct Unconventional Warfare in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.4.1', 'Employ Operational System of Obstacles' FROM DUAL 
UNION ALL SELECT 'OP 1.5.1', 'Control of Operationally Significant Land Area in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.5.2', 'Gain and Maintain Maritime Superiority in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.5.3', 'Gain and Maintain Air Superiority in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 1.5.5', 'Assist HN in Populace and Resource Control' FROM DUAL 
UNION ALL SELECT 'OP 2.1.2', 'Determine and Prioritize Operational Information Requirements (IR)' FROM DUAL 
UNION ALL SELECT 'OP 2.2.1', 'Collect Information on Operational Situation' FROM DUAL 
UNION ALL SELECT 'OP 2.4.1', 'Evaluate, Integrate, Analyze, and Interpret Operational Information' FROM DUAL 
UNION ALL SELECT 'OP 2.4.2.1', 'Provide Indications and Warning for the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 2.5', 'Disseminate and Integrate Operational Intelligence' FROM DUAL 
UNION ALL SELECT 'OP 3.1.6', 'Conduct Operational Combat/MOOTW Assessment' FROM DUAL 
UNION ALL SELECT 'OP 3.2.2', 'Conduct Attack on Operational Targets using Nonlethal Means' FROM DUAL 
UNION ALL SELECT 'OP 3.2.2.4', 'Conduct Attack on Personnel, Equipment, and Installations using Nonlethal Means' FROM DUAL 
UNION ALL SELECT 'OP 3.2.5.3', 'Conduct Special Operations Interdiction of Operational Forces/Targets' FROM DUAL 
UNION ALL SELECT 'OP 3.2.6', 'Provide Firepower in Support of Operational Maneuver' FROM DUAL 
UNION ALL SELECT 'OP 3.2.7', 'Synchronize Operational Firepower' FROM DUAL 
UNION ALL SELECT 'OP 4.4.1.2', 'Coordinate Mortuary Affairs in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.4.3', 'Provide for Health Services in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.4.3.1', 'Manage Joint Blood Program in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.4.3.3', 'Manage Health Services Resources in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.4.6', 'Provide Religious Ministry Support in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.5.1', 'Provide for Movement Services in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.7.1', 'Provide Security Assistance in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.7.2', 'Conduct Civil Military Operations in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 4.7.3', 'Provide Support to DOD and Other Government Agencies' FROM DUAL 
UNION ALL SELECT 'OP 4.7.6', 'Coordinate Civil Affairs in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 5.1.1', 'Communicate Operational Information' FROM DUAL 
UNION ALL SELECT 'OP 5.1.3', 'Determine Commander''s Critical Information Requirements' FROM DUAL 
UNION ALL SELECT 'OP 5.1.4', 'Maintain Operational Information and Force Status' FROM DUAL 
UNION ALL SELECT 'OP 5.2.1', 'Review Current Situation (Project Branches)' FROM DUAL 
UNION ALL SELECT 'OP 5.2.2', 'Formulate Crisis Assessment' FROM DUAL 
UNION ALL SELECT 'OP 5.3.1', 'Conduct Operational Mission Analysis' FROM DUAL 
UNION ALL SELECT 'OP 5.4.2', 'Issue Plans and Orders' FROM DUAL 
UNION ALL SELECT 'OP 5.4.4', 'Synchronize and Integrate Operations' FROM DUAL 
UNION ALL SELECT 'OP 5.5', 'Establish, Organize, and Operate a Joint Force Headquarters' FROM DUAL 
UNION ALL SELECT 'OP 5.5.1', 'Develop a Joint Force Command and Control Structure' FROM DUAL 
UNION ALL SELECT 'OP 5.5.2', 'Develop Joint Force Liaison Structure' FROM DUAL 
UNION ALL SELECT 'OP 5.7.4', 'Coordinate Plans with Non-DOD Organizations' FROM DUAL 
UNION ALL SELECT 'OP 5.8', 'Provide Public Affairs in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 6.1', 'Provide Operational Air, Space and Missile Defense' FROM DUAL 
UNION ALL SELECT 'OP 6.2', 'Provide Protection for Operational Forces, Means, and Noncombatants' FROM DUAL 
UNION ALL SELECT 'OP 6.2.1', 'Prepare Operationally Significant Defenses' FROM DUAL 
UNION ALL SELECT 'OP 6.2.2', 'Remove Operationally Significant Hazards' FROM DUAL 
UNION ALL SELECT 'OP 6.2.5', 'Provide Positive Identification of Friendly Forces Within the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 6.2.7', 'Establish Disaster Control Measures' FROM DUAL 
UNION ALL SELECT 'OP 6.3', 'Protect Systems and Capabilities in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'OP 6.3.1', 'Employ Operations Security (OPSEC) in JOA' FROM DUAL 
UNION ALL SELECT 'OP 6.3.2', 'Supervise Communications Security (COMSEC)' FROM DUAL 
UNION ALL SELECT 'OP 6.5', 'Provide Security for Operational Forces and Means' FROM DUAL 
UNION ALL SELECT 'OP 6.5.3', 'Protect/Secure Operationally Critical Installations, Facilities, and Systems' FROM DUAL 
UNION ALL SELECT 'OP 6.5.4', 'Protect and Secure Air, Land and Sea LOCs in the Joint Operations Area' FROM DUAL 
UNION ALL SELECT 'SN 8.1.10', 'Coordinate Actions to Combat Terrorism' FROM DUAL 
UNION ALL SELECT 'ST 1.1', 'Conduct Intratheater Strategic Deployment' FROM DUAL 
UNION ALL SELECT 'ST 1.1.3', 'Conduct Intratheater Deployment of Forces' FROM DUAL 
UNION ALL SELECT 'ST 1.1.6', 'Coordinate/Provide Pre-positioned Assets/Equipment' FROM DUAL 
UNION ALL SELECT 'ST 1.3.5', 'Conduct Show of Force/Demonstration' FROM DUAL 
UNION ALL SELECT 'ST 2.2.1', 'Collect Information on Theater Strategic Situation' FROM DUAL 
UNION ALL SELECT 'ST 2.2.3', 'Collect and Assess Meteorological and Oceanographic (METOC) Information' FROM DUAL 
UNION ALL SELECT 'ST 4.2.2', 'Coordinate Health Service Support' FROM DUAL 
UNION ALL SELECT 'ST 4.2.6', 'Determine Theater Residual Capabilities' FROM DUAL 
UNION ALL SELECT 'ST 5.2.1', 'Review Current Situation' FROM DUAL 
UNION ALL SELECT 'ST 5.6.1', 'Plan and Provide for External Media Support and Operations' FROM DUAL 
UNION ALL SELECT 'ST 5.6.3', 'Plan and Conduct Community Relations Program' FROM DUAL 
UNION ALL SELECT 'ST 6.2.6', 'Establish Security Procedures for Theater Forces and Means' FROM DUAL 
UNION ALL SELECT 'ST 8.1.2', 'Promote Regional Security and Interoperability' FROM DUAL 
UNION ALL SELECT 'ST 8.1.3', 'Develop Headquarters or Organizations for Coalitions' FROM DUAL 
UNION ALL SELECT 'ST 8.1.4', 'Develop Multinational Intelligence/Information Sharing Structure' FROM DUAL 
UNION ALL SELECT 'ST 8.2.1', 'Coordinate Security Assistance Activities' FROM DUAL 
UNION ALL SELECT 'ST 8.2.2', 'Coordinate Civil Affairs in Theater' FROM DUAL 
UNION ALL SELECT 'ST 8.2.6', 'Coordinate Military Civic Action Assistance' FROM DUAL 
UNION ALL SELECT 'ST 8.2.7', 'Assist in Restoration of Order' FROM DUAL 
UNION ALL SELECT 'ST 8.3.1', 'Arrange Stationing for US Forces' FROM DUAL 
UNION ALL SELECT 'ST 8.3.3', 'Arrange Sustainment Support for Theater Forces' FROM DUAL 
UNION ALL SELECT 'ST 8.4.2', 'Assist in Combating Terrorism' FROM DUAL 
UNION ALL SELECT 'ST 8.4.5', 'Coordinate Military Assistance for Civil disturbances (MACDIS) in the United States' FROM DUAL ;

-- Test SELECT --

SELECT met_code, met_desc 
FROM mission_essential_tasks_ref;

