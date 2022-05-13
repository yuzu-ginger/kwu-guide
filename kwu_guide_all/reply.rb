#reply.rb
# 返信用メソッド

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
    choice[0][0] = "#{url}{※YOUR_URL※}"
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
    images = {
        type: 'text',
        text: "エラーです。すみません！"
    }

    for i in 0..2           # 日にち
        if i == array[2]
            for j in 0..4   # 固定(方向)
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

    
    #if array[2] == 2
    #    images = {
    #        type: 'text',
    #        text: "ただいま準備中です"
    #    }
    #end
    

    client.reply_message(event['replyToken'], [message, images])
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

def reply_opinion
    {
        "type": "template",
        "altText": "意見箱",

        "template": {
            "type": "buttons",
            "title": "フォーム",
            "text": "こちらのフォームから回答してください",              # 質問(例：何回生ですか)

            # ポストバックアクション
            "actions": [
                {
                    "type": "uri",
                    "label": "意見箱",
                    "uri": "{※YOUR_URL※}"
                },
                {
                    "type": "uri",
                    "label": "評価アンケート",
                    "uri": "{※YOUR_URL※}"
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
