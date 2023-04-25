-----------------------------------9장 INDEX
/*
  인덱스(INDEX)
  1. 빠른 검색을 위해서 데이터의 물리적인 위치를 기억하고 있는 데이터베이스
  2. 인덱스가 등록된 컬럼을 이용한 검색은 그렇지 않은 검색에 비해 속도가 빠름
  3. 인덱스가 자동으로 등록되는 경우 
   1) PRIMARY KEY
   2) UNIQUE
  4. 삽입, 수정, 삭제가 자주 발생하는 곳에 인덱스를 사용하면 성능이 떨어짐
*/

-- 인덱스 정보가 저장된 데이터 딕셔너리(메타 데이터, 시스템 카탈로그)
-- ORACLE의 모든 인덱스 정보를 가지고 있는 데이터 딕셔너리
SELECT OWNER, INDEX_NAME, TABLE_NAME
	FROM ALL_INDEXES;

SELECT OWNER, INDEX_NAME, TABLE_NAME
	FROM ALL_INDEXES
	WHERE TABLE_NAME = 'MEMBER_TBL';
	
-- 사용자가 생성한 인덱스 정보를 가지고 있는 데이터 딕셔너리
SELECT INDEX_NAME, TABLE_OWNER, TABLE_NAME
	FROM USER_INDEXES;

-- 인덱스 컬럼 정보가 저장된 데이터 딕셔너리
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
	FROM USER_IND_COLUMNS;

-- 인덱스 생성하기(WHERE절에서 사용되는 컬럼에 인덱스를 설정한다.
-- 			  만일 해당 컬럼이 PK나 UNIQUE일 경우는 이미 인덱스가 생성된 상태임)
CREATE INDEX IND_NAME ON BOOK_TBL(BOOK_NAME);

-- 인덱스 삭제하기
DROP INDEX IND_NAME;

-----------------------------------11장 SEQUENCE와 SYNONYM
/*
   SEQUENCE(시퀀스): 데이터 입력시 자동으로 번호를 생성해서 입력해주는 오브젝트
   				   시작값, 증가값, 최대값, 최소값, 반복여부, 캐시여부 등을 설정하여 생성할 수 있음
   CREATE SEQUENCE 시퀀스명
   INCREMENT  증가값
   START WITH 시작값
   MAXVALUE   최대값
   MINVALUE   최소값
   CYCLE      반복
   CACHE OR NO CACHE; 캐시여부(시퀀스 생성속도 개선하기 위한 용도)				 
 */
CREATE SEQUENCE SEQ_JUMUN
	INCREMENT BY 1
	START WITH 1000
	MAXVALUE  1010
	MINVALUE  990
	CYCLE     
	CACHE 2;

SELECT * FROM BOOK_TBL;
-- 시퀀스명.NEXTVAL는 시퀀스명.CURRVAL의 다음값
-- 데이터 입력시 시퀀스명.NEXTVAL를 이용해서 중복되지 않는 순차번호를 입력할 수 있음
-- NEXTVAL은 계속 생성 됨 / 이미 지워짐 값은 무시하고 다음 번호 계속 생성
INSERT INTO BOOK_TBL VALUES(SEQ_JUMUN.NEXTVAL, '데이터베이스', 25000, NULL);
INSERT INTO BOOK_TBL VALUES(SEQ_JUMUN.NEXTVAL, '스프링', 35000, NULL);
INSERT INTO BOOK_TBL VALUES(1003,'JSP', 30000, NULL);
INSERT INTO BOOK_TBL VALUES(SEQ_JUMUN.NEXTVAL, 'HTML', 15000, NULL);
INSERT INTO BOOK_TBL VALUES(SEQ_JUMUN.NEXTVAL, 'CSS', 15000, NULL);
INSERT INTO BOOK_TBL VALUES(SEQ_JUMUN.NEXTVAL, 'JAVASCRIPT', 15000, NULL);

DELETE FROM BOOK_TBL WHERE BOOK_ID = 1002;

-- 특정 시퀀스 정보 확인하기
SELECT * 
	FROM USER_SEQUENCES  -- USER 시퀀스에는 복수형 
	WHERE SEQUENCE_NAME = 'SEQ_JUMUN'; 

-- CURRVAL: 현재의 시퀀스 값 출력하기
SELECT SEQ_JUMUN.CURRVAL FROM DUAL;

-- 시퀀스 삭제하기
DROP SEQUENCE SEQ_JUMUN;

--SYNONYM 기존의 오브젝트를 다른 이름으로 생성할 수 있음