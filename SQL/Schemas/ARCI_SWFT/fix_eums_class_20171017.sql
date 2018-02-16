DELIMITER $$

$$

INSERT
INTO pcd_tracker.enum_values (
    rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description
    )
VALUES
(uuid_v4(),  30, 'CLASS', '688', 000, '688', 'Los Angeles-class submarine'), 
(uuid_v4(),  30, 'CLASS', '688i', 000, '688i', 'Los Angeles-class submarine'), 
(uuid_v4(),  30, 'CLASS', 'SSBN', 000, 'SSBN', 'Ship, Submersible, Ballistic, Nuclear'), 
(uuid_v4(),  30, 'CLASS', 'SSGN', 000, 'SSGN', 'Submersible, Ship, Guided, Nuclear'), 
(uuid_v4(),  30, 'CLASS', 'SW', 000, 'SW', 'Seawolf-class submarine'), 
(uuid_v4(),  30, 'CLASS', 'VA', 000, 'VA', 'Virginia-class submarine'), 
(uuid_v4(),  30, 'CLASS', 'VA BLK I', 000, 'VA BLK I', 'Virginia-class Blk I ()'), 
(uuid_v4(),  30, 'CLASS', 'VA BLK II', 000, 'VA BLK II', 'Virginia-class Blk II ()'), 
(uuid_v4(),  30, 'CLASS', 'VA BLK III', 000, 'VA BLK III', 'Virginia-class Blk III ()'), 
(uuid_v4(),  30, 'CLASS', 'VA BLK IV', 000, 'VA BLK IV', 'Virginia-class Blk IV ()'), 
(uuid_v4(),  30, 'CLASS', 'VA BLK V', 000, 'VA BLK V', 'Virginia-class Blk V ()') 
;
$$

DELIMITER ;
