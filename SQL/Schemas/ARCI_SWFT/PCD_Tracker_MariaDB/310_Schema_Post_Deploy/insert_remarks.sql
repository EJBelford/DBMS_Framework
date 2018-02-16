/* Source File: insert_remarks.sql                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: pcd_tracker.remarks_seq                                       */
/*      Author: Gene Belford                                                  */
/* Description: Creates a sequence number for the table that is assigned      */
/*              to the rec_id each new record is created.                     */
/*        Date: 2017-05-25                                                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-25             Gene Belford          Created                       */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/

-- 310 Schema Post Deploy 

-- DELETE FROM  pcd_tracker.remarks; 

INSERT 
INTO pcd_tracker.remarks (
    parent_rec_id, parent_rec_uuid, 
    remark_type, remark_user, remark 
    )
VALUES 
(4, uuid(), 'TRACKER', 'etl', '4/11/17: Not funded yet. Wait for funding to come in'),
(4, uuid(), 'TRACKER', 'etl', '2/13/17: Work around is to Utilize a subset of the SSN23 spares'), 
(5, uuid(), 'TRACKER', 'etl', '3/28/2017: Need direction from 401 on TI18 EOL or redesign.  Need to pursue'), 
(6, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'),
(6, uuid(), 'TRACKER', 'etl', '3/28/2017: Brian Evans working with Eddie on what the bom is.  It may equal 783l'),
(6, uuid(), 'TRACKER', 'etl', '3/30/2017: Brian confirmed 782 = 783 BOM'), 
(7, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'), 
(8, uuid(), 'TRACKER', 'etl', 'Roger and Pat said they will fund with LWWAA contract material'), 
(9, uuid(), 'TRACKER', 'etl', '4/11/17: Not funded yet. Wait for funding to come in'), 
(10, uuid(), 'TRACKER', 'etl', 'Steve and Joey to plan for 2 shipsets worth of FEA.  Wake up date is at the start FEA process'), 
(11, uuid(), 'TRACKER', 'etl', '3/9/17: Not funded yet. Wait for funding to come in'), 
(12, uuid(), 'TRACKER', 'etl', '3/28/2017: 4/7 o/l for release'),
(12, uuid(), 'TRACKER', 'etl', '3/9/17: Not funded yet. Wait for funding to come in'), 
(13, uuid(), 'TRACKER', 'etl', '3/13/17: Not funded'), 
(14, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'), 
(15, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'), 
(16, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'), 
(17, uuid(), 'TRACKER', 'etl', '3/13/17: funding in April'), 
(19, uuid(), 'TRACKER', 'etl', '4/18/17: Waiting on Michelle to release BOM'), 
(19, uuid(), 'TRACKER', 'etl', '1/12/17: Need Larry''s approval for GFI'), 
(22, uuid(), 'TRACKER', 'etl', '11/16: Not funded'), 
(56, uuid(), 'TRACKER', 'etl', '3/9/17: Not funded yet. Wait for funding to come in'), 
(59, uuid(), 'TRACKER', 'etl', '1/12/17: Working proposal'), 
(62, uuid(), 'TRACKER', 'etl', '1/12/17: Working proposal'), 
(63, uuid(), 'TRACKER', 'etl', '11/16: Not funded'), 
(19, uuid(), 'TRACKER', 'etl', '2/13/17: Work around is to Utilize a subset of the ssn23 assets'), 
(64, uuid(), 'TRACKER', 'etl', '3/28/2017: outlook for release is 4/7'), 
(65, uuid(), 'TRACKER', 'etl', 'CLW O/L 8/1/2017'), 
(66, uuid(), 'TRACKER', 'etl', '12/7/17: CLW O/L APRIL THROUGH AUGUST 2017 (SYS) 7/30/2018 SPARES'), 
(67, uuid(), 'TRACKER', 'etl', '12/7/17: CLW O/L APRIL THROUGH AUGUST 2017 (SYS) 7/30/2018 SPARES'), 
(19, uuid(), 'TRACKER', 'etl', 'ND: Action Complete'), 
(72, uuid(), 'TRACKER', 'etl', '12/7/2016: IN GPHA'), 
(73, uuid(), 'TRACKER', 'etl', '12/7/2016: CLW 4/23/17'), 
(74, uuid(), 'TRACKER', 'etl', 'Long poles: ACDI cards arriving 7/10 - go into junction boxes'), 
(75, uuid(), 'TRACKER', 'etl', '12/7/16: IN GPHA'), 
(76, uuid(), 'TRACKER', 'etl', '12/7/16: CLW O/L 7/13/17'), 
(77, uuid(), 'TRACKER', 'etl', '12/7/16: CLW O/L 1/20/17'), 
(78, uuid(), 'TRACKER', 'etl', '2/13/17: FEA Approved, PCD generated.'), 
(89, uuid(), 'TRACKER', 'etl', '12/7/16: CLW O/L 2017'), 
(91, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'), 
(91, uuid(), 'TRACKER', 'etl', 'Will we order the same items we are proposing for 798 thru 801?'), 
(92, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'), 
(92, uuid(), 'TRACKER', 'etl', 'Holding until ODC are funded'), 
(94, uuid(), 'TRACKER', 'etl', '11/15: Launching end item HPCD this week and will be starting release of PRs next week.'), 
(98, uuid(), 'TRACKER', 'etl', '12/7: CLW O/L 2017'), 
(100, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'), 
(100, uuid(), 'TRACKER', 'etl', 'Will we order the same items we are proposing for 798 thru 801?'), 
(101, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'), 
(101, uuid(), 'TRACKER', 'etl', 'Holding until ODC are funded'), 
(102, uuid(), 'TRACKER', 'etl', 'O/L from Syracuse 6/23/17'), 
(104, uuid(), 'TRACKER', 'etl', '12/7/16: Del''d to customer'),
(104, uuid(), 'TRACKER', 'etl', '11/30/16: Shipped 11/16/16'),
(104, uuid(), 'TRACKER', 'etl', 'Received Mod PZ0001 funding and charges from FEA go to Clin 00110AB.'), 
(105, uuid(), 'TRACKER', 'etl', '12/7/16: Del''d to Customer'), 
(107, uuid(), 'TRACKER', 'etl', 'Received Mod PZ0001 funding remaining Hardware. PCD Draft 001269 in review.'), 
(109, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'),
(109, uuid(), 'TRACKER', 'etl', 'Will we order the same items we are proposing for 798 thru 801?'), 
(110, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'),
(110, uuid(), 'TRACKER', 'etl', 'Holding until ODC are funded'), 
(113, uuid(), 'TRACKER', 'etl', 'Received Funding Mod POZ0001 PCK on order 10/24/2016.'), 
(116, uuid(), 'TRACKER', 'etl', 'Received Mod PZ0001 funding remaining Hardware. PCD Draft 000107  in review.'), 
(118, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'),
(118, uuid(), 'TRACKER', 'etl', 'Will we order the same items we are proposing for 798 thru 801?'), 
(119, uuid(), 'TRACKER', 'etl', '2/16/17: Need to get WPs opened per Jmullins'),
(119, uuid(), 'TRACKER', 'etl', 'Holding until ODC are funded'), 
(122, uuid(), 'TRACKER', 'etl', '2/13/17: Joey to work on FEA '), 
(126, uuid(), 'TRACKER', 'etl', '1/12/17: Working proposal'), 
(136, uuid(), 'TRACKER', 'etl', '1/12/17: Working proposal'), 
(138, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(139, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(140, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(142, uuid(), 'TRACKER', 'etl', ' '), 
(143, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(144, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(145, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(146, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(148, uuid(), 'TRACKER', 'etl', ' '), 
(149, uuid(), 'TRACKER', 'etl', 'Part of N146651-2 LL/EOQ BOM'), 
(150, uuid(), 'TRACKER', 'etl', '12/7/16: Rec''d 11/9/15'), 
(152, uuid(), 'TRACKER', 'etl', '12/7/16: CLW O/L 10/26/17'), 
(152, uuid(), 'TRACKER', 'etl', 'PCD released Nov 11 2016.'), 
(153, uuid(), 'TRACKER', 'etl', '11/16: Per B. Jones: Rec''d funding; still waiting on BOM release'), 
(153, uuid(), 'TRACKER', 'etl', 'Received funding Slin 006AB for Mod/Seawolf. 1.6mil. Expect BOM to be released by 11/18/2016'), 
(154, uuid(), 'TRACKER', 'etl', '11:16: Per B. Jones: Rec''d funding; waiting on BOM release'), 
(154, uuid(), 'TRACKER', 'etl', 'Received funding Slin 006AA for Va New TI16 I&C kit. Awaiting expected BOM release 23 November 2016.'), 
(155, uuid(), 'TRACKER', 'etl', '12/7/16: CLW O/L 11/1/17'), 
(155, uuid(), 'TRACKER', 'etl', 'PCD released Nov 10 2016.'), 
(156, uuid(), 'TRACKER', 'etl', '3/14/17: PO''s placed. O/L June 2017 and April 2017'), 
(156, uuid(), 'TRACKER', 'etl', '12/12/16: PRs launched. Need PO.'),  
(156, uuid(), 'TRACKER', 'etl', '5/23/16: we were funded 800K, waiting for list to order'), 
(156, uuid(), 'TRACKER', 'etl', '9/29/16:  Need ~60 days after ABF decision for list to be provided (Note from Betsy W.)'), 
(158, uuid(), 'TRACKER', 'etl', '1/23/17:  Initial list fat/eqt hw and delta kit'), 
(159, uuid(), 'TRACKER', 'etl', '5/23/16: we were funded 800K, waiting for list to order'), 
(159, uuid(), 'TRACKER', 'etl', '9/29/16:  Need ~60 days after ABF decision for list to be provided (Note from Betsy W.)'), 
(159, uuid(), 'TRACKER', 'etl', '2/20/17: April finalizing quotes and EOL investigation. Nimssi received WPs. Ready to PCD.'), 
(160, uuid(), 'TRACKER', 'etl', '1/12/17: Michelle working on quantities'), 
(160, uuid(), 'TRACKER', 'etl', '3/28/2017: PCD issued 3/28 using TI18 FEA.  Only covers TI16 FY18. Still need direction from 401 on TI18 EOL or redesign'), 
(163, uuid(), 'TRACKER', 'etl', '3/13/17: Emailed Jeremiyah asking for status'), 
(163, uuid(), 'TRACKER', 'etl', 'EOL Buy '), 
(164, uuid(), 'TRACKER', 'etl', '3/14/17: PO # 4102815475. According to Neckar: we just approved their test procedures 2 weeks ago, so they''re going to be starting test and sell off soon'), 
(164, uuid(), 'TRACKER', 'etl', '9/30/2016 received Email Note: From A. Neckar providing information'), 
(165, uuid(), 'TRACKER', 'etl', '12/7/16 CLW O/L 8/1/2017'), 
(165, uuid(), 'TRACKER', 'etl', '8/30/16: I have authorized to use existing funding for LVA790 until customer funding comes in'), 
(165, uuid(), 'TRACKER', 'etl', '8/31/16: Per Thanh she said use existing LVA funding, since it is only $29K, I am good with it.'), 
(165, uuid(), 'TRACKER', 'etl', '9/7/16: Talked to Bill and BOMs still not released. Draft PCD ready awaiting ECN release (Steve Z).'),                                                                                                                                       
(165, uuid(), 'TRACKER', 'etl', '10/10/2016: ECN released per Steve Z and PCD issued.'), 
(165, uuid(), 'TRACKER', 'etl', '1/30/2017: Note from Bateman:  It is OK to extend the second set of LVA 2D Mockups from 2/1 to 4/15 without EB impact.'), 
(166, uuid(), 'TRACKER', 'etl', '12/7/16: Vendor O/L 2/18-4/1/17'), 
(166, uuid(), 'TRACKER', 'etl', '8/30/16: Fanto sent note to Thanh.  I have also asked Katie to provide a wp# so that we can order these.  Need to payback Engr Services for loan.'), 
(166, uuid(), 'TRACKER', 'etl', '9/1/16: Talked to Mark Wadell at the ISR and he said he was ok with LM buying the VaMod 2 Ds'), 
(166, uuid(), 'TRACKER', 'etl', '9/1/16: Thanh sent a note saying she approves'), 
(166, uuid(), 'TRACKER', 'etl', '9/7/15: Bill now has WP#, and we discussed the 12/8/16 customer RDD'), 
(174, uuid(), 'TRACKER', 'etl', '12/12/16: still working CAP sheets and won’t load CW until next week.  However, loaded Manassas and will launch Manassas and Progeny reqs this week'), 
(177, uuid(), 'TRACKER', 'etl', '12/12/16: still working CAP sheets and won’t load CW until next week.  However, loaded Manassas and will launch Manassas and Progeny reqs this week'), 
(179, uuid(), 'TRACKER', 'etl', '12/12/16: still working CAP sheets and won’t load CW until next week.  However, loaded Manassas and will launch Manassas and Progeny reqs this week'), 
(180, uuid(), 'TRACKER', 'etl', 'Remarks'), 
(181, uuid(), 'TRACKER', 'etl', '1/12/17: Waiting on Navy to provide information'), 
(182, uuid(), 'TRACKER', 'etl', '1/12/17: Waiting on Navy to provide information') 
;


INSERT 
INTO pcd_tracker.remarks (
    parent_rec_id, parent_rec_uuid, 
    remark_type, remark_date, remark_user, remark 
    )
VALUES 
(63, NULL, 'PCD', '2017/04/10', 'EJB', 'The purpose of this PCD is to serve as an Initial WAD P00014, authorizing the procurement, manufacturing and labor efforts for FY17 TI12 to TI16 SSN 21 Pre-Cable kit (N150130-1). The Period of Performance (POP) for this April 2017 thru June 2018. 

Note: Per PPMD Section 5.5.3 all CAM''s are required to open and close their respective work packages. This is accomplished by the CAM filling out Open/Close Charge ID Macro contained in folder 40 on the EVM portal.

Note: For all Required Delivery Dates (RDD) Please reference the Installation Planning Matrix.'),
(63, NULL, 'PCD', '2017/03/22', 'EJB', '03/22/2017 The purpose of this PCD is to serve as an Initial WAD P00014, authorizing the procurement, manufacturing and labor efforts for FY17 TI12 to TI16 SSN 21 Sonar System. The Period of Performance (POP) for this effort shall be from March 2017 thru June 2018. 

Note: Per PPMD Section 5.5.3 all CAM''s are required to open and close their respective work packages. This is accomplished by the CAM filling out Open/Close Charge ID Macro contained in folder 40 on the EVM portal.

Note: For all Required Delivery Dates (RDD) Please reference the Installation Planning Matrix.

Part                               Contract              
Number        Nomenclature  Qty    Clin      Work Package

N160100-10    Sonar System   1     0214AA    See Attachment Provided

N150130-1     Pre-Cable kit  1     0214AB    See Attachment Provided'),

(65, NULL, 'PCD', '2017/02/03', 'EJB', 'This PCD revision corrects the Manassas Hardware work package from 1M17ETMMA380 to 1M17ETM1M380 PER Email Note from Janet Myers dated 30 January 2017.'),
(65, NULL, 'PCD', '2017/01/17', 'EJB', 'This PCD updates Labor and Hardware work packages based on FY 17 funding.'),
(65, NULL, 'PCD', '2016/11/16', 'EJB', '11/16/2016- The purpose of this PCD authorizes the procurement efforts for ordering the SSN 23 TI08 to TI16 OBRP/MAMs Delta kit N166856-1. 

Note: The Spare hardware kit is being procured via Engineering Service Task utilizing ODC Funds Slin 00103AM. 

Part                              Est.             Work
Number      Description      Qty  Cost   RDD       Package       Remarks

N166856-1   SSN 23 OBRP/MAMs  1   $500k  08/30/17  1M17ETM1M380  Man Hd only
                                    89k            1M17ETC1M380  Clw Hd only'),

(65, NULL, 'PCD', '2017/02/03', 'EJB', '')
;

/*
    
SELECT r.* 
FROM   pcd_tracker.remarks r 
ORDER BY r.rec_id; 

*/



