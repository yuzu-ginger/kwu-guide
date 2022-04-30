def richmenu_url
  choice1 = "京女ポータル"
  choice2 = "図書館HP"
  choice3 = "蔵書検索(OPAC)"
  choice4 = "My Library"
  {
      "type": "template",
      "altText": "リッチメニューURL",

      "template": {
          "type": "buttons",
          "title": "ウェブページを開きます",
          "text": "選んでください",

          # ポストバックアクション
          "actions": [
              {
                  "type": "uri",
                  "label": choice1,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice2,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice3,
                  "uri": "{※YOUR_URL※}"
              },
              {
                  "type": "uri",
                  "label": choice4,
                  "uri": "{※YOUR_URL※}"
              }
          ]
      }
  }
end

def richmenu_qa
  choice1 = "各種証明書"
  choice2 = "Q&A"
  {
      "type": "template",
      "altText": "リッチメニューURL",

      "template": {
          "type": "buttons",
          "title": "choice",
          "text": "どちらか選んでください",

          # ポストバックアクション
          "actions": [
              {
                  "type": "postback",
                  "label": choice1,
                  "displayText": choice1,
                  "data": "#{choice1}"
              },
              {
                  "type": "postback",
                  "label": choice2,
                  "displayText": choice2,
                  "data": "#{choice2}"
              }
          ]
      }
  }
end

def richmenu_box
    choice1 = "意見箱"
    choice2 = "使い方"
    {
        "type": "template",
        "altText": "意見箱使い方",
  
        "template": {
            "type": "buttons",
            "title": "choice",
            "text": "どちらか選んでください",
  
            # ポストバックアクション
            "actions": [
                {
                    "type": "postback",
                    "label": choice1,
                    "displayText": choice1,
                    "data": "#{choice1}"
                },
                {
                    "type": "uri",
                    "label": choice2,
                    "uri": "{※YOUR_URL※}"
                }
            ]
        }
    }
end
