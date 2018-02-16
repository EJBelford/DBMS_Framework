/* Source File: <tableName>_seq.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>_seq                                               */
/*      Author: <author>                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 170 Sequence 

DROP SEQUENCE IF EXISTS <tableName>_seq;

CREATE SEQUENCE <tableName>_seq 
    INCREMENT   1
    MINVALUE    1
    MAXVALUE    9223372036854775807
    START       1
    CACHE       1;

    
COMMENT ON SEQUENCE <tableName>_seq 
    IS '<tableName>_seq - Creates a sequence number for <tableName> that is assigned to the rec_id each new record is created.';


ALTER TABLE <tableName>_seq 
    OWNER TO postgres; 

/* Source File: <tableName>.sql                                               */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>                                                   */
/*      Author: <author>                                                  */
/* Description: <description>                                */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS <tableName>;

CREATE TABLE <tableName> 
(
rec_id                INTEGER      NOT NULL DEFAULT nextval('<tableName>_seq'::regclass),
--
rec_uuid              UUID         NOT NULL DEFAULT uuid_generate_v4(), 
--
<fieldName>_nm        VARCHAR(50)  UNIQUE NOT NULL,
<fieldDesc>_desc      VARCHAR(50)  NOT NULL, 
--
status                CHAR(1)      NOT NULL DEFAULT 'C', 
status_by             VARCHAR(50)  DEFAULT USER,
status_date           TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(), 
--
insert_date           TIMESTAMP    WITH TIME ZONE NOT NULL DEFAULT CLOCK_TIMESTAMP(),
insert_by             VARCHAR(50)  DEFAULT USER,
update_date           TIMESTAMP    WITH TIME ZONE,
update_by             VARCHAR(50),
delete_flag           BOOLEAN      DEFAULT 'FALSE',   
delete_date           TIMESTAMP    WITH TIME ZONE,
delete_by             VARCHAR(50),
hidden_flag           BOOLEAN      DEFAULT 'FALSE',   
hidden_date           TIMESTAMP    WITH TIME ZONE,
hidden_by             VARCHAR(50),
--
mandatorymetadata_security_c_0 VARCHAR(254),
mandatorymetadata_security_c_2 VARCHAR(254),
mandatorymetadata_security_c_1 VARCHAR(254),
mandatorymetadata_security_d_7 VARCHAR(254),
mandatorymetadata_security_d_6 VARCHAR(254),
mandatorymetadata_security_d_3 VARCHAR(254),
mandatorymetadata_security_d_4 VARCHAR(254),
mandatorymetadata_security_d_5 VARCHAR(254),
mandatorymetadata_security_d_1 VARCHAR(254),
mandatorymetadata_security_d_2 VARCHAR(254),
mandatorymetadata_security_d_0 VARCHAR(254),
mandatorymetadata_security_f_0 VARCHAR(254),
mandatorymetadata_security_f_1 VARCHAR(254),
mandatorymetadata_security_n_0 VARCHAR(254),
mandatorymetadata_security_o_0 VARCHAR(254),
mandatorymetadata_security_r_0 VARCHAR(254),
mandatorymetadata_security_s_1 VARCHAR(254),
mandatorymetadata_security_s_0 VARCHAR(254),
mandatorymetadata_security_t_0 VARCHAR(254), 
--
PRIMARY KEY (rec_id) 
)
WITH (
    OIDS = FALSE 
    );

COMMENT ON TABLE <tableName> 
IS '<tableName> - <description>';

COMMENT ON COLUMN <tableName>.rec_id 
IS 'rec_id - The unquie durable single field key assigned to the record.';
COMMENT ON COLUMN omega_process_log.rec_uuid 
IS 'rec_uuid - Stores the Universally Unique IDentifier (UUID) as defined by RFC 4122, ISO/IEC 9834-8:2005.'; 
COMMENT ON COLUMN <tableName>.<tableName>_nm 
IS '<fieldName> - ';
COMMENT ON COLUMN <tableName>.<tableName>_desc 
IS '<fieldDesc> - ';

COMMENT ON COLUMN <tableName>.status 
IS 'status - A 1 character code for the statsu of the record, (Current, Duplicate, Error, Historical, Logical, New, Processing, Questionable, Ready to process, Waiting)'; 
COMMENT ON COLUMN <tableName>.status_by 
IS 'status_by - The user who last changed the status of the record';
COMMENT ON COLUMN <tableName>.status_date 
IS 'status_date - The date when the record status was last changed';

COMMENT ON COLUMN <tableName>.insert_date 
IS 'insert_date - The date the record was created';
COMMENT ON COLUMN <tableName>.insert_by 
IS 'insert_by - The user/fuction that created the record';
COMMENT ON COLUMN <tableName>.update_date 
IS 'update_date - The date the record was last modified';
COMMENT ON COLUMN <tableName>.update_by 
IS 'update_by - The user/function that last updated the record';
COMMENT ON COLUMN <tableName>.delete_flag 
IS 'delete_flag - A logical flag used to ignore the record as if it was deleted';   
COMMENT ON COLUMN <tableName>.delete_date 
IS 'delete_date - The date the logical delete flag was set';
COMMENT ON COLUMN <tableName>.delete_by 
IS 'delete_by - The user/function that set the logical delete flag';
COMMENT ON COLUMN <tableName>.hidden_flag 
IS 'hidden_flag - A flag used to hide/exclude the record from pick lists';  
COMMENT ON COLUMN <tableName>.hidden_date 
IS 'hidden_date - The date the hidden flag was set';
COMMENT ON COLUMN <tableName>.hidden_by 
IS 'hidden_by - The user/function that set the hidden flag';

/* Sourced from: http://schemas.opengis.net/ic/2.1/IC-ISM-v2.1.xsd            */
    
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_c_0 
    IS 'Classification Tag - NEIM 2.1 > IC-ISM-v2.1.xsd - classification - This attribute is used at both the resource and the portion levels.  A single indicator of the highest level of classification applicable to an information resource or portion within the domain of classification national security information.  The Classification element is always used in conjunction with Owner Producer element.  Taken together, the two elements specify the classification category and the type of classifiaction (US, non-US, orJoint).  It is manifested in portion marks and security banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_c_2 
    IS 'Classification Reason - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  One or more reason indicators or explanatory test describing the basis for an orginial classification decision.  It is manifested only in the "Reason" line of a resource''s Classification/Deslassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_c_1 
    IS 'Classified By - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  The identity, ny name or personal identifier, of the original classification authority for a resource.  It is manifested only in the "Classified By" line of a resources''s classification/declassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_7 
    IS 'Date of Exempted Source - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  A specific year, month, day of publication or release of a source, or the most recent source document, that was itself marked with a declassification constraint.  The element is always used in conjunction with the Type Of Exempted Segment Source elemnet.  It is manifested only in the the "Declassify On" line of a resource''s Classification/Declassification lock.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_6 
    IS 'Declassification Date - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primalily at the resource level.  A specific year, month, and day upon which information shall be automatically declassified if not properly exempted form automatic desclassification.  It is manifested in the "Declassify On" line of a resource'' classification/declassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_3 
    IS 'Declassification Event - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primalily at the resource level.  A description of an event upon which the information shall be automatically declassified if not properly exempted form automatic declassification.  It is manifested in the "Declassify On" line of a resource'' classification/declassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_4 
    IS 'Declassification Exception - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  A single indicator describing an exemption to the 25-year point for automatic declassification.  This element is used in conjunction with the Declassification Date or Desclsssification Event.  It is manifested in the "Declassify On" line of a resource''s classifiaction/declassification block.  This element is defined as NMTOKENS but ISOO has stated it should be a SINGLE value giving the longest protection.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_5 
    IS 'Declassification Manual Review - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  A single indicator of a requirement for manual review prior to declassification, over and above the usual programmatic determinations.  The ability to indicate manual review was rescinded as of 1 February 2008 with complete removal from automated systems required by 31 March 2009 at which time this elemnet will be deprecated.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_1 
    IS 'Derivatively Classified By - NEIM 2.1 > IC-ISM-v2.xsd - This attribute is used primarily at the resource level.  The identity, by name or personal identifier, of the derivative classification authority.  It is manifested only in the "Classified By" line of a resource''s Classifiaction/Declassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_2 
    IS 'Derived From - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primalily at the resource level.  A citation of he authoritative source or reference to multiple sources of classifiaction markings used in a classified resource.  It is manifested only in the "Derived From" line of a documents''s Classification/Declassification block.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_d_0 
    IS 'Dissemination Controls - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both th resource and the portion levels.  One or more indicators identifying the expansion or limitation on the distribution of information.  It is manifested in portion marks and security banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_f_0 
    IS 'FGI Source Open - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  One or more indicators identifying information which qualifies as foreign government information for which the source(s) of the information is not concealed.  The attribute can indicate that the source of information of foreign origin is unknown.  It is manifested in portion marks and securty banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_f_1 
    IS 'FGI Source Protected - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  This attribute has unique specific rules concerning its usage.  A single indicator that information qualifies has foreign government information for which the source(s) of the information must be concealed.  Within protected internal organiational spaces this element may be used to maintain a record of the one or more indicators identifying information which ualifies as foreign government information for which the source(s) of the information must be concealed.  Measures must be taken prior to dissemination of the information to conceal the source(s) of the foreign government information.  An indication that information qualifies as foreign government information according to CAPCO guidelines for which the source(s) of the information must be concealed when the information is disseminated is shared spaces this data element has a dual purpose.  Within shared spaces, the data element serves only to indicate the presence of information which is categorized as foreign government information according to CAPCO guidelines for which the source(s) of the information is concealed, in which case, this data element''s value will always be "FGI".  The data element may also be employed in this manner within protected internal organizational spaces.  However, within the protected internal organizational spaces this data element may alternatively be used to maintain a formal record of the foreign country or countries and.or registered international organization(s) that are the non-disclosable owner(s) and/or producer(s) of information which is categorized as foreign government information according to CAPCO guidelines for which the source(s) of the information must be concealed when the resource is disseminated to shared spaces.  If the data element is emplyed in this manner, ten additional measures must be taken prior to dissemination of the resources to shared spaces so that any indications of the non-disclosable owner(s) and/or producer(s) of the information within the resource are eliminated.  In all cases, the corresponding portion marking or banner marking should be compliant with CAPCO guidelines for FGI when the source must be concealed.  In other words, even if the data element is being employed within protected internal organizational spaces to maintain a formal record of the non-disclosable owner(s) and/r producer(s) within an XML resource, if the resource is rendered for display wihin the protected internal organizational spaces in nay format by a stylesheet or as a result of any other transformation process, then the non-disclosable owner(s) and/or producer(s) should not be included in the corresponding portion marking or banner marking.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_n_0 
    IS 'Non IC Markings - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  One or more indicators of the expansion or limitation on the distribution of an information resource or portion within the domain of information orginating from non-intelligence components.  It is manifested in portion marks and security banners.  LAW ENFORCEMENT SENSITIVE (LES) is not an authorized IC classification and control marking in CAPCO Register.  However, CAPCO has published interim marking guidance concerning the incorporation of LES information into IC products.  "LES" has been included as a permissible value for attribute "nonICmarkings" in IC ISM in order to facilitate compliance with the CAPCO interim marking guidance in XML-based products.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_o_0 
    IS 'Owner Producer - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  One or more indicators identifying the national government or internaltional organization that have purview over the classification marking of an information resource or portion therein.  This element is always used in conjunction with the Classifiaction element.  Taken together,  the two elements specify the classification category and the type of classification (US, non-US, or Joint).  Within protected internal organizational spaces this element may include one or more indicators identifyig information which qualifies as foreign government information for which the sources(s) of the information must be concealed.  Measures must be taken prior todissemination of the information to conceal the source(s) of the foreign goverment information.  Specifically, under these specific circumstances, when data are moved to the shared spaces, the non-disclosable owner(s) and/or producer(s) listed in this data elements value should be removed and replaced with "FGI".  The attribute value may be manifested in portion marls or security banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_r_0 
    IS 'Releaseable To - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels. One or more indicators identifying the country or countries and/or international organization(s) to which classified information may be released based on the determination of an originator in accordance with established foreign disclosure procedures.  This element is used in conjunction with the Dissemination Controls element.  It is manifested in portion marks and security banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_s_1 
    IS 'SAR Identifier - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  One or more idicators identifying the defense or intelligence programs for which special access is required.  It is manifested in the portion marks and security banners.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_s_0 
    IS 'SCI Controls - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used at both the resource and the portion levels.  One or more indicators identifying sensitive compartmented information control system(s).  It is manifested in the portion marks and security banners.  For the "SI-ECI-XXX" permissible value, "XXX" is a placeholder for ECI program designator alphabaetic trigraphs, which are classified and are therefore not included here.  Additional classified and unpublished SCI control system abbreviations are not included here.';
COMMENT ON COLUMN <tableName>.mandatorymetadata_security_t_0 
    IS 'Type of Exempted Source - NEIM 2.1 > IC-ISM-v2.1.xsd - This attribute is used primarily at the resource level.  A declassification marking of a source document that causes the current, derivative document to be exempted from automatic declassification.  This element is always used in conjuncion with the Date Of Exempted Source element.  It is manifested in the "Declassify On" line of a documents''classification/declassification block.  This element is defined as NMTOKENS but ISOO has stated it should be a SINGLE value giving the longest protection.'; 
    
/*
SELECT pc.relname, pd.description, pd.objoid, pd.classoid, pd.objsubid
  --, pd.* 
FROM pg_description pd 
JOIN pg_class pc ON pd.objoid = pc.oid 
JOIN pg_namespace pn ON pc.relnamespace = pn.oid 
WHERE pc.relname = LOWER('<tableName>') AND pn.nspname = 'public';
*/

/*
SELECT pd.* FROM pg_description pd WHERE pd.objoid = 1259;
*/


/* Source File: udx_<tableName>_<xx>.sql                                 */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: udx_<tableName>_<xx>                               */
/*      Author: <author>                                                  */
/* Description: Is a unique index on <xx> for the                  */
/*              <tableName>.                                       */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 220 Indexes 

-- DROP INDEX IF EXISTS udx_<tableName>_<xx>;


CREATE UNIQUE INDEX udx_<tableName>_<xx>
    ON <tableName> (
        <xx>
        );

COMMENT ON INDEX udx_<tableName>_xx 
    IS 'udx_<tableName>_<xx> - Index Is a unique index on xx for the <tableName>.';


/* Source File: idx_<tableName>_<yx>.sql                                 */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: idx_<tableName>_<yx>                               */
/*      Author: <author>                                                  */
/* Description: Is a index on <yx> for the                  */
/*              <tableName>.                                       */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 220 Indexes 

-- DROP INDEX IF EXISTS idx_<tableName>_<xy>;


CREATE UNIQUE INDEX idx_<tableName>_<xy>
    ON <tableName> (
        <xy>
        );

COMMENT ON INDEX idx_<tableName>_<xy> 
    IS 'idx_<tableName>_<xy> - Index Is a index on <xy> for the <tableName>.';


/* Source File: <tableName>_status.sql                                        */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>_status                                            */
/*      Author: <author>                                                      */
/* Description: Defines the "status" constraint for <tableName>.              */
/*        Date: <yyyy-mm-dd>                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>             <author>          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 217 Constraint 

-- ALTER TABLE <tableName> DROP CONSTRAINT <tableName>_status; 

ALTER TABLE <tableName> 
   ADD CONSTRAINT <tableName>_status 
   CHECK (status IN ('C', 'D', 'E', 'H', 'L', 'N', 'P', 'Q', 'R', 'W')); 
     

COMMENT ON CONSTRAINT <tableName>_status 
    ON <tableName> 
    IS '<tableName>_status - Defines the "status" constraint for <tableName>.';


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

INSERT 
INTO <tableName> (
    rec_uuid, 
    <tableName>_nm, <tableName>_desc, status
    )
VALUES (
    '00000000-0000-0000-0000-000000000001', 
--    uuid_generate_v4(), 
    'test_' || CLOCK_TIMESTAMP(), 'desc', 'C'
    );
    
SELECT a.* 
FROM   <tableName> a 
ORDER BY rec_id DESC; 


/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Below this section is optional.  If you don't need to have an audit        */
/* trail remove it from the  template.                                        */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/


/* Source File: <tableName>_audit.sql                                         */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>_audit                                             */
/*      Author: <author>                                                      */
/* Description: Creates an audit table for <tableName> that tracks changes    */
/*              to the parent table as they are made.                         */
/*        Date: <yyyy-mm-dd>                                                  */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>           <author>           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 180 Table 

-- DROP TABLE IF EXISTS <tableName>_audit;

CREATE TABLE <tableName>_audit 
(
rec_id               INTEGER      NOT NULL,
--
rec_uuid             UUID         NOT NULL,
--
cmd                  CHAR(1)      NOT NULL,
update_date          TIMESTAMP    WITH TIME ZONE NOT NULL,
update_by            VARCHAR(50),
--
n_<tableName>_nm     VARCHAR(50),
o_<tableName>_nm     VARCHAR(50),
n_<tableName>_desc   VARCHAR(50),
o_<tableName>_desc   VARCHAR(50),
--
PRIMARY KEY (rec_id, cmd, update_date) 
)
WITH (
    OIDS = FALSE 
    );


COMMENT ON TABLE <tableName>_audit 
    IS '<tableName>_audit - Creates an audit table for <tableName> that tracks changes to the parent table as they are made.';


-- DROP FUNCTION IF EXISTS f_<tableName>_audit;

CREATE OR REPLACE FUNCTION f_<tableName>_audit() 
    RETURNS TRIGGER AS 
    
$BODY$ 
    
/* Source File: f_<tableName>_audit.sql                                       */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_<tableName>_audit                                           */
/*      Author: <author>                                                      */
/* Description:                                                               */
/*        Date: <yyyy-mm-dd>                                                  */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>            <author>           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*


*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 260 Function 

BEGIN 

    IF (TG_OP='INSERT') THEN 
        
        INSERT INTO <tableName>_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_<tableName>_nm
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'I', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.<tableName>_nm;
    
    ELSIF (TG_OP='UPDATE') THEN 
        
        INSERT INTO <tableName>_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            n_<tableName>_nm, o_<tableName>_nm
            )  
        SELECT NEW.rec_id, NEW.rec_uuid, 'U', 
            CLOCK_TIMESTAMP(), USER, 
            NEW.<tableName>_nm, OLD.<tableName>_nm;
    
    ELSIF (TG_OP='DELETE') THEN 
        
        INSERT INTO <tableName>_audit 
            (
            rec_id, rec_uuid, cmd, 
            update_date, update_by, 
            o_<tableName>_nm
            )  
        SELECT OLD.rec_id, OLD.rec_uuid, 'D', 
            CLOCK_TIMESTAMP(), USER, 
            OLD.<tableName>_nm;
    
    END IF;
    
    RETURN NULL;

END;
    
$BODY$
LANGUAGE plpgsql VOLATILE 
COST 100;


COMMENT ON FUNCTION f_<tableName>_audit() 
    IS 'f_<tableName>_audit() - This function ';


ALTER FUNCTION f_<tableName>_audit() 
    OWNER TO postgres; 
    
    
/* Source File: t_<tableName>_audit.sql                                       */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: <tableName>                                                   */
/*      Author: <author>                                                      */
/* Description:                                                               */
/*        Date: <yyyy-mm-dd>                                                  */
/* Source File:                                                               */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* <yyyy-mm-dd>           <author>           Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 280 Trigger 

-- DROP TRIGGER IF EXISTS t_<tableName>_audit ON <tableName>;

CREATE TRIGGER t_<tableName>_audit 
    AFTER INSERT OR UPDATE OR DELETE 
    ON <tableName> 
    FOR EACH ROW 
    EXECUTE PROCEDURE f_<tableName>_audit(); 


COMMENT ON TRIGGER t_<tableName>_audit 
    ON <tableName> 
    IS 't_<tableName>_audit - This trigger ';


    
    
