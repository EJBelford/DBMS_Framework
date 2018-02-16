
INSERT INTO enterprise(enterprise_id,ent_db_site,ent_db_id,ent_type_code,user_tag_ident,name,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) VALUES (1075,'0000000000000000',2,3,'CONTROL-PT','Control Point Corporation',to_date('18-FEB-2008'),'0000000000000000',2,1);

INSERT INTO site(site_code,enterprise_id,site_id,st_db_site,st_db_id,st_type_code,user_tag_ident,name,template_yn,gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) 
VALUES('0000043300000001',1075,1,'0000000000000000',2,5,'CPC Reference Database for Ground System Prototye Sample',
'CPC Reference Database Site for Ground System Prototype Sample','Y',sysdate,null,null,1);

INSERT INTO site_database(db_site,db_id,user_tag_ident,
gmt_last_updated,last_upd_db_site,last_upd_db_id,rstat_type_code) 
VALUES('0000043300000001',1,'Next Generation Prototype Ground Combat System Reference Database',
sysdate,'0000043300000001',1,1);
