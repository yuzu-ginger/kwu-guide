require 'bundler/setup'
require 'sinatra'
require 'line/bot'

# test
get '/' do
  'hello world!'
end

def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
end
  
post '/callback' do
    body = request.body.read
  
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end
  
    events = client.parse_events_from(body)
  
    events.each do |event|
        case event
        when Line::Bot::Event::Message
            case event.type
            when Line::Bot::Event::MessageType::Text     # テキストが入力されたときの処理
                if event.message['text'] =~ /京女ポータル/ or event.message['text'] =~ /図書館/     # "京女ポータル"か"図書館"の文字列が含まれていたら          
                    client.reply_message(event['replyToken'], richmenu_url)                         # 応答メッセージを送信(richmenu_urlメソッドを表示する)
                end
            end
        end
    end
end

def richmenu_url
  choice1 = "京女ポータル"
  choice2 = "図書館HP"
  choice3 = "蔵書検索(OPAC)"
  choice4 = "My Library"
  {
      "type": "template",
      "altText": "リッチメニューURL",

      "template": {
          "type": "buttons",                    # ボタンテンプレートを使用
          "title": "ウェブページを開きます",     # ボタンのタイトル(表示される)
          "text": "選んでください",              # ボタンの説明文(表示される)
        
          "actions": [
              {                                 # 1つ目のボタン
                  "type": "uri",                # urlタイプ
                  "label": choice1,             # ボタンに表示されるテキスト(choice1="京女ポータル")
                  "uri": "{※YOUR_URL※}"       # 遷移先のurl, ダブルクォーテーション(")で囲む
              },
              {                                 # 2つ目のボタン
                  "type": "uri",
                  "label": choice2,
                  "uri": "{※YOUR_URL※}"
              },
              {                                 # 3つ目のボタン
                  "type": "uri",
                  "label": choice3,
                  "uri": "{※YOUR_URL※}"
              },
              {                                 # 4つ目のボタン
                  "type": "uri",
                  "label": choice4,
                  "uri": "{※YOUR_URL※}"
              }
          ]
      }
  }
end
