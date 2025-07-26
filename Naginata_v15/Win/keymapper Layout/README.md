# 薙刀式 v15fix版 (横書き用)
 [keymapper](https://github.com/houmain/keymapper)の __Windows版専用__ の設定ファイルです。
 @deepprog氏の[keymapper 薙刀式の設定](https://qiita.com/deepprog/items/4d18a8cc4ab628ee9fb9)を編集して作りました。

IMEのキー設定を利用しますので、__新MS-IMEでは使えません__。
__JISキーボード__（日本語配列キーボード）でご使用ください。
## 使用法
設定ファイル `keymapper.conf` を `C:\Users\ユーザー名` に置きます。

ポータブル版を使う場合は、ZIPファイルを解凍後に `keymapper.exe` と `keymapperd.exe` の2つを実行します。

記号入力が文字化けしたら、`keymapper.conf` のエンコードを UTF-8 でBOMなし になっているか確認してください。
## IMEのキー設定
|* キー|入力/変換済み文字なし|他|
|---|:---:|:---:|
|Ctrl+Shift+無変換| - |全消去|
|Ctrl+Shift+変換  | - |全確定|
## 仕様
* かな入力時に「左右シフト+アルファベット」を押すと、大文字入力と同時にIMEオフになります。
* Windows 11 のメモ帳では編集モードがうまく動かないことがあります。
## 薙刀式とは
【薙刀式】v15fix版、発表
http://oookaworks.seesaa.net/article/500180437.html#gsc.tab=0
