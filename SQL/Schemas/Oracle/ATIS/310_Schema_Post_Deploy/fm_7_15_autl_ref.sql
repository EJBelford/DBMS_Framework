
-- fm_7_15_autl_ref
-- ref
-- %FieldNm1%
-- %Value_1%

DELETE FROM fm_7_15_autl_ref;

-- Load records --

INSERT INTO fm_7_15_autl_ref (pub_type, pub_num, pub_date, art_chap, art_sect, art, art_title) 
          SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '0', '1.0', 'ART 1.0: THE MOVEMENT AND MANEUVER WARFIGHTING FUNCTION' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '1', '1.1', 'ART 1.1: Perform Tactical Actions Associated with Force Projection and Deployment' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '1', '1.1.1', 'ART 1.1.1 Conduct Mobilization of Tactical Units' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '1', '1.1.2', 'ART 1.1.2 Conduct Tactical Deployment and Redeployment Activities' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '1', '1.1.3', 'ART 1.1.3 Conduct Demobilization of Tactical Units' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '1', '1.1.4', 'ART 1.1.4 Conduct Rear Detachment Activities' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2', 'ART 1.2: Conduct Tactical Maneuver' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.1', 'ART 1.2.1 Conduct One of the Five Forms of Maneuver' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.2', 'ART 1.2.2 Employ Combat Formations' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.3', 'ART 1.2.3 Employ Combat Patrols' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.4', 'ART 1.2.4 Conduct Counterambush Actions' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.5', 'ART 1.2.5 Exploit Terrain to Expedite Tactical Movements' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.6', 'ART 1.2.6 Cross a Danger Area' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.7', 'ART 1.2.7 Link Up with Other Tactical Forces' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.8', 'ART 1.2.8 Conduct Passage of Lines' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.9', 'ART 1.2.9 Conduct a Relief in Place' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.10', 'ART 1.2.10 Navigate from One Point to Another' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.11', 'ART 1.2.11 Conduct a Survivability Move' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.12', 'ART 1.2.12 Conduct Sniper Active Countermeasures' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '2', '1.2.13', 'ART 1.2.13 Conduct Sniper Passive Countermeasures' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '3', '1.3', 'ART 1.3: Conduct Tactical Troop Movements' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '3', '1.3.1', 'ART 1.3.1 Prepare Forces for Movement' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '3', '1.3.2', 'ART 1.3.2 Conduct Tactical Road March' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '3', '1.3.3', 'ART 1.3.3 Conduct Tactical Convoy' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '1', '3', '1.3.4', 'ART 1.3.4 Conduct an Approach March' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '0', '7.0', 'ART 7.0: FULL SPECTRUM OPERATIONS, TACTICAL MISSION TASKS, AND OPERATIONAL THEMES' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '1', '7.1', 'ART 7.1: Conduct Offensive Operations' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '1', '7.1.1', 'ART 7.1.1 Conduct a Movement to Contact ' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '1', '7.1.2', 'ART 7.1.2 Conduct an Attack' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '1', '7.1.3', 'ART 7.1.3 Conduct an Exploitation' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '1', '7.1.4', 'ART 7.1.4 Conduct a Pursuit' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '2', '7.2', 'ART 7.2: Conduct Defensive Operations' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '2', '7.2.1', 'ART 7.2.1 Conduct a Mobile Defense' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '2', '7.2.2', 'ART 7.2.2 Conduct an Area Defense' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '2', '7.2.3', 'ART 7.2.3 Conduct a Retrograde' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3', 'ART 7.3: Conduct Stability Operations' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.1', 'ART 7.3.1 Establish Civil Security' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.2', 'ART 7.3.2 Establish Civil Control' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.3', 'ART 7.3.3 Restore Essential Services' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.4', 'ART 7.3.4 Support Governance' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.5', 'ART 7.3.5 Support Economic and Infrastructure Development' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '3', '7.3.6', 'ART 7.3.6 Conduct Security Force Assistance' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '4', '7.4', 'ART 7.4: Conduct Civil Support Operations' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '4', '7.4.1', 'ART 7.4.1 Provide Support in Response to Disaster or Terrorist Attack' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '4', '7.4.2', 'ART 7.4.2 Provide Support to Civil Law Enforcement' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '4', '7.4.3', 'ART 7.4.3 Provide Other Support as Required' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5', 'ART 7.5: Conduct Tactical Mission Tasks' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.1', 'ART 7.5.1 Attack by Fire an Enemy Force or Position' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.2', 'ART 7.5.2 Block an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.3', 'ART 7.5.3 Breach Enemy Defensive Positions' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.4', 'ART 7.5.4 Bypass Enemy Obstacles, Forces, or Positions' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.5', 'ART 7.5.5 Canalize Enemy Movement' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.6', 'ART 7.5.6 Clear Enemy Forces' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.7', 'ART 7.5.7 Conduct Counterreconnaissance' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.8', 'ART 7.5.8 Contain an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.9', 'ART 7.5.9 Control an Area' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.10', 'ART 7.5.10 Defeat an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.11', 'ART 7.5.11 Destroy a Designated Enemy Force or Position' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.12', 'ART 7.5.12 Disengage from a Designated Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.13', 'ART 7.5.13 Disrupt a Designated Enemy Force’s Formation, Tempo, or Timetable' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.14', 'ART 7.5.14 Conduct an Exfiltration' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.15', 'ART 7.5.15 Fix an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.16', 'ART 7.5.16 Follow and Assume the Missions of a Friendly Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.17', 'ART 7.5.17 Follow and Support the Actions of a Friendly Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.18', 'ART 7.5.18 Interdict an Area or Route to Prevent, Disrupt, or Delay Its Use by an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.19', 'ART 7.5.19 Isolate an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.20', 'ART 7.5.20 Neutralize an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.21', 'ART 7.5.21 Occupy an Area' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.22', 'ART 7.5.22 Reduce an Encircled or Bypassed Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.23', 'ART 7.5.23 Retain a Terrain Feature' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.24', 'ART 7.5.24 Secure a Unit, Facility, or Location' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.25', 'ART 7.5.25 Seize an Area' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.26', 'ART 7.5.26 Support by Fire the Maneuver of Another Friendly Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.27', 'ART 7.5.27 Suppress a Force or Weapon System' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.28', 'ART 7.5.28 Turn an Enemy Force' FROM DUAL 
UNION ALL SELECT 'FM', '7-15', 'FEBRUARY 2009', '7', '5', '7.5.29', 'ART 7.5.29 Conduct Soldier Surveillance and Reconnaissance' FROM DUAL ;

-- Test SELECT --

SELECT pub_type, pub_num, pub_date, art_chap, art_sect, art, art_title 
FROM fm_7_15_autl_ref
ORDER BY art;

