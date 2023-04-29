/*
 * SYNONYM(동의어)
 * 		- 다른 사용자의 객체를 참조할 때 사용자명.객체명 형식으로 사용하는 것을
 *        좀 더 간단한 이름으로 사용할 수 있도록 다른 이름을 만드는 것
 * 		
 * 비공개 동의어
 * 		- 객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로
 * 		  해당 사용자만 사용 가능.
 * 
 * 공개 동의
 * 		- DBA 가 정한 동의어로 모든 사용자가 사용 가능.(DUAL 이 공개 동의어로 만들어진 것)
 */

/* 관리자 권한에서 연습용 계정 생성 및 커넥션 생성하기(관리자권한 및 user1,2 커넥션도추가) */

CREATE USER user1 IDENTIFIED BY user1;
CREATE USER user2 IDENTIFIED BY user2;

GRANT CONNECT, RESOURCE, INSERT ANY TABLE, UPDATE ANY TABLE,
			DELETE ANY TABLE, CREATE SYNONYM TO user1;
		
GRANT CONNECT, RESOURCE, INSERT ANY TABLE, UPDATE ANY TABLE,
			DELETE ANY TABLE TO user2;

ALTER USER user1 quota 10M ON USERS;
ALTER USER user2 quota 10M ON USERS;

/* 어떤 계정으로 접속했는지 가지고 있는 테이블로도 확인 가능 */
SELECT * FROM USER_TABLES;

/* USER1 에서 샘플용 테이블 생성 */
CREATE TABLE SAMPLE(
	   ID NUMBER PRIMARY KEY
	 , NAME VARCHAR2(50)
);

INSERT INTO SAMPLE VALUES(1, 'sample');
INSERT INTO SAMPLE VALUES(2, 'table');
INSERT INTO SAMPLE VALUES(3, 'data');

/* SAMPLE 테이블의 비공개 동의어 생성 (CREATE SYNONYM 권한 필요함) */
CREATE SYNONYM SAM FOR SAMPLE;
-- user1 에 CREATE SYNONYM 권한 부여해야함.
SELECT * FROM SAMPLE;
/* 동의어로 테이블 조회 */
SELECT * FROM SAM;

-- ---> user1 계정에서는 당연히 사용 가능

/* 관리자 권한 계정에서는 사용자명.계정명을 통한 접근 가능 */
SELECT * FROM USER1.SAMPLE;
SELECT * FROM USER1.SAM;

/* user2 계정에서는 사용자명.계정명 통한 접근 권한 불충분 */

SELECT * FROM USER1.SAMPLE;
SELECT * FROM USER1.SAM;

/* user1 계정에서 user2 계정에 권한 부여하기 */
-- 참고로, user2 계정에 SAMPLE 또는 SAM 권한만 줘도 SAMPLE 및 SAM 테이블 모두 접근 가능함.
--       (둘 중에 하나만 적용하면 됨.)
GRANT SELECT ON SAMPLE TO USER2;
GRANT SELECT ON SAM TO USER2;

SELECT * FROM USER1.SAMPLE;
SELECT * FROM USER1.SAM;

/* 비공개 동의어의 경우에는 반드시 사용자명.테이블명 형식으로만 접근 가능함.*/
SELECT * FROM SAMPLE;
SELECT * FROM SAM;

/* user2의 권한 제거 */
-- user2 계정에 SAMPLE 또는 SAM 권한만 제거해도 SAMPLE 및 SAM 테이블 모두 접근 불가능함.
--       (둘 중에 하나만 적용하면 됨.)
REVOKE SELECT ON SAMPLE FROM USER2;

SELECT * FROM USER1.SAMPLE;
SELECT * FROM USER1.SAM;

/* 공개동의어 테스트를 위한 테이블 생성 : user1 에서 생성할 것*/
CREATE TABLE PUBLIC_SAMPLE(
	   ID NUMBER PRIMARY KEY
	 , NAME VARCHAR2(50)
);

INSERT INTO PUBLIC_SAMPLE VALUES(1, 'sample');
INSERT INTO PUBLIC_SAMPLE VALUES(2, 'table');
INSERT INTO PUBLIC_SAMPLE VALUES(3, 'data');

/* 공개 동의어는 관리자 계정에서 작업해야 함. */
CREATE PUBLIC SYNONYM PSAM FOR USER1.PUBLIC_SAMPLE;


SELECT * FROM PUBLIC_SAMPLE;
SELECT * FROM PSAM; 
/* 공개 동의어를 관리자계정에서 만들어주면 사용자명 없이 조회가능 */

/* user1에서 user2에 조회권한 부여 */
-- user2 계정에 PUBLIC_SAMPLE 또는 PSAM 권한만 줘도
-- PUBLIC_SAMPLE 및 PSAM 테이블 모두 접근 가능하며,(둘 중에 하나만 적용하면 됨.)
-- 비공개 동의어 접근과 달리 사용자명. 없이 접근 가능함.
GRANT SELECT ON PUBLIC_SAMPLE TO USER2;
GRANT SELECT ON PSAM TO USER2;

/* user2에서 공개동의어로 접근 가능 : USER1과 같은 사용자명 스키마가 필요없이 조회 가능 */
SELECT * FROM PSAM;
SELECT * FROM PUBLIC_SAMPLE;

/* 동의어 생성 정보 조회 : 공개, 비공개 동의어 확인 */
-- PUBLIC : 공개 동의어 / 사용자명 : 비공개 동의어, 
SELECT * FROM ALL_SYNONYMS WHERE TABLE_OWNER = 'USER1';

/* 다른 사용자에게 부여 또는 부여 받은 권한 정보 확인 가능 */
SELECT * FROM USER_TAB_PRIVS;
