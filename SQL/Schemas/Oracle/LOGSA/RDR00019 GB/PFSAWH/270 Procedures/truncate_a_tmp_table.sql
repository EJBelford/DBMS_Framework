CREATE OR REPLACE PROCEDURE "TRUNCATE_A_TMP_TABLE" (my_test VARCHAR2)
AS
   w_test     VARCHAR2 (128);
   sql_stmt   VARCHAR2 (256);
BEGIN
   w_test := my_test;
   sql_stmt := 'truncate table ' || trim(w_test);

   EXECUTE IMMEDIATE sql_stmt;
END truncate_a_tmp_table;
/