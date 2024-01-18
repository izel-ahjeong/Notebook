<h2> 사용자 접근 제한 

<h3> board/views.py

```python
from django.contrib.auth.decorators import login_required # 로그인한 사용자만 해당 view함수를 사용할 수 있도록 하는 decorators.

# 예시
@login_required # @ 순서가 중요.
@require_http_methods(['GET', 'POST'])
def article_create(request): # 로그인 한 사용자만 article 생성 가능.
    # POST => 데이터 저장하기
    if request.method == 'POST':
        form = ArticleForm(request.POST)
        if form.is_valid():
            article = form.save(commit=False) # 바로 저장할 경우, user 값이 삽입 되지않아 에러 발생
            article.user = request.user
            # user 값 삽입
            article.save()
            return redirect('board:article_detail', article.pk)
            
    # GET => 화면(html form>주기
    elif request.method == 'GET':
        form = ArticleForm()

    return render(request, 'board/form.html', {
        'form': form,
    })

@login_required
@require_http_methods(['GET', 'POST'])
def article_update(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    # '지금 요청을 보낸 user'와 작성자가 다르다면
    if request.user != article.user:
        # 전체화면으로 돌아가게 만들기
        return redirect('board:article_index')
        # 오류 띄우기
        # return HttpResponseForbidden('작성자가 아닙니다.')

    # POST => 데이터 저장하기
    if request.method == 'POST':
        form = ArticleForm(request.POST, instance=article)
        if form.is_valid():
            article = form.save()
            return redirect('board:article_detail', article.pk)
            
    # GET => 화면(html form)주기
    elif request.method == 'GET':
        form = ArticleForm(instance=article)

    return render(request, 'board/form.html', {
        'form': form,
    })

@login_required # article 삭제도 로그인을 한 사용자만 가능.
@require_POST
def article_delete(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    if request.user != article.user: # 요청한 사용자가 작성자와 동일할 경우에만.
        return redirect('board:article_detail', article.pk)
    article.delete()
    return redirect('board:article_index')


@login_required
@require_POST
def comment_create(request, article_pk):
    article = get_object_or_404(Article, pk=article_pk)
    form = CommentForm(request.POST)
    if form.is_valid():
        # 저장 직전에 멈춘다.
        comment = form.save(commit=False)
        comment.article = article
        comment.user= request.user # 커맨트 작성자에 요청자 id 넣기
        comment.save()
    # 저장과 상관없이 마지막엔 redirect        
    return redirect('board:article_detail', article.pk)
```

<h3> board/detail.html, detai_comment.html

```html
<p>{{ article.content | linebreaksbr }}</p>

{% if article.user == request.user %} # 요청자와 작성자 확인
<div>
  <a href="{% url "board:article_update" article.pk %}">
    <button>update</button>
  </a>
</div>
```

```python
  {% if request.user.is_authenticated %} # 요청자가 인증을 받았다면.
  <!-- 댓글 작성 UI -->
  <form action="{% url "board:comment_create" article.pk %}" method="POST">
    {% csrf_token %}
    {{ form }}
    <button>commit</button>
  </form>
  {% endif %}
```


<h2> profile page 작성

<h3> accounts/urls.py

```python 
path('<str:username>/', views.profile, name='profile') # 각 username을 사용할 수 있도록 <> 처리
```

<h3> accounts/views.py

```python
@require_safe
def profile(request, username): # urls 에서 제공받은 username 
    User = get_user_model()
    user = get_object_or_404(User, username=username) 
    return render(request, 'accounts/profile.html', {
        'user':user,
    })
```

<h3> accounts/profile.html

```html
{% extends "base.html" %}

{% block content %}

<h1>{{user.username}}</h1>

<h2>Articles</h2>
<ul>
    {% for article in user.article_set.all %} # user 별 작성 article 전부 출력
    <li>
        <a href="{% url "board:article_detail" article.pk %}">{{article.title}}</a>
    </li>
    {% endfor %}
</ul>


<h2>Comments</h2>
<ul>
    {% for comment in user.comment_set.all %} # user 별 작성 comment 전부 출력
    <li>
        {% comment %} 댓글이 달려있는 게시글의 pk가 필요함 {% endcomment %}
        <a href="{% url "board:article_detail" comment.article.pk %}">
            {{ comment.content }}
        </a>
    </li>
    {% endfor %}
</ul>

{% endblock content %}
```