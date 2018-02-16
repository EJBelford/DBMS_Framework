-- DBA deployment order:

-- Promotion_Instructions  (Text file only, and Not Executed) 
-- Contains the promotion instructions file.   
-- The promotion instructions file shall be an ASCII text file.   
-- The DBA will always read this file (if it is present) prior to performing a  
-- deployment and may include the contents within the deployment results.   
-- Files within this directory are not executed.

--/*---------------------------------------------*/
--
-- DBA_PRE_Deployment  (Executed as DBA) 
-- 
-- Contains scripts that must be executed by the DBA prior to performing the  
-- schema deployment.   
-- For Directory objects, use the -- Directories folder in VM.   
-- This is a rarely used directory and any scripts in this location will be  
-- scrutinized.

--/*---------------------------------------------*/
--
-- SCHEMA_PRE_Deployment  (Executed as Schema)  
-- 
-- Contains scripts that prepare the schema for deployment and must run prior  
-- to any other scripts.  This is not a catch-all directory.   
-- Tasks will be failed if scripts belong elsewhere in VM.   
-- Multiple scripts are acceptable.

--/*---------------------------------------------*/
--
-- Directories  (Executed as DBA) 
-- 
-- This is a legacy directory that contains scripts to create directories.   
-- Scripts within this directory are executed at the same time as the 
-- DBA_PRE_Deployment scripts.   
-- Multiple scripts are acceptable.

--/*---------------------------------------------*/
--
-- Sequences  (Executed as Schema) 
-- 
-- Contains scripts to create or alter sequences.  
-- Multiple scripts are acceptable.

--/*---------------------------------------------*/
--
-- Tables  (Executed as Schema) 
-- 
-- Contains scripts to create or alter tables.   
-- There shall be one script per table.   
-- Do NOT include CREATE TABLE scripts if you are performing an  
-- ALTER TABLE operation.  
-- Note: Inclusion of both the CREATE TABLE and ALTER TABLE scripts will  
-- produce unnecessary errors for the DEVELOPER to track down.

--/*---------------------------------------------*/
--
-- Comments 
-- 

--/*---------------------------------------------*/
--
-- Snapshots  (Executed as Schema) 
-- 
-- Contains scripts to create or alter materialized views (snapshots).

--/*---------------------------------------------*/
--
-- Constraints  (Executed as Schema)  
-- 
-- Contains scripts to create or alter constraints.

--/*---------------------------------------------*/
--
-- Indexes  (Executed as Schema) 
-- 
-- Contains scripts to create or alter indexes.

--/*---------------------------------------------*/
--
-- Views  (Executed as Schema) 
-- 
-- Contains scripts to create or alter views.

--/*---------------------------------------------*/
--
-- Functions  (Executed as Schema) 
-- 
-- Contains scripts to create or alter functions.   
-- There shall be one script per function.

--/*---------------------------------------------*/
--
-- Packages  (Executed as Schema) 
-- 
-- Contains scripts to create or alter packages.   
-- There shall be one script per package.

--/*---------------------------------------------*/
--
-- Package_Bodies  (Executed as Schema) 
-- 
-- Contains scripts to create or alter package bodies.   
-- There shall be one script per package body.

--/*---------------------------------------------*/
--
-- Procedures  (Executed as Schema) 
-- 
-- Contains scripts to create or alter procedures.   
-- There shall be one script per procedure.

--/*---------------------------------------------*/
--
-- Triggers  (Executed as Schema) 
-- 
-- Contains scripts to create or alter triggers.   
-- There shall be one script per trigger.

--/*---------------------------------------------*/
--
-- Synonyms  (Executed as DBA) 
-- 
-- Contains one script to create public synonyms.   
-- Scripts within this directory are executed at the same time as the 
-- DBA_POST_Deployment scripts.    
-- There shall be ONE script for all synonyms to be created. 

CREATE PUBLIC SYNONYM xx_pfsawh_blank_dim FOR PFSAWH.xx_pfsawh_blank_dim;

--/*---------------------------------------------*/
--
-- Grants  (Executed as Schema) 
-- 
-- Contains one script to execute grants.   
-- There shall be ONE script for all grants. 

GRANT SELECT ON xx_pfsawh_blank_dim TO LIW_BASIC; 

GRANT SELECT ON xx_pfsawh_blank_dim TO LIW_RESTRICTED; 

GRANT SELECT ON xx_pfsawh_blank_dim TO S_PFSAW; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO MD2L043; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_LOGSA_WEBPROP; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_PBUSE; 

-- GRANT SELECT ON xx_pfsawh_blank_dim TO S_WEBPROP; 

GRANT SELECT ON xx_pfsawh_blank_dim TO C_PFSAW; 

--/*---------------------------------------------*/
--
-- Scripts  (Executed as Schema) 
-- 
-- Contains scripts to perform any DML operations.   
-- This is not a catch-all directory.   
-- Tasks will be failed if scripts belong elsewhere in VM.   
-- Multiple scripts are acceptable.

--/*---------------------------------------------*/
--
-- SCHEMA_POST_Deployment  (Executed as Schema)  
-- 
-- Contains scripts that must run after any other schema level scripts.   
-- This is not a catch-all directory.   
-- Tasks will be failed if scripts belong elsewhere in VM.   
-- Multiple scripts are acceptable.

--/*---------------------------------------------*/
--
-- DBA_POST_Deployment  (Executed as DBA) 
-- 
-- Contains scripts that must be executed by the DBA after performing the  
-- schema deployment.  For Synonym objects, use the -- Synonym folder in VM.   
-- Any scripts in this location will be scrutinized.   
-- Multiple scripts are acceptable. 

