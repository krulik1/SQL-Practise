# SQL-Practise
This repository contains my solutions to database management lab exercises that I completed as part of my coursework.

Use PostgreSQL (PSQL or pgAdmin) or the database system of your choice to create a database MISCOMPANY that includes the following tables:

Table 1: Employees. Includes the first name, middle initial, and last name of every worker in the company, as well as their social insurance number, date of birth, address, gender, salary, and the number of the department with which they are associated.

Table 2: Departments. Indicates the name (Consumer Products, Industrial Products, and Research) and number of each department in the company, as well as the social insurance number and start date of the manager in each department.

Table 3: Projects. Includes the project name and number, the number of the department in charge of the project, and the location of the office working on the project.

Table 4: Locations. Lists the locations of all the offices of each department.  
#### ![alt text](https://github.com/Krulik00Jakub/SQL-Practise/blob/main/DatabaseLabTables.png?raw=true)

1. Create these MISCOMPANY tables in your home database.  
2. Use SQL queries to populate the tables with the specified data.  
3. It is preferable to use triggers to enforce an on updates cascade policy for foreign keys. In other words, if X is an attribute in Table 1 and a foreign key in Table 2 and Table 3, then any change to an X value in Table 1 will result in all X values equal to the old value being updated accordingly in Table 2 and Table 3. Write a trigger to handle this on updates cascade for your tables. Your solution should be simple and correct.  
4. The company administration has decided to change the research department number from “12” to “14”. Write an SQL query that performs this update. Your query should make use of your trigger (from 3) to ensure database integrity.  
5. Write an SQL statement to retrieve the number of people working in each of the departments responsible for mobile technology projects.  
6. Retrieve the department name and the number of female employees working for each department whose average salary is more than 27 000.  
7. To make strategic decisions, the president of the company needs summary data about the departments. For each department, the president must know the number of employees working on mobile technology projects and their total and average salaries. Does the following view answer the president’s request? If not, write the correct view that will satisfy the president’s request.
```SQL
CREATE VIEW DEPT_SUMMARY (D, C, TOTAL_S, AVERAGE_S)
AS SELECT DNO, COUNT (*), SUM (SALARY), AVG (SALARY)
  FROM EMPLOYEE, PROJECT
  WHERE DNO = DNUM and PNAME like 'Mobile%'
  GROUP BY DNO;
```
8. Which of the following queries and updates would be allowed by this view (from 7)? If a query or update is allowed, what would the corresponding query or update on the base relations look like? Give its result when applied to the database.
```SQL
-- Q1. 
SELECT * FROM DEPT_SUMMARY;

-- Q2.
SELECT D, C FROM DEPT_SUMMARY WHERE TOTAL_S > 100000;

-- Q3.
SELECT D, AVERAGE_S FROM DEPT_SUMMARY WHERE C > (SELECT C FROM DEPT_SUMMARY WHERE D=4);

-- Q4.
UPDATE DEPT_SUMMARY SET D=3 WHERE D=4;

-- Q5.
DELETE FROM DEPT_SUMMARY WHERE C > 4;
```
