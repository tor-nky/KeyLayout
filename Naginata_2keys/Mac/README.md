# Mac を 薙刀式 2キー同時版 に対応するスクプリト

## 薙刀式 2キー同時版 とは

[【薙刀式】2キー同時版の提案](http://oookaworks.seesaa.net/article/479308905.html#gsc.tab=0)をご覧ください。

# 使い方

Karabiner-Elements で動作します。

* Naginata_2keys.json をフォルダ ~/.config/karabiner/assets/complex_modifications にコピーします。
* Karabiner-Elements の Preferences を開き、Complex modifications 画面の下の方にある Add rule を押す。
* スクリプトを選び、+Enable を押す。

JISキーボードにもUSキーボードにも対応しています。

(インストール後サイズ: 273KB)

## 仕様

* 小書き、外来音、半濁拗音の入力を、特殊キー(Q)との同時押しではなく、通常シフトに設定しています。
従って、Qを押しながら、他のキーを押してください。

* 特殊キー(Q)の単独押し離しは、中点「・」に当てています。
* 同時押しは50ミリ秒以内(Karabiner-Elementsの設定による)に押します。

英数入力時もSandSを使いたい場合は、Change spacebar to left_shift. (Post spacebar if pressed alone)
などの他のスクリプトを登録してください。

## おもな修正履歴

* 英数入力時も改行(V+M)をできるようにした

(ここまで2021年3月3日追加)
