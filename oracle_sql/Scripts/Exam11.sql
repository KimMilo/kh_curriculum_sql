CREATE SEQUENCE SEQ1;
-- 객체 생성하기

SELECT SEQ1.NEXTVAL FROM DUAL;
-- 현재 번호 실행 후 다음 실행할 때마다 다음 번호 반환

SELECT SEQ1.CURRVAL FROM DUAL;
-- 현재 번호를 반환
-- 단, 시퀀스 객체 생성 직 후 실행하면 에러발생 반드시 NEXTVAL 한번
--    은 (한번하면 시작값 반환) 하고 해야함.

DROP SEQUENCE SEQ1;
-- 객체 삭제하기
----------------------------------------------------------
CREATE SEQUENCE SEQ1
 START WITH 10;
-- 10부터 시작하는 시퀀스 객체 생성

SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;

CREATE SEQUENCE SEQ2
		 START WITH 10
     INCREMENT BY 10;
-- 10부터 시작 및 10씩 증가하는 시퀀스 객체 생성

SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;
DROP SEQUENCE SEQ1;
-------------------------------------------------------------
    
CREATE SEQUENCE SEQ1
		 START WITH 10
     INCREMENT BY 10
      MAXVALUE 100;
-- 10부터 시작해서 최대 100까지 시퀀스 객체 생성

SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;
DROP SEQUENCE SEQ1;
-------------------------------------------------------------
     
CREATE SEQUENCE SEQ1
		 START WITH 10
     INCREMENT BY 10
      MAXVALUE 100
         CYCLE 
       NOCACHE;
      
-- 10부터 시작해서 최대 100까지 10씩 증가하면서 순환하는 시퀀스 객체 생성 
-- -> 10,20,....100 다음부터는 1,11,21,31,41,51,...91

SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;
DROP SEQUENCE SEQ1;
-------------------------------------------------------------
      
CREATE SEQUENCE SEQ1
		 START WITH 10
     INCREMENT BY 10
      MAXVALUE 100
      MINVALUE -100
         CYCLE 
       NOCACHE;
-- 시작은 10부터 10씩 증가하여 최대 100을 찍고
-- 최소 -100 최대100 10씩 증가하면서 순환하는 시퀀스 객체 생성

SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;
DROP SEQUENCE SEQ1;
-------------------------------------------------------------
      
CREATE SEQUENCE SEQ1
		 START WITH 10
     INCREMENT BY 10
      MAXVALUE 200
      MINVALUE -200
         CYCLE 
         CACHE 10;
/* CACHE 
 *    - 미리 생성하여 저장(할당)할 수 있는 정수값 수량
 *	  - 기본적으로 CACHE 는 20개의 번호로 설정되어 있음
 *	  - 미리생성된 번호를 NEXTVAL 값에 사용하고 다 사용하면 다음 설정 개수만큼 생성
 *    - oracle 이 이상하게 종료되거나하면 CACHE 설정개수만큼 뻑나서 NEXTVAL 값에 들어갈 수 있음.
 *    - CACHE의 장점은 속도가 빠름.
 */
        
SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL;
DROP SEQUENCE SEQ1;
---------------------------------------------------------------
ALTER SEQUENCE SEQ1
      INCREMENT BY 5
      MAXVALUE 250
      MINVALUE -100
       NOCYCLE
       NOCACHE;
-- 시퀀스 객체 수정할 때 START WITH 는 변경하지 못함.
-- 시퀀스 객체 수정하기 (수정 전 CURRVAL부터 변경된 시퀀스로 동작함.)
       
SELECT SEQ1.NEXTVAL FROM DUAL;
SELECT SEQ1.CURRVAL FROM DUAL; 

DROP SEQUENCE SEQ1;
----------------------------------------------------------------

/* 일반적인 시퀀스 객체 사용 예시*/
CREATE SEQUENCE SEQ_TEMP;
CREATE TABLE TEMP(
	   ID NUMBER PRIMARY KEY
);

INSERT INTO TEMP VALUES(SEQ_TEMP.NEXTVAL);
SELECT * FROM TEMP;

UPDATE TEMP 
   SET ID = SEQ_TEMP.NEXTVAL
 WHERE ID = 5;

SELECT * FROM TEMP;

/* 
 * NEXTVAL, CURRVAL 을 사용할 수 있는 명령어
 * 		1. SELECT 문(서브쿼리 아님)
 *      2. INSERT 문의 VALUES 절
 * 		3. INSERT 문의 SELECT 절
 * 		4. UPDATE 문의 SET 절
 * 
 * NEXTVAL, CURRVAL 을 사용할 수 없는 명령어
 * 		1. VIEW 를 사용하는 SELECT
 * 		2. DISTINCT 키워드가 있는 SELECT
 * 		3. GROUP BY, HAVING, ORDER BY 가 있는 SELECT
 * 		4. SELECT, DELETE, UPDATE 의 서브쿼리
 * 		5. CREATE TABLE, ALTER TABLE 에서 사용하는 DEFAULT 값
 */

CREATE TABLE TEST(
       DEPT_ID NUMBER
);

INSERT INTO TEST VALUES(100);


CREATE SEQUENCE SEQ1
     START WITH 110
   INCREMENT BY 10;

INSERT INTO TEST
       VALUES(SEQ1.NEXTVAL);
       
SELECT * FROM TEST;

DROP TABLE TEST;
DROP SEQUENCE SEQ1;