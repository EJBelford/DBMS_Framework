SELECT	* 
FROM	PFSA_EQUIP_AVAIL

SELECT	* 
FROM	PFSA_SYS_EI 

SELECT 
DISTINCT	ea.sys_ei_niin, 
	sys.sys_ei_nomen, 
	sys.lin 
FROM	PFSA_EQUIP_AVAIL ea 
LEFT OUTER JOIN PFSA_SYS_EI sys ON ea.sys_ei_niin = sys.sys_ei_niin 
ORDER BY ea.sys_ei_niin

/*
010204216   HCPTE OBSN OH-58C                   H31110 
010350266   HCPTR UTILITY UH-60A                K32293 
010883669   HCPTR CGO TRANS CH47D               H30517 
011069519   HCPTR ADVANCED ATTACK               H28647 
011255476   AERIAL SCOUT HELICPT                A21633 
012823747   HELICPTR CARGO MH-47E               H46150
012984532   HELICPTR UTIL UH-60L                H32361 
013558250   HELIC ATTACK AH-64D                 H48918 
013853844   HELICOPTER FLGHT TRNG               H32611 
014926324   HELICOPTER UTILITY                  H32429 

009269488   DECON APPR M12A1 500G               F81880 
011538660   DECONTAMINATING APP                 D82404 
012060147   GEN ST SMOKE GN: M157               G51840 
012853012   GEN SET DED MEP 831                 G18358 
013285964   TANK CBT 120MM M1A2                 T13305 
013296826   LAUNCHER ROCKET ARM                 L44894 
013463122   DECON APPAR M17A3                   D82404 
013469317   TRK UTIL 10000 M1097                T07679 
013578502                                              
013801400   GENSMOKE MECH M56                   G58151 
013926191                                              
014067401   GEN SET SMK 120 GALS                G51840 
014138332   MECH SMOKE OBSCUR M58               G87229 
014172886   TRK LFT FK VAR RCH RT               T73347 
014321526   FIRE SPT TM VEH BFIST               F86571 
014360005   FIGHTING VEH INF M2A3               F60564 
014360007   FIGHT VEH CAL M3A3                  F90796 
014362309                                              
014386963                                              
014504243   LAUNCHER ROCKET ARM                 M82581 
014518250   RADIO SET AN/VRC-92F                R45543 
014734350   LAUNCHER ROCKET HIGH                H53326 
*/

SELECT	ea.sys_ei_niin, 
	ea.sys_ei_sn, 
	sys.sys_ei_nomen, 
	sys.lin, 
	ea.* 
FROM	PFSA_EQUIP_AVAIL ea 
LEFT OUTER JOIN PFSA_SYS_EI sys ON ea.sys_ei_niin = sys.sys_ei_niin 
WHERE	LIN = 'H30517' 
	AND from_dt > '01-SEP-2007'
ORDER BY from_dt DESC, ea.sys_ei_sn 

SELECT	* 
FROM	FORCE1A.D_UIC 
	
SELECT	a.uic, 
	u.long_unt_desc, 
	u.pres_loc, 
	a.nsn, 
	SUBSTR(a.nsn, 5, 9), 
	a.serial_num, 
	ea.sys_ei_niin, 
	ea.sys_ei_sn, 
	a.* 
FROM	WEBPROP.GCSSA_HR_ASSET a	
LEFT OUTER JOIN PFSA_EQUIP_AVAIL ea ON SUBSTR(a.nsn, 5, 9) = ea.sys_ei_niin 
	AND a.SERIAL_NUM = (SUBSTR(ea.sys_ei_sn, 1, 2) || '-' || SUBSTR(ea.sys_ei_sn, 3, 6))
	AND ea.from_dt > '01-SEP-2007'
LEFT OUTER JOIN FORCE1A.D_UIC u ON a.uic = u.uic 
WHERE	a.lin = 'H30517' OR a.lin = 'H46150' 
ORDER BY a.uic, a.serial_num
	