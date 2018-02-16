-- synchronize_script.sql

CREATE TABLE omega.synchronize_content
(
	rec_id bigint,
	rec_uuid uuid,
	dataobj_type_cd int,
	domain_1 boolean,
	domain_2 boolean,
	domain_3 boolean,
--	STATUS_BOILERPLATE,
--	SECURITY_BOILERPLATE,
	CONSTRAINT unnamed18 PRIMARY KEY(rec_uuid)
);

CREATE TABLE omega.structured_data_transfer_queue
(
	rec_id bigint,
	trans_batch_uuid uuid,
	item_num int,
	dataobj_uuid uuid,
	sync_status char [1],
	source_domain int,
	target_domain int,
	timestamp_pending timestamp with time zone,
	timestamp_processing timestamp with time zone,
	timestamp_complete timestamp with time zone,
--	STATUS_BOILERPLATE,
	CONSTRAINT unnamed19 PRIMARY KEY(trans_batch_uuid, dataobj_uuid),
	FOREIGN KEY(dataobj_uuid) REFERENCES postgres.omega_data_obj (rec_uuid)
);

CREATE TABLE omega.synchronize_content_element
(
	rec_id bigint,
	rec_uuid uuid,
	sync_content_uuid uuid,
	element_id int,
	domain_1 boolean,
	domain_1_hl_action char [1],
	domain_1_lh_action char [1],
	domain_2 boolean,
	domain_2_hl_action char [1],
	domain_2_lh_action char [1],
	domain_3 boolean,
	domain_3_hl_action char [1],
	domain_3_lh_action char [1],
--	STATUS_BOILERPLATE,
--	SECURITY_BOILERPLATE,
	FOREIGN KEY(sync_content_uuid) REFERENCES omega.synchronize_content (rec_uuid)
);
