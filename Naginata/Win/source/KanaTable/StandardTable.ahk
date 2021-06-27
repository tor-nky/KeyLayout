﻿; **********************************************************************
; キーボード初期配列
; **********************************************************************

; ----------------------------------------------------------------------
; 英数／かな配列の定義ファイル 【すべて縦書き用で書くこと】
;
; 例：	SetKana( KC_Q | KC_L | KC_SPC		,"xwa"	, R)	; (ゎ)
;		~~~~~~~  ~~~~~~~~~~~~~~~~~~~~		  ~~~	  ~ 	  ~~~~
;		かな定義	スペース+Q+L		 変換後の出力 ↑	コメント
;													  ｜
			;						リピートあり(省略はリピートなし)
;
; 例：	 SetEisu( KC_H | KC_J			,"{vkF2 2}" )		; IME ON
;		 ~~~~~~~
;		 英数定義
;
;	※再読み込みか、再起動で有効になります
;	※全角空白の違いが見えるエディタを使うことをおすすめします
;	※UTF-8(BOM付)で保存してください
;	※順序はグループ内で自由です。同じキーの組み合わせは、後の方が有効になります。
; ----------------------------------------------------------------------


; ここからはすべてグループなし
Group := 0	; 0 はグループAll

; 1キー
	SetEisu( KC_1		,"{sc02}"	)
	SetEisu( KC_2		,"{sc03}"	)
	SetEisu( KC_3		,"{sc04}"	)
	SetEisu( KC_4		,"{sc05}"	)
	SetEisu( KC_5		,"{sc06}"	)
	SetEisu( KC_6		,"{sc07}"	)

	SetEisu( KC_7		,"{sc08}"	)
	SetEisu( KC_8		,"{sc09}"	)
	SetEisu( KC_9		,"{sc0A}"	)
	SetEisu( KC_0		,"{sc0B}"	)
	SetEisu( KC_MINS	,"{sc0C}"	)
	SetEisu( KC_EQL		,"{sc0D}"	)
	SetEisu( JP_YEN		,"\"		)

	SetEisu( KC_Q		,"{sc10}"	)
	SetEisu( KC_W		,"{sc11}"	)
	SetEisu( KC_E		,"{sc12}"	)
	SetEisu( KC_R		,"{sc13}"	)
	SetEisu( KC_T		,"{sc14}"	)

	SetEisu( KC_Y		,"{sc15}"	)
	SetEisu( KC_U		,"{sc16}"	)
	SetEisu( KC_I		,"{sc17}"	)
	SetEisu( KC_O		,"{sc18}"	)
	SetEisu( KC_P		,"{sc19}"	)
	SetEisu( KC_LBRC	,"{sc1A}"	)
	SetEisu( KC_RBRC	,"{sc1B}"	)

	SetEisu( KC_A		,"{sc1E}"	)
	SetEisu( KC_S		,"{sc1F}"	)
	SetEisu( KC_D		,"{sc20}"	)
	SetEisu( KC_F		,"{sc21}"	)
	SetEisu( KC_G		,"{sc22}"	)

	SetEisu( KC_H		,"{sc23}"	)
	SetEisu( KC_J		,"{sc24}"	)
	SetEisu( KC_K		,"{sc25}"	)
	SetEisu( KC_L		,"{sc26}"	)
	SetEisu( KC_SCLN	,"{sc27}"	)
	SetEisu( KC_QUOT	,"{sc28}"	)
	SetEisu( KC_NUHS	,"{sc2B}"	)

	SetEisu( KC_Z		,"{sc2C}"	)
	SetEisu( KC_X		,"{sc2D}"	)
	SetEisu( KC_C		,"{sc2E}"	)
	SetEisu( KC_V		,"{sc2F}"	)
	SetEisu( KC_B		,"{sc30}"	)

	SetEisu( KC_N		,"{sc31}"	)
	SetEisu( KC_M		,"{sc32}"	)
	SetEisu( KC_COMM	,"{sc33}"	)
	SetEisu( KC_DOT 	,"{sc34}"	)
	SetEisu( KC_SLSH	,"{sc35}"	)
	SetEisu( KC_INT1	,"\"		)

	SetEisu( KC_1 | KC_SPC		,"+{sc02}"	)
	SetEisu( KC_2 | KC_SPC		,"+{sc03}"	)
	SetEisu( KC_3 | KC_SPC		,"+{sc04}"	)
	SetEisu( KC_4 | KC_SPC		,"+{sc05}"	)
	SetEisu( KC_5 | KC_SPC		,"+{sc06}"	)
	SetEisu( KC_6 | KC_SPC		,"+{sc07}"	)

	SetEisu( KC_7 | KC_SPC		,"+{sc08}"	)
	SetEisu( KC_8 | KC_SPC		,"+{sc09}"	)
	SetEisu( KC_9 | KC_SPC		,"+{sc0A}"	)
	SetEisu( KC_0 | KC_SPC		,"+{sc0B}"	)
	SetEisu( KC_MINS | KC_SPC	,"+{sc0C}"	)
	SetEisu( KC_EQL | KC_SPC	,"+{sc0D}"	)
	SetEisu( JP_YEN | KC_SPC	,"|"		)

	SetEisu( KC_Q | KC_SPC		,"+{sc10}"	)
	SetEisu( KC_W | KC_SPC		,"+{sc11}"	)
	SetEisu( KC_E | KC_SPC		,"+{sc12}"	)
	SetEisu( KC_R | KC_SPC		,"+{sc13}"	)
	SetEisu( KC_T | KC_SPC		,"+{sc14}"	)

	SetEisu( KC_Y | KC_SPC		,"+{sc15}"	)
	SetEisu( KC_U | KC_SPC		,"+{sc16}"	)
	SetEisu( KC_I | KC_SPC		,"+{sc17}"	)
	SetEisu( KC_O | KC_SPC		,"+{sc18}"	)
	SetEisu( KC_P | KC_SPC		,"+{sc19}"	)
	SetEisu( KC_LBRC | KC_SPC	,"+{sc1A}"	)
	SetEisu( KC_RBRC | KC_SPC	,"+{sc1B}"	)

	SetEisu( KC_A | KC_SPC		,"+{sc1E}"	)
	SetEisu( KC_S | KC_SPC		,"+{sc1F}"	)
	SetEisu( KC_D | KC_SPC		,"+{sc20}"	)
	SetEisu( KC_F | KC_SPC		,"+{sc21}"	)
	SetEisu( KC_G | KC_SPC		,"+{sc22}"	)

	SetEisu( KC_H | KC_SPC		,"+{sc23}"	)
	SetEisu( KC_J | KC_SPC		,"+{sc24}"	)
	SetEisu( KC_K | KC_SPC		,"+{sc25}"	)
	SetEisu( KC_L | KC_SPC		,"+{sc26}"	)
	SetEisu( KC_SCLN | KC_SPC	,"+{sc27}"	)
	SetEisu( KC_QUOT | KC_SPC	,"+{sc28}"	)
	SetEisu( KC_NUHS | KC_SPC	,"+{sc2B}"	)

	SetEisu( KC_Z | KC_SPC		,"+{sc2C}"	)
	SetEisu( KC_X | KC_SPC		,"+{sc2D}"	)
	SetEisu( KC_C | KC_SPC		,"+{sc2E}"	)
	SetEisu( KC_V | KC_SPC		,"+{sc2F}"	)
	SetEisu( KC_B | KC_SPC		,"+{sc30}"	)

	SetEisu( KC_N | KC_SPC		,"+{sc31}"	)
	SetEisu( KC_M | KC_SPC		,"+{sc32}"	)
	SetEisu( KC_COMM | KC_SPC	,"+{sc33}"	)
	SetEisu( KC_DOT | KC_SPC	,"+{sc34}"	)
	SetEisu( KC_SLSH | KC_SPC	,"+{sc35}"	)
	SetEisu( KC_INT1 | KC_SPC	,"_"		)


	SetKana( KC_1		,"{sc02}"	)
	SetKana( KC_2		,"{sc03}"	)
	SetKana( KC_3		,"{sc04}"	)
	SetKana( KC_4		,"{sc05}"	)
	SetKana( KC_5		,"{sc06}"	)
	SetKana( KC_6		,"{sc07}"	)

	SetKana( KC_7		,"{sc08}"	)
	SetKana( KC_8		,"{sc09}"	)
	SetKana( KC_9		,"{sc0A}"	)
	SetKana( KC_0		,"{sc0B}"	)
	SetKana( KC_MINS	,"{sc0C}"	)
	SetKana( KC_EQL		,"{sc0D}"	)
	SetKana( JP_YEN		,"\"		)

	SetKana( KC_Q		,"{sc10}"	)
	SetKana( KC_W		,"{sc11}"	)
	SetKana( KC_E		,"{sc12}"	)
	SetKana( KC_R		,"{sc13}"	)
	SetKana( KC_T		,"{sc14}"	)

	SetKana( KC_Y		,"{sc15}"	)
	SetKana( KC_U		,"{sc16}"	)
	SetKana( KC_I		,"{sc17}"	)
	SetKana( KC_O		,"{sc18}"	)
	SetKana( KC_P		,"{sc19}"	)
	SetKana( KC_LBRC	,"{sc1A}"	)
	SetKana( KC_RBRC	,"{sc1B}"	)

	SetKana( KC_A		,"{sc1E}"	)
	SetKana( KC_S		,"{sc1F}"	)
	SetKana( KC_D		,"{sc20}"	)
	SetKana( KC_F		,"{sc21}"	)
	SetKana( KC_G		,"{sc22}"	)

	SetKana( KC_H		,"{sc23}"	)
	SetKana( KC_J		,"{sc24}"	)
	SetKana( KC_K		,"{sc25}"	)
	SetKana( KC_L		,"{sc26}"	)
	SetKana( KC_SCLN	,"{sc27}"	)
	SetKana( KC_QUOT	,"{sc28}"	)
	SetKana( KC_NUHS	,"{sc2B}"	)

	SetKana( KC_Z		,"{sc2C}"	)
	SetKana( KC_X		,"{sc2D}"	)
	SetKana( KC_C		,"{sc2E}"	)
	SetKana( KC_V		,"{sc2F}"	)
	SetKana( KC_B		,"{sc30}"	)

	SetKana( KC_N		,"{sc31}"	)
	SetKana( KC_M		,"{sc32}"	)
	SetKana( KC_COMM	,"{sc33}"	)
	SetKana( KC_DOT 	,"{sc34}"	)
	SetKana( KC_SLSH	,"{sc35}"	)
	SetKana( KC_INT1	,"\"		)

	SetKana( KC_1 | KC_SPC		,"+{sc02}"	)
	SetKana( KC_2 | KC_SPC		,"+{sc03}"	)
	SetKana( KC_3 | KC_SPC		,"+{sc04}"	)
	SetKana( KC_4 | KC_SPC		,"+{sc05}"	)
	SetKana( KC_5 | KC_SPC		,"+{sc06}"	)
	SetKana( KC_6 | KC_SPC		,"+{sc07}"	)

	SetKana( KC_7 | KC_SPC		,"+{sc08}"	)
	SetKana( KC_8 | KC_SPC		,"+{sc09}"	)
	SetKana( KC_9 | KC_SPC		,"+{sc0A}"	)
	SetKana( KC_0 | KC_SPC		,"+{sc0B}"	)
	SetKana( KC_MINS | KC_SPC	,"+{sc0C}"	)
	SetKana( KC_EQL | KC_SPC	,"+{sc0D}"	)
	SetKana( JP_YEN | KC_SPC	,"|"		)

	SetKana( KC_Q | KC_SPC		,"+{sc10}"	)
	SetKana( KC_W | KC_SPC		,"+{sc11}"	)
	SetKana( KC_E | KC_SPC		,"+{sc12}"	)
	SetKana( KC_R | KC_SPC		,"+{sc13}"	)
	SetKana( KC_T | KC_SPC		,"+{sc14}"	)

	SetKana( KC_Y | KC_SPC		,"+{sc15}"	)
	SetKana( KC_U | KC_SPC		,"+{sc16}"	)
	SetKana( KC_I | KC_SPC		,"+{sc17}"	)
	SetKana( KC_O | KC_SPC		,"+{sc18}"	)
	SetKana( KC_P | KC_SPC		,"+{sc19}"	)
	SetKana( KC_LBRC | KC_SPC	,"+{sc1A}"	)
	SetKana( KC_RBRC | KC_SPC	,"+{sc1B}"	)

	SetKana( KC_A | KC_SPC		,"+{sc1E}"	)
	SetKana( KC_S | KC_SPC		,"+{sc1F}"	)
	SetKana( KC_D | KC_SPC		,"+{sc20}"	)
	SetKana( KC_F | KC_SPC		,"+{sc21}"	)
	SetKana( KC_G | KC_SPC		,"+{sc22}"	)

	SetKana( KC_H | KC_SPC		,"+{sc23}"	)
	SetKana( KC_J | KC_SPC		,"+{sc24}"	)
	SetKana( KC_K | KC_SPC		,"+{sc25}"	)
	SetKana( KC_L | KC_SPC		,"+{sc26}"	)
	SetKana( KC_SCLN | KC_SPC	,"+{sc27}"	)
	SetKana( KC_QUOT | KC_SPC	,"+{sc28}"	)
	SetKana( KC_NUHS | KC_SPC	,"+{sc2B}"	)

	SetKana( KC_Z | KC_SPC		,"+{sc2C}"	)
	SetKana( KC_X | KC_SPC		,"+{sc2D}"	)
	SetKana( KC_C | KC_SPC		,"+{sc2E}"	)
	SetKana( KC_V | KC_SPC		,"+{sc2F}"	)
	SetKana( KC_B | KC_SPC		,"+{sc30}"	)

	SetKana( KC_N | KC_SPC		,"+{sc31}"	)
	SetKana( KC_M | KC_SPC		,"+{sc32}"	)
	SetKana( KC_COMM | KC_SPC	,"+{sc33}"	)
	SetKana( KC_DOT | KC_SPC	,"+{sc34}"	)
	SetKana( KC_SLSH | KC_SPC	,"+{sc35}"	)
	SetKana( KC_INT1 | KC_SPC	,"_"		)

; スペースキーの定義は不要


; ----------------------------------------------------------------------
; 設定がUSキーボードの場合	参考: https://ixsvr.dyndns.org/blog/764
; ----------------------------------------------------------------------
if (KeyDriver == "kbd101.dll")
{
	SetEisu( KC_GRV				,"{sc29}"	)
	SetEisu( KC_GRV | KC_SPC	,"+{sc29}"	)

	SetKana( KC_GRV				,"{sc29}"	)
	SetKana( KC_GRV | KC_SPC	,"+{sc29}"	)
}
