CREATE TABLE EMP_SAMPLE
AS
SELECT EMPLOYEE_ID AS EMP_ID
	 , FIRST_NAME || ' ' || LAST_NAME AS EMP_NAME
	 , EMAIL || '@emp.co.kr' AS EMAIL
	 , HIRE_DATE
	 , SALARY
	 , COMMISSION_PCT
	 , DEPARTMENT_ID AS DEPT_ID
	 , REPLACE(PHONE_NUMBER, '.' , '-') AS PHONE
  FROM EMPLOYEES;	 
  
SELECT * FROM EMP_SAMPLE;

/*
 * 홍길동 사원 정보를 추가 한다.
 * 홍길동 사원의 EMP_ID 는 기존 EMP_ID의 값 중 가장 큰 EMP_ID + 1한 값이 저장되게 한다.
 * 홍길동 사원의 입사일은 2022년 03월 05일 이다.
 * 홍길동 사원의 부서 ID는 80 이다.
 * 홍길동 사원의 급여는 2800 이며, 보너스(COMMISSION_PCT) 는 없다.
 * 위에서 제시한 사항을 참고하여 데이터를 추가하며 없는 정보는 NULL 로 채워 넣는다.
 */
SELECT MAX(EMP_ID) FROM EMP_SAMPLE;
INSERT INTO EMP_SAMPLE(EMP_ID, EMP_NAME, HIRE_DATE, DEPT_ID, SALARY, 
						COMMISSION_PCT)
				VALUES((SELECT MAX(EMP_ID) + 1 FROM EMP_SAMPLE),
						'홍길동', TO_DATE('20220305'), 80, 2800, NULL);

SELECT * FROM EMP_SAMPLE ORDER BY EMP_ID;
/*
 * 홍길동 사원의 부서ID는 60 으로 수정하세요.
 * 홍길동 사원의 EMAIL 주소는 영문이름으로 만들어서 수정해주세요.
 * 홍길동 사원의 전화번호는 590-423-4561 으로 수정해주세요.
 */

UPDATE EMP_SAMPLE 
   SET DEPT_ID = 60
     , EMAIL = 'HongGilDong@emp.co.kr'
     , PHONE = '590-423-4561'
 WHERE EMP_NAME = '홍길동';					

SELECT * FROM EMP_SAMPLE WHERE EMP_NAME = '홍길동';

/*
 * 1990년 이전 입사자들의 퇴직신청을 위해 관련된 사원의 리스트를 조회하고
 * 조회된 정보 중에서 급여가 10000 이상인 사원의 급여를 25% 삭감하세요.
 */

SELECT * 
  FROM EMP_SAMPLE 
 WHERE HIRE_DATE < TO_DATE('19900101') AND SALARY > 10000;

UPDATE EMP_SAMPLE
   SET SALARY = SALARY - (SALARY * 0.25)
 WHERE HIRE_DATE < TO_DATE('19900101') AND SALARY > 10000;

SELECT * 
  FROM EMP_SAMPLE 
 WHERE HIRE_DATE < TO_DATE('19900101') AND SALARY > 10000;

/*
 * 부서 ID 가 50, 60, 70 인 사원들에 대해 기존 급여에 10% 인상한 급여로
 * 수정하세요.
 */

SELECT COUNT(*)
  FROM EMP_SAMPLE
 WHERE DEPT_ID IN (50, 60, 70);

UPDATE EMP_SAMPLE
   SET SALARY = SALARY * 1.1
 WHERE DEPT_ID IN (50, 60, 70);

-- COUNT(*) 의 52개와 Updated Rows 의 52개 같은지 체크하는게 좋음.

SELECT *
  FROM EMP_SAMPLE
 WHERE DEPT_ID IN (50, 60, 70);
---------------------------------------------------------------------------

DROP TABLE EMP_SAMPLE;