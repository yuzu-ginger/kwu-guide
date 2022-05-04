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
              if event.message['text'] =~ /意見箱/ or event.message['text'] =~ /エラー/ or event.message['text'] =~ /使い方/
                    client.reply_message(event['replyToken'], richmenu_box)
              end
            end
         when Line::Bot::Event::Postback           # ボタンが押されたあとの処理(ポストバック)
            if event['postback']['data'].split(",").last == "意見箱"     # <= richmenu_box
                message  = {
                    type: 'text',
                    text: "次のような場合、意見箱を利用してください\n\n・途中でエラーが出た\n・情報が間違っていた\n・こんなサービスがほしい\n\n評価アンケートへのご協力もお願いしています"
                }
                attention = {
                    type: 'text',
                    text: "【注意！】\n・個人情報などは送信されません\n・個人が特定されることもありません\n・意見が反映されない場合もあります。ご了承ください"
                }
                client.reply_message(event['replyToken'], [message, attention, reply_opinion])

            end
        end
    end
end

def richmenu_box
    choice1 = "意見箱"
    choice2 = "使い方"
    {
        "type": "template",
        "altText": "意見箱使い方",
  
        "template": {
            "type": "buttons",
            "title": "choice",
            "text": "どちらか選んでください",
  
            # ポストバックアクション
            "actions": [
                {
                    "type": "postback",
                    "label": choice1,
                    "displayText": choice1,
                    "data": "#{choice1}"
                },
                {
                    "type": "uri",
                    "label": choice2,
                    "uri": "{※YOUR_URL※}"
                }
            ]
        }
    }
end

def reply_opinion
    {
        "type": "template",
        "altText": "意見箱",

        "template": {
            "type": "buttons",
            "title": "フォーム",
            "text": "こちらのフォームから回答してください",              # 質問(例：何回生ですか)

            # ポストバックアクション
            "actions": [
                {
                    "type": "uri",
                    "label": "意見箱",
                    "uri": "{※YOUR_URL※}"
                },
                {
                    "type": "uri",
                    "label": "評価アンケート",
                    "uri": "{※YOUR_URL※}"
                }
            ]
        }
    }
end
