/**
 * Description: The purpose of this code is to practise writing basic SQL statements and using Triggers and PL/SQL to solve problems.
 * Author: Jakub Krulik
 * Date: 2023-01-16
 */

/* 
 * Create and populate Test Databases
 */



DROP TABLE IF EXISTS Employees CASCADE;

CREATE TABLE Employees(fname varchar(30), minit varchar(1), lname varchar(40), sin integer, bdate date, address varchar(50), gender char(1), salary money, dno integer);

INSERT INTO Employees(fname, minit, lname, sin, bdate, address, gender, salary, dno)

VALUES

('Harris', 'T', 'Chomsky', 123, '1975-12-10', 'Edmonton', 'M', 80000, 12),

('Kristian', 'C', 'Bohr', 456, '1985-10-05', 'Ottawa', 'N', 58000, 11),

('Charlotte', 'F', 'Bouchard', 789, '1995-08-06', 'Montreal', 'F', 70000, 11),

('Said', 'J', 'Ahmad', 111, '1980-09-07', 'Toronto', 'M', 60000, 12),

('Andrew', 'U', 'Brahe', 222, '1980-04-02', 'Winnipeg', 'M', 50000, 10),

('Nadia', 'O', 'Mamary', 333, '1970-01-08', 'Saskatoon', 'F', 65000, 10),

('Yuan', 'P', 'Nielsen', 987, '1993-02-27', 'Moncton', 'N', 62000, 11),

('Neil', 'A', 'Dion', 654, '1963-02-27', 'Moncton', 'M', 62000, 11),

('Karen', 'C', 'Ming', 321, '1973-11-16', 'Victoria', 'F', 56000, 12)

;



DROP TABLE IF EXISTS Departments CASCADE;

CREATE TABLE Departments(DNAME varchar(12), DNUMBER integer, MGRSIN integer, MGRSTARTDATE date);

INSERT INTO Departments (DNAME, DNUMBER, MGRSIN, MGRSTARTDATE)

VALUES

('ConsProd', 10, 333, '2014-10-01'),

('InduProd', 11, 654, '2015-05-01'),

('Research', 12, 111, '2010-06-15')

;



DROP TABLE IF EXISTS Projects CASCADE;

CREATE TABLE Projects(PNAME varchar(22), PNUMBER integer, PLOCATION varchar(10), DNUM integer);

INSERT INTO Projects (PNAME, PNUMBER, PLOCATION, DNUM)

VALUES

('Mobile Banking', 1, 'Ottawa', 10),

('Machine Learning', 2, 'Ottawa', 12),

('Computational Biology', 3, 'Athabasca', 11),

('Data Analytics', 4, 'Edmonton', 10),

('Educational Games', 5, 'Athabasca', 11)

;



DROP TABLE IF EXISTS Locations CASCADE;

CREATE TABLE Locations (DNBR integer, DLOCATION varchar(10));

INSERT INTO Locations (DNBR, DLOCATION)

VALUES

(10, 'Edmonton'),

(10, 'Ottawa'),

(11, 'Athabasca'),

(12, 'Ottawa'),

(12, 'Montreal')

;



ALTER TABLE Employees ADD CONSTRAINT epkey PRIMARY KEY (sin);

ALTER TABLE Departments ADD CONSTRAINT dpkey PRIMARY KEY (dnumber);

ALTER TABLE Projects ADD CONSTRAINT ppkey PRIMARY KEY (pnumber);



ALTER TABLE Employees ADD CONSTRAINT efkey FOREIGN KEY (dno) REFERENCES departments (dnumber) ON UPDATE CASCADE;

ALTER TABLE Departments ADD CONSTRAINT dfkey FOREIGN KEY (mgrsin) REFERENCES Employees (sin) ON UPDATE CASCADE;

ALTER TABLE Projects ADD CONSTRAINT pfkey FOREIGN KEY (dnum) REFERENCES departments (dnumber) ON UPDATE CASCADE;

ALTER TABLE Locations ADD CONSTRAINT lfkey FOREIGN KEY (dnbr) REFERENCES departments (dnumber) ON UPDATE CASCADE;





-- DDL commands to drop constraints

ALTER TABLE EMPLOYEES DROP CONSTRAINT EPKEY CASCADE;

ALTER TABLE DEPARTMENTS DROP CONSTRAINT DPKEY CASCADE;

ALTER TABLE PROJECTS DROP CONSTRAINT PPKEY CASCADE;

ALTER TABLE EMPLOYEES DROP CONSTRAINT EFKEY CASCADE;

ALTER TABLE DEPARTMENTS DROP CONSTRAINT DFKEY CASCADE;

ALTER TABLE PROJECTS DROP CONSTRAINT PFKEY CASCADE;

ALTER TABLE LOCATIONS DROP CONSTRAINT LFKEY CASCADE;



ALTER TABLE Employees ADD CONSTRAINT epkey PRIMARY KEY (sin);

ALTER TABLE Departments ADD CONSTRAINT dpkey PRIMARY KEY (dnumber);

ALTER TABLE Projects ADD CONSTRAINT ppkey PRIMARY KEY (pnumber);



ALTER TABLE Employees ADD CONSTRAINT efkey FOREIGN KEY (dno) REFERENCES departments (dnumber);

ALTER TABLE Departments ADD CONSTRAINT dfkey FOREIGN KEY (mgrsin) REFERENCES Employees (sin);

ALTER TABLE Projects ADD CONSTRAINT pfkey FOREIGN KEY (dnum) REFERENCES departments (dnumber);

ALTER TABLE Locations ADD CONSTRAINT lfkey FOREIGN KEY (dnbr) REFERENCES departments (dnumber);





/*
 * Enforce and on update cascade policy using triggers
 */



--TRIGGER FUNCTION FOR UPDATE OF SIN NUMBER

CREATE OR REPLACE FUNCTION UPSIN_FUNC()

    RETURNS TRIGGER

    LANGUAGE PLPGSQL

    AS $body$

    BEGIN

        UPDATE DEPARTMENTS SET MGRSIN = NEW.SIN

        WHERE MGRSIN = OLD.SIN;

        RETURN OLD;

    END;

    $body$;


DROP TRIGGER IF EXISTS UPSIN ON EMPLOYEES;

CREATE TRIGGER UPSIN

    AFTER UPDATE OF SIN ON EMPLOYEES

    FOR EACH ROW

    EXECUTE PROCEDURE UPSIN_FUNC();

    

-- TESTING CODE

UPDATE EMPLOYEES SET SIN = 0

    WHERE FNAME = 'Nadia';



UPDATE EMPLOYEES SET SIN = 333

    WHERE FNAME = 'Nadia';

    

-- TRIGGER FUNCTION FOR UPDATE OF DNO IN EMPLOYEES

CREATE OR REPLACE FUNCTION UPDNO_FUNC()

    RETURNS TRIGGER

    LANGUAGE PLPGSQL

    AS $body$

    BEGIN

        UPDATE EMPLOYEES SET DNO = NEW.DNUMBER

            WHERE DNO = OLD.DNUMBER;

        

        UPDATE PROJECTS SET DNUM = NEW.DNUMBER

            WHERE DNUM = OLD.DNUMBER;

        

        UPDATE LOCATIONS SET DNBR = NEW.DNUMBER 

            WHERE DNBR = OLD.DNUMBER;

        RETURN OLD;

    END;

    $body$;

    

DROP TRIGGER IF EXISTS UPDNO ON DEPARTMENTS;

CREATE TRIGGER UPDNO

    AFTER UPDATE OF DNUMBER ON DEPARTMENTS

    FOR EACH ROW

    EXECUTE PROCEDURE UPDNO_FUNC();



-- TESTING CODE

UPDATE DEPARTMENTS SET DNUMBER = 55

    WHERE DNAME = 'InduProd';



SELECT * FROM DEPARTMENTS;    

SELECT * FROM EMPLOYEES;

SELECT * FROM PROJECTS;

SELECT * FROM LOCATIONS;



SELECT DEPARTMENTS.DNUMBER, DEPARTMENTS.DNAME, EMPLOYEES.FNAME, EMPLOYEES.SIN, PROJECTS.PNUMBER, PROJECTS.PNAME, LOCATIONS.DLOCATION 

    FROM DEPARTMENTS

        INNER JOIN EMPLOYEES ON DNUMBER = EMPLOYEES.DNO

        INNER JOIN PROJECTS ON DNUMBER = PROJECTS.DNUM

        INNER JOIN LOCATIONS ON DNUMBER = DNBR

        WHERE DNUMBER = 55;



UPDATE DEPARTMENTS SET DNUMBER = 11

    WHERE DNAME = 'InduProd';

    

/*
 * Create a query to change the research department number to '14'
 */



UPDATE DEPARTMENTS SET DNUMBER = 14

    WHERE DNAME = 'Research';

    

-- TESTING CODE

SELECT * FROM DEPARTMENTS ORDER BY DNUMBER;

SELECT * FROM EMPLOYEES ORDER BY DNO;

SELECT * FROM PROJECTS ORDER BY DNUM;

SELECT * FROM LOCATIONS ORDER BY DNBR;
