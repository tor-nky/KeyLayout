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
;	3キー同時押し配列 メインルーチン
; **********************************************************************


; ----------------------------------------------------------------------
; 本ファイルのみで使う変数
; ----------------------------------------------------------------------
; グローバル変数
KanaMode := 0	; 0: 英数入力, 1: かな入力
Vertical := 1	; 0: 横書き用, 1: 縦書き用
; 入力バッファ
InBuf := []
InBufTime := []	; 入力の時間
InBufRead := 0	; 読み出し位置
InBufWrite := 0	; 書き込み位置
InBufRest := 15
; 仮出力バッファ
OutStr := []
_usc := 0		; 保存されている文字数

; ----------------------------------------------------------------------
; タイマー関数、設定
; ----------------------------------------------------------------------

; 参照: https://www.autohotkey.com/boards/viewtopic.php?t=4667
WinAPI_timeGetTime()	; http://msdn.microsoft.com/en-us/library/dd757629.aspx
{
	return DllCall("Winmm.dll\timeGetTime", "UInt")
}
WinAPI_timeBeginPeriod(uPeriod)	; http://msdn.microsoft.com/en-us/library/dd757624.aspx
{
	return DllCall("Winmm.dll\timeBeginPeriod", "UInt", uPeriod, "UInt")
}
WinAPI_timeEndPeriod(uPeriod)	; http://msdn.microsoft.com/en-us/library/dd757626.aspx
{
	return DllCall("Winmm.dll\timeEndPeriod", "UInt", uPeriod, "UInt")
}

; タイマーの精度を調整
if (ShiftDelay)		; 後置シフトあり
	WinAPI_timeBeginPeriod(1)

; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; 文字列 Str1 を適宜ウェイトを入れながら出力する
SendNeo(Str1)
{
;	local Delay, len, Str2, len2, i, j, c, bracket

	IfWinActive, ahk_class CabinetWClass
		Delay := 10	; エクスプローラーにはゆっくり出力する
	else
		Delay := 0

	; 1文字ずつ出力
	len := StrLen(Str1)
	Str2 := "", len2 := 0
	bracket := 0
	i := 1
	while (i <= len)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket)
			bracket++
		Str2 .= c, len2++
		if (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i = len )
		{
			; SendRaw(直接入力モード)にする時
			if (SubStr(Str2, len2 - 4, 5) = "{Raw}")
			{
				Str2 := "{Raw}" . SubStr(Str1, ++i, len) ; 残りを全て出力へ
				i := len	; カウンタは末尾へ
			}
			; {Enter から始まる
			if (SubStr(Str2, 1, 6) = "{Enter")
			{
				j := SubStr(Str2, 8, len2 - 8)	; "{Enter " の後の回数
				Loop {
					Send, {Enter down}
					Sleep, 30
					Send, {Enter up}
					Sleep, 10
					j--
				} Until j < 1
			}
			else
			{
				if (Str2 = "{BS}" || Str2 = "Backspace")
					SetKeyDelay, 40
				else
					SetKeyDelay, Delay
				Send, % Str2
				SetKeyDelay, 0
			}
			Str2 := "", len2 := 0
		}
		i++
	}

	return
}

; 仮出力バッファの先頭から i 回出力する
OutBuf(i)
{
	global _usc, OutStr

	while (i > 0 && _usc > 0)
	{
		SendNeo(OutStr[1])

		OutStr[1] := OutStr[2]
		_usc--
		i--
	}
	return
}

; 仮出力バッファを最後から nBack 回分を削除して、Str1 を保存
StoreBuf(nBack, Str1)
{
	global _usc, OutStr

	if nBack > 0
	{
		_usc -= nBack
		if _usc <= 0
			_usc := 0
		else
			OutBuf(1)	; nBack の分だけ戻って、残りのバッファは出力する
	}
	else if _usc = 2	; バッファがいっぱいなので、1文字出力
		OutBuf(1)
	_usc++
	OutStr[_usc] := Str1

	return
}

; 出力する文字列を選択
SelectStr(i)
{
	global KanaMode, Eisu, EisuYoko, Kana, KanaYoko, Vertical
;	local Str1

	if (!KanaMode)
	{
		if (Vertical || EisuYoko[i] == "")
			Str1 := Eisu[i]
		else
			Str1 := EisuYoko[i]
	}
	else if (Vertical || KanaYoko[i] == "")
		Str1 := Kana[i]
	else
		Str1 := KanaYoko[i]

	return Str1
}

Convert()
{
	global KanaMode
		, InBuf, InBufRead, InBufTime, InBufRest
		, KC_SPC, JP_YEN, KC_INT1
		, Key, KeyGroup, Kana, Eisu, Setted, Repeatable
		, BeginTable, EndTable
		, Vertical, ShiftDelay
	static run		:= 0	; 多重起動防止フラグ
		, spc		:= 0	; スペースキーの単押しを空白入力にするためのフラグ
		, LastStr	:= ""	; 前回の文字列
		, RealKey	:= 0	; 今押している全部のキービットの集合
		, LastKeys	:= 0	; 前回のキービット
		, Last2Keys	:= 0	; 前々回のキービット
		, LastKeyTime := 0	; 有効なキーを押した時間
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, LastGroup := 0	; 前回、何グループだったか？ 0はグループAll
		, RepeatKey	:= 0	; リピート中のキーのビット
;	local Str1
;		, Term		; 入力の末端2文字
;		, RecentKey	; 今回のキービット
;		, KeyTime	; キーを押した時間
;		, KeyComb	; いま検索しようとしているキーの集合
;		, i			; カウンタ
;		, nkeys		; 今回は何キー同時押しか

	if (run)
		return	; 多重起動防止で終了

	; 縦書き検出
;	Vertical := IME_GetVertical()

	; 入力バッファが空になるまで
	while (run := 15 - InBufRest)
	{
		; 入力バッファから読み出し
		Str1 := InBuf[InBufRead], KeyTime := InBufTime[InBufRead++], InBufRead &= 15, InBufRest++

		; IME の状態を検出
		KanaMode := IME_GetConvMode() & 1
		if (!KanaMode || !IME_GET())
			KanaMode := 0	; 検出できない、または IME OFF の時

		nkeys := 0	; 何キー同時押しか、を入れる変数
		StringRight, Term, Str1, 2	; Term に入力末尾の2文字を入れる
		; キーが離れた時
		if (Term == "up")
			RecentKey := "0x" . SubStr(Str1, StrLen(Str1) - 4, 2)
		; sc○○ で入力
		else if (SubStr(Str1, 1, 2) == "sc")
		{
			RecentKey := "0x" . Term
			Str1 := "{sc" . Term . "}"
		}	; ここで RecentKey に sc○○ から 0x○○ に変換されたものが入っているが、
			; Autohotkey は十六進数の数値としてそのまま扱える
		; sc○○ 以外で入力
		else
		{
			RecentKey := 0
			Str1 := "{" . Str1 . "}"
			nkeys := -1	; 後の検索は不要なため
		}

		; ビットに変換
		if RecentKey = 0x7D			; (JIS)\
			RecentKey := JP_YEN
		else if RecentKey = 0x73	; (JIS)_
			RecentKey := KC_INT1
		else if (RecentKey)
			RecentKey := 1 << RecentKey

		; キーリリース時
		if (Term == "up")
		{
			if (spc = 1 && RecentKey = KC_SPC)	; スペースキー単押しだったなら、空白出力
			{
				StoreBuf(0, "{Space}")
				spc := 0
			}
			OutBuf(2)
			LastStr	:= ""
			RealKey &= RecentKey ^ (-1)	; RealKey &= ~RecentKey では
										; 32ビット計算になることがあり、不適切
			Last2Keys := 0
			LastKeys := RealKey
			LastGroup := 0
			RepeatKey := 0	; リピート解除
		}
		; スペースキー(通常シフト、キーリリース直後、設定時間経過後の後置シフト)が押された時
		else if (!(RealKey & RecentKey) && RecentKey = KC_SPC
		 && (LastStr == "" || LastKeyTime + ShiftDelay <= KeyTime))
		{
			spc := 1
			OutBuf(2)
			LastStr	:= ""
			RealKey |= KC_SPC
			LastGroup := 0
			RepeatKey := 0	; リピート解除
		}
		; 押されていなかったキーか、リピートできるキーが押された時
		else if (!(RealKey & RecentKey) || RecentKey = RepeatKey)
		{
			RealKey |= RecentKey
			nBack := 0

			; グループありの3キー入力を検索
			if (LastGroup && !nkeys)
			{
				i := BeginTable[3]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys | Last2Keys
				while (i < EndTable[3])
				{
					if (KeyGroup[i] = LastGroup
						&& (Key[i] & RecentKey) 		; 今回のキーを含み
						&& (Key[i] & KeyComb) = key[i]	; 検索中のキー集合が、いま調べている定義内にあり
						&& !((Key[i] ^ KeyComb) & KC_SPC)	; ただしシフトの相違はなく
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{									; かな入力中なら、かな定義が、英数入力中なら英数定義があること
						nkeys := 3
						nBack := (_lks >= 2) ? 1 : 2
							; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
							; 前回が1キー入力だったら、2文字消して仮出力バッファへ
						break
					}
					i++
				}
			}
			; グループありの2キー入力を検索
			if (LastGroup && !nkeys)
			{
				i := BeginTable[2]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys
				while (i < EndTable[2])
				{
					if (KeyGroup[i] = LastGroup
						&& (Key[i] & RecentKey)
						&& (Key[i] & KeyComb) = key[i]
						&& !((Key[i] ^ KeyComb) & KC_SPC)
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{
						nkeys := 2
						if (_lks >= 2 && RecentKey != KC_SPC)	; 2キー同時→2キー同時 は出力確定
							OutBuf(2)
						nBack := 1
						break
					}
					i++
				}
			}
			; グループありの1キー入力を検索
			if (LastGroup && !nkeys)
			{
				i := BeginTable[1]	; 検索開始場所の設定
				if (RecentKey = KC_SPC)
					KeyComb := KC_SPC | LastKeys
				else
					KeyComb := (RealKey & KC_SPC) | RecentKey
				while (i < EndTable[1])
				{
					if (KeyGroup[i] = LastGroup
						&& Key[i] = KeyComb
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{
						nkeys := 1
						if (RecentKey = KC_SPC)
							nBack := 1
						break
					}
					i++
				}
			}
			; 3キー入力を検索
			if (!nkeys)
			{
				i := BeginTable[3]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys | Last2Keys
				while (i < EndTable[3])
				{
					if ((Key[i] & RecentKey)			; 今回のキーを含み
						&& (Key[i] & KeyComb) = key[i]	; 検索中のキー集合が、いま調べている定義内にあり
						&& !((Key[i] ^ KeyComb) & KC_SPC)	; ただしシフトの相違はなく
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{									; かな入力中なら、かな定義が、英数入力中なら英数定義があること
						nkeys := 3
						nBack := (_lks >= 2) ? 1 : 2
							; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
							; 前回が1キー入力だったら、2文字消して仮出力バッファへ
						break
					}
					i++
				}
			}
			; 2キー入力を検索
			if (!nkeys)
			{
				i := BeginTable[2]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys
				while (i < EndTable[2])
				{
					if ((Key[i] & RecentKey)
						&& (Key[i] & KeyComb) = key[i]
						&& !((Key[i] ^ KeyComb) & KC_SPC)
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{
						nkeys := 2
						if (_lks >= 2 && RecentKey != KC_SPC)	; 2キー同時→2キー同時 は出力確定
							OutBuf(2)
						nBack := 1
						break
					}
					i++
				}
			}
			; 1キー入力を検索
			if (!nkeys)
			{
				i := BeginTable[1]	; 検索開始場所の設定
				if (RecentKey = KC_SPC)
					KeyComb := KC_SPC | LastKeys
				else
					KeyComb := (RealKey & KC_SPC) | RecentKey
 				while (i < EndTable[1])
				{
					if (Key[i] = KeyComb
						&& ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
					{
						nkeys := 1
						if (RecentKey = KC_SPC)
							nBack := 1
						break
					}
					i++
				}
			}
			; スペースを押したが、定義がなかった時
			if (RecentKey = KC_SPC && !nkeys)
			{
				spc := 1
;				LastKeys |= KC_SPC	;
				RepeatKey := 0
				continue
			}
			; 見つからなかった時
			if nkeys <= 0
			{
				if (RealKey & KC_SPC)	; シフト
					Str1 := "+" . Str1
			}
			else	; 出力する文字列を選択
				Str1 := SelectStr(i)

			spc := 0
			; 仮出力バッファに入れる
			StoreBuf(nBack, Str1)
			; 出力確定文字か？
			if (!RecentKey || Setted[i] > (ShiftDelay ? 1 : 0))
				OutBuf(2)	; 出力確定

			LastStr	:= Str1
			Last2Keys := (nkeys >= 2) ? 0 : LastKeys	; 2、3キー入力のときは、前々回のキービットを保存しない
			LastKeys := (nkeys >= 1) ? Key[i] : RecentKey	; 前回のキービットを保存
			LastKeyTime := KeyTime		; 有効なキーを押した時間を保存
			_lks := nkeys				; 何キー同時押しだったかを保存
			LastGroup := KeyGroup[i]	; 何グループだったか保存
			if (Repeatable[i])
				RepeatKey := RecentKey	; キーリピートできる
		}
	}

	return
}


; ----------------------------------------------------------------------
; ホットキー
; ----------------------------------------------------------------------
#MaxThreadsPerHotkey 2	; 1つのホットキー・ホットストリングに多重起動可能な
						; 最大のスレッド数を設定

; キー入力部(シフトなし)

#If (KeyDriver == "kbd101.dll")	; 設定がUSキーボードの場合
sc29::	; (JIS)半角/全角	(US)`
#If

sc02::	; 1
sc03::	; 2
sc04::	; 3
sc05::	; 4
sc06::	; 5
sc07::	; 6
sc08::	; 7
sc09::	; 8
sc0A::	; 9
sc0B::	; 0
sc0C::	; -
sc0D::	; (JIS)^	(US)=
sc7D::	; (JIS)\
sc10::	; Q
sc11::	; W
sc12::	; E
sc13::	; R
sc14::	; T
sc15::	; Y
sc16::	; U
sc17::	; I
sc18::	; O
sc19::	; P
sc1A::	; (JIS)@	(US)[
sc1B::	; (JIS)[	(US)]
sc1E::	; A
sc1F::	; S
sc20::	; D
sc21::	; F
sc22::	; G
sc23::	; H
sc24::	; J
sc25::	; K
sc26::	; L
sc27::	; ;
sc28::	; (JIS):	(US)'
sc2B::	; (JIS)]	(US)＼
sc2C::	; Z
sc2D::	; X
sc2E::	; C
sc2F::	; V
sc30::	; B
sc31::	; N
sc32::	; M
sc33::	; ,
sc34::	; .
sc35::	; /
sc73::	; (JIS)_
sc39::	; Space
; SandS 用
Up::
Left::
Right::
Down::
Home::
End::
PgUp::
PgDn::
	; 入力バッファへ保存
	; キーを押す方はいっぱいまで使わない
	InBuf[InBufWrite] := A_ThisHotkey, InBufTime[InBufWrite] := WinAPI_timeGetTime()
		, InBufWrite := (InBufRest > 6) ? ++InBufWrite & 15 : InBufWrite
		, (InBufRest > 6) ? InBufRest-- :
	Convert()	; 変換ルーチン
	return

; キー押上げ

#If (KeyDriver == "kbd101.dll")	; 設定がUSキーボードの場合
sc29 up::	; (JIS)半角/全角	(US)`
#If

sc02 up::	; 1
sc03 up::	; 2
sc04 up::	; 3
sc05 up::	; 4
sc06 up::	; 5
sc07 up::	; 6
sc08 up::	; 7
sc09 up::	; 8
sc0A up::	; 9
sc0B up::	; 0
sc0C up::	; -
sc0D up::	; (JIS)^	(US)=
sc7D up::	; (JIS)\
sc10 up::	; Q
sc11 up::	; W
sc12 up::	; E
sc13 up::	; R
sc14 up::	; T
sc15 up::	; Y
sc16 up::	; U
sc17 up::	; I
sc18 up::	; O
sc19 up::	; P
sc1A up::	; (JIS)@	(US)[
sc1B up::	; (JIS)[	(US)]
sc1E up::	; A
sc1F up::	; S
sc20 up::	; D
sc21 up::	; F
sc22 up::	; G
sc23 up::	; H
sc24 up::	; J
sc25 up::	; K
sc26 up::	; L
sc27 up::	; ;
sc28 up::	; (JIS):	(US)'
sc2B up::	; (JIS)]	(US)＼
sc2C up::	; Z
sc2D up::	; X
sc2E up::	; C
sc2F up::	; V
sc30 up::	; B
sc31 up::	; N
sc32 up::	; M
sc33 up::	; ,
sc34 up::	; .
sc35 up::	; /
sc73 up::	; (JIS)_
sc39 up::	; Space
	; 入力バッファへ保存
	InBuf[InBufWrite] := A_ThisHotkey, InBufTime[InBufWrite] := WinAPI_timeGetTime()
		, InBufWrite := InBufRest ? ++InBufWrite & 15 : InBufWrite
		, InBufRest ? InBufRest-- :
	Convert()	; 変換ルーチン
	return

#MaxThreadsPerHotkey 1	; 元に戻す
