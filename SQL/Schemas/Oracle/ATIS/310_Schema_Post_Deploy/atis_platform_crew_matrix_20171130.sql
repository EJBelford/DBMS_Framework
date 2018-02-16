
-- atis_platform_crew
-- matrix
-- %FieldNm1%
-- %Value1%

DELETE FROM atis_platform_crew_matrix;

-- Default record --

INSERT INTO atis_platform_crew_matrix (crew_id, person_id, uic, weapon_id, platform_id ) 
VALUES ( 0, 'UNK', 'Unknown Weapon' ); 

-- Load records --

INSERT INTO atis_platform_crew_matrix (crew_id, person_id, uic, weapon_id, platform_id) 
          SELECT 1, 40, 'WW21B0', 4, 7 FROM DUAL 
UNION ALL SELECT 1, 41, 'WW21B0', 4, 7 FROM DUAL 
UNION ALL SELECT 1, 42, 'WW21B0', 4, 7 FROM DUAL 
UNION ALL SELECT 1, 43, 'WW21B0', 4, 7 FROM DUAL ;

-- Test SELECT --

SELECT crew_id, person_id, uic, weapon_id, platform_id 
FROM atis_platform_crew_matrix;

