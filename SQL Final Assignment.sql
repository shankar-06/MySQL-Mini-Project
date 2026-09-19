-- Mini Project: Student Course Management System

CREATE DATABASE Student_Course_Management_System;
USE Student_Course_Management_System;

-- Step 1: Database Design (DDL)
-- Apply Primary Key, Foreign Key, and Constraints (NOT NULL, UNIQUE, CHECK).

-- Create the following tables: Students (student_id, name, dob, gender, email)
CREATE TABLE Students (
    student_id INT PRIMARY KEY,              
    name VARCHAR(30) NOT NULL,               
    dob DATE NOT NULL,
    gender VARCHAR(1) CHECK (gender IN ('M' , 'F')), 
    email VARCHAR(60) UNIQUE                 
);

-- Departments (dept_id, dept_name)
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL UNIQUE
);

-- Courses (course_id, course_name, credits, dept_id)
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(40) NOT NULL,
    credits INT CHECK (credits > 0 AND credits <= 5), 
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments (dept_id) 
);

-- Enrollments (enroll_id, student_id, course_id, semester, grade)
CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(25) NOT NULL,
    grade DECIMAL(3 , 1 ),
    CHECK (grade >= 0 AND grade <= 10.0),    
    FOREIGN KEY (student_id) REFERENCES Students (student_id), 
    FOREIGN KEY (course_id) REFERENCES Courses (course_id)     
);

-- Faculty (faculty_id, name, dept_id)
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments (dept_id)
);


-- Step 2: Data Population (DML)

-- Insert at least 10 students, 3 departments, 5 courses, and 15 enrollments.
INSERT INTO Students (student_id, name, dob, gender, email) VALUES 
(1, 'Alice Johnson', '2001-05-14', 'F', 'alice@edu.com'),
(2, 'Bob Smith', '1999-10-22', 'M', 'bob@edu.com'),
(3, 'Charlie Brown', '2002-01-15', 'M', 'charlie@edu.com'),
(4, 'Diana Prince', '2001-08-30', 'F', NULL), 
(5, 'Evan Wright', '2000-11-05', 'M', 'evan@edu.com'),
(6, 'Fiona Gallagher', '2003-02-18', 'F', 'fiona@edu.com'),
(7, 'George Miller', '1998-07-25', 'M', 'george@edu.com'),
(8, 'Hannah Abbott', '2001-12-10', 'F', 'hannah@edu.com'),
(9, 'Ian Malcolm', '1999-04-04', 'M', 'ian@edu.com'),
(10, 'Rachel Green', '2002-09-12', 'F', 'rachel@edu.com');

INSERT INTO Departments (dept_id, dept_name) VALUES 
(1, 'Computer Science'), (2, 'Mathematics'), (3, 'Physics');

INSERT INTO Courses (course_id, course_name, credits, dept_id) VALUES 
(101, 'Data Structures', 4, 1), 
(102, 'Algorithms', 4, 1), 
(201, 'Calculus I', 3, 2), 
(301, 'Quantum Mechanics', 4, 3), 
(103, 'Database Systems', 3, 1);

INSERT INTO Enrollments (enroll_id, student_id, course_id, semester, grade) VALUES 
(1, 1, 101, 'Fall 2023', 9.0), (2, 1, 102, 'Fall 2023', 8.5),
(3, 2, 201, 'Fall 2023', 7.0), (4, 3, 101, 'Fall 2023', NULL), 
(5, 4, 301, 'Fall 2023', 9.5), (6, 5, 103, 'Fall 2023', 8.0),
(7, 6, 101, 'Fall 2023', 7.5), (8, 7, 201, 'Fall 2023', 6.0),
(9, 8, 301, 'Fall 2023', 8.5), (10, 9, 102, 'Fall 2023', 9.0),
(11, 10, 103, 'Fall 2023', 8.0), (12, 1, 103, 'Spring 2024', 9.2),
(13, 2, 101, 'Spring 2024', 8.0), (14, 3, 102, 'Spring 2024', 7.5),
(15, 10, 101, 'Spring 2024', 6.5);

INSERT INTO Faculty (faculty_id, name, dept_id) VALUES 
(1, 'Dr. Alan Turing', 1), 
(2, 'Dr. Ada Lovelace', 1), 
(3, 'Dr. Isaac Newton', 2);

-- Update one student’s email.
UPDATE Students 
SET email = 'bobmainacc@gamil.com'
WHERE student_id = 2;

-- Delete one enrollment record.
DELETE FROM Enrollments 
WHERE enroll_id = 15;


-- Step 3: Projections & Filtering

-- Apply DISTINCT, alias, ORDER BY.
-- Select specific columns (e.g., student names and emails).
SELECT DISTINCT semester AS Academic_Semester, grade AS Possible_Grades_Per_Sem
FROM Enrollments
ORDER BY grade DESC; 

-- Use arithmetic operators (e.g., calculate GPA = SUM(grade*credits)/SUM(credits)).
SELECT e.student_id, SUM(e.grade*c.credits)/SUM(c.credits) AS Calculated_GPA
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL  
GROUP BY e.student_id;   


-- Step 4: Row Selection

-- Use WHERE with comparison operators (e.g., students born after 2000).
SELECT * FROM Students
WHERE YEAR(dob) > 2000;

-- Combine logical operators (AND, OR, NOT).
SELECT e.student_id
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade > 8.0 AND (c.dept_id = 1 OR c.dept_id = 2);


-- Step 5: Advanced Filtering

-- Find students enrolled in courses using IN.
SELECT * FROM Enrollments WHERE course_id IN(101, 102, 103);

-- Use LIKE to filter names starting with “R”.
SELECT * FROM Students
WHERE name LIKE 'r%';

-- Check for missing grades with IS NULL.
SELECT * FROM Enrollments
WHERE grade IS NULL;


-- Step 6: Aggregation & Grouping

-- Count students per department.
SELECT c.dept_id, COUNT(DISTINCT e.student_id) AS Counts_Per_Department
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.dept_id;

-- Find average grade per course.
SELECT c.course_name, AVG(e.grade) AS Avg_Grade_Per_Course
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- Use GROUP BY and filter with HAVING.
SELECT c.course_name, AVG(e.grade) AS Avg_Grade_Per_Course
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING AVG(e.grade) > 7.5;


-- Step 7: Combining Queries

-- Use UNION to combine student names from two departments.
SELECT s.name FROM Students s 
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id
WHERE c.dept_id = 1
UNION 
SELECT s.name FROM Students s 
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id
WHERE c.dept_id = 3;

-- Apply LIMIT to show top 5 students by GPA.
SELECT e.student_id, SUM(e.grade*c.credits)/SUM(c.credits) AS Calculated_GPA
FROM Enrollments e 
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
GROUP BY e.student_id
ORDER BY Calculated_GPA DESC
LIMIT 5;


-- Step 8: Conditional Expressions

-- Apply COALESCE to handle NULL emails.
-- Use CASE to categorize grades (A, B, C).
SELECT s.name, 
       COALESCE(s.email, 'No Email Registered') AS email_status,
       e.grade,
       CASE 
           WHEN e.grade >= 9.0 THEN 'A'
           WHEN e.grade >= 7.5 THEN 'B'
           WHEN e.grade >= 6.0 THEN 'C'
           ELSE 'F'
       END AS Grade_Letter
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id;


-- Step 9: Scalar Functions

-- Use string functions to uppercase student names.
-- Format student DOB using DATE_FORMAT.
-- Extract year of enrollment.
SELECT UPPER(s.name) AS Name_Upper, 
       DATE_FORMAT(s.dob, '%M %D %Y') AS Formatted_DOB,
       SUBSTRING(e.semester, -4) AS Enrollment_Year 
FROM Students s 
JOIN Enrollments e ON s.student_id = e.student_id;


-- Step 10-11: Joins

-- INNER JOIN students with enrollments.
SELECT s.name, e.semester, e.grade
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id;

-- LEFT JOIN courses with enrollments.
SELECT c.course_name, e.student_id
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id;

-- SELF JOIN faculty table to show mentorship relationships.
SELECT 
    mentee.name AS Junior_Faculty, 
    mentor.name AS Mentor
FROM Faculty mentee
JOIN Faculty mentor 
    ON mentee.dept_id = mentor.dept_id        
    AND mentee.faculty_id > mentor.faculty_id;
    

-- Step 12: Subqueries

-- Find students who scored above the average grade.
SELECT student_id, course_id, grade 
FROM Enrollments
WHERE grade > (SELECT AVG(grade) FROM Enrollments WHERE grade IS NOT NULL)
ORDER BY grade DESC;

-- Use correlated subquery to list students with multiple enrollments.
SELECT s.name 
FROM Students s
WHERE 1 < (SELECT COUNT(*) FROM Enrollments e WHERE s.student_id = e.student_id );

-- Apply EXISTS/NOT EXISTS to check if a student is enrolled in any course.
SELECT name 
FROM Students s
WHERE EXISTS (SELECT 1 FROM Enrollments e WHERE e.student_id = s.student_id);


-- Step 13-14: Window Functions

-- Use ROW_NUMBER to rank students by GPA.
SELECT student_id, course_id, grade,
       ROW_NUMBER() OVER(ORDER BY grade DESC) as gpa_rank
FROM Enrollments
WHERE grade IS NOT NULL;

-- Apply RANK and DENSE_RANK for grade distribution.
SELECT student_id, course_id, grade,
       RANK() OVER(PARTITION BY course_id ORDER BY grade DESC) AS grade_rank,
       DENSE_RANK() OVER(PARTITION BY course_id ORDER BY grade DESC) AS dense_grade_rank
FROM Enrollments
WHERE grade IS NOT NULL;

-- Use LEAD and LAG to compare semester grades.
SELECT student_id, semester, grade,
       LAG(grade) OVER(PARTITION BY student_id ORDER BY semester) AS prev_semester_grade,
       LEAD(grade) OVER(PARTITION BY student_id ORDER BY semester) AS next_semester_grade
FROM Enrollments;






