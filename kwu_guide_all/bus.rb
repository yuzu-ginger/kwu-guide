def bus_date
    choice0 = "平日"              # => A
    choice1 = "土曜日"            # => B
    choice2 = "日曜日・祝日"      # => C
    {
        "type": "text",
        "text": "横にスクロールして調べたい日を選んでください",
        "quickReply": {
        "items": [
            {
                "type": "action",
                "action": {
                    "type": "postback",
                    "label": choice0,
                    "text": choice0,
                    "data": "バス,#{choice0},0" 
                }
            },
            {
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
            "type": "buttons",
            "title": "乗車",
            "text": "どのバス停から乗りますか？",              # 質問(例：何回生ですか)

            # ポストバックアクション
            "actions": [
                {
                    "type": "postback",            # 変更なし
                    "label": choice1,                # ボタン1つ目(例：1回生)
                    "displayText": choice1,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice1},乗車"                  # 上と同じ値を入れてください
                },
                {
                    "type": "postback",            # 変更なし
                    "label": choice2,                # ボタン1つ目(例：1回生)
                    "displayText": choice2,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice2},乗車"                  # 上と同じ値を入れてください
                },
                {
                    "type": "postback",            # 変更なし
                    "label": choice3,                # ボタン1つ目(例：1回生)
                    "displayText": choice3,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice3},乗車"                  # 上と同じ値を入れてください
                },
                {
                    "type": "postback",            # 変更なし
                    "label": choice4,                # ボタン1つ目(例：1回生)
                    "displayText": choice4,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice4},乗車"                  # 上と同じ値を入れてください
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
            "type": "buttons",
            "title": "行き先",
            "text": "どこ行きのバスか選んでください",              # 質問(例：何回生ですか)

            # ポストバックアクション
            "actions": [
                {
                    "type": "postback",            # 変更なし
                    "label": choice1,                # ボタン1つ目(例：1回生)
                    "displayText": choice1,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice1}"                  # 上と同じ値を入れてください
                },
                {
                    "type": "postback",            # 変更なし
                    "label": choice2,                # ボタン1つ目(例：1回生)
                    "displayText": choice2,          # ボタン1つ目(画面に表示される)(例：1回生)
                    "data": "#{data},#{choice2}"                  # 上と同じ値を入れてください
                }
            ]
        }
    }
end
