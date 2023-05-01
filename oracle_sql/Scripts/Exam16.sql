/*
 * PROCEDURE
 *     - PL/SQL 구문을 PROCEDURE 객체로 만들어 재사용할 수 있도록 한다.
 *     - EXEC 명령어로 함수와 비슷하게 사용할 수 있다.
 *     - 외부 값을 프로시져 내부에 전달하거나 프로시져 내부에서 생성된
 *       값을 외부에 반환하는 형식을 작성할 수 있다.
 */

/*
 * 프로시져 생성 및 실행
 */
CREATE OR REPLACE PROCEDURE PROC_SAMPLE1
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('프로시져 동작!!!');
END;

/* SQLPlus 에서 실행하는 명령어 */ 
EXEC PROC_SAMPLE1;

/* SQLPlus 외의 도구에서 실행하는 방법 */
BEGIN
    PROC_SAMPLE1;
END;


/*
 * 프로시져에서 변수 선언
 */
CREATE OR REPLACE PROCEDURE PROC_SAMPLE2
IS
    N NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE(N);
END;

/*
 * 외부에서 값 전달받기
 */
CREATE OR REPLACE PROCEDURE PROC_SAMPLE3(X IN NUMBER, Y IN VARCHAR2)
IS
    N NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE(N + X);
    DBMS_OUTPUT.PUT_LINE(Y);
END;

BEGIN
    PROC_SAMPLE3(5, 'Hello Procedure');
END;


/*
 * 외부로 값 내보내기
 */
CREATE OR REPLACE PROCEDURE PROC_SAMPLE4(X OUT NUMBER)
IS
BEGIN
    X := 10;
    DBMS_OUTPUT.PUT_LINE('내보낼 값을 변수에 저장');
END;

/*
 * SQLplus 에서 실행 할 때에는 다음의 방법을 사용한다.
 * 
 * VARIABLE NUM NUMBER;
 * EXEC PROC_SAMPLE4(:NUM);
 * PRINT NUM;
 */

DECLARE
    NUM NUMBER;
BEGIN
    PROC_SAMPLE4(NUM);
    DBMS_OUTPUT.PUT_LINE('프로시져 실행 결과로 ' || NUM || ' 를 받았습니다.');
END;




CREATE OR REPLACE PROCEDURE PROC_SAMPLE5(
       NUM1 IN NUMBER
     , NUM2 IN NUMBER
     , RES OUT NUMBER
)
IS
BEGIN
    RES := NUM1 + NUM2;
    DBMS_OUTPUT.PUT_LINE('실행이 완료되었습니다.');
END;

DECLARE
   RES NUMBER;
BEGIN
    PROC_SAMPLE5(10, 20, RES);
    DBMS_OUTPUT.PUT_LINE('실행 결과: ' || RES);
END;







SELECT * FROM USER_ERRORS;
SELECT * FROM USER_PROCEDURES;