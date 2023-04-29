/*
 * PL/SQL
 *		- Procedural Language extension to SQL
 *		- SQL 문장에서 변수의 정의, 조건문, 반복문 등의 프로그래밍 언어에서
 * 		  지원하는 기능을 일부 지원하는 것
 * 
 * PL/SQL 구조
 * 
 * DECLARE
 *    변수 정의 영역(생략 가능)
 * BEGIN
 *    실행 영역 
 * EXCEPTION
 *    예외처리 영역(생략 가능)
 * END;
 * 
 * / : SQLPLUS에서는 작성완료 후 마지막 뒤에 / 부호(종료를 의미) 작성해야되나, 
 *     DBeaver 에서는 사용 X(사용하면 부적합한 SQL유형입니다. sqlKind = UNINITIALIZED).
 * 
 */

BEGIN 
	DBMS_OUTPUT.PUT_LINE('Hello PL/SQL');
END;

-- Output 화면에서 출력되며, 우클릭하면 Clear 키 있음(또는 편집기->sql편집기->sql실행
-- -> Clear output log before execution 설정하면 이전 출력 내용 제거 후 출력함)


/* SQLPLUS 접속 방법 : 일반 실행 후 입력 또는 검색란에 입력 */
-- 관리자 sqlplus / as sysdba
-- 계정 접속 sqlpus web_admin/admin@localhost:1521/xepdb1
--                 계정명   / 비밀번호

-- SQLPLUS 에서 출력기능 ON/OFF 하는 방법
-- : SET SERVEROUTPUT ON; / OFF;

/*
 * 기본 변수 사용 방법 
 */
DECLARE
	-- 할당 시 := 부호 사용
   x NUMBER := 10; 
   y NUMBER := 20;
BEGIN
	DBMS_OUTPUT.PUT_LINE (x + y);
END;

DECLARE
	-- 문자열 할당 시 크기 지정해야함.
   s1 VARCHAR2(10) := 'Hello'; 
   s2 CHAR(10) := 'PL/SQL';
BEGIN
	DBMS_OUTPUT.PUT_LINE (s1 || ' ' || s2);
END;
	
DECLARE
	-- BEGIN 에서 할당
	n1 NUMBER;
	n2 NUMBER;
BEGIN
	n1 := 10;
	n2 := 20;
	DBMS_OUTPUT.PUT_LINE(n1 + n2);
END;

DECLARE
	-- BEGIN 에서 재할당
	e1 NUMBER := 1;
	e2 NUMBER := 2;
BEGIN
	e1 := 10;
	e2 := 20;
	DBMS_OUTPUT.PUT_LINE(e1 + e2);
END;

------------------------------------------------------------------

/*
 * 조회 구문 사용하기
 */

DECLARE
	EMP_ID NUMBER;
	FNAME VARCHAR2(30);
	LNAME VARCHAR2(30);
BEGIN
	SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
	  INTO EMP_ID, FNAME, LNAME
	  FROM EMPLOYEES
	 WHERE EMPLOYEE_ID = 100;
	DBMS_OUTPUT.PUT_LINE(EMP_ID || '|' || FNAME || '|' || LNAME);
END;

-- VALUE 값 입력해서 조회하기
-- 이 떄 , DBeaver는 : 를 사용하고 SQLPLUS는 & 사용
DECLARE
	EMP_ID NUMBER;
	FNAME VARCHAR2(30);
	LNAME VARCHAR2(30);
BEGIN
	SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
	  INTO EMP_ID, FNAME, LNAME
	  FROM EMPLOYEES
	 WHERE EMPLOYEE_ID = :ID;
	DBMS_OUTPUT.PUT_LINE(EMP_ID || '|' || FNAME || '|' || LNAME);
END;

-- SQLPLUS에서 사용 방법
DECLARE
	EMP_ID NUMBER;
	FNAME VARCHAR2(30);
	LNAME VARCHAR2(30);
BEGIN
	SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
	  INTO EMP_ID, FNAME, LNAME
	  FROM EMPLOYEES
	 WHERE EMPLOYEE_ID = &ID;
	DBMS_OUTPUT.PUT_LINE(EMP_ID || '|' || FNAME || '|' || LNAME);
END;
/

/*
 * IF 문 사용하기
 */

DECLARE
	NUM NUMBER;
BEGIN
	NUM := :NUM;
    IF(NUM > 10) THEN
    	DBMS_OUTPUT.PUT_LINE('변수 NUM에 저장된 값은 10보다 큽니다.');
    END IF;
END;

DECLARE
	NUM NUMBER;
BEGIN
	NUM := :NUM;
    IF(NUM > 10) THEN
    	DBMS_OUTPUT.PUT_LINE('변수 NUM에 저장된 값은 10보다 큽니다.');
    ELSIF(NUM = 10) THEN
    	-- = 같다 => 할당 시 =가 아닌 := 이라서 같다를 굳이 ==로 할 필요가 없기 때문에...
        DBMS_OUTPUT.PUT_LINE('변수 NUM에 저장된 값은 10입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('변수 NUM에 저장된 값은 10보다 작습니다.');
    END IF;
END;

/*
 * 반복문 사용하기 
 */

BEGIN
	FOR N IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;

BEGIN
	FOR N IN REVERSE 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;

/*
 * LOOP ~ END LOOP; : 무한반복문
 */
DECLARE
 	NUM NUMBER := 0;
BEGIN
	LOOP
		NUM := NUM + 1;
		DBMS_OUTPUT.PUT_LINE(NUM);
		IF NUM > 5 THEN 
			EXIT;
		END IF;
	END LOOP;
END;

DECLARE
	NUM NUMBER := 0;
BEGIN
	WHILE NUM < 5 LOOP
		NUM := NUM + 1;
		DBMS_OUTPUT.PUT_LINE(NUM);
	END LOOP;
END;

/*
 * 테스트용 테이블을 생성 후 데이터 추가 / 수정 / 삭제 하기. 
 */

CREATE TABLE TEST1(
	   ID NUMBER PRIMARY KEY
	 , NAME VARCHAR2(30)
	 , AGE NUMBER
);

-- sqlplus 이용해서 commit 후 조회
-- :name 형식에서 막혀서 sqlplus로 진행했고 
-- :name 이용하려면 이름 입력 시 '' 넣어서 입력할 것
DECLARE
	ID NUMBER;
	NAME VARCHAR2(30);
	AGE NUMBER;
BEGIN
	ID := &ID;
	NAME := '&NAME';
	AGE := &AGE;
	INSERT INTO TEST1 VALUES(ID, NAME, AGE);
END;

-- DBeaver에서 문자열 입력 : Bind parameter(s)에 문자열 칸은 '' 넣어서 입력할 것
DECLARE
	ID NUMBER;
	NAME VARCHAR2(30);
	AGE NUMBER;
BEGIN
	ID := :ID;
	NAME := :NAME;
	-- DBeaver에서는 '홍길동' 이런식으로 입력해야 식별자 에러 발생 하지 않음.
	AGE := :AGE;
	INSERT INTO TEST1 VALUES(ID, NAME, AGE);
END;

/* 무결성 제약 조건 중복값 데이터 유무 확인 및 없으면 INSERT하기 */
DECLARE
	VID NUMBER;
	NAME VARCHAR2(30);
	AGE NUMBER;
	CNT NUMBER;
BEGIN
	VID := :ID;
	NAME := :NAME;
	AGE := :AGE;
	SELECT COUNT(ID)
	  INTO CNT
	  FROM TEST1
	 WHERE ID = VID;
	IF(CNT = 1) THEN
 		DBMS_OUTPUT.PUT_LINE('동일한 ID 가 존재합니다.');
 	ELSE
 		INSERT INTO TEST1 VALUES(VID, NAME, AGE);
 		COMMIT;
 	END IF;
END;

/* EXCEPTION END 
 * DUP_VAL_ON_INDEX : 중복 오류
 * 구글에서 oracle pl/sql exception name 21c 검색 후 
 * -->https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-error-handling.html#GUID-8C327B4A-71FA-4CFB-8BC9-4550A23734D6
 * -->exception categories 란에서 naming 찾으면 됨.(error코드로 찾으면됨.)
 */
DECLARE
	VID NUMBER;
	NAME VARCHAR2(30);
	AGE NUMBER;
BEGIN
	VID := :ID;
	NAME := :NAME;
	AGE := :AGE;
    INSERT INTO TEST1 VALUES(VID, NAME, AGE);
 	COMMIT;
EXCEPTION
	WHEN DUP_VAL_ON_INDEX 
		THEN DBMS_OUTPUT.PUT_LINE('중복값이 있습니다.');
	ROLLBACK;
END;

/* 해당 ID에 중복값이 있을 경우 VNAME, VAGE로 변경 적용 */
DECLARE
	VID NUMBER;
	VNAME VARCHAR2(30);
	VAGE NUMBER;
BEGIN
	VID := :ID;
	VNAME := :NAME;
	VAGE := :AGE;
    INSERT INTO TEST1 VALUES(VID, VNAME, VAGE);
 	COMMIT;
EXCEPTION
	WHEN DUP_VAL_ON_INDEX 
		THEN 
			UPDATE TEST1
			   SET NAME = VNAME
			     , AGE = VAGE
			 WHERE ID = VID;
	COMMIT;
END;

SELECT * FROM TEST1;