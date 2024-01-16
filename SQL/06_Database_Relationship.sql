-- One-to-One Relationship

CREATE TABLE book_details (
  id integer PRIMARY KEY, -- table 내에 PRIMARY KEY 설정
  book_isbn varchar(50) REFERENCES book(isbn) UNIQUE,
  rating decimal,
  language varchar(10),
  keywords text[],
  date_published date
);


SELECT
  constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'book_details';

INSERT INTO book VALUES (
  'Learn PostgreSQL',
  '123457890',
  100,
  2.99,
  'Great course',
  'Codecademy'
);

INSERT INTO book_details VALUES (
  1,
  '123457890',
  3.95,
  'English',
  '{sql, postgresql, database}',
  '2020-05-20'
);

INSERT INTO book_details VALUES (
  2,
  '123457890',
  3.95,
  'French',
  '{sql, postgresql, database}',
  '2020-05-20'
);

SELECT
    book.title, book.price, book_details.language, book_details.rating
FROM book
JOIN book_details
ON book.isbn = book_details.book_isbn;


-- One-to-Many Relationship

CREATE TABLE page (
  id integer PRIMARY KEY,
  chapter_id integer REFERENCES chapter(id),
  content text,
  header varchar(20),
  footer varchar(20)
);

ALTER TABLE chapter
DROP COLUMN content;

SELECT
  constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage
WHERE
  table_name = 'page';

INSERT INTO book VALUES (
  'Learn PostgreSQL',
  '0-9673-4537-5',
  100,
  2.99,
  'Dive into Postgres for Beginners',
  'Codecademy Publishing'
);

INSERT INTO book VALUES (
  'Postgres Made Easy',
  '0-3414-4116-3',
  255,
  5.99,
  'Learn Postgres the Easy Way',
  'Codecademy Press'
);

INSERT INTO chapter VALUES (
  1,
  '0-9673-4537-5',
  1,
  'Chapter 1'
);

INSERT INTO chapter VALUES (
  2,
  '0-3414-4116-3',
  1,
  'Chapter 1'
);

INSERT INTO page VALUES (
  1,
  1,
  'Chapter 1 Page 1',
  'Page 1 Header',
  'Page 1 Footer'
);

INSERT INTO page VALUES (
  2,
  1,
  'Chapter 1 Page 2',
  'Page 2 Header',
  'Page 2 Footer'
);

INSERT INTO page VALUES (
  3,
  2,
  'Chapter 1 Page 1',
  'Page 1 Header',
  'Page 1 Footer'
);

INSERT INTO page VALUES (
  4,
  2,
  'Chapter 1 Page 2',
  'Page 2 Header',
  'Page 2 Footer'
);

SELECT
    book.title as book_title, chapter.title as chapter_title, page.content as page_content
FROM
    book
JOIN
    chapter
ON
    book.isbn = chapter.book_isbn 
JOIN
    page
ON
    chapter.id = page.chapter_id;


-- Many-to-Many Relationship

CREATE TABLE books_authors ( -- 외래키로 이루어진 테이블 생성
  book_isbn varchar(50) REFERENCES book(isbn), -- 각 테이블의 PRIMARY KEY 
  author_email varchar(20) REFERENCES author(email),
  PRIMARY KEY (book_isbn, author_email) -- PRIMARY KEY 설정
);

SELECT
  constraint_name, table_name, column_name
FROM
  information_schema.key_column_usage -- constraint_name 등 확인
WHERE
  table_name = 'books_authors';

SELECT * FROM book;

SELECT * FROM author;

INSERT INTO books_authors VALUES (
  '123457890',
  'jkey@db.com'
);

INSERT INTO books_authors VALUES (
  '123457890',
  'cindex@db.com'
);

INSERT INTO books_authors VALUES (
  '987654321',
  'cindex@db.com'
);

SELECT
    book.title AS book_title,
    author.name AS author_name,
    book.description AS book_description
FROM
    book, author, books_authors
WHERE
    book.isbn = books_authors.book_isbn -- 1. WHERE, AND 로 Fk 사용
AND
    author.email = books_authors.author_email;

SELECT
    author.name AS author_name,
    author.email AS author_email,
    book.title AS book_title
FROM
    book
JOIN
    books_authors
One
    book.isbn = books_authors.book_isbn  -- 2. 각 테이블에 JOIN , ON 하여 FK 사용
JOIN
    author
ON
    author.email = books_authors.author_email;