DELIMITER $$

DELETE 
FROM pcd_tracker.enum_values 
WHERE enum_type = 'HULL_NUMBER' 
    AND rec_id > 0;
$$	


INSERT
INTO pcd_tracker.enum_values (
    rec_uuid, parent_rec_id, enum_type, enum_value, order_by, enum_display_name, description
    )
VALUES
(uuid_v4(),  7, 'HULL_NUMBER', '21',   10, '21',  'USS Seawolf (SSN-21)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '22',   15, '22',  'USS Connecticut (SSN-22)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '23',   20, '23',  'USS Jimmy Carter (SSN-23)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '727',  25, '727', 'USS Michigan (SSBN-727/SSGN-727)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '729',  30, '729', 'USS Georgia (SSBN-729/SSGN-729)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '731',  35, '731', 'USS Alabama (SSBN-731)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '732',  40, '732', 'USS Alaska (SSBN-732)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '733',  45, '733', 'USS Nevada (SSBN-733)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '737',  50, '737', 'USS Kentucky (SSBN-737)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '738',  55, '738', 'USS Maryland (SSBN-738)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '740',  60, '740', 'USS Rhode Island (SSBN-740)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '741',  65, '741', 'USS Maine (SSBN-741)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '742',  70, '742', 'USS Wyoming (SSBN-742)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '743',  75, '743', 'USS Louisiana (SSBN-743)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '752',  80, '752', 'USS Pasadena (SSN-752)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '754',  85, '754', 'USS Topeka (SSN-754)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '757',  90, '757', 'USS Alexandria (SSN-757)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '758',  95, '758', 'USS Asheville (SSN-758)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '761', 100, '761', 'USS Springfield (SSN-761)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '763', 105, '763', 'USS Santa Fe (SSN-763)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '764', 110, '764', 'USS Boise (SSN-764)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '765', 115, '765', 'USS Montpelier (SSN-765)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '766', 120, '766', 'USS Charlotte (SSN-766)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '767', 125, '767', 'USS Hampton (SSN-767)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '768', 130, '768', 'USS Hartford (SSN-768)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '769', 135, '769', 'USS Toledo (SSN 769)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '770', 140, '770', 'USS Tucson (SSN-770)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '771', 145, '771', 'USS Columbia (SSN-771)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '772', 150, '772', 'USS Greeneville (SSN-772)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '773', 155, '773', 'USS Cheyenne (SSN-773)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '774', 160, '774', 'USS Virginia (SSN-774)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '775', 165, '775', 'USS Texas (SSN-775)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '776', 170, '776', 'USS Hawaii (SSN-776)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '777', 175, '777', 'USS North Carolina (SSN-777)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '778', 180, '778', 'USS New Hampshire (SSN-778)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '779', 185, '779', 'USS New Mexico (SSN-779)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '780', 190, '780', 'USS Missouri (SSN-780)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '781', 195, '781', 'USS California (SSN-781)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '782', 200, '782', 'USS Mississippi (SSN-782)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '783', 205, '783', 'USS Minnesota (SSN-783)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '784', 210, '784', 'USS North Dakota (SSN-784)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '785', 215, '785', 'USS John Warner (SSN-785)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '786', 220, '786', 'USS Illinois (SSN-786)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '794', 225, '794', 'USS Montana (SSN-794)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '795', 230, '795', 'USS Hyman G. Rickover (SSN-795)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '796', 235, '796', 'USS New Jersey (SSN-796)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '797', 240, '797', 'USS Iowa (SSN-797'), 
(uuid_v4(),  7, 'HULL_NUMBER', '798', 245, '798', 'USS Massachusetts (SSN-798)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '799', 250, '799', 'USS Idaho (SSN-799)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '800', 255, '800', 'USS Arkansas (SSN-800)'), 
(uuid_v4(),  7, 'HULL_NUMBER', '801', 260, '801', 'USS Utah (SSN-801'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'EDM',       300, 'EDM', 'EDM'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'INCO',      305, 'INCO', 'INCO'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'LVA-790',   310, 'LVA-790', 'LVA-790'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'MISC',      315, 'MISC', 'MISC'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'Mock-up',   320, 'Mock-up', 'Mock-up'), 
(uuid_v4(),  7, 'HULL_NUMBER', 'SSBN:SSGN', 325, 'SSBN:SSGN', 'SSBN:SSGN') 
;
$$

DELIMITER ;
