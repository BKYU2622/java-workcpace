/*
    단일 컬럼과 복수행 함수를 함께 출력하려고 할 경우 반드시 GROUP BY절을 사용해야함.
    GROUP BY 절에는 별칭을 사용할 수 없고, SELECT 절에는 GROUP BY에 사용된 컬럼을 생략할 수 있다.
    반면 ORDER BY절에는 별칭 사용 가능.
*/
SELECT DEPTNO 부서,SUM(PAY)
	FROM PROFESSOR
	GROUP BY DEPTNO
	ORDER BY 부서;

SELECT DEPTNO, TRUNC(AVG(NVL(BONUS,0))) 평균보너스 
	FROM PROFESSOR
	GROUP BY DEPTNO
	ORDER BY DEPTNO;

-- GROUP BY절을 사용한 경우 조건을 추가하려면 HAVING을 사용한다.
-- HAVING절에도 별칭(ALIAS을 쓰지 못한다
SELECT DEPTNO , AVG(NVL(BONUS,0)) 평균보너스 
	FROM PROFESSOR 
	GROUP BY DEPTNO
	HAVING AVG(NVL(BONUS,0)) > 50;

-- 학과별 교수인원이 2명 이하인 학과번호, 교수인원을 출력
SELECT DEPTNO 학과번호, COUNT(*) 교수인원
	FROM PROFESSOR
	GROUP BY DEPTNO 
	HAVING COUNT(*) <= 2; 
	
-- 교수테이블에서 평균급여가 350이상인 부서의 부서코드, 평균급여, 급여합계 출력
SELECT DEPTNO 부서코드, AVG(PAY) 평균급여, SUM(PAY) 급여합계 
 	FROM PROFESSOR 
	GROUP BY DEPTNO
	HAVING AVG(PAY) >= 350; 
/*
GROUP 함수(복수행함수): 레코드들 기준 컬럼(전체)으로 그룹화하여 원하는 결과를 구하는 함수들
	- GROUP BY: 기준컬럼명 
	- HAVING: 그룹함수 조건문
	- NULL값은 제외 됨
	
	1) COUNT: 레코드의 건 수 변환, NULL값은 제외
		COUNT(*): 전체 레코드 수
		COUNT(컬럼명): 해당 컬럼의 값이 NULL이 아닌 개수
	
	2) SUM: 컬럼값의 합계 변환
		SUM(숫지형컬럼)
	
	3) AVG: 컬럼값들의 평균 반환, NULL값인 경우 평균산출시 제외
 		AVG(숫자형컬럼명), AVG(NVL(컬럼명, 0)) => NULL인 경우도 평균 산출시 처리됨
 		
 	4) MAX: 컬럼값중 최대값 반환 
 	
 	5) MIN: 컬럼값중 최소값 반환
 	
 	6) ROLLUP: 자동 소계 산출 함수, 한반향
 	
 	7) CUBE: 자동 소계 산출 함수, 양방향
 */

SELECT DEPTNO , POSITION , COUNT(*) 교수인원, SUM(PAY) 총급여 
	FROM PROFESSOR  
	GROUP BY ROLLUP(DEPTNO, POSITION);

-----------------------------------------------------------------------
-- 0은 의미 없음, NULL이 아니기만 하면 됨
SELECT DEPTNO
    , COUNT(DECODE(JOB,'CLERK',0)) CLERK
    , COUNT(DECODE(JOB,'MANAGER',0)) MANAGER
    , COUNT(DECODE(JOB,'PRESIDENT',0)) PRESIDENT
    , COUNT(DECODE(JOB,'ANALYST',0)) ANALYST
    , COUNT(DECODE(JOB,'SALESMAN',0)) SALESMAN
	FROM EMP  
	GROUP BY DEPTNO 
	ORDER BY DEPTNO ;

-- Professor 테이블을 사용하여 교수 중에서 급여(pay)와 보너스(bonus)를 합친금액이 가장 많은 경우와 가장 적은 경우 , 평균 금액을 구하세요. 
-- 단, 보너스가 없을 경우는 보너스를 0 으로 계산하고 출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요.

SELECT MAX(PAY+NVL(BONUS,0)) MAX, MIN(PAY+NVL(BONUS,0)) MIN, ROUND(AVG(PAY+NVL(BONUS,0)),1) AVG 
	FROM PROFESSOR p ;
-- Student 테이블의 birthday 칼럼을 사용하여 아래 화면처럼 월별로 태어난 인원수를 출력하세요.
SELECT COUNT(*) 합계 
    , SUM(DECODE(TO_CHAR(BIRTHDAY,'MM'),'01',1,0)) "1월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),02,1,0)) "2월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),03,1,0)) "3월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),04,1,0)) "4월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),05,1,0)) "5월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),06,1,0)) "6월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),07,1,0)) "7월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),08,1,0)) "8월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),09,1,0)) "9월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),10,1,0)) "10월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),11,1,0)) "11월"
	, SUM(DECODE(SUBSTR(BIRTHDAY,4,2),12,1,0)) "12월"
	FROM STUDENT s ;

-- ROWNUM, ROWID / 오라클에 의하여 특정하게 부여되는 번호
-- 조회하는 상태에 따라서 ROWNUM은 바뀌지만, ROWID는 바뀌지 않음
SELECT ROWNUM, ROWID, ENAME 
	FROM EMP e 
	ORDER BY ENAME ;

SELECT ROWNUM, ROWID, ENAME 
	FROM EMP e 
	WHERE DEPTNO = 20
	ORDER BY ENAME ;

-- ROWNUM은 범위를 정할 때, 시작이 무조건 1이여야 출력이 됨
SELECT ROWNUM , NAME , JUMIN 
	FROM STUDENT s 
	WHERE ROWNUM BETWEEN 1 AND 5;

SELECT 
   	 NVL(MAX(DECODE(MOD(ROWNUM-1,3),0,PROFNO)),'0') 사번1
  	,NVL(MAX(DECODE(MOD(ROWNUM-1,3),0,NAME)),'******') 이름1
  	,NVL(MAX(DECODE(MOD(ROWNUM-1,3),1,PROFNO)),'0') 사번2
  	,NVL(MAX(DECODE(MOD(ROWNUM-1,3),1,NAME)),'******') 이름2
  	,NVL(MAX(DECODE(MOD(ROWNUM-1,3),2,PROFNO)),'0') 사번3
  	,NVL(MAX(DECODE(MOD(ROWNUM-1,3),2,NAME)),'******') 이름3
	FROM PROFESSOR
	GROUP BY TRUNC((ROWNUM-1)/3) 
	ORDER BY 사번1;


-- 학생테이블에서 학번과 이름을 한줄에 3명씩 출력하기
SELECT 
	 MAX(DECODE(MOD(ROWNUM-1,3),0,STUDNO)) 학번1
	,MAX(DECODE(MOD(ROWNUM-1,3),0,NAME)) 이름1
	,MAX(DECODE(MOD(ROWNUM-1,3),1,STUDNO)) 학번2
	,MAX(DECODE(MOD(ROWNUM-1,3),1,NAME)) 이름2
	,MAX(DECODE(MOD(ROWNUM-1,3),2,STUDNO)) 학번3
	,MAX(DECODE(MOD(ROWNUM-1,3),2,NAME)) 이름3
	FROM STUDENT s 
	GROUP BY TRUNC((ROWNUM-1)/3) 
	ORDER BY 1;  		-- 1은 첫번째 컬럼을 의미
	
------------------------------------------------------------------------------------
-----------------------------------4장 JOIN
-- JOIN	
-- 1) EQUI JOIN(등가 join)

-- ANSI 문법
SELECT STUDENT.NAME, DEPARTMENT.DEPTNO, DEPARTMENT.DNAME
  FROM STUDENT JOIN  DEPARTMENT
  ON STUDENT.DEPTNO1 = DEPARTMENT.DEPTNO;

-- 변수명 지정해주고 앞에 써줘도 됨 / 위와 동일한 값
SELECT S.NAME, D.DEPTNO, D.DNAME
  FROM STUDENT S JOIN  DEPARTMENT D
  ON S.DEPTNO1 = D.DEPTNO; 	

--ORACLE 문법
SELECT S.NAME, D.DEPTNO, D.DNAME
	FROM STUDENT S, DEPARTMENT D
	WHERE S.DEPTNO1 = D.DEPTNO;

SELECT S.NAME 학생이름, P.PROFNO 교수번호, P.NAME 교수이름
  FROM STUDENT S JOIN PROFESSOR P
    ON S.PROFNO = P.PROFNO;

SELECT S.NAME 학생이름, P.PROFNO 교수번호, P.NAME 교수이름
	FROM STUDENT S , PROFESSOR P
	WHERE S.PROFNO = P.PROFNO;

-- 학생 테이블(student)과 학과 테이블(department) , 교수 테이블(professor2)을 Join하여 학생의 이름과 학과이름, 지도교수 이름을 출력하세요.
SELECT S.NAME, D.DNAME, P.NAME
	FROM STUDENT S JOIN PROFESSOR P
    ON S.PROFNO = P.PROFNO
    JOIN DEPARTMENT D  
    ON D.DEPTNO = P.DEPTNO;
	
SELECT S.NAME, D.DNAME, P.NAME
	FROM STUDENT S , PROFESSOR P, DEPARTMENT D
	WHERE S.PROFNO = P.PROFNO
    AND P.DEPTNO = D.DEPTNO;

-- emp2 테이블과 p_grade 테이블을 조회하여 사원의 이름과 직급, 현재 연봉(sal), 
-- 해당 직급의 연봉의 하한금액(s_pay)과 상한 금액(e_pay)을 출력하세요.
SELECT E.NAME , E.POSITION , PAY , G.S_PAY, G.E_PAY
	FROM EMP2 E JOIN P_GRADE G 
	ON E.POSITION = G.POSITION ;

--전공(deptno)이 101번인 학생들의 학생 이름과 지도교수 이름을 출력하세요.
SELECT S.NAME, P.NAME 
	FROM STUDENT S JOIN PROFESSOR P
    ON S.PROFNO = P.PROFNO
 	WHERE S.DEPTNO1 = '101';
	
SELECT S.NAME , P.NAME 
	FROM STUDENT s , PROFESSOR p 
	WHERE S.PROFNO = P.PROFNO
	AND S.DEPTNO1 = '101';
	
----------------------------------------------------------------------------------
-- NON EQUI JOIN(비등가 조인: 조인조건이 '='이 나닌 조인)
SELECT * FROM GOGAK ;
SELECT * FROM GIFT ;

SELECT GO.GNAME , GO.POINT , GI.GNAME 
	FROM GOGAK GO JOIN GIFT GI
	ON POINT BETWEEN G_START AND G_END;

SELECT GI.GNAME 상품명, COUNT(*) 필요수량 
	FROM GOGAK GO JOIN GIFT GI
	ON POINT BETWEEN G_START AND G_END
	GROUP BY GI.GNAME ;

-- Student 테이블과 exam_01 테이블 , hakjum 테이블을 조회하여 학생들의 이름과 점수와 학점을 출력하세요.
SELECT S.NAME 학생이름, E.TOTAL 점수, H.GRADE 학점
	FROM STUDENT s JOIN EXAM_01 e 
	ON S.STUDNO = E.STUDNO JOIN HAKJUM h 
	ON E.TOTAL BETWEEN MIN_POINT AND MAX_POINT ;

-- Gogak 테이블과 gift 테이블을 Join하여 고객이 자기 포인트보다 낮은 포인트의 상품 중 한가지를 선택할 수 있다고 할 때, 
-- 산악용 자전거를 선택할 수 있는 고객명과 포인트, 상품명을 출력하세요.
SELECT GO.GNAME, GO.POINT, GI.GNAME 
	FROM GOGAK GO JOIN GIFT GI 
	ON GO.POINT BETWEEN GI.G_START AND GI.G_END 
	WHERE GI.GNAME = '산악용자전거';

SELECT GO.GNAME, GO.POINT, GI.GNAME
	FROM GOGAK GO JOIN GIFT GI 
	ON GI.G_START <= GO.POINT
	AND GI.GNAME = '산악용자전거';

SELECT * FROM EXAM_01 ;
SELECT * FROM HAKJUM ;
SELECT * FROM STUDENT;
SELECT * FROM EMP;
SELECT * FROM PROFESSOR;