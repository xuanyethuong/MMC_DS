'''
Exercise 1: Tiếp tục với Database Testing System
Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
'''
USE TESTINGSYSTEM;
DROP PROCEDURE IF EXISTS sp_GetAccFromDep; 
DELIMITER $$
CREATE PROCEDURE sp_GetAccFromDep(IN in_dep_name NVARCHAR(50)) BEGIN
 	SELECT A.AccountID, A.FullName, D.DepartmentName FROM `account` A
 	INNER JOIN department D ON D.DepartmentID = A.DepartmentID
 	WHERE D.DepartmentName = in_dep_name; 
END$$
DELIMITER ;
Call sp_GetAccFromDep('Sale');
''' Question 2: Tạo store để in ra số lượng account trong mỗi group
'''
DROP PROCEDURE IF EXISTS sp_GetCountAccFromGroup; 
DELIMITER $$
CREATE PROCEDURE sp_GetCountAccFromGroup(IN in_group_name NVARCHAR(50)) BEGIN
 	SELECT g.GroupName, count(ga.AccountID) AS SL FROM groupaccount ga
 	INNER JOIN `group` g ON ga.GroupID = g.GroupID
 	WHERE g.GroupName = in_group_name; 
END$$
DELIMITER ;
Call sp_GetCountAccFromGroup('Testing System');
'''
Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
'''
DROP PROCEDURE IF EXISTS sp_GetCountTypeInMonth; 
DELIMITER $$
CREATE PROCEDURE sp_GetCountTypeInMonth() BEGIN
	SELECT tq.TypeName, count(q.TypeID) 
	FROM question q 
	INNER JOIN typequestion tq ON q.TypeID = tq.TypeID
	WHERE month(q.CreateDate) = month(now()) AND year(q.CreateDate) = year(now()) 
	GROUP BY q.TypeID;
END$$ 
DELIMITER ;
Call sp_GetCountTypeInMonth();

'''
Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
'''
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType;
DELIMITER $$
CREATE PROCEDURE sp_GetCountQuesFromType() BEGIN
 	WITH CTE_MaxTypeID AS(
 	SELECT count(q.TypeID) AS SL FROM question q

 	)
 	SELECT tq.TypeName, count(q.TypeID) AS SL FROM question q
 	INNER JOIN typequestion tq ON tq.TypeID = q.TypeID
 	GROUP BY q.TypeID
	HAVING count(q.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
END$$ 
DELIMITER ;
Call sp_GetCountQuesFromType
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType; 
DELIMITER $$
CREATE PROCEDURE sp_GetCountQuesFromType(OUT v_ID TINYINT) BEGIN
 	WITH CTE_CountTypeID AS (
 	SELECT count(q.TypeID) AS SL FROM question q
 	GROUP BY q.TypeID)
 	SELECT q.TypeID INTO v_ID FROM question q
 	GROUP BY q.TypeID
 	HAVING COUNT(q.TypeID) = (SELECT max(SL) FROM CTE_CountTypeID);
END$$ DELIMITER ;

SET @ID =0;
Call sp_GetCountQuesFromType(@ID);

SELECT @ID;
'''
Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
'''
DROP PROCEDURE IF EXISTS sp_GetCountQuesFromType; 
DELIMITER $$
CREATE PROCEDURE sp_GetCountQuesFromType() BEGIN
 	WITH CTE_MaxTypeID AS(
 	SELECT count(q.TypeID) AS SL FROM question q
 	)
 	SELECT tq.TypeName, count(q.TypeID) AS SL 
    FROM question q
 	INNER JOIN typequestion tq ON tq.TypeID = q.TypeID
 	GROUP BY q.TypeID
 	HAVING count(q.TypeID) = (SELECT MAX(SL) FROM CTE_MaxTypeID);
END$$ 
DELIMITER ;
Call sp_GetCountQuesFromType();
SET @ID =0;
Call sp_GetCountQuesFromType(@ID);
SELECT * FROM typequestion WHERE TypeID = @ID;

'''
Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa
chuỗi của người dùng nhập vào
🡺Trong bài tập này có thể sử dụng Union để join sau khi select 2 bảng. k cần sử dụng cờ.
'''
SET @ID =0;
Call sp_GetCountQuesFromType(@ID);
SELECT * FROM typequestion WHERE TypeID = @ID;
CREATE PROCEDURE sp_getNameAccOrNameGroup ( IN var_String VARCHAR(50)
) BEGIN
 	SELECT g.GroupName FROM `group` g WHERE g.GroupName LIKE CONCAT("%",var_String,"%")
 	UNION
 	SELECT a.Username FROM `account` a WHERE a.Username LIKE CONCAT("%",var_String,"%")
END$$
DELIMITER ;
Call sp_getNameAccOrNameGroup('s');
DROP PROCEDURE IF EXISTS sp_getNameAccOrNameGroup; DELIMITER $$
DELIMITER $$
CREATE PROCEDURE sp_getNameAccOrNameGroup (IN var_String VARCHAR(50), IN flag INT)
BEGIN
    IF flag = 1 THEN
        -- This section handles the condition to get group names matching the input string
        SELECT g.GroupName 
        FROM `group` g 
        WHERE g.GroupName LIKE CONCAT("%", var_String, "%");
    ELSE
        -- This section handles the condition when flag != 1, to find users whose username contains the input string
        SELECT a.Username 
        FROM `account` a 
        WHERE a.Username LIKE CONCAT("%", var_String, "%");
    END IF;
END$$
DELIMITER ;
Call sp_getNameAccOrNameGroup('s',1);
DROP PROCEDURE IF EXISTS sp_getNameAccOrNameGroup_Union; DELIMITER $$
CREATE PROCEDURE sp_getNameAccOrNameGroup_Union ( IN var_String VARCHAR(50))
BEGIN
 	SELECT g.GroupName AS Name_Group_Username FROM `group` g WHERE g.GroupName LIKE CONCAT("%",var_String,"%")
 	UNION
 	SELECT a.Username FROM `account` a WHERE a.Username LIKE CONCAT("%",var_String,"%");
END$$ DELIMITER ;
Call sp_getNameAccOrNameGroup_Union('te');
-----
DROP PROCEDURE IF EXISTS sp_getNameAccOrNameGroup_Union;
DELIMITER $$
CREATE PROCEDURE sp_getNameAccOrNameGroup_Union ( IN var_String VARCHAR(50))
BEGIN
 	SELECT g.GroupName AS Name_Group_Username FROM `group` g WHERE g.GroupName LIKE CONCAT("%",var_String,"%")
 	UNION
 	SELECT a.Username FROM `account` a WHERE a.Username LIKE CONCAT("%",var_String,"%");
END$$ 
DELIMITER ;
Call sp_getNameAccOrNameGroup_Union('te');
'''
Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
username sẽ giống email nhưng bỏ phần @..mail đi positionID: sẽ có default là developer departmentID: sẽ được cho vào 1 phòng chờ
Sau đó in ra kết quả tạo thành công
🡺 Chú ý: Khi khai báo các biến DECLARE thì không sử dụng từ khóa NOT NULL trong
thuộc tính.
'''
-------
DROP PROCEDURE IF EXISTS sp_insertAccount; 
DELIMITER $$
CREATE PROCEDURE sp_insertAccount (	IN var_Email VARCHAR(50),
 	IN var_Fullname VARCHAR(50)) BEGIN
 	DECLARE v_Username VARCHAR(50) DEFAULT SUBSTRING_INDEX(var_Email, '@', 1);
 	DECLARE v_DepartmentID TINYINT UNSIGNED DEFAULT 11;
 	DECLARE v_PositionID TINYINT UNSIGNED DEFAULT 1;
 	DECLARE v_CreateDate DATETIME DEFAULT now();
INSERT INTO `account` (`Email`,	`Username`,	`FullName`,`DepartmentID`,	`PositionID`,	`CreateDate`)
VALUES (var_Email,	v_Username,	var_Fullname,v_DepartmentID,	v_PositionID,	v_CreateDate);
END$$ 
DELIMITER ;
Call sp_insertAccount('daonq@viettel.com.vn','Nguyen dao');
--- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất

DROP PROCEDURE IF EXISTS sp_getMaxNameQuesFormNameType;
DELIMITER $$

CREATE PROCEDURE sp_getMaxNameQuesFormNameType (IN var_Choice VARCHAR(50))
BEGIN
    DECLARE v_TypeID TINYINT UNSIGNED;
    
    -- Get the TypeID based on the provided TypeName
    SELECT tq.TypeID INTO v_TypeID 
    FROM typequestion tq
    WHERE tq.TypeName = var_Choice;

    -- Check the choice and execute corresponding query
    IF var_Choice = 'Essay' THEN
        -- Find the longest Essay content
        SELECT * 
        FROM question q
        WHERE q.TypeID = v_TypeID
        AND LENGTH(q.Content) = (
            SELECT MAX(LENGTH(q2.Content))
            FROM question q2
            WHERE q2.TypeID = v_TypeID
        );
    ELSEIF var_Choice = 'Multiple-Choice' THEN
        -- Find the longest Multiple-Choice content
        SELECT * 
        FROM question q
        WHERE q.TypeID = v_TypeID
        AND LENGTH(q.Content) = (
            SELECT MAX(LENGTH(q2.Content))
            FROM question q2
            WHERE q2.TypeID = v_TypeID
        );
    END IF;
END$$
DELIMITER ;

'''
Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
Bảng Exam có liên kết khóa ngoại đến bảng examquestion vì vậy trước khi xóa dữ liệu trong bảng exam cần xóa dữ liệu trong bảng examquestion trước
'''
DROP PROCEDURE IF EXISTS sp_DeleteExamWithID; DELIMITER $$
CREATE PROCEDURE sp_DeleteExamWithID (IN in_ExamID TINYINT UNSIGNED) BEGIN
 	DELETE FROM examquestion WHERE	ExamID = in_ExamID;

END$$ DELIMITER ;

CALL sp_DeleteExamWithID(7);
'''
Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa)
Sau đó in số lượng record đã remove từ các table liên quan trong khi removing

'''
DROP PROCEDURE IF EXISTS SP_DeleteExamBefore3Year; DELIMITER $$
CREATE PROCEDURE SP_DeleteExamBefore3Year() BEGIN
DROP PROCEDURE IF EXISTS sp_getMaxNameQuesFormNameType;
DELIMITER $$

CREATE PROCEDURE sp_getMaxNameQuesFormNameType (IN var_Choice VARCHAR(50))
BEGIN
    DECLARE v_TypeID TINYINT UNSIGNED;
    
    -- Get the TypeID based on the provided TypeName
    SELECT tq.TypeID INTO v_TypeID 
    FROM typequestion tq
    WHERE tq.TypeName = var_Choice;

    -- Check the choice and execute corresponding query
    IF var_Choice = 'Essay' THEN
        -- Find the longest Essay content
        SELECT * 
        FROM question q
        WHERE q.TypeID = v_TypeID
        AND LENGTH(q.Content) = (
            SELECT MAX(LENGTH(q2.Content))
            FROM question q2
            WHERE q2.TypeID = v_TypeID
        );
    ELSEIF var_Choice = 'Multiple-Choice' THEN
        -- Find the longest Multiple-Choice content
        SELECT * 
        FROM question q
        WHERE q.TypeID = v_TypeID
        AND LENGTH(q.Content) = (
            SELECT MAX(LENGTH(q2.Content))
            FROM question q2
            WHERE q2.TypeID = v_TypeID
        );
    END IF;
END$$

DELIMITER ;
'''
Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ
'''
DROP PROCEDURE IF EXISTS SP_DelDepFromName;
DELIMITER $$

CREATE PROCEDURE SP_DelDepFromName(IN var_DepartmentName VARCHAR(30))
BEGIN
    DECLARE v_DepartmentID VARCHAR(30);
    -- Start a transaction
    START TRANSACTION;
    -- Retrieve the DepartmentID for the given DepartmentName
    SELECT D1.DepartmentID INTO v_DepartmentID
    FROM department D1
    WHERE D1.DepartmentName = var_DepartmentName;
    -- Check if the department exists
    IF v_DepartmentID IS NOT NULL THEN
        -- Update accounts to the default DepartmentID ('11')
        UPDATE account A
        SET A.DepartmentID = '11' WHERE A.DepartmentID = v_DepartmentID;
        DELETE FROM department d WHERE d.DepartmentName = var_DepartmentName;
        -- Commit the transaction
        COMMIT;
    ELSE
        -- Rollback the transaction if the department does not exist
        ROLLBACK;
    END IF;
END$$

DELIMITER ;
'''
Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay.
Các bước làm:
-	Sử dụng CTE tạo 1 bảng tạm CTE_12Months để lưu thông tin 12 tháng
-	Sử dụng JOIN kết hợp điều kiện ON là M.MONTH = month(Q.CreateDate), ở đây ON là 1 hàm của CreateDate

'''
DROP PROCEDURE IF EXISTS sp_CountQuesInMonth;
DELIMITER $$
CREATE PROCEDURE sp_CountQuesInMonth()
BEGIN
    -- Common Table Expression (CTE) to generate 12 months
    WITH CTE_12Months AS (
        SELECT 1 AS MONTH UNION 
        SELECT 2 AS MONTH UNION 
        SELECT 3 AS MONTH UNION 
        SELECT 4 AS MONTH UNION 
        SELECT 5 AS MONTH UNION 
        SELECT 6 AS MONTH UNION 
        SELECT 7 AS MONTH UNION 
        SELECT 8 AS MONTH UNION 
        SELECT 9 AS MONTH UNION 
        SELECT 10 AS MONTH UNION 
        SELECT 11 AS MONTH UNION 
        SELECT 12 AS MONTH
    )
    -- Join the CTE with the question table to count questions per month
    SELECT 
        M.MONTH, 
        COUNT(Q.CreateDate) AS SL 
    FROM 
        CTE_12Months M
    LEFT JOIN 
        (SELECT * FROM question Q1 WHERE YEAR(Q1.CreateDate) = YEAR(NOW())) Q 
    ON 
        M.MONTH = MONTH(Q.CreateDate)
    GROUP BY 
        M.MONTH;
END$$

DELIMITER ;

-- Call the stored procedure
CALL sp_CountQuesInMonth();
'''
Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất
(Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")

'''
DROP PROCEDURE IF EXISTS sp_CountQuesBefore6Month; DELIMITER $$
CREATE PROCEDURE sp_CountQuesBefore6Month() BEGIN
 	WITH CTE_Talbe_6MonthBefore AS (
 	SELECT MONTH(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS MONTH, YEAR(DATE_SUB(NOW(), INTERVAL 5 MONTH)) AS `YEAR`
 	UNION
 	SELECT MONTH(DATE_SUB(NOW(), INTERVAL 4 MONTH)) AS MONTH, YEAR(DATE_SUB(NOW(), INTERVAL 4 MONTH)) AS `YEAR`
 	UNION
 	SELECT MONTH(DATE_SUB(NOW(), INTERVAL 3 MONTH)) AS MONTH, YEAR(DATE_SUB(NOW(), INTERVAL 3 MONTH)) AS `YEAR`
 	UNION
 	SELECT MONTH(DATE_SUB(NOW(), INTERVAL 2 MONTH)) AS MONTH, YEAR(DATE_SUB(NOW(), INTERVAL 2 MONTH)) AS `YEAR`

	UNION
 	SELECT MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AS MONTH, YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AS `YEAR`
 	UNION
	)
 	SELECT M.MONTH,M.YEAR, CASE
 	WHEN COUNT(QuestionID) = 0 THEN 'không có câu hỏi nào trong tháng'
 	ELSE COUNT(QuestionID)
 	END AS SL
 	FROM CTE_Talbe_6MonthBefore M
 	LEFT JOIN (SELECT * FROM question where CreateDate >= DATE_SUB(NOW(), INTERVAL 6 MONTH) AND CreateDate <= now()) AS Sub_Question ON M.MONTH = MONTH(CreateDate)
 	GROUP BY M.MONTH
 	ORDER BY M.MONTH ASC;
END$$ DELIMITER ;
