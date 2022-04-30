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

                elsif event.message['text'] =~ /バス/
                    message = {
                        type: 'text',
                        text: "バスの時刻表を検索します"
                    }
                    client.reply_message(event['replyToken'], [message, bus_date])

                elsif event.message['text'] =~ /空き教室/
                    message = {
                        type: 'text',
                        text: "空き教室を検索します\n空き教室は2022年4月25日時点のものです。使用中の場合は別教室を探してください"
                    }
                    client.reply_message(event['replyToken'], [message, room_day])
                    
                elsif event.message['text'] =~ /各種証明書/ or event.message['text'] =~ /Q&A/
                    
                    client.reply_message(event['replyToken'], richmenu_qa)

                elsif event.message['text'] =~ /マップ/
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

                elsif event.message['text'] =~ /意見箱/ or event.message['text'] =~ /エラー/ or event.message['text'] =~ /使い方/
                    client.reply_message(event['replyToken'], richmenu_box)
                    
                    # v施設・部署検索
                elsif event.message['text'] == "が"
                    client.reply_message(event['replyToken'], ques_char("が"))
                elsif event.message['text'] == "し"
                    client.reply_message(event['replyToken'], ques_char("し"))
                elsif event.message['text'] == "け"
                    client.reply_message(event['replyToken'], ques_char("け"))
                elsif event.message['text'] == "き"
                    client.reply_message(event['replyToken'], ques_char("き"))
                elsif event.message['text'] == "れ"
                    reply_ques_file(event, "連携推進課")
                elsif event.message['text'] == "ち"
                    reply_ques_file(event, "地域連携研究センター")
                elsif event.message['text'] == "こ"
                    client.reply_message(event['replyToken'], ques_char("こ"))
                elsif event.message['text'] == "に"
                    reply_ques_file(event, "入試広報課")
                elsif event.message['text'] == "ざ"
                    reply_ques_file(event, "財務課")
                elsif event.message['text'] == "と"
                    reply_ques_file(event, "図書館")
                elsif event.message['text'] == "お"
                    reply_ques_file(event, "京都女子大学大阪オフィス")
                elsif event.message['text'] == "そ"
                    reply_ques_file(event, "総務課")
                elsif event.message['text'] == "じ"
                    reply_ques_file(event, "情報システム課")
                elsif event.message['text'] == "だ"
                    reply_ques_file(event, "大学院事務センター")
                elsif event.message['text'] == "一覧"    # 施設・部署の一覧(売店、食堂以外)
                    reply_ques_list(event)
                end
            end
        when Line::Bot::Event::Postback           # ボタンが押されたあとの処理
            if event['postback']['data'].split(",").first == "バス"   # バス時刻表検索 <= bus_date

                array = event['postback']['data'].split(",")
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"
                }

                if event['postback']['data'].split(",").last == "乗車"        # <= bus_start
                    array = event['postback']['data'].split(",")
                    # array = [バス, 日にち, 日にち番号, 乗車バス停, 乗車]
                    if array[3] == "京都女子大学"   # 大学から帰る
                        client.reply_message(event['replyToken'], bus_direction(event['postback']['data']))
                    else   # 大学に行く
                        reply_bus(event, event['postback']['data'], 1)
                    end
                elsif event['postback']['data'].split(",").last =~ /行き/     # <= bus_direction
                    array = event['postback']['data'].split(",")
                    # array = [バス, 日にち, 日にち番号, 乗車バス停, 乗車, 〇〇行き]
                    reply_bus(event, event['postback']['data'], 2)
                end
                client.reply_message(event['replyToken'], [message, bus_start(event['postback']['data'])])

            elsif event['postback']['data'].split(",").first == "教室"   # 空き教室検索 <= room_day
                # array = [教室, 曜日, 曜日コード]
                array = event['postback']['data'].split(",")
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"
                }
              
                if event['postback']['data'].split(",").last == "限"        # <= room_time
                    array = event['postback']['data'].split(",")
                    # array = [教室, 曜日, 曜日コード, 何限, 講時コード, 限]
                    message = {
                        type: 'text',
                        text: "#{array[3]}ですね"
                    } 
                    client.reply_message(event['replyToken'], [message, room_build(event['postback']['data'])])   
                elsif event['postback']['data'].split(",").last == "校舎"        # <= room_build
                    array = event['postback']['data'].split(",")
                    # array = [教室, 曜日, 曜日コード, 何限, 講時コード, 限, 何校舎, 校舎] 
                    reply_room(event, array)
                end
              
                client.reply_message(event['replyToken'], [message, room_time(event['postback']['data'])])
                
            elsif event['postback']['data'] == "各種証明書"
                message = {
                    type: 'text',
                    text: "各種証明書について調べます"
                }
                client.reply_message(event['replyToken'], [message, cer_kind])

            elsif event['postback']['data'] == "Q&A"
                message = {
                    type: 'text',
                    text: "Q＆Aでは施設・部署の検索・場所・利用時間・連絡先、困ったときにどうすればいいのかがわかります"
                }
                client.reply_message(event['replyToken'], [message, ques_kind])

            elsif event['postback']['data'].split(",").first == "証明書"      # 各種証明書 <= cer_kind
                array = event['postback']['data'].split(",")
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"     # array[1]="見込証明書"or"英文"or"その他"
                }
                if event['postback']['data'].split(",").last == "c"           # <= cer_kind_detail
                    array = event['postback']['data'].split(",")
                    # array = [証明書, 大分類, 種類, c]
                    reply_cer(event, array[2])
                end
                client.reply_message(event['replyToken'], [message, cer_kind_detail(event['postback']['data'], array[1])])

            elsif event['postback']['data'].split(",").first == "Q"           # <= ques_kind
                array = event['postback']['data'].split(",")
                # array = [Q, 大分類]
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"
                }
                if array[1] == "施設(場所・利用時間・電話番号)"
                    client.reply_message(event['replyToken'], [message, ques_info])
                else    # 施設(利用時間・電話番号)以外
                    client.reply_message(event['replyToken'], [message, ques_choice(array[1])])
                end
                
            elsif event['postback']['data'].split(",").last == "施設"            # <= ques_info, ques_char
                array = event['postback']['data'].split(",")
                # array = [売店名・施設名・部署名, 施設]
                reply_ques_file(event, array[0])

            elsif event['postback']['data'].split(",").last == "質問"       # <= ques_choice
                array = event['postback']['data'].split(",")
                # array = [大分類, 質問キーワード,質問]
                if array[1] == "学年暦"
                    message = {
                        type: 'text',
                        text: "#{array[1]}ですね"
                    }
                    client.reply_message(event['replyToken'], [message, reply_ques_schedule])
                elsif array[1] == "各種証明書"
                    message = {
                        type: 'text',
                        text: "各種証明書について調べます"
                    }
                    client.reply_message(event['replyToken'], [message, cer_kind])
                else
                    reply_ques_answer(event, array[1])
                end
            elsif event['postback']['data'].split(",").last == "意見箱"     # <= richmenu_box
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
  
    "OK"
end
