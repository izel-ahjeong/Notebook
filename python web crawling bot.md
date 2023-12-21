# 12/6 웹 크롤링 리뷰 (아이패드 에어 5 가격정보를 얻어 텔레그램 내가 만든 봇으로 나에게 보내기)

***


```python
import requests
from bs4 import BeautifulSoup
```

# 원하는 페이지 가지고 오기

ipadURL ='https://search.shopping.naver.com/catalog/31530843620?cat_id=50000152&frm=NVSCMOD&query=%EC%95%84%EC%9D%B4%ED%8C%A8%EB%93%9C+%EC%97%90%EC%96%B45&NaPm=ct%3Dlptirdn4%7Cci%3D3f50636c5a1a00b045e20155f6ca5650b5f0ac73%7Ctr%3Dsls%7Csn%3D95694%7Chk%3D7b978b6de31f77cbef568d11c773d8cc38ac7bd5'


page = requests.get(ipadURL)


# naver 증권에 접속하여 전체 페이지를 다운 받는다.
page = requests.get(ipadURL)


# **parsing (구문분석/해석) -> bs4**
data = BeautifulSoup(page.text, 'html.parser')


# 아이패드 에어 5의 제품명과 현재 가격 데이터를 찾아낸다.

## 원하는 파트를 정할 때는 f12버튼을 누르고 확대하기 같은 버튼을 누른다
## 복사하기 -> selector copy

`ipadname = data.select_one('#container > div.style_inner__ZMO5R > div.top_summary_title__ViyrM > h2')`

`ipadprice = data.select_one('#content > div.style_content__v25xx > div > div.summary_info_area__NP6l5 > div.lowestPrice_price_area__VDBfj > div.lowestPrice_low_price__Ypmmk > em')`   



# 텔레그램에 봇을 만들고 내 아이디와 토큰을 알아낸다.
## getupdates 에서 아이디와 토큰 확인 가능하다.

'https://api.telegram.org/bot6335925415:AAHIEF-jQ825gHYRzhfjFf51cErX7edwJ24/getMe'
'https://api.telegram.org/bot6335925415:AAHIEF-jQ825gHYRzhfjFf51cErX7edwJ24/getUpdates'

TOKEN =''
My_ID = ''


# 텔레그램에 정보 전송 
## 1. sendMessage 에서 text 뒷편을 지운다
## 2. requests.get 에서 문자열을 합친다


URL = 'https://api.telegram.org/bot6335925415:AAHIEF-jQ825gHYRzhfjFf51cErX7edwJ24/sendMessage?chat_id=815413448&text='
message1 = ipadname.text
message2 = ipadprice.text

requests.get(URL + message1 + message2)