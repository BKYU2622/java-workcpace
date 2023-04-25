/*
  OUTER JOIN: 테이블을 조인했을 때, 조인조건에 해당하지 않는 레코드까지 출력하기 위한 조인
  			  테이블을 포함하고 있는 테이블의 조인 위치에 따라 LEFT OUTER JOIN 또는 RIGHT OUTER JOIN 사용
  			  
  INNER JOIN: 조인 조건에 해당하는 레코드만 출력하는 조인방식			  
 */
--LEFT OUTER JOIN
--ANSI
SELECT S.NAME 학생명, P.NAME 교수명 
	FROM STUDENT s LEFT OUTER JOIN PROFESSOR p 
	ON S.PROFNO = P.PROFNO ;

--ORACLE / ORACLE 문법에서는 없는 데이터 쪽에 +를 해줘야 함 
--LEFT OUTER JOIN이면 오른쪽에 (+), RIGHT OUTER JOIN이면 왼쪽에 (+)
SELECT S.NAME 학생명, P.NAME 교수명
	FROM STUDENT s , PROFESSOR p 
	WHERE S.PROFNO = P.PROFNO(+) ;

--RIGHT OUTER JOIN / +지도학생이 없는 교수들
--ANSI
SELECT S.NAME 학생이름, P.NAME 교수이름
	FROM STUDENT s RIGHT OUTER JOIN PROFESSOR p 
	ON S.PROFNO = P.PROFNO 
	ORDER BY 1 ;
--ORACLE
SELECT S.NAME 학생이름, P.NAME 교수이름
	FROM STUDENT s , PROFESSOR p
	WHERE S.PROFNO(+) = P.PROFNO 
	ORDER BY 1 ;

--FULL OUTER JOIN / 지도교수가 없는 학생 + 지도학생이 없는 교수
--ANSI
SELECT S.NAME 학생이름, P.NAME 교수이름 
	FROM STUDENT s FULL OUTER JOIN PROFESSOR p 
	ON S.PROFNO = P.PROFNO ;
--ORACLE
SELECT S.NAME 학생이름, P.NAME 교수이름 
	FROM STUDENT s , PROFESSOR p 
	WHERE S.PROFNO(+) = P.PROFNO  
UNION
SELECT S.NAME 학생이름, P.NAME 교수이름 
	FROM STUDENT s , PROFESSOR p 
	WHERE S.PROFNO = P.PROFNO(+) ;

--SELF JOIN: 한 테이블내의 컬럼들을 조인 조건으로 사용하는 조인방식 / 같은 테이블이기 때문에 별칭이 반드시 들어가야 함
--ANSI
SELECT D1.DNAME 부서명, D2.DNAME 상위부서명
	FROM DEPT2 d1 JOIN DEPT2 d2 
	ON D1.PDEPT = D2.DCODE ;
--ORACLE
SELECT D1.DNAME 부서명, D2.DNAME 상위부서명 
	FROM DEPT2 d1 , DEPT2 d2 
	WHERE D1.PDEPT = D2.DCODE ; 

--professor 테이블에서 교수의 번호, 교수이름, 입사일, 자신보다 입사일 빠른 사람 인원수를 출력하세요. 
--단,자신보다 입사일이 빠른 사람수를 오름차순으로 출력하세요.	
--ANSI
SELECT P1.PROFNO 교수번호, P1.NAME 교수명, P1.HIREDATE 입사일, COUNT(P2.NAME) "빠른 사람"
	FROM PROFESSOR p1 LEFT OUTER JOIN PROFESSOR p2 
	ON P1.HIREDATE > P2.HIREDATE
	GROUP BY P1.PROFNO , P1.NAME , P1.HIREDATE 
	ORDER BY P1.HIREDATE ;

SELECT * FROM PROFESSOR p  ;

--ORACEL
SELECT P1.PROFNO 교수번호, P1.NAME 교수명, P1.HIREDATE 입사일, COUNT(P2.NAME) "빠른 사람"
	FROM PROFESSOR p1 , PROFESSOR p2 
	WHERE P1.HIREDATE > P2.HIREDATE(+) 
	GROUP BY P1.PROFNO , P1.NAME , P1.HIREDATE 
	ORDER BY P1.HIREDATE ;

--EMP 테이블에서 사원번호, 이름, 직무, 상사번호, 상사이름, 상사의 직무를 출력하시오
--ANSI
SELECT E1.EMPNO 사원번호, E1.ENAME 이름, E1.JOB 직무, E2.EMPNO 상사직원번호, E2.ENAME 상사이름, E2.JOB 상사직무
	FROM EMP e1 LEFT OUTER JOIN EMP e2 
	ON E1.MGR = E2.EMPNO; 
--ORACLE
SELECT E1.EMPNO 사원번호, E1.ENAME 이름, E1.JOB 직무, E2.EMPNO 상사직원번호, E2.ENAME 상사이름, E2.JOB 상사직무
	FROM EMP e1 , EMP e2 
	WHERE E1.MGR = E2.EMPNO(+); 

/*
 INNER JOIN  VS OUTER JOIN
 EQUI JOIN VS NON EQUI JOIN
 SELEF JOIN
*/

----------------------------------------------------------------------------------
-----------------------------------5장 SUB QUERY

SELECT ENAME 이름, SAL 급여
	FROM EMP e 
	WHERE SAL > (SELECT SAL
				 FROM EMP e 
				 WHERE ENAME = 'SCOTT');
/*
--SUB QUERY(부속질의)는 WHERE절의 조건값을 또 다른 SELECT절에 의해 추출하는데 사용하는 QUERY를 가리킴.
	다음과 같은 종류의 서브쿼리가 있음	
	1)일반서브쿼리: WHERE절에 위치하고 비교값을 구하기 위한 서브쿼리, 단일행 서브쿼리와 다중행 서브쿼리가 있고,
			   단일/다중행에 따라 사용하는 연산자가 다르다. 또한, 다중컬럼 서브쿼리도 가능하다.
	2)스칼라서브쿼리: SELECT절에 사용되는 서브쿼리. 단일행이 조회될때마다 서브쿼리가 실행되므로 성능은 좋지 못함.
	3)인라인뷰: FROM절에 사용하는 서브쿼리. 기존 테이블에서 쿼리를 통해 가상의 테이블을 구성한 후,
			 다른 테이블과 조인이 필요할 경우 사용되는 서브쿼리. 뷰는 가상의 테이블을 가리킴. 
 */					
--1)일반 서브쿼리
-- Student테이블과 department 테이블을 사용하여 이윤나 학생과 전공 deptno이 동일한 학생들의 이름과 전공 이름을 출력하세요 .
SELECT S.NAME 이름, D.DNAME 학과
	FROM STUDENT S JOIN DEPARTMENT D
    ON S.DEPTNO1 = D.DEPTNO
	WHERE  S.DEPTNO1 = (SELECT DEPTNO1
                        FROM STUDENT
                        WHERE NAME = '이윤나');

SELECT S.NAME 이름, D.DNAME 학과
	FROM STUDENT S JOIN DEPARTMENT D
    ON S.DEPTNO1 = D.DEPTNO
	WHERE S.NAME != '이윤나' 
	AND S.DEPTNO1 = (SELECT DEPTNO1
                     FROM STUDENT
                     WHERE NAME = '이윤나');		 
	
--김진욱 학생과 같은 과 학생의 이름, 학년, 학과명 출력하기
SELECT S.NAME 이름, S.GRADE 학년, D.DNAME 학과명
	FROM STUDENT s JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE S.DEPTNO1  = (SELECT DEPTNO1
					FROM STUDENT s
					WHERE NAME = '김진욱');

--다중 행 서브 쿼리에서는 다중 행 연산자만 써야 함 / 단일 행은 단일 행 연산자만 써야 함
SELECT EMPNO 사원번호, NAME 이름, DEPTNO 부서번호 
	FROM EMP2 e 
	WHERE DEPTNO IN(SELECT DCODE 
					FROM DEPT2 d 
					WHERE AREA = '서울지사');

--Emp2테이블을 사용하여 전체 직원 중 과장 직급의 최소 연봉자보다 연봉이 높은 사람의 이름과 직급 , 연봉을 출력하세요. 
--단, 연봉 출력 형식은 아래와 같이 천 단위 구분기호와 원 표시를 하세요.
-- SUB QUERY
SELECT MIN(PAY)
	FROM EMP2
	WHERE POSITION = '과장';

SELECT NAME 이름, POSITION 직급, TO_CHAR(PAY,'999,999,999')||'원' 연봉
	FROM EMP2
	WHERE PAY > ( SELECT MIN(PAY)
                  FROM EMP2
                  WHERE POSITION = '과장');
				 
--Student 테이블을 조회하여 전체 학생 중에서 체중이 4학년 학생들의 체중에서 가장 적게 나가는 학생보다 
--몸무게가 적은 학생의 이름과 학년과 몸무게를 출력하세요
SELECT NAME 이름, GRADE 학년, WEIGHT 몸무게
	FROM STUDENT s 
	WHERE WEIGHT < (SELECT MIN(WEIGHT) 
					FROM STUDENT s 
					WHERE GRADE = '4');
				
SELECT NAME 이름, GRADE 학년, WEIGHT 몸무게
	FROM STUDENT s 
	WHERE WEIGHT < ALL (SELECT WEIGHT 
					FROM STUDENT s 
					WHERE GRADE = '4');
					
--Student 테이블을 조회하여 각 학년별로 최대키를 가진 학생들의 학년과 이름과 키를 출력하세요.
SELECT GRADE 학년, NAME 이름, HEIGHT 키
	FROM STUDENT s 
	WHERE (GRADE, HEIGHT) IN(SELECT GRADE , MAX(HEIGHT)
							 FROM STUDENT s 
							 GROUP BY GRADE);
							
--Professor 테이블을 조회하여 각 학과별로 입사일이 가장 오래된 교수의 교수번호와 이름, 학과명을 출력하세요. 
--(학과이름순(department)으로 오름차순 정렬하세요)
SELECT P.PROFNO 교수번호, P.NAME 이름, D.DNAME 학과명
	FROM PROFESSOR p JOIN DEPARTMENT d 
	ON P.DEPTNO = D.DEPTNO 
	WHERE(P.DEPTNO, P.HIREDATE) IN(SELECT DEPTNO, MIN(HIREDATE)
								 FROM PROFESSOR p
								 GROUP BY DEPTNO)
								 ORDER BY D.DNAME ;
								
--Emp2 테이블을 조회하여 직급별로 해당 직급에서 최대 연봉을 받는 직원의 이름과 직급, 연봉을 출력하세요. 
--연봉순으로 오름차순 정렬하세요.								
SELECT NAME 이름, POSITION 직급, PAY 연봉
	FROM EMP2 e 
	WHERE(POSITION , PAY) IN(SELECT POSITION, MAX(PAY)
							 FROM EMP2 e
							 GROUP BY POSITION)
							 ORDER BY PAY ;

--Emp2 테이블을 조회해서 직원 들 중에서 자신의 직급의 평균연봉과 같거나 많이 받는 사람들의 이름과 직급, 현재 연봉을 출력하세요.
--SUB QUERY를 쓰기 때문에 별칭을 주어야 함 
SELECT NAME 이름, POSITION 직급, PAY 연봉
	FROM EMP2 E1
	WHERE PAY >= (SELECT AVG(PAY)
                  FROM EMP2 E2
                  WHERE E1.POSITION = E2.POSITION);	
                 
--2)스칼라 서브쿼리				  
--EMP2 테이블과 DEPT2 테이블을 조회하여 사원들의 이름과 부서이름을 출력하세요.
SELECT E.NAME 이름, D.DNAME 부서이름
	FROM EMP2 E JOIN DEPT2 D
    ON E.DEPTNO = D.DCODE;

SELECT E.NAME 사원이름,( SELECT D.DNAME 
                      FROM DEPT2 D 
                      WHERE E.DEPTNO = D.DCODE) 부서이름
  					  FROM EMP2 E;

--3)인라인뷰
--STUDENT 테이블과 DEPARTMENT 테이블을 사용하여 학과별로 학생등의 최대 키와 최대 몸무게 학과이름을 츌력하세요.
SELECT D.DNAME 학과명, S.MAX_HEIGHT "최대 키", S.MAX_WEIGHT "최대 몸무게"
	FROM (SELECT DEPTNO1,MAX(HEIGHT) MAX_HEIGHT,MAX(WEIGHT) MAX_WEIGHT
          FROM STUDENT
          GROUP BY DEPTNO1) S, DEPARTMENT D
 		  WHERE S.DEPTNO1 = D.DEPTNO;

SELECT DEPTNO1 ,MAX(HEIGHT) MAX_HEIGHT ,MAX(WEIGHT) MAX_WEIGHT 
         FROM STUDENT
         GROUP BY DEPTNO1;
        
----------------------------------------------------------------------------------

/*
--SQL문 종류
1.DQL(DATA QUERY LANGUAGE): SELECT 

2.DML(DATA MANIPULATION LANGUAGE): 데이터 조작어, 즉 데이터를 삽입, 수정, 삭제할 때 사용하는 쿼리 언어
 2-1종류
 	1)삽입: INSERT VALUES 
 	2)수정: UPDATE SET WHERE
 	3)삭제: DELETE FROM WHERE
 	DML 사용 후에는 COMMIT(데이터베이스에 반영) 또는 ROLLBACK(이전 상태로 돌림)처리를 해야 함.
 	
3.DDL(DATA DEFINITION LANGUAGE): 데이터 정의어, 즉 데이터베이스 객체(USER, TABLE, SEQUENCE, VIEW,
INDEX 등)을 생성, 수정, 삭제할 수 있는 쿼리 언어, 완료된 작업은 최소할 수 없음(COMMIT이 필요없음, ROLLBACK할 수 없음)	
 3-1종류
 	1)CREATE: 생성
 	2)ALTER: 수정
 	3)DROP: 삭제
 	
4.DCL(DATA CONTROL LANGUAGE): 데이터 처리어, 즉 데이터베이스에 대한 권한을 부여하고, 제거하는데 사용하는 쿼리 언어
데이터베이스 보안을 위해 권한을 제어하기 위해 사용됨, 사용자에게 최소권한만 부여해야함
 4-1종류
 	1)GRANT: 권한 부여
 	2)REVOKE: 권한 제거				            				            				            				            
*/
        
--INSERT
--MULL이 아닌 이상 무조건 컬럼을 입력해야 함 / NULL값을 넣을 경우 입력해 줘야 함       
INSERT INTO DEPT2(DCODE, DNAME, PDEPT, AREA)
	VALUES(9000, '특판1팀', '영업', '임시지역');

--앞에 컬럼을 지정하지 않아도 값은 입력 됨, 단 순서대로 입력하고 컬럼의 타입과 수를 지켜야 함
INSERT INTO DEPT2 VALUES (9001, '특판2팀', '영업', '임시지역');

SELECT * FROM DEPT2 d ;
COMMIT;
ROLLBACK;

--DELETE 
--삭제할 부분을 WHERE로 특정해줘야 함
DELETE FROM DEPT2 d 
	WHERE DCODE = 9001; 

SELECT * FROM DEPT d 
WHERE DNAME = '영업부';

INSERT INTO PROFESSOR p (PROFNO , NAME , ID , POSITION , PAY , HIREDATE)
	VALUES (5001, '김설희', 'love_me', '정교수', 510, '2021-11-14');

INSERT INTO PROFESSOR p (PROFNO , NAME , ID , POSITION , PAY , HIREDATE)
	VALUES (5002, '각설이', 'HI_SNOW', '조교수', 400, SYSDATE);

SELECT * FROM PROFESSOR p ;

--CREATE 
--PROFESSOR 테이블을 PROFESSOR2로 전체 복사한다는 뜻
CREATE TABLE PROFESSOR2 AS SELECT * FROM PROFESSOR ;

SELECT * FROM PROFESSOR p2 ;

--필요한 테이블만 복사할 수 있다는 뜻
CREATE TABLE PROFESSOR3 AS SELECT * FROM PROFESSOR WHERE PROFNO < 2000;

SELECT * FROM PROFESSOR3 ;

DROP TABLE PROFESSOR3; 