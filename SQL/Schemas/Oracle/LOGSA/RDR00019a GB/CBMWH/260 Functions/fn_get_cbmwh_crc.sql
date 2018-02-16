/* Formatted on 2008/08/26 11:40 (Formatter Plus v4.8.8) */
/********************************* TEAM ITSS ***********************************

         NAME: get_cbmwh_crc 
      PURPOSE:   

   CREATED BY: Gene Belford 
  DESIGNED BY: Leslie M. Johnson 
 CREATED DATE: 26 August 2008 

   PARAMETERS: 

        INPUT:  

       OUTPUT:  

  ASSUMPTIONS:


  LIMITATIONS:

        NOTES:


HISTORY of REVISIONS:

  Date    ECP #         Author             Description
-------   ------------  -----------------  ---------------------------------
26AUG08                 Gene Belford       Function Created

*********************************** TEAM ITSS *********************************/

CREATE OR REPLACE FUNCTION fn_get_cbmwh_crc (i_string VARCHAR2)
   RETURN NUMBER
IS
   w_crc      NUMBER          := 0;
   w_crc_up   NUMBER          := 0;
   w_crc_dn   NUMBER          := 0;
   w_len      NUMBER;
   w_pos      NUMBER;
   w_text     VARCHAR2 (4096);
BEGIN
   w_text := i_string;
   w_len := LENGTH (w_text);
   w_pos := 1;

   WHILE w_pos <= w_len
   LOOP
      w_crc_up := w_crc_up + (w_pos * (ASCII (SUBSTR (w_text, w_pos, 1)) - 63));
      w_pos := w_pos + 1;
   END LOOP;

   w_pos := w_len;

   WHILE w_pos >= 1
   LOOP
      w_crc_dn := w_crc_dn + (w_pos * (ASCII (SUBSTR (w_text, ((w_len+1) - w_pos), 1)) - 63));
      w_pos := w_pos - 1;
   END LOOP;
   
   w_crc := ABS (w_crc_up - w_crc_dn);
   RETURN w_crc;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN -1;
   WHEN OTHERS
   THEN
      -- consider logging the error and then re-raise
      RETURN -2;
END fn_get_cbmwh_crc;