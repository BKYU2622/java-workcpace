-- ROWNUM 0414에 했었음
-- ROWNUM을 이용해서 원하는 데이터구간을 출력하려고 할 때
-- 기본적으로 ROWNUM은 할상 1부터 시작해야 출력이 됨 
SELECT ROWNUM , NAME , DEPTNO1 
	FROM STUDENT s 
	WHERE ROWNUM BETWEEN 1 AND 5;
-- 1부터 시작하지 않는 구간의 레코드를 출력하려면 인라인뷰를 이용해서 ROWNUM에 별칭을 부여하고 
-- 해당 별칭을 이용해서 구간 조회를 할 수 있다
-- ROWNUM은 별칭을 써서 출력해야 1이 아닌 부분부터 잘라서 출력 가능
SELECT *
	FROM (SELECT ROWNUM RNUM, S.*
		  FROM STUDENT s) 
		  WHERE RNUM BETWEEN 6 AND 10;
		  
------------------------------------------------------------------------------
-----------------------------------6장 DML
-- INSERT 
-- 1. DEPT2에 9002번('특수판매1팀'), 상위부터(1000) 추가
INSERT INTO DEPT2 d (DCODE , DNAME, PDEPT )VALUES ('9002','특수판매1팀','1000');
-- 2. DEPT2에 9003번('특수판매2팀'), 상위부터(1001), '임시지역' 추가 / 컬럼명 생략하고 쓴 것
INSERT INTO DEPT2 d VALUES ('9003','특수판매2팀','1001','임시지역');
-- 3. COMMIT: 데이터베이스 변경사항(입력, 수정, 삭제) 확정, COMMIT 후에는 ROLLBACK(이전 상태로 되돌림)이 안 됨
-- 데이서 변경 후에는 반드시 COMMIT 해줘야 함
COMMIT ;
ROLLBACK;
-- 4. DB구조가 자주 변경이 되는 경우 컬럼명을 기술하는 것이 안전함

-- 교수번호:5003, 이름:김삿갓, pay:350, 입사일:2021-04-29, 직책:전임강사, id:kimsg
-- 인 레코드 PROFESSOR 테이블에 추가하기(컬럼명 지정)
INSERT INTO PROFESSOR p (PROFNO, NAME, PAY, HIREDATE, POSITION, ID)
VALUES (5003,'김삿갓',350,'2021-04-29','전임강사','kismsg');

-- 교수번호:5004, 이름:김삿갓2, pay:350, 입사일:2021-04-29, 직책:전임강사, id:kimsg2
-- 인 레코드 PROFESSOR 테이블 추가하기. 컬럼명을 기술하지 않고 추가하기.
INSERT INTO PROFESSOR p 
VALUES (5004,'김삿갓2','kismsg2','전임강사',350,'2021-04-29',0,0,'','');

SELECT * FROM DEPT2 d2 ;
SELECT * FROM PROFESSOR p ;

--------------------------------------------------------------------------------
/* 
   UPDATE: 테이블의 특정컬럼의 값을 변경하고자 할 때 사용
   UPDATE의 구조
   UPDATE 테이블
   SET 컬럼 = 변경값
   WHERE 조건;
*/
-- UPDATE는 무조건 조건이 들어가야 함 / 조건이 없으면 전체가 바뀜

SELECT BONUS
  FROM PROFESSOR
 WHERE POSITION = '조교수';

UPDATE PROFESSOR
   SET BONUS = 100
 WHERE POSITION = '조교수';

--Professor 테이블에서 차범철 교수의 직급과 동일한 직급을 가진 교수들 중 현재
--급여가 250 만원이 안 되는 교수들의 급여를 15% 인상하세요.
UPDATE PROFESSOR 
	SET BONUS = BONUS * 1.15
	WHERE POSITION = (SELECT POSITION
					  FROM PROFESSOR p
					  WHERE NAME = '장해진')
	AND PAY < 300;
					  
SELECT * 
	FROM PROFESSOR p 
	WHERE POSITION = '조교수';

--교수테이블에서 보너스가 없는(0, NULL) 교수를 찾아서 50으로 수정하시오
UPDATE PROFESSOR 
	SET BONUS = 50
	WHERE BONUS = 0
	OR BONUS IS NULL ;

-----------------------------------------------------------------------------------
/*
   DELETE: 데이터 삭제시 사용
   DELETE의 구조
   DELETE FROM 테이블
   WHERE 조건
 */
DELETE FROM DEPT2 d 
	WHERE DCODE BETWEEN 9000 AND 9100;

--DEPT2 테이블 전체를 DEPT3로 복사, 즉 DEPT2와 똑같은 테이블을 DEPT3로 생성
CREATE TABLE DEPT3  
	AS SELECT * FROM DEPT2 ;
--DEPT3에서 AREA가 임시지역인 레코드 삭제하기
DELETE FROM DEPT3 
	WHERE AREA = '임시지역';

ROLLBACK;
COMMIT;

/*
   트랜잭션 관리: 연결된 데이터베이스 작업을 TRANSACTION이라고 함.
   			 2가지 이상의 SQL작업(INSERT,UPDATE,DELETE)을 하나의 TRANSACTION으로 처리해야하는 경우.
   			 해당 SQL이 모두 성공하지 않으면 ROLLBACK 처리해야 함. 모두 성공했을 때에만 COMMIT.
 */

------------------------------------------------------------------------------------
-----------------------------------7장 DDL과 DATA DICTIONARY
-- CREATE: 데이터베이스 객체(TABLE,INDEX,SEQUENCE 등)을 생성
CREATE TABLE DDL_TEST (NO NUMBER(3), NAME VARCHAR2(10), BIRTH DATE DEFAULT SYSDATE);
INSERT INTO DDL_TEST(NO,NAME) VALUES (1,'홍길동');
SELECT * FROM DDL_TEST ;

-- DDL_TEST2 테이블 생성하기
-- DDL_TEST와 같은 컬럼으로 생성, NAME의 기본값은 홍길동, BIRTH의 기본값은 2000-01-01로 설정
CREATE TABLE DDL_TEST2 (NO NUMBER(3), NAME VARCHAR2(10) DEFAULT '홍길동', BIRTH DATE DEFAULT '2000-01-01');
INSERT INTO DDL_TEST2 VALUES (2,'김삿갓',SYSDATE);
INSERT INTO DDL_TEST2 (NO) VALUES (3);
SELECT * FROM DDL_TEST2 ;

-- 한글로도 테이블 생성 가능 / 숫자도 올 수 있지만 문자가 맨처음에 와야 함 / 특수문자는 ""를 사용하면 가능
CREATE TABLE 구디아카데미 (번호 NUMBER(3), 이름 VARCHAR2(10), 전화번호 VARCHAR2(20));
SELECT * FROM 구디아카데미;

-- 새로운 컬럼 추가하기
-- ALTER: 기존 데이터베이스 객체를 변경하는 명령
CREATE TABLE DEPT6 AS SELECT DCODE , DNAME FROM DEPT2 WHERE DCODE IN(1000,1001,1002) ;
ALTER TABLE DEPT6 ADD (LOC VARCHAR2(20) DEFAULT '기타지역');

-- 테이블명 변경하는 방법
ALTER TABLE DEPT6 RENAME COLUMN LOC TO AREA;

-- 컬럼의 데이커 크기를 변경하는 방법
ALTER TABLE DEPT6 MODIFY DCODE VARCHAR2(10);

-- 컬럼 삭제하는 방법 / DROP은 
ALTER TABLE DEPT6 DROP COLUMN LOC2 ;

-- DELETE는 테이블 안에 데이터를 삭제 / TRUNCATE는 구조는 남겨놓음 / DROP은 아예 다 삭제
TRUNCATE TABLE DEPT7 ;

SELECT * FROM DEPT6 ;
DROP TABLE DEPT6; 

--------------------------------------------------------------------------------
-----------------------------------8장 제약조건

CREATE TABLE DEPT10
AS SELECT * FROM DEPT2 ; 

CREATE TABLE EMP10
AS SELECT * FROM EMP2 ;

-- DEPT10 테이블의 DCODE 칼럼을 PRIMARY KEY 설정 / PRIMARY KEY는 테이블당 한개만 설정할 수 있음
ALTER TABLE DEPT10 ADD CONSTRAINT DEPT10_DCODE_PK PRIMARY KEY(DCODE);

-- 모든 컬럼의 제약조건을 설정해서 EMP11테이블 생성
-- REFERENCES 제약조건을 위해서는 해당 테이블의 칼럼이 PRIMARY KEY 또는 UNIQUE 제약조건이 설정돼 있어야 함
CREATE TABLE EMP11(
NO NUMBER(4)
	CONSTRAINT EMP11_NO_PK PRIMARY KEY ,
NAME VARCHAR2(10)
	CONSTRAINT EMP11_NAME_NN NOT NULL,
JUMIN VARCHAR2(13)
	CONSTRAINT EMP11_JUMIN_NN NOT NULL
	CONSTRAINT EMP11_JUMIN_UK UNIQUE ,
AREA NUMBER(1)
	CONSTRAINT EMP11_AREA_CK CHECK ( AREA < 5 ),
DEPTNO VARCHAR2(6)
	CONSTRAINT EMP11_DEPTNO_FK REFERENCES DEPT10(DCODE)
) ;

INSERT INTO EMP11
	VALUES (1000, '강감찬', '111101234567', 4, 1010);
-- JUMIN값이 UNIQUE라서 중복된 값이 들어갈 수 없음 
INSERT INTO EMP11
	VALUES (1001, '강감찬', '111101234567', 4, 1010);


-- BANK TABLE 생성(COSTOMER_TBL의 부모테이블: BANK_CODE)
CREATE TABLE BANK_TBL(
BANK_CODE VARCHAR2(20) NOT NULL,
BANK_NAME VARCHAR2(30),
CONSTRAINT PK_BANK PRIMARY KEY(BANK_CODE)
) ;

-- CUSTOMER TABLE 생성 / REFERENCES 값이 없으면 오류 발생
-- 약식으로 생성하기
CREATE TABLE CUSTOMER_TBL(
NO NUMBER PRIMARY KEY,	-- = NO NUMBER CONSTRAINT PK_CUSTOMER PRIMARY KEY,
NAME VARCHAR2(20 BYTE) NOT NULL,
PHONE VARCHAR2(20) UNIQUE,
AGE NUMBER CHECK(AGE BETWEEN 1 AND 150),
BANK_CODE VARCHAR2(20) REFERENCES BANK_TBL(BANK_CODE)
) ;

/*
   테이블 변경하기
   1. 컬럼 추가: ALTER TABLE 테이블명 ADD 컬럼명 데이터타입 + [제약조건]
   2. 컬럼 삭제: ALTER TABLE 테이블명 DROP COLUMN 컬럼명
   3. 컬럼 수정: ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입 + [제약조건]
   4. 컬럼 이름 변경: ALTER TABLE 테이블명 RENAME COLUMN 기존컬럼명 TO 신규컬럼명
   5. 테이블 이름 변경: ALTER TABLE 테이블명 RENAME TP 신규테이블명
 */

-- 1. BANK_TBL 테이블에 연락처(BANK_TEL) 컬럼을 추가
ALTER TABLE BANK_TBL ADD BANK_TEL VARCHAR2(20) NOT NULL;

-- 2. CUSTOMER_TBL 테이블에서 나이(AGE) 칼럼 삭제
ALTER TABLE CUSTOMER_TBL DROP COLUMN AGE;

-- 3. BANK_TBL 테이블의 은행명(BANK_NAME) 컬럼의 데이터타입을 VARCHAR2(15 BYTE)로 변경
ALTER TABLE BANK_TBL MODIFY BANK_NAME VARCHAR2(15);

-- 4. CUSTOMER_TBL 테이블에서 고객명(NAME) 컬럼의 이름을 CUST_NAME으로 변경
ALTER TABLE CUSTOMER_TBL RENAME COLUMN NAME TO CUST_NAME;

-- 5. CUSTOMER_TBL 테이블에 GRADE 칼럼을 추가하시오.
-- GRADE 칼럼은 'VIP', 'GOLD', 'SILVER', 'BRONZE' 중 하나의 값만 가질 수 있도록 CHECK 제약조건을 지정하시오.
ALTER TABLE CUSTOMER_TBL ADD GRADE VARCHAR2(6 BYTE) 
CHECK(GRADE IN('VIP', 'GOLD', 'SILVER', 'BRONZE'));

-- 6. BANK_TBL 테이블의 BANK_NAME 칼럼에 NOT NULL 제약조건을 추가하시오.
-- 제약조건 추가는 ADD가 아닌 MODIFY / 첫 번째는 에러남
ALTER TABLE BANK_TABLE ADD CONSTRAINT BANK_TBL_BANL_NAME_NN NOT NULL(BANL_NAME);
ALTER TABLE BANK_TBL MODIFY (BANK_NAME CONSTRAINT BANK_TBL_BANK_NAME_NN NOT NULL);

-- 7. CUSTOMER_TBL 테이블의 NO 칼럼의 이름을 CUST_NO로 변경하시오.
ALTER TABLE CUSTOMER_TBL RENAME COLUMN NO TO CUST_NO;

-- 8. CUSTOMER_TBL 테이블의 PHONE 칼럼을 삭제하시오.
ALTER TABLE CUSTOMER_TBL DROP COLUMN PHONE;

-- 9. CUSTOMER_TBL 테이블의 CUST_NAME 칼럼의 NOT NULL 제약조건을 NULL 제약조건으로 변경하시오.
ALTER TABLE CUSTOMER_TBL MODIFY CUST_NAME VARCHAR2(20) NULL;


-- 기존 컬럼의 제약조건을 설정하고자 하는 경우 ADD가 아니라 MODIFY를 이용해야 함
ALTER TABLE DEPT2 ADD CONSTRAINT DEPT2_AREA_NN NOT NULL (AREA);
ALTER TABLE DEPT2 MODIFY (AREA CONSTRAINT DEPT2_AREA_NN NOT NULL);

DELETE FROM DEPT2 
	WHERE DCODE = '9002';

----------------------------------------------------------------------------------

CREATE TABLE BOOK_TBL (
BOOK_ID NUMBER(4) PRIMARY KEY,
BOOK_NAME VARCHAR2(20) NOT NULL,
BOOK_PRICE NUMBER(10)
);

CREATE TABLE ORDER_TBL(
ORDER_ID NUMBER(10) PRIMARY KEY,
ORDER_DATE DATE,
ORDER_BOOK_ID NUMBER(4)
);

-- ORFER_TBL의 ORDER_BOOK_ID가 BOOK_ID를 참조키 제약 조건을 추가하시오
-- FOREIGN KEY 추가시 주의사항: 부모테이블 컬럼에 UNIQUE나 PK 컬럼이어야 함
ALTER TABLE ORDER_TBL ADD CONSTRAINT ORDER_TBL_FK 
FOREIGN KEY(ORDER_BOOK_ID) REFERENCES BOOK_TBL(BOOK_ID); 

-- 부모테이블에 없는 데이터를 참조해서 입력하려고 할 때 참조키 제약조건에 의해서 입력이 거부됨
-- 자식테이블에서 참조하고 있는 컬럼은 반드시 부모테이블에 존재해야 함 
-- 따라서 입력 순서가 바뀌면 오류가 발생함
INSERT INTO BOOK_TBL VALUES (4000, '자바', 30000);
INSERT INTO ORDER_TBL VALUES (1001, SYSDATE, 4000);

-- 테이블에 컬럼 추가하기 
ALTER TABLE BOOK_TBL ADD TYPE NUMBER(4);
ALTER TABLE ORDER_TBL ADD ORDER_TYPE NUMBER(4) ;

-- BOOK_TBL의 TYPE 컬럼에 UNIQUE 제약조건 추가하기
ALTER TABLE BOOK_TBL ADD CONSTRAINT BOOK_TBL_UK UNIQUE(TYPE); 

-- 자식테이블에서 부모테이블의 컬럼을 참조하기 위해서는 부모테이블의 컬럼이 PRIMARY KEY이거나 UNIQUE키 이어야 함
-- FOREIGN KEY 추가시 오류 예시 / 부모테이블 컬럼에 UNIQUE나 PK 컬럼이어야 함
ALTER TABLE ORDER_TBL ADD CONSTRAINT ORDER_TBL_FK2 
FOREIGN KEY(ORDER_TYPE) REFERENCES BOOK_TBL(TYPE);

-- 제약조건 설정 확인
SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS
	FROM USER_CONSTRAINTS 
	WHERE TABLE_NAME = 'BOOK_TBL';

-- 제약조건 삭제하기 / 데이터를 삭제하는 것는 DELETE, 객체를 삭제하는 거는 DROP
-- FOREIGN KEY 삭제
ALTER TABLE ORDER_TBL
	DROP CONSTRAINT ORDER_TBL_fk2 ;

/*
ON DELETE CASCADE: 
FOREIGN KEY를 설정 후 부모 테이블 의 데이터를 지우고 싶은데 만약 
자식테이블에서 부모테이블의 해당 데이터를 참조하고 있을 경우 지울 수가 없습니다. 
이럴 경우를 대비해서 FOREIGN KEY를 생성할 때 설정함.
/부모테이블의 데이터를 삭제하면 자동으로 자식테이블의 데이터도 삭제시키는 함수
*/

-- CHECK: 지정된 값만 입력 가능
-- FOREIGN KEY: 데이터의 일관성 확인

SELECT * FROM ORDER_TBL ;
SELECT * FROM BOOK_TBL ;
SELECT * FROM CUSTOMER_TBL ;
SELECT * FROM BANK_TBL ;
SELECT * FROM EMP11 ;
SELECT * FROM DEPT10 ;
SELECT * FROM DEPT3 ;
SELECT * FROM DEPT2 ;
SELECT * FROM PROFESSOR p ;

-----------------------------------------------------------------------------------
-----------------------------------10장 VIEW
/*
   뷰(VIEW)
   - 테이블이나 뷰를 이용해서 만들어낸 가상테이블
   - 쿼리문 자체를 저장하고 있음
   - 자주 사용하는 복잡한 쿼리문이 있으면 뷰로 만들어서 호출하는 것이 편리함
   - 뷰로 인한 성능상의 변화는 없음 
 */
-- 하나의 테이블로부터 뷰 만들기
CREATE VIEW VIEW_DEPT
	AS (SELECT DCODE, DNAME, AREA 
		FROM DEPT2);
SELECT * 
	FROM VIEW_DEPT;

-- 테이블을 조인하여 뷰 만들기
-- 쿼리문으로 작성해 놓고 뷰로 보기 / 반드시 JOIN을 해주어야 함
CREATE VIEW VIEW_STUDENT
	AS (SELECT S.STUDNO, S.NAME, S.ID, S.GRADE, D.DNAME, D.BUILD 
		FROM STUDENT s INNER JOIN DEPARTMENT d 
		ON S.DEPTNO1 = D.DEPTNO );
SELECT NAME , GRADE , DNAME 
	FROM VIEW_STUDENT ;

-- 뷰 테이블을 이용하여 또 다른 뷰 만들기
CREATE VIEW VIEW2_STUDENT 
	AS (SELECT STUDNO, NAME, GRADE, DNAME
		FROM VIEW_STUDENT);
SELECT *
	FROM VIEW2_STUDENT;  