# Programmers 문제풀이 4
## 01. 물고기 종류 별 잡은 수 구하기
### 문제
낚시앱에서 사용하는 FISH_INFO 테이블은 잡은 물고기들의 정보를 담고 있습니다. FISH_INFO 테이블의 구조는 다음과 같으며 ID, FISH_TYPE, LENGTH, TIME은 각각 잡은 물고기의 ID, 물고기의 종류(숫자), 잡은 물고기의 길이(cm), 물고기를 잡은 날짜를 나타냅니다.
단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.

FISH_NAME_INFO 테이블은 물고기의 이름에 대한 정보를 담고 있습니다. FISH_NAME_INFO 테이블의 구조는 다음과 같으며, FISH_TYPE, FISH_NAME 은 각각 물고기의 종류(숫자), 물고기의 이름(문자) 입니다.

FISH_NAME_INFO에서 물고기의 종류 별 물고기의 이름과 잡은 수를 출력하는 SQL문을 작성해주세요. 물고기의 이름 컬럼명은 FISH_NAME, 잡은 수 컬럼명은 FISH_COUNT로 해주세요. 결과는 잡은 수 기준으로 내림차순 정렬해주세요.

### 답
```sql
SELECT COUNT(*) AS FISH_COUNT, N.FISH_NAME
FROM FISH_INFO I
JOIN FISH_NAME_INFO N
ON I.FISH_TYPE = N.FISH_TYPE
GROUP BY N.FISH_NAME
ORDER BY FISH_COUNT DESC ;
```
1. `FROM table1 t1 JOIN table2 t2 ON col`
- FROM ~ JOIN: 조인할 테이블
    - AS 사용 없이 테이블명 지정
- ON: 기준 컬럼
    - ON t1.col = t2.col 형태로 사용

## 02. 동물 수 구하기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 동물이 몇 마리 들어왔는지 조회하는 SQL 문을 작성해주세요.

### 답
```sql
SELECT COUNT(*) AS count
FROM ANIMAL_INS ;
```

## 03. 최솟값 구하기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 가장 먼저 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.

### 답
```sql
SELECT MIN(DATETIME) AS 시간
FROM ANIMAL_INS
```

## 04. 중복 제거하기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 들어온 동물의 이름은 몇 개인지 조회하는 SQL 문을 작성해주세요. 이때 이름이 NULL인 경우는 집계하지 않으며 중복되는 이름은 하나로 칩니다.

### 답
```sql
SELECT COUNT(DISTINCT NAME) AS count
FROM ANIMAL_INS
WHERE NAME IS NOT NULL ;
```
1. `WHERE col IS NOT NULL`
- 컬럼이 결측값인 경우 제외

2. `DISTINCT col``
- 중복 제거
- 함수가 아니라 괄호 없이 사용

## 05. 동명 동물 수 찾기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하는 SQL문을 작성해주세요. 이때 결과는 이름이 없는 동물은 집계에서 제외하며, 결과는 이름 순으로 조회해주세요.

### 답
```sql
SELECT NAME, COUNT(*) AS COUNT
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
GROUP BY NAME
HAVING COUNT(*) > 1
ORDER BY NAME ;
```

1. `HAVING` 
- 그룹핑 기준 필터 -> GROUP BY 이후에 작성
- alias 사용 불가 -> 집계 함수를 다시 작성해야 함

## 06. 고양이와 개는 몇 마리 있을까
### 문제 
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

동물 보호소에 들어온 동물 중 고양이와 개가 각각 몇 마리인지 조회하는 SQL문을 작성해주세요. 이때 고양이를 개보다 먼저 조회해주세요.

### 답
```sql
SELECT ANIMAL_TYPE, COUNT(*) AS count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE ;
``` 

## 07. 이름에 el이 들어가는 동물 찾기
### 문제
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

보호소에 돌아가신 할머니가 기르던 개를 찾는 사람이 찾아왔습니다. 이 사람이 말하길 할머니가 기르던 개는 이름에 'el'이 들어간다고 합니다. 동물 보호소에 들어온 동물 이름 중, 이름에 "EL"이 들어가는 개의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 이때 결과는 이름 순으로 조회해주세요. 단, 이름의 대소문자는 구분하지 않습니다.

### 답
```sql
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE NAME LIKE '%el%' 
AND ANIMAL_TYPE = 'Dog'
ORDER BY NAME ;
```

## 08. 중성화 여부 파악하기
### 문제 
ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

보호소의 동물이 중성화되었는지 아닌지 파악하려 합니다. 중성화된 동물은 SEX_UPON_INTAKE 컬럼에 'Neutered' 또는 'Spayed'라는 단어가 들어있습니다. 동물의 아이디와 이름, 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 이때 중성화가 되어있다면 'O', 아니라면 'X'라고 표시해주세요.

### 답
```sql
SELECT ANIMAL_ID, NAME,
    CASE 
    WHEN SEX_UPON_INTAKE LIKE 'Neutered%' 
    OR SEX_UPON_INTAKE LIKE 'Spayed%'
    THEN 'O'
    ELSE 'X' END AS 중성화
FROM ANIMAL_INS
ORDER BY ANIMAL_ID ;
```
1. `CASE WHEN 조건 THEN a ELSE b AS alias`
- if문의 형태가 필요하면 CASE WHEN ~ THEN ~ ELSE 활용


## 09. 카테고리 별 상품 개수 구하기
### 문제
다음은 어느 의류 쇼핑몰에서 판매중인 상품들의 정보를 담은 PRODUCT 테이블입니다. PRODUCT 테이블은 아래와 같은 구조로 되어있으며, PRODUCT_ID, PRODUCT_CODE, PRICE는 각각 상품 ID, 상품코드, 판매가를 나타냅니다. 상품 별로 중복되지 않는 8자리 상품코드 값을 가지며, 앞 2자리는 카테고리 코드를 의미합니다.

PRODUCT 테이블에서 상품 카테고리 코드(PRODUCT_CODE 앞 2자리) 별 상품 개수를 출력하는 SQL문을 작성해주세요. 결과는 상품 카테고리 코드를 기준으로 오름차순 정렬해주세요.

### 답
```sql
SELECT
  LEFT(PRODUCT_CODE, 2) AS CATEGORY,
  COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY LEFT(PRODUCT_CODE, 2)
ORDER BY CATEGORY;
```

1. `LEFT(a, n)`
- 컬럼 a(문자열) 왼쪽에서 n개 글자만 자르는 함수

## 10. 상품 별 오프라인 매출 구하기
### 문제
다음은 어느 의류 쇼핑몰에서 판매중인 상품들의 상품 정보를 담은 PRODUCT 테이블과 오프라인 상품 판매 정보를 담은 OFFLINE_SALE 테이블 입니다. PRODUCT 테이블은 아래와 같은 구조로 PRODUCT_ID, PRODUCT_CODE, PRICE는 각각 상품 ID, 상품코드, 판매가를 나타냅니다.

OFFLINE_SALE 테이블은 아래와 같은 구조로 되어있으며 OFFLINE_SALE_ID, PRODUCT_ID, SALES_AMOUNT, SALES_DATE는 각각 오프라인 상품 판매 ID, 상품 ID, 판매량, 판매일을 나타냅니다.

PRODUCT 테이블과 OFFLINE_SALE 테이블에서 상품코드 별 매출액(판매가 * 판매량) 합계를 출력하는 SQL문을 작성해주세요. 결과는 매출액을 기준으로 내림차순 정렬해주시고 매출액이 같다면 상품코드를 기준으로 오름차순 정렬해주세요.

### 답
```sql
SELECT P.PRODUCT_CODE, SUM(P.PRICE*O.SALES_AMOUNT) AS SALES
FROM PRODUCT P
JOIN OFFLINE_SALE O
ON P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY PRODUCT_CODE
ORDER BY SALES DESC, PRODUCT_CODE ;
``` 
- COUNT(*)*PRICE가 안되는 이유
    - 행의 개수 != 판매 개수

문제와 컬럼 설명을 잘 보장~~~

## 11. 
### 문제
다음은 아이스크림 가게의 상반기 주문 정보를 담은 FIRST_HALF 테이블과 아이스크림 성분에 대한 정보를 담은 ICECREAM_INFO 테이블입니다. FIRST_HALF 테이블 구조는 다음과 같으며, SHIPMENT_ID, FLAVOR, TOTAL_ORDER 는 각각 아이스크림 공장에서 아이스크림 가게까지의 출하 번호, 아이스크림 맛, 상반기 아이스크림 총주문량을 나타냅니다. FIRST_HALF 테이블의 기본 키는 FLAVOR입니다.

ICECREAM_INFO 테이블 구조는 다음과 같으며, FLAVOR, INGREDITENT_TYPE 은 각각 아이스크림 맛, 아이스크림의 성분 타입을 나타냅니다. INGREDIENT_TYPE에는 아이스크림의 주 성분이 설탕이면 sugar_based라고 입력되고, 아이스크림의 주 성분이 과일이면 fruit_based라고 입력됩니다. ICECREAM_INFO의 기본 키는 FLAVOR입니다. ICECREAM_INFO테이블의 FLAVOR는 FIRST_HALF 테이블의 FLAVOR의 외래 키입니다.

상반기 동안 각 아이스크림 성분 타입과 성분 타입에 대한 아이스크림의 총주문량을 총주문량이 작은 순서대로 조회하는 SQL 문을 작성해주세요. 이때 총주문량을 나타내는 컬럼명은 TOTAL_ORDER로 지정해주세요.

### 답
```sql
SELECT I.INGREDIENT_TYPE, SUM(TOTAL_ORDER) AS TOTAL_ORDER
FROM FIRST_HALF F
JOIN ICECREAM_INFO I
ON F.FLAVOR = I.FLAVOR
GROUP BY INGREDIENT_TYPE
ORDER BY TOTAL_ORDER ;
``` 
