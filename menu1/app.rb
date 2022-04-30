require 'bundler/setup'
require 'sinatra'
require 'line/bot'
require 'roo'
require_relative 'bus'
require_relative 'reply'
require_relative 'certificate'
require_relative 'question'
require_relative 'question_char'
require_relative 'room'
require_relative 'richmenu'

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
