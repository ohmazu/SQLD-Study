# 2-5. GROUP BY절
## GROUP BY절
- 각 행을 **특정 조건에 따라 그룹으로 분리하여 계산**하도록 하는 구문식


```sql
SELECT * | 컬럼명 | 표현식
  FROM 테이블명 
 WHERE 조회할 데이터 조건
 GROUP BY 그룹핑 컬럼명
 HAVING 그룹핑 대상 필터링 조건 ;
```
- 그룹 연산에서 제외할 대상이 있다면 WHERE절에서 제외 후 GROUP BY절에 그룹을 지정할 컬럼 전달
- 그룹에 대한 조건은 WHERE절에서 사용 불가
- **GROUP BY절을 사용하8면 데이터가 요약되므로 요약되기 전 데이터와 함께 출력 불가**

```sql
# 직군(JOB_ID)별 급여 총합과 급여 평균 출력
SELECT JOB_ID, SUM(SALARY),
       ROUND(AVG(SALARY)) AS AVG_SALARY
  FROM EMPLOYEE
 GROUP BY JOB_ID;
```
- **FROM**: EMPLOYEE 데이터에서 
- **SELECT**: 직군(JOB_ID), 급여 총합(SUM(SALARY)), 급여 평균(ROUND(AVG(SALARY)) 컬럼(표현식) 선택
- **GROUP BY**: 직군(JOB_ID)별

**HAVING절**
- **그룹 함수 결과를 조건으로 사용할 때 사용하는 절**
- WHERE절을 사용하여 그룹을 제한할 수 없으므로 HAVING절에 전달
- 내부적 연산 순서가 SELECT절보다 먼저이므로 SELECT 절에서 선언된 alias 사용 불가

# 2-6. ORDER BY절
**ORDER BY절**
- 데이터는 입력된 순서대로 출력되나, **출력되는 행의 순서를 사용자가 변경**하고자 할 때 사용
```sql
SELECT * | 컬럼명 | 표현식
  FROM 테이블명 
 WHERE 조회할 데이터 조건
 GROUP BY 그룹핑컬럼명
HAVING 그룹핑 대상 필터링 조건
 ORDER BY 정렬컬럼명 (DESC) ;
```
- 정렬 순서: ASC(오름차순), DESC(내림차순)
- SELECT절에서 정의한 alias 사용 가능
- 복합정렬: 먼저 정렬한 값의 동일한 결과가 있을 경우 추가적 정렬 가능

NULL의 정렬
- SQL에서는 NULL값을 포함한 값의 정렬시 처음에 배치

# 2-7. JOIN
**JOIN(조인)**
- **여러 테이블의 데이터를 사용하여 동시 출력하거나 참조**할 경우 사용
- **FROM절에 조인할 테이블 나열**
- 동일한 열 이름이 여러 테이블에 존재할 경우 **열 이름 앞에 테이블 이름이나 alias** 붙임
- n개의 테이블을 조인하려면 최소 n-1개의 조인 조건 필요

**조인의 종류**
1. 조건의 형태에 따라 
- EQUI JOIN: 조인 조건이 동등 조건인 경우
- NON EQUI JOIN: 조건이 동등 조건이 아닌 경우
2. 조인 결과에 따라 
- INNER JOIN: 조인 조건에 성립하는 데이터만 출력
- OUTER JOIN: 조인 조건에 성립하지 않는 데이터도 출력
- NATURAL JOIN: 조인 조건 생략 시 두 테이블에 같은 이름으로 자연 연결되는 조인 
- CROSS JOIN: 조인 조건 생략 시 두 테이블의 발생 가능한 모든 행을 출력하는 조인 
- SELF JOIN: 하나의 테이블을 두 번 이상 참조하여 연결하는 조인

**EQUI JOIN**
- 조인 조건이 **'=' 비교를 통해 같은 값을 가지는 행을 연결**하여 결과를 얻는 조인 방법
```sql
SELECT 테이블1.컬럼, 테이블2.컬럼
  FROM 테이블1, 테이블2
 WHERE 테이블1.컬럼 = 테이블2.컬럼 ; 
```
- FROM절에 조인하고자 하는 테이블을 모두 명시
- WHERE절에 두 테이블의 공통 컬럼에 대한 조인 조건을 나열 

```sql
# EMP 테이블과 DEPT 테이블을 사용하여 각 직원의 이름과 부서명을 함께 출력
SELECT EMP.ENAME, DEPT.DNAME
  FROM EMP, DEPT
 WHERE EMP.DEPTNO = DEPT.DEPTNO ;
```

**NON-EQUI JOIN**
- 테이블을 연결짓는 조인 컬럼에 대한 비교 조건이 '<', BETWEEN a AND b와 같이 '=' 조건이 아닌 연산자를 사용하는 경우의 조인 조건
```sql 
# EMP 테이블의 급여를 확인하고 SAL_GRADE에 있는 급여 등급 기준에 따라 직원 이름과 급여, 급여등급 출력 
SELECT E.ENAME, E.SAL, S.GRADE
  FROM EMP E, SALGRADE S
 WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL ;
```

세 테이블 이상 조인
- n개의 테이블 경우 최소 n-1개의 조인 조건 필요

```sql
# EMPLOYEE, DEPARTMENTS, LOCATION 테이블 조인
SELECT E.EMPLOYEE_ID, E.FRIST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, L.COUNTRY_ID
  FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
  AND D.LOCATION_ID = L.LOCATION_ID ;
```
- 만약 필수 조인 조건이 하나라도 생략될 경우 카타시안곱 발생(정상 조인보다 더 많은 수의 행이 리턴)

**SELF JOIN**
- 한 테이블 내 각 행끼리 관계를 갖는 경우 사용하는 조인 기법
- 한 테이블을 참조할 때마다 명시해야 함
- 테이블명이 중복되므로 반드시 테이블 별칭 사용
```sql
# EMPLOYEES 테이블에서의 각 직원이름과 매니저 이름을 함께 출력
SELECT E1.EMPLOYEE_ID, E1.FIRST_NAME, E1.LAST_NAME, E1.MANAGER_ID, E2.EMPLOYEE_ID, E2.FIRST_NAME, E2.LAST_NAME
  FROM EMPLOYEES E1, EMPLOYEES E2
 WHERE E1.MANAGER_ID = E2.EMPLOYEE_ID
ORDER BY 1, 4;
```
- 조인 조건이 일치하지 않는 데이터를 추가적으로 출력하려면 OUTER JOIN 필요

# 2-8. 표준 조인 
**표준 조인**
- INNER JOIN, CROSS JOIN, NATURAL JOIN, OUTER JOIN 

**INNER JOIN**
- 조인 조건이 일치하는 행만 추출

**ON절**
- 조인할 양 컬럼의 컬럼명이 서로 다르더라도 사용 가능
- ON 조건의 괄호는 옵션(생략 가능)
- ON 조건절에서 조인조건 명시, WHERE절에서는 일반조건 명시 
```sql
SELECT 테이블1.컬럼명, 테이블2.컬럼명
  FROM 테이블 1 INNER JOIN 테이블2
    ON 테이블1.조인컬럼 = 테이블2.조인컬럼 ;
```

**USING절**
- 조인할 **컬럼명이 같을 경우** 사용
- alias나 테이블 이름 같은 경우 접두사 붙이기 불가
- 괄호 필수
```sql
SELECT 테이블1.컬럼명, 테이블2.컬럼명
  FROM 테이블 1 INNER JOIN 테이블2
 USING (동일컬럼명) ;
```

**NATURAL JOIN**
- 두 테이블 간의 **동일한 이륾을 가지는 모든 컬럼들에 대해 EQUI JOIN** 수행
```sql
SELECT 테이블1.컬럼명, 테이블2.컬럼명 
  FROM 테이블 1 NATURAL JOIN 테이블2 ;
```
- **USING, ON, WHERE절에서 조건 정의 불가**
- JOIN에 사용된 컬럼들은 **데이터 유형이 동일**해야 하며 **접두사 사용 불가**
- 조인 컬럼의 값이 모두 같을 때만 결과가 리턴됨

**CROSS JOIN**
- 테이블 간 JOIN 조건이 없는 경우 생성 가능한 모든 테이블의 조합(카타시안 곱 출력)
- 양쪽 테이블 행의 수의 곱한 수의데이터 조합 발생(m*n)
```sql
SELECT 테이블1.컬럼명, 테이블2.컬럼명 
  FROM 테이블1 CROSS JOIN 테이블2 ;
```

**OUTER JOIN**
- 조인 조건에서 동일한 값이 없는 행도 반환
- NULL값을 가질 때도 출력 가능
- 테이블 기준 방향에 따라 LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN으로 구분 
```sql
SELECT S.STUDNO, S.NAME AS 학생명, S.GRADE, S.PROFNO, P.PROFNO, P.NAME AS 교수명
  FROM STUDENT S LEFT OUTER JOIN PROFESSOR P
    ON S.PROFNO = P.PROFNO
 WHERE S.GRADE IN (1, 4) ;
```
- ANSI 표준에서는 조인 종류를 FROM절에 테이블과 테이블 사이 명시
- 조인 조건을 바로 뒤 ON절에 나열
- WHERE절은 ON절 밑에 전달(순서 중요)
