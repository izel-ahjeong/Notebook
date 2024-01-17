<h2> comment 기능 생성 


<h3> board/models.py

```python
from django.db import models
from django.conf import settings

class Article(models.Model):
    # models.py 한정>
        # 다른 모델들과 달리, User 를 관계로 설정할 때에는 모델명을 settings.AUTH_USER_MODEL 로 적는걸 권장.
        # 'User' 나 get_user_model() 은 권장하지 않음.
    
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    title = models.CharField(max_length=200)
    content = models.TextField()
    # timestamp
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class Comment(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    article = models.ForeignKey(Article, on_delete=models.CASCADE)

    content = models.CharField(max_length=300)
    # timestamp
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

<h3> board/forms.py

```python
from django import forms
from .models import Article, Comment


class ArticleForm(forms.ModelForm):
    
    class Meta:
        model = Article
        # 아래 필드들을 사용하지 않겠다.

        exclude = ('user', )

        # 아래 필드들을 사용하겠다
        # fields = '__all__'


class CommentForm(forms.ModelForm):

    class Meta:
        model = Comment
        fields = ('content', )
        
```

<h3> board/urls.py

```python
from django.urls import path
from . import views


app_name = 'board'

urlpatterns = [
    # board/create/
    path('create/', views.article_create, name='article_create'),
    # board/
    path('', views.article_index, name='article_index'),
    # board/1/
    path('<int:article_pk>/', views.article_detail, name='article_detail'),
    # board/1/update/
    path('<int:article_pk>/update/', views.article_update, name='article_update'),
    # board/1/delete/
    path('<int:article_pk>/delete/', views.article_delete, name='article_delete'),
    # board/1/comments/create/
    path('<int:article_pk>/comments/create/', views.comment_create, name='comment_create'),
    # board/1/comments/1/delete/
    path('<int:article_pk>/comments/<int:comment_pk>/delete/', views.comment_delete, name='comment_delete'),
]
```

<h3> board/views.py

<h4> 1. view.py 내에 comment 관련 view 생성

```python
@require_POST
def comment_create(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    form = CommentForm(request.POST)
    if form.is_valid():
        # 저장 직전에 멈춰!
        comment = form.save(commit=False)
        comment.article = article
        comment.save()
    # 저장과 상관없이 마지막엔 redirect        
    return redirect('board:article_detail', article.pk)


@require_POST
def comment_delete(request, article_pk, comment_pk):
    article = get_object_or_404(Article, pk=article_pk)
    comment = get_object_or_404(Comment, pk=comment_pk)
    comment.delete()
    return redirect('board:article_detail', article.pk)
    
```

<h4> 2. 기존의 detail view 수정

```python
@require_safe
def article_detail(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    # comment create 를 위한 form
    form = CommentForm()
    return render(request, 'board/detail.html', {
        'article': article,
        'form': form,
    })
```


<h3> board/detail_comment.html 작성

```python
<div>
  {% if request.user.is_authenticated %}
  <!-- 댓글 작성 UI -->
  <form action="{% url "board:comment_create" article.pk %}" method="POST">
    {% csrf_token %}
    {{ form }}
    <button>제출</button>
  </form>
  {% endif %}

  <!-- 댓글 조회 UI -->
  <ul>
    {% for comment in article.comment_set.all %}
    <li>
      {{ comment.content }}
      <!-- 댓글 삭제 UI -->
      <form 
        action="{% url "board:comment_delete" article.pk comment.pk %}" 
        method="POST" style="display: inline-block;"
      >
        {% csrf_token %}
        <button onclick="return confirm('삭제 하시겠습니까?')">삭제</button>
      </form>
    </li>
    {% endfor %}
  </ul>
</div>
```



<h2> accounts 앱 생성

<h3> 사용자 signup 과 login/out DB 생성을 위한 앱 생성

<h3> board/admin.py 

```python
from django.contrib import admin
from .models import Article, Comment

admin.site.register(Article)
admin.site.register(Comment)
```

<h3> accounts/urls.py

```python
from django.urls import path
from . import views

app_name = 'accounts'

urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('login/', views.login, name = 'login'),
    path('logout/', views.logout, name='logout'),
]
```

<h3> accounts/views.py

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.views.decorators.http import require_http_methods
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth import login as auth_login, logout as auth_logout

@require_http_methods(['GET','POST'])
def signup(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # 바로 이어서 로그인 시켜주기
            auth_login(request, user)
            return redirect('board:article_index')       
    else:
        form = UserCreationForm()
    return render(request, 'accounts/signup.html', {
        'form' : form,
    })

@require_http_methods(['GET','POST'])
def login(request):
    if request.method == 'POST':
        #Authenticationform은 다른 Modelform 과 다름.
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            # 해당 user 조회하여 return
            user = form.get_user()
            # 로그인을 시켜주는 용도이며, 해당이유로 save() 사용하지 않음
            auth_login(request, user)
            return redirect('board:article_index')
    else:
            form = AuthenticationForm()
    return render(request, 'accounts/login.html', {
        'form' : form,
    })
    
    

def logout(request):
    auth_logout(request)
    return redirect('board:article_index')
    
```

<h3> accounts/login.html 작성

```python
{% extends "base.html" %}

{% block content %}

<h1>LOGIN</h1>

<form method =  "POST">
    {% csrf_token %}
    {{ form.as_p }}
    <button>login</button>
</form>


{% endblock content %}
```


