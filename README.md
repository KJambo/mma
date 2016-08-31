# 병특을 위한 병무청 공지사항 눈팅 봇

### 설치

```ruby
gem install httparty
gem install nokogiri
```

잼 두개 사용 중

config 폴더 아래에 slack_webhook.yml 파일에 아래와 같이 넣어주고 실행하면 끝

```sh
url: YOUR_WEBHOOK_URL
```

crontab에 등록해서 사용하는 것이 좋을듯
