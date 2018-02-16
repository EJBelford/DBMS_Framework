/* Formatted on 2008/11/07 09:34 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PROCEDURE table_size_tracking ( my_owner varchar2 ) 

IS 

BEGIN
    INSERT 
    INTO   pfsawh_tab_size_trk
                ( table_name, chk_date, num_of_rows, last_analysis )
        SELECT table_name, SYSDATE, num_rows, last_analyzed
          FROM all_tables
         WHERE owner = my_owner;
END table_size_tracking;