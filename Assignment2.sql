-- COMP 8157 | Advanced Database Topics
-- Assignment 2: Advanced SQL for Data Analysis and Visualization
-- Student: Dipesh Raj Joshi

-- PART 1: DATABASE CREATION


-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ADTAssignment2')
BEGIN
    CREATE DATABASE ADTAssignment2;
END
GO

-- Use the database
USE ADTAssignment2;
GO


-- PART 2: TABLE CREATION (DATABASE SCHEMA)


-- Drop tables if they exist (for re-running the script)
IF OBJECT_ID('courseSiteVisit', 'U') IS NOT NULL DROP TABLE courseSiteVisit;
IF OBJECT_ID('users', 'U') IS NOT NULL DROP TABLE users;
IF OBJECT_ID('depCourse', 'U') IS NOT NULL DROP TABLE depCourse;
IF OBJECT_ID('program', 'U') IS NOT NULL DROP TABLE program;
GO

-- Table 1: program
-- Stores information about academic programs
CREATE TABLE program (
    programID INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL
);
GO

-- Table 2: depCourse
-- Stores courses offered by different departments in various programs
CREATE TABLE depCourse (
    courseID INT PRIMARY KEY IDENTITY(1,1),
    deptName VARCHAR(100) NOT NULL,
    programID INT,
    FOREIGN KEY (programID) REFERENCES program(programID)
);
GO

-- Table 3: users
-- Stores user/student information enrolled in programs
CREATE TABLE users (
    userID INT PRIMARY KEY IDENTITY(1,1),
    programID INT,
    FOREIGN KEY (programID) REFERENCES program(programID)
);
GO

-- Table 4: courseSiteVisit
-- Tracks when users visit course sites
CREATE TABLE courseSiteVisit (
    visitID INT PRIMARY KEY IDENTITY(1,1),
    courseID INT,
    userID INT,
    date DATE NOT NULL,
    FOREIGN KEY (courseID) REFERENCES depCourse(courseID),
    FOREIGN KEY (userID) REFERENCES users(userID)
);
GO


-- PART 3: DATA POPULATION


-- Insert Programs (Requirement: at least 2 programs)
INSERT INTO program (name) VALUES 
('Undergraduate'),
('Master');
GO

-- Insert Courses (Requirement: at least 2 courses per program per department)
-- Computer Science Department - Undergraduate Program
INSERT INTO depCourse (deptName, programID) VALUES 
('Computer Science', 1),  -- CS Undergrad Course 1
('Computer Science', 1);  -- CS Undergrad Course 2

-- Computer Science Department - Master Program
INSERT INTO depCourse (deptName, programID) VALUES 
('Computer Science', 2),  -- CS Master Course 1
('Computer Science', 2);  -- CS Master Course 2

-- Mathematics Department - Undergraduate Program
INSERT INTO depCourse (deptName, programID) VALUES 
('Mathematics', 1),       -- Math Undergrad Course 1
('Mathematics', 1);       -- Math Undergrad Course 2

-- Mathematics Department - Master Program
INSERT INTO depCourse (deptName, programID) VALUES 
('Mathematics', 2),       -- Math Master Course 1
('Mathematics', 2);       -- Math Master Course 2
GO

-- Insert Users (Requirement: at least 3 users per program)
-- Undergraduate users (5 users)
INSERT INTO users (programID) VALUES 
(1), (1), (1), (1), (1);

-- Master users (4 users)
INSERT INTO users (programID) VALUES 
(2), (2), (2), (2);
GO

-- Insert courseSiteVisit records
-- Requirements:
-- i. At least 2 users visited all courses
-- ii. All users visited at least 1 course
-- iii. Each user visited at least 1 course multiple times on same date
-- iv. Each user visited multiple dates per single course
-- Total: 100+ records

-- User 1 visits all courses (multiple times, multiple dates)
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 1, '2024-10-01'), (1, 1, '2024-10-01'), (1, 1, '2024-10-02'), (1, 1, '2024-10-03'),
(2, 1, '2024-10-01'), (2, 1, '2024-10-02'), (2, 1, '2024-10-05'),
(3, 1, '2024-10-03'), (3, 1, '2024-10-03'), (3, 1, '2024-10-04'),
(4, 1, '2024-10-04'), (4, 1, '2024-10-06'),
(5, 1, '2024-10-05'), (5, 1, '2024-10-07'),
(6, 1, '2024-10-06'), (6, 1, '2024-10-08'),
(7, 1, '2024-10-07'), (7, 1, '2024-10-09'),
(8, 1, '2024-10-08'), (8, 1, '2024-10-10');

-- User 2 visits all courses (multiple times, multiple dates)
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 2, '2024-10-02'), (1, 2, '2024-10-03'), (1, 2, '2024-10-04'),
(2, 2, '2024-10-02'), (2, 2, '2024-10-02'), (2, 2, '2024-10-05'),
(3, 2, '2024-10-03'), (3, 2, '2024-10-06'),
(4, 2, '2024-10-04'), (4, 2, '2024-10-04'), (4, 2, '2024-10-07'),
(5, 2, '2024-10-05'), (5, 2, '2024-10-08'),
(6, 2, '2024-10-06'), (6, 2, '2024-10-09'),
(7, 2, '2024-10-07'), (7, 2, '2024-10-10'),
(8, 2, '2024-10-08'), (8, 2, '2024-10-08'), (8, 2, '2024-10-11');

-- User 3 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 3, '2024-10-01'), (1, 3, '2024-10-01'), (1, 3, '2024-10-03'),
(2, 3, '2024-10-02'), (2, 3, '2024-10-04'),
(3, 3, '2024-10-03'), (3, 3, '2024-10-03'), (3, 3, '2024-10-05');

-- User 4 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 4, '2024-10-02'), (1, 4, '2024-10-04'),
(4, 4, '2024-10-03'), (4, 4, '2024-10-03'), (4, 4, '2024-10-05'),
(5, 4, '2024-10-04'), (5, 4, '2024-10-06');

-- User 5 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(2, 5, '2024-10-01'), (2, 5, '2024-10-01'), (2, 5, '2024-10-03'),
(6, 5, '2024-10-02'), (6, 5, '2024-10-04'),
(7, 5, '2024-10-03'), (7, 5, '2024-10-05');

-- User 6 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(3, 6, '2024-10-01'), (3, 6, '2024-10-03'),
(4, 6, '2024-10-02'), (4, 6, '2024-10-02'), (4, 6, '2024-10-04'),
(8, 6, '2024-10-03'), (8, 6, '2024-10-05');

-- User 7 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(5, 7, '2024-10-01'), (5, 7, '2024-10-01'), (5, 7, '2024-10-03'),
(6, 7, '2024-10-02'), (6, 7, '2024-10-04'),
(7, 7, '2024-10-03'), (7, 7, '2024-10-05');

-- User 8 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 8, '2024-10-01'), (1, 8, '2024-10-03'),
(2, 8, '2024-10-02'), (2, 8, '2024-10-02'), (2, 8, '2024-10-04'),
(8, 8, '2024-10-03'), (8, 8, '2024-10-05');

-- User 9 visits some courses
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(3, 9, '2024-10-01'), (3, 9, '2024-10-01'), (3, 9, '2024-10-03'),
(4, 9, '2024-10-02'), (4, 9, '2024-10-04'),
(5, 9, '2024-10-03'), (5, 9, '2024-10-05');

-- Additional visits to reach 100+ records
INSERT INTO courseSiteVisit (courseID, userID, date) VALUES
(1, 1, '2024-10-11'), (2, 1, '2024-10-12'), (3, 1, '2024-10-13'),
(1, 2, '2024-10-14'), (2, 2, '2024-10-15'), (3, 2, '2024-10-16'),
(1, 3, '2024-10-17'), (2, 3, '2024-10-18'), (3, 3, '2024-10-19'),
(4, 4, '2024-10-20'), (5, 4, '2024-10-21'), (6, 5, '2024-10-22');
GO

-- Verify data population
PRINT 'Data Population Summary:';
SELECT 'Programs' AS TableName, COUNT(*) AS RecordCount FROM program
UNION ALL
SELECT 'Courses', COUNT(*) FROM depCourse
UNION ALL
SELECT 'Users', COUNT(*) FROM users
UNION ALL
SELECT 'Site Visits', COUNT(*) FROM courseSiteVisit;
GO


-- PART 4: DATA ANALYSIS QUERIES


PRINT '';
PRINT '=================================================================';
PRINT 'QUERY A: Total number of times a course has been visited';
PRINT '=================================================================';
-- Purpose: Shows the overall popularity of each course across all users
SELECT 
    c.courseID,
    c.deptName,
    p.name AS programName,
    COUNT(*) AS TotalVisits
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY c.courseID, c.deptName, p.name
ORDER BY TotalVisits DESC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY B: Total visits for each course, categorized by program';
PRINT '=================================================================';
-- Purpose: Compares course engagement between Undergraduate and Master programs
SELECT 
    p.name AS ProgramName,
    c.courseID,
    c.deptName,
    COUNT(*) AS TotalVisits
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY p.name, c.courseID, c.deptName
ORDER BY p.name, TotalVisits DESC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY C: Total number of users enrolled in each program';
PRINT '=================================================================';
-- Purpose: Shows the distribution of students across programs
SELECT 
    p.programID,
    p.name AS ProgramName,
    COUNT(u.userID) AS TotalUsers
FROM program p
LEFT JOIN users u ON p.programID = u.programID
GROUP BY p.programID, p.name
ORDER BY p.programID;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY D: Total unique visitors per department by program';
PRINT '=================================================================';
-- Purpose: Identifies how many distinct users engaged with each department
SELECT 
    c.deptName,
    p.name AS ProgramName,
    COUNT(DISTINCT csv.userID) AS UniqueVisitors
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY c.deptName, p.name
ORDER BY c.deptName, p.name;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY E: Most recent date user visited each course';
PRINT '=================================================================';
-- Purpose: Shows the last engagement date for each user-course combination
SELECT 
    csv.userID,
    csv.courseID,
    c.deptName,
    MAX(csv.date) AS LastVisitDate
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
GROUP BY csv.userID, csv.courseID, c.deptName
ORDER BY csv.userID, csv.courseID;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY F: Number of times a user visited each course';
PRINT '=================================================================';
-- Purpose: Identifies individual user engagement patterns per course
SELECT 
    csv.userID,
    csv.courseID,
    c.deptName,
    p.name AS ProgramName,
    COUNT(*) AS VisitCount
FROM courseSiteVisit csv
JOIN depCourse c ON csv.courseID = c.courseID
JOIN program p ON c.programID = p.programID
GROUP BY csv.userID, csv.courseID, c.deptName, p.name
ORDER BY csv.userID, VisitCount DESC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY G: Most frequent visitor per course';
PRINT '=================================================================';
-- Purpose: Identifies the most engaged user for each course
WITH CourseVisitCounts AS (
    SELECT 
        courseID,
        userID,
        COUNT(*) AS VisitCount,
        ROW_NUMBER() OVER (PARTITION BY courseID ORDER BY COUNT(*) DESC) AS rn
    FROM courseSiteVisit
    GROUP BY courseID, userID
)
SELECT 
    cvc.courseID,
    c.deptName,
    cvc.userID,
    cvc.VisitCount AS MaxVisits
FROM CourseVisitCounts cvc
JOIN depCourse c ON cvc.courseID = c.courseID
WHERE cvc.rn = 1
ORDER BY cvc.courseID;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY H: User who visited a course most times in single day';
PRINT '=================================================================';
-- Purpose: Finds the highest daily engagement per course
WITH DailyVisitCounts AS (
    SELECT 
        courseID,
        userID,
        date,
        COUNT(*) AS VisitsInDay,
        ROW_NUMBER() OVER (PARTITION BY courseID ORDER BY COUNT(*) DESC) AS rn
    FROM courseSiteVisit
    GROUP BY courseID, userID, date
)
SELECT 
    dvc.courseID,
    c.deptName,
    dvc.userID,
    dvc.date,
    dvc.VisitsInDay AS MaxVisitsInSingleDay
FROM DailyVisitCounts dvc
JOIN depCourse c ON dvc.courseID = c.courseID
WHERE dvc.rn = 1
ORDER BY dvc.courseID;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY I: Longest visit streak days per user per course';
PRINT '=================================================================';
-- Purpose: Identifies consecutive day engagement patterns
WITH VisitDates AS (
    SELECT DISTINCT 
        userID, 
        courseID, 
        date,
        DATEDIFF(day, date, LAG(date) OVER (PARTITION BY userID, courseID ORDER BY date)) AS dayDiff
    FROM courseSiteVisit
),
Streaks AS (
    SELECT 
        userID,
        courseID,
        date,
        CASE 
            WHEN dayDiff = -1 OR dayDiff IS NULL THEN 0 
            ELSE 1 
        END AS isNewStreak,
        SUM(CASE WHEN dayDiff = -1 OR dayDiff IS NULL THEN 0 ELSE 1 END) 
            OVER (PARTITION BY userID, courseID ORDER BY date) AS streakGroup
    FROM VisitDates
),
StreakLengths AS (
    SELECT 
        userID,
        courseID,
        streakGroup,
        COUNT(*) AS streakLength
    FROM Streaks
    GROUP BY userID, courseID, streakGroup
)
SELECT 
    sl.userID,
    sl.courseID,
    c.deptName,
    MAX(sl.streakLength) AS LongestStreak
FROM StreakLengths sl
JOIN depCourse c ON sl.courseID = c.courseID
GROUP BY sl.userID, sl.courseID, c.deptName
ORDER BY LongestStreak DESC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY J: Longest gap between visits per user per course';
PRINT '=================================================================';
-- Purpose: Identifies periods of inactivity in course engagement
WITH VisitGaps AS (
    SELECT 
        userID,
        courseID,
        date,
        LEAD(date) OVER (PARTITION BY userID, courseID ORDER BY date) AS nextVisitDate,
        DATEDIFF(day, date, LEAD(date) OVER (PARTITION BY userID, courseID ORDER BY date)) AS gapDays
    FROM (
        SELECT DISTINCT userID, courseID, date 
        FROM courseSiteVisit
    ) AS distinctVisits
)
SELECT 
    vg.userID,
    vg.courseID,
    c.deptName,
    MAX(vg.gapDays) AS LongestGapDays
FROM VisitGaps vg
JOIN depCourse c ON vg.courseID = c.courseID
WHERE vg.gapDays IS NOT NULL
GROUP BY vg.userID, vg.courseID, c.deptName
ORDER BY LongestGapDays DESC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'QUERY K: User who visited most courses in short duration';
PRINT '=================================================================';
-- Purpose: Identifies users with intensive multi-course engagement
WITH UserCourseDates AS (
    SELECT DISTINCT 
        userID,
        courseID,
        date
    FROM courseSiteVisit
),
WindowVisits AS (
    SELECT 
        userID,
        date,
        COUNT(DISTINCT courseID) AS coursesVisited,
        MIN(date) AS windowStart,
        MAX(date) AS windowEnd
    FROM UserCourseDates
    GROUP BY userID, date
),
ThreeDayWindow AS (
    SELECT 
        w1.userID,
        w1.date AS startDate,
        COUNT(DISTINCT w2.courseID) AS totalCourses,
        DATEDIFF(day, w1.date, MAX(w2.date)) AS duration
    FROM WindowVisits w1
    CROSS APPLY (
        SELECT courseID, date
        FROM UserCourseDates w2
        WHERE w2.userID = w1.userID 
        AND w2.date BETWEEN w1.date AND DATEADD(day, 3, w1.date)
    ) w2
    GROUP BY w1.userID, w1.date
)
SELECT TOP 10
    userID,
    startDate,
    DATEADD(day, duration, startDate) AS endDate,
    totalCourses,
    duration AS DurationInDays
FROM ThreeDayWindow
ORDER BY totalCourses DESC, duration ASC;
GO

PRINT '';
PRINT '=================================================================';
PRINT 'ALL QUERIES COMPLETED SUCCESSFULLY!';
PRINT '=================================================================';