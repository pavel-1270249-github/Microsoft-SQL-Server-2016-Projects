USE CourseEnrollment
GO
--Insert Procedure Test with Values
--Insert Records on Tutors Table 
EXEC spInsertTutor 'Poul Samuel', 'poul13@gmail.com', '(01)99-57569'
EXEC spInsertTutor 'Poul Warner', 'warner25@gmail.com', '(01)99-57569'
EXEC spInsertTutor 'David Samuel', 'david221@gmail.com', '(01)99-57569'
EXEC spInsertTutor 'Poul Jhon', 'jhon99@gmail.com', '(01)99-57569'
EXEC spInsertTutor 'Jhon Mickle', 'mickle1444@gmail.com', '(01)99-57569'
GO
SELECT * FROM Tutors
GO
--Insert Records on Courses Table 
EXEC spInsertCourses 'SQL', 4, 5000.00, 3
EXEC spInsertCourses 'C#', 30, 10000.00, 1
EXEC spInsertCourses 'HTML CSS', 12, 7000.00, 2
EXEC spInsertCourses 'ASP.NET CORE', 20, 15000.00, 3
EXEC spInsertCourses 'PHOTOSHOP', 4, 4000.00, 2
GO
SELECT * FROM Courses
GO
--Insert Records on Students Table
EXEC spInsertStudent 'Mona', 'mona2222@gmail.com', '(99) 01-54734'
EXEC spInsertStudent 'Heron', 'heron27@gmail.com', '(99) 01-54904'
EXEC spInsertStudent 'Moana', 'moana2255@gmail.com', '(99) 01-50004'
EXEC spInsertStudent 'Rita', 'rita87@gmail.com', '(99) 01-58766'
EXEC spInsertStudent 'Sanu', 'sanu99887@gmail.com', '(99) 01-20734'
EXEC spInsertStudent 'Pol', 'pol2634@gmail.com', '(99) 01-30734'
GO
SELECT * FROM Students
GO
--Insert Records on Enrollments Table
EXEC spInsertEnrollment 1, 3, '2022-01-01','2022-01-01'
EXEC spInsertEnrollment 2, 3, '2022-02-01','2022-02-01'
EXEC spInsertEnrollment 3, 1, '2022-03-01','2022-03-01'
EXEC spInsertEnrollment 4, 1, '2022-04-01','2022-04-01'
EXEC spInsertEnrollment 5, 2, '2022-05-01','2022-05-01'
GO
SELECT * FROM Enrollments
GO

---- Test VIEWS
SELECT * FROM vCourseStudents
GO
SELECT * FROM vCourseWiseStudent
GO
SELECT * FROM vCourseSummaryByTutor
GO

--Test User-Defined Function
--1 Count Student
SELECT dbo.fnStudentCount(1)
GO
SELECT dbo.fnStudentCount(2)
GO
--2 Total Payment
SELECT dbo.fnTotalAmount (3)
GO
SELECT dbo.fnTotalAmount (2)
GO
SELECT dbo.fnTotalAmount (1)
GO
--3
SELECT * FROM fnCourseInfo (1)
GO
SELECT * FROM fnCourseInfo (2)
GO
SELECT * FROM fnCourseInfo (3)
GO
--4
SELECT * FROM fnCourseWiseStudent (1)
GO
SELECT * FROM fnCourseWiseStudent (2)
GO
SELECT * FROM fnCourseWiseStudent (3)
GO
---Test Triggers
--Insert Trigger on Enrollments Table
SELECT * FROM Enrollments
GO
EXEC trInsertEnrollment 6, 2, '2022-07-15', '2022-06-13'
GO
SELECT * FROM Enrollments
GO
EXEC trInsertEnrollment 5, 2, '2022-07-15', '2022-07-16'
GO 
----Delete Trigger on Enrollments Table
SELECT * FROM Enrollments
GO
EXEC trDeleteEnrollment 2, 3
GO
----
SELECT * FROM Enrollments
GO
EXEC trDeleteEnrollment 2, 5
GO
---------------------------
--- QUERIES
--1 RETRIVING DATA USING INNER JOIN QUERY
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Courses C
INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
INNER JOIN Students ST ON EN.StudentID=ST.StudentID
INNER JOIN Tutors T ON C.TutorID=T.TutorID
--2 FILTER USING INNER JOIN 1
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Courses C
INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
INNER JOIN Students ST ON EN.StudentID=ST.StudentID
INNER JOIN Tutors T ON C.TutorID=T.TutorID
WHERE C.CourseName= 'SQL'
GO
--3 FILTER USING INNER JOIN 2
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Courses C
INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
INNER JOIN Students ST ON EN.StudentID=ST.StudentID
INNER JOIN Tutors T ON C.TutorID=T.TutorID
WHERE C.CourseFee>3000
GO 
--4. RETRIVING DATA USING LEFT OUTER JOIN
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
GO 
--5. RETRIVING DATA USING CTE
WITH CTE AS
(
SELECT C.CourseID, C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone
FROM Tutors T
INNER JOIN Courses C ON C.TutorID=T.TutorID
)
SELECT CT.CourseName, CT.DurationInWeek, CT.CourseFee, CT.TutorName, CT.TutorMail, CT.TutorPhone
FROM CTE CT
LEFT OUTER JOIN Enrollments EN ON CT.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON ST.StudentID=EN.StudentID
GO
--6 RETRIVING NON MATCH USING OUTER JOIN 
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
WHERE EN.StudentID IS NULL
GO
--7  RETRIVING NON MATCH USING OUTER JOIN WITH SUBQUERY
SELECT C.CourseName, C.DurationInWeek, C.CourseFee, T.TutorName, T.TutorMail, T.TutorPhone, ST.StudentName, ST.StudentPhone, EN.EnrollDate, EN.PaymentDate
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
WHERE NOT (EN.StudentID IS NOT NULL AND EN.CourseID IN (SELECT CourseID FROM Courses))
GO
-- 8 RETRIVING DATA USING AGGREGATE FUNCTION 
SELECT C.CourseName, COUNT(ST.StudentID) 'TotalStudent'
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
GROUP BY C.CourseName
GO
-- 9 RETRIVING DATA USING AGGREGATE FUNCTION WITH HAVING CLAUSE
SELECT C.CourseName, COUNT(ST.StudentID) 'TotalStudent'
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
GROUP BY C.CourseName
HAVING C.CourseName = 'C#'
GO
--10 RANKING FUNCTION USING OVER CLAUSE
SELECT C.CourseName, ST.StudentID,
COUNT(ST.StudentID) OVER(ORDER BY C.CourseName) 'TotalStudent',
ROW_NUMBER() OVER(ORDER BY C.CourseName) 'RowCount',
RANK() OVER(ORDER BY C.CourseName) 'Rank',
DENSE_RANK() OVER(ORDER BY C.CourseName) 'DesneRank',
NTILE(3) OVER(ORDER BY C.CourseName) 'NTILE(3)'
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
GROUP BY C.CourseName, ST.StudentID
GO
--11 RETRIVING DATA USING CASE
SELECT 
CASE
	WHEN COUNT(ST.StudentID) <=0 THEN 'No Student'
	ELSE CAST(COUNT(ST.StudentID) AS VARCHAR)
	END 'TotalStudent'
FROM Tutors T
INNER JOIN Courses C ON T.TutorID=C.TutorID
LEFT OUTER JOIN Enrollments EN ON C.CourseID=EN.CourseID
LEFT OUTER JOIN Students ST ON EN.StudentID=ST.StudentID
GROUP BY C.CourseName
GO
