require 'bundler/setup'
require 'sinatra'
require 'line/bot'
require 'roo'

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
              if event.message['text'] =~ /空き教室/
                    message = {
                        type: 'text',
                        text: "空き教室を検索します\n空き教室は2022年4月25日時点のものです。使用中の場合は別教室を探してください"
                    }
                    client.reply_message(event['replyToken'], [message, room_day])    # 配列に入れることで複数の応答メッセージを送信できる
              end
            end
         when Line::Bot::Event::Postback           # ボタンが押されたあとの処理(ポストバック)
            if event['postback']['data'].split(",").first == "教室"   # <= room_dayメソッド
                # array = [教室, 曜日, 曜日コード]
                array = event['postback']['data'].split(",")
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"
                }
                if event['postback']['data'].split(",").last == "限"        # <= room_timeメソッド
                    array = event['postback']['data'].split(",")
                    # array = [教室, 曜日, 曜日コード, 何限, 講時コード, 限]
                    message = {
                        type: 'text',
                        text: "#{array[3]}ですね"
                    } 
                    client.reply_message(event['replyToken'], [message, room_build(event['postback']['data'])])   
                elsif event['postback']['data'].split(",").last == "校舎"        # <= room_buildメソッド
                    array = event['postback']['data'].split(",")
                    # array = [教室, 曜日, 曜日コード, 何限, 講時コード, 限, 何校舎, 校舎] 
                    reply_room(event, array)
                end
              
                client.reply_message(event['replyToken'], [message, room_time(event['postback']['data'])])
            end
        end
    end
end

def room_day
  choice1 = "月曜日"
  choice2 = "火曜日"
  choice3 = "水曜日"
  choice4 = "木曜日"
  choice5 = "金曜日"
  {
    "type": "text",
    "text": "横にスクロールして曜日を選んでください",
    "quickReply": {
        "items": [
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice1,
                    "text": choice1,
                    "data": "教室,#{choice1},1" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice2,
                    "text": choice2,
                    "data": "教室,#{choice2},2" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice3,
                    "text": choice3,
                    "data": "教室,#{choice3},3" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice4,
                    "text": choice4,
                    "data": "教室,#{choice4},4" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice5,
                    "text": choice5,
                    "data": "教室,#{choice5},5" 
                }
            }
        ]
    }
  }
end

def room_time(data)
  choice1 = "1限"
  choice2 = "2限"
  choice3 = "3限"
  choice4 = "4限"
  choice5 = "5限"
  choice6 = "6限"
  {
    "type": "text",
    "text": "横にスクロールして時間を選んでください",
    "quickReply": {
        "items": [
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice1,
                    "text": choice1,
                    "data": "#{data},#{choice1},1,限" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice2,
                    "text": choice2,
                    "data": "#{data},#{choice2},2,限" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice3,
                    "text": choice3,
                    "data": "#{data},#{choice3},3,限" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice4,
                    "text": choice4,
                    "data": "#{data},#{choice4},4,限" 
                }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice5,
                      "text": choice5,
                      "data": "#{data},#{choice5},5,限" 
                  }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice6,
                      "text": choice6,
                      "data": "#{data},#{choice6},6,限" 
                  }
            }
        ]
    }
  }
end

def room_build(data)
  choice1 = "A校舎"
  choice2 = "C校舎"
  choice3 = "E校舎"
  choice4 = "F校舎"
  choice5 = "J校舎"
  choice6 = "S校舎"
  choice7 = "U校舎"
  choice8 = "Y校舎"
  {
    "type": "text",
    "text": "横にスクロールして校舎を選んでください",
    "quickReply": {
        "items": [
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice1,
                    "text": choice1,
                    "data": "#{data},#{choice1},校舎" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice2,
                    "text": choice2,
                    "data": "#{data},#{choice2},校舎" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice3,
                    "text": choice3,
                    "data": "#{data},#{choice3},校舎" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice4,
                    "text": choice4,
                    "data": "#{data},#{choice4},校舎" 
                }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice5,
                      "text": choice5,
                      "data": "#{data},#{choice5},校舎" 
                  }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice6,
                      "text": choice6,
                      "data": "#{data},#{choice6},校舎" 
                  }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice7,
                      "text": choice7,
                      "data": "#{data},#{choice7},校舎" 
                  }
            },
            {
                  "type": "action",
                  "action": {
                      "type": "postback",
                      "label": choice8,
                      "text": choice8,
                      "data": "#{data},#{choice8},校舎" 
                  }
            }
        ]
    }
  }
end

def reply_room(event, array)
    # p array
    # array = [教室, 曜日, 曜日コード, 何限, 講時コード, 限, 何校舎, 校舎] 
    
    # room_index.xlsx(全教室名データ)で参照するデータの行(校舎別)
    case array[6]
    when "A校舎"
        start = 2
        finish = 11
    when "C校舎"
        start = 46
        finish = 88
    when "E校舎"
        start = 89
        finish = 100
    when "F校舎"
        start = 101
        finish = 111
    when "J校舎"
        start = 112
        finish = 145
    when "S校舎"
        start = 146
        finish = 164
    when "U校舎"
        start = 165
        finish = 166
    when "Y校舎"
        start = 167
        finish = 188
    end

    room = ""         # リプライメッセージ用
    index = []        # 全教室名(一覧)を入れる配列(校舎指定)
    index_use = []    # 使用中の教室を入れる配列
    xlsx_room = Roo::Excelx.new("room_index.xlsx")  # 全教室名データ
    xlsx = CSV.read("roomdata.csv", headers: true).map(&:to_hash)  # 校舎別使用教室データ★

    # 処理速度計算(start)
    start_time = Time.now

    # 教室一覧(校舎指定)、読み込む位置を指定することで校舎別にする
    for i in start..finish
        index.push(xlsx_room.cell(i, "A").to_s)
    end
    
    use_then = xlsx.find_all {|x| x["開講サイン"] == "1" && x["曜日コード"] == array[2] && x["講時"] == array[4] && x["教室"] =~ /#{array[6].chars.first}/}
    use_then.each do |x|
        index_use.push(x["教室"])
    end

    index -= index_use   # 教室一覧(index)から使用教室(index_use)消す

    # ・A201\nの形にする
    index.each do |x|
        if x == index.last
            room += "・#{x}\nです"
        else
            room += "・#{x}\n"
        end
    end
  
    if index == []
      room = "ありません"
    end

    # 処理速度計算(finish)
    puts "\e[33m処理 #{Time.now - start_time}s\e[0m"
  
    message = {
      type: "text",
      text: "#{array[1]}#{array[3]}#{array[6]}の空き教室は\n#{room}"
    }
    client.reply_message(event['replyToken'], message)
end
