-- 0412 복습문제 풀이
-- 1. 학생의 생일이 77년 이후인 학생의 학번, 이름, 생일을 출력하기
select studno, name, birthday
    from student
    where birthday > '77/12/31';
    
-- 2. professor 테이블에서 직급이 정교수인 교수의 이름과  부서코드, 직급 출력하기
select name, deptno, position
    from professor
    where position = '정교수';
    
-- 3. 학생 테이블을 읽어 '학생이름의 생일은 yyyy-mm-dd  입니다. 축하합니다' 형태로 출력하기  
alter session set nls_date_format='YYYY-MM-DD';
select name || '님의 생일은 ' || birthday || ' 입니다. 축하합니다!'
    from student;

-- 4. 학생 테이블에서 학생 이름과키,몸무게, 표준체중을 출력하기, 표준 체중은 키에서 100을 뺀 값에 0.9를 곱한 값이다.  
select name, height, weight, (height - 100) * 0.9 표준체중
    from student;
    
-- 5. 101 번 학과 학생 중에서 3학년 이상인 학생의 이름, 아이디, 학년을 출력하기 
select name, id, grade
    from student
    where deptno1 = '101'
    and grade >= 3;

-- 6. 비교 연산자와 SQL 연산자(between)를 사용하여 키가  165 이상 175 이하인 학생의 이름, 학년, 키를 출력하여라.
-- 비교 연산자
select name, grade, height
    from student
    where height >= 165 
    and height <= 175;
-- between    
select name, grade, height
    from student
    where height between 165 and 175;
    
-- 7. 학생 중 이름의 끝자가 '훈'인 학생의 학번, 이름, 부서코드 출력하기
select studno, name, deptno1
    from student
    where name like '%훈';
    
-- 8. 학생 중 전화번호(tel)가 서울지역인 학생의 이름, 학번, 전화번호 출력하기
select name, studno, tel
    from student 
    where S(tel, 1, 2) = '02';

-- 9. 학생 중  id에 'M'문자를 가지고 있는 학생의 이름,  id,  학과번호1을 출력하기
select name, id, deptno1
    from student
    where id like '%m%' or id like '%M%';   -- 대소문자 다 찾을 때

-- 10. 학생 테이블에서 학년이 2학년과 3학년이고, 학과가 101이거나 201인 학생의 학번, 이름, 학년, 학과를 출력하기. 단  between과  in연산자를 사용하여 출력하기
select studno, name, grade, deptno1
    from student
    where grade between 2 and 3
    and deptno1 in(101, 201);
 
select studno, name, grade, deptno1
    from student
    where (grade = 2 or grade = 3)
    and (deptno1 = 101 or deptno1 = 201);   
    
-- 11. EMP 테이블에서 급여가 1300에서 1700 사이인 사원의 성명, 업무, 급여, 부서번호(deptno)를 출력하여라.
select ename, job, sal, deptno
    from emp
    where sal between 1300 and 1700;

-- 12. EMP테이블에서 사원번호(empno)가 7902, 7788, 7566 인 사원의 사원번호, 성명, 업무(job), 급여, 입사일자(hiredate)를 출력하여라.
select empno, ename, job, sal, hiredate
    from emp
    where empno in(7902, 7788, 7566);

-- 13. EMP 테이블에서 이름의 첫 글자가 ‘M’인 사원의 이름, 급여를 조회하라.
select ename, sal
    from emp
    where ename like 'M%';

-- 14. EMP 테이블에서 급여가 1100 이상이고, JOB이Manager인 사원의 사원번호, 성명, 담당업무, 급여, 입사일자, 부서번호를 출력하여라.
select empno, ename, job, sal, hiredate, deptno
    from emp
    where sal >= 1100
    and job = 'MANAGER' or job = 'Manager';

-- 15. EMP 테이블에서 JOB이 PRESIDENT이고 급여가 1500 이상이거나 업무가 SALESMAN인 사원의 사원번호, 이름, 업무, 급여를 출력하여라
select empno, ename, job, sal
    from emp
    where (job = 'PRESIDENT' and sal >= 1500) or job = 'SALESMAN';   