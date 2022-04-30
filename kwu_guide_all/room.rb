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
