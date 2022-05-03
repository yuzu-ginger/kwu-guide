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
                if event.message['text'] =~ /京女ポータル/ or event.message['text'] =~ /図書館/
                    
                    client.reply_message(event['replyToken'], richmenu_url)
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
          "type": "buttons",
          "title": "ウェブページを開きます",
          "text": "選んでください",
        
          "actions": [
              {
                  "type": "uri",
                  "label": choice1,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice2,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice3,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice4,
                  "uri": "{※YOUR_URL※}"
              }
          ]
      }
  }
end

def richmenu_qa
  choice1 = "各種証明書"
  choice2 = "Q&A"
  {
      "type": "template",
      "altText": "リッチメニューURL",

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
                  "type": "postback",
                  "label": choice2,
                  "displayText": choice2,
                  "data": "#{choice2}"
              }
          ]
      }
  }
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
