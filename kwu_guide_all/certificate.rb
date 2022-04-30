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
