/* Source File: insert_trackers.sql                                           */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: insert_trackers                                               */
/*      Author: Gene Belford                                                  */
/* Description: Populates the tracker table with the data from the ARCI PCD   */
/*              workbook.  Performs the data migration task.  Initial will    */
/*              be used for HMI testing.                                      */
/*        Date: 2017-05-24                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-24             Gene Belford          Created                       */
/*                                                  trackers                  */
/*                                                  pcd                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 310 Schema Post Deployment 

/*

DELETE FROM pcd_tracker.pcd;  
-- DELETE FROM pcd_tracker.pcd_audit; 
DELETE FROM pcd_tracker.trackers;  
-- DELETE FROM pcd_tracker.trackers_audit; 
DELETE FROM pcd_tracker.remarks;  

*/
    
INSERT 
INTO pcd_tracker.trackers (
    rec_id, rec_uuid, 
    hull_number, fiscal_year, technical_insert, on_dock_need_date, pcd_lead_time,
    delivery_required, delivery_status, funded_flag, part_number, parts_list_status, drawing_status
    )
VALUES 
(4, uuid(), '21', 'FY17', 'TI16', '4/13/2018', 365, '1/13/2018', '', 'N', 'N165074-1', 'Released', 'Released'), 
(5, uuid(), 'MISC', 'FY19', 'TI18', '1/1/1900', 183, null, '', 'N', 'N106431
79C1002-00', 'n/a', 'n/a'), 
(6, uuid(), '782', 'FY17', 'TI16', '5/15/2018', 365, '2/14/2018', '', 'N', 'N165083-1', 'Released', 'Released'), 
(7, uuid(), '782', 'FY17', 'TI16', '5/15/2018', 365, '2/14/2018', '', 'N', 'N148500-500', 'Released', 'Released'), 
(8, uuid(), 'MISC', 'FY17', 'TI18', '6/1/2017', 0, '3/3/2017', '', 'N', '', '', ''), 
(9, uuid(), '783', 'FY17', 'TI16', '6/14/2018', 365, '3/16/2018', '', 'N', 'N165083-1', 'Released', 'Released'), 
(10, uuid(), 'MISC', 'FY17', 'TI18', '1/1/2018', 189, '9/3/2017', '', 'N', '', '', ''), 
(11, uuid(), '779', 'FY17', 'TI16', '7/5/2018', 365, '4/6/2018', '', 'N', 'N165080-1', 'Released', 'Released'), 
(12, uuid(), '785', 'FY17', 'TI16', '7/13/2018', 365, '4/14/2018', '', 'N', 'N165082-1', 'Released', 'Released'), 
(13, uuid(), 'SSBN #5P', 'FY17', 'TI16', '8/15/2018', 365, '5/17/2018', '', 'N', 'N165076-1', 'Released', 'Released'), 
(14, uuid(), '782', 'FY17', 'TI16', '3/1/2018', 183, '12/1/2017', '', 'N', 'N148547-1 ', 'Released', 'Released'), 
(15, uuid(), '780', 'FY17', 'TI16', '3/5/2018', 183, '12/5/2017', '', 'N', 'N148547-1 ', 'Released', 'Released'), 
(16, uuid(), '780', 'FY17', 'TI16', '9/5/2018', 365, '6/7/2018', '', 'N', 'N165081-1', 'Released', 'Released'), 
(17, uuid(), '780', 'FY17', 'TI16', '9/5/2018', 365, '6/7/2018', '', 'N', 'N148500-300', 'Released', 'Released'), 
(18, uuid(), 'SSBN #4L', 'FY17', 'TI16', '11/3/2018', 365, '8/5/2018', '', 'N', 'N165075-1 ', 'Released', 'Released'), 
(19, uuid(), '23', 'FY16', 'TI16', '5/9/2018', 183, '2/8/2018', '', 'Y', 'N150160-1', 'no', 'no'), 
(20, uuid(), '771', 'FY18', 'TI18', '6/13/2018', 183, '3/15/2018', '', 'N', '', '', ''), 
(21, uuid(), '22', 'FY18', 'TI16', '1/16/2019', 365, '10/18/2018', '', 'N', 'N165074-1', 'Released', 'Released'), 
(22, uuid(), '22', 'FY18', 'TI16', '1/16/2019', 365, '10/18/2018', '', 'N', 'N160100-20', 'Released', 'Released'), 
(23, uuid(), '771', 'FY18', 'TI18', '2/13/2019', 365, '11/15/2018', '', 'N', '', '', ''), 
(24, uuid(), '771', 'FY18', 'TI18', '2/13/2019', 365, '11/15/2018', '', 'N', '', '', ''), 
(25, uuid(), '22', 'FY18', 'TI16', '9/15/2018', 183, '6/17/2018', '', 'N', 'N150130-1', 'Released', 'Released'), 
(26, uuid(), '800', 'FY18', 'TI16', '9/27/2018', 183, '6/29/2018', '', 'N', 'N127966-2', 'Released', 'Released'), 
(27, uuid(), '774', 'FY17', 'TI16', '4/7/2019', 365, '1/7/2019', '', 'N', 'N165078-1', 'Released', 'Released'), 
(28, uuid(), '752', 'FY18', 'TI18', '6/1/2019', 365, '3/3/2019', '', 'N', '', '', ''), 
(29, uuid(), '752', 'FY18', 'TI18', '6/1/2019', 365, '3/3/2019', '', 'N', '', '', ''), 
(30, uuid(), '781', 'FY18', 'TI16', '1/15/2019', 183, '10/17/2018', '', 'N', '', '', ''), 
(31, uuid(), '781', 'FY18', 'TI16', '9/15/2019', 365, '6/17/2019', '', 'N', 'N165081-1', 'Released', 'Released'), 
(32, uuid(), '781', 'FY18', 'TI16', '9/15/2019', 365, '6/17/2019', '', 'N', '', '', ''), 
(33, uuid(), '766', 'FY18', 'TI18', '3/23/2019', 183, '12/23/2018', '', 'N', '', '', ''), 
(34, uuid(), '801', 'FY18', 'TI16', '3/28/2019', 183, '12/28/2018', '', 'N', 'N127966-2', 'Released', 'Released'), 
(35, uuid(), '752', 'FY18', 'TI18', '4/1/2019', 183, '1/1/2019', '', 'N', '', '', ''), 
(36, uuid(), '766', 'FY18', 'TI18', '11/23/2019', 365, '8/25/2019', '', 'N', '', '', ''), 
(37, uuid(), '766', 'FY18', 'TI18', '11/23/2019', 365, '8/25/2019', '', 'N', '', '', ''), 
(38, uuid(), '763', 'FY18', 'TI18', '7/15/2019', 183, '4/16/2019', '', 'N', '', '', ''), 
(39, uuid(), '764', 'FY18', 'TI18', '8/3/2019', 183, '5/5/2019', '', 'N', '', '', ''), 
(40, uuid(), '770', 'FY18', 'TI18', '9/1/2019', 183, '6/3/2019', '', 'N', '', '', ''), 
(41, uuid(), '763', 'FY18', 'TI18', '3/15/2020', 365, '12/16/2019', '', 'N', '', '', ''), 
(42, uuid(), '763', 'FY18', 'TI18', '3/15/2020', 365, '12/16/2019', '', 'N', '', '', ''), 
(43, uuid(), '770', 'FY18', 'TI18', '5/1/2020', 365, '2/1/2020', '', 'N', '', '', ''), 
(44, uuid(), '770', 'FY18', 'TI18', '5/1/2020', 365, '2/1/2020', '', 'N', '', '', ''), 
(45, uuid(), '764', 'FY18', 'TI18', '5/13/2020', 365, '2/13/2020', '', 'N', '', '', ''), 
(46, uuid(), '764', 'FY18', 'TI18', '5/13/2020', 365, '2/13/2020', '', 'N', '', '', ''), 
(47, uuid(), '765', 'FY18', 'TI18', '1/4/2020', 183, '10/6/2019', '', 'N', '', '', ''), 
(48, uuid(), '800', 'FY18', 'TI16', '7/13/2020', 365, '4/14/2020', '', 'N', '', '', ''), 
(49, uuid(), '765', 'FY18', 'TI18', '9/24/2020', 365, '6/26/2020', '', 'N', '', '', ''), 
(50, uuid(), '765', 'FY18', 'TI18', '9/24/2020', 365, '6/26/2020', '', 'N', '', '', ''), 
(51, uuid(), '768', 'FY18', 'TI18', '3/30/2020', 183, '12/31/2019', '', 'N', '', '', ''), 
(52, uuid(), '768', 'FY18', 'TI18', '11/30/2020', 365, '9/1/2020', '', 'N', '', '', ''), 
(53, uuid(), '768', 'FY18', 'TI18', '11/30/2020', 365, '9/1/2020', '', 'N', '', '', ''), 
(54, uuid(), '800', 'FY18', 'TI16', '12/14/2020', 365, '9/15/2020', '', 'N', 'N148500-4', 'Released', 'Released'), 
(55, uuid(), '801', 'FY18', 'TI16', '1/12/2021', 365, '10/14/2020', '', 'N', '', '', ''), 
(56, uuid(), '775', 'FY17', 'TI16', '2/13/2021', 365, '11/15/2020', '', 'N', 'N165081-1', 'Released', 'Released'), 
(57, uuid(), '801', 'FY18', 'TI16', '6/14/2021', 365, '3/16/2021', '', 'N', 'N148500-4', 'Released', 'Released'), 
(58, uuid(), '773', 'FY18', 'TI18', '6/6/2021', 183, '3/8/2021', '', 'N', '', '', ''), 
(59, uuid(), '800', 'FY18', 'TI16', '1/1/2022', 365, '10/3/2021', '', 'N', 'N165085-1 ', 'Released', 'Released'), 
(60, uuid(), '773', 'FY18', 'TI18', '2/6/2022', 365, '11/8/2021', '', 'N', '', '', ''), 
(61, uuid(), '773', 'FY18', 'TI18', '2/6/2022', 365, '11/8/2021', '', 'N', '', '', ''), 
(62, uuid(), '801', 'FY18', 'TI16', '9/1/2022', 365, '6/3/2022', '', 'N', 'N165085-1 ', 'Released', 'Released'), 
(63, uuid(), '21', 'FY17', 'TI16', '4/13/2018', 365, null, 'Complete', 'Y', 'N160100-10', 'Released', 'Released'), 
(64, uuid(), '21', 'FY17', 'TI16', '2/4/2018', 183, '11/6/2017', 'Complete', 'Y', 'N150130-1', 'Released', 'Released'), 
(65, uuid(), '23', 'FY16', 'TI16', '8/30/2017', 183, '6/1/2017', 'Complete', 'Y', 'N166856-1', 'Released', 'Released'), 
(66, uuid(), '23', 'FY16', 'TI16', '4/17/2019', 365, '1/17/2019', 'Complete', 'Y', 'N165070-1', 'Released', 'Released'), 
(67, uuid(), '23', 'FY16', 'TI16', '4/17/2019', 365, '1/17/2019', 'Complete', 'Y', 'N160100-30', 'Released', 'Released'), 
(68, uuid(), '774', 'FY17', 'TI16', '4/1/2018', 183, '1/1/2018', 'Complete', 'Y', 'N148547-1', 'Released', 'Released'), 
(69, uuid(), '774', 'FY17', 'TI16', '4/7/2019', 365, '1/7/2019', 'Complete', 'Y', 'N148500-100 ', 'Released', 'Released'), 
(70, uuid(), '775', 'FY17', 'TI16', '6/13/2020', 183, '3/15/2020', 'Complete', 'Y', 'N148547-1 ', 'Released', 'Released'), 
(71, uuid(), '775', 'FY17', 'TI16', '2/13/2021', 365, '11/15/2020', 'Complete', 'Y', 'N148500-300', 'Released', 'Released'), 
(72, uuid(), '777', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N148547-1', 'Released', 'Released'), 
(73, uuid(), '777', 'FY16', 'TI16', '9/21/2017', 365, '6/23/2017', 'Complete', 'Y', 'N165080-1', 'Released', 'Released'), 
(74, uuid(), '777', 'FY16', 'TI16', '9/21/2017', 365, '6/23/2017', 'Complete', 'Y', 'N148500-200', 'Released', 'Released'), 
(75, uuid(), '778', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N122756-1
N148547-1', 'Released', 'Released'), 
(76, uuid(), '778', 'FY16', 'TI16', '10/3/2017', 365, '7/5/2017', 'Complete', 'Y', 'N165079-1', 'Released', 'Released'), 
(77, uuid(), '778', 'FY16', 'TI16', '10/3/2017', 365, '7/5/2017', 'Complete', 'Y', 'N148500-100', 'Released', 'Released'), 
(78, uuid(), '779', 'FY17', 'TI16', '7/28/2017', 183, '4/29/2017', 'Complete', 'Y', 'N148547-1 ', 'Released', 'Released'), 
(79, uuid(), '779', 'FY17', 'TI16', '7/5/2018', 365, '4/6/2018', 'Complete', 'Y', 'N148500-200 ', 'Released', 'Released'), 
(80, uuid(), '783', 'FY17', 'TI16', '4/1/2018', 183, '1/1/2018', 'Complete', 'Y', 'N148547-1 ', 'Released', 'Released'), 
(81, uuid(), '783', 'FY17', 'TI16', '6/14/2018', 365, '3/16/2018', 'Complete', 'Y', 'N148500-500', 'Released', 'Released'), 
(82, uuid(), '785', 'FY17', 'TI16', '5/13/2018', 183, '2/12/2018', 'Complete', 'Y', 'N148547-1', 'Released', 'Released'), 
(83, uuid(), '785', 'FY17', 'TI16', '7/13/2018', 365, '4/14/2018', 'Complete', 'Y', 'N148500-400', 'Released', 'Released'), 
(84, uuid(), '794', 'FY16', 'TI16', '7/3/2017', 365, '4/4/2017', 'Complete', 'Y', '', '', ''), 
(85, uuid(), '794', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(86, uuid(), '794', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N127966-2 ', 'Released', 'Released'), 
(87, uuid(), '794', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(88, uuid(), '794', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(89, uuid(), '794', 'FY16', 'TI16', '12/11/2017', 365, '9/12/2017', 'Complete', 'Y', 'N148500-1', 'Released', 'Released'), 
(90, uuid(), '794', 'FY16', 'TI16', '1/11/2019', 365, '10/13/2018', 'Complete', 'Y', 'N160570-1CW', 'Released', 'Released'), 
(91, uuid(), '794', 'FY16', 'TI16', '1/1/2019', 365, '10/3/2018', 'Complete', 'Y', 'N165084-1', 'Released', 'Released'), 
(92, uuid(), '794', 'FY16', 'TI16', '1/1/2019', 365, '10/3/2018', 'Complete', 'Y', 'N165084-1', 'Released', 'Released'), 
(93, uuid(), '795', 'FY16', 'TI16', '5/9/2017', 183, null, 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(94, uuid(), '795', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N127966-2', 'Released', 'Released'), 
(95, uuid(), '795', 'FY16', 'TI16', '2/1/2018', 365, '11/3/2017', 'Complete', 'Y', '', '', ''), 
(96, uuid(), '795', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(97, uuid(), '795', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(98, uuid(), '795', 'FY16', 'TI16', '6/15/2018', 365, '3/17/2018', 'Complete', 'Y', 'N148500-1', 'Released', 'Released'), 
(99, uuid(), '795', 'FY16', 'TI16', '7/8/2019', 365, '4/9/2019', 'Complete', 'Y', 'N160570-1CW', 'Released', '12/9: WIP'), 
(100, uuid(), '795', 'FY16', 'TI16', '9/1/2019', 365, '6/3/2019', 'Complete', 'Y', 'N165084-1', 'Released', 'Released'), 
(101, uuid(), '795', 'FY16', 'TI16', '9/1/2019', 365, '6/3/2019', 'Complete', 'Y', 'N165084-1', 'Released', 'Released'), 
(102, uuid(), '796', 'FY16', 'TI16', '2/1/2017', 365, null, 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(103, uuid(), '796', 'FY16', 'TI16', '11/3/2017', 183, '8/5/2017', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(104, uuid(), '796', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N127966-2', 'Released', 'Released'), 
(105, uuid(), '796', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(106, uuid(), '796', 'FY16', 'TI16', '7/17/2018', 365, '4/18/2018', 'Complete', 'Y', '', '', ''), 
(107, uuid(), '796', 'FY16', 'TI16', '12/14/2018', 365, '9/15/2018', 'Complete', 'Y', 'N148500-5', 'Released', 'Released'), 
(108, uuid(), '796', 'FY16', 'TI16', '1/8/2020', 365, '10/10/2019', 'Complete', 'Y', 'N160570-1CW', 'Released', '12/9: WIP'), 
(109, uuid(), '796', 'FY16', 'TI16', '1/1/2020', 365, '10/3/2019', 'Complete', 'Y', 'N165085-1', 'Released', 'Released'), 
(110, uuid(), '796', 'FY16', 'TI16', '1/1/2020', 365, '10/3/2019', 'Complete', 'Y', 'N165085-1', 'Released', 'Released'), 
(111, uuid(), '797', 'FY16', 'TI16', '5/30/2017', 365, '3/1/2017', 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(112, uuid(), '797', 'FY16', 'TI16', '7/24/2017', 365, '4/25/2017', 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(113, uuid(), '797', 'FY16', 'TI16', '4/4/2017', 183, null, 'Complete', 'Y', 'N127966-2', 'Released', 'Released'), 
(114, uuid(), '797', 'FY16', 'TI16', '5/4/2018', 183, '2/3/2018', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(115, uuid(), '797', 'FY16', 'TI16', '1/11/2019', 365, '10/13/2018', 'Complete', 'Y', '', '', ''), 
(116, uuid(), '797', 'FY16', 'TI16', '6/11/2019', 365, '3/13/2019', 'Complete', 'Y', 'N148500-5', 'Released', 'Released'), 
(117, uuid(), '797', 'FY16', 'TI16', '7/7/2020', 365, '4/8/2020', 'Complete', 'Y', 'N160570-1CW', 'Released', '12/9: WIP'), 
(118, uuid(), '797', 'FY16', 'TI16', '9/1/2020', 365, '6/3/2020', 'Complete', 'Y', 'N165085-1', 'Released', 'Released'), 
(119, uuid(), '797', 'FY16', 'TI16', '9/1/2020', 365, '6/3/2020', 'Complete', 'Y', 'N165085-1', 'Released', 'Released'), 
(120, uuid(), '798', 'FY17', 'TI16', '10/31/2018', 183, '8/2/2018', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(121, uuid(), '798', 'FY17', 'TI16', '10/2/2017', 183, '7/4/2017', 'Complete', 'Y', 'N127966-2', 'Released', 'Released'), 
(122, uuid(), '798', 'FY17', 'TI16', '11/17/2017', 365, '8/19/2017', 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(123, uuid(), '798', 'FY17', 'TI16', '5/1/2018', 365, '1/31/2018', 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(124, uuid(), '798', 'FY17', 'TI16', '7/16/2019', 365, '4/17/2019', 'Complete', 'Y', '', '', ''), 
(125, uuid(), '798', 'FY17', 'TI16', '12/16/2019', 365, '9/17/2019', 'Complete', 'Y', 'N148500-4', 'Released', 'Released'), 
(126, uuid(), '798', 'FY17', 'TI16', '1/1/2021', 0, '10/3/2020', 'Complete', 'Y', 'N165085-1 ', 'Released', 'Released'), 
(127, uuid(), '798', 'FY17', 'TI16', '1/1/2021', 0, '10/3/2020', 'Complete', 'Y', 'N165085-1 ', 'Released', 'Released'), 
(128, uuid(), '798', 'FY17', 'TI16', '1/8/2021', 365, '10/10/2020', 'Complete', 'Y', 'N160570-1', 'Released', 'Released'), 
(129, uuid(), '799', 'FY17', 'TI16', '4/2/2018', 183, '1/2/2018', 'Complete', 'Y', 'N127966-2', 'Released', 'Released'), 
(130, uuid(), '799', 'FY17', 'TI16', '5/24/2018', 365, '2/23/2018', 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(131, uuid(), '799', 'FY17', 'TI16', '5/2/2019', 183, '2/1/2019', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(132, uuid(), '799', 'FY17', 'TI16', '8/24/2018', 365, '5/26/2018', 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(133, uuid(), '799', 'FY17', 'TI16', '1/14/2020', 365, '10/16/2019', 'Complete', 'Y', '', '', ''), 
(134, uuid(), '799', 'FY17', 'TI16', '6/10/2020', 365, '3/12/2020', 'Complete', 'Y', 'N148500-4', 'Released', 'Released'), 
(135, uuid(), '799', 'FY17', 'TI16', '7/8/2021', 365, '4/9/2021', 'Complete', 'Y', 'N160570-1', 'Released', 'Released'), 
(136, uuid(), '799', 'FY17', 'TI16', '9/1/2021', 0, '6/3/2021', 'Complete', 'Y', 'N165085-1 ', 'Released', 'Released'), 
(137, uuid(), '799', 'FY17', 'TI16', '9/1/2021', 0, '6/3/2021', 'Complete', 'Y', 'N165085-1 ', 'Released', 'Released'), 
(138, uuid(), '800', 'FY17', 'TI16', '11/14/2018', 365, '8/16/2018', 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(139, uuid(), '800', 'FY17', 'TI16', '10/29/2019', 183, '7/31/2019', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(140, uuid(), '800', 'FY17', 'TI16', '2/1/2019', 365, '11/3/2018', 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(141, uuid(), '800', 'FY18', 'TI16', '1/1/2022', 365, '10/3/2021', 'Complete', 'N', 'N165085-1 ', 'Released', 'Released'), 
(142, uuid(), '800', 'FY17', 'TI16', '12/14/2020', 183, '9/15/2020', 'Complete', 'Y', 'N146651-2', '', ''), 
(143, uuid(), '800', 'FY17', 'TI16', '1/10/2022', 365, '10/12/2021', 'Complete', 'Y', 'N160570-1CW', 'Released', 'Released'), 
(144, uuid(), '801', 'FY17', 'TI16', '5/22/2019', 365, '2/21/2019', 'Complete', 'Y', 'N137732-1', 'Released', 'Released'), 
(145, uuid(), '801', 'FY17', 'TI16', '4/28/2020', 183, '1/29/2020', 'Complete', 'Y', 'N123719-3', 'Released', 'Released'), 
(146, uuid(), '801', 'FY17', 'TI16', '7/23/2019', 365, '4/24/2019', 'Complete', 'Y', '77C962400G1', 'Released', 'Released'), 
(147, uuid(), '801', 'FY18', 'TI16', '9/1/2022', 365, '6/3/2022', 'Complete', 'N', 'N165085-1 ', 'Released', 'Released'), 
(148, uuid(), '801', 'FY17', 'TI16', '6/14/2021', 183, '3/16/2021', 'Complete', 'Y', 'N146651-2', '', ''), 
(149, uuid(), '801', 'FY17', 'TI16', '7/8/2022', 365, '4/9/2022', 'Complete', 'Y', 'N160570-1CW', 'Released', 'Released'), 
(150, uuid(), 'EDM', 'FY17', 'TI16', '10/1/2016', 183, null, 'Complete', 'Y', 'N146823-1', 'Released', 'Released'), 
(151, uuid(), 'INCO', 'FY17', 'TI16', '8/30/2017', 365, '6/1/2017', 'Complete', 'Y', 'N166856-1', '11:15 Released', '11:08: Released'), 
(152, uuid(), 'INCO', 'FY17', 'TI16', '10/1/2017', 365, '7/3/2017', 'Complete', 'Y', 'N165699-1', 'Released', 'Released'), 
(153, uuid(), 'INCO', 'FY17', 'TI16', '10/1/2017', 365, '7/3/2017', 'Complete', 'Y', 'N165698-1', 'Released', 'Released'), 
(154, uuid(), 'INCO', 'FY17', 'TI16', '10/1/2017', 365, '7/3/2017', 'Complete', 'Y', 'N165697-1', 'Released', 'Released'), 
(155, uuid(), 'INCO', 'FY17', 'TI16', '12/1/2017', 365, '9/2/2017', 'Complete', 'Y', 'N166714-1', 'Released', 'Released'), 
(157, uuid(), 'LVA-790', 'FY17', 'TI14', '5/5/2017', 183, '2/4/2017', 'Complete', 'Y', '701418-01/
701152-03', 'N/A', 'N/A'), 
(158, uuid(), 'LVA-790', 'FY17', 'TI14', null, 183, null, 'Complete', 'Y', 'Various', 'N/A', 'N/A'), 
(159, uuid(), 'LVA-790', 'FY17', 'TI14', null, 183, '1/1/1900', 'Complete', 'Y', 'TBD', '', ''), 
(160, uuid(), 'MISC', 'FY18', 'TI16', '3/1/2018', 183, '12/1/2017', 'Complete', 'Y', 'N106431
79C1002-00', 'n/a', 'n/a'), 
(161, uuid(), 'MISC', 'FY17', 'TI16', '8/1/2017', 120, '5/3/2017', 'Complete', 'Y', 'many', '', ''), 
(162, uuid(), 'MISC', '', 'TI16', '12/16/2017', 365, '9/17/2017', 'Complete', 'Y', '500721-01', '', ''), 
(163, uuid(), 'MISC', 'FY15', 'TI16', '1/1/1900', 0, '1/1/1900', 'Complete', 'Y', '', '', ''), 
(164, uuid(), 'MISC', 'FY16', 'TI16', null, 0, '1/1/1900', 'Complete', 'Y', 'ELD0062306', 'N/A', 'N/A'), 
(165, uuid(), 'Mock-up', 'FY17', 'TI16', '6/15/2017', 0, '3/17/2017', 'Complete', 'Y', 'N146813-1
N146814-1
N166558-11
N166558-15', 'Released', 'Released'), 
(166, uuid(), 'Mock-up', 'FY17', 'TI16', '1/1/1900', 0, null, 'Complete', 'Y', '', '', ''), 
(167, uuid(), 'SSBN #1L', 'FY16', 'TI16', '9/25/2017', 365, '6/27/2017', 'Complete', 'Y', 'N165075-1 ', 'Released', 'Released'), 
(168, uuid(), 'SSBN #1L', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N148190-2', 'Released', 'Released'), 
(169, uuid(), 'SSBN #1L', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N148009-1
N165806-1 ', 'Released', 'Released'), 
(170, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N148190-2', 'Released', 'Released'), 
(171, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 365, null, 'Complete', 'Y', 'N165075-1 ', 'Released', 'Released'), 
(172, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 183, null, 'Complete', 'Y', 'N148009-1
N165806-1 ', 'Released', 'Released'), 
(173, uuid(), 'SSBN #3P', 'FY17', 'TI16', '2/14/2018', 365, '11/16/2017', 'Complete', 'Y', 'N165076-1', 'Released', 'Released'), 
(174, uuid(), 'SSBN #3P', 'FY17', 'TI16', '2/14/2018', 365, '11/16/2017', 'Complete', 'Y', 'N148190-1', 'Released', 'Released'), 
(175, uuid(), 'SSBN #3P', 'FY17', 'TI16', '3/1/2017', 183, null, 'Complete', 'Y', 'N148009-1 
N165806-1', 'Released', 'Released'), 
(176, uuid(), 'SSBN #4L', 'FY17', 'TI16', '11/13/2017', 183, '8/15/2017', 'Complete', 'Y', 'N148009-1
N165806-1', 'Released', 'Released'), 
(177, uuid(), 'SSBN #4L', 'FY17', 'TI16', '11/3/2018', 365, '8/5/2018', 'Complete', 'Y', 'N148190-2', 'Released', 'Released'), 
(178, uuid(), 'SSBN #5P', 'FY17', 'TI16', '3/1/2018', 183, '12/1/2017', 'Complete', 'Y', 'N148009-1
N165806-1', 'Released', 'Released'), 
(179, uuid(), 'SSBN #5P', 'FY17', 'TI16', '8/15/2018', 365, '5/17/2018', 'Complete', 'Y', 'N148190-1 ', 'Released', 'Released'), 
(180, uuid(), 'LVA-790', 'FY17', 'TI14', null, 365, '1/1/1900', '', 'Y', 'TBD', '', ''), 
(181, uuid(), 'LVA-790', 'FY17', 'TI14', null, 365, '1/1/1900', '', 'Y', 'TBD', '', '') 
;    
    
/*
    
SELECT trk.* 
FROM   pcd_tracker.trackers trk 
ORDER BY trk.rec_id DESC; 

SELECT trka.* 
FROM   pcd_tracker.trackers_audit trka 
ORDER BY trka.rec_id DESC; 

*/

INSERT 
INTO pcd_tracker.pcd (
    rec_id, rec_uuid, tracker_id,          tracker_uuid, 
    pcd_id, subject,  classification_code, pcd_required_date
    )
VALUES 
(4, uuid(), 4, uuid(), 'tbd4', 'Spares', 'UNRESTRICTED', '4/13/2017'), 
(5, uuid(), 5, uuid(), 'tbd5', 'EOL Purchase of CPLD for PCM and Func Mod (TI18)', 'UNRESTRICTED', '5/1/2017'), 
(6, uuid(), 6, uuid(), 'tbd6', 'Spares', 'UNRESTRICTED', '5/15/2017'), 
(7, uuid(), 7, uuid(), 'tbd7', 'System', 'UNRESTRICTED', '5/15/2017'), 
(8, uuid(), 8, uuid(), 'tbd8', 'APB19 TI18 Servers for Ben', 'UNRESTRICTED', '6/1/2017'), 
(9, uuid(), 9, uuid(), 'tbd9', 'Spares', 'UNRESTRICTED', '6/14/2017'), 
(10, uuid(), 10, uuid(), 'tbd10', 'TI18 688 Development Assets for Bernie', 'UNRESTRICTED', '6/26/2017'), 
(11, uuid(), 11, uuid(), 'tbd11', 'Spares', 'UNRESTRICTED', '7/5/2017'), 
(12, uuid(), 12, uuid(), 'tbd12', 'Spares', 'UNRESTRICTED', '7/13/2017'), 
(13, uuid(), 13, uuid(), 'tbd13', 'FY17 SSBN #5P SPARES', 'UNRESTRICTED', '8/15/2017'), 
(14, uuid(), 14, uuid(), 'tbd14', 'PCK', 'UNRESTRICTED', '8/30/2017'), 
(15, uuid(), 15, uuid(), 'tbd15', 'PCK', 'UNRESTRICTED', '9/3/2017'), 
(16, uuid(), 16, uuid(), 'tbd16', 'Spares', 'UNRESTRICTED', '9/5/2017'), 
(17, uuid(), 17, uuid(), 'tbd17', 'System', 'UNRESTRICTED', '9/5/2017'), 
(18, uuid(), 18, uuid(), 'tbd18', 'FY17 SSBN #4L SPARES', 'UNRESTRICTED', '11/3/2017'), 
(19, uuid(), 19, uuid(), ' ', 'PCK', 'UNRESTRICTED', '11/7/2017'), 
(20, uuid(), 20, uuid(), 'tbd20', 'PCK', 'UNRESTRICTED', '12/12/2017'), 
(21, uuid(), 21, uuid(), 'tbd21', 'Spares', 'UNRESTRICTED', '1/16/2018'), 
(22, uuid(), 22, uuid(), 'tbd22', 'System', 'UNRESTRICTED', '1/16/2018'), 
(23, uuid(), 23, uuid(), 'tbd23', 'Spares', 'UNRESTRICTED', '2/13/2018'), 
(24, uuid(), 24, uuid(), 'tbd24', 'System', 'UNRESTRICTED', '2/13/2018'), 
(25, uuid(), 25, uuid(), 'tbd25', 'PCK', 'UNRESTRICTED', '3/16/2018'), 
(26, uuid(), 26, uuid(), 'tbd26', 'PCK', 'UNRESTRICTED', '3/28/2018'), 
(27, uuid(), 27, uuid(), 'tbd27', 'Spares', 'UNRESTRICTED', '4/7/2018'), 
(28, uuid(), 28, uuid(), 'tbd28', 'Spares', 'UNRESTRICTED', '6/1/2018'), 
(29, uuid(), 29, uuid(), 'tbd29', ' ', 'UNRESTRICTED', '6/1/2018'), 
(30, uuid(), 30, uuid(), 'tbd30', 'PCK', 'UNRESTRICTED', '7/16/2018'), 
(31, uuid(), 31, uuid(), 'tbd31', 'Spares', 'UNRESTRICTED', '9/15/2018'), 
(32, uuid(), 32, uuid(), 'tbd32', 'System', 'UNRESTRICTED', '9/15/2018'), 
(33, uuid(), 33, uuid(), 'tbd33', 'PCK', 'UNRESTRICTED', '9/21/2018'), 
(34, uuid(), 34, uuid(), 'tbd34', 'PCK', 'UNRESTRICTED', '9/26/2018'), 
(35, uuid(), 35, uuid(), 'tbd35', 'PCK', 'UNRESTRICTED', '9/30/2018'), 
(36, uuid(), 36, uuid(), 'tbd36', 'Spares', 'UNRESTRICTED', '11/23/2018'), 
(37, uuid(), 37, uuid(), 'tbd37', 'System', 'UNRESTRICTED', '11/23/2018'), 
(38, uuid(), 38, uuid(), 'tbd38', 'PCK', 'UNRESTRICTED', '1/13/2019'), 
(39, uuid(), 39, uuid(), 'tbd39', 'PCK', 'UNRESTRICTED', '2/1/2019'), 
(40, uuid(), 40, uuid(), 'tbd40', 'PCK', 'UNRESTRICTED', '3/2/2019'), 
(41, uuid(), 41, uuid(), 'tbd41', 'Spares', 'UNRESTRICTED', '3/16/2019'), 
(42, uuid(), 42, uuid(), 'tbd42', 'System', 'UNRESTRICTED', '3/16/2019'), 
(43, uuid(), 43, uuid(), 'tbd43', 'Spares', 'UNRESTRICTED', '5/2/2019'), 
(44, uuid(), 44, uuid(), 'tbd44', 'System', 'UNRESTRICTED', '5/2/2019'), 
(45, uuid(), 45, uuid(), 'tbd45', 'Spares', 'UNRESTRICTED', '5/14/2019'), 
(46, uuid(), 46, uuid(), 'tbd46', 'System', 'UNRESTRICTED', '5/14/2019'), 
(47, uuid(), 47, uuid(), 'tbd47', 'PCK', 'UNRESTRICTED', '7/5/2019'), 
(48, uuid(), 48, uuid(), 'tbd48', 'Early Fiber Delivery', 'UNRESTRICTED', '7/14/2019'), 
(49, uuid(), 49, uuid(), 'tbd49', 'Spares', 'UNRESTRICTED', '9/25/2019'), 
(50, uuid(), 50, uuid(), 'tbd50', 'System', 'UNRESTRICTED', '9/25/2019'), 
(51, uuid(), 51, uuid(), 'tbd51', 'PCK', 'UNRESTRICTED', '9/29/2019'), 
(52, uuid(), 52, uuid(), 'tbd52', 'Spares', 'UNRESTRICTED', '12/1/2019'), 
(53, uuid(), 53, uuid(), 'tbd53', 'System', 'UNRESTRICTED', '12/1/2019'), 
(54, uuid(), 54, uuid(), 'tbd54', 'System', 'UNRESTRICTED', '12/15/2019'), 
(55, uuid(), 55, uuid(), 'tbd55', 'Early Fiber Delivery', 'UNRESTRICTED', '1/13/2020'), 
(56, uuid(), 56, uuid(), 'tbd56', 'Spares', 'UNRESTRICTED', '2/14/2020'), 
(57, uuid(), 57, uuid(), 'tbd57', 'System', 'UNRESTRICTED', '6/14/2020'), 
(58, uuid(), 58, uuid(), 'tbd58', 'PCK', 'UNRESTRICTED', '12/5/2020'), 
(59, uuid(), 59, uuid(), 'tbd59', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/2021'), 
(60, uuid(), 60, uuid(), 'tbd60', 'Spares', 'UNRESTRICTED', '2/6/2021'), 
(61, uuid(), 61, uuid(), 'tbd61', 'System', 'UNRESTRICTED', '2/6/2021'), 
(62, uuid(), 62, uuid(), 'tbd62', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '9/1/2021'), 
(63, uuid(), 63, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00014A', 'System', 'UNRESTRICTED', '1/1/1900'), 
(64, uuid(), 64, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00014A', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(65, uuid(), 65, uuid(), '16-ARCI FY16 Production-LMDM-PCD00040B', 'OBRP/MAMS Delta kit', 'UNRESTRICTED', '1/1/1900'), 
(66, uuid(), 66, uuid(), '16-ARCI FY16 Production-LMDM-PCD00020A', 'Spares', 'UNRESTRICTED', '1/1/1900'), 
(67, uuid(), 67, uuid(), '16-ARCI FY16 Production-LMDM-PCD00020A', 'System', 'UNRESTRICTED', '1/1/1900'), 
(68, uuid(), 68, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00013', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(69, uuid(), 69, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00013', 'System', 'UNRESTRICTED', '1/1/1900'), 
(70, uuid(), 70, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00012', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(71, uuid(), 71, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00012', 'System', 'UNRESTRICTED', '1/1/1900'), 
(72, uuid(), 72, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(73, uuid(), 73, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'Spares', 'UNRESTRICTED', '1/1/1900'), 
(74, uuid(), 74, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'System', 'UNRESTRICTED', '1/1/1900'), 
(75, uuid(), 75, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(76, uuid(), 76, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'Spares', 'UNRESTRICTED', '1/1/1900'), 
(77, uuid(), 77, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'System', 'UNRESTRICTED', '1/1/1900'), 
(78, uuid(), 78, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00009', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(79, uuid(), 79, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00009', 'System', 'UNRESTRICTED', '1/1/1900'), 
(80, uuid(), 80, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00010', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(81, uuid(), 81, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00010', 'System', 'UNRESTRICTED', '1/1/1900'), 
(82, uuid(), 82, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00011', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(83, uuid(), 83, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00011', 'System', 'UNRESTRICTED', '1/1/1900'), 
(84, uuid(), 84, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(85, uuid(), 85, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(86, uuid(), 86, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(87, uuid(), 87, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(88, uuid(), 88, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(89, uuid(), 89, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'System', 'UNRESTRICTED', '1/1/1900'), 
(90, uuid(), 90, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(91, uuid(), 91, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(92, uuid(), 92, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(93, uuid(), 93, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(94, uuid(), 94, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(95, uuid(), 95, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(96, uuid(), 96, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(97, uuid(), 97, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(98, uuid(), 98, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'System', 'UNRESTRICTED', '1/1/1900'), 
(99, uuid(), 99, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(100, uuid(), 100, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(101, uuid(), 101, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(102, uuid(), 102, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(103, uuid(), 103, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(104, uuid(), 104, uuid(), '16-ARCI Production-LMDM-PCD00005A', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(105, uuid(), 105, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(106, uuid(), 106, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(107, uuid(), 107, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004D', 'System', 'UNRESTRICTED', '1/1/1900'), 
(108, uuid(), 108, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(109, uuid(), 109, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004E', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(110, uuid(), 110, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004E', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(111, uuid(), 111, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(112, uuid(), 112, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(113, uuid(), 113, uuid(), '16-ARCI Production-LMDM-PCD00006', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(114, uuid(), 114, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(115, uuid(), 115, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(116, uuid(), 116, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005C', 'System', 'UNRESTRICTED', '1/1/1900'), 
(117, uuid(), 117, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(118, uuid(), 118, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(119, uuid(), 119, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(120, uuid(), 120, uuid(), '17-ARCI Production-LMDM-PCD00002', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(121, uuid(), 121, uuid(), '17-ARCI Production-LMDM-PCD00002', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(122, uuid(), 122, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00007', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(123, uuid(), 123, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(124, uuid(), 124, uuid(), '17-ARCI Production-LMDM-PCD00002', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(125, uuid(), 125, uuid(), '17-ARCI Production-LMDM-PCD00002', 'System', 'UNRESTRICTED', '1/1/1900'), 
(126, uuid(), 126, uuid(), '17-ARCI Production-LMDM-PCD00002', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(127, uuid(), 127, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(128, uuid(), 128, uuid(), '17-ARCI Production-LMDM-PCD00002', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(129, uuid(), 129, uuid(), '17-ARCI Production-LMDM-PCD00003', 'PCK', 'UNRESTRICTED', '1/1/1900'), 
(130, uuid(), 130, uuid(), '17-ARCI Production-LMDM-PCD00003', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(131, uuid(), 131, uuid(), '17-ARCI Production-LMDM-PCD00003', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(132, uuid(), 132, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(133, uuid(), 133, uuid(), '17-ARCI Production-LMDM-PCD00003', 'Early Fiber Delivery', 'UNRESTRICTED', '1/1/1900'), 
(134, uuid(), 134, uuid(), '17-ARCI Production-LMDM-PCD00003', 'System', 'UNRESTRICTED', '1/1/1900'), 
(135, uuid(), 135, uuid(), '17-ARCI Production-LMDM-PCD00003', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(136, uuid(), 136, uuid(), '17-ARCI Production-LMDM-PCD00003', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1/1/1900'), 
(137, uuid(), 137, uuid(), '17-ARCI Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(138, uuid(), 138, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(139, uuid(), 139, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(140, uuid(), 140, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(141, uuid(), 141, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(142, uuid(), 142, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'Long Lead EOQ', 'UNRESTRICTED', '1/1/1900'), 
(143, uuid(), 143, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(144, uuid(), 144, uuid(), '17-ARCI Production-LMDM-PCD00005', 'ASRU', 'UNRESTRICTED', '1/1/1900'), 
(145, uuid(), 145, uuid(), '17-ARCI Production-LMDM-PCD00005', 'Flow Valves', 'UNRESTRICTED', '1/1/1900'), 
(146, uuid(), 146, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1/1/1900'), 
(147, uuid(), 147, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1/1/1900'), 
(148, uuid(), 148, uuid(), '17-ARCI Production-LMDM-PCD00005', 'Long Lead EOQ', 'UNRESTRICTED', '1/1/1900'), 
(149, uuid(), 149, uuid(), '17-ARCI Production-LMDM-PCD00005', 'LWWAA', 'UNRESTRICTED', '1/1/1900'), 
(150, uuid(), 150, uuid(), '15-ARCI FY15 Production-LMDM-PCD00025A', 'Order 2 Laptop Kits for Integration', 'UNRESTRICTED', '1/1/1900'), 
(151, uuid(), 151, uuid(), '16-ARCI FY16 Production-LMDM-PCD00040B', '$595K ODC Seawolf Spares Buy', 'UNRESTRICTED', '1/1/1900'), 
(152, uuid(), 152, uuid(), '16-ARCI FY16 Production-LMDM-PCD00039', 'SSBN INCO Spares', 'UNRESTRICTED', '1/1/1900'), 
(153, uuid(), 153, uuid(), '16-ARCI FY16 Production-LMDM-PCD00043A', 'Va Mod/Seawolf INCO Spares', 'UNRESTRICTED', '1/1/1900'), 
(154, uuid(), 154, uuid(), '16-ARCI FY16 Production-LMDM-PCD00044', 'Va New Con INCO Spares', 'UNRESTRICTED', '1/1/1900'), 
(155, uuid(), 155, uuid(), '16-ARCI FY16 Production-LMDM-PCD00038A', 'Order additional spares Ref:P00057 on 6294 - $2.4M', 'UNRESTRICTED', '1/1/1900'), 
(157, uuid(), 157, uuid(), '16-ARCI Engineering Services TI14-LMDM-PCD00111A', 'Buy S79 and S47 EQT servers for LVA', 'UNRESTRICTED', '1/1/1900'), 
(158, uuid(), 158, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00001B', 'LVA 790 ABF Delta HW Initial Buy (Jan 2017)', 'UNRESTRICTED', '1/1/1900'), 
(159, uuid(), 159, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00006G', 'LVA 790 ABF Delta HW (remaining hw required after drawings are released)', 'UNRESTRICTED', '1/1/1900'), 
(160, uuid(), 160, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00015', 'EOL Purchase of CPLD for PCM and Func Mod (TI16)', 'UNRESTRICTED', '1/1/1900'), 
(161, uuid(), 161, uuid(), '17-ARCI FY16 Production-LMDM-PCD00007A', 'Bakers Rack 3 Additional Sets for vaMod', 'UNRESTRICTED', '1/1/1900'), 
(162, uuid(), 162, uuid(), '16-ARCI FY16 Production-LMDM-PCD00042', 'Motherboard EOL purchase - in TI16-B03/S14/S34/S37/S40', 'UNRESTRICTED', '1/1/1900'), 
(163, uuid(), 163, uuid(), '15-ARCI FY15 Production-LMDM-PCD00030B', 'Sippican MK21 PCB Assemblies', 'UNRESTRICTED', '1/1/1900'), 
(164, uuid(), 164, uuid(), '16-ARCI FY16 Production-LMDM-PCD00030', 'Laser Modulators need Qnty 433 on 6294 P000057', 'UNRESTRICTED', '1/1/1900'), 
(165, uuid(), 165, uuid(), '16-FY14 ARCI/Va Production-LMDM-PCD00006', 'LVA 2D Mockups', 'UNRESTRICTED', '1/1/1900'), 
(166, uuid(), 166, uuid(), '16-ARCI FY16 Production-LMDM-PCD00026A', 'Va Mod 2D Mock-ups (Early delivery stuff)', 'UNRESTRICTED', '1/1/1900'), 
(167, uuid(), 167, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L Spares', 'UNRESTRICTED', '1/1/1900'), 
(168, uuid(), 168, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L System', 'UNRESTRICTED', '1/1/1900'), 
(169, uuid(), 169, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L PCK', 'UNRESTRICTED', '1/1/1900'), 
(170, uuid(), 170, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L System', 'UNRESTRICTED', '1/1/1900'), 
(171, uuid(), 171, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L Spares', 'UNRESTRICTED', '1/1/1900'), 
(172, uuid(), 172, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L PCK', 'UNRESTRICTED', '1/1/1900'), 
(173, uuid(), 173, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P SPARES', 'UNRESTRICTED', '1/1/1900'), 
(174, uuid(), 174, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P System', 'UNRESTRICTED', '1/1/1900'), 
(175, uuid(), 175, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P PCK', 'UNRESTRICTED', '1/1/1900'), 
(176, uuid(), 176, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00003', 'FY17 SSBN #4L PCK', 'UNRESTRICTED', '1/1/1900'), 
(177, uuid(), 177, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00003', 'FY17 SSBN #4L System', 'UNRESTRICTED', '1/1/1900'), 
(178, uuid(), 178, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00002', 'FY17 SSBN #5P PCK', 'UNRESTRICTED', '1/1/1900'), 
(179, uuid(), 179, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00002', 'FY17 SSBN SHIPSET 5 System', 'UNRESTRICTED', '1/1/1900'), 
(180, uuid(), 180, uuid(), 'tbd180', 'LVA INCOs', 'UNRESTRICTED', '1/1/1900'), 
(181, uuid(), 181, uuid(), 'tbd181', 'LVA Spares', 'UNRESTRICTED', '1/1/1900')  
;

/*
    
SELECT pcd.* 
FROM   pcd_tracker.pcd pcd 
ORDER BY pcd.rec_id DESC; 

SELECT pcda.* 
FROM   pcd_tracker.pcd_audit pcda 
ORDER BY pcda.rec_id DESC; 

*/

/* FY 15-17 Not Funded 

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
WHERE trk.funded_flag = false 
    AND trk.fiscal_year IN ('FY15', 'FY16', 'FY17') 
ORDER BY pcd.pcd_required_date;

*/

/* Funded No PCD

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
WHERE trk.funded_flag = true 
    AND pcd.pcd_id NOT LIKE ('%ARCI%') 
ORDER BY pcd.pcd_required_date;

*/

/* PCD Wake Up 

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
ORDER BY pcd.pcd_required_date;

*/

/* Delivery Wake Up 

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

*/
