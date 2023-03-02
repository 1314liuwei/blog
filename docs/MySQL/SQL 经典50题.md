# SQL 经典 50 题

## 引言

SQL 是一门基础简单、语法通俗易懂的语言。但是想要灵活应用 SQL，使其能够达到随心所欲的境界就需要大量的练习。下面这50道问题是十分经典的题目，全部练习之后会使你的 SQL 语句编写能力更上一个台阶。加油吧！

**注**：博主是使用的 MySQL8 练习的题目，大家自行练习时要注意和自己的数据库版本进行对应哦。

## 创建数据库

```sql
DROP TABLE IF EXISTS `Course`;
CREATE TABLE `Course`  (
  `C` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Cname` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `T` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of Course
-- ----------------------------
INSERT INTO `Course` VALUES ('01', '语文', '02');
INSERT INTO `Course` VALUES ('02', '数学', '01');
INSERT INTO `Course` VALUES ('03', '英语', '03');

-- ----------------------------
-- Table structure for SC
-- ----------------------------
DROP TABLE IF EXISTS `SC`;
CREATE TABLE `SC`  (
  `S` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `C` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `score` decimal(18, 1) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of SC
-- ----------------------------
INSERT INTO `SC` VALUES ('01', '01', 80.0);
INSERT INTO `SC` VALUES ('01', '02', 90.0);
INSERT INTO `SC` VALUES ('01', '03', 99.0);
INSERT INTO `SC` VALUES ('02', '01', 70.0);
INSERT INTO `SC` VALUES ('02', '02', 60.0);
INSERT INTO `SC` VALUES ('02', '03', 80.0);
INSERT INTO `SC` VALUES ('03', '01', 80.0);
INSERT INTO `SC` VALUES ('03', '02', 80.0);
INSERT INTO `SC` VALUES ('03', '03', 80.0);
INSERT INTO `SC` VALUES ('04', '01', 50.0);
INSERT INTO `SC` VALUES ('04', '02', 30.0);
INSERT INTO `SC` VALUES ('04', '03', 20.0);
INSERT INTO `SC` VALUES ('05', '01', 76.0);
INSERT INTO `SC` VALUES ('05', '02', 87.0);
INSERT INTO `SC` VALUES ('06', '01', 31.0);
INSERT INTO `SC` VALUES ('06', '03', 34.0);
INSERT INTO `SC` VALUES ('07', '02', 89.0);
INSERT INTO `SC` VALUES ('07', '03', 98.0);
INSERT INTO `SC` VALUES ('07', '04', 94.0);

-- ----------------------------
-- Table structure for Student
-- ----------------------------
DROP TABLE IF EXISTS `Student`;
CREATE TABLE `Student`  (
  `S` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Sname` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Sage` datetime(0) NULL DEFAULT NULL,
  `Ssex` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of Student
-- ----------------------------
INSERT INTO `Student` VALUES ('01', '赵雷', '1990-01-01 00:00:00', '男');
INSERT INTO `Student` VALUES ('02', '钱电', '1990-12-21 00:00:00', '男');
INSERT INTO `Student` VALUES ('03', '孙风', '1990-05-20 00:00:00', '男');
INSERT INTO `Student` VALUES ('04', '李云', '1990-08-06 00:00:00', '男');
INSERT INTO `Student` VALUES ('05', '周梅', '1991-12-01 00:00:00', '女');
INSERT INTO `Student` VALUES ('06', '吴兰', '1992-03-01 00:00:00', '女');
INSERT INTO `Student` VALUES ('07', '郑竹', '1989-07-01 00:00:00', '女');
INSERT INTO `Student` VALUES ('08', '王菊', '1990-01-20 00:00:00', '女');

-- ----------------------------
-- Table structure for Teacher
-- ----------------------------
DROP TABLE IF EXISTS `Teacher`;
CREATE TABLE `Teacher`  (
  `T` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Tname` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of Teacher
-- ----------------------------
INSERT INTO `Teacher` VALUES ('01', '张三');
INSERT INTO `Teacher` VALUES ('02', '李四');
INSERT INTO `Teacher` VALUES ('03', '王五');

SET FOREIGN_KEY_CHECKS = 1;
```

## 题目

1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
2. 查询同时存在" 01 "课程和" 02 "课程的情况
3. 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
4. 查询不存在" 01 "课程但存在" 02 "课程的情况
5. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
6. 查询在 SC 表存在成绩的学生信息
7. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )
8. 查询「李」姓老师的数量 
9. 查询学过「张三」老师授课的同学的信息 
10. 查询没有学全所有课程的同学的信息 
11. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息 
12. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息 
13. 查询没学过"张三"老师讲授的任一门课程的学生姓名 
14. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
15. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
16. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
17. 查询各科成绩最高分、最低分和平均分：以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
      及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
      要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
18. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺
19. 按各科成绩进行排序，并显示排名， Score 重复时合并名次
20. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺
21. 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
22. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
23. 查询各科成绩前三名的记录
24. 查询每门课程被选修的学生数 
25. 查询出只选修两门课程的学生学号和姓名 
26. 查询男生、女生人数
27. 查询名字中含有「风」字的学生信息
28. 查询同名同性学生名单，并统计同名人数
29. 查询 1990 年出生的学生名单
30. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
31. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩 
32. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数 
33. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
34. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
35. 查询不及格的课程
36. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
37. 求每门课程的学生人数 
38. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
39. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
40. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
41. 查询每门功成绩最好的前两名
42. 统计每门课程的学生选修人数（超过 5 人的课程才统计）。
43. 检索至少选修两门课程的学生学号 
44. 查询选修了全部课程的学生信息
45. 查询各学生的年龄，只按年份来算 
46. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
47. 查询本周过生日的学生
48. 查询下周过生日的学生
49. 查询本月过生日的学生
50. 查询下月过生日的学生

## 参考答案

1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数

   ```sql
   -- 方式1
   SELECT
   	S,
   	Sname,
   	Sage,
   	Ssex,
   	SUM( CASE WHEN C = '01' THEN score ELSE NULL END ) AS C1,
   	SUM( CASE WHEN C = '02' THEN score ELSE NULL END ) AS C2 
   FROM
   	SC
   	INNER JOIN Student USING ( S ) 
   GROUP BY
   	S,
   	Sname,
   	Sage,
   	Ssex 
   HAVING
   	C1 > C2;
   -- 方式2
   SELECT
   	S,
   	Sname,
   	Sage,
   	Ssex,
   	Course1.score AS C1,
   	Course2.score AS C2 
   FROM
   	( SELECT S, score FROM SC WHERE C = '01' ) AS Course1
   	INNER JOIN ( SELECT S, score FROM SC WHERE C = '02' ) AS Course2 USING ( S )
   	INNER JOIN Student USING ( S ) 
   WHERE
   	Course1.score > Course2.score;
   ```

2. 查询同时存在" 01 "课程和" 02 "课程的学生的信息及课程分数

   ```sql
   SELECT
   	S,
   	Sname,
   	Sage,
   	Ssex,
   	Course1.score AS C1,
   	Course2.score AS C2 
   FROM
   	( SELECT S, score FROM SC WHERE C = '01' ) AS Course1
   	INNER JOIN ( SELECT S, score FROM SC WHERE C = '02' ) AS Course2 USING ( S )
   	INNER JOIN Student USING ( S );
   ```

3. 查询存在" 01 "课程但可能不存在" 02 "课程的学生的信息及课程分数(不存在时显示为 null )

   ```sql
   SELECT
   	S,
   	Sname,
   	Sage,
   	Ssex,
   	Course1.score AS C1,
   	Course2.score AS C2 
   FROM
   	( SELECT S, score FROM SC WHERE C = '01' ) AS Course1
   	LEFT JOIN ( SELECT S, score FROM SC WHERE C = '02' ) AS Course2 USING ( S )
   	INNER JOIN Student USING ( S );
   ```

4. 查询不存在" 01 "课程但存在" 02 "课程的学生的信息及课程分数

   ```sql
   SELECT
   	S,
   	Sname,
   	Sage,
   	Ssex,
   	Course1.score AS C1,
   	Course2.score AS C2 
   FROM
   	( SELECT S, score FROM SC WHERE C = '01' ) AS Course1
   	RIGHT JOIN ( SELECT S, score FROM SC WHERE C = '02' ) AS Course2 USING ( S )
   	INNER JOIN Student USING ( S ) 
   WHERE
   	Course1.score IS NULL;
   ```

5. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩

   ```sql
   SELECT
   	S,
   	AVG( score ) 
   FROM
   	SC 
   GROUP BY
   	S 
   HAVING
   	AVG( score ) > 60;
   ```

6. 查询在 SC 表存在成绩的学生信息

   ```sql
   SELECT
   	Student.* 
   FROM
   	( SELECT S FROM SC GROUP BY S HAVING COUNT( score ) > 0 ) AS S1
   	INNER JOIN Student USING ( S );
   ```

7. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为 null )

   ```sql
   SELECT
   	Student.Sname,
   	Student.S,
   	S1.amount,
   	S1.total 
   FROM
   	( SELECT S, COUNT( C ) AS amount, SUM( score ) AS total FROM SC GROUP BY S ) AS S1
   	RIGHT JOIN Student USING ( S );
   ```

8. 查询「李」姓老师的数量 

   ```sql
   SELECT
   	COUNT( T ) 
   FROM
   	Teacher 
   WHERE
   	Tname LIKE '李%';
   ```

9. 查询学过「张三」老师授课的同学的信息 

   ```sql
   SELECT
   	Student.* 
   FROM
   	(
   	SELECT DISTINCT
   		S 
   	FROM
   		SC
   		INNER JOIN ( SELECT C FROM ( SELECT T FROM Teacher WHERE Tname = '张三' ) AS T1 INNER JOIN Course ON T1.T = Course.T ) AS C1 ON SC.C = C1.C 
   	) AS S1
   	INNER JOIN Student ON S1.S = Student.S;
   ```

10. 查询没有学全所有课程的同学的信息 

    ```sql
    SELECT
    	Student.* 
    FROM
    	SC
    	RIGHT JOIN Student ON SC.S = Student.S 
    GROUP BY
    	Student.S,
    	Student.Sname,
    	Student.Sage,
    	Student.Ssex 
    HAVING
    	COUNT( C ) < ( SELECT COUNT(*) FROM Course );
    ```

11. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息 

     ```sql
    SELECT
    	* 
    FROM
    	Student 
    WHERE
    	S IN (
    	SELECT DISTINCT
    		S 
    	FROM
    		SC 
    WHERE
    	C IN ( SELECT C FROM SC WHERE S = '01' ))
     ```

12. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息 

     ```sql
    SELECT
    	* 
    FROM
    	Student 
    WHERE
    	S IN (
    	SELECT
    		S 
    	FROM
    		SC 
    	WHERE
    		S NOT IN (
    		SELECT
    			S 
    		FROM
    			SC 
    		WHERE
    		C NOT IN ( SELECT C FROM SC WHERE S = '01' )) 
    	GROUP BY
    		S 
    	HAVING
    		COUNT( C )=(
    		SELECT
    			COUNT(*) 
    		FROM
    			SC 
    		WHERE
    		S = '01' 
    	))
     ```

13. 查询没学过"张三"老师讲授的任一门课程的学生姓名 

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	S NOT IN (
    	SELECT DISTINCT
    		S 
    	FROM
    		SC
    		INNER JOIN (
    		SELECT
    			C 
    		FROM
    			Course 
    		WHERE
    		T IN ( SELECT T FROM Teacher WHERE Tname = '张三' )) AS C1 ON SC.C = C1.C 
    	);
     ```

14. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 

     ```sql
    SELECT
    	SC.S,
    	Student.Sname,
    	AVG( score ) 
    FROM
    	SC
    	INNER JOIN Student ON Student.S = SC.S 
    WHERE
    	SC.S IN ( SELECT S FROM SC WHERE score < 60 GROUP BY S HAVING COUNT( C )>= 2 ) 
    GROUP BY
    	SC.S,
    	Student.Sname
     ```

15. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息

     ```sql
    SELECT
    	* 
    FROM
    	Student 
    WHERE
    	S IN (
    	SELECT
    		S 
    	FROM
    		SC 
    	WHERE
    		C = '01' 
    		AND score < 60 
    ORDER BY
    	score)
     ```

16. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

     ```sql
    SELECT
    	S,
    	AVG( score ),
    	MAX( CASE C WHEN '01' THEN score ELSE NULL END ) AS C1,
    	MAX( CASE C WHEN '02' THEN score ELSE NULL END ) AS C2,
    	MAX( CASE C WHEN '03' THEN score ELSE NULL END ) AS C3 
    FROM
    	SC 
    GROUP BY
    	S 
    ORDER BY
    	AVG( score ) DESC
     ```

17. 查询各科成绩最高分、最低分和平均分：以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
      及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
      要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列

    ```sql
    SELECT
    	SC.C,
    	Course.Cname,
    	COUNT( score ) AS 选课人数,
    	MAX( score ) AS highestScore,
    	MIN( score ) AS lowestScore,
    	AVG( score ) AS average,
    	CONCAT( COUNT( CASE WHEN score >= 60 THEN 1 ELSE NULL END )/ COUNT( score )* 100, '%' ) AS 及格率,
    	CONCAT( COUNT( CASE WHEN score >= 70 AND score < 80 THEN 1 ELSE NULL END )/ COUNT( score )* 100, '%' ) AS 中等率,
    	CONCAT( COUNT( CASE WHEN score >= 80 AND score < 90 THEN 1 ELSE NULL END )/ COUNT( score )* 100, '%' ) AS 优良率,
    	CONCAT( COUNT( CASE WHEN score >= 90 THEN 1 ELSE NULL END )/ COUNT( score )* 100, '%' ) AS 优秀率 
    FROM
    	SC
    	INNER JOIN Course ON SC.C = Course.C 
    GROUP BY
    	SC.C,
    	Course.Cname 
    ORDER BY
    	选课人数 DESC,
    	C
    ```

18. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺

     ```sql
    SELECT
    	C,
    	S,
    	score,
    	RANK() OVER ( PARTITION BY C ORDER BY score DESC ) AS RANKING 
    FROM
    	SC
     ```

19. 按各科成绩进行排序，并显示排名， Score 重复时合并名次

     ```sql
    SELECT
    	C,
    	S,
    	score,
    	DENSE_RANK() OVER ( PARTITION BY C ORDER BY score DESC ) AS RANKING 
    FROM
    	SC
     ```

20. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺

     ```sql
    SELECT
    	RANK() OVER ( ORDER BY SUM( score ) DESC ) AS 排名,
    	S,
    	SUM( score ) AS 总分 
    FROM
    	SC 
    GROUP BY
    	S
     ```

21. 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺

     ```sql
    SELECT
    	DENSE_RANK() OVER ( ORDER BY SUM( score ) DESC ) AS 排名,
    	S,
    	SUM( score ) AS 总分 
    FROM
    	SC 
    GROUP BY
    	S
     ```

22. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比

     ```sql
     SELECT
     	C,
     	CONCAT(
     		COUNT( CASE WHEN score >= 85 AND score <= 100 THEN 1 ELSE NULL END ),
     		'人/',
     		COUNT( CASE WHEN score >= 85 AND score <= 100 THEN 1 ELSE NULL END )/ COUNT( score )* 100,
     		'%' 
     	) AS '[100-85]人数/百分比',
     	CONCAT(
     		COUNT( CASE WHEN score >= 70 AND score < 85 THEN 1 ELSE NULL END ),
     		'人/',
     		COUNT( CASE WHEN score >= 70 AND score < 85 THEN 1 ELSE NULL END )/ COUNT( score )* 100,
     		'%' 
     	) AS '[85-70]人数/百分比',
     	CONCAT(
     		COUNT( CASE WHEN score >= 60 AND score < 70 THEN 1 ELSE NULL END ),
     		'人/',
     		COUNT( CASE WHEN score >= 60 AND score < 70 THEN 1 ELSE NULL END )/ COUNT( score )* 100,
     		'%' 
     	) AS '[70-60]人数/百分比',
     	CONCAT(
     		COUNT( CASE WHEN score >= 0 AND score < 60 THEN 1 ELSE NULL END ),
     		'人/',
     		COUNT( CASE WHEN score >= 0 AND score < 60 THEN 1 ELSE NULL END )/ COUNT( score )* 100,
     		'%' 
     	) AS '[60-0]人数/百分比' 
     FROM
     	SC 
     GROUP BY
     	C
     ```

23. 查询各科成绩前三名的记录

     ```sql
    SELECT
    	* 
    FROM
    	( SELECT C, score, RANK() OVER ( PARTITION BY C ORDER BY score DESC ) AS ranking FROM SC GROUP BY C, score ) AS C1 
    WHERE
    	C1.ranking <=3
     ```

24. 查询每门课程被选修的学生数 

     ```sql
    SELECT
    	C,
    	COUNT( S ) AS 选修人数 
    FROM
    	SC 
    GROUP BY
    	C
     ```

25. 查询出只选修两门课程的学生学号和姓名 

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	S IN (
    	SELECT
    		S 
    	FROM
    		SC 
    	GROUP BY
    		S 
    HAVING
    	COUNT( C )= 2)
     ```

26. 查询男生、女生人数

     ```sql
    SELECT
    	Ssex,
    	COUNT( Ssex ) AS '人数' 
    FROM
    	Student 
    GROUP BY
    	Ssex
     ```

27. 查询名字中含有「风」字的学生信息

     ```sql
    SELECT
    	* 
    FROM
    	Student 
    WHERE
    	Sname LIKE '%风%'
     ```

28. 查询同名同性学生名单，并统计同名人数

     ```sql
    SELECT
    	A.*,
    	B.同名人数 
    FROM
    	Student AS A
    	LEFT JOIN ( SELECT Sname, Ssex, COUNT(*) AS 同名人数 FROM Student GROUP BY Sname, Ssex ) AS B ON A.Sname = B.Sname 
    	AND A.Ssex = B.Ssex 
    WHERE
    	B.同名人数 >1
     ```

29. 查询 1990 年出生的学生名单

     ```sql
    SELECT
    	Sname,
    	Sage 
    FROM
    	Student 
    WHERE
    	YEAR ( Sage ) = 1990
     ```

30. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列

     ```sql
    SELECT
    	C,
    	AVG( score ) 
    FROM
    	SC 
    GROUP BY
    	C 
    ORDER BY
    	AVG( score ) DESC,
    	C
     ```

31. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩 

     ```sql
    SELECT
    	SC.S,
    	Sname,
    	AVG( score ) 
    FROM
    	SC
    	INNER JOIN Student ON SC.S = Student.S 
    GROUP BY
    	SC.S,
    	Sname 
    HAVING
    	AVG( score ) >= 85
     ```

32. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数 

     ```sql
    SELECT
    	SC.S,
    	Sname,
    	score 
    FROM
    	SC
    	INNER JOIN Student ON SC.S = Student.S 
    WHERE
    	C =(
    	SELECT
    		C 
    	FROM
    		Course 
    	WHERE
    		Cname = '数学' 
    	) 
    	AND score <= 60
     ```

33. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）

     ```sql
     SELECT
     	S,
     	SUM( CASE C WHEN '01' THEN score ELSE NULL END ) AS 'C01',
     	SUM( CASE C WHEN '02' THEN score ELSE NULL END ) AS 'C02',
     	SUM( CASE C WHEN '03' THEN score ELSE NULL END ) AS 'C03',
     	SUM( CASE C WHEN '04' THEN score ELSE NULL END ) AS 'C04'
     FROM
     	SC 
     GROUP BY
     	S
     ```

34. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数

     ```sql
     SELECT
     	Student.Sname,
     	Course.Cname,
     	SC.score 
     FROM
     	SC
     	INNER JOIN Student ON SC.S = Student.S
     	INNER JOIN Course ON SC.C = Course.C 
     WHERE
     	score > 70
     ```

35. 查询不及格的课程

     ```sql
     SELECT
     	Student.Sname,
     	Course.Cname,
     	SC.score 
     FROM
     	SC
     	INNER JOIN Student ON SC.S = Student.S
     	INNER JOIN Course ON SC.C = Course.C 
     WHERE
     	score < 60
     ```

36. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名

     ```sql
     SELECT
     	SC.S,
     	Student.Sname,
     	SC.score 
     FROM
     	SC
     	INNER JOIN Student ON SC.S = Student.S 
     WHERE
     	SC.C = '01' 
     	AND SC.score > 80
     ```

37. 求每门课程的学生人数 

     ```sql
     SELECT
     	Course.Cname,
     	COUNT( S ) 
     FROM
     	SC
     	RIGHT JOIN Course ON SC.C = Course.C 
     GROUP BY
     	Course.Cname
     ```

38. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩

     ```sql
    SELECT
    	Student.*,
    	SC.score 
    FROM
    	SC
    	INNER JOIN Student ON SC.S = Student.S 
    WHERE
    	SC.C IN (
    	SELECT
    		C 
    	FROM
    		Course 
    	WHERE
    		T =(
    		SELECT
    			T 
    		FROM
    			Teacher 
    		WHERE
    			Tname = '张三' 
    		)) 
    ORDER BY
    	score DESC 
    	LIMIT 1
     ```

39. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩

     ```sql
    SELECT
    	Student.*,
    	SC.score 
    FROM
    	SC
    	INNER JOIN Student ON SC.S = Student.S 
    WHERE
    	SC.score >=(
    	SELECT
    		score 
    	FROM
    		SC 
    	WHERE
    		SC.C IN (
    		SELECT
    			C 
    		FROM
    			Course 
    		WHERE
    			T =(
    			SELECT
    				T 
    			FROM
    				Teacher 
    			WHERE
    				Tname = '张三' 
    			)) 
    	ORDER BY
    		score DESC 
    		LIMIT 1 
    	) 
    	AND SC.C IN (
    	SELECT
    		C 
    	FROM
    		Course 
    	WHERE
    		T =(
    		SELECT
    			T 
    		FROM
    			Teacher 
    		WHERE
    		Tname = '张三' 
    	))
     ```

40. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 

     ```sql
    SELECT DISTINCT
    	A.* 
    FROM
    	SC AS A
    	INNER JOIN SC AS B ON A.S = B.S 
    WHERE
    	A.score = B.score 
    	AND A.C != B.C
     ```

41. 查询每门功成绩最好的前两名

     ```sql
    SELECT
    	* 
    FROM
    	SC 
    WHERE
    	( SELECT COUNT(*) FROM SC AS A WHERE SC.C = A.C AND SC.score < A.score ) < 2 
    ORDER BY
    	C,
    	score DESC;
     ```

42. 统计每门课程的学生选修人数（超过 5 人的课程才统计）

     ```sql
    SELECT
    	C,
    	COUNT( S ) 
    FROM
    	SC 
    GROUP BY
    	C 
    HAVING
    	COUNT( S )>5
     ```

43. 检索至少选修两门课程的学生学号 

     ```sql
    SELECT
    	S,
    	COUNT( C ) 
    FROM
    	SC 
    GROUP BY
    	S 
    HAVING
    	COUNT( C )>=2
     ```

44. 查询选修了全部课程的学生信息

     ```sql
    SELECT
    	S,
    	COUNT( C ) 
    FROM
    	SC 
    GROUP BY
    	S 
    HAVING
    	COUNT( C )=(
    	SELECT
    		COUNT(*) 
    FROM
    	Course)
     ```

45. 查询各学生的年龄，只按年份来算 

     ```sql
    SELECT
    	S,
    	YEAR (
    	NOW()) - YEAR ( Sage ) AS age 
    FROM
    	Student
     ```

46. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一

     ```sql
    SELECT
    	S,
    	YEAR (
    	NOW()) - YEAR ( Sage ) - ( CASE WHEN MONTH ( NOW()) > MONTH ( Sage ) AND DAY ( NOW()) > DAY ( Sage ) THEN 0 ELSE 1 END ) AS age 
    FROM
    	Student
     ```

47. 查询本周过生日的学生

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	WEEK ( Sage )= WEEK (
    	NOW())
     ```

48. 查询下周过生日的学生

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	WEEK ( Sage )=(
    	WEEK (
    	NOW())+ 1)
     ```

49. 查询本月过生日的学生

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	MONTH ( Sage )= MONTH (
    	NOW())
     ```

50. 查询下月过生日的学生

     ```sql
    SELECT
    	Sname 
    FROM
    	Student 
    WHERE
    	MONTH ( Sage )=(
    	MONTH (
    	NOW())+ 1)
     ```

     