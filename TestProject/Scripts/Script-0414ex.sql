-- 4월 14일 복습문제
SELECT * FROM STUDENT s ;
SELECT * FROM PROFESSOR p ;
SELECT * FROM EMP e ;

--1. 교수테이블에서 2000년 이전에 입사한 교수명과 입사일, 현재연봉 10%인상 후 연봉을 출력하기
-- 단, 연봉은 pay * 12로 하고, 인상후 연봉은 소숫점 이하 삭제함 연봉, 인상후연봉 출력시 천단위로 구분 기호, 출력하기
SELECT NAME 교수명, HIREDATE 입사일, PAY*12 연봉, TRUNC((PAY*13)*1.1) "인상후 연봉"
	FROM PROFESSOR p 
	WHERE TO_CHAR(HIREDATE, 'YYYY') < '2000';  
--	WHERE SUBSTR(HIREDATE,1,4) < '2000'; 
	
--2. 교수의 이름, 부서번호와, 교수의 이름이 김도형이면 '석좌교수후보' 출력하고, 김도형 교수가 아니면 '출마안함' 출력하기
--CASE문
SELECT  NAME 교수명, DEPTNO 부서번호,
	CASE 
		WHEN NAME = '김도형' THEN '석좌교수후보	'
		WHEN NAME != '김도형' THEN '출마안함'
	END 후보
	FROM PROFESSOR p ;

--DECODE문
SELECT NAME 교수명, DEPTNO 부서번호, DECODE(NAME , '김도형', '석좌교수후보', '출마안함') 후보 
	FROM PROFESSOR p ; 

--3. 교수의 이름, 부서번호, 부서번호가 103번이면서 , 교수의 이름이 조인형이면 '석좌교수후보' 출력하고,
-- 김도형 교수가 아니면 '출마안함' 출력하고, 103번학과가 아니면 '출마부서아님'으로 출력하기
--CASE문
SELECT NAME 교수명, DEPTNO 부서번호, 
	CASE 
		WHEN DEPTNO = '103' AND NAME = '김도형' THEN '석좌교수후보'
		WHEN DEPTNO = '103' AND NAME != '김도형' THEN '출마안함'
		ELSE '출마부서아님'
	END 후보
	FROM PROFESSOR p ; 
	
--DECODE문
SELECT NAME 교수명, DEPTNO 부서번호, 
DECODE(DEPTNO , '103', DECODE(NAME , '김도형', '석좌교수후보', '출마안함'), '출마부서아님') 후보 
	FROM PROFESSOR p ; 

--4. 학생의 이름과, 체중 ,키 ,비만도를 출력하기. 비만도:( (실제체중 - 표준체중) / 표준체중 ) * 100
-- 표준체중: (키 - 100) * 0.9 비만도 10미만 은 '정상', 10 ~ 20미만  '과체중', 20이상 '비만' 으로 출력하기
SELECT NAME 이름, WEIGHT 체중, HEIGHT 키,
	CASE 
		WHEN ((WEIGHT-(HEIGHT-100)*0.9)/(HEIGHT-100)*0.9)*100 < 10 THEN '정상'
		WHEN ((WEIGHT-(HEIGHT-100)*0.9)/(HEIGHT-100)*0.9)*100 >= 10 AND 
			 ((WEIGHT-(HEIGHT-100)*0.9)/(HEIGHT-100)*0.9)*100 < 20 THEN '과체중'
		WHEN ((WEIGHT-(HEIGHT-100)*0.9)/(HEIGHT-100)*0.9)*100 >= 20 THEN '비만'
	END 비만도
	FROM STUDENT s ;
	
--5. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어 나머지가 0이면 'A팀', 1이면 'B팀', 2이면 'C팀'으로 
-- 분류하여 학생 번호, 이름, 학과 번호, 팀 이름을 출력하여라
--CASE문
SELECT STUDNO 학생번호, NAME 이름, DEPTNO1 학과번호,
	CASE 
		WHEN MOD(STUDNO,3) = 0 THEN 'A팀'
		WHEN MOD(STUDNO,3) = 1 THEN 'B팀'
		WHEN MOD(STUDNO,3) = 2 THEN 'C팀'
	END 팀
	FROM STUDENT s ;

--조건을 먼저 준 경우
SELECT STUDNO 학생번호, NAME 이름, DEPTNO1 학과번호, 
	CASE MOD(STUDNO ,3) 
		WHEN 0 THEN 'A팀'
		WHEN 1 THEN 'B팀'
		WHEN 2 THEN 'C팀'
	END 팀
	FROM STUDENT s ;
 
--DECODE문
SELECT STUDNO 학생번호, NAME 이름, DEPTNO1 학과번호, 
	DECODE(MOD(STUDNO,3),0,'A팀',DECODE(MOD(STUDNO,3),1,'B팀', 'C팀')) 팀
	FROM STUDENT s ;

SELECT STUDNO 학생번호, NAME 이름, DEPTNO1 학과번호,
	DECODE(MOD(STUDNO,3),0,'A팀',1,'B팀','C팀') 팀
	FROM STUDENT s ;
	
--6. 학생의 이름, 지도 교수 번호를 출력하여라. 단, 지도 교수가 배정되지 않은 학생은 지도교수 번호를 0000으로 출력하여라
--지도교수번호가 숫자 타입이라 0만 찍힘
SELECT NAME 이름, NVL(PROFNO,'0000') "지도교수 번호"
	FROM STUDENT s ;

--형변환 / '0999': 값이 없는 부분은 0으로 4자리 출력하겠다는 뜻
SELECT NAME 이름, TO_CHAR(NVL(PROFNO,0),'0999') "지도교수 번호"
	FROM STUDENT s ;

--7.주민등록번호를 기준으로 학생들의 이름, 사용자 아이디, 생년월일을 출력하여라. 단, 사용자 아이디는 대문자(UPPER)로,	
-- 생년월일은 '1985/02/01' 형식으로 출력하여라
-- 문자타입의 JUMIN을 데이트 타입으로 바꾼 후, 다시 'YYYY/MM/DD'의 문자형식으로 변환
SELECT NAME 이름, UPPER(ID) , TO_CHAR(TO_DATE(SUBSTR(JUMIN,1,6)),'YYYY/MM/DD')  
	FROM STUDENT s ;
/*
SELECT NAME, UPPER(ID), TO_CHAR(TO_DATE(SUBSTR(JUMIN,1,6),'RR/MM/DD'), 'YYYY/MM/DD')
  FROM STUDENT;      -- SQLDEVELOPER/DBEABER에서 실행됨.
*/

--8. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D등급을 출력하기
-- 160 미만: A등급, 160 ~ 169까지: B등급, 170 ~ 179까지: C등급, 180이상: D등급
SELECT NAME 이름, HEIGHT 키,
	CASE 
		WHEN HEIGHT < 160 THEN 'A등급'
		WHEN HEIGHT >= 160 AND HEIGHT < 170 THEN 'B등급'
		WHEN HEIGHT >= 170 AND HEIGHT < 180 THEN 'C등급'
		WHEN HEIGHT >= 180 THEN 'D등급' 
	END 등급
	FROM STUDENT s ;

SELECT NAME 이름, HEIGHT 키,
	CASE 
		WHEN HEIGHT < 160 THEN 'A등급'
		WHEN HEIGHT BETWEEN 160 AND 169 THEN 'B등급'
		WHEN HEIGHT BETWEEN 170 AND 179 THEN 'C등급'
		ELSE 'D등급' 
	END 등급
	FROM STUDENT s ; 

--9. 4학년 학생의 이름(STUDENT.NAME) 학과번호(STUDENT.DEPTNO1, DEPARTMENT.DEPTNO) , 학과이름(DEPARTMENT.DNAME) 출력하기
SELECT S.NAME 학생이름, D.DEPTNO 학과번호, D.DNAME 학과이름 
	FROM STUDENT s INNER JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO ;

--10. 오나라 학생의 이름, 학과코드1,학과이름,학과위치 출력하기
SELECT S.NAME 이름, S.DEPTNO1 학과번호, D.DNAME "학과 이름", D.BUILD 학과위치
	FROM STUDENT s JOIN DEPARTMENT d   
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE S.NAME = '오나라' ;

--이름에 '김'이 포함된 학생만 조회
SELECT S.NAME 이름, S.DEPTNO1 학과번호, D.DNAME "학과 이름", D.BUILD 학과위치  
	FROM STUDENT s JOIN DEPARTMENT d   
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE S.NAME LIKE '%김%' ;

--11. 학번과 학생 이름과 소속학과이름을 학생 이름순으로 정렬하여 출력
--ANSI
SELECT S.NAME "학생 이름", S.DEPTNO1 학번, D.DNAME "소속학과 이름"
	FROM STUDENT s INNER JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	ORDER BY S.NAME ;

--ORACLE
SELECT S.NAME "학생 이름", S.DEPTNO1 학번, D.DNAME "소속학과 이름"
	FROM STUDENT s , DEPARTMENT d
	WHERE S.DEPTNO1 =D.DEPTNO 
	ORDER BY S.NAME ;

--12. 교수별로 교수 이름과 지도 학생 수를 출력하기.
--ANSI
SELECT P.NAME 교수명, COUNT(*) 학생수 
	FROM PROFESSOR p JOIN STUDENT s 
	ON P.PROFNO = S.PROFNO  
	GROUP BY P.NAME ;

--ORACLE
SELECT P.NAME 교수명, COUNT(*) 학생수
	FROM PROFESSOR p , STUDENT s 
	WHERE P.PROFNO = S.PROFNO 
	GROUP BY P.NAME ;

--13. 교수별로 교수 이름과 지도 학생의 이름을 출력하기
-- 함수를 사용해서 가독성 좋게한 경우 / GROUP BY절에는 반드시 함수를 사용해야 함 EX)COUNT
SELECT P.NAME 교수명, LISTAGG(S.NAME,',') WITHIN GROUP(ORDER BY S.GRADE) 지도학생 
	FROM PROFESSOR p JOIN STUDENT s 
	ON P.PROFNO = S.PROFNO 
	GROUP BY P.NAME ;
	
SELECT P.NAME 교수명, S.NAME 지도학생 
	FROM PROFESSOR p JOIN STUDENT s
	ON P.PROFNO = S.PROFNO ; 
	
--14.emp2, p_grade 테이블을 조회하여 나이를 기준으로 예상직급을 조회하기
-- 사원들의 이름,나이,현재 직급, 예상직급을 출력하기 나이는 생일과 오늘을 기준으로하고, 개월수 /12로 한다. 소숫점 이하는 버림
SELECT * FROM EMP2 e ;
SELECT * FROM P_GRADE pg ; 

--ANSI
SELECT E.NAME 이름, TRUNC(MONTHS_BETWEEN(SYSDATE,E.BIRTHDAY)/12) 나이, 
	E.POSITION 현재직급, P.POSITION 예상직급  
	FROM EMP2 e JOIN P_GRADE p 
	ON TRUNC(MONTHS_BETWEEN(SYSDATE,E.BIRTHDAY)/12) BETWEEN S_AGE AND E_AGE ; 

--ORACLE
SELECT E.NAME 이름, TRUNC(MONTHS_BETWEEN(SYSDATE,E.BIRTHDAY)/12) 나이, 
	E.POSITION 현재직급, P.POSITION 예상직급  
	FROM EMP2 e , P_GRADE p 
	WHERE TRUNC(MONTHS_BETWEEN(SYSDATE,E.BIRTHDAY)/12) BETWEEN S_AGE AND E_AGE ;

--15.emp2, p_grade 테이블을 조회하여 입사년(empno 앞4자리)을 기준으로 예상 직급을 조회하기
-- 사원들의 이름,나이,근속년도,현재 직급, 예상직급을 출력하기, 입사년도는 오늘을 기준으로하고, trunc함수를 사용
--ANSI
SELECT E.NAME 이름, TRUNC(MONTHS_BETWEEN(SYSDATE,E.BIRTHDAY)/12) 나이,
	TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(SUBSTR(E.EMPNO,1,4)) 근속년도,
	E.POSITION 현재직급 , P.POSITION 예상직급 
	FROM EMP2 E JOIN P_GRADE p 
	ON TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(SUBSTR(E.EMPNO,1,4))
	BETWEEN P.S_YEAR AND P.E_YEAR ;	

--16. 성이 김씨인 학생들의 이름, 학과이름 학과위치 출력하기
--ANSI
SELECT S.NAME 이름, D.DNAME 학과이름, D.BUILD 학과위치 
	FROM STUDENT s JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	AND S.NAME LIKE '김%' ;

--ORACLE
SELECT S.NAME 이름, D.DNAME 학과이름, D.BUILD 학과위치 
	FROM STUDENT s , DEPARTMENT d 
	WHERE  S.DEPTNO1 = D.DEPTNO 
	AND S.NAME LIKE '김%' ;

--17. 교수이름, 입사일, 입사년도의 휴가보상일, 올해의 휴가보상일 출력하기, 휴가보상일: 입사월의 마지막 일자 
SELECT NAME 이름, HIREDATE 입사일, LAST_DAY(HIREDATE) "입사년도 휴가보상일" 
	, LAST_DAY(TO_CHAR(SYSDATE, 'YYYY') || TO_CHAR(HIREDATE,'MM') || '01') "올해의 휴가보상일"  
	FROM  PROFESSOR p ;

--18. 사원의 정식 입사일은 입사일의 2개월 이후 다음달 1일로 한다. 사원번호, 이름, 입사일, 정식입사일(요일까지 출력) 조회하기
-- LAST_DATY에 +1을 하여 다음달 1일을 출력
-- 'DY': 요일
SELECT EMPNO 사원번호, ENAME 이름, TO_CHAR(HIREDATE, 'YYYY-MM-DD') 입사일, TO_CHAR(LAST_DAY(ADD_MONTHS(HIREDATE,2))+1,'YYYY/MM/DD') "정식 입사일"
	, TO_CHAR(LAST_DAY(ADD_MONTHS(HIREDATE,2))+1,'DY') || '요일' "정식 입사요일"
	FROM EMP e ;
