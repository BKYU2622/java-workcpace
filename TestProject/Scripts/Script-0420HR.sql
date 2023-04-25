/*
    EXIT : 반복문 종료하기
    CONTINUE : 반복문을 LOOP문의 시작부터 다시 실행하기
*/

-- 1부터 정수값을 누적하시오. 누적값이 100을 초과하면 누적을 멈추고 어디까지 누적했는지 출력하시오.
DECLARE
    N       NUMBER;
    TOTAL   NUMBER;
BEGIN
    N     :=1;
    TOTAL := 0;
    WHILE TRUE LOOP
        IF TOTAL > 100 THEN
            EXIT;
        END IF;
        TOTAL := TOTAL + N;
        N := N + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1부터 '|| N ||'까지 합은' || TOTAL || '입니다.');
END;
/

/*
    예외처리 구문
    
    EXCEPTION
        WHEN 예외종류 THEN
             예외처리
        WHEN 예외종류 THEN
             예외처리
        WHEN OTHERS THEN
             예외처리
*/

DECLARE
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME
      INTO FNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 0;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
           DBMS_OUTPUT.PUT_LINE('조회된 데이터가 없습니다.');
END;
/

DECLARE
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME
      INTO FNAME
      FROM EMPLOYEES
     WHERE DEPARTMENT_ID = 50;
    EXCEPTION 
      WHEN TOO_MANY_ROWS THEN
           DBMS_OUTPUT.PUT_LINE('조회된 데이터가 2개이상입니다.');
           DBMS_OUTPUT.PUT_LINE(FNAME);
END;
/

DECLARE
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME
      INTO FNAME
      FROM EMPLOYEES
     WHERE DEPARTMENT_ID = 50;
    EXCEPTION 
      WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE(SQLCODE);
           DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-----------------------------------15장 
/*
    프로시저(PROCEDURE), 스토어드 프로시저(STORED PROCEDURE)라고도 부름.
    1.하나의 프로시저에 여러개의 쿼리문을 작성해서 처리할 수 있음.
    2.여러 개의 쿼리문이 필요한 서비스를 프로시저로 작성해 두면 편리함.
      (EX:  은행 이체(UPDATE 쿼리가 2개로 구성)
    3.형식
      CREATE [OR REPLACE] PROCEDURE 프로시저명[(매개변수)]
      IS  -- AS도 가능
        변수선언
      BEGIN
          본문
        [EXCEPTION
          예외처리]
      END;
    4. 작성된 프로시저는 EXECUTE 프로시저명(); 형식으로 실행함.
*/

-- 프로시저1  정의(만들기)
CREATE OR REPLACE PROCEDURE PROC1
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO PROCEDURE');
END;
/
EXECUTE PROC1();

-- 프로시저2 정의(만들기) : 사원번호가 100인 사원의 FIRST_NAME,LAST_NAME,SALARY를 조회하는 프로시저
CREATE OR REPLACE PROCEDURE PROC2
AS
    FNAME       EMPLOYEES.FIRST_NAME%TYPE;
    LNAME       EMPLOYEES.LAST_NAME%TYPE;
    SAL         EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, SALARY
      INTO FNAME,LNAME,SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
     DBMS_OUTPUT.PUT_LINE(FNAME||','||LNAME||','||SAL);
END;
/
EXEC PROC2();

-- 프로시저3 정의(만들기) : 사원번호를 매개변수로 전달해서 
--                   해당 사원의 FIRST_NAME,LAST_NAME,SALARY를 조회하는 프로시저
-- 1. 프로시저로 값을 전달할 때 입력파라미터를 사용함.
-- 2. 형식 : 변수명 IN 타입

CREATE OR REPLACE PROCEDURE PROC3(EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE)
AS
    FNAME       EMPLOYEES.FIRST_NAME%TYPE;
    LNAME       EMPLOYEES.LAST_NAME%TYPE;
    SAL         EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, SALARY
      INTO FNAME,LNAME,SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
     DBMS_OUTPUT.PUT_LINE(FNAME||','||LNAME||','||SAL);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('조회된 사원이 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
END;
/
EXEC PROC3(101);

-- 프로시저4 정의(만들기)
-- 사원번호가 100사원의 FIRST_NAME, LAST_NAME을 출력 파라미터로 변화하는 프로시저

-- 출력파라미터
-- 1. 프로시저의 실행결과를 저장하는 변수
-- 2. 형식: 변수 OUT타입
-- 프로시저4 정의(만들기)
-- 사원번호가 100사원의  FIRST_NAME,LAST_NAME을 출력 파라미터로 반화하는 프로시저

-- 출력파라미터
-- 1. 프로시저의 실행결과를 저장하는 변수
-- 2. 형식 : 변수 OUT 타입
CREATE PROCEDURE PROC4(FNAME OUT EMPLOYEES.FIRST_NAME%TYPE,LNAME OUT EMPLOYEES.LAST_NAME%TYPE)
IS
BEGIN
    SELECT FIRST_NAME, LAST_NAME
      INTO FNAME, LNAME          -- 출력 파라미터에 조회된 값이 입력됨.
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = 100;
END;
/

-- PROC4 호출(실행하기)
-- FNAME, LNAME값을 저장할 변수를 선언한 뒤, 프로시저에 전달해야함.
DECLARE
    FNAME       EMPLOYEES.FIRST_NAME%TYPE;
    LNAME       EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    PROC4(FNAME,LNAME);  -- PL/SQL내부에서 프로시저를 호출할 때는 EXECUTE를 생략해야 함.
    DBMS_OUTPUT.PUT_LINE(FNAME||','||LNAME);
END;
/

-- 프로시저5: 사원번호를 전달하면 해당 사원의 FIRST_NAME과 LAST_NAME이 출력 파라미터 FNAME, LNAME에 저장되도록 작성
-- 없는 사원번호가 전달되면 출력 파라미터 FNAME에 '없는 사원번호'가 저장되도록 작성
-- 실행 예시
-- PROC5(100, FNAME): 사원번호 100은 Steven입니다.
-- PROC5(0, FNAME): 사원번호 0은 없는 사원번호입니다.
-- 프로시저5 : 사원번호를 전달하면 해당 사원의 FIRST_NAME과 LAST_NAME이 출력 파라미터 FNAME, LNAME에 저장되도록 작성.
-- 없는 사원번호가 전달되면 출력파라미터 FNAME에 '없는 사원번호'이 저장되도록 작성.
-- 실행 예시
-- PROC5(100,FNAME) : 사원번호 100은 Steven입니다.
-- PROC5(0,FNAME) : 사원번호 0은 없는 사원번호입니다.
CREATE OR REPLACE PROCEDURE PROC5
(
    EMP_ID      IN      EMPLOYEES.EMPLOYEE_ID%TYPE,
    FNAME       OUT     EMPLOYEES.FIRST_NAME%TYPE,
    LNAME       OUT     EMPLOYEES.LAST_NAME%TYPE
)
IS
BEGIN
    SELECT FIRST_NAME,LAST_NAME
      INTO FNAME,LNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        FNAME := '없는 사원번호';
        EMP_NO := EMP_ID;
END;
/

DECLARE
    FNAME       EMPLOYEES.FIRST_NAME%TYPE;
    LNAME       EMPLOYEES.LAST_NAME%TYPE;
    EMP_ID		EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN
    PROC5(110, FNAME, LNAME, EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원번호'||EMP_ID||'은/는'||FNAME||','||LNAME||'입니다.');
END;
/

----------------------------------------------------------------------------------
--프로시저 연습 1개, 사용자함수, 트리거

/*
    프로시저 연습
    1. BUY_PROC 프로시저 구현하기
    2. 처리할 일
        1) 구매내역 테이블에 구매 내역을 추가(INSERT)한다.
        2) 제품 테이블의 재고 내역을 수정(UPDATE)한다.
        3) 고객 테이블의 포인트를 수정(UPDATE)한다.
*/

-- 테이블 삭제하기
DROP TABLE BUY_TBL;
DROP TABLE CUST_TBL;
DROP TABLE PROD_TBL;

--  시퀀스 삭제하기
DROP SEQUENCE BUY_SEQ;

-- 제품 테이블 구성하기
CREATE TABLE PROD_TBL (
    /*  */ P_CODE NUMBER NOT NULL,
    /*  */ P_NAME VARCHAR2(20 BYTE),
    /*  */ P_PRICE NUMBER,
    /*  */ P_STOCK NUMBER
);
ALTER TABLE PROD_TBL
    ADD CONSTRAINT PK_PROD PRIMARY KEY(P_CODE);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1000, '홈런볼', 1000, 100);
INSERT INTO PROD_TBL(P_CODE, P_NAME, P_PRICE, P_STOCK) VALUES(1001, '맛동산', 2000, 100);
COMMIT;

-- 고객 테이블 구성하기
CREATE TABLE CUST_TBL (
    C_NO NUMBER NOT NULL,
    C_NAME VARCHAR2(20 BYTE),
    C_POINT NUMBER
);
ALTER TABLE CUST_TBL
    ADD CONSTRAINT PK_CUST PRIMARY KEY(C_NO);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(1, '정숙', 0);
INSERT INTO CUST_TBL(C_NO, C_NAME, C_POINT) VALUES(2, '재홍', 0);
COMMIT;

-- 구매 테이블 구성하기
CREATE TABLE BUY_TBL (
    B_NO NUMBER NOT NULL,
    C_NO NUMBER NOT NULL,
    P_CODE NUMBER,
    B_AMOUNT NUMBER
);
ALTER TABLE BUY_TBL
    ADD CONSTRAINT PK_BUY PRIMARY KEY(B_NO);
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_CUST FOREIGN KEY(C_NO)
        REFERENCES CUST_TBL(C_NO)
            ON DELETE CASCADE;
ALTER TABLE BUY_TBL
    ADD CONSTRAINT FK_BUY_PROD FOREIGN KEY(P_CODE)
        REFERENCES PROD_TBL(P_CODE)
            ON DELETE SET NULL;

CREATE SEQUENCE BUY_SEQ
    NOCACHE;
   
/*
    프로시저 연습
    1. BUY_PROC 프로시저 구현하기
    2. 처리할 일
        1) 구매내역 테이블에 구매 내역을 추가(INSERT)한다.
        2) 제품 테이블의 재고 내역을 수정(UPDATE)한다.
        3) 고객 테이블의 포인트를 수정(UPDATE)한다.
*/
   
-- BUY_PROC 프로시저 정의

CREATE OR REPLACE PROCEDURE BUY_PROC
(
    CNO         IN CUST_TBL.C_NO%TYPE,   --고객번호
    PCODE       IN PROD_TBL.P_CODE%TYPE, --제품코드
    BUY_AMOUNT  IN BUY_TBL.B_AMOUNT%TYPE --구매수량
)
IS
BEGIN
    --1) 구매내역 테이블에 구매내역을 추가(INSERT)한다.
    INSERT INTO BUY_TBL(B_NO,C_NO,P_CODE,B_AMOUNT) VALUES(BUY_SEQ.NEXTVAL,CNO,PCODE,BUY_AMOUNT);
    
    --2) 제품 테이블의 재고내역을 수정(UPDATE)한다.
    UPDATE PROD_TBL SET P_STOCK = P_STOCK - BUY_AMOUNT WHERE P_CODE = PCODE;
    
    --3) 고객테이블의 포인트를 수정(UPDATE)한다.
    -- 총 구매액의 10%를 정수로 올림처리(CEIL)해서 포인트를 부여한다.
    UPDATE CUST_TBL 
       SET C_POINT = C_POINT + CEIL((SELECT P_PRICE
                                       FROM PROD_TBL
                                      WHERE P_CODE = PCODE) * BUY_AMOUNT * 0.1)
     WHERE C_NO = CNO;   
     
     -- 커밋
     COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외가 발생했습니다.');
        ROLLBACK;
END;
/

-- BUY_PROC 프로시저 호출

EXECUTE BUY_PROC(1,1000,10);
EXECUTE BUY_PROC(2,1001,20);
EXECUTE BUY_PROC(1,1000,20);

SELECT * FROM BUY_TBL;
SELECT * FROM PROD_TBL;
SELECT * FROM CUST_TBL;
   
-----------------------------------------------------------------------------------
/*
   사용자 함수(FUNCTION)  
 	1. 어떤 값을 반환할 때 사용하는 데이터베이스 객체
 	2. 실제로 함수를 만들어서 사용하는 개념
 	3. RETURN 개념이 존재한다
 	4. 함수의 결과값을 확인할 수 있도록 SELECT문에서 많이 사용한다
 	5. 형식
 		CREATE OR REPLACE FUNCTION 함수명[(매개변수)]
 		RETURN 반환타입
 		IS -- AS도 가능
 			변수선언
 		BEGIN
 			함수본문
 		[EXCEPTION
 			예외처리]
 		END;
 		/
 */

-- 사용자 함수 FUNC1 정의 
CREATE OR REPLACE FUNCTION FUNC1
RETURN VARCHAR2 -- 반환타입에는 크기를 명시하지 않음
IS -- AS가능
BEGIN 
	RETURN 'HELLO FUNCTION';
END;
/

SELECT FUNC1() FROM DUAL;

-- 사용자 함수 FUNC2 정의
-- 사원번호를 매개변수로 전달하면 해당 사원의 FULLNAME(Steven King)을 반환하는 함수

-- 사용자 함수의 파라미터는 IN/OUT 표시가 없음
-- 입력 파라미터 형식으로 사용된다
CREATE OR REPLACE FUNCTION FUNC2(EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
RETURN VARCHAR2
IS
    FNAME   EMPLOYEES.FIRST_NAME%TYPE;
    LNAME   EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME,LAST_NAME
      INTO FNAME,LNAME
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
    
    RETURN FNAME||' '||LNAME;
END;
/

-- 사용자 함수 FUNC2 호출
SELECT EMPLOYEE_ID, FUNC2(EMPLOYEE_ID)
  FROM EMPLOYEES;
 
 -- 사용자 함수 FUNC3 정의
 -- 사원번호를 전달했을 때, 해당 사원의 연봉이 15000이상이면 '고액연봉', 아니면 '보통연봉'을 반환하나는 함수
CREATE OR REPLACE FUNCTION FUNC3(EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE)
RETURN VARCHAR2
IS
    SAL     EMPLOYEES.SALARY%TYPE;
    MESSAGE VARCHAR2(12);
BEGIN
    SELECT SALARY
      INTO SAL
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
     
     IF SAL >= 15000 THEN
        MESSAGE := '고액연봉';
     ELSE
        MESSAGE := '보통연봉';
     END IF;
     
     RETURN MESSAGE;
END;
/

-- 사용자 함수 FUNC3 호출

SELECT EMPLOYEE_ID, FUNC2(EMPLOYEE_ID), SALARY, FUNC3(EMPLOYEE_ID)
  FROM EMPLOYEES;
  
 -- ************ PL/SQL문, 사용자 함수(FUNCTION)은 디비버에서 보다 오라클에서 실행하는게 오류 안 나옴