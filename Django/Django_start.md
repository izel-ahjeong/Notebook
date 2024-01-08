<h2> Django 


<h3> Django 설치 및 app 설치

```python
django-admin startproject <project name>

python manage.py startapp <appname>
```


<h3> master app 에 app 등록

<h4> 1. settings 내부의 installed_apps 목록에 추가

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    '<new_app>',
]
```

<h4> 2. urls 에 path 추가

```python
urlpatterns = [
    path('admin/', admin.site.urls),
    path('form/', include('<new_app>.urls')),
]
```


<h3> app 정비

<h4> 1. urls.py 파일 생성
<h4> 2. templates 폴더 생성, 내부에 app이름과 동일한 폴더 생성



<h3> app의 urls 파일 내부에 views 파일로 이어지는 설정

```python
from django.urls import path
from . import views

urlpatterns = [
    path('new_file/', views.<new_file>),
]
```


<h3> views 파일 내부에 templates 로 이어지는 설정

```python
from django.shortcuts import render

def index(request):
    return render(request, '<new_app>/<new_file>.html')
```


<h3> templates 내부에 파일명과 동일한 html 생성

<h3> 실행

```python
python manage.py runserver
```