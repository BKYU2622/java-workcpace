-----------------------------------------------------------------------------------

-- 테이블 삭제
DROP TABLE EMPLOYEE_TBL;
DROP TABLE DEPARTMENT_TBL;
-- DEPARTMENT_TBL 테이블 생성
CREATE TABLE DEPARTMENT_TBL (
    DEPT_NO   NUMBER            NOT NULL,
    DEPT_NAME VARCHAR2(15 BYTE) NOT NULL,
    LOCATION  VARCHAR2(15 BYTE) NOT NULL
);
-- EMPLOYEE_TBL 테이블 생성
CREATE TABLE EMPLOYEE_TBL (
    EMP_NO    NUMBER            NOT NULL,
    NAME      VARCHAR2(20 BYTE) NOT NULL,
    DEPART    NUMBER            NULL,
    POSITION  VARCHAR2(20 BYTE) NULL,
    GENDER    CHAR(2 BYTE)      NULL,
    HIRE_DATE DATE              NULL, 
    SALARY    NUMBER            NULL
);
-- 기본키
ALTER TABLE DEPARTMENT_TBL
    ADD CONSTRAINT PK_DEPT PRIMARY KEY(DEPT_NO);
ALTER TABLE EMPLOYEE_TBL
    ADD CONSTRAINT PK_EMP PRIMARY KEY(EMP_NO);
-- 외래키
ALTER TABLE EMPLOYEE_TBL
    ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY(DEPART) 
        REFERENCES DEPARTMENT_TBL(DEPT_NO)
            ON DELETE SET NULL;
-- 시퀀스(번호 생성기) 삭제하기
DROP SEQUENCE DEPARTMENT_SEQ;
-- 시퀀스(번호 생성기) 만들기
CREATE SEQUENCE DEPARTMENT_SEQ
    INCREMENT BY 1  -- 1씩 증가하는 번호를 만든다.(생략 가능)
    START WITH 1    -- 1부터 번호를 만든다.(생략 가능)
    NOMAXVALUE      -- 번호의 상한선이 없다.(생략 가능)  MAXVALUE 100 : 번호를 100까지만 생성한다.
    NOMINVALUE      -- 번호의 하한선이 없다.(생략 가능)  MINVALUE 100 : 번호의 최소값이 100이다.
    NOCYCLE         -- 번호 순환이 없다.(생략 가능)      CYCLE : 번호가 MAXVALUE에 도달하면 다음 번호는 MINVALUE이다.
    NOCACHE         -- 메모리 캐시를 사용하지 않는다.    CACHE : 메모리 캐시를 사용한다.(사용하지 않는 것이 좋다.)
    ORDER           -- 번호 건너뛰기가 없다.             NOORDER : 번호 건너뛰기가 가능하다.
;
-- 시퀀스에서 번호 뽑는 함수 : NEXTVAL
-- SELECT DEPARTMENT_SEQ.NEXTVAL FROM DUAL;  -- 오라클에서는 테이블에 없는 데이터를 조회하려면 DUAL 테이블을 사용한다.
-- 데이터 입력하기(Parent Key를 먼저 입력해야 한다.)
INSERT INTO DEPARTMENT_TBL(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPARTMENT_SEQ.NEXTVAL, '영업부', '대구');
INSERT INTO DEPARTMENT_TBL(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPARTMENT_SEQ.NEXTVAL, '인사부', '서울');
INSERT INTO DEPARTMENT_TBL(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPARTMENT_SEQ.NEXTVAL, '총무부', '대구');
INSERT INTO DEPARTMENT_TBL(DEPT_NO, DEPT_NAME, LOCATION) VALUES(DEPARTMENT_SEQ.NEXTVAL, '기획부', '서울');
COMMIT;
-- 시퀀스 삭제하기
DROP SEQUENCE EMPLOYEE_SEQ;
-- 시퀀스 만들기
CREATE SEQUENCE EMPLOYEE_SEQ
    START WITH 1001
    NOCACHE;
-- 데이터 입력하기
INSERT INTO EMPLOYEE_TBL VALUES(EMPLOYEE_SEQ.NEXTVAL, '구창민', 1, '과장', 'M', '95-05-01', 5000000);
INSERT INTO EMPLOYEE_TBL VALUES(EMPLOYEE_SEQ.NEXTVAL, '김민서', 1, '사원', 'M', '17-09-01', 2500000);
INSERT INTO EMPLOYEE_TBL VALUES(EMPLOYEE_SEQ.NEXTVAL, '이은영', 2, '부장', 'F', '90/09/01', 5500000);
INSERT INTO EMPLOYEE_TBL VALUES(EMPLOYEE_SEQ.NEXTVAL, '한성일', 2, '과장', 'M', '93/04/01', 5000000);
COMMIT;

SELECT * FROM EMPLOYEE_TBL ;
SELECT * FROM DEPARTMENT_TBL; 

-- EMPLOYEE_TBL, DEPARTMENT_TBL 생성 후 1~3번 문제를 해결하시오.
--1. 부서번호가 2인 부서에 근무하는 사원들의 직급과 일치하는 사원을 조회하시오. (10점)
SELECT E.NAME 사원명
	FROM EMPLOYEE_TBL E INNER JOIN DEPARTMENT_TBL D
	ON E.POSITION = D.DEPT_NO
	WHERE D.DEPT_NO = 2;  

--2.  부서번호(DEPT_NO)가 1인 부서의 지역(LOCATION)을 '경기'로 수정하시오. (10점)
UPDATE DEPARTMENT_TBL
	SET LOCATION = '경기'
	WHERE DEPT_NO = 1;

--3. 사원테이블(EMPLOYEE_TBL)을 사원번호 순으로 정렬하여 2 ~ 3 사이의 직원을 조회하시오. (ROWNUM 사용)  (10점)
SELECT ROWNUM , NAME 
	FROM EMPLOYEE_TBL
 	WHERE ROWNUM BETWEEN 2 AND 3
 	ORDER BY EMP_NO;

----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 4.

PRODUCT 테이블의 모든 칼럼을 복사하여 NEW_PRODUCT이라는 이름의 새 테이블을 생성하는 쿼리문을 작성하시오. (10점)

데이터(행, ROW)는 복사되지 않고 칼럼만 복사되도록 작성하시오.

복사되지 않는 제약조건은 신경쓰지 마시오. (10점)
*/
CREATE TABLE NEW_PRODUCT
    AS (SELECT * FROM PRODUCTS WHERE 1=2);
 
5.
/*
다음 지시사항의 대상 테이블과 대상 칼럼 정보를 이용해서 새로운 뷰(VIEW)를 생성하는 쿼리문을 작성하시오. (10점)

    1) 대상 테이블 : PRODUCT

    2) 대상 칼럼 : PRODUCT_NAME, PRODUCT_PRICE

    3) 뷰 이름 : V_PRODUCT
 */
CREATE VIEW V_PRODUCT AS (SELECT PROD_NAME, PROD_PRICE FROM PRODUCTS);
 

SELECT * FROM EMPLOYEE_TBL ;
SELECT * FROM DEPARTMENT_TBL;
--6. 부서번호(DEPART)가 1인 부서에 근무하는 사원들의 급여(SALARY)를 500000원 증가시키시오. (10점)
UPDATE EMPLOYEE_TBL
	SET SALARY = SALARY + 500000
	WHERE DEPART = 1;
	

 

--7. 현재 ADMIN 이라는 계정이 잠겨있다고 가정할 때 해당 계정을 사용할 수 있도록 잠금을 풀고  패스워드를 설정하는 DCL문을 작성하시오. (10점)
ALTER USER ADMIN ACCOUNT UNLOCK;
ALTER USER ADMIN IDENTIFIED BY (PASSWORD);
/*
 * 
 * 8.

다음과 같은 관계를 가진 테이블이 있다고 가정하고 문제에서 요구하는 올바른 쿼리문 2개를 모두 작성하시오. (각 5점, 총 10점)
*/
SELECT D.DEPTNAME
	FROM DEPATMENT D JOIN EMPLOYEE E
	ON D.DEPTID = E.DEPTID 
	WHERE MAX(SALARY);

SELECT E.EMPID, E.EMPNAME, E.SALARY 
	FROM DEPARTMENT D JOIN EMPLOYEE E 
	ON D.DEPTID = E.DEPTID
	WHERE D.DPTID = (SELECT DEPTID
					 FROM DEPARTMENT
					 WHERE DEPTNAME = '총무부');
/*
9.

다음 칼럼 정보를 참고하여 BOARD_TBL 테이블을 생성하는 쿼리문을 작성하시오. (10점)

<< 칼럼 정보 >>

    1) BOARD_NO : 글번호, 숫자, 필수, 기본키(제약조건이름 : PK_BOARD)

    2) TITLE : 글제목, 가변길이문자열 최대 1000바이트, 필수

    3) CONTENT : 글내용, 가변길이문자열 최대 4000바이트

    4) HIT : 조회수, 숫자

    5) CREATE_DATE : 작성일, 날짜
*/ 

CREATE TABLE BOARD_TBL(
	BOARD_NO	NUMBER NOT NULL,
	TITLE		VARCHAR2(1000) NOT NULL,
	CONTENT		VARCHAR2(4000),
	HIT			NUMBER,
	CREATE_DATE DATE
	);


--10.어떤 테이블에 삽입, 수정, 삭제된 행(ROW) 정보를 실제로 DB에 반영하기 위해서 사용하는 
--쿼리문과 변경전 상태로 돌아가기 위해 사용하는 쿼리문을 쓰오. (10점)
COMMIT;
ROLLBACK;

