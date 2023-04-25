-- 4월 13일 복습문제 풀이
--1.  EMP 테이블에서 사원이름, 직업, 사원이름에서  'L'자의 첫 위치를 출력하여라
SELECT ENAME, JOB, INSTR(ENAME,'L')
  FROM EMP;

--2. 교수테이블에서 이메일이 있는 교수의 이름, 직책,   email, emailid 를 출력하기
--   emailid는 @앞의 문자를 말한다.
--   email : number1@naver.com
--   emailid : number1
SELECT NAME, POSITION, SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) 이메일아이디
  FROM PROFESSOR
 WHERE EMAIL IS NOT NULL;

--3. 101번 학과 학생의 이름 중 두번째 글자만 '#'으로 치환하여 출력하기
SELECT NAME, REPLACE(NAME, SUBSTR(NAME,2,1),'#')
  FROM STUDENT
 WHERE DEPTNO1 = '101';

--4. 102번 학과 학생의 이름과 전화번호, 전화번호의 국번부분만#으로 치환하여 출력하기(단 국번은 3자리로 간주함.)
SELECT NAME, TEL, REPLACE(TEL,SUBSTR(TEL,INSTR(TEL,')')+1,3),'###')
  FROM STUDENT
 WHERE DEPTNO1 = '102'
UNION ALL
SELECT NAME, TEL, REPLACE(TEL,SUBSTR(TEL,1,INSTR(TEL,')')-1),'###')
  FROM STUDENT
 WHERE DEPTNO1 = '102';

--5. 교수테이블의  email 주소의 @다음의 3자리를 ###으로 치환하여 출력하기
--  교수의 이름, email, #mail을 출력하기
SELECT NAME, EMAIL, REPLACE(EMAIL,SUBSTR(EMAIL,INSTR(EMAIL,'@')+1,3),'###') "#EMAIL"
  FROM PROFESSOR;
  
--6. 교수테이블의  email 주소의 @앞의 3자리를 ###으로 치환하여 출력하기
--   교수의 이름, email, #mail을 출력하기
SELECT NAME, EMAIL, REPLACE(EMAIL,SUBSTR(EMAIL,INSTR(EMAIL,'@')-3,3),'###') "#EMAIL"
  FROM PROFESSOR;

--7. 사원테이블에서 사원이름에 *를 왼쪽에 채워 모두 동일한 15개의 이름으로 변환하고 업무와 급여를 출력한다.
SELECT LPAD(ENAME,15,'*'), JOB, SAL
  FROM EMP;

--8. 교수 테이블에서 입사일이 1-3월인 모든 교수의  급여를 15% 인상하여 정수로 출력하되 반올림(ROUND)된 값과  절삭(TRUNC)된 값을  출력하기.
SELECT NAME, HIREDATE, ROUND(PAY*1.15), TRUNC(PAY*1.15)
  FROM PROFESSOR
 WHERE SUBSTR(HIREDATE,4,2) BETWEEN 01 AND 03;

--9. 교수들의 근무 개월 수를 현재 일을 기준으로  계산하되,  근무 개월 순으로 정렬(ORDER BY)하여 출력하기. 
--  단, 개월 수의 소수점 이하 버린다
SELECT NAME, HIREDATE, TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)) 근무개월
  FROM PROFESSOR
 ORDER BY 근무개월;

--10. 사용자 아이디에서 문자열의 길이가 7이상인   학생의 이름과  사용자 아이디를 출력 하여라
SELECT NAME, ID
  FROM STUDENT
 WHERE LENGTH(ID) >= 7;

--11. 교수테이블에서 이름과, 교수가 사용하는 email  서버의 이름을    출력하라.
--   이메일 서버는 @이후의 문자를 말한다.
SELECT NAME, SUBSTR(EMAIL,INSTR(EMAIL,'@')+1) 이메일서버         --SUBSTR에서 잘라낼크기를 지정하지 않으면 마지막까지 잘라냄.
  FROM PROFESSOR;

--12. 교수테이블에서 교수가 사용하는 email id와   등록된  id가 다른 교수의 이름과 id email을    출력하라.
SELECT NAME, ID, EMAIL
  FROM PROFESSOR
 WHERE SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) != ID;

--13. 101번학과, 201번, 301번 학과 교수의 이름과  id를 출력하는데, id는 오른쪽을 $로 채운 후 
--   20자리로 출력하고  동일한 학과의 학생의   이름과 id를 출력하는데, 
--   학생의 id는 왼쪽#으로 채운 후 20자리로 출력하라.

SELECT NAME, RPAD(ID,20,'$')
  FROM PROFESSOR
 WHERE DEPTNO IN ('101','201','301')
UNION
SELECT NAME, LPAD(ID,20,'#')
  FROM STUDENT
 WHERE DEPTNO1 IN ('101','201','301');

--14. 2021년 2월 10일 부터 2021년 5월 20일까지   개월수를 반올림해서 정수 출력하기
select round(months_between('2021/5/20','2021/02/10')) from dual;

--15. 교수테이블에서 교수명과 입사일, 현재연봉 3%인상 후 연봉을 출력하기
--  단 연봉은 pay * 12로 하고, 인상후 연봉은 소숫점 이하 삭제함(TRUNC)
SELECT NAME, HIREDATE, TRUNC((PAY*12)*1.03) 
  FROM PROFESSOR;

--16. EMP 테이블에서 사원이름, 입사일, 근무개월수, 현재까지 근무일수를 출력하기
--     근무개월수는 소숫점이하 1자리로 반올림하여 출력하고, 근무일수는 버림(TRUNC)하여 정수로 출력하기.
--     단, 근무일수가 많은 사람 순으로 정렬(ORDER BY)하여 출력하기
SELECT ENAME, HIREDATE, ROUND(MONTHS_BETWEEN(SYSDATE,HIREDATE),1) 근무개월수
       , TRUNC(SYSDATE - HIREDATE) 근무일수
  FROM EMP
 ORDER BY 근무일수 DESC;

--17. EMP 테이블에서 10번 부서원의 현재까지의 근무 월수를 계산하여  출력하여라.
--    근무월수는 반올림하여 정수로 출력하기

SELECT ENAME, ROUND(MONTHS_BETWEEN(SYSDATE,HIREDATE))
  FROM EMP
 WHERE DEPTNO = '10';