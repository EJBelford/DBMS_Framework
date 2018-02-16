-- Table: omega.projectpriority
 
-- DROP TABLE omega.projectpriority;

CREATE TABLE omega.projectpriority
(
  enumvalues character varying NOT NULL,
  CONSTRAINT projectpriority_pkey PRIMARY KEY (enumvalues)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE omega.projectpriority
  OWNER TO omega;
COMMENT ON TABLE omega.projectpriority
  IS 'projectpriority - enumeration table - '; 

DELETE 
FROM omega.projectpriority;

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (0);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (1);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (2);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (3);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (4);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (5);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (6);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (7);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (8);

INSERT    
INTO omega.projectpriority (enumvalues)
VALUES (9);

SELECT enumvalues 
FROM omega.projectpriority
ORDER BY enumvalues; 


/*----------------------------*/
/*----------------------------*/


DELETE 
FROM omega.project; 

INSERT 
INTO omega.project(projectid, priority)
VALUES (1, '0');

INSERT 
INTO omega.project(projectid, priority)
VALUES (2, '-1');

INSERT 
INTO omega.project(projectid, priority)
VALUES (3, '99');

SELECT * 
FROM omega.project; 


/*----------------------------*/
/*----------------------------*/


ALTER TABLE omega.project
    ALTER priority SET DATA TYPE VARCHAR(255);

ALTER TABLE omega.project
    ALTER priority SET DATA TYPE SMALLINT USING CAST(priority AS SMALLINT);


/*----------------------------*/
/*----------------------------*/


SELECT enumvalues 
FROM omega.platformtype;

SELECT enumvalues
FROM omega.platformtype 
WHERE enumvalues LIKE '%Ship%';

SELECT enumvalues
FROM omega.platformtype 
WHERE LOWER(enumvalues) LIKE LOWER('%Sub%');


    