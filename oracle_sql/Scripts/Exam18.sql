/*
 * TRIGGER 객체
 * 		- PL/SQL 구문을 사용하여 생성할 수 있는 객체
 * 		- 테이블 또는 뷰에 INSERT, UPDATE, DELETE 문에 의한 변경이 발생할 경우
 * 		  자동으로 실행할 내용을 정의하여 실행하게 하는 객체
 * 		- 변경 전/후를 구분하여 자동으로 실행할 내용을 정의할 수 있다.
 * 		- 문장 트리거, 행 트리거로 나눌 수 있으며, 행 트리거의 경우 FOR EACH ROW 를
 * 		  작성해야 한다.
 * 		- 행 트리거를 사용하게 되면 NEW.컬럼명 또는 OLD.컬럼명 형태를 사용할 수 있다.
 * 
 * 
 * 		- PS : SYS 계정에서는 TRIGGER 객체 생성 불가인것 같고, 사용하는 TABLE 삭제하면 
 *        	   TRIGGER 도 제거 되는 것 같음.
 * 
 * 사용 예시)
 * 재고관리 할 때 입고테이블, 출고테이블, 재고테이블이 있다고 가정하면
 * - 입고 또는 출고 테이블 수정이 생기면, 재고테이블에 트리거를 활용해서 사용.
 * - 추가적으로 재고테이블의 수량이 일정 수량 이하면 재고요청 테이블 트리거 활용해서 사용.
 */

CREATE TABLE ORIGIN(
	   ID NUMBER
	 , NAME VARCHAR2(50)
);

CREATE TABLE COPY(
	   ID NUMBER
	 , NAME VARCHAR2(50)
);

/* INSERT 트리거 생성 */
CREATE OR REPLACE TRIGGER TRG_SAMPLE1
AFTER INSERT ON ORIGIN FOR EACH ROW
BEGIN 	
	DBMS_OUTPUT.PUT_LINE('ORIGIN 테이블에 대한 AFTER INSERT 트리거 동작');
	/* INSERT INTO COPY VALUES(1, 'A'); 
	 * : 해당 값이 ORIGIN에 INSERT 되면 COPY에도 INSERT
	 */
	INSERT INTO COPY VALUES(:NEW.ID, :NEW.NAME); 
	/* FOR EACH ROW : ORIGIN에 INSERT 되는 값 불러와서 COPY에 INSERT */

	/* INSERT , UPDATE, DELETE 사용방법 동일함 */
END;

INSERT INTO ORIGIN VALUES(1, 'A');
INSERT INTO ORIGIN VALUES(2, 'B');
INSERT INTO ORIGIN VALUES(3, 'C');
INSERT INTO ORIGIN VALUES(7, 'G');
INSERT INTO ORIGIN(
	SELECT 4, 'D' FROM DUAL
	UNION ALL
	SELECT 5, 'E' FROM DUAL 
	UNION ALL
	SELECT 6, 'F' FROM DUAL
);

SELECT * FROM USER_ERRORS;

SELECT * FROM ORIGIN;
SELECT * FROM COPY;

--------------------------------------------------------------------------

/* UPDATE 트리거 생성 */
CREATE OR REPLACE TRIGGER TRG_SAMPLE2
BEFORE UPDATE ON ORIGIN FOR EACH ROW 
BEGIN 
	UPDATE COPY 
	   SET NAME = :OLD.NAME || '->' || :NEW.NAME
	 WHERE ID = :NEW.ID;
	DBMS_OUTPUT.PUT_LINE('UPDATE 트리거 동작!!!');
END;

/* UPDATE 트리거 생성 시 ID는 넣은게 없어서 COPY는 변화 없고, Output에도 출력문 없음 */
UPDATE ORIGIN
   SET ID = ID * 10
 WHERE ID = 1;

/* UPDATE 트리거대로 ORIGIN에 수정되고, COPY도 트리거 내용대로 수정 및 Output에 출력 */
UPDATE ORIGIN 
   SET NAME = 'd'
 WHERE ID = 4;

SELECT * FROM USER_ERRORS;

SELECT * FROM ORIGIN;
SELECT * FROM COPY;


-----------------------------------------------------------------------------------------------

/*
 * DEPARTMENTS 테이블에 총원(EMP_TOTAL) 컬럼을 추가하여 부서별 인원을 기록할 수 있도록 수정한다.
 * 
 * 사원 추가(PROC_ADD_EMPLOYEE) 프로시져를 생성하여 사원을 추가할 때 다음의 기능이 동작하도록 한다.
 * 		- EMPLOYEES 테이블에 사원을 추가할 수 있는 최소한의 정보를 이용하여 프로시져가 동작하게 한다.
 * 		- 추가된 사원의 부서에 맞추어 DEPARTMENTS 테이블의 EMP_TOTAL 컬럼의 총원을 증가시키도록 한다.
 * 
 * 사원 수정(PROC_MOD_EMPLOYEE) 프로시져와 사원 삭제(PROC_DEL_EMPLOYEE) 프로시져를 생성하여
 * 다음의 기능이 동작하도록 한다.
 * 		- EMPLOYEES 테이블의 사원 정보를 수정/삭제 할 수 있는 최소한의 정보를 이용하여 프로시져가
 * 		  동작하게 한다.
 * 		- 사원의 정보를 수정할 때는 급여, 직무, 부서 만 수정할 수 있게 한다.
 * 		- 수정/삭제된 사원의 부서에 맞추어 DEPARTMENTS 테이블의 EMP_TOTAL 컬럼의 총원을 증가
 *        혹은 감소 시키도록 한다.
 * 
 * TRIGGER 로도 생성하여 만들어 본다. 
 * 		- TRIGGER로 생성하고 테스트 할 때에는 직접
 * 		  INSERT, UPDATE, DELETE 쿼리문을 만들어서 실행해야 합니다.
 * 
 * 중요 POINT 
 * 		 PROCEDURE 와 TRIGGER는 중복으로 사용하지 않는게 좋음
 * 		 그 이유는, PROCEDURE 에 UPDATE 등 원본테이블에 처리한 내용이 있으면 
 * 		 중복으로 처리됨.
 * 		
 * 		  해당 예제로 본다면 PROC_ADD_EMPLOYEE 하기 구문을 사용하지 않고 써야함.
 * 	
 * 				UPDATE DEPARTMENTS 
 *		   		   SET EMP_TOTAL = EMP_TOTAL + 1
 *	 	         WHERE DEPARTMENT_ID = IN_DEPT_ID;
 */

/*
 * PROCEDURE 사용
 */

/* INSERT */
ALTER TABLE DEPARTMENTS ADD EMP_TOTAL NUMBER DEFAULT(0);

UPDATE DEPARTMENTS D
   SET EMP_TOTAL = (SELECT COUNT(*)
                      FROM EMPLOYEES E
                     GROUP BY DEPARTMENT_ID
                     HAVING D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 WHERE DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID 
						   FROM EMPLOYEES);
-- OR --						
UPDATE DEPARTMENTS D
   SET EMP_TOTAL = (SELECT CNT
   					  FROM (SELECT DEPARTMENT_ID AS DEPT_ID 
   					             , COUNT(*) AS CNT
                              FROM EMPLOYEES E
                             GROUP BY DEPARTMENT_ID)
                     WHERE DEPT_ID = D.DEPARTMENT_ID);
    						
UPDATE DEPARTMENTS
   SET EMP_TOTAL = 0
 WHERE EMP_TOTAL IS NULL;

SELECT * FROM DEPARTMENTS;

CREATE OR REPLACE PROCEDURE PROC_ADD_EMPLOYEE(
	   IN_FNAME IN VARCHAR2
	 , IN_LNAME IN VARCHAR2
	 , IN_EMAIL IN VARCHAR2
	 , IN_JOB_ID IN VARCHAR2
	 , IN_DEPT_ID IN NUMBER
)
IS 
	VAR_EMP_ID NUMBER;
	VAR_SALARY NUMBER;
	EXISTS_JOB VARCHAR2(30);
	EXISTS_DEPT NUMBER;
BEGIN
	SELECT MAX(EMPLOYEE_ID) + 1 INTO VAR_EMP_ID FROM EMPLOYEES;
	SELECT JOB_ID, MIN_SALARY 
      INTO EXISTS_JOB, VAR_SALARY 
      FROM JOBS 
     WHERE JOB_ID = IN_JOB_ID;
	SELECT DEPARTMENT_ID 
      INTO EXISTS_DEPT 
      FROM DEPARTMENTS 
     WHERE DEPARTMENT_ID = IN_DEPT_ID;
	
	INSERT INTO EMPLOYEES(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL
						, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID)
			       VALUES(VAR_EMP_ID, IN_FNAME, IN_LNAME, IN_EMAIL
	  		          	, SYSDATE, VAR_SALARY, IN_JOB_ID, IN_DEPT_ID);
	
    /* TRI_ADD_EMPLOYEE TRIGGER로 대체함.
	UPDATE DEPARTMENTS 
	   SET EMP_TOTAL = EMP_TOTAL + 1
	 WHERE DEPARTMENT_ID = IN_DEPT_ID;
	*/
	  		          
	COMMIT;	    
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('직무 코드 또는 부서 ID가 존재하지 않습니다.');
		ROLLBACK;
END;

SELECT * FROM USER_ERRORS;

/* 실행 */
-- 부서ID 300번이 없어서 EXCEPTION 처리됨.
BEGIN
	PROC_ADD_EMPLOYEE('홍', '길동', 'GILL', 'IT_PROG', 300);
END;

BEGIN
	PROC_ADD_EMPLOYEE('홍', '길동', 'GILL', 'IT_PROG', 60);
END;

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

/* UPDATE : 급여, 직무, 부서 수정 */
CREATE OR REPLACE PROCEDURE PROC_MOD_EMPLOYEE(
       IN_EMP_ID IN NUMBER
     , IN_SALARY IN NUMBER
     , IN_JOB_ID IN VARCHAR2
     , IN_DEPT_ID IN NUMBER
)
IS
	VAR_DEPT_ID NUMBER;
BEGIN
	SELECT DEPARTMENT_ID 
      INTO VAR_DEPT_ID 
      FROM EMPLOYEES 
     WHERE EMPLOYEE_ID = IN_EMP_ID;
	
    IF VAR_DEPT_ID <> IN_DEPT_ID THEN
    	UPDATE DEPARTMENTS
		   SET EMP_TOTAL = EMP_TOTAL - 1
		 WHERE DEPARTMENT_ID = VAR_DEPT_ID;
	
		UPDATE DEPARTMENTS 
		   SET EMP_TOTAL = EMP_TOTAL + 1
		 WHERE DEPARTMENT_ID = IN_DEPT_ID;
	END IF;

	UPDATE EMPLOYEES 
	   SET SALARY = IN_SALARY
	     , JOB_ID = IN_JOB_ID
	     , DEPARTMENT_ID = IN_DEPT_ID
	 WHERE EMPLOYEE_ID = IN_EMP_ID;
	
	COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
	ROLLBACK;
END;

SELECT * FROM USER_ERRORS;

/* 실행 */
BEGIN
	PROC_MOD_EMPLOYEE(213, 4000, 'PR_REP', 70);
END;

SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

/* DELETE */

CREATE OR REPLACE PROCEDURE PROC_DEL_EMPLOYEE(
	   IN_EMP_ID IN NUMBER
)
IS
	VAR_DEPT_ID NUMBER;
BEGIN
	SELECT DEPARTMENT_ID 
      INTO VAR_DEPT_ID 
      FROM EMPLOYEES 
     WHERE EMPLOYEE_ID = IN_EMP_ID;

	DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = IN_EMP_ID;

	UPDATE DEPARTMENTS 
	   SET EMP_TOTAL = EMP_TOTAL - 1
	 WHERE DEPARTMENT_ID = VAR_DEPT_ID;
	
	COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
		ROLLBACK;
END;

SELECT * FROM USER_ERRORS;

/* 실행 */

BEGIN
	PROC_DEL_EMPLOYEE(213);
END;

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

-------------------------------------------------------------------------
/*
 * TRIGGER 사용 
 */

/* INSERT */

CREATE OR REPLACE TRIGGER TRI_ADD_EMPLOYEE
AFTER INSERT ON EMPLOYEES FOR EACH ROW 
BEGIN 
	UPDATE DEPARTMENTS 
	   SET EMP_TOTAL = EMP_TOTAL + 1
	 WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID;
END;

SELECT * FROM USER_ERRORS;

INSERT INTO EMPLOYEES(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL
						, HIRE_DATE, SALARY, JOB_ID, DEPARTMENT_ID)
			       VALUES(213, '홍', '길덩', 'GILL'
	  		          	, SYSDATE, 4000, 'IT_PROG', 60);

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

/* UPDATE */

CREATE OR REPLACE TRIGGER TRI_MOD_EMPLOYEE
AFTER UPDATE ON EMPLOYEES FOR EACH ROW 
BEGIN 
    UPDATE DEPARTMENTS
	   SET EMP_TOTAL = EMP_TOTAL - 1
     WHERE DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
	
	UPDATE DEPARTMENTS 
	   SET EMP_TOTAL = EMP_TOTAL + 1
     WHERE DEPARTMENT_ID = :NEW.DEPARTMENT_ID;
END;


/* DELETE */

CREATE OR REPLACE TRIGGER TRI_DEL_EMPLOYEE
AFTER DELETE ON EMPLOYEES FOR EACH ROW 
BEGIN 
	UPDATE DEPARTMENTS 
	   SET EMP_TOTAL = EMP_TOTAL - 1
	 WHERE DEPARTMENT_ID = :OLD.DEPARTMENT_ID;
END;

