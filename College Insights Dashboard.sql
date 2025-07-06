CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  gender VARCHAR(10),
  age INT CHECK (age >= 17),
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  course_name VARCHAR(100) NOT NULL,
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
CREATE TABLE enrollments (
  enrollment_id INT PRIMARY KEY,
  student_id INT,
  course_id INT,
  enrollment_date DATE,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'Computer Science'),
(2, 'Electronics'),
(3, 'Mathematics'),
(4, 'Physics');
INSERT INTO students (student_id, name, gender, age, dept_id) VALUES
(101, 'Sneha', 'Female', 21, 1),
(102, 'Raj', 'Male', 22, 1),
(103, 'Priya', 'Female', 20, 2),
(104, 'Arjun', 'Male', 23, 3),
(105, 'Tanvi', 'Female', 21, 4);
INSERT INTO courses (course_id, course_name, dept_id) VALUES
(201, 'DBMS', 1),
(202, 'Data Structures', 1),
(203, 'Digital Circuits', 2),
(204, 'Linear Algebra', 3),
(205, 'Quantum Mechanics', 4);
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 101, 201, '2023-07-01'),
(2, 101, 202, '2023-07-01'),
(3, 102, 201, '2023-07-02'),
(4, 103, 203, '2023-07-03'),
(5, 104, 204, '2023-07-03'),
(6, 105, 205, '2023-07-04'),
(7, 105, 204, '2023-07-04');

-- Department-wise total number of students
SELECT d.dept_name, COUNT(*) AS total_students FROM students s JOIN departments d ON s.dept_id = d.dept_id GROUP BY d.dept_name;

-- Course-wise student enrollment count
SELECT c.course_name, COUNT(*) AS enrolled_students FROM enrollments e JOIN courses c ON e.course_id = c.course_id GROUP BY c.course_name;

-- Students enrolled in more than 1 course
SELECT student_id, COUNT(*) AS total_courses FROM enrollments GROUP BY student_id HAVING COUNT(*) > 1;

-- Students not enrolled in any course
SELECT s.student_id, s.name FROM students s LEFT JOIN enrollments e ON s.student_id = e.student_id WHERE e.enrollment_id IS NULL;

-- Most popular course
SELECT c.course_name, COUNT(*) AS cnt FROM enrollments e JOIN courses c ON e.course_id = c.course_id GROUP BY c.course_name ORDER BY cnt DESC LIMIT 1;

-- Department offering most number of courses
SELECT d.dept_name, COUNT(*) AS num_courses FROM courses c JOIN departments d ON c.dept_id = d.dept_id GROUP BY d.dept_name ORDER BY num_courses DESC LIMIT 1;

-- View
CREATE VIEW student_course_info AS
SELECT s.name AS student_name, c.course_name, d.dept_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN departments d ON s.dept_id = d.dept_id;

SELECT * FROM student_course_info;

-- Stored procedure
DELIMITER //
CREATE PROCEDURE GetCoursesByStudent(IN stu_name VARCHAR(50))
BEGIN
  SELECT s.name, c.course_name
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN courses c ON e.course_id = c.course_id
  WHERE s.name = stu_name;
END //
DELIMITER ;

-- Rank students by number of courses taken
SELECT s.name, COUNT(e.course_id) AS num_courses,
RANK() OVER (ORDER BY COUNT(e.course_id) DESC) AS course_rank
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name;









