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
/* 2017-05-30             Gene Belford          Updated for MariaDB           */
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
(4, uuid(), '21', 'FY17', 'TI16', '2018/4/13', 365, '2018/1/13', '', FALSE, 'N165074-1', 'Released', 'Released'), 
(5, uuid(), 'MISC', 'FY19', 'TI18', '1900/1/1', 183, null, '', FALSE, 'N106431
79C1002-00', 'n/a', 'n/a'), 
(6, uuid(), '782', 'FY17', 'TI16', '2018/5/15', 365, '2018/2/14', '', FALSE, 'N165083-1', 'Released', 'Released'), 
(7, uuid(), '782', 'FY17', 'TI16', '2018/5/15', 365, '2018/2/14', '', FALSE, 'N148500-500', 'Released', 'Released'), 
(8, uuid(), 'MISC', 'FY17', 'TI18', '2017/6/1', 0, '2017/3/3', '', FALSE, '', '', ''), 
(9, uuid(), '783', 'FY17', 'TI16', '2018/6/14', 365, '2018/3/16', '', FALSE, 'N165083-1', 'Released', 'Released'), 
(10, uuid(), 'MISC', 'FY17', 'TI18', '2018/1/1', 189, '2017/9/3', '', FALSE, '', '', ''), 
(11, uuid(), '779', 'FY17', 'TI16', '2018/7/5', 365, '2018/4/6', '', FALSE, 'N165080-1', 'Released', 'Released'), 
(12, uuid(), '785', 'FY17', 'TI16', '2018/7/13', 365, '2018/4/14', '', FALSE, 'N165082-1', 'Released', 'Released'), 
(13, uuid(), 'SSBN #5P', 'FY17', 'TI16', '2018/8/15', 365, '2018/5/17', '', FALSE, 'N165076-1', 'Released', 'Released'), 
(14, uuid(), '782', 'FY17', 'TI16', '2018/3/1', 183, '2017/12/1', '', FALSE, 'N148547-1 ', 'Released', 'Released'), 
(15, uuid(), '780', 'FY17', 'TI16', '2018/3/5', 183, '2017/12/5', '', FALSE, 'N148547-1 ', 'Released', 'Released'), 
(16, uuid(), '780', 'FY17', 'TI16', '2018/9/5', 365, '2018/6/7', '', FALSE, 'N165081-1', 'Released', 'Released'), 
(17, uuid(), '780', 'FY17', 'TI16', '2018/9/5', 365, '2018/6/7', '', FALSE, 'N148500-300', 'Released', 'Released'), 
(18, uuid(), 'SSBN #4L', 'FY17', 'TI16', '2018/11/3', 365, '2018/8/5', '', FALSE, 'N165075-1 ', 'Released', 'Released'), 
(19, uuid(), '23', 'FY16', 'TI16', '2018/5/9', 183, '2018/2/8', '', TRUE, 'N150160-1', 'no', 'no'), 
(20, uuid(), '771', 'FY18', 'TI18', '2018/6/13', 183, '2018/3/15', '', FALSE, '', '', ''), 
(21, uuid(), '22', 'FY18', 'TI16', '2019/1/16', 365, '2018/10/18', '', FALSE, 'N165074-1', 'Released', 'Released'), 
(22, uuid(), '22', 'FY18', 'TI16', '2019/1/16', 365, '2018/10/18', '', FALSE, 'N160100-20', 'Released', 'Released'), 
(23, uuid(), '771', 'FY18', 'TI18', '2019/2/13', 365, '2018/11/15', '', FALSE, '', '', ''), 
(24, uuid(), '771', 'FY18', 'TI18', '2019/2/13', 365, '2018/11/15', '', FALSE, '', '', ''), 
(25, uuid(), '22', 'FY18', 'TI16', '2018/9/15', 183, '2018/6/17', '', FALSE, 'N150130-1', 'Released', 'Released'), 
(26, uuid(), '800', 'FY18', 'TI16', '2018/9/27', 183, '2018/6/29', '', FALSE, 'N127966-2', 'Released', 'Released'), 
(27, uuid(), '774', 'FY17', 'TI16', '2019/4/7', 365, '2019/1/7', '', FALSE, 'N165078-1', 'Released', 'Released'), 
(28, uuid(), '752', 'FY18', 'TI18', '2019/6/1', 365, '2019/3/3', '', FALSE, '', '', ''), 
(29, uuid(), '752', 'FY18', 'TI18', '2019/6/1', 365, '2019/3/3', '', FALSE, '', '', ''), 
(30, uuid(), '781', 'FY18', 'TI16', '2019/1/15', 183, '2018/10/17', '', FALSE, '', '', ''), 
(31, uuid(), '781', 'FY18', 'TI16', '2019/9/15', 365, '2019/6/17', '', FALSE, 'N165081-1', 'Released', 'Released'), 
(32, uuid(), '781', 'FY18', 'TI16', '2019/9/15', 365, '2019/6/17', '', FALSE, '', '', ''), 
(33, uuid(), '766', 'FY18', 'TI18', '2019/3/23', 183, '2018/12/23', '', FALSE, '', '', ''), 
(34, uuid(), '801', 'FY18', 'TI16', '2019/3/28', 183, '2018/12/28', '', FALSE, 'N127966-2', 'Released', 'Released'), 
(35, uuid(), '752', 'FY18', 'TI18', '2019/4/1', 183, '2019/1/1', '', FALSE, '', '', ''), 
(36, uuid(), '766', 'FY18', 'TI18', '2019/11/23', 365, '2019/8/25', '', FALSE, '', '', ''), 
(37, uuid(), '766', 'FY18', 'TI18', '2019/11/23', 365, '2019/8/25', '', FALSE, '', '', ''), 
(38, uuid(), '763', 'FY18', 'TI18', '2019/7/15', 183, '2019/4/16', '', FALSE, '', '', ''), 
(39, uuid(), '764', 'FY18', 'TI18', '2019/8/3', 183, '2019/5/5', '', FALSE, '', '', ''), 
(40, uuid(), '770', 'FY18', 'TI18', '2019/9/1', 183, '2019/6/3', '', FALSE, '', '', ''), 
(41, uuid(), '763', 'FY18', 'TI18', '2020/3/15', 365, '2019/12/16', '', FALSE, '', '', ''), 
(42, uuid(), '763', 'FY18', 'TI18', '2020/3/15', 365, '2019/12/16', '', FALSE, '', '', ''), 
(43, uuid(), '770', 'FY18', 'TI18', '2020/5/1', 365, '2020/2/1', '', FALSE, '', '', ''), 
(44, uuid(), '770', 'FY18', 'TI18', '2020/5/1', 365, '2020/2/1', '', FALSE, '', '', ''), 
(45, uuid(), '764', 'FY18', 'TI18', '2020/5/13', 365, '2020/2/13', '', FALSE, '', '', ''), 
(46, uuid(), '764', 'FY18', 'TI18', '2020/5/13', 365, '2020/2/13', '', FALSE, '', '', ''), 
(47, uuid(), '765', 'FY18', 'TI18', '2020/1/4', 183, '2019/10/6', '', FALSE, '', '', ''), 
(48, uuid(), '800', 'FY18', 'TI16', '2020/7/13', 365, '2020/4/14', '', FALSE, '', '', ''), 
(49, uuid(), '765', 'FY18', 'TI18', '2020/9/24', 365, '2020/6/26', '', FALSE, '', '', ''), 
(50, uuid(), '765', 'FY18', 'TI18', '2020/9/24', 365, '2020/6/26', '', FALSE, '', '', ''), 
(51, uuid(), '768', 'FY18', 'TI18', '2020/3/30', 183, '2019/12/31', '', FALSE, '', '', ''), 
(52, uuid(), '768', 'FY18', 'TI18', '2020/11/30', 365, '2020/9/1', '', FALSE, '', '', ''), 
(53, uuid(), '768', 'FY18', 'TI18', '2020/11/30', 365, '2020/9/1', '', FALSE, '', '', ''), 
(54, uuid(), '800', 'FY18', 'TI16', '2020/12/14', 365, '2020/9/15', '', FALSE, 'N148500-4', 'Released', 'Released'), 
(55, uuid(), '801', 'FY18', 'TI16', '2021/1/12', 365, '2020/10/14', '', FALSE, '', '', ''), 
(56, uuid(), '775', 'FY17', 'TI16', '2021/2/13', 365, '2020/11/15', '', FALSE, 'N165081-1', 'Released', 'Released'), 
(57, uuid(), '801', 'FY18', 'TI16', '2021/6/14', 365, '2021/3/16', '', FALSE, 'N148500-4', 'Released', 'Released'), 
(58, uuid(), '773', 'FY18', 'TI18', '2021/6/6', 183, '2021/3/8', '', FALSE, '', '', ''), 
(59, uuid(), '800', 'FY18', 'TI16', '2022/1/1', 365, '2021/10/3', '', FALSE, 'N165085-1 ', 'Released', 'Released'), 
(60, uuid(), '773', 'FY18', 'TI18', '2022/2/6', 365, '2021/11/8', '', FALSE, '', '', ''), 
(61, uuid(), '773', 'FY18', 'TI18', '2022/2/6', 365, '2021/11/8', '', FALSE, '', '', ''), 
(62, uuid(), '801', 'FY18', 'TI16', '2022/9/1', 365, '2022/6/3', '', FALSE, 'N165085-1 ', 'Released', 'Released'), 
(63, uuid(), '21', 'FY17', 'TI16', '2018/4/13', 365, null, 'Complete', TRUE, 'N160100-10', 'Released', 'Released'), 
(64, uuid(), '21', 'FY17', 'TI16', '2018/2/4', 183, '2017/11/6', 'Complete', TRUE, 'N150130-1', 'Released', 'Released'), 
(65, uuid(), '23', 'FY16', 'TI16', '2017/8/30', 183, '2017/6/1', 'Complete', TRUE, 'N166856-1', 'Released', 'Released'), 
(66, uuid(), '23', 'FY16', 'TI16', '2019/4/17', 365, '2019/1/17', 'Complete', TRUE, 'N165070-1', 'Released', 'Released'), 
(67, uuid(), '23', 'FY16', 'TI16', '2019/4/17', 365, '2019/1/17', 'Complete', TRUE, 'N160100-30', 'Released', 'Released'), 
(68, uuid(), '774', 'FY17', 'TI16', '2018/4/1', 183, '2018/1/1', 'Complete', TRUE, 'N148547-1', 'Released', 'Released'), 
(69, uuid(), '774', 'FY17', 'TI16', '2019/4/7', 365, '2019/1/7', 'Complete', TRUE, 'N148500-100 ', 'Released', 'Released'), 
(70, uuid(), '775', 'FY17', 'TI16', '2020/6/13', 183, '2020/3/15', 'Complete', TRUE, 'N148547-1 ', 'Released', 'Released'), 
(71, uuid(), '775', 'FY17', 'TI16', '2021/2/13', 365, '2020/11/15', 'Complete', TRUE, 'N148500-300', 'Released', 'Released'), 
(72, uuid(), '777', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N148547-1', 'Released', 'Released'), 
(73, uuid(), '777', 'FY16', 'TI16', '2017/9/21', 365, '2017/6/23', 'Complete', TRUE, 'N165080-1', 'Released', 'Released'), 
(74, uuid(), '777', 'FY16', 'TI16', '2017/9/21', 365, '2017/6/23', 'Complete', TRUE, 'N148500-200', 'Released', 'Released'), 
(75, uuid(), '778', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N122756-1
N148547-1', 'Released', 'Released'), 
(76, uuid(), '778', 'FY16', 'TI16', '2017/10/3', 365, '2017/7/5', 'Complete', TRUE, 'N165079-1', 'Released', 'Released'), 
(77, uuid(), '778', 'FY16', 'TI16', '2017/10/3', 365, '2017/7/5', 'Complete', TRUE, 'N148500-100', 'Released', 'Released'), 
(78, uuid(), '779', 'FY17', 'TI16', '2017/7/28', 183, '2017/4/29', 'Complete', TRUE, 'N148547-1 ', 'Released', 'Released'), 
(79, uuid(), '779', 'FY17', 'TI16', '2018/7/5', 365, '2018/4/6', 'Complete', TRUE, 'N148500-200 ', 'Released', 'Released'), 
(80, uuid(), '783', 'FY17', 'TI16', '2018/4/1', 183, '2018/1/1', 'Complete', TRUE, 'N148547-1 ', 'Released', 'Released'), 
(81, uuid(), '783', 'FY17', 'TI16', '2018/6/14', 365, '2018/3/16', 'Complete', TRUE, 'N148500-500', 'Released', 'Released'), 
(82, uuid(), '785', 'FY17', 'TI16', '2018/5/13', 183, '2018/2/12', 'Complete', TRUE, 'N148547-1', 'Released', 'Released'), 
(83, uuid(), '785', 'FY17', 'TI16', '2018/7/13', 365, '2018/4/14', 'Complete', TRUE, 'N148500-400', 'Released', 'Released'), 
(84, uuid(), '794', 'FY16', 'TI16', '2017/7/3', 365, '2017/4/4', 'Complete', TRUE, '', '', ''), 
(85, uuid(), '794', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(86, uuid(), '794', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N127966-2 ', 'Released', 'Released'), 
(87, uuid(), '794', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(88, uuid(), '794', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(89, uuid(), '794', 'FY16', 'TI16', '2017/12/11', 365, '2017/9/12', 'Complete', TRUE, 'N148500-1', 'Released', 'Released'), 
(90, uuid(), '794', 'FY16', 'TI16', '2019/1/11', 365, '2018/10/13', 'Complete', TRUE, 'N160570-1CW', 'Released', 'Released'), 
(91, uuid(), '794', 'FY16', 'TI16', '2019/1/1', 365, '2018/10/3', 'Complete', TRUE, 'N165084-1', 'Released', 'Released'), 
(92, uuid(), '794', 'FY16', 'TI16', '2019/1/1', 365, '2018/10/3', 'Complete', TRUE, 'N165084-1', 'Released', 'Released'), 
(93, uuid(), '795', 'FY16', 'TI16', '2017/5/9', 183, null, 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(94, uuid(), '795', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N127966-2', 'Released', 'Released'), 
(95, uuid(), '795', 'FY16', 'TI16', '2018/2/1', 365, '2017/11/3', 'Complete', TRUE, '', '', ''), 
(96, uuid(), '795', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(97, uuid(), '795', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(98, uuid(), '795', 'FY16', 'TI16', '2018/6/15', 365, '2018/3/17', 'Complete', TRUE, 'N148500-1', 'Released', 'Released'), 
(99, uuid(), '795', 'FY16', 'TI16', '2019/7/8', 365, '2019/4/9', 'Complete', TRUE, 'N160570-1CW', 'Released', '12/9: WIP'), 
(100, uuid(), '795', 'FY16', 'TI16', '2019/9/1', 365, '2019/6/3', 'Complete', TRUE, 'N165084-1', 'Released', 'Released'), 
(101, uuid(), '795', 'FY16', 'TI16', '2019/9/1', 365, '2019/6/3', 'Complete', TRUE, 'N165084-1', 'Released', 'Released'), 
(102, uuid(), '796', 'FY16', 'TI16', '2017/2/1', 365, null, 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(103, uuid(), '796', 'FY16', 'TI16', '2017/11/3', 183, '2017/8/5', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(104, uuid(), '796', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N127966-2', 'Released', 'Released'), 
(105, uuid(), '796', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(106, uuid(), '796', 'FY16', 'TI16', '2018/7/17', 365, '2018/4/18', 'Complete', TRUE, '', '', ''), 
(107, uuid(), '796', 'FY16', 'TI16', '2018/12/14', 365, '2018/9/15', 'Complete', TRUE, 'N148500-5', 'Released', 'Released'), 
(108, uuid(), '796', 'FY16', 'TI16', '2020/1/8', 365, '2019/10/10', 'Complete', TRUE, 'N160570-1CW', 'Released', '12/9: WIP'), 
(109, uuid(), '796', 'FY16', 'TI16', '2020/1/1', 365, '2019/10/3', 'Complete', TRUE, 'N165085-1', 'Released', 'Released'), 
(110, uuid(), '796', 'FY16', 'TI16', '2020/1/1', 365, '2019/10/3', 'Complete', TRUE, 'N165085-1', 'Released', 'Released'), 
(111, uuid(), '797', 'FY16', 'TI16', '2017/5/30', 365, '2017/3/1', 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(112, uuid(), '797', 'FY16', 'TI16', '2017/7/24', 365, '2017/4/25', 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(113, uuid(), '797', 'FY16', 'TI16', '2017/4/4', 183, null, 'Complete', TRUE, 'N127966-2', 'Released', 'Released'), 
(114, uuid(), '797', 'FY16', 'TI16', '2018/5/4', 183, '2018/2/3', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(115, uuid(), '797', 'FY16', 'TI16', '2019/1/11', 365, '2018/10/13', 'Complete', TRUE, '', '', ''), 
(116, uuid(), '797', 'FY16', 'TI16', '2019/6/11', 365, '2019/3/13', 'Complete', TRUE, 'N148500-5', 'Released', 'Released'), 
(117, uuid(), '797', 'FY16', 'TI16', '2020/7/7', 365, '2020/4/8', 'Complete', TRUE, 'N160570-1CW', 'Released', '12/9: WIP'), 
(118, uuid(), '797', 'FY16', 'TI16', '2020/9/1', 365, '2020/6/3', 'Complete', TRUE, 'N165085-1', 'Released', 'Released'), 
(119, uuid(), '797', 'FY16', 'TI16', '2020/9/1', 365, '2020/6/3', 'Complete', TRUE, 'N165085-1', 'Released', 'Released'), 
(120, uuid(), '798', 'FY17', 'TI16', '2018/10/31', 183, '2018/8/2', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(121, uuid(), '798', 'FY17', 'TI16', '2017/10/2', 183, '2017/7/4', 'Complete', TRUE, 'N127966-2', 'Released', 'Released'), 
(122, uuid(), '798', 'FY17', 'TI16', '2017/11/17', 365, '2017/8/19', 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(123, uuid(), '798', 'FY17', 'TI16', '2018/5/1', 365, '2018/1/31', 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(124, uuid(), '798', 'FY17', 'TI16', '2019/7/16', 365, '2019/4/17', 'Complete', TRUE, '', '', ''), 
(125, uuid(), '798', 'FY17', 'TI16', '2019/12/16', 365, '2019/9/17', 'Complete', TRUE, 'N148500-4', 'Released', 'Released'), 
(126, uuid(), '798', 'FY17', 'TI16', '2021/1/1', 0, '2020/10/3', 'Complete', TRUE, 'N165085-1 ', 'Released', 'Released'), 
(127, uuid(), '798', 'FY17', 'TI16', '2021/1/1', 0, '2020/10/3', 'Complete', TRUE, 'N165085-1 ', 'Released', 'Released'), 
(128, uuid(), '798', 'FY17', 'TI16', '2021/1/8', 365, '2020/10/10', 'Complete', TRUE, 'N160570-1', 'Released', 'Released'), 
(129, uuid(), '799', 'FY17', 'TI16', '2018/4/2', 183, '2018/1/2', 'Complete', TRUE, 'N127966-2', 'Released', 'Released'), 
(130, uuid(), '799', 'FY17', 'TI16', '2018/5/24', 365, '2018/2/23', 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(131, uuid(), '799', 'FY17', 'TI16', '2019/5/2', 183, '2019/2/1', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(132, uuid(), '799', 'FY17', 'TI16', '2018/8/24', 365, '2018/5/26', 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(133, uuid(), '799', 'FY17', 'TI16', '2020/1/14', 365, '2019/10/16', 'Complete', TRUE, '', '', ''), 
(134, uuid(), '799', 'FY17', 'TI16', '2020/6/10', 365, '2020/3/12', 'Complete', TRUE, 'N148500-4', 'Released', 'Released'), 
(135, uuid(), '799', 'FY17', 'TI16', '2021/7/8', 365, '2021/4/9', 'Complete', TRUE, 'N160570-1', 'Released', 'Released'), 
(136, uuid(), '799', 'FY17', 'TI16', '2021/9/1', 0, '2021/6/3', 'Complete', TRUE, 'N165085-1 ', 'Released', 'Released'), 
(137, uuid(), '799', 'FY17', 'TI16', '2021/9/1', 0, '2021/6/3', 'Complete', TRUE, 'N165085-1 ', 'Released', 'Released'), 
(138, uuid(), '800', 'FY17', 'TI16', '2018/11/14', 365, '2018/8/16', 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(139, uuid(), '800', 'FY17', 'TI16', '2019/10/29', 183, '2019/7/31', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(140, uuid(), '800', 'FY17', 'TI16', '2019/2/1', 365, '2018/11/3', 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(141, uuid(), '800', 'FY18', 'TI16', '2022/1/1', 365, '2021/10/3', 'Complete', FALSE, 'N165085-1 ', 'Released', 'Released'), 
(142, uuid(), '800', 'FY17', 'TI16', '2020/12/14', 183, '2020/9/15', 'Complete', TRUE, 'N146651-2', '', ''), 
(143, uuid(), '800', 'FY17', 'TI16', '2022/1/10', 365, '2021/10/12', 'Complete', TRUE, 'N160570-1CW', 'Released', 'Released'), 
(144, uuid(), '801', 'FY17', 'TI16', '2019/5/22', 365, '2019/2/21', 'Complete', TRUE, 'N137732-1', 'Released', 'Released'), 
(145, uuid(), '801', 'FY17', 'TI16', '2020/4/28', 183, '2020/1/29', 'Complete', TRUE, 'N123719-3', 'Released', 'Released'), 
(146, uuid(), '801', 'FY17', 'TI16', '2019/7/23', 365, '2019/4/24', 'Complete', TRUE, '77C962400G1', 'Released', 'Released'), 
(147, uuid(), '801', 'FY18', 'TI16', '2022/9/1', 365, '2022/6/3', 'Complete', FALSE, 'N165085-1 ', 'Released', 'Released'), 
(148, uuid(), '801', 'FY17', 'TI16', '2021/6/14', 183, '2021/3/16', 'Complete', TRUE, 'N146651-2', '', ''), 
(149, uuid(), '801', 'FY17', 'TI16', '2022/7/8', 365, '2022/4/9', 'Complete', TRUE, 'N160570-1CW', 'Released', 'Released'), 
(150, uuid(), 'EDM', 'FY17', 'TI16', '2016/10/1', 183, null, 'Complete', TRUE, 'N146823-1', 'Released', 'Released'), 
(151, uuid(), 'INCO', 'FY17', 'TI16', '2017/8/30', 365, '2017/6/1', 'Complete', TRUE, 'N166856-1', '11:15 Released', '11:08: Released'), 
(152, uuid(), 'INCO', 'FY17', 'TI16', '2017/10/1', 365, '2017/7/3', 'Complete', TRUE, 'N165699-1', 'Released', 'Released'), 
(153, uuid(), 'INCO', 'FY17', 'TI16', '2017/10/1', 365, '2017/7/3', 'Complete', TRUE, 'N165698-1', 'Released', 'Released'), 
(154, uuid(), 'INCO', 'FY17', 'TI16', '2017/10/1', 365, '2017/7/3', 'Complete', TRUE, 'N165697-1', 'Released', 'Released'), 
(155, uuid(), 'INCO', 'FY17', 'TI16', '2017/12/1', 365, '2017/9/2', 'Complete', TRUE, 'N166714-1', 'Released', 'Released'), 
(156, uuid(), 'LVA-790', 'FY17', 'TI14', '2017/5/5', 183, '2017/2/4', 'Complete', TRUE, '701418-01/
701152-03', 'N/A', 'N/A'), 
(158, uuid(), 'LVA-790', 'FY17', 'TI14', null, 183, null, 'Complete', TRUE, 'Various', 'N/A', 'N/A'), 
(159, uuid(), 'LVA-790', 'FY17', 'TI14', null, 183, '1900/1/1', 'Complete', TRUE, 'TBD', '', ''), 
(160, uuid(), 'MISC', 'FY18', 'TI16', '2018/3/1', 183, '2017/12/1', 'Complete', TRUE, 'N106431
79C1002-00', 'n/a', 'n/a'), 
(161, uuid(), 'MISC', 'FY17', 'TI16', '2017/8/1', 120, '2017/5/3', 'Complete', TRUE, 'many', '', ''), 
(162, uuid(), 'MISC', '', 'TI16', '2017/12/16', 365, '2017/9/17', 'Complete', TRUE, '500721-01', '', ''), 
(163, uuid(), 'MISC', 'FY15', 'TI16', '1900/1/1', 0, '1900/1/1', 'Complete', TRUE, '', '', ''), 
(164, uuid(), 'MISC', 'FY16', 'TI16', null, 0, '1900/1/1', 'Complete', TRUE, 'ELD0062306', 'N/A', 'N/A'), 
(165, uuid(), 'Mock-up', 'FY17', 'TI16', '2017/6/15', 0, '2017/3/17', 'Complete', TRUE, 'N146813-1
N146814-1
N166558-11
N166558-15', 'Released', 'Released'), 
(166, uuid(), 'Mock-up', 'FY17', 'TI16', '1900/1/1', 0, null, 'Complete', TRUE, '', '', ''), 
(167, uuid(), 'SSBN #1L', 'FY16', 'TI16', '2017/9/25', 365, '2017/6/27', 'Complete', TRUE, 'N165075-1 ', 'Released', 'Released'), 
(168, uuid(), 'SSBN #1L', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N148190-2', 'Released', 'Released'), 
(169, uuid(), 'SSBN #1L', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N148009-1
N165806-1 ', 'Released', 'Released'), 
(170, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N148190-2', 'Released', 'Released'), 
(171, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 365, null, 'Complete', TRUE, 'N165075-1 ', 'Released', 'Released'), 
(172, uuid(), 'SSBN #2L', 'FY16', 'TI16', null, 183, null, 'Complete', TRUE, 'N148009-1
N165806-1 ', 'Released', 'Released'), 
(173, uuid(), 'SSBN #3P', 'FY17', 'TI16', '2018/2/14', 365, '2017/11/16', 'Complete', TRUE, 'N165076-1', 'Released', 'Released'), 
(174, uuid(), 'SSBN #3P', 'FY17', 'TI16', '2018/2/14', 365, '2017/11/16', 'Complete', TRUE, 'N148190-1', 'Released', 'Released'), 
(175, uuid(), 'SSBN #3P', 'FY17', 'TI16', '2017/3/1', 183, null, 'Complete', TRUE, 'N148009-1 
N165806-1', 'Released', 'Released'), 
(176, uuid(), 'SSBN #4L', 'FY17', 'TI16', '2017/11/13', 183, '2017/8/15', 'Complete', TRUE, 'N148009-1
N165806-1', 'Released', 'Released'), 
(177, uuid(), 'SSBN #4L', 'FY17', 'TI16', '2018/11/3', 365, '2018/8/5', 'Complete', TRUE, 'N148190-2', 'Released', 'Released'), 
(178, uuid(), 'SSBN #5P', 'FY17', 'TI16', '2018/3/1', 183, '2017/12/1', 'Complete', TRUE, 'N148009-1
N165806-1', 'Released', 'Released'), 
(179, uuid(), 'SSBN #5P', 'FY17', 'TI16', '2018/8/15', 365, '2018/5/17', 'Complete', TRUE, 'N148190-1 ', 'Released', 'Released'), 
(180, uuid(), 'LVA-790', 'FY17', 'TI14', null, 365, '1900/1/1', '', TRUE, 'TBD', '', ''), 
(181, uuid(), 'LVA-790', 'FY17', 'TI14', null, 365, '1900/1/1', '', TRUE, 'TBD', '', '') 
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
(4, uuid(), 4, uuid(), 'tbd4', 'Spares', 'UNRESTRICTED', '2017/4/13'), 
(5, uuid(), 5, uuid(), 'tbd5', 'EOL Purchase of CPLD for PCM and Func Mod (TI18)', 'UNRESTRICTED', '2017/5/1'), 
(6, uuid(), 6, uuid(), 'tbd6', 'Spares', 'UNRESTRICTED', '2017/5/15'), 
(7, uuid(), 7, uuid(), 'tbd7', 'System', 'UNRESTRICTED', '2017/5/15'), 
(8, uuid(), 8, uuid(), 'tbd8', 'APB19 TI18 Servers for Ben', 'UNRESTRICTED', '2017/6/1'), 
(9, uuid(), 9, uuid(), 'tbd9', 'Spares', 'UNRESTRICTED', '2017/6/14'), 
(10, uuid(), 10, uuid(), 'tbd10', 'TI18 688 Development Assets for Bernie', 'UNRESTRICTED', '2017/6/26'), 
(11, uuid(), 11, uuid(), 'tbd11', 'Spares', 'UNRESTRICTED', '2017/7/5'), 
(12, uuid(), 12, uuid(), 'tbd12', 'Spares', 'UNRESTRICTED', '2017/7/13'), 
(13, uuid(), 13, uuid(), 'tbd13', 'FY17 SSBN #5P SPARES', 'UNRESTRICTED', '2017/8/15'), 
(14, uuid(), 14, uuid(), 'tbd14', 'PCK', 'UNRESTRICTED', '2017/8/30'), 
(15, uuid(), 15, uuid(), 'tbd15', 'PCK', 'UNRESTRICTED', '2017/9/3'), 
(16, uuid(), 16, uuid(), 'tbd16', 'Spares', 'UNRESTRICTED', '2017/9/5'), 
(17, uuid(), 17, uuid(), 'tbd17', 'System', 'UNRESTRICTED', '2017/9/5'), 
(18, uuid(), 18, uuid(), 'tbd18', 'FY17 SSBN #4L SPARES', 'UNRESTRICTED', '2017/11/3'), 
(19, uuid(), 19, uuid(), ' ', 'PCK', 'UNRESTRICTED', '2017/11/7'), 
(20, uuid(), 20, uuid(), 'tbd20', 'PCK', 'UNRESTRICTED', '2017/12/12'), 
(21, uuid(), 21, uuid(), 'tbd21', 'Spares', 'UNRESTRICTED', '2018/1/16'), 
(22, uuid(), 22, uuid(), 'tbd22', 'System', 'UNRESTRICTED', '2018/1/16'), 
(23, uuid(), 23, uuid(), 'tbd23', 'Spares', 'UNRESTRICTED', '2018/2/13'), 
(24, uuid(), 24, uuid(), 'tbd24', 'System', 'UNRESTRICTED', '2018/2/13'), 
(25, uuid(), 25, uuid(), 'tbd25', 'PCK', 'UNRESTRICTED', '2018/3/16'), 
(26, uuid(), 26, uuid(), 'tbd26', 'PCK', 'UNRESTRICTED', '2018/3/28'), 
(27, uuid(), 27, uuid(), 'tbd27', 'Spares', 'UNRESTRICTED', '2018/4/7'), 
(28, uuid(), 28, uuid(), 'tbd28', 'Spares', 'UNRESTRICTED', '2018/6/1'), 
(29, uuid(), 29, uuid(), 'tbd29', ' ', 'UNRESTRICTED', '2018/6/1'), 
(30, uuid(), 30, uuid(), 'tbd30', 'PCK', 'UNRESTRICTED', '2018/7/16'), 
(31, uuid(), 31, uuid(), 'tbd31', 'Spares', 'UNRESTRICTED', '2018/9/15'), 
(32, uuid(), 32, uuid(), 'tbd32', 'System', 'UNRESTRICTED', '2018/9/15'), 
(33, uuid(), 33, uuid(), 'tbd33', 'PCK', 'UNRESTRICTED', '2018/9/21'), 
(34, uuid(), 34, uuid(), 'tbd34', 'PCK', 'UNRESTRICTED', '2018/9/26'), 
(35, uuid(), 35, uuid(), 'tbd35', 'PCK', 'UNRESTRICTED', '2018/9/30'), 
(36, uuid(), 36, uuid(), 'tbd36', 'Spares', 'UNRESTRICTED', '2018/11/23'), 
(37, uuid(), 37, uuid(), 'tbd37', 'System', 'UNRESTRICTED', '2018/11/23'), 
(38, uuid(), 38, uuid(), 'tbd38', 'PCK', 'UNRESTRICTED', '2019/1/13'), 
(39, uuid(), 39, uuid(), 'tbd39', 'PCK', 'UNRESTRICTED', '2019/2/1'), 
(40, uuid(), 40, uuid(), 'tbd40', 'PCK', 'UNRESTRICTED', '2019/3/2'), 
(41, uuid(), 41, uuid(), 'tbd41', 'Spares', 'UNRESTRICTED', '2019/3/16'), 
(42, uuid(), 42, uuid(), 'tbd42', 'System', 'UNRESTRICTED', '2019/3/16'), 
(43, uuid(), 43, uuid(), 'tbd43', 'Spares', 'UNRESTRICTED', '2019/5/2'), 
(44, uuid(), 44, uuid(), 'tbd44', 'System', 'UNRESTRICTED', '2019/5/2'), 
(45, uuid(), 45, uuid(), 'tbd45', 'Spares', 'UNRESTRICTED', '2019/5/14'), 
(46, uuid(), 46, uuid(), 'tbd46', 'System', 'UNRESTRICTED', '2019/5/14'), 
(47, uuid(), 47, uuid(), 'tbd47', 'PCK', 'UNRESTRICTED', '2019/7/5'), 
(48, uuid(), 48, uuid(), 'tbd48', 'Early Fiber Delivery', 'UNRESTRICTED', '2019/7/14'), 
(49, uuid(), 49, uuid(), 'tbd49', 'Spares', 'UNRESTRICTED', '2019/9/25'), 
(50, uuid(), 50, uuid(), 'tbd50', 'System', 'UNRESTRICTED', '2019/9/25'), 
(51, uuid(), 51, uuid(), 'tbd51', 'PCK', 'UNRESTRICTED', '2019/9/29'), 
(52, uuid(), 52, uuid(), 'tbd52', 'Spares', 'UNRESTRICTED', '2019/12/1'), 
(53, uuid(), 53, uuid(), 'tbd53', 'System', 'UNRESTRICTED', '2019/12/1'), 
(54, uuid(), 54, uuid(), 'tbd54', 'System', 'UNRESTRICTED', '2019/12/15'), 
(55, uuid(), 55, uuid(), 'tbd55', 'Early Fiber Delivery', 'UNRESTRICTED', '2020/1/13'), 
(56, uuid(), 56, uuid(), 'tbd56', 'Spares', 'UNRESTRICTED', '2020/2/14'), 
(57, uuid(), 57, uuid(), 'tbd57', 'System', 'UNRESTRICTED', '2020/6/14'), 
(58, uuid(), 58, uuid(), 'tbd58', 'PCK', 'UNRESTRICTED', '2020/12/5'), 
(59, uuid(), 59, uuid(), 'tbd59', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '2021/1/1'), 
(60, uuid(), 60, uuid(), 'tbd60', 'Spares', 'UNRESTRICTED', '2021/2/6'), 
(61, uuid(), 61, uuid(), 'tbd61', 'System', 'UNRESTRICTED', '2021/2/6'), 
(62, uuid(), 62, uuid(), 'tbd62', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '2021/9/1'), 
(63, uuid(), 63, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00014A', 'System', 'UNRESTRICTED', '1900/01/01'), 
(64, uuid(), 64, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00014A', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(65, uuid(), 65, uuid(), '16-ARCI FY16 Production-LMDM-PCD00040B', 'OBRP/MAMS Delta kit', 'UNRESTRICTED', '1900/01/01'), 
(66, uuid(), 66, uuid(), '16-ARCI FY16 Production-LMDM-PCD00020A', 'Spares', 'UNRESTRICTED', '1900/01/01'), 
(67, uuid(), 67, uuid(), '16-ARCI FY16 Production-LMDM-PCD00020A', 'System', 'UNRESTRICTED', '1900/01/01'), 
(68, uuid(), 68, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00013', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(69, uuid(), 69, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00013', 'System', 'UNRESTRICTED', '1900/01/01'), 
(70, uuid(), 70, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00012', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(71, uuid(), 71, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00012', 'System', 'UNRESTRICTED', '1900/01/01'), 
(72, uuid(), 72, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(73, uuid(), 73, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'Spares', 'UNRESTRICTED', '1900/01/01'), 
(74, uuid(), 74, uuid(), '16-ARCI FY16 Production-LMDM-PCD00018A', 'System', 'UNRESTRICTED', '1900/01/01'), 
(75, uuid(), 75, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(76, uuid(), 76, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'Spares', 'UNRESTRICTED', '1900/01/01'), 
(77, uuid(), 77, uuid(), '16-ARCI FY16 Production-LMDM-PCD00019A', 'System', 'UNRESTRICTED', '1900/01/01'), 
(78, uuid(), 78, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00009', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(79, uuid(), 79, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00009', 'System', 'UNRESTRICTED', '1900/01/01'), 
(80, uuid(), 80, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00010', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(81, uuid(), 81, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00010', 'System', 'UNRESTRICTED', '1900/01/01'), 
(82, uuid(), 82, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00011', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(83, uuid(), 83, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00011', 'System', 'UNRESTRICTED', '1900/01/01'), 
(84, uuid(), 84, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(85, uuid(), 85, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(86, uuid(), 86, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(87, uuid(), 87, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(88, uuid(), 88, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(89, uuid(), 89, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'System', 'UNRESTRICTED', '1900/01/01'), 
(90, uuid(), 90, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(91, uuid(), 91, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(92, uuid(), 92, uuid(), '15-ARCI FY15 Production-LMDM-PCD00002D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(93, uuid(), 93, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(94, uuid(), 94, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(95, uuid(), 95, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(96, uuid(), 96, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(97, uuid(), 97, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(98, uuid(), 98, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'System', 'UNRESTRICTED', '1900/01/01'), 
(99, uuid(), 99, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003C', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(100, uuid(), 100, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(101, uuid(), 101, uuid(), '15-ARCI FY15 Production-LMDM-PCD00003D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(102, uuid(), 102, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(103, uuid(), 103, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(104, uuid(), 104, uuid(), '16-ARCI Production-LMDM-PCD00005A', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(105, uuid(), 105, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(106, uuid(), 106, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(107, uuid(), 107, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004D', 'System', 'UNRESTRICTED', '1900/01/01'), 
(108, uuid(), 108, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004B', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(109, uuid(), 109, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004E', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(110, uuid(), 110, uuid(), '15-ARCI FY15 Production-LMDM-PCD00004E', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(111, uuid(), 111, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(112, uuid(), 112, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(113, uuid(), 113, uuid(), '16-ARCI Production-LMDM-PCD00006', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(114, uuid(), 114, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(115, uuid(), 115, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(116, uuid(), 116, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005C', 'System', 'UNRESTRICTED', '1900/01/01'), 
(117, uuid(), 117, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005B', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(118, uuid(), 118, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005D', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(119, uuid(), 119, uuid(), '15-ARCI FY15 Production-LMDM-PCD00005D', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(120, uuid(), 120, uuid(), '17-ARCI Production-LMDM-PCD00002', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(121, uuid(), 121, uuid(), '17-ARCI Production-LMDM-PCD00002', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(122, uuid(), 122, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00007', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(123, uuid(), 123, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(124, uuid(), 124, uuid(), '17-ARCI Production-LMDM-PCD00002', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(125, uuid(), 125, uuid(), '17-ARCI Production-LMDM-PCD00002', 'System', 'UNRESTRICTED', '1900/01/01'), 
(126, uuid(), 126, uuid(), '17-ARCI Production-LMDM-PCD00002', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(127, uuid(), 127, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(128, uuid(), 128, uuid(), '17-ARCI Production-LMDM-PCD00002', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(129, uuid(), 129, uuid(), '17-ARCI Production-LMDM-PCD00003', 'PCK', 'UNRESTRICTED', '1900/01/01'), 
(130, uuid(), 130, uuid(), '17-ARCI Production-LMDM-PCD00003', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(131, uuid(), 131, uuid(), '17-ARCI Production-LMDM-PCD00003', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(132, uuid(), 132, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(133, uuid(), 133, uuid(), '17-ARCI Production-LMDM-PCD00003', 'Early Fiber Delivery', 'UNRESTRICTED', '1900/01/01'), 
(134, uuid(), 134, uuid(), '17-ARCI Production-LMDM-PCD00003', 'System', 'UNRESTRICTED', '1900/01/01'), 
(135, uuid(), 135, uuid(), '17-ARCI Production-LMDM-PCD00003', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(136, uuid(), 136, uuid(), '17-ARCI Production-LMDM-PCD00003', 'TI16 NewCon ODC Spares', 'UNRESTRICTED', '1900/01/01'), 
(137, uuid(), 137, uuid(), '17-ARCI Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(138, uuid(), 138, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(139, uuid(), 139, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(140, uuid(), 140, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(141, uuid(), 141, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(142, uuid(), 142, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'Long Lead EOQ', 'UNRESTRICTED', '1900/01/01'), 
(143, uuid(), 143, uuid(), '17-ARCI Production-LMDM-PCD00004A', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(144, uuid(), 144, uuid(), '17-ARCI Production-LMDM-PCD00005', 'ASRU', 'UNRESTRICTED', '1900/01/01'), 
(145, uuid(), 145, uuid(), '17-ARCI Production-LMDM-PCD00005', 'Flow Valves', 'UNRESTRICTED', '1900/01/01'), 
(146, uuid(), 146, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00002', 'OBEs', 'UNRESTRICTED', '1900/01/01'), 
(147, uuid(), 147, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00003', 'TI16 NewCon Spares (OBRP)', 'UNRESTRICTED', '1900/01/01'), 
(148, uuid(), 148, uuid(), '17-ARCI Production-LMDM-PCD00005', 'Long Lead EOQ', 'UNRESTRICTED', '1900/01/01'), 
(149, uuid(), 149, uuid(), '17-ARCI Production-LMDM-PCD00005', 'LWWAA', 'UNRESTRICTED', '1900/01/01'), 
(150, uuid(), 150, uuid(), '15-ARCI FY15 Production-LMDM-PCD00025A', 'Order 2 Laptop Kits for Integration', 'UNRESTRICTED', '1900/01/01'), 
(151, uuid(), 151, uuid(), '16-ARCI FY16 Production-LMDM-PCD00040B', '$595K ODC Seawolf Spares Buy', 'UNRESTRICTED', '1900/01/01'), 
(152, uuid(), 152, uuid(), '16-ARCI FY16 Production-LMDM-PCD00039', 'SSBN INCO Spares', 'UNRESTRICTED', '1900/01/01'), 
(153, uuid(), 153, uuid(), '16-ARCI FY16 Production-LMDM-PCD00043A', 'Va Mod/Seawolf INCO Spares', 'UNRESTRICTED', '1900/01/01'), 
(154, uuid(), 154, uuid(), '16-ARCI FY16 Production-LMDM-PCD00044', 'Va New Con INCO Spares', 'UNRESTRICTED', '1900/01/01'), 
(155, uuid(), 155, uuid(), '16-ARCI FY16 Production-LMDM-PCD00038A', 'Order additional spares Ref:P00057 on 6294 - $2.4M', 'UNRESTRICTED', '1900/01/01'), 
(156, uuid(), 156, uuid(), '16-ARCI Engineering Services TI14-LMDM-PCD00111A', 'Buy S79 and S47 EQT servers for LVA', 'UNRESTRICTED', '1900/01/01'), 
(158, uuid(), 158, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00001B', 'LVA 790 ABF Delta HW Initial Buy (Jan 2017)', 'UNRESTRICTED', '1900/01/01'), 
(159, uuid(), 159, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00006G', 'LVA 790 ABF Delta HW (remaining hw required after drawings are released)', 'UNRESTRICTED', '1900/01/01'), 
(160, uuid(), 160, uuid(), '17-ARCI FY17 TI16 Production-LMDM-PCD00015', 'EOL Purchase of CPLD for PCM and Func Mod (TI16)', 'UNRESTRICTED', '1900/01/01'), 
(161, uuid(), 161, uuid(), '17-ARCI FY16 Production-LMDM-PCD00007A', 'Bakers Rack 3 Additional Sets for vaMod', 'UNRESTRICTED', '1900/01/01'), 
(162, uuid(), 162, uuid(), '16-ARCI FY16 Production-LMDM-PCD00042', 'Motherboard EOL purchase - in TI16-B03/S14/S34/S37/S40', 'UNRESTRICTED', '1900/01/01'), 
(163, uuid(), 163, uuid(), '15-ARCI FY15 Production-LMDM-PCD00030B', 'Sippican MK21 PCB Assemblies', 'UNRESTRICTED', '1900/01/01'), 
(164, uuid(), 164, uuid(), '16-ARCI FY16 Production-LMDM-PCD00030', 'Laser Modulators need Qnty 433 on 6294 P000057', 'UNRESTRICTED', '1900/01/01'), 
(165, uuid(), 165, uuid(), '16-FY14 ARCI/Va Production-LMDM-PCD00006', 'LVA 2D Mockups', 'UNRESTRICTED', '1900/01/01'), 
(166, uuid(), 166, uuid(), '16-ARCI FY16 Production-LMDM-PCD00026A', 'Va Mod 2D Mock-ups (Early delivery stuff)', 'UNRESTRICTED', '1900/01/01'), 
(167, uuid(), 167, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L Spares', 'UNRESTRICTED', '1900/01/01'), 
(168, uuid(), 168, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L System', 'UNRESTRICTED', '1900/01/01'), 
(169, uuid(), 169, uuid(), '16-ARCI FY16 Production-LMDM-PCD00011D', 'FY16 SSBN #1L PCK', 'UNRESTRICTED', '1900/01/01'), 
(170, uuid(), 170, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L System', 'UNRESTRICTED', '1900/01/01'), 
(171, uuid(), 171, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L Spares', 'UNRESTRICTED', '1900/01/01'), 
(172, uuid(), 172, uuid(), '16-ARCI FY16 Production-LMDM-PCD00012D', 'FY16 SSBN #2L PCK', 'UNRESTRICTED', '1900/01/01'), 
(173, uuid(), 173, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P SPARES', 'UNRESTRICTED', '1900/01/01'), 
(174, uuid(), 174, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P System', 'UNRESTRICTED', '1900/01/01'), 
(175, uuid(), 175, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00001A', 'FY17 SSBN #3P PCK', 'UNRESTRICTED', '1900/01/01'), 
(176, uuid(), 176, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00003', 'FY17 SSBN #4L PCK', 'UNRESTRICTED', '1900/01/01'), 
(177, uuid(), 177, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00003', 'FY17 SSBN #4L System', 'UNRESTRICTED', '1900/01/01'), 
(178, uuid(), 178, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00002', 'FY17 SSBN #5P PCK', 'UNRESTRICTED', '1900/01/01'), 
(179, uuid(), 179, uuid(), '16-ARCI FY17 TI16 Production-LMDM-PCD00002', 'FY17 SSBN SHIPSET 5 System', 'UNRESTRICTED', '1900/01/01'), 
(180, uuid(), 180, uuid(), 'tbd180', 'LVA INCOs', 'UNRESTRICTED', '1900/1/1'), 
(181, uuid(), 181, uuid(), 'tbd181', 'LVA Spares', 'UNRESTRICTED', '1900/1/1') 
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
