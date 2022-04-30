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
