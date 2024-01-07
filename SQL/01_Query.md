<h3> DISTINCT

```sql
SELECT DISTINCT year
FROM movies;
```


<h3> WHERE

```sql
SELECT *
FROM movies
WHERE imdb_rating < 5;

SELECT *
FROM movies
WHERE year > 2014;
```


<h3> LIKE

```sql
SELECT *
FROM movies
WHERE name LIKE 'Se_en';

SELECT *
FROM movies
WHERE name LIKE '%man%';

SELECT *
FROM movies
WHERE name LIKE 'The %';
```

<h3> NULL

```sql
SELECT name
FROM movies
WHERE imdb_rating IS NULL;
```


<h3> BETWEEN

```sql
SELECT *
FROM movies
WHERE name BETWEEN 'D' AND 'G';

SELECT *
FROM movies
WHERE year BETWEEN 1970 AND 1979;
```


<h3> AND

```sql
SELECT *
FROM movies
WHERE year BETWEEN 1970 AND 1979
  AND imdb_rating > 8;

SELECT *
FROM movies
WHERE year < 1985 AND genre = 'horror'
```


<h3> OR

```sql
SELECT *
FROM movies
WHERE year > 2014
   OR genre = 'action';

SELECT *
FROM movies
WHERE genre = 'romance' OR genre = 'comedy';
```


<h3>

```sql
SELECT name, year
FROM movies
ORDER BY name;

SELECT name, year, imdb_rating
FROM movies
ORDER BY imdb_rating DESC;
```


<h3> LIMIT

```sql
SELECT *
FROM movies
ORDER BY imdb_rating DESC
LIMIT 3;
```


<h3> CASE

```sql
SELECT name,
CASE 
 WHEN genre = 'romance' THEN 'Chill'
 WHEN genre = 'comedy' THEN 'Chill'
 ELSE 'Intense'
END AS 'Mood'
FROM movies;
```