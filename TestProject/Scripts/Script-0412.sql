SELECT * FROM emp;

SELECT id, initcap(id), UPPER(id)  	
	FROM STUDENT s 					 
 	WHERE DEPTNO1 = '201';

SELECT name, id, LENGTH(id)
 	FROM student 
 	WHERE LENGTHB (id) >= 9;
 	
SELECT name, LENGTH(name), LENGTHB(name)
	FROM STUDENT s 
	WHERE DEPTNO1 = '201';
	
SELECT SUBSTR('ABCDE', 2, 3)	-- B부터 3개
	FROM dual;

SELECT SUBSTR('ABCDE', -2, 3)	-- D부터 3개 
	FROM dual;
	
SELECT id
	FROM STUDENT s;

-- 학생테이블에서 4번째 id값의 4번째 글자가 n인 학생의 이름과 id출력
SELECT name, id
	FROM STUDENT s
	WHERE SUBSTR(id, 4, 1) = 'n';
	
SELECT name, SUBSTR(jumin, 1, 6)
	FROM STUDENT s 
	WHERE DEPTNO1 = '101';

SELECT name || '님의 생일은 ' || SUBSTR(JUMIN, 1, 2) || '년 ' || SUBSTR(JUMIN, 3, 2) || '월 ' || SUBSTR(JUMIN, 5, 2) || '일 입니다.'  
	FROM STUDENT s 
	WHERE DEPTNO1 = '101'
	AND SUBSTR(jumin, 3, 2) = '08'; 

SELECT name, tel, SUBSTR(tel, 1, 3) 지역번호
	FROM STUDENT; 
	
SELECT name, tel, SUBSTR(tel, 1, (INSTR(tel, ')')-1)) 지역번호
	FROM STUDENT; 						-- )를 찾아서 -1을 해주면 지역번호까지만 출력