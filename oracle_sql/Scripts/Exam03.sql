/* 
 * JOB_ID 별 최고급여액, 최저급여액을 구하시오
 * COMMISION_PCT가 있는 경우 COMMISSION_PCT를 포함한 급여액으로 구하세요.
 */

SELECT JOB_ID
	 , MAX(CASE WHEN COMMISSION_PCT IS NULL THEN SALARY 
	 			ELSE SALARY * (1 + COMMISSION_PCT)
	 	   END) AS "JOB_ID별 최고급여액"
	 , MIN(CASE WHEN COMMISSION_PCT IS NULL THEN SALARY 
	 			ELSE SALARY * (1 + COMMISSION_PCT)
	 	   END) AS "JOB_ID별 최저급여액"
  FROM EMPLOYEES
 GROUP BY JOB_ID;


/*
 * HAVING 절
 * 		- 그룹에 대한 조건절로 사용한다.
 *		- WHERE 절에서 사용하는 조건은 GROUP 으로 묶이기 전의 조건으로 사용됨.
 */

SELECT DEPARTMENT_ID
	 , COUNT(DEPARTMENT_ID) 부서별총원
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
HAVING COUNT(DEPARTMENT_ID) < 5;

SELECT SUBSTR(PHONE_NUMBER, 1, 3) AS 전화번호앞잘리
	 , COUNT(*) AS 수량
  FROM EMPLOYEES
 GROUP BY SUBSTR(PHONE_NUMBER, 1, 3)
HAVING COUNT(*) >= 20;

/*
 * 30명 이상 근무하는 부서의 전화번호 앞자리 사용 회선수 집계
 */

SELECT DEPARTMENT_ID AS 부서ID
	 , SUBSTR(PHONE_NUMBER, 1, 3) AS 전화번호앞자리
	 , COUNT(SUBSTR(PHONE_NUMBER, 1, 3)) AS 회선수
	 , COUNT(DEPARTMENT_ID)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID , SUBSTR(PHONE_NUMBER, 1, 3) 
HAVING COUNT(DEPARTMENT_ID) >= 30; 

/*
 * 커미션을 지급 받는 사원의 직무 분포 현황
 */

SELECT JOB_ID
	 , COUNT(JOB_ID) AS 수
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL
 GROUP BY JOB_ID;

SELECT JOB_ID
	 , COMMISSION_PCT AS 커미션률
	 , COUNT(*) AS 수
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL
 GROUP BY JOB_ID, COMMISSION_PCT;

/* 
 * 1. 1980년대 입사자, 1990년대 입사자, 2000년대 입사자의 수를 구하시오.
 * 
 * 2. DEPARTMENT_ID 가 50, 80, 100 인 부서의 평균 급여를 구하시오.
 * 
 * 3. 년도 구분 없이 1/4 분기 2/4분기, 3/4분기, 4/4분기 별 입사자의 수를 구하시오.
 * 
 * 4. 급여액이 10000 이상인 사원이 어느 부서에 많이 있는지 확인할 수 있는 조회 구문을 작성하시오.
 * 
 */

-- 1. 1980년대 입사자, 1990년대 입사자, 2000년대 입사자의 수를 구하시오.
SELECT SUBSTR(EXTRACT(YEAR FROM HIRE_DATE),1,3) || '0' AS 입사년도
	 , COUNT(*) AS 입사자수
FROM EMPLOYEES
WHERE HIRE_DATE BETWEEN '19800101' AND '20001231'
GROUP BY SUBSTR(EXTRACT(YEAR FROM HIRE_DATE),1,3) || '0'
ORDER BY 1;


-- 2. DEPARTMENT_ID 가 50, 80, 100 인 부서의 평균 급여를 구하시오.
SELECT DEPARTMENT_ID AS 부서
	 , ROUND(AVG(SALARY),2) AS 평균급여
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (50, 80, 100)
GROUP BY DEPARTMENT_ID;


-- 3. 년도 구분 없이 1/4 분기 2/4분기, 3/4분기, 4/4분기 별 입사자의 수를 구하시오.
SELECT CASE WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 1 AND 3 THEN '1/4분기'
			WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 4 AND 6 THEN '2/4분기'
			WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 7 AND 9 THEN '3/4분기'
			ELSE '4/4분기'
		END AS 분기
	 , COUNT(*) AS 입사자수
  FROM EMPLOYEES
 GROUP BY CASE WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 1 AND 3 THEN '1/4분기'
			  WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 4 AND 6 THEN '2/4분기'
			  WHEN EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 7 AND 9 THEN '3/4분기'
			  ELSE '4/4분기'
		  END
 ORDER BY 1;
		  
-- 4. 급여액이 10000 이상인 사원이 어느 부서에 많이 있는지 확인할 수 있는 조회 구문을 작성하시오.		 
SELECT DEPARTMENT_ID AS 부서
	 , COUNT(*) AS 급여10000이상사원수
  FROM EMPLOYEES
WHERE SALARY >= 10000
GROUP BY DEPARTMENT_ID
ORDER BY 2 DESC;
