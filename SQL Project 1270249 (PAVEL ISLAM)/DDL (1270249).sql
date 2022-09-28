/*
			IsDB-BISEW 
	IT SCHOLARSHIP PROGRAMME
			ROUND-52
	Trainee ID	: 1270249
	Name		: Md. Pavel Islam
	Batch		: CS/ACSL-M/52/01
	
*/
------------------------------
--DETABASE CREATION
CREATE DATABASE CourseEnrollment
GO

USE CourseEnrollment
GO
------------------------------
--CREATE TABLES ON DATABASE
CREATE TABLE Tutors
(
	TutorID INT IDENTITY PRIMARY KEY,
	TutorName NVARCHAR(30) NOT NULL,
	TutorMail NVARCHAR (30) NOT NULL,
	TutorPhone NVARCHAR (25) NOT NULL
)
GO
CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY,
	StudentName NVARCHAR (30) NOT NULL,
	StudentMail NVARCHAR (30) NOT NULL,
	StudentPhone NVARCHAR (25) NOT NULL
)
GO
CREATE TABLE Courses
(
	CourseID INT IDENTITY PRIMARY KEY,
	CourseName NVARCHAR (30) NOT NULL,
	DurationInWeek INT NOT NULL,
	CourseFee MONEY NOT NULL,
	TutorID INT NOT NULL REFERENCES Tutors (TutorID)
)
GO
CREATE TABLE Enrollments
(
	StudentID INT NOT NULL REFERENCES Students (StudentID),
	CourseID INT NOT NULL REFERENCES Courses (CourseID),
	EnrollDate DATE NOT NULL,
	PaymentDate DATE NULL,
	PRIMARY KEY (StudentID,CourseID)
)
GO
-----------------------
--Create Insert Procedures

--Create Insert Procedures for Tutors Table
CREATE PROC spInsertTutor @TN NVARCHAR(30), @TM NVARCHAR (30), @TP NVARCHAR(25)
AS
BEGIN TRY
	INSERT INTO Tutors VALUES (@TN, @TM, @TP)
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Insert Procedures for Courses Table
CREATE PROC spInsertCourses @CN NVARCHAR (30), @DW INT, @CF MONEY, @TID INT
AS
BEGIN TRY
	INSERT INTO Courses VALUES (@CN, @DW, @CF, @TID)
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Insert Procedures for Students Table
CREATE PROC spInsertStudent @SN NVARCHAR(30), @SM NVARCHAR (30), @SP NVARCHAR(25)
AS
BEGIN TRY
	INSERT INTO Students VALUES (@SN, @SM, @SP)
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Insert Procedures for Enrollments Table
CREATE PROCEDURE spInsertEnrollment @SID INT, @CID INT, @ED DATE, @PD DATE = NULL
AS
BEGIN TRY
	INSERT INTO Enrollments VALUES (@SID, @CID, @ED, @PD)
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Update Procedures

--Create Update Procedures for Tutors Table
CREATE PROC spUpdateTutor @TID INT, @TN NVARCHAR(30), @TM NVARCHAR (30), @TP NVARCHAR(25)
AS
BEGIN TRY
	UPDATE Tutors 
	SET TutorName=@TN, TutorMail=@TM, TutorPhone=@TP
	WHERE TutorID=@TID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Update Procedures for Courses Table
CREATE PROC spUpdateCourses @CID INT, @CN NVARCHAR (30), @DW INT, @CF MONEY, @TID INT
AS
BEGIN TRY
	UPDATE Courses 
	SET CourseName=@CN, DurationInWeek=@DW, CourseFee=@CF, TutorID=@TID
	WHERE CourseID=@CID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Update Procedures for Students Table
CREATE PROC spUpdateStudent @SID INT, @SN NVARCHAR(30), @SM NVARCHAR (30), @SP NVARCHAR(25)
AS
BEGIN TRY
	UPDATE Students 
	SET StudentName=@SN, StudentMail=@SM, StudentPhone=@SP
	WHERE StudentID = @SID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
--Create Update Procedures for Enrollments Table
CREATE PROCEDURE spUpdateEnrollment @SID INT, @CID INT, @ED DATE, @PD DATE = NULL
AS
BEGIN TRY
	UPDATE Enrollments 
	SET EnrollDate=@ED, PaymentDate=@PD
	WHERE StudentID = @SID AND CourseID = @CID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
END CATCH
GO
----Create Delete Procedures for Tutors Table
CREATE PROC spDeleteTutor @TID INT
AS
BEGIN TRY
	DELETE Tutors WHERE TutorID=@TID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
	;
	THROW 50001, @M, 1
END CATCH
GO
----Create Delete Procedures for Courses Table
CREATE PROC spDeleteCourse @CID INT
AS
BEGIN TRY
	DELETE Courses WHERE CourseID=@CID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
	;
	THROW 50001, @M, 1
END CATCH
GO
----Create Delete Procedures for Students Table
CREATE PROC spDeleteStudent @SID INT
AS
BEGIN TRY
	DELETE Students WHERE StudentID=@SID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
	;
	THROW 50001, @M, 1
END CATCH
GO
----Create Delete Procedures for Enrollments Table
CREATE PROC spDeleteEnrollment @SID INT, @CID INT
AS
BEGIN TRY
	DELETE Enrollments WHERE StudentID=@SID AND CourseID=@CID
END TRY
BEGIN CATCH
	DECLARE @M VARCHAR (250)
	SELECT @M = ERROR_MESSAGE()
	RAISERROR (@M, 16, 1)
	;
	THROW 50001, @M, 1
END CATCH
GO
--Create Views

--Create Views to Retrive All Data Using JOIN
CREATE VIEW vCourseStudents
AS
SELECT C.CourseName, T.TutorName, C.DurationInWeek, C.CourseFee, ST.StudentName, EN.EnrollDate, EN.PaymentDate
FROM Courses C
INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
INNER JOIN Students ST ON EN.StudentID=ST.StudentID
INNER JOIN Tutors T ON T.TutorID=C.TutorID
GO

--Create Views to Retrive Course-Wise Student Data Using Aggregate Function
CREATE VIEW vCourseWiseStudent
AS
SELECT C.CourseName, COUNT(ST.StudentID) 'StudentCount',  SUM(C.CourseFee) 'TotalFee'
FROM Courses C
INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
INNER JOIN Students ST ON EN.StudentID=ST.StudentID
INNER JOIN Tutors T ON T.TutorID=C.TutorID
GROUP BY C.CourseName
GO

--Create Views to Retrive Course-Summary by Tutor Data Using Aggregate Function
CREATE VIEW vCourseSummaryByTutor
AS
SELECT T.TutorName, COUNT(C.CourseID) 'CourseCount'
FROM Courses C
INNER JOIN Tutors T ON T.TutorID=C.TutorID
GROUP BY T.TutorName
GO

--CREATE USER-DEFINED FUNCTION (UDF)

--Create Scalar User-Defined Function to Count Student 
CREATE FUNCTION fnStudentCount (@CID INT) RETURNS INT
AS
BEGIN
	DECLARE @C INT
	SELECT @C=COUNT(ST.StudentID)
	FROM Courses C
	INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
	INNER JOIN Students ST ON EN.StudentID=ST.StudentID
	WHERE C.CourseID=@CID
	RETURN @C
END
GO
--Create Scalar User-Defined Function to Show Total Payment Amount of Certain Courses 
CREATE FUNCTION fnTotalAmount (@CID INT) RETURNS MONEY
AS
BEGIN
	DECLARE @A INT
	SELECT @A=SUM(C.CourseFee)
	FROM Courses C
	INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
	INNER JOIN Students ST ON EN.StudentID=ST.StudentID
	WHERE C.CourseID=@CID
	HAVING COUNT(ST.StudentID)>0
	RETURN @A
END
GO
--Create User-Defined Function to RETURN IN A TABLE for Course Information
CREATE FUNCTION fnCourseInfo (@CID INT) RETURNS TABLE
AS
RETURN
(
	SELECT C.CourseName, T.TutorName, C.DurationInWeek, C.CourseFee, ST.StudentName, EN.EnrollDate, EN.PaymentDate
	FROM Courses C
	INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
	INNER JOIN Students ST ON EN.StudentID=ST.StudentID
	INNER JOIN Tutors T ON T.TutorID=C.TutorID
	WHERE C.CourseID=@CID
)
GO
----Create User-Defined Function to Retrive Course-Wise Student Data Using Aggregate Function

CREATE FUNCTION fnCourseWiseStudent (@CID INT) RETURNS TABLE 
AS
RETURN
(
		SELECT C.CourseName, COUNT(ST.StudentID) 'StudentCount',  SUM(C.CourseFee) 'TotalFee'
		FROM Courses C
		INNER JOIN Enrollments EN ON C.CourseID=EN.CourseID
		INNER JOIN Students ST ON EN.StudentID=ST.StudentID
		INNER JOIN Tutors T ON T.TutorID=C.TutorID
		WHERE C.CourseID=@CID
		GROUP BY C.CourseName
)
GO


--CREATE TRIGGER
--Create Insert Trigger on Enrollments Table
CREATE TRIGGER trInsertEnrollment
ON Enrollments
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @ED DATE, @PD DATE
	SELECT @ED=EnrollDate, @PD=PaymentDate FROM inserted
	IF CAST(@PD AS DATE) < CAST(@ED AS DATE) --PaymentDate < EnrollDate
		BEGIN 
			RAISERROR ('Invalid Payment Date', 16, 1)
			RETURN
		END
	INSERT INTO Enrollments
	SELECT * FROM inserted
END
GO
--Create Update Trigger on Enrollments Table
CREATE TRIGGER trUpdateEnrollment
ON Enrollments 
FOR UPDATE
AS 
BEGIN
	DECLARE @ED DATE, @PD DATE
	SELECT @ED=EnrollDate, @PD=PaymentDate FROM inserted
	IF CAST(@PD AS DATE) < CAST(@ED AS DATE) --PaymentDate < EnrollDate
		BEGIN 
			RAISERROR ('Invalid Payment Date', 16, 1)
			RETURN
		END
END
GO
--Create Delete Trigger on Enrollments Table
CREATE TRIGGER trDeleteEnrollment
ON Enrollments 
INSTEAD OF DELETE
AS 
BEGIN
	DECLARE @PD DATE, @CID INT, @SID INT
	SELECT @PD=PaymentDate, @CID=CourseID, @SID=StudentID FROM deleted
	IF @PD IS NOT NULL --Student must paid Course Fee
		BEGIN 
			RAISERROR ('Cannot Delete Student already has Paid', 16, 1)
			RETURN
		END
		
		DELETE 
		FROM Enrollments
		WHERE CourseID=@CID AND StudentID=@SID
END
GO
