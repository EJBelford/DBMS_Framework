DELIMITER $$

DROP FUNCTION IF EXISTS f_remarks_string;

$$
CREATE FUNCTION f_remarks_string(
	p_rec_id INT
)
RETURNS TEXT

LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'This function build a string of all the remarks related to the parent.'

BEGIN

/* Source File: f_remarks_string.sql                                          */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Module Name: f_remarks_string                                              */
/*      Author: Gene Belford                                                  */
/* Description: This function build a string of all the remarks related to    */
/*              the parent.                                                   */
/*        Date: 2017-05-25                                                    */
/* Source File: f_remarks_string.sql                                          */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Change History                                                             */
/* ==============                                                             */
/* Date:       Chng_Ctrl  Name                  Description                   */
/* ==========  =========  ====================  ============================= */
/* 2017-05-25             Gene Belford          Created                       */
/* 2017-05-30             Gene Belford          Updated for MariaDB.          */
/* 2017-05-31             Gene Belford          Add remark types to the       */
/*             results string and a line between comments.                    */
/*                                                                            */
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*--+----1----+----2----+----3----+----4----+----5----+----6----+----7----+---*/
/*                                                                            */
/* Unit Test                                                                  */
/*

SELECT CONCAT('"', f_remarks_string(0), '"');

SELECT CONCAT('"', f_remarks_string(4), '"');

SELECT CONCAT('"', f_remarks_string(5), '"');

SELECT CONCAT('"', f_remarks_string(6), '"');

SELECT CONCAT('"', f_remarks_string(63), '"');

*/

    DECLARE r_remark_type   VARCHAR(8)         DEFAULT NULL;
    DECLARE r_remark_date   DATE               DEFAULT NULL;
    DECLARE r_remark_user   VARCHAR(50)        DEFAULT NULL;
    DECLARE r_remark        TEXT               DEFAULT NULL;
    
    DECLARE v_text          TEXT               DEFAULT '';
    
    DECLARE done            BOOL;     
    
    DECLARE cur_remarks CURSOR FOR 
        SELECT remark_type, remark_date, remark_user, remark  
        FROM pcd_tracker.remarks  
        WHERE parent_rec_id = p_rec_id; 
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
    OPEN cur_remarks; 
        
    concat_loop: LOOP 
        FETCH cur_remarks INTO r_remark_type, r_remark_date, r_remark_user, r_remark;
        
        IF done IS TRUE THEN
            LEAVE concat_loop;
        ELSE 
            SET v_text := CONCAT(r_remark_type, ' : ', r_remark_date, ' : ', r_remark_user, ' : ', r_remark, '\n', REPEAT('-', 80), '\n', v_text); 
        END IF;

    END LOOP;
    
    CLOSE cur_remarks;
    
    RETURN v_text;

END $$
