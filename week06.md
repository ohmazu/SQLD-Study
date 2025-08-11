# 2-19. DDL (2)

**제약조건**
- 데이터 무결성을 위해 각 컬럼에 생성하는 데이터의 제약 장치
- 테이블 생성 시 정의 가능, 컬럼 추가 시 정의 가능, 이미 생성된 컬럼에 제약조건만 추가 가능

**1. PRIMARY KEY(기본키)**
- 유일한 식별자
- 중복 허용 x, NULL 허용 x -> unique+notnull
- 특정 커럼에 primary key 생성하면 not null 속성 자동 부여(CTAS로 테이블 복사 시 복사되지 x)
- 하나의 테이블에 여러 기본키 생성 x
- 하나의 기본키를 여러 컬럼을 결합하여 생성 o
- primary key 생성 시 자동으로 unique index 생성

```sql
# 테이블 생성시 제약조건 생성
CREATE TABLE 테이블명(
    컬럼1 데이터타입 [DEFAULT 기본값] [[CONSTRAINT 제약조건명] 제약조건종류],
    컬럼2 데이터타입 [DEFAULT 기본값] [[CONSTRAINT 제약조건명] 제약조건종류],
    ...
    [[CONSTRAINT 제약조건명] 제약조건종류]
) ;

# 컬럼 추가 시 제약 조건 생성
ALTER TABLE 테이블명
ADD 컬럼명 데이터타입 [DEFAULT 기본값] [[CONSTRAINT 제약조건명] 제약조건종류] ;

# 이미 생성된 컬럼에 제약조건만 추가
ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] 제약조건종류 ;

# 제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명 ;
```
- 제약조건 생성 시 이름을 설정하지 않으면 자동으로 부여 

**2. UNIQUE**
- 중복 허용 x / NULL 허용 o
- UNIQUE INDEX 생성
```SQL
# UNIQUE KEY 생성
CREATE TABLE 테이블명(
    컬럼1 데이터타입,
    컬럼2 데이터타입 UNIQUE
) ; 
```
- 컬럼2는 UNIQUE 제약을 걸어서, 동일한 값을 가지는 행이 존재할 수 x

**3. NOT NULL**
- 다른 제약조건과 다르게 컬럼의 특징을 나타냄 -> CTAS 복제 시 따라감
- 컬럼 생성 시 NOT NULL을 선언하지 않으면 nullable 컬럼으로 생성
- 이미 만들어진 컬럼에 NOT NULL 선언 시 제약조건 생성이 아닌 컬럼 수정(MODIFY)으로 해결
```sql
ALTER TABLE 테이블명 ADD NOT NULL(컬럼1) ; -- 불가
ALTER TABLE 테이블명 MODIFY 컬럼1 NOT NULL ; -- 컬럼 수정으로 not null 부여
ALTER TABLE 테이블명 MODIFY 컬럼1
                          CONSTRAINT 컬럼1 NOT NULL -- 제약조건으로 이름 부여
```

**4. FORIGEN KEY**
- 참조테이블의 참조 컬럼에 있는 데이터를 확인하면서 본 테이블 데이터를 관리할 목적으로 생성
- 반드시 **참조테이블의 참조 컬럼이 사전에 PK 혹은 UNIQUE KEY를 가져야 함**
```sql
CREATE TABLE 테이블명(
    컬럼1 데이터타입 [DEFAULT 값] REFERENCES 참조테이블(참조키),
...
) ;
```

```
# 예제
# 테스트 테이블 생성
CREATE TABLE EMP_TEST AS SELECT * FROM EMP ;
CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT ;

# 부모 테이블(DEPT_TEST)에 REFERENCE KEY(참조대상)에 PK 설정
ALTER TABLE DEPT_TEST ADD CONSTRAINT DEPT_TEST_DEPTNO_PK PRIMARY KEY(DEPNO) ;

# 자식 테이블(EMP_TEST)에 FOREIGN KEY 생성
ALTER TABLE EMP_TEST ADD (CONSTRAINT EMP_TEST_DEPTNO_FK)
      FOREIGN KEY(DEPTNO) REFERENCES DEPT_TEST(DEPTNO) ;
```
```sql
# TEST1) 자식 테이블(EMP_TEST)에서 10번 부서원 삭제 시도
DELETE EMP_TEST WHERE DEPTNO = 10 ;  # 가능
```
```sql
# TEST2) 자식 테이블(EMP_TEST)에서 20번 부서원 50번으로 변경 시도
UPDATE EMP_TEST SET DEPTNO = 50 WHERE DEPTNO = 20 ; # 에러
```
- 부모 테이블에 50번 부서번호가 정의되어 있지 않아 수정 불가

```sql
# TEST4) 부모 테이블(DEPT_TEST)에 20번 부서원 삭제 시도
DELETE DEPT_TEST WHERE DEPTNO = 20 ; # 에러
```
- 20번 부서 정보가 자식 테이블에 존재하므로 삭제 불가

**FOREIGN KEY 옵션**(생성 시 정의, 변경 불가 -> 재생성)
- ON DELETE CASCADE: 부모 데이터 삭제 시 자식 데이터 함께 삭제
- ON DELETE SET NULL: 부모 데이터 삭제 시 자식 데이터의 참조값은 NULL로 수정

**5. CHECK**
- 직접 데이터의 값 제한
    - ex. 양수(1, 2, 3, 4) 중 하나

**기타 오브젝트**

**1. 뷰(VIEW)**
- 저장공간을 가지지는 않지만 테이블처럼 조회 및 수정할 수 있는 객체

뷰의 종류
- 단순뷰: 하나의 테이블 조회 뷰
- 복합뷰: 둘 이상의 테이블 조인 뷰

뷰의 특징
- 논리적 독립성 제공
- 데이터의 접근을 제어함으로써 보안유지
- 사용자의 데이터 관리 단순화
- 데이터의 다양한 지원 가능

뷰의 단점
- 뷰의 정의 변경 불가
- 삽입, 삭제, 갱신 연산에 제한
- 인덱스 구성 불가
```sql
# 뷰 생성
CREATE [OR REPLACE] VIEW 뷰이름
AS 조회쿼리 ;

# 뷰 삭제 
DROP VIEW 뷰명 ;
```

**2. 시퀀스(SEQUENCE)**
- 자동으로 연속적인 숫자를 부여해주는 객체
```sql
CREATE SEQUENCE 시퀀스명 
INCREMENT BY  -- 증가값(디폴트: 1)
START WITH    -- 시작값(디폴트: 1)
MAXVALUE      -- 마지막값(증가시퀀스), 재사용시 시작값(감소시퀀스)
MINVALUE      -- 재사용시 시작값(증가시퀀스), 마지막값(감소시퀀스)
CYCLE | NOCYCLE  -- 시퀀스 번호 재사용(디폴트: NO)
CACHE N       -- 캐시값(디폴트: 20)
;
```

**3. 시노님(SYNONYM)**
- 테이블에 별칭 생성
```SQL
CREATE [OR REPLACE] [PUBLIC] SYNONYM 별칭 FOR 테이블명 ; 
```
- OR REPLACE: 기존에 같은 이름으로 시노님이 생성되어 있는 경우 대체
- PUBLIC: 누구나 사용 가능(<->PRIVATE SYNONYM의 반대)
- 퍼블릭으로 생성한 시노님은 반드시 퍼블릭으로 삭제 


# 2-20. DCL

**DCL(Data Control Language)**
- 데이터 제어어로 객체에 대한 권한을 부여(GRANT)하거나 회수(REVOKE)하는 기능
- 테이블 소유자는 타계정에 테이블 조회 및 수정 권한 부여 및 회수 가능

**권한**
- 일반적으로 본인(접속한 계정) 소유가 아닌 테이블은 원칙적으로 조회 불가(권한 통제)
- 업무적으로 필요시 테이블 소유자가 아닌 계정에 테입르 조회, 수정 권한 부여 가능

**권한 종류**
1. 오브젝트 권한
- 테이블에 대한 권한 제어
    - ex. 특정 테이블에 대한 SELECT, INSERT, UPDATE, DELETE, MERGE 권한 
- 테이블 소유자는 타계정에 소유 테이블에 대한 조회 및 수정 권한 부여 및 회수 가능

2. 시스템 권한
- 시스템 작업(테이블 생성 등) 등을 제어
    - ex. 테이블 생성 권한, 인덱스 삭제 권한
- 관리자 권한만 권한 부여 및 회수 가능

**GRANT**
- 권한 부여 시 반드시 테이블 소유자나 관리자 계정으로 접속하여 권한을 부여하여야 함
- 동시에 여러 유저에 대한 권한 부여 가능 / 동시 여러 권한 부여 가능
- 동시 여러 객체 권한 부여 x
```sql
GRANT 권한 ON 테이블명 TO 유저 ;
```

**REVOKE**
- 동시 여러 권한 회수 가능 / 동시 여러 유저로부터 권한 회수 가능
- 이미 회수된 권한 재회수 불가
```sql
REVOKE 권한 ON 테이블명 FROM 유저 ;
```

**ROLL**
- 권한의 묶음(생성 가능한 객체)
- SYSTEM 계정에서 ROLE 생성 가능
```sql
CREATE ROLE 롤이름 ;

# 롤에 권한 담기
GRANT SELECT ON EMP TO ROLE_SEL ;

# 롤 부여
GRANT ROLE_SEL TO HR ;

# 롤에서 권한 빼기
REVOKE SELECT ON DEPARTMENT FROM ROLE_SEL ;
```
- ROLE에서 회수된 권한은 즉시 반영되므로 다시 ROLE을 부여할 필요가 없음
- ROLE을 통해 부여한 권한은 직접 회수 불가, ROLE을 통한 회수만 가능

**권한부여 옵션(중간관리자 권한)**
1. WITH GRANT OPTION
- WITH GRANT OPTION으로 받은 오브젝트 권한을 다른 사용자에게 부여할 수 있음
- 중간관리자가 부여한 권한은 중간관리자만 회수 가능
- 중간관리자에게 부여된 권한 회수 시 제 3자에게 부여된 권한도 함께 회수됨

2. WITH ADMIN OPTION
- WITH ADMIN OPTION을 통해 부여 받은 시스템 권한을 다른 사용자에게 부여 o
- 중간관리자를 거치지 않고 직접 회수 가능
- 중간관리자 권한 회수시 제 3자에게 부여된 권한도 함께 회수 x
```sql
# 권한 부여
-- SYS 계정 수행)
GRANT SELECT ON SCOTT.ROLLBACK_TEST TO HDATALAB WITH GRANT OPTION ;
GRANT CREATE ANY TABLE TO HDATALAB WITH ADMIN OPTION ;
GRANT ALTER ANY TABLE TO HDATALAB WITH ADMIN OPTION ;

-- HDATALAB 계정 수행)
GRANT SELECT ON SCOTT.ROLLBACK_TEST TO PARK ;
GRANT CREATE ANY TABLE TO PARK ;
GRANT ALTER ANY TABLE TO PARK ;
```

```sql
# 오브젝트 권한 회수 시도
-- SYS 계정 수행)
- REVOKE SELECT ON SCOTT.ROLLBACK_TEST FROM PARK ;  -- 직접 회수 불가
```
- 중간관리자를 통해 부여한 제 3계정의 권한은 관리자가 직접 회수 불가

```sql
# 오브젝트 권한 회수 시도
-- SYS 계정 수행)
REVOKE SELECT ON SCOTT.ROLLBACK_TEST FROM PARK ;
REVOKE SELECT ON SCOTT.ROLLBACK_TEST FROM HDATALAB ;
```
- 대신 중간관리자에게 부여된 권한을 회수(제 3의 계정에 부여된 권한도 함계 회수됨)

```sql
# 시스템 권한 회수 시도
-- SYS 계정 수행)
REVOKE ALTER ANY TABLE FROM PARK ;  -- 직접회수가능
REVOKE CREATE ANY TABLE FROM HDATALAB ;  -- 중간관리자회수
```
- 제 3의 계정에 부여된 권한을 관리자가 직접 회수할 수 있음

```sql
-- PARK 계정 수행)
CREATE TABLE CREATE_TEST(COL1 NUMBER) ;  -- 가능
```
- 중간 관리자의 시스템 권한을 회수하더라도 중간관리자가 제 3의 계정에 부여한 권한은 회수되지 않아 테이블 생성이 가능함


