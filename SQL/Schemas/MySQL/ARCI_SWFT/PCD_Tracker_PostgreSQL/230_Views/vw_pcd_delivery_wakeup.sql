/* Source File: vw_pcd_delivery_wakeup.sql                                    */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: vw_pcd_delivery_wakeup                                        */
/*      Author: Gene Belford                                                  */
/* Description: View to populate the PCD Status Review.                       */
/*        Date: 2017-05-26                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-26             Gene Belford           Created                      */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT * FROM pcd_tracker.vw_pcd_delivery_wakeup;

*/
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 230 View 

-- DROP VIEW pcd_tracker.vw_pcd_delivery_wakeup;

CREATE OR REPLACE VIEW pcd_tracker.vw_pcd_delivery_wakeup 

AS 

SELECT trk.rec_id, 
    trk.hull_number AS "Hull",
    trk.fiscal_year AS "FY",
    trk.technical_insert AS "TI",
    trk.on_dock_need_date AS "On Dock",
    trk.pcd_lead_time AS "Lead Time (days)",
    pcd.pcd_required_date AS "PCD Wake Up Date",
    trk.internal_rdd AS "Int RRD",
    trk.delivery_required AS "Del Date",
    trk.delivery_status AS "Del Status",
    pcd.subject AS "Subject",
    trk.funded_flag AS "Funded",
    ( SELECT pcd_tracker.f_remarks_string(trk.rec_id) AS f_remarks_string) AS "Remarks",
    pcd.pcd_id AS "PCD",
    trk.part_number AS "PN",
    trk.parts_list_status AS "PL Status",
    trk.drawing_status AS "DRW Status",
    trk.man_pr AS "MAN PR",
    trk.man_del_ol AS "MAN Del O/L",
    trk.clw_pr AS "CLW PR",
    trk.clw_del_ol AS "CLW Del O/L"
FROM pcd_tracker.trackers trk
LEFT JOIN pcd_tracker.pcd pcd ON trk.rec_id = pcd.tracker_id
WHERE pcd.pcd_id NOT LIKE ('%ARCI%') 
ORDER BY trk.delivery_required;

ALTER TABLE pcd_tracker.vw_pcd_delivery_wakeup
    OWNER TO postgres;
