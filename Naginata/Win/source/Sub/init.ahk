; Copyright 2021 Satoru NAKAYA
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;	  http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

; **********************************************************************
;	3キー同時押し配列 初期設定
; **********************************************************************

#NoEnv						; 変数名を解釈するとき、環境変数を無視する
SetBatchLines, -1			; 自動Sleepなし
ListLines, Off				; スクリプトの実行履歴を取らない
SetKeyDelay, 10, 0			; キーストローク間のディレイを変更
#MenuMaskKey vk07			; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
#UseHook					; ホットキーはすべてフックを使用する
; Process, Priority, , High	; プロセスの優先度を変更
;Thread, interrupt, 15, 6	; スレッド開始から15ミリ秒ないし1行以内の割り込みを、絶対禁止
SetStoreCapslockMode, off	; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

;SetFormat, Integer, H		; 数値演算の結果を、16進数の整数による文字列で表現する

; ----------------------------------------------------------------------
; 配列定義で使う変数
; ----------------------------------------------------------------------
; キーを64bitの各ビットに割り当てる
; 右側の数字は仮想キーコードになっている
KC_1	:= 1 << 0x02
KC_2	:= 1 << 0x03
KC_3	:= 1 << 0x04
KC_4	:= 1 << 0x05
KC_5	:= 1 << 0x06
KC_6	:= 1 << 0x07

KC_7	:= 1 << 0x08
KC_8	:= 1 << 0x09
KC_9	:= 1 << 0x0A
KC_0	:= 1 << 0x0B
KC_MINS	:= 1 << 0x0C
KC_EQL	:= 1 << 0x0D
JP_YEN	:= 1 << 0x37	; sc7D

KC_Q	:= 1 << 0x10
KC_W	:= 1 << 0x11
KC_E	:= 1 << 0x12
KC_R	:= 1 << 0x13
KC_T	:= 1 << 0x14

KC_Y	:= 1 << 0x15
KC_U	:= 1 << 0x16
KC_I	:= 1 << 0x17
KC_O	:= 1 << 0x18
KC_P	:= 1 << 0x19
KC_LBRC	:= 1 << 0x1A
KC_RBRC	:= 1 << 0x1B

KC_A	:= 1 << 0x1E
KC_S	:= 1 << 0x1F
KC_D	:= 1 << 0x20
KC_F	:= 1 << 0x21
KC_G	:= 1 << 0x22

KC_H	:= 1 << 0x23
KC_J	:= 1 << 0x24
KC_K	:= 1 << 0x25
KC_L	:= 1 << 0x26
KC_SCLN	:= 1 << 0x27
KC_QUOT	:= 1 << 0x28
KC_NUHS	:= 1 << 0x2B

KC_Z	:= 1 << 0x2C
KC_X	:= 1 << 0x2D
KC_C	:= 1 << 0x2E
KC_V	:= 1 << 0x2F
KC_B	:= 1 << 0x30

KC_N	:= 1 << 0x31
KC_M	:= 1 << 0x32
KC_COMM	:= 1 << 0x33
KC_DOT	:= 1 << 0x34
KC_SLSH	:= 1 << 0x35
KC_INT1	:= 1 << 0x38	; sc73

KC_SPC	:= 1 << 0x39

; 固有名詞定義用
KOYU_1		:= KC_U | KC_I | KC_1
KOYU_2		:= KC_U | KC_I | KC_2
KOYU_3		:= KC_U | KC_I | KC_3
KOYU_4		:= KC_U | KC_I | KC_4
KOYU_5		:= KC_U | KC_I | KC_5
KOYU_6		:= KC_E | KC_R | KC_6
KOYU_7		:= KC_E | KC_R | KC_7
KOYU_8		:= KC_E | KC_R | KC_8
KOYU_9		:= KC_E | KC_R | KC_9
KOYU_0		:= KC_E | KC_R | KC_0
KOYU_MINS	:= KC_E | KC_R | KC_MINS
KOYU_EQL	:= KC_E | KC_R | KC_EQL
KOYU_YEN	:= KC_E | KC_R | JP_YEN

KOYU_Q		:= KC_U | KC_I | KC_Q
KOYU_W		:= KC_U | KC_I | KC_W
KOYU_E		:= KC_U | KC_I | KC_E
KOYU_R		:= KC_U | KC_I | KC_R
KOYU_T		:= KC_U | KC_I | KC_T

KOYU_Y		:= KC_E | KC_R | KC_Y
KOYU_U		:= KC_E | KC_R | KC_U
KOYU_I		:= KC_E | KC_R | KC_I
KOYU_O		:= KC_E | KC_R | KC_O
KOYU_P		:= KC_E | KC_R | KC_P
KOYU_LBRC	:= KC_E | KC_R | KC_LBRC
KOYU_RBRC	:= KC_E | KC_R | KC_RBRC

KOYU_A		:= KC_U | KC_I | KC_A
KOYU_S		:= KC_U | KC_I | KC_S
KOYU_D		:= KC_U | KC_I | KC_D
KOYU_F		:= KC_U | KC_I | KC_F
KOYU_G		:= KC_U | KC_I | KC_G

KOYU_H		:= KC_E | KC_R | KC_H
KOYU_J		:= KC_E | KC_R | KC_J
KOYU_K		:= KC_E | KC_R | KC_K
KOYU_L		:= KC_E | KC_R | KC_L
KOYU_SCLN	:= KC_E | KC_R | KC_SCLN
KOYU_QUOT	:= KC_E | KC_R | KC_QUOT
KOYU_NUHS	:= KC_E | KC_R | KC_NUHS
KOYU_BSLS	:= KC_E | KC_R | KC_BSLS

KOYU_Z		:= KC_U | KC_I | KC_Z
KOYU_X		:= KC_U | KC_I | KC_X
KOYU_C		:= KC_U | KC_I | KC_C
KOYU_V		:= KC_U | KC_I | KC_V
KOYU_B		:= KC_U | KC_I | KC_B

KOYU_N		:= KC_E | KC_R | KC_N
KOYU_M		:= KC_E | KC_R | KC_M
KOYU_COMM	:= KC_E | KC_R | KC_COMM
KOYU_DOT	:= KC_E | KC_R | KC_DOT
KOYU_SLSH	:= KC_E | KC_R | KC_SLSH
KOYU_INT1	:= KC_E | KC_R | KC_INT1


; リピート定義用
R := 1


; ----------------------------------------------------------------------
; 共通変数
; ----------------------------------------------------------------------
; 入れ物の定義
Key := []			; キービットの集合
Kana := []			; かな定義
KanaYoko := []		; かな定義(横書き) ※縦書きと違う場合のみ使用
KeyGroup := []		; 定義のグループ番号 ※0はグループAll
Eisu := []			; 英数定義
EisuYoko := []		; かな定義(横書き) ※縦書きと違う場合のみ使用
Setted := []		; 0: 出力確定しない, 1: 通常シフトのみ出力確定, 2: どちらのシフトも出力確定
Repeatable := []	; 1: リピートできる

BeginTable := [1001, 20001, 300001]	; 定義の始め 1キー, 2キー同時, 3キー同時
EndTable := [1001, 20001, 300001]	; 定義の終わり+1 1キー, 2キー同時, 3キー同時

; キーボードドライバを調べて KeyDriver に格納する
; 参考: https://ixsvr.dyndns.org/blog/764
RegRead, KeyDriver, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN


; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; 何キー同時か数える
CountBit(KeyComb)
{
	global KC_SPC
;	local count, i

	KeyComb &= KC_SPC ^ (-1)	; スペースキーは数えない

	count := 0
	i := 0
	while (i < 64 && count < 3)	; 3になったら、それ以上数えない
	{
		count += KeyComb & 1
		KeyComb >>= 1
		i++
	}
	return count
}

; 縦書き用定義から横書き用に変換
ConvTateYoko(Str1)
{
	StringReplace, Str1, Str1, {Up,		{Temp,	A
	StringReplace, Str1, Str1, {Right,	{Up,	A
	StringReplace, Str1, Str1, {Down,	{Right,	A
	StringReplace, Str1, Str1, {Left,	{Down,	A
	StringReplace, Str1, Str1, {Temp,	{Left,	A

	return Str1
}

; 機能置き換え処理 - DvorakJ との互換用
StrReplace(Str1)
{
	StringReplace, Str1, Str1, {→,			{Right,		A
	StringReplace, Str1, Str1, {->,			{Right,		A
	StringReplace, Str1, Str1, {右,			{Right,		A
	StringReplace, Str1, Str1, {←,			{Left,		A
	StringReplace, Str1, Str1, {<-,			{Left,		A
	StringReplace, Str1, Str1, {左,			{Right,		A
	StringReplace, Str1, Str1, {↑,			{Up,		A
	StringReplace, Str1, Str1, {上,			{Up,		A
	StringReplace, Str1, Str1, {↓,			{Down,		A
	StringReplace, Str1, Str1, {下,			{Down,		A
	StringReplace, Str1, Str1, {ペースト},	^v,			A
	StringReplace, Str1, Str1, {貼付},		^v,			A
	StringReplace, Str1, Str1, {貼り付け},	^v,			A
	StringReplace, Str1, Str1, {カット},	^x,			A
	StringReplace, Str1, Str1, {切取},		^x,			A
	StringReplace, Str1, Str1, {切り取り},	^x,			A
	StringReplace, Str1, Str1, {コピー},	^c,			A
	StringReplace, Str1, Str1, {無変換,		{vk1D,		A
	StringReplace, Str1, Str1, {変換,		{vk1C,		A
	StringReplace, Str1, Str1, {ひらがな,	{vkF2,		A
	StringReplace, Str1, Str1, {改行,		{Enter,		A
	StringReplace, Str1, Str1, {後退,		{BS,		A
	StringReplace, Str1, Str1, {取消,		{Esc,		A
	StringReplace, Str1, Str1, {削除,		{Del,		A
	StringReplace, Str1, Str1, {全角,		{vkF3,		A
	StringReplace, Str1, Str1, {タブ,		{Tab,		A
	StringReplace, Str1, Str1, {空白		{Space,		A
	StringReplace, Str1, Str1, {メニュー,	{AppsKey,	A

	StringReplace, Str1, Str1, {Caps Lock,	{vkF0,		A
	StringReplace, Str1, Str1, {Back Space,	{BS,		A

	return Str1
}

; 文字列に必要に応じて"確定"と"切り替え"を加える
Analysis(Str1)
{
;	local i 					; カウンタ
;		, TateStr
;		, len, Str2, c, bracket
;		, ZenkakuCount			; 連続している全角文字を数える
;		, KaeCount				; 入れた"切り替え"を数える

	; Str1 の文字列に"確定"を加えながら TateStr にコピーする
	; 1文字ずつ分析する
	len := StrLen(Str1)
	TateStr := ""
	Str2 := "", len2 := 0
	bracket := 0
	ZenkakuCount := 0, KaeCount := 0
	i := 1
	while (i <= len)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket > 0)
			bracket++
		Str2 .= c, len2++
		if (i = len || !(bracket > 0 || c == "+" || c == "^" || c == "!" || c == "#"))
		{
			; ASCIIコードでない
			if (Asc(Str2) > 127
				|| SubStr(Str2, 1, 3) = "{U+"
				|| (SubStr(Str2, 1, 5) = "{ASC " && SubStr(Str2, 6, len2 - 6) > 127))			{
				if ZenkakuCount = 0		; ASCIIコード → それ以外 に変わった
					TateStr .= "{確}"	; "確定"を入れる

				; ATOK は全角空白が入力されると、文字入力中か検出できないので対策
				if (KaeCount = 0
					&& (Asc(Str2) = 0x3000 || SubStr(Str2, 1, 7) = "{U+3000"
					|| (SubStr(Str2, 1, 5) = "{ASC " && SubStr(Str2, 6, len2 - 6) > 127)))
				{
					if ZenkakuCount = 0
						TateStr .= "・{替}{BS}"
					else
						TateStr .= "{替}"
					KaeCount++
				}

				ZenkakuCount++
			}
			; ASCIIコード
			else if ZenkakuCount > 0	; ASCIIコード以外 → ASCIIコード に変わった
			{
				TateStr .= "{替}"		; "切り替え"を入れる
				ZenkakuCount := 0, KaeCount++
			}
			TateStr .= Str2
			Str2 := "", len2 := 0
		}
		i++
	}
	if ZenkakuCount > 0			; 最後の文字がASCIIコード以外
		TateStr .= "{替}"	; "切り替え"を入れる

	return TateStr
}

; かな定義登録	(定義が多すぎても警告は出ません)
SetKana(KeyComb, Str1, Repeat:=0)
{
	global Key, KeyGroup, Kana, KanaYoko, Repeatable
		, BeginTable, EndTable, Group
;	local nkeys 				; 何キー同時押しか
;		, i 					; カウンタ
;		, TateStr, YokoStr

	; 機能置き換え処理
	Str1 := StrReplace(Str1)

	; Str1 の文字列に必要に応じて"確定"を加える
	TateStr := Analysis(Str1)

	; 登録
	nkeys := CountBit(KeyComb)	; 何キー同時押しか
	i := BeginTable[nkeys]
	while (i < EndTable[nkeys])
	{
		if (Key[i] = KeyComb && Kana[i] != "")	; 定義の重複があったら、古いのを消す
		{
			Key[i] := ""
			KeyGroup[i] := ""
			Kana[i] := ""
			KanaYoko[i] := ""
			Repeatable[i] := ""
		}
		i++
	}
	if (TateStr != "")	; 定義あり
	{
;		i := EndTable[nkeys]
		Key[i] := KeyComb
		KeyGroup[i] := Group
		Kana[i] := TateStr
		YokoStr := ConvTateYoko(TateStr)	; 縦横変換
		if (YokoStr != TateStr)
			KanaYoko[i] := YokoStr
		Repeatable[i] := Repeat
		EndTable[nkeys]++
	}

	return
}

; 英数定義登録	(定義が多すぎても警告は出ません)
SetEisu(KeyComb, Str1, Repeat:=0)
{
	global Key, KeyGroup, Eisu, EisuYoko, Repeatable
		, BeginTable, EndTable, Group
;	local nkeys 				; 何キー同時押しか
;		, i 					; カウンタ
;		, TateStr, YokoStr

	; 機能置き換え処理
	Str1 := StrReplace(Str1)

	; Str1 の文字列に必要に応じて"確定"を加える
	TateStr := Analysis(Str1)

	; 登録
	nkeys := CountBit(KeyComb)	; 何キー同時押しか
	i := BeginTable[nkeys]
	while (i < EndTable[nkeys])
	{
		if (Key[i] = KeyComb && Eisu[i] != "")	; 定義の重複があったら、古いのを消す
		{
			Key[i] := ""
			KeyGroup[i] := ""
			Eisu[i] := ""
			EisuYoko[i] := ""
			Repeatable[i] := ""
		}
		i++
	}
	if (TateStr != "")	; 定義あり
	{
;		i := EndTable[nkeys]
		Key[i] := KeyComb
		KeyGroup[i] := Group
		Eisu[i] := TateStr
		YokoStr := ConvTateYoko(TateStr)	; 縦横変換
		if (YokoStr != TateStr)
			EisuYoko[i] := YokoStr
		Repeatable[i] := Repeat
		EndTable[nkeys]++
	}

	return
}

; 出力確定するかな定義を調べて Setted[] に記録
; 0: 確定しない, 1: 通常シフトのみ確定, 2: 後置シフトでも確定
KanaSetting()
{
	global Key, Kana, Setted
		, BeginTable, EndTable
;	local i, j, flag	; カウンタ

	; 3キー同時押し
	i := BeginTable[3]
	while (i < EndTable[3])
	{
		if (Kana[i] != "")
		{
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (i != j && Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
					break	; 後置シフトは出力確定しない
				j++
			}
			Setted[i] := (j >= EndTable[3]) ? 2 : 1
		}
		i++
	}

	; 2キー同時押し
	i := BeginTable[2]
	while (i < EndTable[2])
	{
		if (Kana[i] != "")
		{
			flag := 0
			; 3キー同時押しで使われているキーは出力が確定しない
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
				{
					; シフトも一致
					if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
					{
						flag := 0
						break		; 出力確定しない
					}
					else
						flag := 1	; 後置シフトは出力確定しない
				}
				j++
			}
			if (j >= EndTable[3] && flag = 0)
			{
				j := BeginTable[2]
				while (j < EndTable[2])
				{
					; Key[i] は Key[j] に内包されているか
					if (i != j && Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
					{
						flag := 1
						break	; 後置シフトは出力確定しない
					}
					j++
				}
				; 検索してもなかった
				if (j >= BeginTable[2])
					Setted[i] := 2	; どちらのシフトも出力確定
			}
			if flag > 0
				Setted[i] := 1	; 通常シフトのみ出力確定
		}
		i++
	}

	; 1キー押し
	i := BeginTable[1]
	while (i < EndTable[1])
	{
		if (Kana[i] != "")
		{
			flag := 0
			; 3キー同時押しで使われているキーは出力が確定しない
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
				{
					; シフトも一致
					if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
					{
						flag := 0
						break		; 出力確定しない
					}
					else
						flag := 1	; 後置シフトは出力確定しない
				}
				j++
			}
			if (j >= EndTable[3])
			{
				; 2キー同時押しで使われているキーは出力が確定しない
				j := BeginTable[2]
				while (j < EndTable[2])
				{
					; Key[i] は Key[j] に内包されているか
					if (Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
					{
						; シフトも一致
						if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
						{
							flag := 0
							break		; 出力確定しない
						}
						else
							flag := 1	; 後置シフトは出力確定しない
					}
					j++
				}
				if (j >= EndTable[2] && flag = 0)
				{
					j := BeginTable[1]
					while (j < EndTable[1])
					{
						; Key[i] は Key[j] に内包されているか
						if (i != j && Kana[j] != "" && (Key[i] & Key[j]) = Key[i])
						{
							flag := 1
							break	; 後置シフトは出力確定しない
						}
						j++
					}
					; 検索してもなかった
					if (j >= BeginTable[1])
						Setted[i] := 2	; どちらのシフトも出力確定
				}
			}
			if flag > 0
				Setted[i] := 1	; 通常シフトのみ出力確定
		}
		i++
	}

	return
}

; 出力確定する英数定義を調べて Setted[] に記録
; 0: 確定しない, 1: 通常シフトのみ確定, 2: 後置シフトでも確定
EisuSetting()
{
	global Key, Eisu, Setted
		, BeginTable, EndTable
;	local i, j, flag	; カウンタ

	; 3キー同時押し
	i := BeginTable[3]
	while (i < EndTable[3])
	{
		if (Eisu[i] != "")
		{
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (i != j && Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
					break	; 後置シフトは出力確定しない
				j++
			}
			Setted[i] := (j >= EndTable[3]) ? 2 : 1
		}
		i++
	}

	; 2キー同時押し
	i := BeginTable[2]
	while (i < EndTable[2])
	{
		if (Eisu[i] != "")
		{
			flag := 0
			; 3キー同時押しで使われているキーは出力が確定しない
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
				{
					; シフトも一致
					if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
					{
						flag := 0
						break		; 出力確定しない
					}
					else
						flag := 1	; 後置シフトは出力確定しない
				}
				j++
			}
			if (j >= EndTable[3] && flag = 0)
			{
				j := BeginTable[2]
				while (j < EndTable[2])
				{
					; Key[i] は Key[j] に内包されているか
					if (i != j && Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
					{
						flag := 1
						break	; 後置シフトは出力確定しない
					}
					j++
				}
				; 検索してもなかった
				if (j >= BeginTable[2])
					Setted[i] := 2	; どちらのシフトも出力確定
			}
			if flag > 0
				Setted[i] := 1	; 通常シフトのみ出力確定
		}
		i++
	}

	; 1キー押し
	i := BeginTable[1]
	while (i < EndTable[1])
	{
		if (Eisu[i] != "")
		{
			flag := 0
			; 3キー同時押しで使われているキーは出力が確定しない
			j := BeginTable[3]
			while (j < EndTable[3])
			{
				; Key[i] は Key[j] に内包されているか
				if (Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
				{
					; シフトも一致
					if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
					{
						flag := 0
						break		; 出力確定しない
					}
					else
						flag := 1	; 後置シフトは出力確定しない
				}
				j++
			}
			if (j >= EndTable[3])
			{
				; 2キー同時押しで使われているキーは出力が確定しない
				j := BeginTable[2]
				while (j < EndTable[2])
				{
					; Key[i] は Key[j] に内包されているか
					if (Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
					{
						; シフトも一致
						if ((Key[i] & KC_SPC) = (Key[j] & KC_SPC))
						{
							flag := 0
							break		; 出力確定しない
						}
						else
							flag := 1	; 後置シフトは出力確定しない
					}
					j++
				}
				if (j >= EndTable[2] && flag = 0)
				{
					j := BeginTable[1]
					while (j < EndTable[1])
					{
						; Key[i] は Key[j] に内包されているか
						if (i != j && Eisu[j] != "" && (Key[i] & Key[j]) = Key[i])
						{
							flag := 1
							break	; 後置シフトは出力確定しない
						}
						j++
					}
					; 検索してもなかった
					if (j >= BeginTable[1])
						Setted[i] := 2	; どちらのシフトも出力確定
				}
			}
			if flag > 0
				Setted[i] := 1	; 通常シフトのみ出力確定
		}
		i++
	}

	return
}
