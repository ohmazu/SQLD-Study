# 2-9. 서브 쿼리

**서브 쿼리** 
- 하나의 SQL문 안에 또 다른 SQL문을 의미
- 반드시 괄호로 묶어야 함

**서브쿼리 사용 가능한 위치**
- SELECT 절
- FROM 절
- WHERE 절
- HAVING 절
- ORDER BY 절
- 기타 DML(INSERT, DELETE, UPDATE)절 
- ***GROUP BY절 사용 불가***

**서브쿼리 종류**
1. 동작하는 방식에 따라

1-1.  UN-CORRELATED(비연관) 서브 쿼리 
- 서브쿼리에 메인쿼리(외부쿼리) 테이블의 컬럼을 포함하지 않은 형태의 서브쿼리
- 서브쿼리가 메인쿼리의 값을 참조하지 않고 독립적으로 실행됨
- 서브쿼리는 한 번만 실행됨
```sql
SELECT ENAME, SAL
  FROM EMP E1
 WHERE E1.SAL > (SELECT AVG(E2.SAL)
                   FROM E2) ;
```

1-2. CORRELATED(연관) 서브쿼리
- 서브쿼리에 메인쿼리(외부쿼리) 테이블의 컬럼을 포함하는 형태의 서브쿼리
- 서브쿼리가 메인쿼리의 컬럼을 참조하고 있기 때문에 서브쿼리의 실행이메인쿼리와 독립적이지 않음
- 메인쿼리의 각 행에 대해 서브쿼리가 실행됨
```sql
SELECT ENAME, SAL
  FROM EMP E1
 WHERE E1.SAL > (SELECT AVG(E2.SAL)
                   FROM EMP E2
                 WHERE E2.DEPTNO = E1.DEPTNO) ;
```
- 서브쿼리에서 메인쿼리의 컬럼인 E1.DEPTNO를 참조하고 있기 때문에 서로 독립적으로 수행되지 않고 메인쿼리의 각 행마다 서브쿼리가 실행됨 

2. 위치에 따라

2-1. 스칼라 서브쿼리
- SELECT절에 사용하는 서브쿼리
- 서브쿼리 결과를 마치 **하나의 컬럼처럼 사용**하기 위해 주로 사용
```sql
SELECT * | 컬럼명 | 표현식
      (SELECT * | 컬럼명 | 표현식
         FROM 테이블명 또는 뷰명
         ...)
  FROM 테이블명 또는 뷰명 ;
```

2-2. 인라인뷰
- FROM 절에 사용하는 서브쿼리
- 서브쿼리 결과를 **테이블처럼 사용**하기 위해 주로 사용
```sql
SELECT * | 컬럼명 | 표현식
  FROM (SELECT * | 컬럼명 | 표현식
          FROM 테이블명 또는 뷰명
          ...) ;
```

2-3. WHERE절 서브쿼리
- 가장 일반적인 서브쿼리
- 비교 상수 자리에 값을 전달하기 위한 목적으로 주로 사용(상수항의 대체)
- 반환되는 데이터의 형태에 따라 단일행 서브쿼리, 다중행 서브쿼리, 다중컬럼 서브쿼리, (상호)얀관 서브쿼리로 구분
```sql
SELECT * | 컬럼명 | 표현식
  FROM 테이블명 또는 뷰명
 WHERE 조건대상 연산자(SELECT * | 컬럼명 | 표현식
                     FROM 테이블명 또는 뷰명
                     ...) ;
```

**WHERE절 서브쿼리 종류**
1. 단일행 서브 쿼리
- 서브쿼리 결과가 1개의 행만 리턴되는 형태 
- 연산자
    - = : 같다 / <> : 같지 않다 
    - '>' : 크다 / >= 크거나 같다
    - < : 작다 / <= : 작거나 같다 

2. 다중행 서브쿼리
- 서브쿼리 결과가 여러 행을 리턴하는 형태
- =, <, >와 같은 비교 연산자 사용 불가
- 서브쿼리 결과를 한 행으로 요약하거나 다중행 서브쿼리 연산자를 사용하여 해결
- 연산자 
    - IN : 같은 값을 찾음
    - <ANY : 최대값보다 작은 행 반환 / >ANY : 최소값보다 큰 행 반환  
    - <ALL : 최소값보다 작은 반환 / >ALL : 최대값보다 큰  반환
    - EXISTS : 서브쿼리가 하나 이상의 결과 반환시 TRUE / NOT EXISTS : 서브쿼리가 결과를 반환하지 않으면 TRUE

3. 다중컬럼 서브쿼리
- 서브쿼리 결과가 여러 컬럼을 리턴하는 형태
- 메인쿼리와 비교하는 컬럼이 두 개 이상인 형태
- 대소 비교 조건 전달 불가(두 값을 동시에 묶어 대소 비교를 할 수 없으므로)

4. 상호연관 서브쿼리
- 메인쿼리와 서브쿼리 간의 비굘르 수행하는 형태
- 비교할 집단이나 조건은 서브쿼리에 명시되어야 함
- 서브쿼리가 메인쿼리의 컬럼을 참조하고 있기 때문에, 메인쿼리 실행 시 서브쿼리가 항상 실행되는 형태
- 연산 순서
    - 메인쿼리 테이블 읽기(한 행씩)
    - 메인쿼리 WHERE절 확인(SAL 확인)
    - 서브쿼리 테이블 읽기(FROM 절부터)
    - 서브쿼리 WHERE절 확인 -> 다시 메인쿼리의 DEPTNO(E1.DEPTNO) 요구
    - 서브쿼리에서 E1.DEPTNO값과 같은 대상을 찾아 AVG(SAL) 연산
    - SAL > AVG(SAL) 조건을 만족하는 행만 추출

    *상호연관 서브쿼리 사용 시 GROUP BY 생략 가능*

**인라인뷰(Inline View)**
- 쿼리 안의 뷰의 형태로, 테이블처럼 조회할 데이터를 정의하기 위해 사용
- 테이블명이 존재하지 않기 때문에 다른 테이블과 조인 시 반드시 테이블 별칭을 명시해야 함(조인 업싱 단독으로 사용하는 경우 불필요)
- 서브쿼리에서 출력되는 결괄르 메인 쿼리의 어느 절에서도 사용할 수 있음
- 인라인 뷰의 결과는 메인쿼리 테이블과 조인할 목적으로 주로 사용
- 모든 비교 연산자 사용 가능
```sql
SELECT E.EMPNO, E.NAME, E.SAL, I.AVG_SAL
  FROM EMP E, (SELECT DEPTNO, AVG(SAL) AS AVG_SAL
                 FROM EMP
                GROUP BY DEPTNO) I
 WHERE E.DEPNO = I.DEPTNO
   AND E.SAL > I.AVG_SAL ;
```

**스칼라 서브쿼리**
- SELECT절에 사용하는 쿼리로, 마치 하나의 컬럼처럼 표현하기 위해 사용(단, 하나의 출력 대상만 표현 가능)
- 각 행마다 스칼라 서브쿼리 결과가 하나여야 함(단일행 서브쿼리 형태)
- 조인의 대체 연산
- 스칼라 서브쿼리를 사용한 조인 시 OUTER JOIN이 기본(조인 조건에 일치하는 대상이 없어도 생략되지 않고 NULL로 출력됨)
```sql
SELECT EMPNO, ENAME,
       (SELECT DNAME
          FROM DEPT D
         WHERE D.DEPTNO = E.DEPTNO) AS DNAME
  FROM EMP E
 WHERE DEPTNO = 1O ;
```

**서브쿼리 주의사항**
- 특별한 경우(TOP-N 분석 등)을 제외하고는 서브쿼리 절에 ORDER BY절 사용 불가
- 단일행 서브쿼리와 다중행 서브쿼리에 따라 연산자의 선택 필요


# 2-10. 집합 연산자

**집합 연산자**
- SELECT문 결과를 하나의 집합으로 간주, **그 집합에 대한 합집합, 교집합, 차집합 연산**
- SELECT문과 SELECT문 사이에 집합 연산자 정의
- 두 집합의 컬럼이 동일하게 구성되어야 함(각 컬럼의 데이터 타입과 순서 일치 필요)
- 전체 집합의 데이터타입과 컬럼명은 첫번째 집합에 의해 결정됨

**합집합**
- UNION과 UNION ALL 사용 가능

1. UNION
- 중복된 데이터는 한 번만 출력
- 중복된 데이터를 제거하기 위해 내부적으로 정렬 수행
- 중복된 데이터가 없을 경우는 UNION 사용 대신 UNION ALL 사용 권고 

2. UNION ALL
- 중복된 데이터도 전체 출력 

```sql
SELECT EMPNO, ENAME, DEPTNO
  FROM EMP
 WHERE DEPTNO !- 10
 UNION
SELECT EMPNO, ENAME, DEPTNO
  FROM EMP
 WHERE DEPTNO = 20 ;
```

**교집합**
- INTERSECT

**차집합**
- MINUS
- 집합 순서 주의(A-B, B-A)

**집합 연산자 사용시 주의 사항**
- 두 집합의 컬럼 수 일치
- 두 집합의 컬럼 순서 일치
- 두 집합의 각 컬럼의 데이터 타입 일치
- 긱 칼람의 사이즈는 달라도 됨
- **개별 SELECT문에 ORDER BY 전달 불가**(GROUP BY 전달 가능)

# 2-11. 그룹 함수

**그룹함수**
- 숫자함수 중 여러 값을 전달하여 하나의 요약 값을 출력하는 다중행 함수
- 수학/통계 함수들(기술통계)
- GROUP BY 절에 의해 그룹별 연산 결과를 리턴
- **반드시 한 컬럼만 전달**
- NULL은 무시하고 연산 

**COUNT**
- 테이블의 행의 수를 세는 함수
- 인수: * 또는 하나의 표현식
- 문자, 숫자, 날짜 컬럼 모두 전달 가능
- NULL은 세지 않음
- COUNT(*)은 항상 모든 행의 수 출력
```sql
SELECT COUNT(*)
       COUNT(EMPNO)
       COUNT(COMM)
  FROM EMP ;
```

**SUM**
- 총합 출력
- 숫자 컬럼만 전달 가능
```sql
SELECT SUM(SAL)
  FROM EMP ; 
```

**AVG**
- 평균 출력
- 숫자 컬럼만 전달 가능
- NULL을 제외한 대상의 평균을 리턴하므로 전체 대상 평균 연산 시 주의
```sql
SELECT AVG(COMM),
       SUM(COMM) / COUNT(EMPNO) AS AVG2,
       AVG(NVL(COMM, 0)) AS AVG3
  FROM EMP ;
```

**MIN/MAX**
- 최소, 최대 출력
- 날짜, 숫자, 문자 모두 가능
```sql
SELECT MIN(ENAME), MAX(ENAME)
       MIN(SAL), MAX(SAL)
       MIN(HIREDATE), MAX(HIREDATE)
  FROM EMP ; 
```

**VARIANCE/STDDEV**
- 분산과 표준편차
- 표준편차는 분산의 루트값

**GROUP BY FUNCION**
- GROUP BY절에 사용하는 함수
- 여러 GROUP BY 결과를 동시에 출력하는 기능
- 그룹핑 할 그룹을 정의 
1. GROUPING SETS(A, B, ...)
- A별, B별 그룹 연산 결과 출력
- 나열 순서 중요하지 x
- 기본 출력에 전체 총계는 출력되지 x
- NULL 혹은 () 사용하여 전체 총합 출력 가능
- UNION ALL로 대체 가능
```sql
SELECT DEPTNO, JOB, SUM(SAL)
  FROM EMP
 GROUP BY GROUPING SETS(DEPTNO, JOB) ;
```
- DEPTN별 SAL의 총합과 JOB별 SAL의 총합 결과 

2. ROLLUP(A, B)
- A별, (A, B)별, 전체 그룹 연산 결과 출력
- 나열 대상의 순서 중요
- 가본적으로 전체 총계가 출력됨
```sql
SELECT DEPTNO, JOB, SUM(SAL)
  FROM EMP
 GROUP BY DEPTNO, JOB
 UNION ALL
SELECT DEPTNO, NULL, SUM(SAL)
  FROM EMP
 GROUP BY DEPTNO
 UNION ALL 
SELECT NULL, NULL, SUM(SAL)
  FROM EMP ;
```

3. CUBE(A, B)
- A별, B별, (A,B)별, 전체 그룹 연산 결과 출력
- 그룹으로 묶을 대상의 나열 순서 중요x
- 기본적으로 전체 총계가 출력
```sql
SELECT DEPTNO, JOB, SUM(SAL)
  FROM EMP
 GROUP BY CUBE(DEPTNO, JOB) ; 




