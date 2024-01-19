<h1> SQL 제약 조건

<h2> 목적
<h3>

 - 데이터 무결성과 품질 유지 : 테이블에 삽입하면 안 되는 값의 삽입 또는 업데이트 거부하여 데이터의 무결성이 유지된다.
  
 - app 디버깅에 도움
  

<h2> 1. data type 에 따른 제약
<h3>

 - CREATE TABLE 문에서 데이터 유형을 지정하여 특정 값만을 저장한다 <br>
 - 불완전한 값에 대해 적절히 대응할 수 없다.<br>
   1. INT 값이 제약되어 있는 행에 FLOAT 값을 삽입하면 반올림하여 저장한다.<br>
   2. Email 에 VARCHAR 로 유형을 지정해놨을 경우, 값으로 1.5를 삽입해도 저장한다.<br>
   

   ```sql
   CREATE TABLE attendees (
   id integer,
   name varchar,
   total_tickets_reserved integer,
   standard_tickets_reserved integer,
   vip_tickets_reserved integer
   );

   INSERT INTO attendees VALUES (
     1, 
     'John Smith',
     2,
     1,
     1
    );
    ```


<h2> 2. NULL 허용 여부 제약

<h3> 

 - 값을 포함하지 않은 입력을 제한하여 동일한 입력이 필요한 데이터의 유용성을 높일 수 있다.<br>
 - CREATE TABLE 문의 데이터 유형 뒤에 NOT NULL 제약조건을 추가할 수 있다.


  ```sql
  CREATE TABLE speakers (
  id integer NOT NULL,
  email varchar NOT NULL,
  name varchar NOT NULL,
  organization varchar,
  title varchar,
  years_in_role integer
  );

  INSERT INTO speakers (id, email, name,  organization, title, years_in_role)
  VALUES (1, 'awilson@ABCcorp.com', 'A. Wilson',  'ABC Corp.', 'CTO', 6);
  ```


<h2> 3. 기존 테이블에 제약조건 추가 / 삭제

<h3> 

 - 데이터가 채워져 있지만 제약조건은 없는 경우 ALTER TABLE 문을 이용해 기존 테이블에 추가할 수 있다.
 - 테이블 내에 DROP NOT NULL 을 사용해 제약조건을 삭제 할 수도 있다.

  ```sql
  ALTER TABLE speakers
   -- 제약조건으로 칼럼값이 null일 경우 받지 않는다.
   ALTER COLUMN name SET NOT NULL;

   UPDATE speakers
   SET organization ='TBD' 
   -- 이미 null 값이 작성된 위치를 해당 값으로 대체
   WHERE organization IS NULL;

   ALTER TABLE speakers
   ALTER COLUMN organization SET NOT NULL
   -- UPDATE ALTER를 순서대로 사용했을 경우, 이전에 비어있던 위치는 'TBD'로 대체되어 들어가고 앞으로 받는 값은 null일 경우 받지 않는다.
 ``` 



<h2> 4. CHECK문을 사용해 정확한 제약조건 구현

<h3>

 - CREATE TABLE 문 내의 CHECK 문에 테스트하려는 조건을 작성한다.
 - 괄호 안의 테스트 조건은 true 나 false 로 평가될 수 있는 문장이어야 한다.
 - AND, OR, IN, LIKE 등의 다른 연산자들과 함께 사용할 수 있다.

  ```sql
  -- year_in_role 이 100 보다 작은지 테스트 할 경우
  ALTER TABLE speakers 
  ADD CHECK (years_in_role <100);
   
  -- 0 < years_in_role < 100
  ALTER TABLE speakers
  ADD CHECK (years_in_role < 100 AND years_in_role > 0);

  ALTER TABLE attendees 
  ADD CHECK (standard_tickets_reserved + vip_tickets_reserved = total_tickets_reserved);
  
  ```



<h2> 5. UNIQUE 제약 조건 사용

<h3> 

 - UNIQUE 제약조건을 사용해 단일 열의 값을 고유한 것으로 식별할 수 있다.
 - PRIMARY KEY 는 하나씩 적용이 가능하지만 UNIQUE 는 여러개 사용이 가능하다.
  
  ```sql
  ALTER TABLE speakers
   ADD UNIQUE (email);

   CREATE TABLE registrations (
    id integer NOT NULL,
    attendee_id integer NOT NULL,
    session_timeslot timestamp NOT NULL,
    talk_id integer NOT NULL,
    -- 일부 속성 조합으로 행을 고유하게 식별
    UNIQUE (attendee_id, session_timeslot)
   );
   ```


<h2> 6. PRIMARY KEY 사용

<h3>


 ```sql
 ALTER TABLE speakers
 ADD PRIMARY KEY (id);
 -- 이렇게 PK를 설정하면 id가 누락된 정보는 받지 않는다.
 ```



<h2> 7. FOREIGN KEY 사용

<h3> 

 - 부모 테이블과 자식 테이블의 관계의 경우 하위 테이블에 삽입된 값은 상위 테이블에 이미 존재하는 데이터로 유효성을 검사해야 한다.
 - 다른 테이블을 참조하여 유효성을 검사하는데 FK 를 사용한다.
 - 사용자가 삽입하려는 데이터가 상위 테이블에 없으면 업데이트를 거부해야 한다.


 ```sql
 -- 예시) talks 의 speaker_id 가 speak 의 열 id를 참조하는 지 확인하는 FK 설정하는 방법
 ALTER TABLE talks
 ADD FOREIGN KEY (speaker_id) 
 REFERENCES speakers(id);

 -- 발표자가 삭제되면 해당 발언도 제거한다는 규칙 설정
 ALTER TABLE talks
 ADD FOREIGN KEY (speaker_id)
 REFERENCES speakers(id) ON DELETE CASCADE;
 ```