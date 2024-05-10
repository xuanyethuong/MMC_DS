USE testingsystem;
SELECT * FROM testingsystem.account;
INSERT INTO account 
    (ACCOUNTID, EMAIL, USERNAME, FULLNAME, DEPARTMENTID, POSITIONID, CREATEDATE)
VALUES 	
    (11, 'abc11@gmail.com', 'ABC11', 'ABCFULL11', 1, 2, '2024-05-10 16:00:00'),
    (12, 'abc12@gmail.com', 'ABC12', 'ABCFULL12', 5, 2, '2024-05-10 16:00:01'),
    (13, 'abc13@gmail.com', 'ABC13', 'ABCFULL13', 4, 2, '2024-05-10 16:00:02'),
    (14, 'abc14@gmail.com', 'ABC14', 'ABCFULL14', 8, 2, '2024-05-10 16:00:03'),
    (15, 'abc15@gmail.com', 'ABC15', 'ABCFULL15', 9, 2, '2024-05-10 16:00:00'),
    (16, 'abc16@gmail.com', 'ABC16', 'ABCFULL16', 7, 2, '2024-05-10 16:00:00'),
    (17, 'abc17@gmail.com', 'ABC17', 'ABCFULL17', 2, 2, '2024-05-10 16:00:00'),
    (18, 'abc18@gmail.com', 'ABC18', 'ABCFULL', 1, 2, '2024-05-10 16:00:00'),
    (19, 'abc19@gmail.com', 'ABC19', 'ABCFULL', 3, 2, '2024-05-10 16:00:00'),
    (20, 'abc20@gmail.com', 'ABC20', 'ABCFULL', 4, 3, '2024-05-10 16:00:00');
SELECT * FROM answer;
INSERT INTO answer 
    (AnswerID, Content, QuestionID, isCorrect)
VALUES 	
    (11, 'Trả lời 11', 1, 1),
    (12, 'Trả lời 12', 4, 1),
    (13, 'Trả lời 13', 8, 0),
    (14, 'Trả lời 11', 5, 1),
    (15, 'Trả lời 11', 9, 1),
    (16, 'Trả lời 11', 10, 1),
    (17, 'Trả lời 17', 7, 0),
    (18, 'Trả lời 18', 8, 0),
    (19, 'Trả lời 19', 9, 1),
    (20, 'Trả lời 20', 10, 1);
SELECT * FROM categoryquestion;
INSERT INTO categoryquestion 
    (CategoryID, CategoryName)
VALUES 	
	(11, 'Trả lời 13'),
	(12, 'Trả lời 14'),
  	(13, 'Trả lời 13'),
	(14, 'Trả lời 14'),
    (15, 'Trả lời 15'),
	(16, 'Trả lời 16'),
	(17, 'Trả lời 17'),
    (18, 'Trả lời 8'),
	(19, 'Trả lời 19'),
	(20, 'Trả lời 20');
SELECT * FROM Department;
INSERT INTO Department
    (DepartmentID, DepartmentName)
VALUES 	
	(11, 'DepartmentName 11'),
	(12, 'DepartmentName 12'),
  	(13, 'DepartmentName 13'),
	(14, 'DepartmentName 14'),
    (15, 'DepartmentName 15'),
	(16, 'DepartmentName 16'),
	(17, 'DepartmentName 17'),
    (18, 'DepartmentName8'),
	(19, 'DepartmentName 19'),
	(20, 'DepartmentName 20'); 
SELECT * FROM department
WHERE DEPARTMENTNAME = 'SALE';
SELECT * FROM account;
SELECT * FROM ACCOUNT 
ORDER BY LENGTH(FULLNAME) DESC
LIMIT 1;
SELECT * FROM ACCOUNT 
ORDER BY LENGTH(FULLNAME) AND (DEPARTMENTID = 3) DESC
LIMIT 1;
SELECT * FROM testingsystem.group;
SELECT * FROM testingsystem.group
ORDER BY (CREATEDATE < 20/12/2019)  DESC;
SELECT * FROM testingsystem.question;
SELECT QuestionID
FROM Question
GROUP BY QuestionID
HAVING COUNT(*) >= 4;
SELECT * FROM exam
WHERE (duration >= 60) AND (CreateDate < '2019-12-20');
SELECT * FROM testingsystem.group;
SELECT GroupID 
FROM testingsystem.group
ORDER BY CreateDate DESC
LIMIT 5;
SELECT COUNT(*) AS EMPLOYEE_COUNT
FROM DEPARTMENT 
WHERE DepartmentID = 2;
SELECT *
FROM ACCOUNT
WHERE FullName LIKE 'D%o';
DELETE FROM exam
WHERE createddate < '2019-12-20';
DELETE FROM question
WHERE Content LIKE 'câu hỏi%';
UPDATE testingsystem.account
SET FullName = 'Lô Văn Đề', Email = 'lo.vande@mmc.edu.vn'
WHERE AccountID = 5;
UPDATE groupaccount
SET GroupID = 4
WHERE AccountID = 5;

    
    
    
    
    
    