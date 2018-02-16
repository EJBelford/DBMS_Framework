CREATE OR REPLACE PACKAGE atis_toe_ref_pckg 
IS 

    PROCEDURE toe_uic_list;

END atis_toe_ref_pckg;


create or replace package body atis_toe_ref_pckg 

as

/*     function myfuncname ( inval number )
        return number
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
        return tmpvar;
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end myfuncname; */
	
/*-----  -----*/	
/*
    
    EXECUTE DBMS_OUTPUT.PUT_LINE(100);
    EXECUTE toe_uic_list();
    
*/

    CREATE OR REPLACE PROCEDURE toe_uic_list
    AS

/*---------------------- Cursors ----------------------*/

    CURSOR toe_uic_cur IS
		SELECT DISTINCT atoer.uic, 
			aor.dispname, 
			aor.title
		FROM atis_table_org_equip_ref atoer 
		LEFT OUTER JOIN atis_organizations_ref aor ON atoer.uic = aor.uic
		ORDER BY atoer.uic;
        
    toe_uic_rec    toe_uic_cur%ROWTYPE;
   
    begin
       DBMS_OUTPUT.ENABLE(1000000);
       DBMS_OUTPUT.PUT_LINE('10:');
        
       OPEN toe_uic_cur;
    
        LOOP
            FETCH toe_uic_cur 
            INTO  toe_uic_rec;
        
            EXIT WHEN toe_uic_cur%NOTFOUND  
                OR (toe_uic_cur%ROWCOUNT > 11)  -- Need for unit testing .. 
                ;
        
            DBMS_OUTPUT.PUT_LINE  (
                'toe_uic_list'   
                || ': '|| toe_uic_rec.uic  
                || ', '|| toe_uic_rec.dispname
                || ', '|| toe_uic_rec.title
                );
        
        END LOOP;
    
        CLOSE toe_uic_cur;
		
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end toe_uic_list;

/*-----  -----*/	

    procedure toe_lin_by_uic_list ( p_uic_code varchar2 )
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
		
		SELECT DISTINCT atoer.moslin, 
			atoer.titlenomen 
		FROM atis_table_org_equip_ref atoer 
		WHERE UPPER(atoer.uic) = UPPER(p_uic_code)
			AND GRADE IS NULL 
		ORDER BY atoer.MOSLIN;
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end toe_lin_by_uic_list;


/*-----  -----*/	

    procedure toe_mos_by_uic_list ( p_uic_code varchar2 )
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
		
		SELECT atoer.uic, 
			atoer.paratitle, 
			atoer.grade, 
			atoer.moslin, 
			atoer.titlenomen, 
			atoer.req, 
			atoer.auth 
    	    -- , '|' , atoer.* 
		FROM atis_table_org_equip_ref atoer 
		WHERE UPPER(atoer.uic) = UPPER(p_uic_code)
			AND GRADE IS NOT NULL
		ORDER BY atoer.GRADE; 
     exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end toe_mos_by_uic_list;
 

/*-----  -----*/	

    procedure toe_lin_by_uic_list ( p_uic_code varchar2 )
    is
        tmpvar                        number;
    begin
        tmpvar := 0;
		
		SELECT atoer.uic, 
			atoer.paratitle, 
			atoer.moslin, 
			atoer.titlenomen, 
			atoer.req, 
			atoer.auth  
			-- , '|' , atoer.* 
		FROM atis_table_org_equip_ref atoer 
		WHERE UPPER(atoer.uic) = UPPER(p_uic_code)
			AND GRADE IS NULL
		ORDER BY atoer.MOSLIN; 
    exception
        when no_data_found then
            null;
        when others then
            -- consider logging the error and then re-raise
            raise;
    end toe_lin_by_uic_list;

	
/*-----  -----*/	

end atis_toe_ref_pckg;

/ 