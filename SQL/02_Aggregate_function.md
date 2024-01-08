<h3> COUNT

```sql
SELECT COUNT(*)
FROM fake_apps
WHERE price = 0;
```


<h3> SUM

```sql
SELECT SUM(downloads)
FROM fake_apps;
```


<h3> MAX/MIN

```sql
SELECT MIN(downloads)
FROM fake_apps;

SELECT MAX(price)
FROM fake_apps;
```


<h3> AVG

```sql
SELECT AVG(downloads)
FROM fake_apps;

SELECT AVG(price)
FROM fake_apps;
```


<h3> ROUND

```sql
SELECT ROUND(AVG(price), 2)
FROM fake_apps;
```


<h3> GROUP BY

```sql
SELECT price, COUNT(*)
FROM fake_apps
WHERE downloads > 20000
GROUP BY price;

SELECT category, SUM(downloads)
FROM fake_apps
GROUP BY category;

SELECT category, price, AVG(downloads)
FROM fake_apps
GROUP BY 1,2;
```


<h3> HAVING

```sql
SELECT price, ROUND(AVG(downloads)),COUNT(*)
FROM fake_apps
GROUP BY 1
HAVING COUNT(price) > 10;
```
