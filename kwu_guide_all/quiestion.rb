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
