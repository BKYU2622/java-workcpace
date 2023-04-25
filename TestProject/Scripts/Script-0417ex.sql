-- 4월 17일 복습문제
SELECT * FROM DEPT d ;
SELECT * FROM DEPT2 d ;
SELECT * FROM DEPARTMENT d ;
SELECT * FROM PROFESSOR p ;
SELECT * FROM STUDENT s ;

-- 1.부서테이블(dept2)에서 각 부서의 상위 부서 이름을 출력, 단 상위부서가 없는 부서도 출력
--ANSI
SELECT d1.DNAME 부서명, d2.DNAME 상위부서명 
	FROM DEPT2 d1 LEFT OUTER JOIN DEPT2 d2
	ON d1.PDEPT = d2.DCODE ;
--ORACLE
SELECT d1.DNAME 부서명, d2.DNAME 상위부서명 
	FROM DEPT2 d1, DEPT2 d2
	WHERE d1.PDEPT = d2.DCODE(+) ;

-- 2.부서테이블(department)에서 공과대학(deptno=10)에 소속된 학과이름을 출력
--SELF JOIN, SUB QUERY
SELECT D1.DNAME 
	FROM DEPARTMENT d1 JOIN DEPARTMENT d2
	ON D1.PART = D2.DEPTNO 
	WHERE D1.PART = (SELECT DEPTNO 
			  		 FROM DEPARTMENT 
					 WHERE DNAME = '공과대학');

-- 3.학생테이블에서 전공학과가 101번인 학생들의 평균몸무게보다 몸무게가 높은 학생들의 이름과 몸무게, 학과명 출력
SELECT S.NAME 이름, S.WEIGHT 몸무게, D.DNAME 학과명
	FROM STUDENT s JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE WEIGHT > (SELECT AVG(WEIGHT)
					FROM STUDENT s
					WHERE DEPTNO1 = '101');

-- 4.교수테이블의 심슨교수와 같은 입사일에 입사한 교수 중 김명선교수 보다 월급을 적게받는 교수의 이름, 급여, 입사일 출력
--SUB QUERY가 두 개 들어가 있는 문 / 첫 번째는 입사일이 같은 경우, 두 번째는 월급이 적은 경우
SELECT NAME 교수명, PAY 급여, HIREDATE 입사일 
	FROM PROFESSOR p  
	WHERE HIREDATE = (SELECT HIREDATE
					  FROM PROFESSOR p
					  WHERE NAME = '심슨')
	AND PAY < (SELECT PAY
				FROM PROFESSOR p
				WHERE NAME = '김명선');					

-- 5.101번 학과 학생들의 평균 몸무게 보다 몸무게가 적은 학생의 학번과, 이름과, 학과번호, 몸무게를 출력
SELECT S.STUDNO 학번, S.NAME 이름, S.DEPTNO1 학과번호, S.WEIGHT 몸무게
  FROM STUDENT S 
 WHERE S.WEIGHT < (SELECT AVG(WEIGHT)
                   FROM STUDENT
                   WHERE DEPTNO1 = 101);
                  
-- 학과 이름이 필요한 경우
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 학과명, S.WEIGHT 몸무게
	FROM STUDENT s JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE S.WEIGHT < (SELECT AVG(WEIGHT)
					  FROM STUDENT s
					  WHERE DEPTNO1 = 101);				
	
-- 6.9712학생과 학년이 같고 키는 9713학생보다 큰 학생의 이름, 학년, 키를 출력
SELECT NAME 이름, GRADE 학년, HEIGHT 키 
	FROM STUDENT s 
	WHERE GRADE = (SELECT GRADE 
				   FROM STUDENT s
				   WHERE STUDNO = 9712)
	AND HEIGHT > (SELECT HEIGHT
				  FROM STUDENT s
			      WHERE STUDNO = 9713);				

-- 7.컴퓨터정보학부에 소속된 모든 학생의 학번,이름, 학과번호 출력
SELECT STUDNO 학번, NAME 이름, DEPTNO1 학과번호
	FROM STUDENT s 
	WHERE DEPTNO1 IN(SELECT D1.DEPTNO
					 FROM DEPARTMENT d1 JOIN DEPARTMENT d2
					 ON D1.PART = D2.DEPTNO 
					 WHERE D2.DNAME = '컴퓨터정보학부');
--학과이름을 출력할 때					
SELECT S.STUDNO 학번, S.NAME 이름, D.DNAME 학과명,S.DEPTNO1 학과번호
	FROM STUDENT s JOIN DEPARTMENT d 
	ON S.DEPTNO1 = D.DEPTNO 
	WHERE DEPTNO1 IN(SELECT D1.DEPTNO
					 FROM DEPARTMENT d1 JOIN DEPARTMENT d2
					 ON D1.PART = D2.DEPTNO 
					 WHERE D2.DNAME = '컴퓨터정보학부');					
	
-- 8.4학년학생 중 키가 제일 작은 학생보다 키가 큰 학생의 학번,이름,키를 출력
SELECT STUDNO 학번, NAME 이름, HEIGHT 키 
	FROM STUDENT s 
	WHERE HEIGHT > (SELECT MIN(HEIGHT)  
					FROM STUDENT s
					WHERE GRADE = 4);
					
-- 9.학생 중에서 생년월일이 가장 빠른 학생의 학번, 이름, 생년월일을 출력
SELECT STUDNO 학번, NAME 이름, BIRTHDAY 생년월일 
	FROM STUDENT s 
	WHERE BIRTHDAY = (SELECT MIN(BIRTHDAY)
					  FROM STUDENT s);

-- 10.학년별로 평균체중이 가장 적은 학년의 학년과 평균 몸무게를 출력
--컬럼별로 이기 때문에 GROUP BY절 사용 / HAVING: GROUP BY절에서 조건 줄 때 사용 
SELECT GRADE 학년, AVG(WEIGHT) "평균 몸무게"
	FROM STUDENT s 
	GROUP BY GRADE 
	HAVING AVG(WEIGHT) = (SELECT MIN(AVG(WEIGHT))
						  FROM STUDENT s
						  GROUP BY GRADE); 
--학년별 평균 몸무게
SELECT GRADE 학년, AVG(WEIGHT) "평균 몸무게"
	FROM STUDENT s 
	GROUP BY GRADE;
--학년중에 평균 몸무게가 가장 적은 몸무게
SELECT MIN(AVG(WEIGHT))
	FROM STUDENT s
	GROUP BY GRADE;
	