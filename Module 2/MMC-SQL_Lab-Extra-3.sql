USE hr;
-- Truy vấn 1: Truy xuất tất cả nhân viên có địa chỉ ở Elgin, IL
-- Gợi ý: Sử dụng toán tử LIKE để tìm các string tương tự
SELECT * FROM employees
WHERE address LIKE '%Elgin%' or '%IL%';
-- Truy vấn 2: Truy xuất tất cả nhân viên sinh vào những năm 1970.
-- Gợi ý: Sử dụng toán tử LIKE để tìm các string tương tự
SELECT * FROM employees
WHERE B_DATE LIKE '%1970%';
-- Truy vấn 3: Truy xuất tất cả nhân viên trong phòng ban 5 có mức lương từ 60000 đến 70000.
-- Gợi ý: Sử dụng từ khóa BETWEEN cho truy vấn này
SELECT * FROM employees
WHERE DEP_ID = 5 AND ( salary BETWEEN 60000 AND 70000 );
-- Truy vấn 4A: Truy xuất danh sách nhân viên được sắp xếp theo ID phòng ban.
-- Gợi ý: Sử dụng mệnh đề ORDER BY cho truy vấn này
SELECT * FROM employees 
ORDER BY DEP_ID DESC;
-- Truy vấn 4B: Truy xuất danh sách nhân viên được sắp xếp theo thứ tự giảm dần theo ID phòng ban và trong mỗi phòng ban, 
-- những nhân viên này được sắp xếp theo họ với thứ tự giảm dần của bảng chữ cái.
SELECT * FROM employees
ORDER BY DEP_ID DESC, f_name DESC;
-- Truy vấn 5A: Đối với mỗi ID phòng ban, truy xuất số lượng nhân viên trong phòng ban.
-- Gợi ý: Sử dụng COUNT (*) để truy xuất tổng số cột, sau đó dùng GROUP BY
SELECT DEP_ID, COUNT(*)  AS QUANTITY
FROM employees
GROUP BY DEP_ID;
-- Truy vấn 5B: Đối với mỗi phòng ban, truy xuất số lượng nhân viên trong phòng ban và mức lương trung bình của nhân viên trong phòng ban.
-- Gợi ý: Sử dụng COUNT (*) để truy xuất tổng số cột và dùng hàm AVG () để tính toán mức lương trung bình, sau đó nhóm kết quả lại
SELECT DEP_ID, COUNT(*) AS E_count, AVG(salary) AS AVG_SL
FROM employees
GROUP BY DEP_ID;
-- Truy vấn 5C: Gắn nhãn các cột đã tính trong tập hợp kết quả của Truy vấn 5B là NUM_EMPLOYEES và AVG_SALARY.
-- Gợi ý: Sử dụng AS “LABEL_NAME” sau tên cột
SELECT DEP_ID, 
       COUNT(*) AS NUM_EMPLOYEES, 
       AVG(salary) AS AVG_SALARY
FROM employees
GROUP BY DEP_ID;
-- Truy vấn 5E: Trong Truy vấn 5D, giới hạn kết quả thành ít hơn 4 nhân viên cho các phòng ban.
-- Gợi ý: Sử dụng HAVING sau GROUP BY và sử dụng hàm count () trong mệnh đề HAVING chứ không dùng nhãn cột.
-- Lưu ý: Mệnh đề WHERE được sử dụng để lọc toàn bộ tập kết quả còn mệnh đề HAVING được sử dụng để lọc kết quả của việc nhóm
SELECT DEP_ID, 
       COUNT(*) AS NUM_EMPLOYEES, 
       AVG(salary) AS AVG_SALARY
FROM employees
GROUP BY DEP_ID
HAVING NUM_EMPLOYEES < 4
ORDER BY AVG_SALARY DESC;




