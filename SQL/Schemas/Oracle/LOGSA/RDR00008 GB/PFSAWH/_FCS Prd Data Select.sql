SELECT pme.* 
FROM   bld_pfsa_maint_event pme
WHERE  pme.sys_ei_niin = '013285964' 
    AND pme.maint_item_sn BETWEEN 'LA27201' AND 'LA27220'
ORDER BY pme.sys_ei_sn; 

SELECT pme.* 
FROM   bld_pfsa_maint_event pme
WHERE  pme.sys_ei_niin = '014360005' 
    AND pme.maint_item_sn BETWEEN '2AGR0428Y' AND '2AGR0477Y'
ORDER BY pme.sys_ei_sn;


SELECT * 
FROM   bld_pfsa_sn_ei_hist 
WHERE  sys_ei_niin = '013285964' 
    AND sys_ei_sn BETWEEN 'LA27201' AND 'LA27220'
ORDER BY sys_ei_sn; 
    
SELECT * 
FROM   bld_pfsa_sn_ei_hist 
WHERE  sys_ei_niin = '014360005' 
    AND sys_ei_sn BETWEEN '2AGR0428Y' AND '2AGR0477Y'
ORDER BY sys_ei_sn; 
    
    
SELECT * 
FROM   bld_pfsa_equip_avail 
WHERE  sys_ei_niin = '013285964' 
    AND pfsa_item_id BETWEEN 'LA27201' AND 'LA27220'  
ORDER BY pfsa_item_id; 
    
SELECT * 
FROM   bld_pfsa_equip_avail 
WHERE  sys_ei_niin = '014360005' 
    AND pfsa_item_id BETWEEN '2AGR0428Y' AND '2AGR0477Y' 
ORDER BY pfsa_item_id; 


/*---------------------------------------------------------------------------*/ 


SELECT * 
FROM   pfsa_equip_avail 
WHERE  sys_ei_niin = '013285964' AND 
(
sys_ei_sn LIKE 'LA27201M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27202M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27203M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27204M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27205M' AND ready_date > TO_DATE('01/15/2008', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27208M' AND ready_date > TO_DATE('01/15/2008', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27210M' AND ready_date > TO_DATE('10/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27211M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27212M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27213M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27214M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27223M' AND ready_date > TO_DATE('12/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27226M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') OR
sys_ei_sn LIKE 'LA27240M' AND ready_date > TO_DATE('11/15/2007', 'MM/DD/YYYY') 
);


/*---------------------------------------------------------------------------*/ 


SELECT wgu.uic, 
    wgu.unt_desc, 
    '|', wgu.* 
FROM   webprop.gcssa_uic wgu 
WHERE  wgu.uic IN (
    'WJR1T0', 
    'WJRXA0', 'WJRXT0', 
    'WJRYA0', 'WJRYB0', 'WJRYT0', 
    'WJR0F0', 
    'WJR2B0', 
    'WJRZA0', 'WJRZC0', 'WJRZD0', 'WJRZE0', 'WJRZT0', 
    'W6KRT0')
ORDER BY wgu.uic; 

SELECT ga.uic, 
    ga.lin, 
    ga.nsn, 
    ga.qty, 
    ga.qty_due_in, 
    '|', ga.* 
FROM   webprop.gcssa_assets ga 
WHERE  ga.uic IN (
    'WJR1T0', 
    'WJRXA0', 'WJRXT0', 
    'WJRYA0', 'WJRYB0', 'WJRYT0', 
    'WJR0F0', 
    'WJR2B0', 
    'WJRZA0', 'WJRZC0', 'WJRZD0', 'WJRZE0', 'WJRZT0', 
    'W6KRT0')
ORDER BY ga.uic; 

SELECT gha.uic, 
    wgu.unt_desc, 
    gha.lin, 
    SUBSTR(gha.nsn, 5, 9) AS niin, 
    SUBSTR(gha.nsn, 1, 4) AS fsc, 
    gha.nsn, 
    gha.serial_num, 
    gha.registration_num, 
    gha.qty, 
    NVL(gha.qty_due_in, 0), 
    gha.acq_date,
    gha.lst_updt,  
    NVL(gha.dodaac, ' ') 
--    , '|', gha.* 
FROM   webprop.gcssa_hr_asset gha, 
    webprop.gcssa_uic wgu 
WHERE  gha.uic = wgu.uic 
    AND gha.uic IN (
        'WJR1T0', 
        'WJRXA0', 'WJRXT0', 
        'WJRYA0', 'WJRYB0', 'WJRYT0', 
        'WJR0F0', 
        'WJR2B0', 
        'WJRZA0', 'WJRZC0', 'WJRZD0', 'WJRZE0', 'WJRZT0', 
        'W6KRT0' )
    AND SUBSTR(gha.nsn, 5, 9) IN ( 
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052', 
        '002234919' ) 
ORDER BY gha.uic, gha.lin, gha.serial_num; 


SELECT a.owner, 
    wgu.unt_desc, 
    a.lin, 
    a.gc.nomen, 
    a.eff_dt,
    a.erc,
    a.rmks,
    a.s_class,
    a.type_auth_cd,
    NVL(a.proj_cd, ' '),
    a.para_no,
    a.comd_con_no,
    a.rqd_qty,
    a.auth_qty,
    a.status,
    a.updt_by,
    a.lst_updt
FROM   auth1.authorized a   
LEFT OUTER JOIN webprop.gcssa_uic wgu ON a.owner = wgu.uic  
LEFT OUTER JOIN webprop.gcssa_catalog gc ON a.lin = gc.lin  
WHERE a.status = 'C' 
    AND a.owner IN (
        'WJR1T0', 
        'WJRXA0', 'WJRXT0', 
        'WJRYA0', 'WJRYB0', 'WJRYT0', 
        'WJR0F0', 
        'WJR2B0', 
        'WJRZA0', 'WJRZC0', 'WJRZD0', 'WJRZE0', 'WJRZT0', 
        'W6KRT0' )
    AND a.lin IN ( 
        'A79381', 'C17936', 'E03826', 'F60564', 'F86571', 
        'F90796', 'G18358', 'M51419', 'R45543', 'T13305', 
        'T53471', 'T73347' ) 
ORDER BY a.owner, a.lin, a.rmks; 


/*

CREATE TABLE WEBPROP.GCSSA_UIC 
(
  UIC                VARCHAR2(6 BYTE)           NOT NULL,
  ALO                CHAR(1 BYTE),
  ASG_CD             VARCHAR2(2 BYTE),
  AUG_IND            CHAR(1 BYTE),
  BRANCH             VARCHAR2(2 BYTE),
  COMP_CD            VARCHAR2(1 BYTE),
  EFF_DT             DATE,
  TPSN               VARCHAR2(5 BYTE),
  TPSN_CD            VARCHAR2(2 BYTE),
  GEO_CMD            VARCHAR2(6 BYTE),
  LOC_CD             VARCHAR2(3 BYTE),
  MACOM              VARCHAR2(10 BYTE),
  MTOE               VARCHAR2(10 BYTE),
  ORG_TYP            CHAR(1 BYTE),
  PRES_LOC           VARCHAR2(21 BYTE),
  SRC                VARCHAR2(13 BYTE),
  STATUS             CHAR(1 BYTE),
  UIC_ALT            VARCHAR2(6 BYTE),
  UNT_LVL_CD         VARCHAR2(3 BYTE),
  UNT_TYP_IND        VARCHAR2(20 BYTE),
  COMD_CON_NUM       VARCHAR2(6 BYTE),
  UNT_NO             VARCHAR2(4 BYTE),
  CARS               VARCHAR2(2 BYTE),
  DIV_LOG_CD         VARCHAR2(1 BYTE),
  UNT_DESC           VARCHAR2(50 BYTE),
  PROJ_CD            VARCHAR2(3 BYTE),
  PERS_EQUIP         VARCHAR2(4 BYTE),
  UIC_4              VARCHAR2(4 BYTE),
  DSSC               VARCHAR2(1 BYTE),
  CMD_ACT_CD         VARCHAR2(2 BYTE),
  COMMANDER          VARCHAR2(21 BYTE),
  CMD_RANK           VARCHAR2(6 BYTE),
  HR_NAME            VARCHAR2(20 BYTE),
  HR_PHONE           VARCHAR2(15 BYTE),
  HR_EMAIL           VARCHAR2(50 BYTE),
  TF_ID_CD           VARCHAR2(1 BYTE),
  TF_PBIC_IND        VARCHAR2(10 BYTE),
  UAT                VARCHAR2(9 BYTE),
  UPDT_BY            VARCHAR2(30 BYTE),
  LST_UPDT           DATE,
  AUTH_EFF_DT_PREV   DATE,
  AUTH_EFF_DT        DATE,
  AUTH_EFF_DT_PRJ1   DATE,
  AUTH_EFF_DT_PRJ2   DATE,
  DEACT_CD           VARCHAR2(1 BYTE),
  DEACT_DATE         DATE,
  INS_CD             VARCHAR2(4 BYTE),
  SESS_ID            NUMBER,
  DT_LST_INV         DATE,
  SEQ_ID             VARCHAR2(32 BYTE)          NOT NULL,
  DELETE_FLAG        VARCHAR2(32 BYTE)          NOT NULL,
  SITE_PRIORITY      VARCHAR2(1 BYTE),
  ROW_CREATION_DATE  DATE,
  EXTRA_STRING       VARCHAR2(1 BYTE),
  EXTRA_DATE         DATE,
  EXTRA_NUM          NUMBER,
  EXTRA2_STRING      VARCHAR2(100 BYTE),
  EXTRA2_DATE        DATE,
  EXTRA2_NUM         NUMBER,
  TIMESTAMP_ZONE     TIMESTAMP(6) WITH LOCAL TIME ZONE NOT NULL,
  PB_LVL_FLAG        VARCHAR2(1 BYTE),
  UNIT_LVL_FLAG      VARCHAR2(1 BYTE),
  STAFF_LVL_FLAG     VARCHAR2(1 BYTE),
  ECHELON_CODE       VARCHAR2(3 BYTE),
  LOCATION_GRID      VARCHAR2(13 BYTE)
); 

*/ 


/* 

CREATE TABLE AUTH1.AUTHORIZED
(
  LIN           VARCHAR2(6 BYTE)                NOT NULL,
  OWNER         VARCHAR2(6 BYTE)                NOT NULL,
  EFF_DT        DATE                            NOT NULL,
  ERC           CHAR(1 BYTE)                    NOT NULL,
  RMKS          VARCHAR2(3 BYTE)                NOT NULL,
  S_CLASS       VARCHAR2(10 BYTE),
  TYPE_AUTH_CD  VARCHAR2(2 BYTE)                NOT NULL,
  PROJ_CD       VARCHAR2(3 BYTE),
  PARA_NO       VARCHAR2(4 BYTE)                NOT NULL,
  COMD_CON_NO   VARCHAR2(6 BYTE),
  RQD_QTY       NUMBER,
  AUTH_QTY      NUMBER,
  STATUS        CHAR(1 BYTE),
  UPDT_BY       VARCHAR2(30 BYTE),
  LST_UPDT      DATE
)

*/ 