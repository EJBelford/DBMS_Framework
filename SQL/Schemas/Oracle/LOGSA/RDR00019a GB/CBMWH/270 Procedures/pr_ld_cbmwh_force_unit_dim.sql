/*--*----|----*----|----*----|---- team itss ----*----|----|----*----|----*---*/
--
--         name: cbmwh_force_unit_dim
--      purpose: to calculate the desired information.
--
-- table source: cbmwh_force_unit_dim.sql 
--
--   created by: gene belford 
-- created date: 07 april 2008 
--
--  assumptions:
--
--  limitations:
--
--        notes:
--
-- 
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
--     change history:
-- ddmmmyy - who - ticket # - cr # - details
-- 07apr08 - gb  -          -      - created 
--
/*--*----|----*----|----*----|---- team itss ----*----|----|----*----|----*---*/

/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                 populate                                   */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

/*

DROP TABLE tmp_uic;

CREATE GLOBAL TEMPORARY TABLE tmp_uic 
    (
    uic     VARCHAR2(6) 
    )
ON COMMIT PRESERVE ROWS; 
 
*/
    
DECLARE

    CURSOR code_cur is
        SELECT a.rec_id, a.uic
        FROM cbmwh_force_unit_dim a
        ORDER BY a.uic;
        
    code_rec    code_cur%ROWTYPE; 
    
    CURSOR status_cur is
        SELECT a.uic, MAX(wh_effective_date) AS maxx, COUNT(uic) AS cnt
        FROM pfsawh_force_unit_dim a
        WHERE  -- status = 'N' AND 
            sorts_uic_status = 'C' 
        GROUP BY a.uic 
        ORDER BY a.uic;
        
    status_rec    status_cur%ROWTYPE; 
    
    v_loopcnt   number; 
    v_force_id  cbmwh_identities.last_dimension_identity%TYPE; 
    v_uic       cbmwh_force_unit_dim.uic%TYPE; 
        
BEGIN 

    DELETE tmp_uic;  
    
--    DELETE cbmwh_force_unit_dim;  
    
    COMMIT; 
    
/*----------------------------------------------------------------------------*/
/*----- Recover dimension records from PFSAWH.PFSAWH_FORCE_UNIT_DIM      -----*/
/*----------------------------------------------------------------------------*/    
    
--    ALTER TRIGGER tr_i_cbmwh_force_unit_seq DISABLE;
--    
--    INSERT 
--    INTO   cbmwh_force_unit_dim 
--        (
--        rec_id,
--        force_unit_id, 
--        uic,
--        unit_description,
--        force_parent_unit_id,
--        geo_id,
--        component_code,
--        component_description,
--        homestation_state_or_country,
--        d_date,
--        r_date,
--        s_date,
--        edd1_date,
--        edd2_date,
--        mre_date,
--        dodaac,
--        ari_list_ref_date,
--        unit_in_reset,
--        sorts_uic_status,
--        macom,
--        pfsa_org,
--        pfsa_tpsn,
--        pfsa_branch,
--        pfsa_parent_org,
--        pfsa_cmd_uic,
--        pfsa_parent_uic,
--        pfsa_geo_cd,
--        pfsa_comp_cd,
--        pfsa_goof_uic_ind,    
--        bct_force_unit_dim_id,
--        bct,
--        bct_description,
--        bct_icon,
--        bct_levels,
--        bct_tree_level, 
--        bct_uic_is_leaf,
--        bct_d_date,
--        bct_r_date,
--        bct_s_date,
--        bct_edd1_date,
--        bct_edd2_date,
--        bct_mre_date,
--        uto_force_unit_dim_id,
--        uto_unit_description,
--        status, updt_by, lst_updt,
--        active_flag, 
--        wh_record_status,  wh_last_update_date, 
--        wh_effective_date, wh_expiration_date,
--        insert_by, insert_date, 
--        update_by,
--        delete_by, delete_flag, delete_date,
--        hidden_by, hidden_flag, hidden_date 
--        )
--    SELECT 
--        rec_id,
--        force_unit_id,
--        uic,
--        unit_description,
--        force_parent_unit_id,
--        geo_id,
--        component_code,
--        component_description,
--        homestation_state_or_country,
--        d_date,
--        r_date,
--        s_date,
--        edd1_date,
--        edd2_date,
--        mre_date,
--        dodaac,
--        ari_list_ref_date,
--        unit_in_reset,
--        sorts_uic_status,
--        macom,
--        pfsa_org,
--        pfsa_tpsn,
--        pfsa_branch,
--        pfsa_parent_org,
--        pfsa_cmd_uic,
--        pfsa_parent_uic,
--        pfsa_geo_cd,
--        pfsa_comp_cd,
--        pfsa_goof_uic_ind,    
--        bct_force_unit_dim_id,
--        bct,
--        bct_description,
--        bct_icon,
--        bct_levels,
--        bct_tree_level, 
--        bct_uic_is_leaf,
--        bct_d_date,
--        bct_r_date,
--        bct_s_date,
--        bct_edd1_date,
--        bct_edd2_date,
--        bct_mre_date,
--        uto_force_unit_dim_id,
--        uto_unit_description,
--        status, updt_by, lst_updt,
--        active_flag, 
--        wh_record_status,  wh_last_update_date,
--        wh_effective_date, wh_expiration_date,
--        insert_by, insert_date, 
--        update_by,
--        delete_by, delete_flag, delete_date,
--        hidden_by, hidden_flag, hidden_date 
--    FROM pfsawh.pfsawh_force_unit_dim; 
--    
--    COMMIT; 
--    
--    ALTER TRIGGER tr_i_cbmwh_force_unit_seq ENABLE;

/*----------------------------------------------------------------------------*/
/*----- merge dimension record from pfsa_org_hist@pfsaw.lidb             -----*/
/*----------------------------------------------------------------------------*/    
    
    MERGE 
    INTO  cbmwh_force_unit_dim fu 
    USING ( 
          SELECT    pfsa_org,
                    day_date_from,
                    day_date_thru,
                    uic,
                    derived_unt_desc,
                    macom,
                    tpsn,
                    branch,
                    parent_org ,
                    cmd_uic,
                    parent_uic,
                    geo_cd,
                    comp_cd,
                    lst_updt,
                    updt_by,
                    goof_uic_ind 
          FROM pfsa_org_hist@pfsaw.lidb  
          WHERE day_date_thru = TO_DATE('31-Dec-4712', 'dd-mon-yyyy') 
              AND LENGTH(pfsa_org) = 6 
              AND UIC IS NOT NULL 
              AND uic <> 'UNKNWN' 
          ) poh 
    ON (fu.uic = poh.uic 
        AND fu.wh_effective_date = poh.day_date_from ) 
    WHEN MATCHED THEN 
        UPDATE 
        SET fu.pfsa_org = poh.pfsa_org ,
--            fu.wh_effective_date = poh.day_date_from ,
            fu.wh_expiration_date = poh.day_date_thru ,
--            fu.uic = poh.uic ,
            fu.unit_description = poh.derived_unt_desc ,
            fu.macom = poh.macom ,
            fu.pfsa_tpsn = poh.tpsn ,
            fu.pfsa_branch = poh.branch ,
            fu.pfsa_parent_org = poh.parent_org ,
            fu.pfsa_cmd_uic = poh.cmd_uic ,
            fu.pfsa_parent_uic = poh.parent_uic ,
            fu.pfsa_geo_cd = poh.geo_cd ,
            fu.pfsa_comp_cd = poh.comp_cd ,
            fu.lst_updt = poh.lst_updt ,
            fu.updt_by = poh.updt_by ,
            fu.pfsa_goof_uic_ind = poh.goof_uic_ind  
    WHEN NOT MATCHED THEN 
        INSERT 
            ( 
            fu.pfsa_org,
            fu.wh_effective_date,
            fu.wh_expiration_date,
            fu.uic,
            fu.unit_description,
            fu.macom,
            fu.pfsa_tpsn,
            fu.pfsa_branch,
            fu.pfsa_parent_org,
            fu.pfsa_cmd_uic,
            fu.pfsa_parent_uic,
            fu.pfsa_geo_cd,
            fu.pfsa_comp_cd,
            fu.lst_updt,
            fu.updt_by,
            fu.pfsa_goof_uic_ind 
            ) 
        VALUES 
            (
            poh.pfsa_org ,
            poh.day_date_from ,
            poh.day_date_thru ,
            poh.uic ,
            poh.derived_unt_desc ,
            poh.macom ,
            poh.tpsn ,
            poh.branch ,
            poh.parent_org ,
            poh.cmd_uic ,
            poh.parent_uic ,
            poh.geo_cd ,
            poh.comp_cd ,
            poh.lst_updt ,
            poh.updt_by ,
            poh.goof_uic_ind  
            ); 
            
    COMMIT;        
    
/*----------------------------------------------------------------------------*/
/*----- merge dimension record from forcewh.bct_force_dim                -----*/
/*----------------------------------------------------------------------------*/    
    
    MERGE 
    INTO  cbmwh_force_unit_dim fu
    USING ( 
          SELECT 
          uic, 
          unit_description, 
          component_code,
          component_description,
          homestation_state_or_country,
          d_date,
          r_date,
          s_date,
          edd1_date,
          edd2_date,
          mre_date,
          dodaac,
          ari_list_ref_date,
          unit_in_reset,
          sorts_uic_status,
          macom,
          bct_force_dim_id,
          bct,
          bct_description,
          bct_icon,
          bct_levels,
          tree_level, 
          uic_is_leaf,
          bct_d_date,
          bct_r_date,
          bct_s_date,
          bct_edd1_date,
          bct_edd2_date,
          bct_mre_date,
          wh_effective_date 
          FROM   forcewh.bct_force_dim
          ) bct  
    ON (fu.uic = bct.uic
       AND fu.wh_effective_date = bct.wh_effective_date) 
    WHEN MATCHED THEN 
        UPDATE 
        SET    bct_force_unit_dim_id = bct.bct_force_dim_id, 
               unit_description  = bct.unit_description, 
--            rec_id = bct.rec_id,
--            force_unit_id = bct.force_unit_id,
--            uic = bct.uic,
--            wh_effective_date = bct.wh_effective_date, 
---            unit_description = bct.unit_description, 
            component_code = bct.component_code,
            component_description = bct.component_description,
            homestation_state_or_country = bct.homestation_state_or_country,
            d_date = bct.d_date,
            r_date = bct.r_date,
            s_date = bct.s_date,
            edd1_date = bct.edd1_date,
            edd2_date = bct.edd2_date,
            mre_date = bct.mre_date,
            dodaac = bct.dodaac,
            ari_list_ref_date = bct.ari_list_ref_date,
            unit_in_reset = bct.unit_in_reset,
            sorts_uic_status = bct.sorts_uic_status,
            macom = bct.macom,
---            bct_force_unit_dim_id = bct.bct_force_unit_dim_id,
            bct = bct.bct,
            bct_description = bct.bct_description,
            bct_icon = bct.bct_icon,
            bct_levels = bct.bct_levels,
            bct_tree_level = bct.tree_level, 
            bct_uic_is_leaf = bct.uic_is_leaf,
            bct_d_date = bct.bct_d_date,
            bct_r_date = bct.bct_r_date,
            bct_s_date = bct.bct_s_date,
            bct_edd1_date = bct.bct_edd1_date,
            bct_edd2_date = bct.bct_edd2_date,
            bct_mre_date = bct.bct_mre_date 
    WHEN NOT MATCHED THEN 
        INSERT 
            (
--            bct.rec_id,
--            bct.force_unit_id,
            uic, 
            unit_description, 
            component_code,
            component_description,
            homestation_state_or_country,
            d_date,
            r_date,
            s_date,
            edd1_date,
            edd2_date,
            mre_date,
            dodaac,
            ari_list_ref_date,
            unit_in_reset,
            sorts_uic_status,
            macom,
            bct_force_unit_dim_id,
            bct,
            bct_description,
            bct_icon,
            bct_levels,
            bct_tree_level, 
            bct_uic_is_leaf,
            bct_d_date,
            bct_r_date,
            bct_s_date,
            bct_edd1_date,
            bct_edd2_date,
            bct_mre_date,
            wh_effective_date
            )
        VALUES 
            (
--            bct.rec_id,
--            bct.force_unit_id,
            bct.uic, 
            bct.unit_description, 
            bct.component_code,
            bct.component_description,
            bct.homestation_state_or_country,
            bct.d_date,
            bct.r_date,
            bct.s_date,
            bct.edd1_date,
            bct.edd2_date,
            bct.mre_date,
            bct.dodaac,
            bct.ari_list_ref_date,
            bct.unit_in_reset,
            bct.sorts_uic_status,
            bct.macom,
            bct.bct_force_dim_id,
            bct.bct,
            bct.bct_description,
            bct.bct_icon,
            bct.bct_levels,
            bct.tree_level, 
            bct.uic_is_leaf,
            bct.bct_d_date,
            bct.bct_r_date,
            bct.bct_s_date,
            bct.bct_edd1_date,
            bct.bct_edd2_date,
            bct.bct_mre_date,
            bct.wh_effective_date
            ); 
    
    COMMIT; 
    
/*----------------------------------------------------------------------------*/
/*----- merge dimension record from forcewh.uto_force_dim                -----*/
/*----------------------------------------------------------------------------*/    
    
    MERGE 
    INTO  cbmwh_force_unit_dim fu
    USING ( 
          SELECT uto_force_dim_id, 
              uic, 
              unit_description, 
              wh_effective_date, 
              wh_expiration_date, 
              wh_record_status, 
              wh_last_update_date
          FROM forcewh.uto_force_dim 
          WHERE UPPER(wh_record_status) = 'CURRENT'
          ) uto 
    ON (fu.uic = uto.uic) 
    WHEN MATCHED THEN 
        UPDATE 
        SET    uto_force_unit_dim_id = uto.uto_force_dim_id, 
               uto_unit_description  = uto.unit_description
    WHEN NOT MATCHED THEN 
        INSERT 
            (
            fu.uto_force_unit_dim_id, 
            fu.uic, 
            fu.unit_description, 
            fu.wh_effective_date, 
            fu.wh_expiration_date, 
            fu.wh_record_status, 
            fu.wh_last_update_date
            )
        VALUES 
            (
            uto.uto_force_dim_id, 
            uto.uic, 
            uto.unit_description, 
            uto.wh_effective_date, 
            uto.wh_expiration_date, 
            uto.wh_record_status, 
            uto.wh_last_update_date
            ); 
            
    COMMIT;
    
/*----------------------------------------------------------------------------*/
/*----- assign the force_unit_id                                         -----*/
/*----------------------------------------------------------------------------*/    
    
    INSERT 
    INTO     tmp_uic 
        (
        uic
        )
    SELECT 
    DISTINCT uic
    FROM   cbmwh_force_unit_dim 
    WHERE  force_unit_id < 1
    ORDER BY uic; 
    
    SELECT COUNT(uic)
    INTO   v_loopcnt  
    FROM   tmp_uic; 
    
    WHILE v_loopcnt > 0 
    LOOP 
    
        SELECT uic 
        INTO   v_uic 
        FROM   tmp_uic 
        WHERE  ROWNUM = 1; 
            
        v_force_id := fn_cbmwh_get_dim_identity('cbmwh_force_unit_dim');
            
        UPDATE cbmwh_force_unit_dim 
        SET    force_unit_id = v_force_id 
        WHERE  uic = v_uic; 
        
        DELETE tmp_uic 
        WHERE  uic = v_uic; 
        
        COMMIT; 
    
        SELECT COUNT(uic)
        INTO   v_loopcnt  
        FROM   tmp_uic; 
    
    END LOOP; -- v_loopcnt  
    
/* 

    SELECT 
    DISTINCT uic, 
        force_unit_id, 
        COUNT(uic) 
    FROM  cbmwh_force_unit_dim 
    GROUP BY uic, force_unit_id 
    ORDER BY COUNT(uic) DESC; 

    SELECT 
    DISTINCT force_unit_id, 
        COUNT(uic) 
    FROM  cbmwh_force_unit_dim 
    GROUP BY force_unit_id 
    ORDER BY COUNT(uic) DESC; 

    SELECT 
    DISTINCT force_unit_id, 
        COUNT(uic) 
    FROM  cbmwh_force_unit_ref 
    GROUP BY force_unit_id 
    ORDER BY COUNT(uic) DESC; 

*/     
/*

--    DELETE cbmwh_force_unit_ref; 
    
--    COMMIT; 
    
    INSERT 
    INTO   cbmwh_force_unit_ref 
        (
        uic, 
        force_unit_id 
        )
    SELECT 
    DISTINCT uic, 
        force_unit_id
    FROM  cbmwh_force_unit_dim; 
    
    COMMIT; 
    
    UPDATE cbmwh_force_unit_ref ref 
    SET    wh_effective_date =  
        ( 
        SELECT TO_DATE(TO_CHAR(MAX(wh_effective_date), 'dd-mon-yyyy'), 'dd-mon-yyyy')  
        FROM   cbmwh_force_unit_dim dim
        WHERE  ref.uic = dim.uic 
        ); 
        
    COMMIT; 
    
    UPDATE cbmwh_force_unit_ref ref 
    SET    unit_description =  
        ( 
        SELECT 
        DISTINCT unit_description  
        FROM   cbmwh_force_unit_dim dim
        WHERE  ref.uic = dim.uic 
            AND ref.wh_effective_date = dim.wh_effective_date 
            AND LENGTH(LTRIM(RTRIM(unit_description))) > 0 
        ); 
        
    COMMIT; 
    
    UPDATE cbmwh_force_unit_ref ref 
    SET    unit_description =  
        ( 
        SELECT  MAX(unit_description)  
        FROM   cbmwh_force_unit_dim dim
        WHERE  ref.uic = dim.uic 
            AND LENGTH(LTRIM(RTRIM(dim.unit_description))) > 0 
            AND dim.unit_description IS NOT NULL 
        ) 
    WHERE ref.unit_description IS NULL; 
        
    COMMIT; 
        

*/       
    
    dbms_output.enable(1000000);
    
    dbms_output.new_line;
    
    OPEN code_cur;
    
    LOOP
        FETCH code_cur 
        INTO  code_rec;
        
        EXIT WHEN code_cur%NOTFOUND
           OR code_cur%ROWCOUNT > 1000;
        
        dbms_output.put_line(code_rec.rec_id || ', ' || code_rec.uic  
--            || ', ' || code_rec.xx_description
            );
        
    END LOOP;
    
    CLOSE code_cur;
    
COMMIT;    

END;  

/*

SELECT 
DISTINCT fu.force_unit_id, fu.status, fu.uic, 
    fu.wh_effective_date, fu.wh_expiration_date, 
    fu.unit_description  
FROM   cbmwh_force_unit_dim fu
ORDER BY fu.uic, fu.wh_effective_date DESC; 

*/ 

/*

SELECT fu.status, fu.wh_record_status, fu.uic, fu.wh_effective_date, fu.* 
FROM   cbmwh_force_unit_dim fu
ORDER BY fu.uic, fu.wh_effective_date DESC; 

*/ 

/*

SELECT fu.uic, fu.status, fu.wh_record_status, COUNT(fu.uic)  
FROM   cbmwh_force_unit_dim fu
GROUP BY fu.uic, fu.status, fu.wh_record_status 
ORDER BY COUNT(fu.uic) DESC, fu.uic; 

*/ 

/*

SELECT   
--        pfsa_org,
        day_date_from,
--        day_date_thru,
        uic,
--        derived_unt_desc,
 --       macom,
--        tpsn,
--        branch,
--        parent_org ,
--        cmd_uic,
--        parent_uic,
--        geo_cd,
--        comp_cd,
--        lst_updt,
--        updt_by,
--        goof_uic_ind,
          count(uic) 
FROM pfsa_org_hist@pfsaw.lidb  
WHERE day_date_thru = TO_DATE('31-dec-4712', 'dd-mon-yyyy') 
      AND LENGTH(pfsa_org) = 6 
      AND uic IS NOT NULL  
GROUP BY uic, day_date_from
ORDER BY count(uic) DESC; 
*/ 
    
/*

SELECT sn.item_niin, sn.physical_item_id,  
    sn.item_serial_number, sn.physical_item_sn_id, 
    sn.mimosa_item_sn_id, 
    sn.item_force_id
FROM cbmwh_item_sn_dim sn
WHERE sn.item_serial_number NOT IN ('AGGREGATE') 
    AND sn.item_niin IN ('
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' ) 
ORDER BY sn.item_niin, sn.item_serial_number;


UPDATE cbmwh_item_sn_bld_fact b
SET    physical_item_sn_id = 
        (
        SELECT 
        DISTINCT d.physical_item_sn_id 
        FROM   cbmwh_item_sn_dim d
        WHERE  b.s_pfsa_item_id = d.item_serial_number 
            AND b.s_sys_ei_niin = d.item_niin 
            AND d.status = 'c'
        ) 
WHERE b.s_sys_ei_sn NOT IN ('AGGREGATE')  
    AND s_sys_ei_niin IN (
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' ); 

COMMIT; 

UPDATE cbmwh_item_sn_bld_fact sn 
SET    item_force_unit_id = 
           (
           SELECT 
           DISTINCT force_unit_id 
           FROM   cbmwh_force_unit_dim  
           WHERE  sn.s_uic = uic 
           )  
WHERE sn.s_sys_ei_sn NOT IN ('AGGREGATE')  
    AND sn.s_sys_ei_niin in (
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' ); 
        
COMMIT;         


SELECT sn.s_sys_ei_niin , sn.s_sys_ei_sn, sn.physical_item_sn_id, 
    sn.s_uic, sn.s_pfsa_org, sn.item_force_unit_id, 
    sn.item_bct_force_id, sn.item_uto_force_id, sn.item_tfb_force_id
    , sn.*    
FROM   cbmwh_item_sn_bld_fact sn 
WHERE sn.s_sys_ei_sn NOT IN ('AGGREGATE') 
    AND sn.s_sys_ei_niin in (
        '013285964', '014360005', '014360007', '014321526', '014172886', 
        '010631574', '014518250', '013016894', '013239584', '015148052',
        '002234919' )
ORDER BY sn.s_sys_ei_niin, sn.s_sys_ei_sn;

SELECT item_force_id, p.*
FROM cbmwh_item_sn_p_fact p;  


SELECT * 
FROM   pfsa_org_hist@pfsaw.lidb; 

*/ 



/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/
/*                                                                            */
/*                                  status                                    */
/*                                                                            */
/*--*----|----*----|----*----|----*----|----*----|----*----|----*----|----*---*/ 

DECLARE

    CURSOR status_cur is
        SELECT a.uic, MAX(wh_effective_date) AS maxx, COUNT(uic) AS cnt
        FROM pfsawh_force_unit_dim a
--        WHERE  -- status = 'N' AND 
--            sorts_uic_status = 'C' 
        GROUP BY a.uic 
        ORDER BY a.uic;
        
    status_rec    status_cur%ROWTYPE; 
    
    v_loopcnt   number; 
    v_force_id  pfsawh_identities.last_dimension_identity%TYPE; 
    v_uic       pfsawh_force_unit_dim.uic%TYPE; 
    
    v_wh_effective_date  pfsawh_force_unit_dim.wh_effective_date%TYPE;
    v_status             pfsawh_force_unit_dim.status%TYPE;
        
BEGIN 

    dbms_output.enable(1000000);
    dbms_output.new_line;
    
    OPEN status_cur;
    
    LOOP
        FETCH status_cur 
        INTO  status_rec;
        
        EXIT WHEN status_cur%NOTFOUND; 
        
--        SELECT wh_effective_date, status 
--        INTO   v_wh_effective_date, v_status 
--        FROM   pfsawh_force_unit_dim 
--        WHERE  -- status = 'N' AND  
--            sorts_uic_status = 'C' 
--            AND uic = status_rec.uic  
--            AND wh_effective_date = status_rec.maxx;  
            
        UPDATE pfsawh_force_unit_dim 
        SET    status = 'E' 
        WHERE  status = 'N'  
            AND uic = status_rec.uic  
            AND status_rec.cnt =  1;
        
        IF status_cur%ROWCOUNT < 1000 THEN 
        dbms_output.put_line(status_rec.uic || ', ' || status_rec.maxx  
            || ', ' || status_rec.cnt
            || ', ' || v_wh_effective_date
            || ', ' || v_status
            );
        END IF;
        
    END LOOP;
    
    CLOSE status_cur;
    
COMMIT;    

END;  

/*
UPDATE pfsawh_force_unit_dim 
SET    status = 'C' 
WHERE  status = 'E';

COMMIT; 
*/

SELECT uic, COUNT(status) 
FROM   pfsawh_force_unit_dim  
GROUP BY uic 
ORDER BY COUNT(status) DESC, uic;  


SELECT uic, COUNT(status) 
FROM   pfsawh_force_unit_dim  
WHERE  status IN ('C', 'E')  
GROUP BY uic 
ORDER BY COUNT(status) DESC, uic;  


SELECT uic, status, COUNT(status) 
FROM   pfsawh_force_unit_dim  
WHERE  status NOT IN ('C', 'H')  
GROUP BY uic, status 
ORDER BY status, COUNT(status) DESC, uic;  

