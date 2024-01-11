<h2> Django CRUD

<h3> 데이터 작성 및 DB 연결

<h4> 1. app 파일 내부에 models.py 생성

<h4> 2. 

```python
from django.db import models
```

<h4> 3. models.py 내부에 데이터 작성 

<h4> ex.

```python
 class <class 명>(models.Model):
    <col 명> = models.CharField(max_length=300)
    <col 명> = models.TextField()

 if __name__ == '__main__':
```

<h4> CREATE
<h4> ex.

 ```python
 p1 = Article.objects.create(title = 'str', content = 'str')
    p2 = Article.objects.create(title = 'str', content = 'str')
    p3 = Article.objects.create(title = 'str', content = 'str')

    Article.objects.all()
 ```
<h4> READ
<h4> ex.

 ```python
     for Article in Article.objects.all():
        print(Article.title)

    p1 = Article.objects.get(pk=1)
 ```

<h4> UPDATE
<h4> ex.

 ```python
     p1 = Article.objects.get(pk=1)
    p1.title = 30
    p1.content = 'str'
    p1.save()
 ```

<h4> DELETE
<h4> ex.

 ```python
 p1.delete()
 ```

<h4> 4. app 내부의 urls.py 파일 작성

<h4> 5. app 내부의 views.py 파일 작성

<h4> DB 연결

 ```python
 python manage.py makemigrations <app 명>
 python manage.py migrate <app 명>
 python manage.py shell_plus
 ```

<h4> 6. shell_plus 내부에 CRUD commend 입력



