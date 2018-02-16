
DELETE FROM atis_platforms;


INSERT INTO atis_platforms (platform_id, platform_name, platform_short_name) 
          SELECT 1, 'Infantry Carrier Vehicle', 'ICV' FROM DUAL 
UNION ALL SELECT 2, 'Mobile Gun System', 'MGS' FROM DUAL 
UNION ALL SELECT 3, 'Reconnaissance Vehicle', 'RV' FROM DUAL 
UNION ALL SELECT 4, 'Command Vehicle', 'CV' FROM DUAL 
UNION ALL SELECT 5, 'Fire Support Vehicle', 'FSV' FROM DUAL 
UNION ALL SELECT 6, 'Medevac', 'MEDEVAC' FROM DUAL 
UNION ALL SELECT 7, 'Mortar Carrier Vehicle', 'MCV' FROM DUAL ;


SELECT platform_id, platform_name, platform_short_name FROM atis_platforms;
