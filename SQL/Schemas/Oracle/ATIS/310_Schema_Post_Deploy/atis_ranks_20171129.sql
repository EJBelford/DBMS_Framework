
DELETE FROM atis_ranks;

INSERT INTO atis_ranks (rank_id, pay_grade, rank_abbr, rank_desc, classification) 
          SELECT 1, 'O-10', 'GEN', 'General', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 2, 'O-9', 'LTG', 'Lieutenant General', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 3, 'O-8', 'MG', 'Major General', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 4, 'O-7', 'BG', 'Brigadier General', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 5, 'O-6', 'COL', 'Colonel', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 6, 'O-5', 'LTC', 'Lieuteant Colonel', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 7, 'O-4', 'MAJ', 'Major', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 8, 'O-3', 'CPT', 'Captain', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 9, 'O-2', '1LT', 'First Lieutenant', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 10, 'O-1', '2LT', 'Second Lieutenant', 'Comissioned Officer' FROM DUAL 
UNION ALL SELECT 11, 'W-5', 'CW5', 'Chief Warrant Officer 5', 'Warrant Officer' FROM DUAL 
UNION ALL SELECT 12, 'W-4', 'CW4', 'Chief Warrant Officer 4', 'Warrant Officer' FROM DUAL 
UNION ALL SELECT 13, 'W-3', 'CW3', 'Chief Warrant Officer 3', 'Warrant Officer' FROM DUAL 
UNION ALL SELECT 14, 'W-2', 'CW2', 'Chief Warrant Officer 2', 'Warrant Officer' FROM DUAL 
UNION ALL SELECT 15, 'W-1', 'CW1', 'Warrant Officer 1', 'Warrant Officer' FROM DUAL 
UNION ALL SELECT 16, 'E-9', 'SMA', 'Segreant Major of the Army', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 17, 'E-9', 'CSM', 'Command Segreant Major', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 18, 'E-9', 'SGM', 'Segreant Major', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 19, 'E-8', '1SG', 'First Segreant', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 20, 'E-8', 'MSG', 'Master Segreant', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 21, 'E-7', 'SFC', 'Segreant First Class', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 22, 'E-6', 'SSG', 'Staff Sergeant', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 23, 'E-5', 'SGT', 'Sergeant', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 24, 'E-4', 'CPL', 'Corporal', 'Noncomissioned Officer' FROM DUAL 
UNION ALL SELECT 25, 'E-4', 'SPC', 'Specialist', 'Enlisted Solider' FROM DUAL 
UNION ALL SELECT 26, 'E-3', 'PFC', 'Private First Class', 'Enlisted Solider' FROM DUAL 
UNION ALL SELECT 27, 'E-2', 'PV2', 'rpooral', 'Enlisted Solider' FROM DUAL 
UNION ALL SELECT 28, 'E-1', 'PVT', 'Private', 'Enlisted Solider' FROM DUAL 
UNION ALL SELECT 29, 'GS15', 'GS15', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 30, 'GS14', 'GS14', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 31, 'GS13', 'GS13', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 32, 'GS12', 'GS12', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 33, 'GS11', 'GS11', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 34, 'GS10', 'GS10', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 35, 'GS09', 'GS09', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 36, 'GS08', 'GS08', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 37, 'GS07', 'GS07', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 38, 'GS06', 'GS06', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 39, 'GS05', 'GS05', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 40, 'GS04', 'GS04', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 41, 'GS03', 'GS03', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 42, 'GS02', 'GS02', null, 'Government Civilian' FROM DUAL 
UNION ALL SELECT 43, 'GS01', 'GS01', null, 'Government Civilian' FROM DUAL ; 


SELECT rank_id, pay_grade, rank_abbr, rank_desc, classification FROM atis_ranks;

