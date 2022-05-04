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
              if event.message['text'] =~ /バス/
                    message = {
                        type: 'text',
                        text: "バスの時刻表を検索します"
                    }
                    client.reply_message(event['replyToken'], [message, bus_date])
              end
            end
         when Line::Bot::Event::Postback           # ボタンが押されたあとの処理(ポストバック)
            if event['postback']['data'].split(",").first == "バス"           # bus_dateメソッドから
                array = event['postback']['data'].split(",")                  # array = [バス, 日にち, 日にち番号]の形に
                message = {
                    type: 'text',
                    text: "#{array[1]}ですね"
                }
                if event['postback']['data'].split(",").last == "乗車"        # bus_startメソッドから
                    array = event['postback']['data'].split(",")              # array = [バス, 日にち, 日にち番号, 乗車バス停, 乗車]
                    if array[3] == "京都女子大学"                             # 大学から帰る場合(乗車バス停が京都女子大学だったとき)帰る方向を決めるメソッドへ
                        client.reply_message(event['replyToken'], bus_direction(event['postback']['data']))
                    else                                                      # 大学に行く場合は結果を表示する(最後の数字(1)は大学に行くか帰るかの識別のための引数)
                        reply_bus(event, event['postback']['data'], 1)
                    end
                elsif event['postback']['data'].split(",").last =~ /行き/     # bus_directionメソッドから
                    array = event['postback']['data'].split(",")              # array = [バス, 日にち, 日にち番号, 乗車バス停, 乗車, 〇〇行き]
                    reply_bus(event, event['postback']['data'], 2)            # 結果を表示する
                end
                client.reply_message(event['replyToken'], [message, bus_start(event['postback']['data'])])  # 1つ目の質問(日にち決めbus_data)に対する応答
            end
        end
    end
end

def bus_date
    choice0 = "平日" 
    choice1 = "土曜日"
    choice2 = "日曜日・祝日"
    {
        "type": "text",
        "text": "横にスクロールして調べたい日を選んでください",
        "quickReply": {                          # クイックリプライを利用
        "items": [
            {
                "type": "action",
                "action": {                      # 1つ目のボタン
                    "type": "postback",
                    "label": choice0,
                    "text": choice0,
                    "data": "バス,#{choice0},0"  # 呼び出し元に返すデータ
                }
            },
            {                                    # 2つ目のボタン
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice1,
                    "text": choice1,
                    "data": "バス,#{choice1},1" 
                }
            },
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice2,
                    "text": choice2,
                    "data": "バス,#{choice2},2" 
                }
            }
        ]
        }
    }
end

def bus_start(data)
    choice1 = "京都女子大学"
    choice2 = "八条口"
    choice3 = "四条河原町"
    choice4 = "京阪七条"
    {
        "type": "template",
        "altText": "乗るバス停",

        "template": {
            "type": "buttons",    # ボタンテンプレートを利用
            "title": "乗車",
            "text": "どのバス停から乗りますか？",

            "actions": [
                {
                    "type": "postback",
                    "label": choice1,
                    "displayText": choice1,
                    "data": "#{data},#{choice1},乗車"
                },
                {
                    "type": "postback",
                    "label": choice2,
                    "displayText": choice2,
                    "data": "#{data},#{choice2},乗車"
                },
                {
                    "type": "postback",
                    "label": choice3,
                    "displayText": choice3,
                    "data": "#{data},#{choice3},乗車"
                },
                {
                    "type": "postback",
                    "label": choice4,
                    "displayText": choice4,
                    "data": "#{data},#{choice4},乗車"
                }
            ]
        }
    }
end

def bus_direction(data)
    choice1 = "八条口行き"
    choice2 = "四条河原町行き"
    {
        "type": "template",
        "altText": "行き先",

        "template": {
            "type": "buttons",             # ボタンテンプレートを利用
            "title": "行き先",
            "text": "どこ行きのバスか選んでください",

            "actions": [
                {
                    "type": "postback",
                    "label": choice1,
                    "displayText": choice1,
                    "data": "#{data},#{choice1}"
                },
                {
                    "type": "postback",
                    "label": choice2,
                    "displayText": choice2,
                    "data": "#{data},#{choice2}"
                }
            ]
        }
    }
end

def reply_bus(event, texts, num)     # バス時刻表
    # texts：入力されたデータ(","区切り)
    # [バス, 日にち, 日にち番号, 乗車バス停, 乗車, 〇〇行き]
    # num： 1=大学に行く, 2=大学から帰る
    # 0.八条口=>大学
    # 1.四条河原町=>大学
    # 2.京阪七条=>大学
    # 3.大学=>八条口方面
    # 4.大学=>四条河原町方面
        
    url = "https://drive.google.com/uc?id="
    choice = [],[],[]  # choice[x][y]のうちxの個数分用意
     # 日にち0(平日)
    choice[0][0] = "#{url}{※YOUR_URL※}"     # googleドライブにある画像のURL
    choice[0][1] = "#{url}{※YOUR_URL※}"
    choice[0][2] = "#{url}{※YOUR_URL※}"
    choice[0][3] = "#{url}{※YOUR_URL※}"
    choice[0][4] = "#{url}{※YOUR_URL※}"
    # 日にち1(土)
    choice[1][0] = "#{url}{※YOUR_URL※}"
    choice[1][1] = "#{url}{※YOUR_URL※}"
    choice[1][2] = "#{url}{※YOUR_URL※}"
    choice[1][3] = "#{url}{※YOUR_URL※}"
    choice[1][4] = "#{url}{※YOUR_URL※}"
    # 日にち2(日)
    choice[2][0] = "#{url}{※YOUR_URL※}"
    choice[2][1] = "#{url}{※YOUR_URL※}"
    choice[2][2] = "#{url}{※YOUR_URL※}"
    choice[2][3] = "#{url}{※YOUR_URL※}"
    choice[2][4] = "#{url}{※YOUR_URL※}"
  
    array = texts.split(",")
    # array = [バス, 日にち, 日にち番号, 乗車バス停, 乗車, 〇〇行き]
    if num == 1   # 行き
        case array[3]
        when "八条口"
            sec = 0
        when "四条河原町"
            sec = 1
        when "京阪七条"
            sec = 2
        end
        text = "#{array[1]}\n#{array[3]}から京都女子大学行き"
    elsif num == 2   # 帰り
        case array[5]
        when "八条口行き"
            sec = 3
        when "四条河原町行き"
            sec = 4
        end
        text = "#{array[1]}\n京都女子大学から#{array[5]}"
    end

    message = {
        type: 'text',
        text: "#{text}の時刻表は"
    }


    array[2] = array[2].to_i
  
    # 画像が見つからなかったときの処理
    images = {
        type: 'text',
        text: "エラーです。すみません！"
    }
    
    # 二次元配列に入れた画像のURLから該当のものを選ぶ
    for i in 0..2           # 日にち番号を回す
        if i == array[2]    # ループ変数i == ユーザ入力の日にち番号 なら
            for j in 0..4   # 方向
                if j == sec
                    images = {
                        type: 'image',
                        originalContentUrl: choice[i][j],
                        previewImageUrl: choice[i][j]
                    }
                end
            end
        end
    end

    client.reply_message(event['replyToken'], [message, images])
end
