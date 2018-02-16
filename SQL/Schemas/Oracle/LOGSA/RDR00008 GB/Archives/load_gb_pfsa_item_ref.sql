DECLARE

-- Exception handling variables (ps_)

ps_procedure_name       VARCHAR2(30)  := 'pr_PHSAWH_blank';
ps_location             VARCHAR2(10)  := 'Begin'; 
ps_oerr                 VARCHAR2(6)   := null;
ps_msg                  VARCHAR2(200) := null;
ps_id_key               VARCHAR2(200) := null;              -- coder responsible for identying key for debug

-- Process status variables (s_)

-- s_rec_Id                NUMBER        := NULL; 

s_processRecId          NUMBER        := -1; 
s_processKey            NUMBER        := NULL;
s_processStartDt        DATE          := sysdate;
s_processEndDt          DATE          := NULL;
s_processStatusCd       NUMBER        := NULL;
s_sqlErrorCode          NUMBER        := NULL;
s_recReadInt            NUMBER        := NULL;
s_recValidInt           NUMBER        := NULL;
s_recLoadInt            NUMBER        := NULL;
s_recInsertedInt        NUMBER        := NULL;
s_recSelectedInt        NUMBER        := NULL;
s_recUpdatedInt         NUMBER        := NULL;
s_recDeletedInt         NUMBER        := NULL;
s_userLoginId           VARCHAR2(30)  := user;
s_message               VARCHAR2(255) := ''; 
    
-- module variables (v_)

v_debug                 NUMBER        := 0; 

/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--
--            SP Name: pr_PHSAWH_blank
--            SP Desc: 
--
--      SP Created By: Gene Belford
--    SP Created Date: dd mmm yyyy 
--
--          SP Source: pr_PHSAWH_blank.sql
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--      SP Parameters: 
--              Input: 
-- 
--             Output:   
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
-- Used in the following:
--
--         
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/
--     Change History:
-- DDMMMYY - Who - Ticket # - CR # - Details
-- ddmmmyy - GB  -          -      - Created 
--
/*----*----|----*----|----*----|----*----|----*----|----*----|----*----|----*--*/

/*----- Populate -----*/

    CURSOR part_cur IS
        SELECT a.part_niin, a.item_ctrl_niin
        FROM gb_pfsa_item_part_bld a
        ORDER BY a.part_niin;
        
    part_rec    part_cur%ROWTYPE;
        
BEGIN 

-- Clear the build table 

    IF v_debug > 100 THEN 

        DELETE gb_pfsa_item_part_bld;
    
        COMMIT;
        
    END IF; 
    
/*---------------------------*/
/*--  manufacturuer parts  --*/    
/*---------------------------*/
    
-- Load the bld table from the manufacturer part list  

    IF v_debug > 100 THEN 

        INSERT 
        INTO   gb_pfsa_item_part_bld 
            (
            niin, 
            part_CAGE_CD, 
            part_MFG_PART_NUM, 
            part_ACT_MEAS,
            part_DAC,
            part_RADIONUCLIDE,
            part_RNAAC,
            part_RNCC,
            part_RNJC,
            part_RNVC,
            part_SADC,
            part_LST_UPDT,
            part_STATUS,
            part_UPDT_BY, 
            record_source  
            )
        SELECT  niin, 
            NVL(cage_cd, -1), 
            NVL(mfg_part_num, -1),  
            ACT_MEAS,
            DAC,
            RADIONUCLIDE,
            RNAAC,
            RNCC,
            RNJC,
            RNVC,
            SADC,
            LST_UPDT,
            STATUS,
            UPDT_BY, 
            'manufacturer_part' 
        FROM    manufacturer_part@pfsawh.lidbdev
        WHERE   rncc = '3'; 
  
        COMMIT;
        
    END IF;

/*---------------------------*/
/*--  items                --*/    
/*---------------------------*/
    
-- Update the bld table with item_control@pfsawh.lidbdev values  

    IF v_debug > 100 THEN 
    
        UPDATE gb_pfsa_item_part_bld 
        SET    (fsc, item_ctrl_NOMEN_35) = 
               ( SELECT NVL(ic.fsc, '-2'), 
                     NVL(ic.NOMEN_35, '-2') 
                 FROM   item_control@pfsawh.lidbdev ic 
                 WHERE  gb_pfsa_item_part_bld.niin = ic.niin 
               ) 
        WHERE niin LIKE '01%'; 
         
        COMMIT;

    END IF;
    
-- Insert item_control@pfsawh.lidbdev values into the bld table for missing niin. 

    SELECT * FROM item_control@pfsawh.lidbdev WHERE niin = '015148052'
    
    INSERT 
    INTO   gb_pfsa_item_part_bld 
        (
        niin, 
        item_ctrl_nomen_35,
        item_data_full_nomen, 
        nsn, 
        fsc, 
        ecc, 
        cl_of_supply_cd, 
        part_LST_UPDT,
        part_STATUS,
        part_UPDT_BY,
        record_source 
        )
    SELECT  niin.niin, 
        niin.nomen_35, 
        niin.nomen_35, 
        NVL(fsc, '0000') || NVL(niin, '000000000'), 
        NVL(fsc, '0000'), 
        niin.ecc, 
        niin.cl_of_supply_cd, 
        niin.LST_UPDT,
        'Z',
        niin.updt_by, 
        'item_control' 
    FROM    item_control@pfsawh.lidbdev niin    
    WHERE NOT EXISTS ( 
                        SELECT niin 
                        FROM   gb_pfsa_item_part_bld 
                        WHERE  niin = niin.niin 
                     );
        
-- Update the bld table with item_data values 

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (item_data_niin, item_data_FULL_NOMEN) = 
               ( SELECT NVL(ida.niin, -2), 
                     NVL(ida.FULL_NOMEN, -2)  
                 FROM   item_data@pfsawh.lidbdev ida 
                 WHERE  gb_pfsa_item_part_bld.niin = ida.niin 
               ) 
        WHERE  niin LIKE '01%'; 
           
        COMMIT;

    SELECT * FROM item_data@pfsawh.lidbdev WHERE niin = '015148052'
    
    END IF; 
    
/*---------------------------*/
/*--  authorized items     --*/    
/*---------------------------*/
    
-- Update the bld table with auth_item values  

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (lin, auth_item_SHRT_NOMEN) = 
            ( SELECT NVL(ai.lin, -2), 
                  NVL(ai.SHRT_NOMEN, -2) 
              FROM   auth_item@pfsawh.lidbdev ai 
              WHERE  gb_pfsa_item_part_bld.niin = ai.niin 
            ) 
        WHERE niin LIKE '01%'; 
    
        COMMIT; 
    
        SELECT * FROM auth_item@pfsawh.lidbdev WHERE niin = '015148052'
    
    END IF; 
     
/*---------------------------*/
/*--  lin items            --*/    
/*---------------------------*/
    
-- Update the bld table with lin values  

    IF v_debug > 100 THEN 

        UPDATE gb_pfsa_item_part_bld 
        SET    (lin_GEN_NOMEN) = 
            ( SELECT NVL(ln.GEN_NOMEN, -2)  
              FROM   lin@pfsawh.lidbdev ln 
              WHERE  gb_pfsa_item_part_bld.lin = ln.lin 
            ) 
        WHERE  niin LIKE '01%';
    
        COMMIT; 

    END IF;
    
-- Insert LIN items not in bld table from GCSSA_LIN

    DELETE gb_pfsa_item_part_bld WHERE  part_UPDT_BY = 'GCSSA_LIN';

    INSERT 
    INTO   gb_pfsa_item_part_bld 
        (
        niin, 
        AUTH_ITEM_LIN,
        item_ctrl_nomen_35,
        item_data_full_nomen, 
        nsn, 
        fsc, 
        ecc_code, 
        cl_of_supply_cd, 
        part_LST_UPDT,
        part_STATUS,
        part_UPDT_BY 
        )
    SELECT  NVL(SUBSTR(lin.nsn, 5, 9), '000000000'), 
        lin.lin, 
        lin.item_nomen, 
        lin.gen_nomen, 
        nsn, 
        NVL(SUBSTR(lin.nsn, 1, 4), '0000'), 
        lin.ecc, 
        lin.supply_class, 
        lin.LST_UPDT,
        'Z',
        'GCSSA_LIN' 
    FROM    GCSSA_LIN@pfsawh.lidbdev lin    -- SELECT * FROM GCSSA_LIN@pfsawh.lidbdev
    WHERE NOT EXISTS ( 
                        SELECT AUTH_ITEM_LIN 
                        FROM   gb_pfsa_item_part_bld 
                        WHERE  AUTH_ITEM_LIN = lin.lin 
                     );
        
-- Insert LIN items not in bld table from GCSSA_HR_ASSET 

    DELETE gb_pfsa_item_part_bld WHERE  part_UPDT_BY = 'GCSSA_HR_ASSET';

    INSERT 
    INTO   gb_pfsa_item_part_bld 
        (
        niin, 
        AUTH_ITEM_LIN,
        nsn,
        fsc, 
        part_LST_UPDT,
        part_STATUS,
        part_UPDT_BY 
        )
    SELECT  
    DISTINCT NVL(SUBSTR(lin.nsn, 5, 9), '000000000'), 
        lin.lin, 
        nsn, 
        NVL(SUBSTR(lin.nsn, 1, 4), '0000'), 
        '01-JAN-1900', -- lin.LST_UPDT,
        'Z',
        'GCSSA_HR_ASSET' 
    FROM    GCSSA_HR_ASSET@pfsawh.lidbdev lin    -- SELECT * FROM GCSSA_HR_ASSET@pfsawh.lidbdev
    WHERE NOT EXISTS ( 
                        SELECT AUTH_ITEM_LIN 
                        FROM   gb_pfsa_item_part_bld 
                        WHERE  AUTH_ITEM_LIN = lin.lin 
                     )
        AND LENGTH(TRIM(nsn)) = 13;
        
-- Debug  
    
    IF v_debug > 1000 THEN 

        DBMS_OUTPUT.ENABLE(1000000);
        DBMS_OUTPUT.NEW_LINE;
    
        OPEN part_cur;
    
        LOOP
            FETCH part_cur 
            INTO  part_rec;
        
            EXIT WHEN part_cur%NOTFOUND 
                OR part_cur%ROWCOUNT > 1000;
        
            DBMS_OUTPUT.PUT_LINE(part_rec.part_niin || ', ' || 
                part_rec.item_ctrl_niin);
        
        END LOOP;
    
        CLOSE part_cur;
        
    END IF;
    
END;  
    
-- COMMIT    

/*

SELECT * 
FROM   gb_pfsa_item_part_bld 
WHERE  niin <> '000000000' 
ORDER BY niin; 

SELECT * 
FROM gb_pfsa_item_part_bld 
WHERE auth_item_lin IS NOT NULL 
ORDER BY auth_item_lin, niin; 

SELECT * 
FROM gb_pfsa_item_part_bld 
WHERE lin IN ('A79381', 'C17936', 'E03826', 'F60564', 'F86751', 'F90796', 
              'M51419', 'R45543', 'T13305', 'T53471', 'T73347', 'Z00384', 
              'Z32566') 
ORDER BY lin, niin; 

*/

         


DROP TABLE gb_pfsa_item_ref 

CREATE TABLE gb_pfsa_item_ref
    (
    LIN                           VARCHAR2(6)         DEFAULT '-1',     -- Line Item Number
    NSLIN                         VARCHAR2(6)         DEFAULT '-1',     -- Non-Standard Line Item Numbers 
    niin_mcn                      VARCHAR2(13),
    NSN                           VARCHAR2(15)        DEFAULT '-1',     -- National Stock Number
    NIIN                          VARCHAR2(9)         DEFAULT '-1',     -- National Item Identification Number 
    MCN                           VARCHAR2(13)        DEFAULT '-1',     -- Management Control Numbers 
    ECC                           VARCHAR2(2)         DEFAULT '-1',     -- 
    FSC                           VARCHAR2(2)         DEFAULT '-1',     -- Federal Supply Classification
    CL_OF_SUPPLY_CD               VARCHAR2(2)         DEFAULT '-1',     -- Class of Supply Code
    GEN_NOMEN                     VARCHAR2(200)       DEFAULT 'unk',
    record_source                 VARCHAR2(30),
    update_source                 VARCHAR2(30)
    )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


SELECT COUNT(*) AS itm_ctrl_cnt FROM item_control@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT fsc FROM item_control@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT EFF_DATE, COUNT(*) FROM item_control@pfsawh.lidbdev GROUP BY EFF_DATE ORDER BY EFF_DATE 
SELECT MAX(LENGTH(EFF_DATE)) FROM item_control@pfsawh.lidbdev
SELECT * FROM item_control@pfsawh.lidbdev ORDER BY niin 

SELECT COUNT(*) AS itm_data_cnt FROM item_data@pfsawh.lidbdev WHERE status = 'C'
SELECT DISTINCT nsn FROM item_data@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT UNPKGD_ITEM_WT, COUNT(*) FROM item_data@pfsawh.lidbdev GROUP BY UNPKGD_ITEM_WT ORDER BY UNPKGD_ITEM_WT 
SELECT MAX(LENGTH(UNPKGD_ITEM_WT)) FROM item_data@pfsawh.lidbdev
SELECT * FROM item_data@pfsawh.lidbdev 

SELECT COUNT(*) AS auth_itm_cnt FROM auth_item@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT lin FROM auth_item@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT wssc, COUNT(*) FROM auth_item@pfsawh.lidbdev GROUP BY wssc ORDER BY wssc 
SELECT MAX(LENGTH(SHRT_NOMEN)) FROM auth_item@pfsawh.lidbdev
SELECT * FROM auth_item@pfsawh.lidbdev 

SELECT COUNT(*) AS lin_cnt FROM lin@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT lin FROM lin@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT CTA_CD, COUNT(*) FROM lin@pfsawh.lidbdev GROUP BY CTA_CD ORDER BY CTA_CD 
SELECT MAX(LENGTH(PUB_DT_SB_700_20)) FROM lin@pfsawh.lidbdev
SELECT * FROM lin@pfsawh.lidbdev 

SELECT COUNT(*) AS manuf_part_cnt FROM manufacturer_part@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT act_meas FROM manufacturer_part@pfsawh.lidbdev WHERE status = 'C' 
SELECT DISTINCT sadc, COUNT(*) FROM manufacturer_part@pfsawh.lidbdev GROUP BY sadc ORDER BY sadc
SELECT MAX(LENGTH(mfg_part_num)) FROM manufacturer_part@pfsawh.lidbdev
SELECT * FROM manufacturer_part@pfsawh.lidbdev  


SELECT * FROM lin@pfsawh.lidbdev WHERE LIN = 'C17936' 
 
SELECT * FROM V_NIIN_MCN@pfsawh.lidbdev 

SELECT standard_army_item, COUNT(standard_army_item) 
FROM   V_NIIN_MCN@pfsawh.lidbdev 
GROUP BY standard_army_item  

SELECT standard_army_item, lin_nslin, COUNT(standard_army_item) 
FROM V_NIIN_MCN@pfsawh.lidbdev 
GROUP BY standard_army_item, lin_nslin
ORDER BY standard_army_item, lin_nslin

SELECT MAX(lst_updt) FROM V_NIIN_MCN@pfsawh.lidbdev WHERE standard_army_item = 'A'
SELECT MAX(lst_updt) FROM V_NIIN_MCN@pfsawh.lidbdev WHERE standard_army_item = 'N'
SELECT MAX(lst_updt) FROM V_NIIN_MCN@pfsawh.lidbdev WHERE standard_army_item = 'Y'

DELETE  gb_pfsa_item_ref
   
INSERT 
INTO    gb_pfsa_item_ref 
    (
    LIN, 
    NSLIN, 
    niin_mcn, 
    NSN,
    MCN, 
    NIIN, 
    CL_OF_SUPPLY_CD, 
    GEN_NOMEN,
    record_source
    )
SELECT  
    CASE standard_army_item   
    	WHEN 'Y' THEN NVL(vnm.lin_nslin, '-1')
        ELSE '-1'
    END, 
    CASE standard_army_item  
    	WHEN 'N' THEN NVL(vnm.lin_nslin, '-1')
        ELSE '-1'
    END, 
    niin_mcn, 
    CASE LENGTH(TRIM(vnm.niin_mcn))
        WHEN 9 THEN 'xxxx' || vnm.niin_mcn 
        ELSE 'size err'
    END, 
    CASE standard_army_item
        WHEN 'N' THEN vnm.niin_mcn 
        ELSE '-1'
    END, 
    CASE LENGTH(TRIM(vnm.niin_mcn))
        WHEN 9 THEN vnm.niin_mcn 
        ELSE 'size err'
    END, 
    vnm.cl_of_supply_cd, 
    vnm.lin_nomen, 
    'V_NIIN_MCN@pfsawh.lidbdev vnm'
FROM	V_NIIN_MCN@pfsawh.lidbdev vnm 
ORDER BY vnm.niin_mcn 


SELECT COUNT(*) FROM gb_pfsa_item_ref  

SELECT * FROM gb_pfsa_item_ref WHERE LIN = 'C17936'
 
                 
SELECT * FROM gcssa_lin@pfsawh.lidbdev


MERGE 
INTO    gb_pfsa_item_ref r 
USING	(
        SELECT lin, nsn, 'gcssa_lin@pfsawh.lidbdev lin'  
        FROM   gcssa_lin@pfsawh.lidbdev 
        ) lin 
        ON (r.lin = lin.lin AND r.niin = SUBSTR(lin.nsn, 5, 9)) 
        WHEN MATCHED THEN 
            UPDATE SET nsn = lin.nsn, 
                       update_source = 'gcssa_lin@pfsawh.lidbdev' 
		WHEN NOT MATCHED THEN 
            INSERT (lin, nsn, niin, record_source)
            VALUES (lin.lin, lin.nsn, SUBSTR(lin.nsn, 5, 9), 'gcssa_lin@pfsawh.lidbdev')  
                

SELECT COUNT(*) FROM gb_pfsa_item_ref  


SELECT DISTINCT LENGTH(TRIM(nsn)), NSN FROM GCSSA_HR_ASSET@pfsawh.lidbdev WHERE LENGTH(TRIM(nsn)) > 13 ORDER BY LENGTH(TRIM(nsn))

MERGE  
INTO    gb_pfsa_item_ref r 
USING   (
        SELECT DISTINCT lin, nsn 
        FROM   GCSSA_HR_ASSET@pfsawh.lidbdev 
        ) lin  
        ON ( r.lin = lin.lin AND r.nsn = lin.nsn )
        WHEN MATCHED THEN 
        	UPDATE SET update_source = 'GCSSA_HR_ASSET@pfsawh.lidbdev' 
        WHEN NOT MATCHED THEN 
            INSERT (lin, nsn, niin, record_source)
            VALUES (lin.lin, lin.nsn, SUBSTR(lin.nsn, 5, 9), 'GCSSA_HR_ASSET@pfsawh.lidbdev')

-- COMMIT   

SELECT * FROM gb_pfsa_item_ref ORDER BY niin  

SELECT * FROM gb_pfsa_item_ref WHERE cl_of_supply_cd = '9' ORDER BY lin  

SELECT * FROM gb_pfsa_item_ref WHERE cl_of_supply_cd = '7' AND lin LIKE 'T%' ORDER BY lin  

SELECT * FROM gb_pfsa_item_ref WHERE update_source = 'gcssa_lin@pfsawh.lidbdev' ORDER BY lin 

SELECT * FROM gb_pfsa_item_ref WHERE record_source = 'GCSSA_HR_ASSET@pfsawh.lidbdev' ORDER BY lin 

SELECT * FROM gb_pfsa_item_ref WHERE update_source = 'GCSSA_HR_ASSET@pfsawh.lidbdev' ORDER BY lin 

SELECT * FROM gb_pfsa_item_ref WHERE lin IN ('-1', 'null', 'size err') ORDER BY lin 

SELECT * FROM gb_pfsa_item_ref WHERE nsn IN ('-1', 'size err') ORDER BY nsn, lin 


SELECT	NVL(vnm.lin_nslin, '-1'), 
    vnm.niin_mcn, 
    'xxxx' || vnm.niin_mcn  AS nsn, 
    ' | ', vnm.*
FROM	V_NIIN_MCN@pfsawh.lidbdev vnm 
ORDER BY vnm.niin_mcn

/*

SELECT * 
FROM   V_NIIN_MCN@pfsawh.lidbdev 
WHERE  nomen_35 LIKE '%SENSE%' 
    OR lin_nomen LIKE '%SENSE%' 
ORDER BY niin_mcn  

*/

/* 

SELECT fsc, fsc_desc
FROM   fsc_ref@pfsawh.lidbdev 
ORDER BY fsc

*/

/*

SELECT *
FROM   xb@pfsawh.lidbdev 
WHERE  lcnamexb LIKE 'TRADE%'

*/

/*

SELECT * 
FROM   item_control@pfsawh.lidbdev 
WHERE (nomen_35 LIKE 'SENSOR,%' OR nomen_35 LIKE 'SENSING%' )
ORDER BY nomen_35

SELECT 
DISTINCT nomen_35, niin  
FROM   item_control@pfsawh.lidbdev 
WHERE (nomen_35 LIKE 'SENSOR,%' OR nomen_35 LIKE 'SENSING%' ) 
	AND cl_of_supply_cd = 9
ORDER BY nomen_35

*/	
