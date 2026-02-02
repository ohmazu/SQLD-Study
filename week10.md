# Programmers 문제풀이 
## 01. 자동차 대여 기록에서 장기/단기 대여 구분하기
### 문제
CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일이 2022년 9월에 속하는 대여 기록에 대해서 대여 기간이 30일 이상이면 '장기 대여' 그렇지 않으면 '단기 대여' 로 표시하는 컬럼(RENT_TYPE)을 추가하여 대여기록을 출력하는 SQL문을 작성해주세요. 결과는 대여 기록 ID를 기준으로 내림차순 정렬해주세요.

### 답
```sql
SELECT
    HISTORY_ID, CAR_ID,
    DATE_FORMAT(START_DATE, '%Y-%m-%d') AS START_DATE,
    DATE_FORMAT(END_DATE, '%Y-%m-%d')   AS END_DATE,
    CASE
        WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 30 THEN '장기 대여'
        ELSE '단기 대여'
    END AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE START_DATE >= '2022-09-01'
  AND START_DATE <  '2022-10-01'
ORDER BY HISTORY_ID DESC;
``` 
1. `CASE WHEN 조건 THEN 값1 ELSE 값2 END AS 컬럼명`
- CASE END -> 항상 세트
- WHEN에 대한 값은 THEN  사용

## 02. 진료과별 총 예약 횟수 출력하기
### 문제
다음은 종합병원의 진료 예약정보를 담은 APPOINTMENT 테이블 입니다.
APPOINTMENT 테이블은 다음과 같으며 APNT_YMD, APNT_NO, PT_NO, MCDP_CD, MDDR_ID, APNT_CNCL_YN, APNT_CNCL_YMD는 각각 진료예약일시, 진료예약번호, 환자번호, 진료과코드, 의사ID, 예약취소여부, 예약취소날짜를 나타냅니다.

APPOINTMENT 테이블에서 2022년 5월에 예약한 환자 수를 진료과코드 별로 조회하는 SQL문을 작성해주세요. 이때, 컬럼명은 '진료과 코드', '5월예약건수'로 지정해주시고 결과는 진료과별 예약한 환자 수를 기준으로 오름차순 정렬하고, 예약한 환자 수가 같다면 진료과 코드를 기준으로 오름차순 정렬해주세요.

### 답
```sql
SELECT
    MCDP_CD AS '진료과코드',
    COUNT (*) AS '5월예약건수'
FROM APPOINTMENT
WHERE APNT_YMD >= '2022-05-01'
AND APNT_YMD < '2022-06-01'
GROUP BY MCDP_CD
ORDER BY COUNT (*) ASC, MCDP_CD ASC ;
```

1. `SELECT a AS alias`
- 컬럼 a를 alias라는 이름명으로 출력

2. `WHERE condition AND condition`
- 기간 필터링
3. `COUNT (*)`
- 조건을 만족하는 행 개수를 셈

## 03. 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
### 문제
다음은 어느 자동차 대여 회사에서 대여중인 자동차들의 정보를 담은 CAR_RENTAL_COMPANY_CAR 테이블입니다. CAR_RENTAL_COMPANY_CAR 테이블은 아래와 같은 구조로 되어있으며, CAR_ID, CAR_TYPE, DAILY_FEE, OPTIONS 는 각각 자동차 ID, 자동차 종류, 일일 대여 요금(원), 자동차 옵션 리스트를 나타냅니다.

CAR_RENTAL_COMPANY_CAR 테이블에서 '통풍시트', '열선시트', '가죽시트' 중 하나 이상의 옵션이 포함된 자동차가 자동차 종류 별로 몇 대인지 출력하는 SQL문을 작성해주세요. 이때 자동차 수에 대한 컬럼명은 CARS로 지정하고, 결과는 자동차 종류를 기준으로 오름차순 정렬해주세요.

### 답
```sql
SELECT CAR_TYPE, COUNT(*) AS CARS 
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%통풍시트%'
    OR OPTIONS LIKE '%열선시트%'
    OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE ;
```

1. `WHERE condition ~ OR`
- 여러 개의 조건을 걸고 싶을 때 OR 사용
  - *컬럼1에 'a', 'b', 'c' 중에 하나 이상 포함된 행*

2. `%word%`
- 단어를 추출할 거면 % 필요

## 04. 조건에 맞는 아이템들의 가격의 총합 구하기
### 문제
다음은 어느 한 게임에서 사용되는 아이템들의 아이템 정보를 담은 ITEM_INFO 테이블입니다. ITEM_INFO 테이블은 다음과 같으며, ITEM_ID, ITEM_NAME, RARITY, PRICE는 각각 아이템 ID, 아이템 명, 아이템의 희귀도, 아이템의 가격을 나타냅니다.

ITEM_INFO 테이블에서 희귀도가 'LEGEND'인 아이템들의 가격의 총합을 구하는 SQL문을 작성해 주세요. 이때 컬럼명은 'TOTAL_PRICE'로 지정해 주세요.

### 답
```sql
SELECT SUM(PRICE) AS TOTAL_PRICE
FROM ITEM_INFO
WHERE RARITY = 'LEGEND';
```
1. `WHERE a = 'word'`
- 컬럼의 값이 word인 행

## 05. NULL 처리하기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

입양 게시판에 동물 정보를 게시하려 합니다. 동물의 생물 종, 이름, 성별 및 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 이때 프로그래밍을 모르는 사람들은 NULL이라는 기호를 모르기 때문에, 이름이 없는 동물의 이름은 "No name"으로 표시해 주세요.

### 답 
```sql 
SELECT 
    ANIMAL_TYPE, 
    IFNULL(NAME, 'No name') AS NAME, 
    SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID ;
``` 
1. `IFNULL(NAME, 'No name')`
- NAME 컬럼이 NULL이면 No name으로 대체