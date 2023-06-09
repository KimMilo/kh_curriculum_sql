-- UNION 
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 10
UNION
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;

-- UNION ALL
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 10
UNION ALL
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;
 
-- INTERSECT
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 10
INTERSECT 
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;

-- MINUS
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 10
MINUS 
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101;
 
SELECT *
  FROM EMPLOYEES
 WHERE MANAGER_ID = 101
 MINUS 
SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 10;


-- SELECT 값(컬럼값) 이 동일하면 출처는 상관없음.
SELECT DEPARTMENT_ID
	 , MANAGER_ID
  FROM DEPARTMENTS
MINUS
SELECT DEPARTMENT_ID
	 , MANAGER_ID
  FROM EMPLOYEES;

/*
 * GROUPING SETS
 * 		- GROUP BY 로 집계한 여러 Record Set 결과를 하나의 Record Set 으로
 * 		  합칠 때 사용
 */
 
SELECT DEPARTMENT_ID
	 , JOB_ID
	 , COUNT(*) AS 인원수
	 , ROUND(AVG(SALARY), 2) AS 평균급여
  FROM EMPLOYEES 
 WHERE DEPARTMENT_ID IS NOT NULL 
 GROUP BY GROUPING SETS(DEPARTMENT_ID, JOB_ID, (DEPARTMENT_ID, JOB_ID))
 ORDER BY 1, 2;