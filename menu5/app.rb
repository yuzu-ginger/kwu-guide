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
              if event.message['text'] =~ /各種証明書/ or event.message['text'] =~ /Q&A/                    
                 client.reply_message(event['replyToken'], richmenu_qa)
              end
            end
         when Line::Bot::Event::Postback           # ボタンが押されたあとの処理(ポストバック)
            if event['postback']['data'] == "各種証明書"
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
            end
        end
    end
end

def cer_kind
    choice1 = "見込証明書"
    choice2 = "英文"
    choice3 = "その他"
    {
        "type": "text",
        "text": "横にスクロールして種類を選んでください",
        "quickReply": {
            "items": [
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice1,
                        "text": choice1,
                        "data": "証明書,#{choice1}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice2,
                        "text": choice2,
                        "data": "証明書,#{choice2}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice3,
                        "text": choice3,
                        "data": "証明書,#{choice3}" 
                    }
                }
            ]
        }
    }
end

def cer_kind_detail(data, kind)
    case kind
    when "見込証明書"
        choice1 = "卒業見込証明書"
        choice2 = "教員免許状取得見込証明書"
        choice3 = "指定保育士養成施設卒業見込証明書"
        choice4 = "諸課程取得見込証明書"
        {
            "type": "text",
            "text": "横にスクロールして選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},c" 
                        }
                    }
                ]                
            }
        }
    when "英文"
        choice1 = "英文成績証明書"
        choice2 = "英文その他の証明書"
        {
            "type": "text",
            "text": "横にスクロールして選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},c" 
                        }
                    }
                ]                
            }
        }
    when "その他"
        choice1 = "成績証明書"
        choice2 = "就職用健康診断証明書(卒業回生)"
        choice3 = "学校学生生徒旅客運賃割引証(学割証)"
        choice4 = "在学証明書"
        choice5 = "仮学生証"
        choice6 = "大学院受験用調査書"
        choice7 = "行動に関する記録"
        choice8 = "提出先所定用紙による証明書"
        choice9 = "推薦書"
        choice10 = "学生証再交付願"
        {
            "type": "text",
            "text": "横にスクロールして選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice7,
                            "text": choice7,
                            "data": "#{data},#{choice7},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice8,
                            "text": choice8,
                            "data": "#{data},#{choice8},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice9,
                            "text": choice9,
                            "data": "#{data},#{choice9},c" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice10,
                            "text": choice10,
                            "data": "#{data},#{choice10},c" 
                        }
                    }
                ]                
            }
        }
    end
end

def ques_kind
    choice1 = "施設(場所・利用時間・電話番号)"
    choice2 = "学籍関係"
    choice3 = "学習関係"
    choice4 = "学生生活関係"
    choice5 = "生活・経済関係"
    choice6 = "証明書関係"
    choice7 = "課外活動関係"
    choice8 = "健康管理関係"
    choice9 = "情報システム関係"
    choice10 = "図書館関係"
    choice11 = "進路・就職関係"
    choice12 = "諸手続"
    choice13 = "その他"
    {
        "type": "text",
        "text": "横にスクロールして選んでください",
        "quickReply": {
            "items": [
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice1,
                        "text": choice1,
                        "data": "Q,#{choice1}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice2,
                        "text": choice2,
                        "data": "Q,#{choice2}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice3,
                        "text": choice3,
                        "data": "Q,#{choice3}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice4,
                        "text": choice4,
                        "data": "Q,#{choice4}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice5,
                        "text": choice5,
                        "data": "Q,#{choice5}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice6,
                        "text": choice6,
                        "data": "Q,#{choice6}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice7,
                        "text": choice7,
                        "data": "Q,#{choice7}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice8,
                        "text": choice8,
                        "data": "Q,#{choice8}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice9,
                        "text": choice9,
                        "data": "Q,#{choice9}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice10,
                        "text": choice10,
                        "data": "Q,#{choice10}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice12,
                        "text": choice12,
                        "data": "Q,#{choice12}" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice13,
                        "text": choice13,
                        "data": "Q,#{choice13}" 
                    }
                }
            ]
        }
    }
end

def ques_info
    choice1 = "A校舎学生食堂(Aチカ)"
    choice2 = "A校舎パンコーナー"
    choice3 = "C校舎売店(ファミリーマート)"
    choice4 = "E校舎カフェテリア"
    choice5 = "E校舎書籍売店(ウィステリア)"
    choice6 = "J校舎売店"
    choice7 = "K校舎カフェ＆ベーカリー(エストモンテ)"
    choice8 = "Q校舎大学購買室(リブレ)"
    choice9 = "Q校舎ATMコーナー"
    choice10 = "C校舎ATMコーナー"
    {
        "type": "text",
        "text": "食堂・売店・ATMは下のボタンから選んでください\n\nそれ以外は調べたい施設・部署の頭文字をひらがなで入力してください\n\n「一覧」と入力すると施設・部署の一覧が見られます",
        "quickReply": {
            "items": [
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice1,
                        "text": choice1,
                        "data": "#{choice1},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice2,
                        "text": choice2,
                        "data": "#{choice2},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice3,
                        "text": choice3,
                        "data": "#{choice3},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice4,
                        "text": choice4,
                        "data": "#{choice4},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice5,
                        "text": choice5,
                        "data": "#{choice5},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice6,
                        "text": choice6,
                        "data": "#{choice6},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice7,
                        "text": choice7,
                        "data": "#{choice7},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice8,
                        "text": choice8,
                        "data": "#{choice8},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice9,
                        "text": choice9,
                        "data": "#{choice9},施設" 
                    }
                },
                {
                    "type": "action",
                    "action": {
                        "type": "postback",
                        "label": choice10,
                        "text": choice10,
                        "data": "#{choice10},施設" 
                    }
                }
            ]
        }
    }
end

def ques_choice(data)
    case data
    when "学籍関係"
        choice1 = "休学"
        choice2 = "復学"
        choice3 = "退学"
        choice4 = "転部・転科・転専攻"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    }
                ]
            }
        }
    when "学習関係"
        choice1 = "大学の学習の相談"
        choice2 = "レポート・論文"
        choice3 = "印刷"
        choice4 = "公欠"
        choice5 = "長期欠席"
        choice6 = "忌引"
        choice7 = "履修登録・教育実習・その他講義"
        choice8 = "交通機関ストライキ・台風"
        choice9 = "試験が受けられない"
        choice10 = "試験当日学生証がない"
        choice11 = "留学・語学研修"
        choice12 = "学年暦"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice7,
                            "text": choice7,
                            "data": "#{data},#{choice7},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice8,
                            "text": choice8,
                            "data": "#{data},#{choice8},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice9,
                            "text": choice9,
                            "data": "#{data},#{choice9},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice10,
                            "text": choice10,
                            "data": "#{data},#{choice10},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice11,
                            "text": choice11,
                            "data": "#{data},#{choice11},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice12,
                            "text": choice12,
                            "data": "#{data},#{choice12},質問" 
                        }
                    }
                ]
            }
        }
    when "学生生活関係"
        choice1 = "障がいや病気"
        choice2 = "学生生活の相談全般"
        choice3 = "通学定期券"
        choice4 = "学年暦"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    }
                ]
            }
        }
    when "生活・経済関係"
        choice1 = "学費の分納・延納"
        choice2 = "奨学金"
        choice3 = "アルバイト"
        choice4 = "学内アルバイト"
        choice5 = "通学定期券"
        choice6 = "諸課程実習費等"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},質問" 
                        }
                    }
                ]
            }
        }
    when "証明書関係"
        choice1 = "各種証明書"
        choice2 = "学生証"
        choice3 = "学生証の再交付"
        choice4 = "通学定期券"
        choice5 = "「学外実習用」通学定期券"
        choice6 = "学生団体割引"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},質問" 
                        }
                    }
                ]
            }
        }
    when "課外活動関係"
        choice1 = "団体の結成"
        choice2 = "合宿"
        choice3 = "大会・試合への参加"
        choice4 = "行事開催・行事参加"
        choice5 = "教室を借りる"
        choice6 = "体育館・グラウンド・練習室を借りる"
        choice7 = "クラブ援助金"
        choice8 = "学生団体割引"
        choice9 = "学校支援ボランティア"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice7,
                            "text": choice7,
                            "data": "#{data},#{choice7},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice8,
                            "text": choice8,
                            "data": "#{data},#{choice8},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice9,
                            "text": choice9,
                            "data": "#{data},#{choice9},質問" 
                        }
                    }
                ]
            }
        }
    when "健康管理関係"
        choice1 = "ケガ・気分が悪い"
        choice2 = "入通院"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    }
                ]
            }
        }
    when "情報システム関係"
        choice1 = "印刷"
        choice2 = "コンピュータの利用"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    }
                ]
            }
        }
    when "図書館関係"
        choice1 = "レポート・論文"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    }
                ]
            }
        }
    when "進路・就職関係"
        choice1 = "将来のこと・インターンシップ"
        choice2 = "進路・就職"
        choice3 = "教職支援"
        choice4 = "教職養成講座"
        choice5 = "学校支援ボランティア"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    }
                ]
            }
        }
    when "諸手続"
        choice1 = "現住所・電話番号・メールアドレスの変更"
        choice2 = "保証人(保護者)の住所変更"
        choice3 = "改姓・改名"
        choice4 = "保証人の変更"
        choice5 = "公欠"
        choice6 = "忌引"
        choice7 = "家族が亡くなった"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{data},#{choice4},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{data},#{choice5},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{data},#{choice6},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice7,
                            "text": choice7,
                            "data": "#{data},#{choice7},質問" 
                        }
                    }
                ]
            }
        }
    when "その他"
        choice1 = "諸課程実習費等"
        choice2 = "紛失・拾得・盗難"
        choice3 = "忘れ物"
        {
            "type": "text",
            "text": "横にスクロールしてキーワードを選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{data},#{choice1},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{data},#{choice2},質問" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{data},#{choice3},質問" 
                        }
                    }
                ]
            }
        }
    end
end

def ques_char(data)   # data == 頭文字
    case data
    when "が"
        choice1 = "学生支援課"
        choice2 = "学生相談室"
        {
            "type": "text",
            "text": "横にスクロールして調べたい施設・部署を選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{choice1},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{choice2},施設"
                        }
                    }
                ]
            }
        }
    when "し"
        choice1 = "障がい学生支援チーム"
        choice2 = "宗教教育センター"
        choice3 = "宗教教育課"
        choice4 = "証明書発行センター"
        choice5 = "進路・就職課"
        choice6 = "資格サポートコーナー"
        {
            "type": "text",
            "text": "横にスクロールして調べたい施設・部署を選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{choice1},施設" 
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{choice2},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{choice3},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{choice4},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice5,
                            "text": choice5,
                            "data": "#{choice5},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice6,
                            "text": choice6,
                            "data": "#{choice6},施設"
                        }
                    }
                ]
            }
        }
    when "け"
        choice1 = "健康管理センター"
        choice2 = "経営企画室"
        {
            "type": "text",
            "text": "横にスクロールして調べたい施設・部署を選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{choice1},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{choice2},施設"
                        }
                    }
                ]
            }
        }
    when "き"
        choice1 = "教務課"
        choice2 = "教職支援センター"
        choice3 = "キャリア開発センター"
        choice4 = "京都女子大学大阪オフィス"
        {
            "type": "text",
            "text": "横にスクロールして調べたい施設・部署を選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{choice1},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{choice2},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{choice3},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice4,
                            "text": choice4,
                            "data": "#{choice4},施設"
                        }
                    }
                ]
            }
        }
    when "こ"
        choice1 = "国際交流課"
        choice2 = "コンピュータ教室"
        choice3 = "コンピュータ相談室(S028)"
        {
            "type": "text",
            "text": "横にスクロールして調べたい施設・部署を選んでください",
            "quickReply": {
                "items": [
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice1,
                            "text": choice1,
                            "data": "#{choice1},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice2,
                            "text": choice2,
                            "data": "#{choice2},施設"
                        }
                    },
                    {
                        "type": "action",
                        "action": {
                            "type": "postback",
                            "label": choice3,
                            "text": choice3,
                            "data": "#{choice3},施設"
                        }
                    }
                ]
            }
        }
    end
end

def reply_cer(event, data)             # 各種証明書のリプライ
    iFileName = "certificate_file.txt"
    list = []
    File.open(iFileName,"r") do |iFile|
        iFile.each_line do |ll|   # 各行を読み込む
          kind,money,day,window = ll.chomp.split(",")
          list.push({"kind"=>kind,"money"=>money,"day"=>day,"window"=>window})
        end
    end
    
    text = "エラーです。すみません！"
    for i in 0...list.size
        #p list[i]["kind"]
        if list[i]["kind"] == data
            #puts list[i]["kind"]
            text = "#{list[i]["kind"]}\n\n手数料：#{list[i]["money"]}\n交付日：#{list[i]["day"]}\n取扱窓口：#{list[i]["window"]}\nです"
            if list[i]["window"] =~ /証明書/
                text += "\n\n証明書等自動発行機は\n①L校舎1階証明書発行センター内(平日：8:45~17:00)\n②L校舎2階エレベータ前(平日：8:30~19:30, 土曜：8:30~12:00)\nにあります"
            end
            message = {
                type: 'text',
                text: text
            }
            client.reply_message(event['replyToken'], message)
        end
    end
end

def reply_ques_file(event, data)      # 施設・部署の利用時間と連絡先
    xlsx = Roo::Excelx.new("info.xlsx")
    message = {
        type: 'text',
        text: "エラーです。すみません！"
    }
    for i in 2..36
        text = xlsx.cell(i, "A").to_s
        if data == text
            weekday = xlsx.cell(i, "B").to_s
            saturday = xlsx.cell(i, "C").to_s
            tel = xlsx.cell(i, "D").to_s
            where = xlsx.cell(i, "E").to_s
            
            if weekday == "" and saturday == ""
                message = {
                    type: 'text',
                    text: "#{data}\n#{where}\n\n連絡先は\n#{tel}\nです"
                }
            else
                if tel == ""
                    message = {
                        type: 'text',
                        text: "#{data}\n#{where}\n\n(利用時間)\n平日\n#{weekday}\n土曜日\n#{saturday}\nです"
                    }
                else
                    message = {
                        type: 'text',
                        text: "#{data}\n#{where}\n\n(利用時間)\n平日\n#{weekday}\n土曜日\n#{saturday}\n\n連絡先は\n#{tel}\nです"
                    }
                end
            end
        end
    end
    client.reply_message(event['replyToken'], message)
end

def reply_ques_list(event)
    xlsx = Roo::Excelx.new("info.xlsx")
    text = ""
    for i in 2..36
        if i >= 22 and i <= 31
        else
            text += "\n・#{xlsx.cell(i, "A").to_s}"
        end
    end
    message = {
        type: 'text',
        text: "施設・部署の一覧です。ひらがなで頭文字を入力すると詳細が見られます\n#{text}"
    }
    client.reply_message(event['replyToken'], message)
end

def reply_ques_answer(event, key)             # Q&AのAnswer
    # title = 〇〇関係(大分類)
    # key = キーワード(質問キーワード)
    ans = Roo::Excelx.new("answer.xlsx")
    xlsx = Roo::Excelx.new("info.xlsx")
    texts = {
        type: 'text',
        text: "エラーです。すみません！"
    }
    message = {
        type: 'text',
        text: "エラーです。すみません！"
    }

    for i in 2..51
        k = ans.cell(i,"A").to_s         # 質問キーワード
        place = ""
        if key == k
            q = ans.cell(i, "B").to_s        # 質問内容(~とき)
            place = ans.cell(i, "C").to_s    # 場所
            how = ans.cell(i, "D").to_s
            texts = {
                type: 'text',
                text: "#{q}は、#{place}#{how}"
            }
            break
        end
    end

    for i in 2..36
        data = xlsx.cell(i, "A").to_s
        if data == place
            weekday = xlsx.cell(i, "B").to_s
            saturday = xlsx.cell(i, "C").to_s
            tel = xlsx.cell(i, "D").to_s
            where = xlsx.cell(i, "E").to_s
            
            if weekday == "" and saturday == ""
                message = {
                    type: 'text',
                    text: "#{data}\n#{where}\n\n連絡先は\n#{tel}\nです"
                }
            else
                if tel == ""
                    message = {
                        type: 'text',
                        text: "#{data}\n#{where}\n\n(利用時間)\n平日\n#{weekday}\n土曜日\n#{saturday}\nです"
                    }
                else
                    message = {
                        type: 'text',
                        text: "#{data}\n#{where}\n\n(利用時間)\n平日\n#{weekday}\n土曜日\n#{saturday}\n\n連絡先は\n#{tel}\nです"
                    }
                end
            end
        end
    end
    client.reply_message(event['replyToken'], [texts, message])
end

def reply_ques_schedule
    {
        "type": "template",
        "altText": "学年暦",

        "template": {
            "type": "buttons",
            "title": "学年暦",
            "text": "2022年度の学年暦はこちらです。タップしてください",              # 質問(例：何回生ですか)

            # ポストバックアクション
            "actions": [
                "type": "uri",
                "label": "学年暦",
                "uri": "{※YOUR_URL※}"
            ]
        }
    }
end
