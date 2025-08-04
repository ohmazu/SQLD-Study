# 2-16. 정규 표현식

**정규 표현식**
- 문자열의 **공통된 규칙을 일반화**하여 표현
- 정규 표현식 사용 가능한 문자 함수 제공(regexp_replace, regexp_substr, ...)
    - *ex) 숫자를 포함하는, 문자로 시작하는 4자리, ...*

**정규 표현식 종류**
- `\d`: digit. 0, 1, 2, ...
- `\D`: 숫자가 아닌 것
- `\s`: 공백
- `\S`: 공백이 아닌 것
- `\w`: 단어 문자
- `\W`: 단어가 아닌 것
- `\t`: tab
- `\n`: new line (엔터 문자)
- `^`: 시작되는 글자
- `$`: 마지막 글자
- `\\`: escape character (뒤에 기호 의미 제거)
- `|`: 또는
- `.`: 엔터를 제외한 모든 한 글자
- `[ab]`: `a` 또는 `b`인 한 글자
- `[^ab]`: `a`, `b` 제외한 모든 문자
- `[0-9]`: 숫자
- `[A-Z]`: 영어 대문자
- `[a-z]`: 영어 소문자
- `[A-Za-z]`: 모든 영문자
- `i+`: `i`가 1회 이상 반복
- `i*`: `i`가 0회 이상 반복
- `i?`: `i`가 0회에서 1회 반복
- `i{n}`: `i`가 `n`회 반복
- `i{n1, n2}`: `i`가 `n1`에서 `n2` 반복
- `i{n,}`: `i`가 `n`회 이상 반복
- `()` : 그룹 지정
- `\n`: 그룹번호
- `[:alnum:]`: 문자와 숫자
- `[:alpha:]`: 문자
- `[:blank:]`: 공백
- `[:cntrl:]`: 제어문자
- `[:digit:]`: digits
- `[:graph:]`: graphical characters
- `[:lower:]`: 소문자
- `[:print:]`: 숫자, 문자, 특수문자, 공백 모두
- `[:punct:]`: 특수문자
- `[:space:]`: 공백문자
- `[:upper:]`: 대문자
- `[:xdigit:]`: 16진수

```
ex.
tel)02-990-4456  -> tel\)[0-9-]+  -> tel\)?[0-9-]+
```
- 전화번호는 숫자와 -로 구성 -> [0-9-]+ 로 표현 가능([]안에 들어가는 패턴이 한자리의 문자열을 구성할 수 있는 값들)


**REGEXP_REPLACE**
- 정규식 표현을 사용한 문자열 치환 가능 
- 문법: REGEXP_REPLACE(대상, 찾을문자열, [바꿀문자열], [검색위치], [발견횟수], [옵션])
    - 바꿀 문자열 생략 시 문자열 삭제 / 검색위치 생략 시 1 / 발견횟수 생략 시 0(모든)
- 옵션: c(대소 구분 검색) / i(대소 구분x 검색) / m(패턴을 다중라인을 선언 가능)
```sql
# ID에서 숫자 삭제
SELECT ID,
       REGEXP_REPLACE(ID, '\d', '') AS RESULT1,
       REGEXP_REPLACE(ID, '[[:digit:]]', '') AS RESULT2
  FROM PROFESSOR ; 

# 괄호포함, 괄호 안에 들어가는 모든 글자 삭제
SELECT DISTINCT REGEXP_REPLACE(상품명, '\(.+\)', '')
  FROM PRODUCT ;
```

- *괄호는 서브그룹을 만드는 정규 표현식이므로 일반 괄효는 `\)`로 표현*
- `\(.+\)`: *()안에 엔터를 제외한 모든 값 허용*

**REGEXP_SUBSTR**
- 정규식 표현식을 사용한 문자열 추출
- 문법: REGEXP_SUBSTR(대상, 패턴, [검색위치], [발견횟수], [옵션], [추출그룹])
    - 검색위치 생략 시 1 / 발견횟수 생략 시 1 / 추출그룹은 서브패턴을 추출 시 그 중 추출할 서브패턴 번호
- 옵션은 REPLACE와 동일
```sql
# 전화번호 분리하여 지역번호 추출
SELECT TEL, 
       REGEXP_SUBSTR(TEL,                   # 원본
                     '(\d+)\)(\d+)-(\d+)',  # 패턴
                     1,                     # 시작위치
                     1,                     # 발견횟수
                     null,                  # 옵션
                     1) AS 지역번호           # 추출할 서브패턴 번호
  FROM STUDENT ;
```
- 전화번호 구성: 숫자여러개 + ) + 숫자여러개 + - + 숫자여러개 
- `\d+ \) \d+ - \d+` 로 표현 가능 
- 그 중 첫번째 그룹 추출 

**REGEXP_INSTR**
- 주어진 문자열에서 특정패턴의 시작 위치를 반환 
- 문법: REGEXP_INSTR(원본, 찾을패턴, [시작위치], [발견횟수],[출력옵션], [옵션], [추출그룹])
    - 시작위치 생략 시 1 / 발견횟수 생략 시 처음 발견된 문자열 위치 리턴
- 출력옵션: 0(디폴트, 문자열의 시작위치 리턴) / 1(문자열의 끝위치 리턴)
```sql
# ID 값에서 두 번째 발견된 숫자의 위치
SELECT ID, 
       REGEXP_INSTR(ID, '\d', 1, 2)
  FROM PROFESSOR ;
```

**REGEXP_LIKE**
- 주어진 문자열에서 특정패턴을 갖는 경우 반환 
- 문법: REGEXP_LIKE(원본, 찾을 문자열, [옵션])
```sql
# ID값이 숫자로 끝나는 교수 정보 출력 
SELECT *
  FROM PROFESSOR
 WHERE REGEXP_LIKE(ID, '\d$') ;
```

**REGEXP_COUNT**
- 주어진 문자열에서 특정패턴의 횟수를 반환
- 문법: REGEXP_COUNT(원본, 찾을문자열, 시작위치, [옵션])
```sql
# ID값에서의 숫자의 수 
SELECT ID, 
       REGEXP_COUNT(ID, '\d') AS RESULT1,
       REGEXP_COUNT(ID, '\d+') AS RESULT2
  FROM PROFESSOR ;
```
- `\d`는 한 자리수의 숫자를 의미, `\d+`는 연속적인 숫자를 의미 -> count 시에 연속적인 숫자를 하나로 취급


# 2-17. DML

**DML(Data Manipulation Language)**
- 데이터의 삽입(insert), 수정(update), 삭제(delete), 병합(megre)
- **저장(commit) 혹은 취소(rollback) 필요**


**INSERT**
- 테이블에 행을 삽입할 때 사용
- 한 번에 한 행만 입력 가능(SQL Server: 여러 행 동시 삽입 가능)
- 하나의 컬러에는 한 값만 삽입 가능 
- 컬럼별 데이터 타입과 사이즈에 맞게 삽입
- INTO 절에 컬럼명을 명시하여 일부 컬러만 입력 가능
- 전체 컬럼에 대한 데이터 입력시 테이블명 뒤의 컬럼명 생략 가능
```SQL
INSERT INTO 테이블명 VALUES(값1, 값2, ...) ;  # 전체 컬럼 값 입력
INSERT INTO 테이블명(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...)  # 선택한 컬럼만 데이터 입력
```

**UPDATE**
- 데이터 수정할 때 사용
- 컬럼 단위 수행
- 다중컬럼 수정 가능
```sql
# 1) 단일컬럼 수정
UPDATE 테이블명
   SET 수정할컬럼명 = 수정값
 WHERE 조건 ;

# 2) 다중컬럼 수정1
UPDATE 테이블명
   SET 수정컬럼명1 = 수정값1, 수정컬럼명2 = 수정값 2, ...
 WHERE 조건 ;

# 다중컬럼 수정2
UPDATE 테이블명
   SET (수정컬럼명1, 수정컬럼명2, ...) = (SELECT 수정값1, 수정값2, ...)
 WHERE 조건 ;
```

**DELETE**
- 데이터를 삭제할 때 사용
- 행 단위 실행
```sql
DELETE [FROM] 테이블명
[WHERE 조건] ;
```
```SQL
# NO가 3인 행 삭제
DELETE MERGE_OLD
 WHERE NO = 3 ;
```

**MERGE**
- 데이터 병합
- 참조 테이블과 동일하게 맞추는 작업
- INSERT, UPDATE, DELETE 작업을 동시에 수행
```sql
MERGE INTO 테이블명
USING 참조테이블
   ON (연결조건)  # 괄호 필수 
 WHEN MATCHED THEN
      UPDATE  # 테이블명 생략
         SET 수정내용  # col1 = 1과 같은 형식
      DELETE (조건)  # 괄호 생략 가능
 WHEN NOT MATCHED THEN
      INSERT VALUES(값1, 값2, ...) ;
```
- MERGE할 테이블 확인 -> MERGE문 작성 -> MERGE 결과 확인

# 2-18. TCL

**TCL(Transcation Control Language)**
- 트랜잭션 제어어로 commit, rollback 포함
- **DML에 의해 조작된 결과를 트랜젝션별로 제어하는 명령어**
- DML 수행 후 트랜잭션을 정상 종료하지 않는 경우 LOCK 발생할 수 있음

**트랜잭션**
- 데이터베이스의 논리적 연산 단위(하나의 연속적인 업무 단위)
- 하나의 트랜잭션에는 하나 이상의 SQL 문장이 포함
- 분할 할 수 없는 최소 단위
- **ALL OR NOTHING 개념**

**트랜재션의 특성**
1. 원자성 2. 일관성 3. 고립성 4. 지속성
- 원자성: 트랜잭션 정의된 연산들 모두 성공적으로 실행되던지 아니면 전혀 실행되지 않은 상태여야 함
- 일관성: 트랜잭션 실행 전 데이터베이스의 내용이 잘못되어 있지 않다면 실행 이후에 잘못 있으면 안 됨
- 고립성: 트랜잭션 실행 도중 다른 트랜잭션의 영향을 받아 잘못된 결과를 만들어서는 안 됨
- 지속성: 트랜잭션이 성공적으로 수행되면 갱신한 데이터베이스 내용이 영구적으로 저장

**COMMIT**
- 입력, 수정, 삭제한 데이터에 이상이 없을 경우 데이터를 저장하는 명령어
- 수행하면 이전에 수행된 DML은 모두 저장되어 되돌릴 수 없음

**ROLLBACK**
- 테이블 내 입력한 데이터나, 수정한 데이터, 삭제한 데이터에 대해 변경을 취소하는 명령어
- 데이터베이스에 저장되지 않고 **최종 COMMIT 지점/변경 전/특정 SAVEPOINT 지점으로 원복**
```sql
INSERT INTO ROLLBACK_TEST(EMPNO, ENAME, DEPTNO) VALUES(9999, 'HONG', 10) ;
INSERT INTO ROLLVACK_TEST(EMPNO, ENAME, DEPTNO) VALUES(9998, 'PARK', 20) ;
COMMIT ;

UPDATE ROLLBACK_TEST SET SAL = 3000 WHERE EMPNO = 9999 ;
ROLLBACK ;

UPDATE ROLLBACK_TEST SET SAL = 3000 WHERE EMPNO = 9998 ;
COMMIT ;

UPDATE ROLLBACK_TEST SET SAL = 4000 WHERE EMPNO = 9999 ; 
SAVEPOINT A;

DELETE ROLLBACK_TEST WHERE EMPNO = 9999 ;
UPDATE ROLLBACK_TEST SET SAL = 9000 WHERE EMPNO = 9998 ;
ROLLBACK TO A;
COMMIT ;
```
- SAVEPOINT 이전 수행한 UPDATE는 취소되지 않음


# 2-19. DDL

**DDL(Data Definition Language)**
- 데이터 구조 정의(객체 생성, 삭제, 변경) 언어
- CREATE(객체 생성), ALTER(객체 변경), DROP(객체 삭제), TRUNCATE(데이터 삭제)
- AUTO COMMIT(명령어 수행하면 즉시 저장, 원복 불가)

**CREATE**
- 테이블이나 인덱스와 같은 **객체를 생성**하는 명령어
- 테이블 생성시 테이블명, 컬럼순서, 컬럼크기, 컬럼의 데이터타입 정의 필수
- 테이블 생성 시 각 컬럼의 제약조건 및 기본값은 생략 가능
- 테이블 생성시 소유자 명시 가능(생략 시 명령어 수행 계정 소유)
- 숫자 컬럼의 경우 컬럼 사이즈 생략 가능(날짜 컬럼은 사이즈 명시x)
```sql
CREATE TABLE [소유자.]테이블명(
    컬럼1 데이터타입 [DEFAULT 기본값] [제약조건],
    컬럼2 데이터타입 [DEFAULT 기본값] [제약조건],
    ...
) ;

# 테이블 복제
CREATE 테이블명
AS
SELECT *
  FROM 복제테이블명 ;
```
- 복제테이블의 컬럼명과 컬럼의 데이터 타입이 복제됨
- SELECT문에서 컬럼별칭 사용 시 컬럼별칭 이름으로 생성
- CREATE문에서 컬럼명 변경 가능
- NULL 속성도 복제
- 테이블에 있는 제약조건, 인덱스 등은 복제 x

**테이블 타입**
- CHAR(n): 고정형 문자 타입, 사이즈 전달 필수, 사이즈만큼 확정형 데이터가 입력됨(빈자리수는 공백)
- VARCHAR2(n): 가변형 문자 타입, 사이즈 전달 필수, 사이즈보다 작은 문자값이 입력되더라도 입력값 유지
- NUMBER(p, s): 숫자형 타입, 자리수 생략 가능, 소수점 자리 제한 시 s 전달(p는 총 자리수)
- DATE: 날짜타입으로 사이즈 전달 불가
```sql
# NUMBER(7,2)의 경우 총 자리수가 7을 초과할 수 없음
INSERT INTO TEST1(B) VALUES(12345.67) ;  # 입력 가능
INSERT INTO TEST2(B) VALUES(1234567.78) ;  # 입력 불가

# MERGE_OLD 테이블 만들기
CREATE TABLE MERGE_OLD(
    NO NUMBER,
    NAME VARCHAR2(10),
    PRICE NUMBER
) ;
```

**ALTER**
- 테이블 구조 변경(컬럼명, 컬럼 데이터타입, 사이즈, 디폴트깂, 컬럼 삭제, 컬럼 추가, 제약조건)
- 컬럼 순서 변경 불가(재생성으로 해결)

1. 컬럼 추가
- 새로 추가된 컬럼 위치는 맨 마지막
- 컬럼 추가 시 데이터타입 필수, 디폴트값, 제약조건 명시 가능
- 여러 컬럼 동시 추가 가능(괄호 이용)
```sql
ALTER TABLE 테이블명 ADD 컬럼명 데이터타입 [DEFAULT] [제약조건];

# 컬럼추가
CREATE TABLE EMP_T1
AS 
SELECT *
  FROM EMP ;
SELECT *
  FROM EMP_T1 ;
```

2. 컬럼(속성) 변경
- 컬럼 사이즈, 데이터 타입, 디폴트값 변경 가능
- 여러 컬럼 동시 변경 가능
```sql
ALTER TABLE 테이블명 MODIFY(컬럼명 DEFAULT 값) ;
```
2-1. 컬럼 사이즈 변경
- 컬럼 사이즈 증가는 항상 가능
- 컬럼 사이즈 축소는 데이터 존재 여부에 따라 제한(데이터의 최대 사이즈만큼 축소 가능)
- 동시 변경 가능(괄호 필요)
```sql
ALTER TABLE TEST MODIFY(COL_A NUMBER(10), COL_B VARCHAR(B)) ;
```

2-2. 데이터 타입 변경
- 빈 컬럼일 경우 데이터 타입 변경 가능
- CHAR, VARCHAR -> 데이터가 잇어도 서로 변경 가능
```sql
ALTER TABLE TEST MODIFY JUMIN VARCHAR2(13);
```

2-3. DEFAULT값 변경
- DEFAULT 값이란 특정 컬럼에 값이 생략될 경우 자동으로 부여되는 값
- NULL을 직접 입력할 땐 디폴트값 대신 NULL값이 입력됨
- 이미 데이터가 존재하면 기존 데이터는 수정 안 됨
- 디폴트값 해제 시 디폴트값은 NULL값으로 선언 
```sql
# 1. DEFAULT값 수정 
ALTER TABLE EMP_T2 MODIFY (SAL DEFAULT 3000) ;

# 2. 새로운 값 입력
INSERT INTO EMP_T2 VALUES('PARK', NULL, NULL, SYSDATE),
INSERT INTO EMP_T2(ENAME, DEPTNO, HIREDATE) VALUES('CHOI', NULL, SYSDATE) ;
COMMIT ;
```

3. 컬럼 이름 변경
- 항상 가능
- 동시에 여러 컬럼 이름 변경 불가(괄호 불가)
``sql
ALTER TABLE 테이블명 RENAME COLUMN 기존컬럼명 TO 새컬럼명 ;
```

4. 컬럼 삭제
- 데이터 존재 여부와 상관없이 항상 가능
- RECYCLEBIN에 남지 않음(FLASHBACK으로 복구 불가)
- 동시 삭제 불가
```sql
ALTER TABLE TEST DROP COLUMN COL_A ;
```

**DROP**
- 객체(테이블, 인덱스 등) 삭제
- DROP 후에는 조회 불가
```sql
DROP TABLE 테이블명 [PURGE] ;
```

**TRUNCATE**
- 구조만 남기고 데이터 즉시 삭제, 즉시 반영
- RECYCLEBIN에 남지 않음
```sql
TRUNCATE TABLE 테이블명 ;
```

**DELETE / DROP / TRUNCATE 차이**
- DELETE: 데이터 일부 또는 전체 삭제, 롤백 가능
- DROP: 데이터와 구조를 동시 삭제, 즉시 반영(롤백 불가)
- TRUNCATE: 데이터 전체 삭제만 가능(일부 삭제 불가), 즉시 반영(롤백 불가)