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
              if event.message['text'] =~ /マップ/
                    campusmap = "{※YOUR_URL※}"
                    message = {
                        type: 'text',
                        text: "キャンパスマップはこちらです"
                    }
                    images = {
                        type: 'image',
                        originalContentUrl: campusmap,
                        previewImageUrl: campusmap
                    }
                    client.reply_message(event['replyToken'], [message, images])
              end
            end
        end
    end
end
