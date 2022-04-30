# kwu-guide
## Introduction
京都女子大学非公式LINEbot「京女ガイド」のソースコードです。<br>
一部共有していないデータがあります。ご了承ください。<br>
※共有していない部分の場所については各ディレクトリ内にあるREADME.mdファイルに詳しく説明しています。
## Code
- [サンプルボット](https://github.com/yuzu-ginger/kwu-guide/tree/main/sample)
- [京女ガイド(完成形)](https://github.com/yuzu-ginger/kwu-guide/tree/main/kwu_guide_all)
- [京女ガイドメニュー1(京女ポータル/図書館HP)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu1)
- [京女ガイドメニュー2(バス時刻表検索)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu2)
- [京女ガイドメニュー3(空き教室検索)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu3)
- [京女ガイドメニュー4(キャンパスマップ)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu4)
- [京女ガイドメニュー5(各種証明書/Q&A)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu5)
- [京女ガイドメニュー6(意見箱/使い方)](https://github.com/yuzu-ginger/kwu-guide/tree/main/menu6)
## Usage
4つのファイルをフォルダの中に作成します
- Gemfile
- Procfile
- config.rb
- app.rb
<br>
中身はコードをコピーしてください
<br>
次に、ターミナルで次のコマンドを実行します。

```
bundle install
```

これを実行すると、Gemfile.lockファイルが作成されると同時に必要なライブラリがインストールされます。
あとはHerokuとLINEbotのアカウントの作成ですが、それについては以下のページの記事を参考にしてください。<br>
[Ruby, Sinatra, HerokuでLINEbotを動かしてみた --Qiita](https://qiita.com/Yuzu_Ginger/items/18edc58bd039fc19ad53)
