/*

DROP TABLE tmp_lin_etl

CREATE GLOBAL TEMPORARY TABLE tmp_lin_etl 
		(
		lin				VARCHAR2(6), 
		nsn				VARCHAR2(13), 
		unit_price		NUMBER, 
		item_nomen		VARCHAR2(25), 
		gen_nomen		VARCHAR2(100), 
		lst_updt		DATE
		)
	ON COMMIT DELETE ROWS; 
	
*/

DECLARE 

-- standard variables 
	
	v_ErrorCode						VARCHAR2(6)		:= NULL;
	ps_location						VARCHAR2(10)	:= 'BEGIN';
	ps_procedure_name				VARCHAR2(30)	:= 'PFSA_DATE_DIM';
	v_ErrorText						VARCHAR2(200)	:= '';
	ps_id_key						VARCHAR2(200)	:= NULL;
	
-- output variables  

	v_item_id			INTEGER; 
	v_lin				VARCHAR2(6); 
	v_nsn				VARCHAR2(13); 
	v_unit_price		NUMBER; 
	v_item_nomen		VARCHAR2(25); 
	v_gen_nomen			VARCHAR2(100); 
	v_status			VARCHAR2(1); 
	v_lst_updt			DATE;
	
-- pfsa_system_dim cursor  
	
	CURSOR pfsa_item_dim_cur IS
		SELECT	item_id, lin, nsn, unit_price, item_nomen, gen_nomen, status, lst_updt  
		FROM	gb_pfsa_item_dim
		ORDER BY  lin; 
		
-- tmp_lin_etl cursor  
	
	CURSOR tmp_lin_etl_cur IS
		SELECT	lin, nsn, unit_price, item_nomen, gen_nomen, lst_updt  
		FROM	tmp_lin_etl
		ORDER BY  lin; 
		
BEGIN  
	DBMS_OUTPUT.ENABLE(1000000);

	DBMS_OUTPUT.NEW_LINE;
	DBMS_OUTPUT.PUT_LINE	('=====================');
	
	DBMS_OUTPUT.PUT_LINE	('***  PFSA_ITEM_DIM  ***');
	DBMS_OUTPUT.PUT_LINE	('*  clear tmp_lin_etl  *'); 
	DBMS_OUTPUT.NEW_LINE;
	
	DELETE	gb_pfsawh_item_dim;  
	DELETE	tmp_lin_etl;  
	
	INSERT 
	INTO	gb_pfsawh_item_dim 
		( 
		lin, 
		army_type_designator, 
		nsn, 
		ricc_item_code, 
		aba, 
		sos, 
		ciic, 
		supply_class, 
		ecc_code, 
		unit_price,
		unit_indicator,
		item_nomen, 
		gen_nomen, 
		lst_updt
		) 
	SELECT	lin, 
		NVL(army_type_designator, 'unk'), 
		nsn, 
		ricc, 
		aba, 
		sos, 
		ciic, 
		supply_class, 
		ecc, 
		NVL(unit_price, -1), 
		ui, 
		NVL(item_nomen, 'unk'), 
		NVL(gen_nomen, 'unk'),  
		lst_updt 
	FROM	gcssa_lin@pfsawh.lidbdev lin 
	WHERE	(unit_price > 25000 
       OR unit_price IS NULL 
       OR lin IN ('A79381', 'C17936', 'E03826', 'F60564', 'F86571', 'F90796', 'M51419', 'R45543', 'T13168', 'T13305', 
				      'T53471', 'T73347', 'Z00384', 'Z32566')
         )
	ORDER BY lin;
	
--	SELECT * FROM tmp_lin_etl ORDER BY lst_updt DESC;
--	SELECT * FROM gb_pfsa_system_dim ORDER BY lin;
--	SELECT * FROM gb_pfsa_system_dim WHERE item_nomen LIKE 'TANK%' ORDER BY lst_updt DESC;
	
	DBMS_OUTPUT.NEW_LINE;
	
	OPEN pfsa_item_dim_cur;
	
	LOOP
		FETCH	pfsa_item_dim_cur 
		INTO	v_item_id, v_lin, v_nsn, v_unit_price, v_item_nomen, v_gen_nomen, v_status, v_lst_updt; 
		
		EXIT WHEN pfsa_item_dim_cur%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(v_item_id || ' -|- ' || v_lin || ' -|- ' || v_nsn || ' -|- ' || v_item_nomen || ' -|- ' || v_gen_nomen 
			 || ' -|- ' || v_status || ' -|- ' || v_lst_updt);
		
	END LOOP;
	
	CLOSE pfsa_item_dim_cur;

END;

/*

SELECT * FROM gb_pfsa_item_dim ORDER BY lin

*/

/*

SELECT	*
FROM	V_NIIN_MCN@pfsawh.lidbdev 
WHERE	lin_nslin IS NOT NULL 
	AND unit_price > 25000
	AND standard_army_item = 'Y' 
ORDER BY lin_nslin

SELECT	* 
FROM	GCSSA_LIN@pfsawh.lidbdev 
WHERE	gen_nomen LIKE '%H-47%' 
ORDER BY lin 

SELECT	* 
FROM	GCSSA_ASSETS@pfsawh.lidbdev 

*/

/*
SELECT	eic.eic AS eic_eic,  
	lin.eic AS lin_eic,
	eic.niin, 
	lin.lin, 
	lin.nsn, 
	eic.eic_model, 
	eic.mat_cat_cd_4, 
	eic.mat_cat_cd_4_5, 
	pb.uic, 
	pb.serial_num, 
	pb.registration_num, 
	pb.acq_date,
--	'|', 
--	eic.*
	'||', 
	lin.ricc,
	lin.cmc, 
	lin.aba, 
	lin.sos,
	lin.supply_class, 
	lin.ui, 
	lin.log_cntl_cd,
	lin.srrc, 
	lin.ciic, 
	lin.unit_price,
	lin.item_nomen, 
	lin.gen_nomen, 
	lin.army_type_designator,
	lin.type_class_cd, 
	lin.aac, 
	lin.hmic,
--	'|||',
--	lin.*, 
	'||||',
	pb.*, 
	'|||||',
	eic.status, 
	eic.lst_updt,  
	eic.updt_by,  
	lin.lst_updt,  
	pb.lst_updt 
FROM	gcssa_lin@pfsawh.lidbdev lin 		 
	LEFT OUTER JOIN gcssa_hr_asset@pfsawh.lidbdev pb ON pb.lin = lin.lin 
	LEFT OUTER JOIN eic_master@pfsawh.lidbdev eic ON eic.NIIN = SUBSTR(lin.NSN, 5, 9)
WHERE	lin.lin IN ('F60564', 'F86571', 'F90796', 'T13168', 'T13305', 'T73347')
	AND pb.uic IN ('WH54AA', 'WH54A0', 'WH54B0', 'WH54C0', 'WH54T0', 'WH54Y0')
ORDER BY lin.lin 
*/

/*

SELECT	* 
FROM	GCSSA_HR_ASSET@pfsawh.lidbdev 
WHERE	uic IN (	'WH54AA', 'WH54A0', 'WH54B0', 'WH54C0', 'WH54T0', 'WH54Y0', 
	 			'WS5SAA', 'WS5SA1', 'WS5SA2', 'WS5SA3', 'WS5SA4',  
	 			'WAEQY1', 'WAEQAD', 'WAEQBD', 'WAEQCD', 'WAEQTD', 'WAEQHD', 'WAEQYH', 'WAEQ1C', 'WAEQHA', 'WAEQ1A' )
ORDER BY uic, lin, serial_num

SELECT DISTINCT pb.lin, pb.uic, COUNT(pb.lin), u.unt_desc, u.pres_loc, lin.item_nomen 
FROM	GCSSA_HR_ASSET@pfsawh.lidbdev pb
	LEFT OUTER JOIN d_uic@pfsawh.lidbdev u ON pb.uic = u.uic 
	LEFT OUTER JOIN gcssa_lin@pfsawh.lidbdev lin ON lin.lin = pb.lin 
WHERE	pb.lin IN ('A79381', 'C17936', 'E03826', 'F60564', 'F86571', 'F90796', 'M51419', 'R45543', 'T13168', 'T13305', 
				'T53471', 'T73347', 'Z00384', 'Z32566') 
--	AND u.pres_loc IN ('FT BLISS')
GROUP BY pb.lin, pb.uic, unt_desc, u.pres_loc, lin.item_nomen
ORDER BY pb.lin, pb.uic

SELECT DISTINCT lin, uic 
FROM	GCSSA_HR_ASSET@pfsawh.lidbdev 
WHERE	lin IN ('F60564', 'F86571', 'F90794', 'T13168', 'T13305', 'T73347') 
	 AND uic IN (	'WH54AA', 'WH54A0', 'WH54B0', 'WH54C0', 'WH54T0', 'WH54Y0', 
	 				'WAEQY1', 'WAEQAD', 'WAEQBD', 'WAEQCD', 'WAEQTD', 'WAEQHD', 'WAEQYH', 'WAEQ1C', 'WAEQHA', 'WAEQ1A' )
ORDER BY lin, uic

SELECT	
DISTINCT lin 
FROM	GCSSA_HR_ASSET@pfsawh.lidbdev 
ORDER BY lin

SELECT	* 
FROM	D_UIC@pfsawh.lidbdev 

*/	

/*
----- ECC -----

SELECT	ecc.* 
FROM	ecc_ref@pfsawh.lidbdev ecc 
WHERE	status = 'C'
ORDER BY ecc 

SELECT	
DISTINCT	status
FROM	ecc_ref@pfsawh.lidbdev ecc 

----- FSC -----

SELECT	fsc.* 
FROM	fsc_ref@pfsawh.lidbdev fsc 
ORDER BY fsc 

SELECT	
DISTINCT	status
FROM	fsc_ref@pfsawh.lidbdev ecc 

----- MAT_CTA -----

SELECT	mc45.* 
FROM	mat_cat_4_5_ref@pfsawh.lidbdev mc45
WHERE	mat_cat_cd_5_desc LIKE '%M7%' 
ORDER BY mat_cat_cd_4_5 

SELECT	
DISTINCT	status
FROM	mat_cat_4_5_ref@pfsawh.lidbdev mc45 

SELECT	mc4.* 
FROM	mat_cat_4_ref@pfsawh.lidbdev mc4 
ORDER BY mat_cat_cd_4 

SELECT	mc3.* 
FROM	mat_cat_3_ref@pfsawh.lidbdev mc3 
ORDER BY mat_cat_cd_3 

SELECT	mc2.* 
FROM	mat_cat_2_ref@pfsawh.lidbdev mc2 
ORDER BY mat_cat_cd_2 

SELECT	mc1.* 
FROM	mat_cat_1_ref@pfsawh.lidbdev mc1 
ORDER BY mat_cat_cd_1 

----- EIC -----

SELECT	eic.* 
FROM	eic_master@pfsawh.lidbdev eic 
WHERE	eic_model LIKE 'M1%'

*/

/*

SELECT	* 
FROM	POTENTIAL_PFSA_ITEM@pfsawh.lidbdev
WHERE	LIN is not null 
ORDER BY  LIN, ITEM_NIIN 

*/

/*

DECLARE
	v_lin			VARCHAR2(6);
	v_item_niin		VARCHAR2(9);
	v_item_nomen	VARCHAR2(35);
	v_gen_nomen		VARCHAR2(64);
	v_eic			VARCHAR2(3);
	v_ricc			VARCHAR2(1);

	CURSOR pot_item_cur IS
		SELECT	lin, item_niin, RPAD(item_nomen, 35, ' '), NVL(eic, '???') 
		FROM	POTENTIAL_PFSA_ITEM@pfsawh.lidbdev
		WHERE	lin is not null 
			AND UPPER(item_nomen) LIKE UPPER('%H-47%')
--			AND UPPER(eic) LIKE UPPER('RC%')
		ORDER BY  lin, item_niin; 
		
	CURSOR gcssa_item_cur IS
		SELECT	lin, RPAD(item_nomen, 35, ' '), RPAD(gen_nomen, 35, ' '), ricc 
		FROM	GCSSA_LIN@pfsawh.lidbdev
		WHERE	lin is not null 
			AND UPPER(gen_nomen) LIKE UPPER('%HELIC%')
		ORDER BY  lin; 
		
BEGIN
	DBMS_OUTPUT.ENABLE(1000000);
	
	OPEN pot_item_cur;
	
	LOOP
		FETCH pot_item_cur 
		INTO	v_lin, v_item_niin, v_item_nomen, v_eic;
		
		EXIT WHEN pot_item_cur%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(v_lin || ' ' || v_item_niin || ' ' || v_item_nomen || ' ' || v_eic);
		
	END LOOP;
	
	CLOSE pot_item_cur;
	
	DBMS_OUTPUT.NEW_LINE;
	
	OPEN gcssa_item_cur;
	
	LOOP
		FETCH gcssa_item_cur 
		INTO	v_lin, v_item_nomen, v_gen_nomen, v_ricc;
		
		EXIT WHEN gcssa_item_cur%NOTFOUND;
		
		DBMS_OUTPUT.PUT_LINE(v_lin || ' ' || v_item_nomen || ' ' || v_gen_nomen || ' ' || v_ricc);
		
	END LOOP;
	
	CLOSE gcssa_item_cur;
END; 

*/

/*
SELECT	* 
FROM	PFSA_SYSTEM_DIM

SELECT	
DISTINCT	LIN, SYS_EI_NOMEN 
FROM	PFSA_SYSTEM_DIM
ORDER BY LIN

SELECT	* 
FROM	PFSA_SYSTEM_DIM
WHERE	LIN IN ('H30517')

*/

