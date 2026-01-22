# 스터디 실습 오답노트 1
## SQL 기본 쿼리 작성 순서
```sql
SELECT col, COUNT (*) AS alias
FROM table_name
WHERE condition -- 개별 행애 대한 조건
GROUP BY category
HAVING condition -- 그룹에 대한 조건 
ORDER BY
LIMIT
```
### 1. WHERE VS HAVING
| 구분    | WHERE      | HAVING     |
| ----- | ---------- | ---------- |
| 대상    | 개별 행       | 그룹         |
| 실행 시점 | GROUP BY 전 | GROUP BY 후 |
| 집계 함수 | X      | O       |
| 예시    | 나이 필터      | 평균 점수 필터   |

**예시**
```sql
-- WHERE: row 필터
WHERE age >= 20

-- HAVING: 그룹 필터
HAVING AVG(score) >= 80
```

## 자주 쓰는 SQL 함수
### 집계 함수
| 함수      | 의미 |
| ------- | -- |
| COUNT( ) | 개수 |
| SUM( )   | 합  |
| AVG( )   | 평균 |
| MIN( )   | 최소 |
| MAX( )   | 최대 |

**예시**
```sql
SELECT COUNT(*), AVG(score)
``` 

### 조건 함수
1. `CASE WHEN`
```sql
CASE 
    WHEN 조건1 THEN 값1
    WHEN 조건2 THEN 값2
    ELSE 값3
END AS alias
```

### 날짜 함수

| 함수               | 역할     |
| ---------------- | ------ |
| DATEDIFF(a,b)    | 날짜 차이  |
| DATE_FORMAT( )    | 날짜 포맷  |
| YEAR( ) / MONTH( ) | 연/월 추출 |

### 문자열 함수
| 함수          | 역할      |
| ----------- | ------- |
| LENGTH( )    | 길이      |
| SUBSTRING( ) | 자르기     |
| LIKE        | 패턴 검색   |
| CONCAT( )    | 문자열 합치기 |

1. `WHERE a LIKE '%con%'`
- 컬럼 a에서 'con'을 포함하는 값 찾기

2. `CONCAT(a, b, c)`
- 결과: abc
- 괄호 안의 인자들을 순서대로 붙여서 하나의 문자열로 생성
- 숫자/날짜 입력시 문자열로 변환


### NULL 처리
| 함수          | 의미           |
| ----------- | ------------ |
| IFNULL(a,b) | NULL 대체      |
| COALESCE()  | NULL 대체 (범용) |

1. `IFNULL(a)`
- NULL을 빈 문자열로 처리

2. `COALESCE(a, b, c)`
- 왼쪽부터 차레대로 검사해서 NULL이 아닌 첫 번째 값을 반환
- 보통 사용 예시
    - COALESCE(a, b)
    - a가 NULL이면 b를 출력