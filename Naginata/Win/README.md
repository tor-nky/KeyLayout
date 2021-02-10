# Windows で薙刀式v13完成版 を使うスクリプト

薙刀式を Autohotkey に実装しました。

* Naginata.ahk

IME.ahk、init.ahk、KanaTable.ahk も同じディレクトリに入れておきます。

Autohotkey をインストールし、Naginata.ahk のスクリプトを実行してください。

Ahk2Exe.exe でコンパイルする場合は、Unicode版で出力してください。

## IME の設定

旧MS-IME では初期状態の設定のままでも使えますが、キー設定を行うことをおすすめします。

半角+全角	→	[入力/変換文字なし]IMEオフ, [他]半英固定

ATOK の場合はソースコードにあるコメントをご覧ください。

### 動作確認

* Windows 10 Home version 20H2 + AutoHotkey (v1.1.33.02) + 旧MS-IME あるいは ATOK 2017

## 不具合

* Edge、Chrome の送信欄に入力中に、記号を入力した後、改行される。

修正方法を検討中です。（現象としては、下の物と同じです）

* 新MS-IME で記号の多くで入力後に改行される。

KanaTable.ahk の修正が必要ですので、準備中です。

## KanaTable.ahk で使えるキーや記号の書き方

Autohotkey の書き方そのものです。
(http://ahkwiki.net/Send) の特殊キー名一覧もご覧ください。

そのまま入力	0〜9 A〜Z -^@[]./ ユニコード文字

; : ,	→	`; `: `,

{Enter} {Esc} {Space} {Tab} {BS} {Del} {Ins}
{Up} {Down} {Left} {Right}
{Home} {End} {PgUp} {PgDn}
など

## 参考

* [【薙刀式】v13完成版、発表。](http://oookaworks.seesaa.net/article/479173898.html#gsc.tab=0)

## おもな修正履歴

* 例えば「う」押す→「スペース」押す→「う」離す、でスペースが発行されていたのを修正（大岡様ありがとうございました）

* 3キー以上を限りなく同時に押すと、2文字までしか入力されないことがある、のを修正

(ここまで2021年2月9日追加)

* エクスプローラーの検索欄で、ローマ字３文字の入力が失敗するので、KanaTable.ahk のディレイを設定し直した
