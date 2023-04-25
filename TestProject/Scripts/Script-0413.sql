select lpad(name, 1, '*')
    from student
    where deptno1 = 101;
    
select replace(name, 9, '*')
    from student
    where deptno1 = 101;   
    
SELECT LPAD(ID, 10, '*')
  FROM STUDENT
 WHERE DEPTNO1 = '101';
 
 SELECT ID
   FROM STUDENT;
 DESC STUDENT;
 
 SELECT LTRIM(DNAME,'영') 
   FROM DEPT2;
   
 SELECT RTRIM(DNAME,'팀') 
   FROM DEPT2;

select replace(name, substr(name, 2, 1), '#')
    from student;

select replace(jumin, substr(jumin, 8, 6), '******')
    from student;
    
select name, deptno1, replace(tel, substr(tel, instr(tel, ')') + 1, 3), '###')
    from student
    where substr(tel, 1, 3) = '051';
 -- where deptno1 = '102';
   
select round(12.345, 2), trunc(12.345, 2), mod(12, 10), ceil(12.345), floor(12.345), power(3,2)
    from dual;
    
select round(15.345, -1)
    from dual;
    
 -- 교수의 급여를 15% 인상하여 정수로 출력하시오.
 -- 교수이름, 현재급여, 반올림된 예상급여, 버림된 예상급여를 정수로 출력하기
select name, pay, round,(ray * 1.15), trunc(ray * 1.15)
    from professor;
    
 -- ABS(숫자|컬럼): 절대값
select abs(-100)
    from dual;
 
 -- sign(숫자|컬럼): 양수인 경우 1, 음수인 경우 -1, 0은 0
select sign(-100), sign(0), sign(1000)
    from dual;   
    
SELECT SYSDATE 
	FROM DUAL;
	
alter session set nls_date_format='YYYY-MM-DD:HH24:MI:SS';  -- 이클립스는 적용 안 됨

alter session set nls_date_format='YYYY-MM-DD';				-- 이클립스는 적용 안 됨

SELECT SYSDATE 
	FROM DUAL;

SELECT MONTHS_BETWEEN('2023-04-13', '2023-01-13')
	FROM DUAL;

SELECT MONTHS_BETWEEN(SYSDATE, '2023-01-01')
	FROM DUAL;

-- 학생의 이름, 생일, 개월수, 나이 출력하기
-- 개월수: 현재 날짜에서 생일까지의 개월수를 반올림하여 정수로 출력
-- 나이: 개월수/12로 나누어서 버림
SELECT NAME 이름, BIRTHDAY 생일, ROUND(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)) 개월수, TRUNC(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) 나이  
	FROM STUDENT;

-- ADD_MONTHS: 개월수를 더한 후의 날짜를 리턴
-- 현재날짜를 기준으로 3개월 후, 3개월 전의 날짜 출력하기
SELECT SYSDATE 오늘, ADD_MONTHS(SYSDATE, 3) "3개월 후", ADD_MONTHS(SYSDATE, -3) "3개월 전" 
	FROM DUAL;

-- 교수테이블에서 입사 후 3개월을 수습기간이라고 가정할 때 수습종료일 출력하기
SELECT NAME 이름, HIREDATE 입사일, ADD_MONTHS(HIREDATE , 3) 수습종료일 
	FROM PROFESSOR; 

-- 전통적인 개월수 계산방식과 MONTHS_BETWEEN함수를 사용한 방식의 값이 차이가 남
-- 전통적인 방식에서는 모든 달을 31일이라는 가정하에 계산함
SELECT NAME,SYSDATE,HIREDATE,
       ROUND(MONTHS_BETWEEN(SYSDATE,HIREDATE),2) DATE_1,
       ROUND(((SYSDATE - HIREDATE)/31),2) DATE_2
  FROM PROFESSOR
 WHERE DEPTNO = 101;
	
----------------------------------------------------------------------------------
-- NEXT_DAY: 지정된 날짜에서 이후의 요일이 며칠인지를 구하는 함수
-- NEXT_DAY의 두 번째 인자는 요일을 의미(일:1 ~ 토:7), 한글로 적어도 됨
-- 오늘날짜에서 다음날, 이틀 후의 날짜를 출력하시오
SELECT SYSDATE, SYSDATE + 1, SYSDATE + 2
	FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, '토')
	FROM DUAL;

-- 일~토요일까지를 1~7의 값으로 지정되어 있음
-- 오늘 날짜를 기준으로 다음의 요일이 며칠인지를 구함
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7)
	FROM DUAL;

-- LAST_DAY: 해당 일자가 포함된 월의 마지막 날짜를 출력
SELECT LAST_DAY('2020-02-01') 
	FROM DUAL;

-- 12시를 기준으로 넘어가면 다음 날짜, 12시 이전이면 당일 날짜
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE)
	FROM DUAL;

-- 사원테이블에서 사원의 이름, 직업, 입사일, 오늘기준 근무일수, 오늘기준 근무개월수 출력
SELECT ENAME , JOB , HIREDATE, TRUNC(SYSDATE-HIREDATE) "근무일수", 
			TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)) "근무개월수" 
	FROM EMP;

-----------------------------------------------------------------------------------

-- 묵시적 형변환
SELECT 1+ '1'
	FROM DUAL;

-- 명시적 형변환
SELECT 1 + TO_NUMBER('1') 
	FROM DUAL;

-- 형변환 불가
SELECT 1 + 'A'
	FROM DUAL;

-- 수동(명시적) 형변환: 숫자, 문자, 날짜 데이터간에 형변환시 함수를 사용함

SELECT SYSDATE 
	FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY') 연도, TO_CHAR(SYSDATE, 'MM') 월 
	FROM DUAL;

-- 1990년에 입사한 사원 검색
SELECT ENAME , HIREDATE
	FROM EMP
	WHERE TO_CHAR(HIREDATE, 'YYYY') = '1990'; 

SELECT TO_CHAR(SYSDATE , 'DD'), TO_CHAR(SYSDATE , 'DAY'), TO_CHAR(SYSDATE , 'DDTH') 
	FROM DUAL ;

SELECT SYSDATE , TO_CHAR(SYSDATE, 'YYYY-MM-DD:HH24:MI:ss')
	FROM DUAL;

-- student 테이블의 birthday 컬럼을 참조하여 생일이 3월인 학생들의 이름과 생일을 출력
SELECT NAME , TO_CHAR(BIRTHDAY , 'yyyy') || '년 ' || TO_CHAR(BIRTHDAY ,'mon') || TO_CHAR(BIRTHDAY, 'DD') || '일' 생년월일
	FROM STUDENT
	WHERE TO_CHAR(BIRTHDAY , 'MM') = '03'; 	

-----------------------------------------------------------------------------------

-- TO_CHAR를 이용하여 NUMBER를 문자타입으로 바꿀 수 있음, 형태 저장가능
SELECT name, TO_CHAR((PAY * 12) + BONUS , '99,999') 연봉 
	FROM PROFESSOR
	WHERE DEPTNO = '101';

-- TO_DATE는 문자형태의 날짜를 DATE타입으로 바꿀 수 있음
SELECT TO_DATE('2023-04-13') 
	FROM DUAL ;

/*
-Professor 테이블을 사용하여 1990년 이전에 입사한 교수명과 입사일, 현
재 연봉과 10% 인상 후 연봉을 출력하세요. 연봉은 상여금(bonus)를
제외한 (pay*12) 로 계산하고 연봉과 인상 후 연봉은 천 단위 구분 기호를 추
가하여 출력하세요.
*/
SELECT NAME 이름
       , HIREDATE 입사일
       , TO_CHAR(PAY*12,'99,999') 연봉 
       , TO_CHAR(PAY*12*1.1,'99,999') 인상후
	FROM PROFESSOR;
	
-- NVL: NULL값을 체크해서 다른 값으로 대체
SELECT NVL(SAL,0), NVL(JOB,'무직'),NVL(HIREDATE,SYSDATE)
	FROM EMP;

SELECT NAME, NVL(BONUS,0), NVL(HPAGE,'홈페이지 없음')
	FROM PROFESSOR;

SELECT NAME 이름, PAY 월급, NVL(BONUS,0) 보너스, PAY*12+NVL(BONUS,0) 연봉
	FROM PROFESSOR;

-- NVL2는 NULL값이 아닌 경우와 NULL값인 경우 다르게 값을 부여하고자 할때 사용
-- BONUS가 NULL이 아닌 경우 PAY*12+BONUS 출력하고
-- BONUS가 NULL인 경우 PAY*12 출력
SELECT NAME 이름, PAY 월급, NVL2(BONUS,PAY*12+BONUS,PAY*12) 연봉
	FROM PROFESSOR;

-- DECODE는 두 값을 비교해서 같을 경우와 다른 경우에 따라서 값을 출력
-- DECODE('A', 'B', 1, 0): A와 B가 같으면 1출력 다르면 0 출력 / NULL 생략 가능
-- DECODE( A , B , '1' , C , '2' , '3' ): A가 B일 경우 1을 출력, A가 C일 경우 2를 출력, 둘 다 아니면 3을 출력 
SELECT DECODE('A', 'A', '1', '0') 
	FROM DUAL ;

SELECT NAME 교수명, DEPTNO 학과번호, DECODE(DEPTNO, '101', '컴퓨터 공학', NULL) 학과명
	FROM PROFESSOR ;

SELECT NAME 교수명, DEPTNO 학과번호, DECODE(DEPTNO, '101', '컴퓨터 공학', '기타 학과') 학과명
	FROM PROFESSOR ;

SELECT NAME 교수명, DEPTNO 학과번호, DECODE(DEPTNO, '101', '컴퓨터 공학', '102', '멀티미디어 공학과', '기타 학과') 학과명
	FROM PROFESSOR ;

-- CASE: 조건문, DECODE함수와 같은 기능
/*
	CASE 조건값
	WHEN 값1 THEN '문자열'
	WHEN 값2 THEN '문자열';
	
	ELSE '문자열' END
 */
-- 학생의 이름, 전화번호, 지역명 출력하기(CASE문 사용)
-- 지역명은 전화번호의 지역구분이 02면 서울, 051 부산, 052 울산 055경남 그외는 기타로 출력
SELECT NAME , TEL,
	CASE substr(TEL, 1, INSTR(TEL, ')')-1)
		WHEN '02' THEN '서울'
		WHEN '051' THEN '부산'
		WHEN '052' THEN '울산'
		WHEN '055' THEN '경남'
		ELSE '기타' 
	END
	FROM STUDENT ;

-- 학생의 주민번호 일곱번째 자리가 1,3인 경우는 '남자', 2,4인 경우는 여자로 출력
-- 이름, 주민번호, 성별 출력
SELECT NAME 이름, JUMIN 주민번호, 
	CASE SUBSTR(JUMIN, 7, 1) 
		WHEN '1' THEN '남자'
		WHEN '3' THEN '남자'
		WHEN '2' THEN '여자'
		WHEN '4' THEN '여자'
	END 성별
	FROM STUDENT;

SELECT NAME , JUMIN, 
	CASE WHEN SUBSTR(JUMIN, 7, 1) IN('1', '3') THEN '남자'
		 WHEN SUBSTR(JUMIN, 7, 1) IN('2', '4') THEN '여자'
	END 성별
	FROM  STUDENT ;

-- 학생의 생일이 1~3월인 경우 1분기, 4~6월인 경우 2분기, 7~9월인 경우 3분기, 10~12월인 경우 4분기 출력
-- 학생의 생일은 주민버호를 기준으로 하고, 이름, 주민번호, 출생분기 출력
SELECT NAME 이름, JUMIN 주민번호, 
	CASE WHEN SUBSTR(JUMIN, 3, 2) IN('01', '02', '03') THEN '1분기'
		 WHEN SUBSTR(JUMIN, 3, 2) IN('04', '05', '06') THEN '2분기'
		 WHEN SUBSTR(JUMIN, 3, 2) IN('07', '08', '09') THEN '3분기'
		 WHEN SUBSTR(JUMIN, 3, 2) IN('10', '11', '12') THEN '4분기' 
	END 출생분기
	FROM STUDENT ;

SELECT NAME 이름, JUMIN 주민번호, 
	CASE WHEN SUBSTR(JUMIN, 3, 2) BETWEEN '01' AND '03' THEN '1분기'
		 WHEN SUBSTR(JUMIN, 3, 2) BETWEEN '04' AND '06' THEN '2분기'
		 WHEN SUBSTR(JUMIN, 3, 2) BETWEEN '07' AND '09' THEN '3분기'
		 WHEN SUBSTR(JUMIN, 3, 2) BETWEEN '10' AND '12' THEN '4분기' 
	END 출생분기
	FROM STUDENT ;
	
-------------------------------------------------------------------------------------

-- 복수행 함수(그룹함수): 여러행에 대한 정보를 조회하는 함수
-- COUNT(): 레코드의 건수, NULL값을 제외한 건수 / NULL값까지 포함 시키려면 NVL함수를 써줘야 함
SELECT COUNT(NAME), COUNT(NVL(BONUS,0))
	FROM PROFESSOR ;

-- SUM(): 여려행의 값을 합한값	, NULL값을 제외 / NULL값은 포함되지 않기 때문에 결과값이 같음
SELECT SUM(BONUS), SUM(NVL(BONUS, 0)) 
	FROM PROFESSOR ;

-- AVG(): 여러행 값의 평균값	/ NULL값을 출력하지 않으면 결과값이 달라질 수 있음 
SELECT COUNT(NVL(BONUS,0)), SUM(NVL(BONUS,0)), AVG(NVL(BONUS,0))  
	FROM PROFESSOR ;

-- MAX(): 여러행 갑중에 최대값 / MIN(): 여러행 값중에 최소값
-- STDDEV(): 표준편차값, 분산의 제곱근
-- VARIANCE(): 분산값, 관측값에서 평균을 뺀 값을 제곱하고, 모두 더한 후 전체 개수로 나눈다
-- 분산값과 표준편차가 크다는 의미는 측정된 값이 평균에서 많이 떨어져서 분포하고 있다는 것을 나타낸다
-- 즉, 데이터들이 넓게 퍼져있음을 의미
SELECT MAX(PAY), MIN(PAY), STDDEV(PAY), VARIANCE(PAY)  
	FROM PROFESSOR ;

-- GROUP BY: 컬럼을 그룹별로 묶어서 출력할 때 사용 / 복수행 함수 사용시 필수
-- GROUP BY: 특정 컬럼을 기준으로 같은 값을 갖는 행들을 그룹화함 
-- 			 복수행 함수를 사용하는 경우 전체행이 아니면 반드시 GROUP BY를 사용해야 함
-- GROUP BY문에는 별칭을 쓰면 안 되고 반드시 컬럼명을 써야 함
SELECT DEPTNO , AVG(NVL(BONUS, 0)) 
	FROM PROFESSOR 
	GROUP BY DEPTNO ;

-- Professor 테이블에서 학과별, 직급별로 교수들의 평균 보너스를 출력 
SELECT DEPTNO, POSITION ,AVG(NVL(BONUS,0))  -- GROUP BY절에 사용된 컬럼을 반드시 SELECT절에 사용할 필요 없음
	FROM PROFESSOR             
	GROUP BY DEPTNO, POSITION   -- SELECT절에 복수행 함수와 함께 사용된 컬럼은 반드시 GROUP BY절에 포함되어야 함 
	HAVING DEPTNO = '101'		-- HAVING: GROUP BY절을 사용한 경우, 특정 조건을 주고자 할 때 사용 	/ ORACLE문의 WHERE절은 JOIN을 위한 용도
	ORDER BY DEPTNO ;			-- ORDER BY절은 특정 컬럼을 기준으로 정렬하고자 할 때 사용
	
SELECT * FROM STUDENT ;	
SELECT * FROM EMP ; 
SELECT * FROM PROFESSOR ;
