require 'nokogiri'
require 'open-uri'
require 'httparty'

class Mma 
  @@MMA_URL = 'http://work.mma.go.kr/caisBYIS/board/boardList.do?gesipan_gbcd=13&tmpl_id=1&menu_id=m_m8_6'

  def run
    notice = get_last_notice
    title = notice.children.first.children.first.text.gsub(/\s+/,'')
    if local_notice != title
      notice_url = notice.children.first.attributes.first[1].value
      url = "http://work.mma.go.kr/#{notice_url}"
      send_message_for_slack(title, url)

      update_local_notice(title)
    end
  end

  def send_message_for_slack(title, url)
    payload = { 'payload' => {
      'username' => '병무청',
      'text' => "<#{url}|#{title}> 공지확인하기"
    }.to_json }
    
    HTTParty.post(get_slack_webhook, body: payload)
  end

  def local_notice
    begin
      f = File.open('./mma.txt', 'r:utf-8')
      f.readline
    rescue
      return ''
    ensure
      f.close unless f.nil?
    end
  end

  def update_local_notice(title)
    f = File.open('./mma.txt', 'w:utf-8')
    f.write(title)
    f.close
  end

  def get_last_notice
    Nokogiri::HTML(open(@@MMA_URL)).css('td.title').first  
  end

  def get_slack_webhook
    YAML.load_file('config/slack_webhook.yml').fetch('url')
  end
end

mma = Mma.new
mma.run
