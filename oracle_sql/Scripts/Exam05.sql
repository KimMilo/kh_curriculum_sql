/*
 * 지출내역서(가계부)를 위한 테이블을 만들어 본다.
 * 		- 테이블 이름은 '지출내역서' 로 한다.
 * 		- 컬럼은 ID, 날짜, 출입구분, 금액, 비고 로 만들어 사용한다.
 * 		- 비고의 경우 한글 100자 까지 저장 가능하게 한다.
 * 		- 출입구분은 '출', '입' 만 사용 가능하게 한다.
 * 		- ID 는 해당 Record 를 식별하기 위한 식별자로 사용할 것이다.
 */

CREATE TABLE TEST1 (
	 	COLID VARCHAR2(10) CONSTRAINT TEST1_COLID_PK PRIMARY KEY
	  , COLDAY DATE
	  , COLINOUT VARCHAR2(10)
	  , COLTEXT VARCHAR2(100 CHAR)
);

ALTER TABLE TEST1 RENAME TO 지출내역서;
ALTER TABLE 지출내역서 RENAME CONSTRAINT TEST1_COLID_PK TO 지출내역서_COLID_PK;

SELECT * FROM USER_TABLES;
SELECT * FROM 지출내역서;

DELETE FROM 지출내역서;

INSERT INTO 지출내역서(COLID, COLDAY, COLINOUT, COLTEXT)
		VALUES('user11', SYSDATE, '입', '11월 월급 1억원 입금되었습니다.');

INSERT INTO 지출내역서(COLID, COLDAY, COLINOUT, COLTEXT)
		VALUES('adcd23', SYSDATE, '입', '11월 월급 500만원 입금 되었습니다.');
	
SELECT * FROM 지출내역서;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역서';

DROP TABLE 지출내역서;
-------------------------1답.-------------------------------------------

CREATE TABLE 지출내역서(
		ID NUMBER		CONSTRAINT 지출내역서_ID_PK PRIMARY KEY
	  , 날짜 DATE
	  , 출입구분 CHAR(3) 	CONSTRAINT 지출내역서_출입구분_CK CHECK(출입구분 IN('출', '입'))
	  , 금액 NUMBER
	  , 비고 VARCHAR(100 CHAR)
);

DROP TABLE 지출내역서;
-------------------------2답.---------------------------------------------

CREATE TABLE 지출내역서(
		ID NUMBER
	  , 날짜 DATE
	  , 출입구분 CHAR(3)
	  , 금액 NUMBER
	  , 비고 VARCHAR(100 CHAR)
	  , CONSTRAINT 지출내역서_ID_PK PRIMARY KEY(ID)
	  , CONSTRAINT 지출내역서_출입구분_CK CHECK(출입구분 IN('출', '입'))
);

SELECT * FROM 지출내역서;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역서';

DROP TABLE 지출내역서;

------------------------3답.---------------------------------------------

CREATE TABLE 지출내역서(
		ID NUMBER
	  , 날짜 DATE
	  , 출입구분 CHAR(3)
	  , 금액 NUMBER
	  , 비고 VARCHAR(100 CHAR)
);

ALTER TABLE 지출내역서 ADD CONSTRAINT 지출내역서_ID_PK PRIMARY KEY(ID);
ALTER TABLE 지출내역서 MODIFY 출입구분 CONSTRAINT 지출내역서_출입구분_CK CHECK(출입구분 IN ('출', '입'));

SELECT * FROM 지출내역서;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '지출내역서';

DROP TABLE 지출내역서;