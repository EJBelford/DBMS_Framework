
/*--*----1----*----2----*----3----*----4----*----5----*----6----*----7----*----8
================================================================================
                          Classification: UNCLASSIFIED
================================================================================
                            Copyright, US Army, 2017
                        Unpublished, All Rights Reserved
================================================================================
----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--
--         NAME: atis_operations_ref
--      PURPOSE: Load data into the atis_operations_ref table.
--
--   CREATED BY: Gene Belford
-- CREATED DATE: 2017-12-04
--
--       SOURCE: atis_operations_ref.sql
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

DELETE FROM atis_operations_ref;

-- Default record --

INSERT INTO atis_operations_ref ( operation_id, operation, operation_desc ) 
VALUES ( 0, 'UNDEFINED', 'The class of operation does not have an existing description.' ); 

-- Load records --

INSERT INTO atis_operations_ref ( operation_id, operation, operation_desc ) 
          SELECT 1, 'AIR ASSAULT', null FROM DUAL 
UNION ALL SELECT 2, 'AIRBORNE', null FROM DUAL 
UNION ALL SELECT 3, 'AMPHIBIOUS', null FROM DUAL 
UNION ALL SELECT 4, 'ANTISUBMARINE WARFARE', null FROM DUAL 
UNION ALL SELECT 5, 'ANTITERRORISM', 'Operations that include defensive measures used to reduce the vulnerability of individuals and property to terrorist acts, to include limited response and containment by local military forces. These operations take place both in the United States and worldwide bases, installations, embassies, and consulates.' FROM DUAL 
UNION ALL SELECT 6, 'AREA DEFENSE', null FROM DUAL 
UNION ALL SELECT 7, 'ARMS CONTROL', null FROM DUAL 
UNION ALL SELECT 8, 'ATTACK', null FROM DUAL 
UNION ALL SELECT 9, 'BARRIER OPERATIONS', null FROM DUAL 
UNION ALL SELECT 10, 'BLOCKADE', null FROM DUAL 
UNION ALL SELECT 11, 'CAMPAIGN PLANNING', null FROM DUAL 
UNION ALL SELECT 12, 'CIVIL DISTURBANCE', 'Riots, acts of violence, insurrections, unlawful obstructions or assemblages, group acts of violence, and disorders prejudicial to public law and order in the 50 States, the District of Columbia, the Commonwealth of Puerto Rico, US possessions and territories, or any political subdivision thereof.' FROM DUAL 
UNION ALL SELECT 13, 'COMBAT SEARCH AND RESCUE', null FROM DUAL 
UNION ALL SELECT 14, 'COMMAND AND CONTROL WARFARE', null FROM DUAL 
UNION ALL SELECT 15, 'COUNTERDRUG', null FROM DUAL 
UNION ALL SELECT 16, 'COUNTERPROLIFERATION', null FROM DUAL 
UNION ALL SELECT 17, 'COUNTERTERRORISM', 'Offensive operations that involve measures taken to prevent, deter, and respond to terrorism. Sensitive and compartmented counterterrorism programs are addressed in relevant National Security Decision Directives, National Security Directives, contingency plans, and other relevant classified documents.' FROM DUAL 
UNION ALL SELECT 18, 'DEFENSIVE COUNTER-AIR', null FROM DUAL 
UNION ALL SELECT 19, 'DELAY', null FROM DUAL 
UNION ALL SELECT 20, 'DEPLOYMENT', null FROM DUAL 
UNION ALL SELECT 21, 'DESTROY ENEMY BASES', null FROM DUAL 
UNION ALL SELECT 22, 'DESTROY ENEMY NAVAL FORCES', null FROM DUAL 
UNION ALL SELECT 23, 'DOMESTIC CONSEQUENCE MANAGEMENT', null FROM DUAL 
UNION ALL SELECT 24, 'CIVIL SUPPORT', 'Those operations conducted within the US that support civil authorities. Such operations include disaster-related civil emergencies, civil defense for attacks directed against the territory of the US, assistance to law enforcement agencies in civil disturbance situations, protection of life and federal property, and prevention of disruptions at federal functions. The Armed Forces of the United States can augment domestic agencies of the US. Such operations can include support to education systems, medical facilities, transportation systems in remote and depressed areas.' FROM DUAL 
UNION ALL SELECT 25, 'ENVIRONMENTAL ASSISTANCE', null FROM DUAL 
UNION ALL SELECT 26, 'EXPLOITATION', null FROM DUAL 
UNION ALL SELECT 27, 'FOREIGN CONSEQUENCE MANAGEMENT', null FROM DUAL 
UNION ALL SELECT 28, 'FOREIGN INTERNAL DEFENSE', null FROM DUAL 
UNION ALL SELECT 29, 'HUMANITARIAN ASSISTANCE', 'Humanitarian Assistance Operations are those operations conducted to relieve or reduce the results of natural or manmade disasters or other endemic conditions such as human pain, disease, hunger, or privation that might present a serious threat to life, or that can result in great damage to, or loss of, property. Humanitarian assistance provided by US forces is limited in scope and duration. The assistance provided is designed to supplement or complement the efforts of the HN civil authorities or agencies that may have the primary responsibility for providing humanitarian assistance.' FROM DUAL 
UNION ALL SELECT 30, 'INFORMATION WARFARE', null FROM DUAL 
UNION ALL SELECT 31, 'JOINT INTERDICTION', null FROM DUAL 
UNION ALL SELECT 32, 'JTF PLANNING', null FROM DUAL 
UNION ALL SELECT 33, 'LAND DEFENSE', null FROM DUAL 
UNION ALL SELECT 34, 'MARITIME INTERCEPTION OPERATIONS', null FROM DUAL 
UNION ALL SELECT 35, 'MOBILE', null FROM DUAL 
UNION ALL SELECT 36, 'MOBILIZATION', null FROM DUAL 
UNION ALL SELECT 37, 'MOVEMENT TO CONTACT', null FROM DUAL 
UNION ALL SELECT 38, 'NATION ASSISTANCE', null FROM DUAL 
UNION ALL SELECT 39, 'NONCOMBATANT EVACUATION OPERATIONS', null FROM DUAL 
UNION ALL SELECT 40, 'NUCLEAR', null FROM DUAL 
UNION ALL SELECT 41, 'OFFENSIVE COUNTER-AIR', null FROM DUAL 
UNION ALL SELECT 42, 'PEACE ENFORCEMENT', null FROM DUAL 
UNION ALL SELECT 43, 'PEACEKEEPING', null FROM DUAL 
UNION ALL SELECT 44, 'PEACEMAKING', null FROM DUAL 
UNION ALL SELECT 45, 'PURSUI', null FROM DUAL 
UNION ALL SELECT 46, 'REAR AREA SECURITY', null FROM DUAL 
UNION ALL SELECT 47, 'RECONNAISSANCE, SURVEILLANCE AND TARGET ACQUISITION', null FROM DUAL 
UNION ALL SELECT 48, 'RETIREMENT', null FROM DUAL 
UNION ALL SELECT 49, 'RECEPTION, STAGING, ONWARD MOVEMENT, AND INTEGRATION', null FROM DUAL 
UNION ALL SELECT 50, 'SUPPRESSION OF ENEMY AIR DEFENSES', null FROM DUAL 
UNION ALL SELECT 51, 'SEARCH AND RESCUE', null FROM DUAL 
UNION ALL SELECT 52, 'SEIZE ADVANCED BASES', null FROM DUAL 
UNION ALL SELECT 53, 'SHOW OF FORCE', null FROM DUAL 
UNION ALL SELECT 54, 'SPACE', null FROM DUAL 
UNION ALL SELECT 55, 'STRATEGIC ATTACK', null FROM DUAL 
UNION ALL SELECT 56, 'SUPPORT COUNTERINSURGENCIES', null FROM DUAL 
UNION ALL SELECT 57, 'SUPPORT INSURGENCIES', null FROM DUAL 
UNION ALL SELECT 58, 'THEATER MISSILE DEFENSE', null FROM DUAL 
UNION ALL SELECT 59, 'THEATER NUCLEAR', null FROM DUAL 
UNION ALL SELECT 60, 'WITHDRAWAL', null FROM DUAL ;

-- Test SELECT --

SELECT  operation_id, operation, operation_desc  
FROM atis_operations_ref;

