-----------------------------------14장 PL/SQL
/*
   PL/SQL(PROCEDURAL LANGUAGE/SQL)
   1. 오라클 전용 문법이고 프로그래밍 처리가 가능하다.
   2. 형식
      [DECLARE
            변수 선언]
       BEGIN
       		수행할 PL/SQL
       END;
       / 
   3. 변수에 지정된 값을 출력하기 위해서 서버 출력을 활성화해야 함(기본값 OFF)
	  SET SERVEROUTPUT ON
 */
-- 서버출력 활성화
SET SERVEROUT ON;  -- 디비버에서는 CMD창에서 해줘야 함 

-- 서버출력 확인
BEGIN 
	DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

/*
   테이블 복사하기
   1. CREATE TABLE과 복사할 데이터의 조회(SELECT)를 이용한다.
   2. PK와 FK제약조건은 복사되지 않는다.
   3. 복사하는 쿼리 
   	1) 데이터 복사하기 
   	   CREATE TABLE 테이블 AS(SELECT 컬럼 FROM 테이블);
    2) 데이터를 제외하고 구조만 복사하기(컬럼만 복사)
       CREATE TABLE 테이블 AS(SELECT 컬럼 FROM 테이블 WHERE 1=2);

-- ORACLE 11g의 HR계정 활성화하기
 - SQLPLUS를 이용해서 SYS계정으로 로그인
   SQLPLUS / AS SYSDBA
 - 잠겨있는 HR계정 활성화
   ALTER USER HR ACCOUNT UNLOCK;
 - HR계정에 비밀번호 설정 / 비밀번호는 대소문자 따짐
   ALTER USER HR IDENTIFIED BY 1234;

   HR계정의 EMPLOYEES 테이블을 SCOTT계정으로 복사한 후 실습
   SCOTT 계정에게 HR계정의 EMPLOYEES 테이블을 SELECT 할 수 있는 권한 부여
   HR계정에서 다음 명령으로 권한 부여
   GRANT SELECT ON EMPLOYEES TO SCOTT;
 */

CREATE TABLE EMPLOYEES
      AS (SELECT *
            FROM HR.EMPLOYEES);

SELECT * FROM EMPLOYEES;

-- EMPLOYEES 테이블에 PK 생성하기
ALTER TABLE EMPLOYEES ADD CONSTRAINT PK_EMPLOYEE PRIMARY KEY(EMPLOYEE_ID);

/*
   변수 선언하기 
   1. 대입연산자(:=)를 사용한다.
   2. 종류
    1) 스칼라변수: 타입을 직접 지정.
    2) 참조변수: 특정 컬럼의 타입을 참조하여 지정한다.
    3) 레코드변수: 2개 이상의 컬럼을 합쳐서 하나의 타입으로 지정.
    4) 행변수: 행 전체 데이터를 저장한다.    
 */
-- 1. 스칼라변수: 직접 타입 명시
DECLARE 
	NAME VARCHAR2(10);
	AGE NUMBER(3);
BEGIN
	NAME:='홍길동';
	AGE:=30;
	DBMS_OUTPUT.PUT_LINE('이름은 '|| NAME || '입니다.');
	DBMS_OUTPUT.PUT_LINE('나이는 '|| AGE ||'입니다');
END;
/

/*
--2. 참조변수
	특정 칼럼의 타입을 그대로 사용하는 변수
	SELECT절의 INTO를 이용해서 테이블의 데이터를 가져와서 변수에 저장할 수 있음
	선언방법: 변수명 테이블명.칼럼명%TYPE
*/

DECLARE
	FNAME EMPLOYEES.FIRST_NAME%TYPE;
	LNAME EMPLOYEES.LAST_NAME%TYPE;
	SAL	EMPLOYEES.SALARY%TYPE;
BEGIN
	SELECT FIRST_NAME, LAST_NAME, SALARY	--SELECT에서 조회된 값을
	INTO FNAME, LNAME, SAL					--아래의 변수명에서 받고
	FROM EMPLOYEES
	WHERE EMPLOYEE_ID = '100';
	DBMS_OUTPUT.PUT_LINE(FNAME || ',' || LNAME || ',' || SAL);--받은걸 출력하겠다.
END;
/

/*
  3. 레코드 변수 / 자바에서 ARRAY 타입이랑 비슷함
  2개 이상의 칼럼값을 동시에 저장하는 변수
  레코드변수 정의(만들기)와 레코드변수 선언으로 구분하여 작성.
*/

DECLARE
	-- 레코드변수 정의하기 / ;이 아닌 ,으로 해야 함
	TYPE MY_RECORD_TYPE IS RECORD ( --타입명: MY_RECORD_TYPE
	 	 FNAME EMPLOYEES.FIRST_NAME%TYPE,
		 LNAME EMPLOYEES.LAST_NAME%TYPE,
		 SAL	EMPLOYEES.SALARY%TYPE
	);
	-- 레코드변수 선언하기
	EMP MY_RECORD_TYPE;
BEGIN
	SELECT FIRST_NAME, LAST_NAME, SALARY
	INTO EMP
	FROM EMPLOYEES 
	WHERE EMPLOYEE_ID = 100;
	DBMS_OUTPUT.PUT_LINE(EMP.FNAME || ',' || EMP.LNAME || ',' || EMP.SAL);
END;
/
	
/*
   4. 행변수   
   행 전체 데이터를 지정할 수 있는 타입
   항상 행 전체 데이터를 저장해야함.
   선언 방법: 변수명 테이블명%ROWTYPE
 */

DECLARE
	EMP EMPLOYEES%ROWTYPE;
BEGIN
	SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, 
	HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID 
	INTO EMP
	FROM EMPLOYEES 
	WHERE EMPLOYEE_ID = 100;
	DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ',' 
	|| EMP.LAST_NAME || ',' || EMP.SALARY); -- 원래 컬럼명을 넣어줘야 함
END;
/

----------------------------------------------------------------------------------
/*
  -- IF 구문 
  IF 조건식 THEN
  	실행문;
  ELSIF 조건식 THEN
  	실행문;
  ELSE
  	실행문;
  END IF; 
*/
-- 성적에 다른 학점(A,B,C,D,F)출력하기
DECLARE
	SCORE NUMBER(3);
	GRADE CHAR(1);
BEGIN
	SCORE := 50;
	IF SCORE >= 90 THEN
		GRADE := 'A';
	ELSIF SCORE >= 80 THEN
		GRADE := 'B';
	ELSIF SCORE >= 70 THEN
		GRADE := 'C';
	ELSIF SCORE >= 60 THEN
		GRADE := 'D';
	ELSE
		GRADE := 'F';
	END IF;
	DBMS_OUTPUT.PUT_LINE(SCORE || '점은 ' || GRADE || '학점입니다.');
END;
/
	
--EMPLOYEE_ID가 150인 사원의 SALRAY가 15000이상이면 '고액연봉', 아니면 '보통연봉'을 출력하시오
DECLARE 
	EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
	SAL    EMPLOYEES.SALARY%TYPE;
	MESSAGE VARCHAR2(20 BYTE);
BEGIN
	EMP_ID := 150;
	SELECT SALARY
	INTO SAL
	FROM EMPLOYEES 
	WHERE EMPLOYEE_ID = EMP_ID;
	IF SAL >= 15000 THEN 
	   MESSAGE := '고액연봉';
	ELSE
	   MESSAGE := '보통연봉';
	END IF;
	DBMS_OUTPUT.PUT_LINE('사원번호' || EMP_ID || '인 사람의 연봉은 ' || 
	SAL || ' 이고' || MESSAGE || '입니다');
END;
/
	
-- EMPLOYEE_ID가 150인 사원의 COMMISSION_PCT가 0이면, '커미션 없음',
-- 있으면 실제 커미션(COMMISSION_PCT * SALARY)를 출력하시오 / TO_CHAR()
DECLARE
    EMP_ID  EMPLOYEES.EMPLOYEE_ID%TYPE;
    SAL     EMPLOYEES.SALARY%TYPE;
    COMM_PCT EMPLOYEES.COMMISSION_PCT%TYPE;
    MESSAGE VARCHAR2(20 BYTE);
BEGIN
    EMP_ID := 150;
    SELECT SALARY,COMMISSION_PCT
    INTO SAL , COMM_PCT
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = EMP_ID;
    IF COMM_PCT = 0 THEN
       MESSAGE := '커미션없음';
    ELSE
       MESSAGE := TO_CHAR(SAL*COMM_PCT);
    END IF;
    DBMS_OUTPUT.PUT_LINE('사원번호 '||EMP_ID||'인 사원의 커미션은 '||MESSAGE||'입니다.');
END;
/	

/*
   CASE 문
   CASE 
   		WHEN 조건식 THEN
   			실행문;
   		WHEN 조건식 THEN
   			실행문;
   		ELSE
   			실행문;
   END CASE;
 */
-- EMPLOYEE_ID가 150인 사원의 PHONE_NUMBER에 따른 지역을 출력하시오.
-- 011: 휴대폰 / 515: 동부 / 590: 서부 / 603: 남부 / 650: 북부
SELECT PHONE_NUMBER FROM EMPLOYEES e WHERE EMPLOYEE_ID = 150;
DECLARE
    EMP_ID   EMPLOYEES.EMPLOYEE_ID%TYPE;
    PHONE    EMPLOYEES.PHONE_NUMBER%TYPE;
    MESSAGE  VARCHAR2(10 BYTE);
BEGIN
    EMP_ID := 140;
    SELECT SUBSTR(PHONE_NUMBER,1,3)
      INTO PHONE
      FROM EMPLOYEES
     WHERE EMPLOYEE_ID = EMP_ID;
     CASE
        WHEN PHONE = '011' THEN
            MESSAGE := '휴대폰';
        WHEN PHONE = '515' THEN
            MESSAGE := '동부';
        WHEN PHONE = '590' THEN
            MESSAGE := '서부';
        WHEN PHONE = '603' THEN
            MESSAGE := '남부';
        WHEN PHONE = '650' THEN
            MESSAGE := '북부';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(PHONE || ',' ||MESSAGE);
END;
/ 

/*
   WHILE문 
   WHILE 조건식 LOOP
	   실행문;
   END LOOP;    
 */
-- 1 ~ 5까지 출력하기
DECLARE
    N NUMBER(1);
BEGIN
    N := 1;
    WHILE N <=5 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N + 1;
    END LOOP;
END;
/
-- EMPLOYEE_ID가 100~200인 사원들의 FIRST_NAME, LAST_NAME을 조회하시오.
DECLARE
    EMP_ID   EMPLOYEES.EMPLOYEE_ID%TYPE;
    FNAME    EMPLOYEES.FIRST_NAME%TYPE;
    LNAME    EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    EMP_ID := 100;
    WHILE EMP_ID <= 200 LOOP
        SELECT FIRST_NAME, LAST_NAME
          INTO FNAME, LNAME
          FROM EMPLOYEES
         WHERE EMPLOYEE_ID = EMP_ID;
         DBMS_OUTPUT.PUT_LINE(FNAME||','||LNAME);
         EMP_ID := EMP_ID + 1;
    END LOOP;
END;
/

-----------------------------------------------------------------------------------

/*
   -- FOR문
  FOR 변수 IN 시작..종료 LOOP
  	  실행문
  END LOOP;
 */
DECLARE
	N NUMBER(1);
BEGIN
	FOR N IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(N);
	END LOOP;
END;
/

-- 1~10 사이 수중에서 '짝수', '홀수', '3의 배수'를 출력하시오.
DECLARE
    N NUMBER(10);
    MODULAR NUMBER(1);  -- 나머지값
    MESSAGE VARCHAR2(10);
BEGIN
    FOR N IN 1..10 LOOP
        SELECT MOD(N,3)
          INTO MODULAR
          FROM DUAL;
        IF MODULAR = 0 THEN
          MESSAGE := '3의배수';
        ELSE
          SELECT MOD(N,2) 
            INTO MODULAR
            FROM DUAL;
          IF MODULAR = 1 THEN
            MESSAGE := '홀수';
          ELSE
            MESSAGE := '짝수';
          END IF;
        END IF;
        DBMS_OUTPUT.PUT_LINE(N||'(은/는) '||MESSAGE||'입니다.');
    END LOOP;
END;
/

-- 사원번호가 100~200사이인 사원들의 연봉 평균을 출력하시오
-- 연봉 평균: 연봉합계/사원수
DECLARE 
	EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE;
	SAL    EMPLOYEES.SALARY%TYPE;
	TOTAL  NUMBER;
	CNT    NUMBER;
BEGIN
	TOTAL := 0;
	CNT := 0;
	FOR EMP_ID IN 100..200 LOOP
		SELECT SALARY
		INTO SAL
		FROM EMPLOYEES  
		WHERE EMPLOYEE_ID = EMP_ID;
		TOTAL := TOTAL + SAL;
		CNT := CNT + 1;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('총연봉'||TOTAL||'사원수'||CNT||','||'평균연봉'||TOTAL/CNT);
END;
/
		
SELECT COUNT(*) FROM EMPLOYEES WHERE EMPLOYEE_ID BETWEEN 100 AND 200;

----------------------------------------------------------------------------------

/*
   - EMPLOYEES 테이블에서 DEPARTMENT_ID가 50인 사원들의 목록을 DEPT50 테이블로 복사하시오
	1) DEPT50 테이블 만들기(컬럼만 복사, WHERE 1=2)
	2) 행 변수로 EMPLOYEES 테이블의 정보 읽기
	3) DEPARTMENT_ID가 50이면 행 변수에 저장된 내용을 DEPT50 테이블에 INSERT 하기
*/

CREATE TABLE DEPT50
    AS (SELECT *
          FROM EMPLOYEES
         WHERE 1=2);
DECLARE
    EMP       EMPLOYEES%ROWTYPE;
    S         NUMBER(3);
    E         NUMBER(3);
    N         NUMBER(3);
BEGIN
    SELECT MIN(EMPLOYEE_ID),MAX(EMPLOYEE_ID)
      INTO S,E
      FROM EMPLOYEES;
    FOR N IN S..E LOOP
        SELECT EMPLOYEE_ID,FIRST_NAME, LAST_NAME,EMAIL,
               PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,
               MANAGER_ID,DEPARTMENT_ID
          INTO EMP
          FROM EMPLOYEES
         WHERE EMPLOYEE_ID = N;
        IF EMP.DEPARTMENT_ID = 50 THEN
           INSERT INTO DEPT50 VALUES EMP;
        END IF;
    END LOOP;
END;
/

-- 위의 문제 다른 풀이 방법
BEGIN
    FOR EMP IN (SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID 
                  FROM EMPLOYEES 
                 WHERE DEPARTMENT_ID = 50) LOOP
        INSERT INTO DEPT50 VALUES EMP;
    END LOOP;
    COMMIT;
END;

SELECT * FROM DEPT50;  