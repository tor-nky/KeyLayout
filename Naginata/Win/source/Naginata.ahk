; **********************************************************************
; 106日本語キーボード用
; 薙刀式配列
;		ローマ字入力モード
;	※MS-IME は初期設定のままでも使えます
;	※ATOK を使う場合のキー設定
;		Ctrl+Enter	→ Enter と同じにする
;		変換		→ [文字未入力]再変換
;		ひらがな	→ 入力文字種全角ひらがな(あ)
;		カタカナ	→ 入力文字種全角カタカナ(ア)
;		半角／全角	→ [文字未入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)
; **********************************************************************
; --------〈起動処理１〉------------------------------------------------
SetWorkingDir %A_ScriptDir%		; スクリプトの作業ディレクトリを変更	;
#SingleInstance force			; 既存のプロセスを終了して実行開始		;
#Include Sub/init.ahk			; 初期設定								;
#Include KanaTable/NaginataTable.ahk	; かな定義の読み込み			;
; ----------------------------------------------------------------------

; ★★★★★★★★★★★★★★★★★★★★★
; ★★★ 通常シフト、後置シフトの設定 ★★★
; ★★★★★★★★★★★★★★★★★★★★★

ShiftDelay := 0		; 0: 通常シフト, >1: 後置シフトの待ち時間(ミリ秒)


; ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
; ☆☆☆ 固有名詞ショートカット				☆☆☆
; ☆☆☆	上段人差指＋中指				☆☆☆
; ☆☆☆		書き方: ""の中に入力します	☆☆☆
; ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆

Group := 1	; 左手側
	SetKana(KOYU_1		,"")
	SetKana(KOYU_2		,"")
	SetKana(KOYU_3		,"")
	SetKana(KOYU_4		,"")
	SetKana(KOYU_5		,"")

	SetKana(KOYU_Q		,"臨兵闘者皆陣烈在前")
	SetKana(KOYU_W		,"ネムカケ")
	SetKana(KOYU_E		,"天狗")
	SetKana(KOYU_R		,"シンイチ")
	SetKana(KOYU_T		,"")

	SetKana(KOYU_A		,"")
	SetKana(KOYU_S		,"")
	SetKana(KOYU_D		,"")
	SetKana(KOYU_F		,"心の闇")
	SetKana(KOYU_G		,"")

	SetKana(KOYU_Z		,"火よ、在れ")
	SetKana(KOYU_X		,"火の剣")
	SetKana(KOYU_C		,"小鴉")
	SetKana(KOYU_V		,"光太郎")
	SetKana(KOYU_B		,"峯")

Group := 2	; 右手側
	SetKana(KOYU_6		,"")
	SetKana(KOYU_7		,"")
	SetKana(KOYU_8		,"")
	SetKana(KOYU_9		,"")
	SetKana(KOYU_0		,"")
	SetKana(KOYU_MINS	,"")
	SetKana(KOYU_EQL	,"")
	SetKana(KOYU_YEN	,"")

	SetKana(KOYU_Y		,"才一")
	SetKana(KOYU_U		,"さくら")
	SetKana(KOYU_I		,"妖怪")
	SetKana(KOYU_O		,"")
	SetKana(KOYU_P		,"")
	SetKana(KOYU_LBRC	,"")
	SetKana(KOYU_RBRC	,"")

	SetKana(KOYU_H		,"鞍馬")
	SetKana(KOYU_J		,"青鬼")
	SetKana(KOYU_K		,"")
	SetKana(KOYU_L		,"")
	SetKana(KOYU_SCLN	,"")
	SetKana(KOYU_QUOT	,"")
	SetKana(KOYU_NUHS	,"")
	SetKana(KOYU_BSLS	,"")

	SetKana(KOYU_N		,"鬼塚")
	SetKana(KOYU_M		,"")
	SetKana(KOYU_COMM	,"")
	SetKana(KOYU_DOT	,"不動金縛りの術")
	SetKana(KOYU_SLSH	,"")
	SetKana(KOYU_INT1	,"")


; --------〈起動処理２〉------------------------------------------------
	KanaSetting()	; 出力確定するかな定義に印をつける					;
	EisuSetting()	; 出力確定する英数定義に印をつける					;
; --------〈変換〉------------------------------------------------------
#Include Sub/IME.ahk	; Author: eamat. http://www6.atwiki.jp/eamat/	;
#Include Sub/Conv.ahk													;
; ----------------------------------------------------------------------
