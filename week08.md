# Programmers 문제풀이

## 01. 잡은 물고기의 평균 길이 구하기
### 문제

잡은 물고기의 평균 길이를 출력하는 SQL문을 작성해주세요.

평균 길이를 나타내는 컬럼 명은 AVERAGE_LENGTH로 해주세요.
평균 길이는 소수점 3째자리에서 반올림하며, 10cm 이하의 물고기들은 10cm 로 취급하여 평균 길이를 구해주세요.
단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.

### 답
```sql
SELECT
  ROUND(AVG(COALESCE(LENGTH, 10)), 2) AS AVERAGE_LENGTH
FROM FISH_INFO;
```
1.`COALESCE(a, b)`
- a가 NULL이면 b를 반환, NULL이 아니면 a 그대로 반환
    - 문제에서 10cm 이하 물고기들은 10cm로 취급



## 02. 잔챙이 잡은 수 구하기
### 문제
<p>낚시앱에서 사용하는 <code>FISH_INFO</code> 테이블은 잡은 물고기들의 정보를 담고 있습니다. <code>FISH_INFO</code> 테이블의 구조는 다음과 같으며 <code>ID</code>, <code>FISH_TYPE</code>, <code>LENGTH</code>, <code>TIME</code>은 각각 잡은 물고기의 ID, 물고기의 종류(숫자), 잡은 물고기의 길이(cm), 물고기를 잡은 날짜를 나타냅니다. </p>
<table class="table">
        <thead><tr>
<th>Column name</th>
<th>Type</th>
<th>Nullable</th>
</tr>
</thead>
        <tbody><tr>
<td>ID</td>
<td>INTEGER</td>
<td>FALSE</td>
</tr>
<tr>
<td>FISH_TYPE</td>
<td>INTEGER</td>
<td>FALSE</td>
</tr>
<tr>
<td>LENGTH</td>
<td>FLOAT</td>
<td>TRUE</td>
</tr>
<tr>
<td>TIME</td>
<td>DATE</td>
<td>FALSE</td>
</tr>
</tbody>
      </table>


잡은 물고기 중 길이가 10cm 이하인 물고기의 수를 출력하는 SQL 문을 작성해주세요.

물고기의 수를 나타내는 컬럼 명은 FISH_COUNT로 해주세요.
단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.

### 답
```sql
SELECT
  COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE LENGTH IS NULL;
``` 

1. `WHERE a IS NULL`
- a가 NULL일 때를 조건으로 함

2. `COUNT(*)`
- **NULL 여부와 상괸없이** 조건을 만족하는 행의 개수를 셈
    - COUNT(LENGTH) -> LENGTH가 NULL인 행은 제외되므로 항상 0이 나오는 오류 발생

## 03. 평균 일일 대여 요금 구하기

### 문제
CAR_RENTAL_COMPANY_CAR 테이블에서 자동차 종류가 'SUV'인 자동차들의 평균 일일 대여 요금을 출력하는 SQL문을 작성해주세요. 이때 평균 일일 대여 요금은 소수 첫 번째 자리에서 반올림하고, 컬럼명은 AVERAGE_FEE 로 지정해주세요.

### 답
```sql
SELECT
  ROUND(AVG(DAILY_FEE), 0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE = 'SUV';
``` 

## 04. 특정 옵션이 포함된 자동차 리스트 구하기
### 문제

CAR_RENTAL_COMPANY_CAR 테이블에서 '네비게이션' 옵션이 포함된 자동차 리스트를 출력하는 SQL문을 작성해주세요. 결과는 자동차 ID를 기준으로 내림차순 정렬해주세요.

### 답

```sql
SELECT
  CAR_ID,
  CAR_TYPE,
  DAILY_FEE,
  OPTIONS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY CAR_ID DESC;
```
1. `WHERE OPTIONS LIKE '%a%'`
- LIKE
    - OPTIONS 컬럼은 콤마로 구분된 문자열
    - 정규화된 테이블이 아니라서 특정 옵션이 문자열에 포함되어 있는지를 확인해야 함
- %a%
    - %: 앞뒤 어떤 문자열이 와도 상관없음

## 05. 이름이 있는 동물의 아이디
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 들어온 동물 중, 이름이 있는 동물의 ID를 조회하는 SQL 문을 작성해주세요. 단, ID는 오름차순 정렬되어야 합니다.

### 답
```sql
SELECT
  ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY ANIMAL_ID;
``` 