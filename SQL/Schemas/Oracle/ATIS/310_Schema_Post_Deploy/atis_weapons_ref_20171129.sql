
DELETE FROM atis_weapons_ref;

-- Default record --

INSERT INTO atis_weapons_ref (weapon_id, model, model_name) 
VALUES ( 0, 'UNK', 'Unknown Weapon' ); 

-- Load records --

INSERT INTO atis_weapons_ref (weapon_id, model, model_name) 
          SELECT 1, 'M240B', 'Machine Gun, 7.62 mm' FROM DUAL 
UNION ALL SELECT 2, 'MK19', 'Machine Gun, 40 mm Grenade ' FROM DUAL 
UNION ALL SELECT 3, 'M2', 'Machine Gun, .50 Caliber, Heavy Barrel' FROM DUAL 
UNION ALL SELECT 4, 'M120', 'M120/M121 120mm Mortar System' FROM DUAL ;

-- Test SELECT --

SELECT weapon_id, model, model_name 
FROM atis_weapons_ref;

