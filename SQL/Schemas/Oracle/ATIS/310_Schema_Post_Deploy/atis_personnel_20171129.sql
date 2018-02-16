
DELETE FROM atis_personnel_ref;

INSERT INTO atis_personnel_ref (person_id, lname, fname, middle_int, date_of_rank, rank_id, mos_p, mos_s, uic) 
          SELECT 1, 'Smith', 'Harry', 'P', TO_DATE('2014/11/21', 'yyyy/mm/dd'), 7, '11O', null, 'WW56HC' FROM DUAL 
UNION ALL SELECT 2, 'Rodriguez', 'Jose', 'J', TO_DATE('2016/09/15', 'yyyy/mm/dd'), 22, '11Z', null, 'WW21HC' FROM DUAL 
UNION ALL SELECT 3, 'Jones', 'Michael', 'A', TO_DATE('2016/06/17', 'yyyy/mm/dd'), 21, '11Z', null, 'WW21A0' FROM DUAL 
UNION ALL SELECT 4, 'Shank', 'Jesse', 'O', TO_DATE('2017/06/15', 'yyyy/mm/dd'), 21, '11Z', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 5, 'Morgan', 'John', 'K', TO_DATE('2017/07/15', 'yyyy/mm/dd'), 23, '11B', null, 'WW21C0' FROM DUAL 
UNION ALL SELECT 6, 'Applegate', 'Art', null, TO_DATE('2017/07/08', 'yyyy/mm/dd'), 10, '11O', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 7, 'Berry', 'Bill', null, TO_DATE('2017/07/01', 'yyyy/mm/dd'), 21, '11Z', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 8, 'Coyle', 'Chuck', null, TO_DATE('2017/06/24', 'yyyy/mm/dd'), 25, '25B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 9, 'Davis', 'James', null, TO_DATE('2017/06/17', 'yyyy/mm/dd'), 25, '13F', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 10, 'Edwards', 'John', null, TO_DATE('2017/06/10', 'yyyy/mm/dd'), 25, '25B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 11, 'Fox', 'Robert', null, TO_DATE('2017/06/03', 'yyyy/mm/dd'), 25, '68W', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 12, 'George', 'Michael', null, TO_DATE('2017/05/27', 'yyyy/mm/dd'), 23, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 13, 'Hill', 'William', null, TO_DATE('2017/05/20', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 14, 'India', 'David', null, TO_DATE('2017/05/13', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 15, 'Jones', 'Richard', null, TO_DATE('2017/05/06', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 16, 'Lewis', 'Joseph', null, TO_DATE('2017/04/29', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 17, 'Marks', 'Charles', null, TO_DATE('2017/04/22', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 18, 'Nettles', 'Chris', null, TO_DATE('2017/04/15', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 19, 'Oscar', 'Daniel', null, TO_DATE('2017/04/08', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 20, 'Paul', 'Matthew', null, TO_DATE('2017/04/01', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 21, 'Queen', 'Anthony', null, TO_DATE('2017/03/25', 'yyyy/mm/dd'), 23, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 22, 'Rogers', 'Donald', null, TO_DATE('2017/03/18', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 23, 'Smith', 'Matthew', null, TO_DATE('2017/03/11', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 24, 'Thomas', 'Mark', null, TO_DATE('2017/03/04', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 25, 'Uncle', 'Paul', null, TO_DATE('2017/02/25', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 26, 'Vicroy', 'Steven', null, TO_DATE('2017/02/18', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 27, 'Watts', 'Andrew', null, TO_DATE('2017/02/11', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 28, 'Young', 'Edward', null, TO_DATE('2017/02/04', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 29, 'Adams', 'Ronald', null, TO_DATE('2017/01/28', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 30, 'Billings', 'Tim', null, TO_DATE('2017/01/21', 'yyyy/mm/dd'), 23, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 31, 'Carol', 'Jason', null, TO_DATE('2017/01/14', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 32, 'Duke', 'Jeff', null, TO_DATE('2017/01/07', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 33, 'Egan', 'Ryan', null, TO_DATE('2016/12/31', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 34, 'Franks', 'Gary', null, TO_DATE('2016/12/24', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 35, 'Gulf', 'Jacob', null, TO_DATE('2016/12/17', 'yyyy/mm/dd'), 24, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 36, 'House', 'Nicholas', null, TO_DATE('2016/12/10', 'yyyy/mm/dd'), 25, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 37, 'Ink', 'Eric', null, TO_DATE('2016/12/03', 'yyyy/mm/dd'), 26, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 38, 'Jacobs', 'Steve', null, TO_DATE('2016/11/26', 'yyyy/mm/dd'), 27, '11B', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 39, 'Leeds', 'Larry', null, TO_DATE('2016/11/19', 'yyyy/mm/dd'), 22, '11Z', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 40, 'Meade', 'Justin', null, TO_DATE('2016/11/12', 'yyyy/mm/dd'), 23, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 41, 'Nickles', 'Scott', null, TO_DATE('2016/11/05', 'yyyy/mm/dd'), 24, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 42, 'Orr', 'Frank', null, TO_DATE('2016/10/29', 'yyyy/mm/dd'), 25, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 43, 'Peters', 'Raymond', null, TO_DATE('2016/10/22', 'yyyy/mm/dd'), 26, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 44, 'Right', 'Jack', null, TO_DATE('2016/10/15', 'yyyy/mm/dd'), 27, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 45, 'Swede', 'Dennis', null, TO_DATE('2016/10/08', 'yyyy/mm/dd'), 24, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 46, 'Tonka', 'Jose', null, TO_DATE('2016/10/01', 'yyyy/mm/dd'), 24, '11C', null, 'WW21B0' FROM DUAL 
UNION ALL SELECT 47, 'Williams', 'Peter', null, TO_DATE('2016/09/24', 'yyyy/mm/dd'), 24, '11C', null, 'WW21B0' FROM DUAL ; 


SELECT person_id, lname, fname, middle_int, 
  date_of_rank, rank_id, 
  mos_p, mos_s, uic 
FROM atis_personnel_ref;

