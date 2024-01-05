<h3> table 조회

```sql
> SELECT * FROM celebs;
```

<h3> table 생성

```sql
CREATE TABLE celebs(
 id INTEGER,
 name TEXT,
 age INTEGER
 );
 ```


<h3> 데이터 삽입

```sql
 INSERT INTO celebs (id, name, age)
  VALUES (1, 'Justin Bieber', 29);

 INSERT INTO celebs (id, name, age)
  VALUES (2, 'Beyonce Knowles', 42);

 INSERT INTO celebs (id, name, age)
 VALUES (3, 'Jeremy Lin', 35);

 INSERT INTO celebs (id, name, age)
 VALUES (4, 'Taylor Swift', 33);
```


<h3> 테이블 변경

```sql
 ALTER TABLE celebs
 ADD COLUMN twitter_handle TEXT;

 SELECT * FROM celebs;
 ```


<h3> 데이터 업데이트

```sql
 UPDATE celebs
 SET twitter_handle = '@taylorswift13'
 WHERE id = 4;

 SELECT * FROM celebs;
```


<h3> 데이터 삭제

```sql
 DELETE FROM celebs
 WHERE twitter_handle IS NULL;

 SELECT * FROM celebs;
 ```


<h3> 제약조건 설정

```sql
 CREATE TABLE awards (
 id INTEGER PRIMARY KEY,
  recipient TEXT NOT NULL,
  award_name TEXT DEFAULT 'Grammy'
 );