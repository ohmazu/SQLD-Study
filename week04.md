# 2-12. 윈도우함수

**WINDOW FUNCTION**
- **서로 다른 행의 비교나 연산**을 위해 만든 함수
- GROUP BY를 쓰지 않고 그룹 연산 간으 
- LAG, LEAD, SUM, AVG, MIN, MAX, COUNT, RANK

**PARTITION BY 절**
- 출력할 총 데이터 수 변화 없이 그룹 연산 수행할 GROUP BY 컬럼 

**ORDER BY 절**
- RANK의 경우 필수 (정렬 컬럼 및 정렬 순서에 따라 순위 변화)

**ROWS/RANGE BETWEEN A AND B**
- 연산 범위 설정
- ORDER BY 절 필수

*PARTITION BY, ORDER BY, ROWS 절 전달 순서 중요(PARTITION BY 전에 ORDER BY 불가)* 
```sql
# 그룹함수 오류
SELECT EMPNO, ENAME, SAL, DEPTNO, SUM(SAL)
  FROM EMP ;
```
- 전체를 출력하는 컬럼과 그룹함수 결과는 함께 출력 불가

**윈도우 함수의 형태**
- SUM, COUNT, AVG, MIN, MAX 등
- OVER절을 사용하여 윈도우 함수로 사용 가능
- 반드시 연산할 대상을 그룹함수의 입력값으로 전달

```sql
SELECT SUM([대상]) OVER([PARTITON BY 컬럼])
                       [ORDER BY 컬럼 ASC|DESC]
                       [ROWS|RANGE BETWEEN A AND B]
```

1. SUM OVER()
- 전체 총합, 그룹별 총합 출력 가능 
```sql
# 각 직원 정보와 함께 급여 총합 출력 -> 직원 정보와 급여 총합을 동시에 출력 시 에러 발생
SELECT EMPNO, ENAME, SAL, DEPTNO, 
       SUM(SAL) OVER () AS TOTAL
  FROM EMP ;
```
- 서브쿼리 사용도 가능 

2. AVG OVER()
- 전체 평균, 그룹별 평균 출력 가능 

3. MIN/MAX OVER()

4. COUNT()

**윈도우 함수 연산 대상 및 범위**
1. 연산 대상
- ROWS:연산을 할 행을 지정
- RANGE(DEFAULT) : 연산을 할 범위를 지정

2. 범위 
- A: 시작점
    - CURRENT ROW: 현재 행부터
    - UNBOUNDED PRECEDING: 처음부터 
    - N PRECEDING : N 이전부터 
- B: 마지막 지점 정의
    - CURRENT ROW: 현재 범위까지
    - UNBOUNDED FOLLOWING: 마지막까지
    - N FOLLOWING: N 이후까지
3. 특징 
- BETWEEN A: and b가 생략된 것으로 CURRENT ROW가 적용
```sql
SELECT NO, SAL
       SUM(SAL) OVER(ORDER BY SAL) AS RESULT1,
       SUM(SAL) OVER(ORDER BY SAL
                     RANGE BETWEEN UNBOUNDED PRECEDING
                           AND CURRENT ROW) AS RESULT2
  FROM WINDOW_TAB1 ; 
```
**순위 관련 함수**
1. RANK
- RANK WITHIN GROUP
    - 특정값에 대한 순위 확인
    - 윈도우함수가 아닌 일반함수
- RANK() OVER()
    - 전체 또는 특정 그룹 내 값의 순위 확인 
    - ORDER BY절 필수
    - 순위를 구할 대상을 ORDER BY 절에 명시(여러 개 나열 가능)
    - 그룹 내 순위를 구할 시 PARTITION BY 절 사용 
```sql
SELECT RANK() OVER([PARTITION BY 컬럼]
                    ORDER BY 컬럼 ASC|DESC)
```
2. DENSE_RANK
- 누적순위
- 값이 같을 때 동일한 순위 부여 후 다음 순위가 바로 이어지는 순위 부여 방식

3. ROW_NUMBER
- 연속된 행 번호
- 동일한 순위 인정x, 나열한대로 순서 값 리턴

> RANK, DENSE_RANK, ROW_NUMBER 비교
- 2, 3번이 동순위일 때
1. RANK: 1 2 2 4 5 ...
2. DENSE_RANK: 1 2 2 3 4 ...
3. ROW_NUMBER: 1 2 3 4 5 ...

**LAG, LEAD**
- 행 순서대로 각각 이전 값(LAG), 이후 값(LEAD) 가져오기 
- ORDER BY절 필수 
```sql
SELECT LAG(컬럼,
           [N])
           OVER ([PARTITION BY 컬럼]
           ORDER BY 컬럼 [ASC|DESC]) ;
```

**FIRST_VALUE, LAST_VALUE**
- 정렬 순서대로 정해진 범위에서의 처음 값, 마지막 값 출력 
- 순서와 범위 정의에 따라 최솟값과 최댓값 리턴 가능
- PARTITION BY, ORDER BY절 생략 가능
```sql
SELECT FIRST_VALUE(대상) OVER ([PARTITION BY 컬럼]
                              [ORDER BY 컬럼]
                              [RANGE|ROWS BETWWEN A AND B])
```

**NTILE**
- 행을 특정 컬럼 순서에 따라 정해진 수의 그룹으로 나누기 위한 함수
- 그룹 번호가 리턴
- ORDER BY 필수
- PARTITION BY를 사용하여 특정 그룹을 또 원하는 수만큼 그룹 분리 가능
- 총 행의 수가 명확히 나눠지지 않을 때 앞 그룹의 크기가 더 크게 분리됨 
```sql
SELECT NTILE(N) OVER ([PARTITION BY 컬럼]
                      ORDER BY 컬럼 ASC|DESC)
```

**비율관련 함수**
1. RATIO_TO_REPORT
- 각 값이 전체 합에서 차지하는 비율을 계산 
- ORDER BY절 사용 불가 
```sql
RATIO_TO_REPORT(대상) OVER ([PARTITION BY 컬럼])
```

2. CUME_DIST
- 해당 값보다 작거나 같은 값의 비율을 계산 
- ORDER BY절 필수
```sql
CUME_DIST() OVER ([PARTITION BY 컬럼]
                   ORDER BY 컬럼 ASC|DESC)
```

3. PERCENT_RANK
- 주어진 값이 데이터 집합 내에서 상대적으로 어디에 위치하는지를 비율(퍼센트)로 나타내는 함수
- 0과 1 사이의 값으로 표현
- ORDER BY절 필수

```sql
PERCENT_RANK() OVER ([PARTITION BY 컬럼]
                      ORDER BY 컬럼 ASC|DESC)
```


# 2-13. TOP N QUERY

**TOP N 쿼리**
- 페이징 처리를 효과적으로 수행하기 위해 사용
- 전체 결과에서 특정 N개 추출 

**TOP-N 행 추출 방법**
- ROWNUM
- RANK
- FETCH
- TOP N

**ROWNUM**
- 출력된 데이터 기준으로 행 번호 부여
- 절대적인 행 번호가 아닌 가상의 번호이므로 특정 행 지정 불가(=연산 불가)
- 첫 번째 행이 증가한 이후 할당되므로 '>' 연산 사용 불가
```sql
SELECT ROWNUM, EMP.*
  FROM EMP
 WHERE SAL >= 1500 ;
```

```sql
# EMP 테이블에서 급여가 높은 순서대로 상위 5명의 직원 정보 출력
SELECT *
  FROM (SELECT *
          FROM EMP
         ORDER BY SAL DESC)
 WHERE ROWNUM <= 5
 ORDER BY SAL DESC ;
```
-> 먼저 서브쿼리를 사용하여 SAL에 대해 내림차순 정렬 후 상위 5개 추출

**FETCH 절**
- 출력될 행의 수를 제한하는 절
- ORDER BY 절 뒤에 사용

```sql
SELECT
  FROM
 WHERE
 GROUP BY
HAVING
 ORDER BY
OFFSET N { ROW | ROWS }
 FETCH { FIRST | NEXT } N { ROW | ROWS } ONLY ;
```
- OFFSET: 건너뛸 행의 수
- N: 출력할 행의 수
- FETCH: 출력할 행의 수를 전달하는 구문
- FIRST: OFFSET을 쓰지 않았을 때 처음부터 N행 출력 명령
- NEXT: OFFSET을 사용했을 경우 제외한 행 다음부터 N행 출력 명령

```sql
# EMP 테이블에서 급여가 높은 순서대로 4~5번째 해당하는 직원 정보 출력
SELECT EMPNO, ENAME, JOB, SAL
  FROM EMP
 ORDER BY SAL DESC
 OFFSET 3 ROW
 FETCH FIRST 2 ROW ONLY ;
```

**TOP N 쿼리**
- SQL Server에서의 상위 n개 행 추출 문법
- 서브쿼리 사용없이 하나의 쿼리로 정렬된 순서대로 상위 n개 추출 가능
- WITH TIES를 사용하여 동순위까지 함께 출력 가능
```sql
SELECT TOP N (WITH TIES) 컬럼1, 컬럼2, ...
  FROM 테이블명
 ORDER BY 정렬컬럼명 [ASC|DESC] 
```
-> WITH TIES 사용시 동순위 행도 함께 출력 가능

# 2-14. 계층형 질의

**계층형 질의**
- 하나의 테이블 내 각 행끼리 관계를 가질 때, 연결고리를 통해 행과 행 사이의 계층을 표현
- PRIOR의 위치에 따라 연결하는 데이터가 달라짐
```sql
SELECT 컬럼명
  FROM 테이블명 
 START WITH 시작조건  # 시작점을 지정하는 조건 전달
CONNECT BY [NOCYCLE] PRIOR 연결조건 ;
```
- NOCYCLE: 순환이 발생하면 무한 루프가 될 수 있기 때문에 이를 방지하고자 사용 

**계층형 질의 조건**

1. CONNECT BY 절 조건
- 계층 구조를 설정하는 조건
- START WITH절에서 시작한 데이터로부터 부모-자식 관계를 탐색하는 규칙 정의
- 이 조건이 성립하지 않으면, 더 이상 자식 관계를 연결하지 않음
- START WITH 절 데이터가 항상 출력됨

2. WHERE절 조건
- 전체 결과를 필터링하는데 사용
- START WITH와 CONNECT BY로 연결된 모든 결과가 출력된 후, WHERE절 조건에 맞는 데이터만 선택하여 출력
- START WITH 절 데이터가 조건에 맞지 않는 경우 생략

**계층형 질의 가상 컬럼**
- LEVEL: 각 depth를 표현(시작점=1)
- CONNECT_BY_ISLEAF: 최하위노드 여부(참:1, 거짓:0)

**계층형 질의 가상 함수**
- CONNECT_BY_ROOT: 루트 노드의 해당하는 컬럼값
- SYS_CONNECT_BY_PATH: 이어지는 경로 출력
- ORDER SIBLINGS BY: 같은 level일 경우 정렬 수행
- CONNECT_BY_ISCYCLE: 계층형 쿼리의 결과에서 순환이 발생했는지 여부


# 2-15. PIVOT과 UNPIVOT

**데이터의 구조**
1. LONG DATA
- 하나의 속성이 하나의 컬럼으로 정의되어 값들이 여러 행으로 쌓이는 구조
- RDBMS의 테이블 설계 방식
- 다른 테이블과의 조인 연산이 가능한 구조

2. WIDE DATA
- 행과 컬럼에 유의미한 정보 전달을 목적으로 작성하는 교차표
- 하나의 속성값이 여러 컬럼으로 분리되어 표현
- RDBMS에서 WIDE 형식으로 테이블 설계 시 값이 추가될 때마다 컬럼이 추가되어야 하므로 비효율적
- 다른 테이블과 조인 연산 부가
- 주로 데이터를 요약할 목적으로 사용

**데이터 구조 변경**
1. PIVOT: LONG -> WIDE
2. UNPIVOT: WIDE -> LONG

**PIVOT**
- 교차표를 만드는 기능
- STACK 컬럼, UNSTACK 컬럼, VALUE 컬럼의 정의가 중요
- **FROM 절에 STACK, UNSTACK, VALUE 컬럼명만 정의** 필요
- PIVOT 절에 UNSTACK, VALUE 컬럼명 정의
- PIVOT 절 IN 연산자에 UNSTACK 컬럼 값을 정의
- FROM 절에 선언된 컬럼 중 PIVOT절에서 선언한 VALUE 컬럼, UNSTACK 컬럼을 제외한 모든 컬럼은 STACK 컬럼이 됨
```sql
SELECT *
  FROM 테이블명 또는 서브쿼리
 PIVOT (VALUE 컬럼명 FOR UNSTACK 컬럼명 IN (값1, 값2, 값3)) ;
```
```sql
# EMP 테이블에서 JOB 별 DEPTNO별 도수(COUNT) 출력
SELECT *
  FROM (SELECT EMPNO, JOB, DEPTNO FROM EMP)
 PIVOT (COUNT(EMPNO) FOR DEPTNO IN (10, 20, 30)) ;
```
*- FROM절 서브쿼리 안에 JOB이 없으면 부서별로 도수 출력*
*- FROM절에 서브쿼리로 컬럼을 제한하지 않으면 STACK 컬럼이 많아짐* 

**UNPIVOT**
- WIDE 데이터를 LONG 데이터로 변경하는 문법
- STACK 컬럼: 이미 UNSTACK 되어있는 여러 컬럼을 하나의 컬럼으로 STACK시 새로 만들 컬럼 이름(사용자 정의)
- VALUE 컬럼: 교차표에서 셀 자리(VALUE)값을 하나의 컬럼으로 표현하고자 할 때 새로 만들 컬럼명(사용자 정의)
```sql
SELECT *
  FROM 테이블먕 | 서브쿼리
UNPIVOT (VALUE 컬럼명 FOR STACK 컬럼명 IN (값1, 값2, ...)) ;
```


