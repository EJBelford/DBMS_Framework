-- DROP TABLE omega_enum_virtual;

CREATE TABLE omega_enum_virtual
(
  rec_id integer,
  rec_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
  omega_enum_virtual character varying(254) NOT NULL,
  sort_ordr integer DEFAULT 0,
  status character(1) NOT NULL DEFAULT 'C'::bpchar, -- status - A 1 character code for the statsu of the record, (Current, Error, Historical, New, Processing, Waiting)
  status_by character varying(50) DEFAULT "current_user"(), -- status_by - The user who last changed the status of the record
  status_date timestamp with time zone NOT NULL DEFAULT now(), -- status_date - The date when the record status was last changed
  insert_date timestamp with time zone NOT NULL DEFAULT now(), -- insert_date - The date the record was created
  insert_by character varying(50) DEFAULT "current_user"(), -- insert_by - The user/fuction that created the record
  update_date timestamp with time zone, -- update_date - The date the record was last modified
  update_by character varying(50), -- update_by - The user/function that last updated the record
  delete_flag boolean DEFAULT false, -- delete_flag - A logical flag used to ignore the record as if it was deleted
  delete_date timestamp with time zone, -- delete_date - The date the logical delete flag was set
  delete_by character varying(50), -- delete_by - The user/function that set the logical delete flag
  hidden_flag boolean DEFAULT false, -- hidden_flag - A flag used to hide/exclude the record from pick lists
  hidden_date timestamp with time zone, -- hidden_date - The date the hidden flag was set
  hidden_by character varying(50), -- hidden_by - The user/function that set the hidden flag
  CONSTRAINT omega_enum_virtual_pkey PRIMARY KEY (rec_uuid),
  CONSTRAINT omega_enum_virtual_ukey1 UNIQUE (rec_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE omega_enum_virtual
  OWNER TO postgres;

  
-- DROP TABLE omega_enum_virtual_ref;

CREATE TABLE omega_enum_virtual_ref
(
  rec_id integer,
  rec_uuid uuid NOT NULL DEFAULT uuid_generate_v4(),
  uuid_parent uuid,
  uuid_child uuid,
  sort_ordr integer DEFAULT 0,
  status character(1) NOT NULL DEFAULT 'C'::bpchar, -- status - A 1 character code for the statsu of the record, (Current, Error, Historical, New, Processing, Waiting)
  status_by character varying(50) DEFAULT "current_user"(), -- status_by - The user who last changed the status of the record
  status_date timestamp with time zone NOT NULL DEFAULT now(), -- status_date - The date when the record status was last changed
  insert_date timestamp with time zone NOT NULL DEFAULT now(), -- insert_date - The date the record was created
  insert_by character varying(50) DEFAULT "current_user"(), -- insert_by - The user/fuction that created the record
  update_date timestamp with time zone, -- update_date - The date the record was last modified
  update_by character varying(50), -- update_by - The user/function that last updated the record
  delete_flag boolean DEFAULT false, -- delete_flag - A logical flag used to ignore the record as if it was deleted
  delete_date timestamp with time zone, -- delete_date - The date the logical delete flag was set
  delete_by character varying(50), -- delete_by - The user/function that set the logical delete flag
  hidden_flag boolean DEFAULT false, -- hidden_flag - A flag used to hide/exclude the record from pick lists
  hidden_date timestamp with time zone, -- hidden_date - The date the hidden flag was set
  hidden_by character varying(50), -- hidden_by - The user/function that set the hidden flag
  CONSTRAINT omega_enum_virtual_ref_pkey PRIMARY KEY (rec_uuid),
  CONSTRAINT omega_enum_virtual_ref_ukey1 UNIQUE (rec_id),
  CONSTRAINT omega_enum_virtual_ref_ukey2 UNIQUE (uuid_parent, uuid_child)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE omega_enum_virtual_ref
  OWNER TO postgres;

