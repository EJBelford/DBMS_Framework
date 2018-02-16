create or replace procedure pr_fix_n_2_ch (in_text varchar2) is

--    type rawtyp is ref cursor;

DECLARE

    cursor chk_cursor  is
            select   rec_id, uic, wh_last_update_date, status
            from pfsawh_force_unit_dim
          -- where status = 'N'
        order by uic, wh_last_update_date desc;
    o_uic                         varchar2 ( 6 );
    o_rec_id                      number;
    n_rec_id                      number;
    n_status                      varchar2 ( 1 );
    n_uic                         varchar2 ( 6 );
    wh_last_update_date           date;
    o_date                        date;
begin
    /*
     the test field name,test date, and unique record id (a field or set of fields)
     need to be defined in the select statment
    */
    o_uic := 'X';
    n_rec_id := null;
    n_uic := null;
    o_date := null;
    wh_last_update_date := null;
    n_status := null;
    n_rec_id := null;

-- one of the keys to making this work is the sort desc for the record set.
-- the key field, comparsion group field, and date field are a must in the
-- select statement.
-- the status is based on the 'N' but may be any other condition that meets the
-- requirement to determine the most current as active and the older being a history
-- record.
    open chk_cursor ;

    loop
        fetch chk_cursor
         into n_rec_id, n_uic, wh_last_update_date, n_status;

        exit when chk_cursor%notfound;

        if o_uic <> n_uic then
-- this is a new record set and should have the most recent date
            o_uic := n_uic;

            update pfsawh_force_unit_dim
               set status = 'C'
             where rec_id = n_rec_id;
        else
-- this is an older record and should be set to H
            update pfsawh_force_unit_dim
               set status = 'H'
             where rec_id = n_rec_id;
        end if;
    end loop;
end pr_fix_n_2_ch; 

/*

SELECT status, COUNT(status) 
FROM   pfsawh_force_unit_dim 
GROUP by status; 

*/