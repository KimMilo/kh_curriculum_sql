CREATE OR REPLACE VIEW V_EMP
AS
SELECT EMPLOYEE_ID EMP_ID
     , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
     , LOWER(EMAIL) || '@emp.co.kr' AS EMAIL
     , SALARY
     , MANAGER_ID
     , DEPARTMENT_ID AS DEPT_ID
  FROM EMPLOYEES;
  
SELECT * FROM V_EMP;

UPDATE V_EMP 
   SET MANAGER_ID = 100
 WHERE EMP_ID = 100;

CREATE OR REPLACE VIEW V_EMP
AS
SELECT EMPLOYEE_ID EMP_ID
     , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
     , LOWER(EMAIL) || '@employee.co.kr' AS EMAIL
     , SALARY
     , MANAGER_ID
     , DEPARTMENT_ID AS DEPT_ID
  FROM EMPLOYEES;

SELECT * FROM V_EMP;

/* FORCE 옵션 : FROM 테이블이 없어도 강제로 VIEW 생성 */
CREATE OR REPLACE FORCE VIEW V_EMP
AS
SELECT EMPLOYEE_ID EMP_ID
     , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
     , LOWER(EMAIL) || '@employee.co.kr' AS EMAIL
     , SALARY
     , MANAGER_ID
     , DEPARTMENT_ID AS DEPT_ID
  FROM EMP;

SELECT * FROM V_EMP;
-- 테이블 없는 VIEW 를 강제로 생성하여 에러발생. 
-- --> VIEW 먼저 만들고 나중에 TABLE 만들 때 사용함.

/* WITH READ ONLY 옵션 : 읽기전용(INSERT, UPDATE, DELETE 불가, SELECT만 가능) */
CREATE OR REPLACE VIEW V_EMP
AS
SELECT EMPLOYEE_ID EMP_ID
     , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
     , LOWER(EMAIL) || '@employee.co.kr' AS EMAIL
     , SALARY
     , MANAGER_ID
     , DEPARTMENT_ID AS DEPT_ID
  FROM EMPLOYEES
  WITH READ ONLY;

SELECT * FROM V_EMP;

/* WITH CHECK OPTION : WHERE 절과 같이 사용하여 WHERE 절 조건에 해당되지 않으면 에러발생 */
CREATE OR REPLACE VIEW V_EMP
AS
SELECT EMPLOYEE_ID EMP_ID
     , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
     , LOWER(EMAIL) || '@employee.co.kr' AS EMAIL
     , SALARY
     , MANAGER_ID
     , DEPARTMENT_ID AS DEPT_ID
  FROM EMPLOYEES
 WHERE MANAGER_ID BETWEEN 100 AND 110
  WITH CHECK OPTION;

SELECT * FROM V_EMP;

UPDATE V_EMP
   SET MANAGER_ID = 111
 WHERE EMP_ID = 101;
-- WITH CHECK OPTION 조건 위배 에러발생 : WHERE절의 조건에 해당되지 않으면 에러발생