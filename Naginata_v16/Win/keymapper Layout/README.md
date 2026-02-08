# 薙刀式v16快速版
 [keymapper 5.3.2以降](https://github.com/houmain/keymapper)用の __Windows版専用__ の設定ファイルです。
 @deepprog氏の[keymapper 薙刀式の設定](https://qiita.com/deepprog/items/4d18a8cc4ab628ee9fb9)を編集して作りました。

IMEのキー設定は不要です。(Windows 11標準のMS-IMEにも対応)
## 使用法
設定ファイル `keymapper.conf` を `C:\Users\ユーザー名` に置きます。

ポータブル版を使う場合は、ZIPファイルを解凍後に `keymapper.exe` と `keymapperd.exe` の2つを実行します。
さらに keymapper.exe のショートカットを作成し、そのプロパティ内のリンク先を `%パス名%\keymapper.exe -c %パス名%\Naginata_v16.conf` などと書き換えて実行することもできます。

記号入力が文字化けになったら、`keymapper.conf` のエンコードが UTF-8 でBOMなし になっているか確認してください。
## 「固有名詞ショートカット」について
429～458行目あたりに登録場所があります。

行頭の # を消し、文字列を " " でくくられた部分に固有名詞を書きます。

例：UI+W を使う
```
  (U I W) >> ime_pause "天空のファルコーン" ime_resume ^
```
「Reload」すると固有名詞ショートカットが使えるようになります。
## 仕様
* かな入力時に「左右シフト+アルファベット」を押すと、大文字入力と同時にIMEオフになります。
MS-IME限定ですが、左右シフト+アルファベット で全角英数モードにする方法
```
  Shift{A} >> !Shift ime_complete Shift{NonConvert A} !IMEState ^
```
なお、エンターを押してもかなモード戻りません。
* かな入力中の記号入力では `Slash Enter Backspace` を入力しているので、アンドゥをすると「・」が見える。
* かなはひらがな入力、英数は半角入力でなければならない。
* Windows 11 のメモ帳では編集モードがうまく動かないことがあります。
## 薙刀式とは
【薙刀式】v16快速版発表
http://oookaworks.seesaa.net/article/509198141.html#gsc.tab=0
