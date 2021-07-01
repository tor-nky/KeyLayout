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
KanaMode := 0		; 0: 英数入力, 1: かな入力
Vertical := 1		; 0: 横書き用, 1: 縦書き用
; 入力バッファ
InBufsKey := []
InBufsTime := []	; 入力の時間
InBufReadPos := 0	; 読み出し位置
InBufWritePos := 0	; 書き込み位置
InBufRest := 15
; 仮出力バッファ
OutStr := []
_usc := 0			; 保存されている文字数

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

; タイマーの精度を調整
if ShiftDelay > 0	; 後置シフトあり
	WinAPI_timeBeginPeriod(1)

; ----------------------------------------------------------------------
; メニュー表示
; ----------------------------------------------------------------------
menu, tray, NoStandard			; タスクトレイメニューの標準メニュー項目を解除
menu, tray, add, 縦書きモード	; “縦書きモード”を追加
menu, tray, Check, 縦書きモード	; “縦書きモード”にチェックを付ける
menu, tray, add					; セパレーター
menu, tray, Standard			; 標準メニュー項目を追加

exit	; 起動時はここまで実行

; ----------------------------------------------------------------------
; メニュー動作
; ----------------------------------------------------------------------
縦書きモード:
menu, tray, ToggleCheck, 縦書きモード
	Vertical ^= 1
return

; ----------------------------------------------------------------------
; サブルーチン
; ----------------------------------------------------------------------

PSTimer:	; 後置シフトの判定期限タイマー
	SetTimer, PSTimer, Off	; タイマー停止
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "PSTimer", InBufsTime[InBufWritePos] := WinAPI_timeGetTime()
		, InBufWritePos := (InBufRest = 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest = 15 ? InBufRest-- : )
	Convert()				; 変換ルーチン
	return

CombTimer:	; 同時押しの判定期限タイマー
	SetTimer, CombTimer, Off	; タイマー停止
	; 入力バッファが空の時、保存
	InBufsKey[InBufWritePos] := "CombTimer", InBufsTime[InBufWritePos] := WinAPI_timeGetTime()
		, InBufWritePos := (InBufRest = 15 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest = 15 ? InBufRest-- : )
	Convert()				; 変換ルーチン
	return

; ----------------------------------------------------------------------
; 関数
; ----------------------------------------------------------------------

; 文字列 Str1 を適宜ディレイを入れながら出力する
SendNeo(Str1, Delay:=0)
{
	global Slow
	static LastTickCount := WinAPI_timeGetTime()
;	local len						; Str1 の長さ
;		, StrChopped, LenChopped	; 細切れにした文字列と、その長さを入れる変数
;		, i, c, bracket
;		, IMECheck, IMEConvMode		; IME入力モードの保存、復元に関するフラグと変数
;		, PreDelay, PostDelay		; 出力前後のディレイの値
;		, LastDelay					; 前回のディレイの値
;		, NowTickCount
;		, SlowCopied

	SlowCopied := Slow
	IfWinActive, ahk_class CabinetWClass	; エクスプローラーにはゆっくり出力する
		Delay := (Delay < 10 ? 10 : Delay)
	else IfWinActive, ahk_class Hidemaru32Class	; 秀丸エディタ
		SlowCopied := (SlowCopied = 1 ? 0x11 : SlowCopied)
	SetKeyDelay, -1, -1

	NowTickCount := WinAPI_timeGetTime()
	if (NowTickCount <= LastTickCount)
		LastDelay := NowTickCount - LastTickCount
	else
		LastDelay := 0x100000000 + NowTickCount - LastTickCount	; タイマーの周回遅れ対策

	; 文字列を細切れにして出力
	PreDelay := 0, PostDelay := Delay	; ディレイの初期値
	IMECheck := 0
	StrChopped := "", LenChopped := 0, bracket := 0
	i := 1, len := StrLen(Str1)
	while (i <= len)
	{
		c := SubStr(Str1, i, 1)
		if (c == "}" && bracket != 1)
			bracket := 0
		else if (c == "{" || bracket)
			bracket++
		StrChopped .= c, LenChopped++
		if (!(bracket || c == "+" || c == "^" || c == "!" || c == "#")
			|| i = len )
		{
			; SendRaw(直接入力モード)にする時
			if (SubStr(StrChopped, LenChopped - 4, 5) = "{Raw}")
			{
				i++
				while (i <= len)
				{
					StrChopped := SubStr(Str1, i, 2)
					if (Asc(StrChopped) > 65535)	; ユニコード拡張領域
					{
						SendRaw, % StrChopped
						i += 2
					}
					else
					{
						SendRaw, % SubStr(Str1, i, 1)
						i++
					}
					; 出力直後のディレイ
					Sleep, PostDelay
				}
				break
			}
			; 出力するキーを変換
			else if (StrChopped == "{確定}")
				StrChopped := "{Enter}"
			else if (StrChopped = "{IMEOff}")
			{
				IMECheck := 1			; IME入力モードを保存する必要あり
				StrChopped := "{vkF3}"	; 半角/全角
				PostDelay := 30
			}
			else if (SlowCopied = 0x11 && SubStr(StrChopped, 1, 6) = "{Enter")
				PreDelay := 80, PostDelay := 100	; 秀丸エディタ + ATOK 用

			; 前回の出力からの時間が短ければ、ディレイを入れる
			if (LastDelay < PreDelay)
				Sleep, % PreDelay - LastDelay
			; IME入力モードを保存する
			if IMECheck = 1
			{
				IMEConvMode := IME_GetConvMode()
				IMECheck := 2	; 後で IME入力モードを回復する
			}
			; キー出力
			if (StrChopped != "{Null}")
			{
				Send, % StrChopped
				; 出力直後のディレイ
				Sleep, PostDelay
				LastDelay := PostDelay				; 今回のディレイの値を保存
				PreDelay := 0, PostDelay := Delay	; ディレイの初期値
			}

			StrChopped := "", LenChopped := 0
		}
		i++
	}

	; IME ON
	if IMECheck = 2
	{
		if SlowCopied = 0x11
			PreDelay := 70, PostDelay := 90		; 秀丸エディタ + ATOK 用
		else if SlowCopied = 1
			PreDelay := 50, PostDelay := 70		; ATOK 用
		; 前回の出力からの時間が短ければ、ディレイを入れる
		if (LastDelay < PreDelay)
			Sleep, % PreDelay - LastDelay
		; キー出力
		Send, {vkF3}	; 半角/全角
		; 出力直後のディレイ
		Sleep, PostDelay
		; IME入力モードを回復する
		if IMEConvMode > 0
			IME_SetConvMode(IMEConvMode)
	}

	LastTickCount := WinAPI_timeGetTime()	; 最後に出力した時間を記録

	return
}

; 仮出力バッファの先頭から i 個出力する
; i の指定がないときは、全部出力する
OutBuf(i:=2)
{
	global _usc, OutStr
;	local Str1, StrBegin

	while (i > 0 && _usc > 0)
	{
		Str1 := OutStr[1]
		StrBegin := SubStr(Str1, 1, 4)
		if (StrBegin == "{記号}" || StrBegin == "{直接}")
		{
			StringTrimLeft, Str1, Str1, 4
			if (StrBegin == "{直接}")
				Str1 := "{Raw}" . Str1
			if (IME_GET() = 1)		; IME ON の時
			{
				if (IME_GetSentenceMode() = 0)
					Str1 := "{IMEOff}" . Str1
				else
					Str1 := ":{確定}{BS}{IMEOff}" . Str1
			}
			SendNeo(Str1, 10)
		}
		else
			SendNeo(Str1)

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
			_usc := 0	; バッファが空になる以上は削除しない
		else
			OutBuf(1)	; nBack の分だけ戻って、残ったバッファは出力する
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
	global DefsTateStr, DefsYokoStr, Vertical
;	local Str1

	Str1 := (Vertical ? DefsTateStr[i] : DefsYokoStr[i])

	return Str1
}

Convert()
{
	global KanaMode
		, InBufsKey, InBufReadPos, InBufsTime, InBufRest
		, KC_SPC, JP_YEN, KC_INT1, R
		, DefsKey, DefsGroup, DefsKanaMode, DefsSetted, DefsRepeat, DefBegin, DefEnd
		, _usc
		, ShiftDelay, CombDelay
	static ConvRest	:= 0	; 多重起動防止フラグ
		, spc		:= 0	; スペースキーの単押しを空白入力にするためのフラグ
		, RealKey	:= 0	; 今押している全部のキービットの集合
		, LastKeys	:= 0	; 前回のキービット
		, Last2Keys	:= 0	; 前々回のキービット
		, LastKeyTime := 0	; 有効なキーを押した時間
		, _lks		:= 0	; 前回、何キー同時押しだったか？
		, LastGroup := 0	; 前回、何グループだったか？ 0はグループAll
		, RepeatKey	:= 0	; リピート中のキーのビット
		, LastSetted := 0	; 出力確定したか(1 だと、後置シフトの判定期限到来で出力確定)
		, shift := 0		; 前回の入力が "+"(左右シフト)付きだったか保存
;	local Detect
;		, Str1
;		, Term		; 入力の末端2文字
;		, RecentKey	; 今回のキービット
;		, KeyTime	; キーを押した時間
;		, KeyComb	; いま検索しようとしているキーの集合
;		, i			; カウンタ
;		, nkeys		; 今回は何キー同時押しか

	if ConvRest > 0
		return	; 多重起動防止で終了

	; 入力バッファが空になるまで
	while (ConvRest := 15 - InBufRest)
	{
		SetTimer, PSTimer, Off		; 後置シフトの判定期限タイマー停止
		SetTimer, CombTimer, Off	; 同時押しの判定期限タイマー停止

		; 入力バッファから読み出し
		Str1 := InBufsKey[InBufReadPos], KeyTime := InBufsTime[InBufReadPos]
		if (Asc(Str1) = 43)		; "+" から始まる
		{
			if shift = 0		; Shiftなし→あり
			{
				OutBuf()
				Str1 := "sc39"	; ここで Space 押す
				shift := 1
			}
			else
			{
				StringTrimLeft, Str1, Str1, 1	; 先頭の1文字を消去
				InBufReadPos := ++InBufReadPos & 15, InBufRest++
			}
		}
		else if shift = 1		; Shiftあり→なし
		{
			Str1 := "sc39 up"	; ここで Space 押し上げ
			shift := 0, spc := 0
		}
		else
			InBufReadPos := ++InBufReadPos & 15, InBufRest++

		; 後置シフトの判定期限到来
		if (Str1 == "PSTimer")
		{
			if (LastSetted = 1 && LastKeyTime + ShiftDelay <= WinAPI_timeGetTime())	; 割り込みの行き違いを防ぐ
				OutBuf()
			continue
		}
		LastSetted := 0

		; 同時押しの判定期限到来(シフト時のみ)
		if (Str1 == "CombTimer")
		{
			if ((RealKey & KC_SPC) && LastKeyTime + CombDelay <= WinAPI_timeGetTime())	; 割り込みの行き違いを防ぐ
			{
				OutBuf()
				Last2Keys := 0, LastKeys := 0
			}
			continue
		}

		; IME の状態を検出(失敗したら書き換えない)
		Detect := IME_GET()
		if Detect = 0 			; IME OFF の時
			KanaMode := 0
		else if Detect = 1		; IME ON の時
		{
			Detect := IME_GetConvMode()
			if (Detect != "")
				KanaMode := Detect & 1
		}

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
		else if RecentKey != 0
			RecentKey := 1 << RecentKey

		; キーリリース時
		if (Term == "up")
		{
			if (spc = 1 && RecentKey = KC_SPC)	; スペースキー単独押しだったなら、空白出力
			{
				StoreBuf(0, "{Space}")
				spc := 0
			}
			OutBuf()
			RealKey &= RecentKey ^ (-1)	; RealKey &= ~RecentKey では
										; 32ビット計算になることがあり、不適切
			Last2Keys := 0
			LastKeys := RealKey
;			LastKeys &= RecentKey ^ (-1)	; 上の式の方が操作しやすい
			LastGroup := 0
			RepeatKey := 0	; リピート解除
		}
		; (キーリリース直後か、通常シフトまたは後置シフトの判定期限後に)スペースキーが押された時
		else if (!(RealKey & RecentKey) && RecentKey = KC_SPC
			&& (_usc = 0 || LastKeyTime + ShiftDelay <= KeyTime))
		{
			spc := 1	; 単独スペース判定フラグ
			OutBuf()
			RealKey |= KC_SPC
			LastGroup := 0
			RepeatKey := 0	; リピート解除
		}
		; 押されていなかったキーか、リピートできるキーが押された時
		else if (!(RealKey & RecentKey) || RecentKey = RepeatKey)
		{
			; 同時押しの判定期限到来(シフト時のみ)
			if (CombDelay > 0 && (RealKey & KC_SPC) && LastKeyTime + CombDelay <= KeyTime)
			{
				OutBuf()
				Last2Keys := 0, LastKeys := 0
			}

			RealKey |= RecentKey
			nBack := 0

			; グループありの3キー入力を検索
			if (LastGroup != 0 && nkeys = 0)
			{
				i := DefBegin[3]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys | Last2Keys
				while (i < DefEnd[3])
				{
					if (DefsGroup[i] = LastGroup
						&& (DefsKey[i] & RecentKey) 			; 今回のキーを含み
						&& (DefsKey[i] & KeyComb) = DefsKey[i]	; 検索中のキー集合が、いま調べている定義内にあり
						&& !((DefsKey[i] ^ KeyComb) & KC_SPC)	; ただしシフトの相違はなく
						&& DefsKanaMode[i] = KanaMode)			; 英数用、かな用の種別が一致していること
					{
						if (_lks = 3 && CombDelay > 0 && (RealKey & KC_SPC) && RecentKey != KC_SPC)
						{
							LastKeys := 0
							break
						}
						if (_lks = 3 && RecentKey != KC_SPC)	; 3キー同時→3キー同時 は仮出力バッファを全て出力
							OutBuf()
						else if _lks >= 2
							nBack := 1	; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
						else
							nBack := 2	; 前回が1キー入力だったら、2文字消して仮出力バッファへ
						nkeys := 3
						break
					}
					i++
				}
			}
			; グループありの2キー入力を検索
			if (LastGroup != 0 && nkeys = 0)
			{
				i := DefBegin[2]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys
				while (i < DefEnd[2])
				{
					if (DefsGroup[i] = LastGroup
						&& (DefsKey[i] & RecentKey)
						&& (DefsKey[i] & KeyComb) = DefsKey[i]
						&& !((DefsKey[i] ^ KeyComb) & KC_SPC)
						&& DefsKanaMode[i] = KanaMode)
					{
						if (_lks = 2 && CombDelay > 0 && (RealKey & KC_SPC) && RecentKey != KC_SPC)
						{
							LastKeys := 0
							break
						}
						if (_lks >= 2 && RecentKey != KC_SPC)	; 2キー同時→2キー同時 は仮出力バッファを全て出力
							OutBuf()
						nBack := 1
						nkeys := 2
						break
					}
					i++
				}
			}
			; グループありの1キー入力を検索
			if (LastGroup != 0 && nkeys = 0)
			{
				i := DefBegin[1]	; 検索開始場所の設定
				if (RecentKey = KC_SPC)
					KeyComb := KC_SPC | LastKeys
				else
					KeyComb := (RealKey & KC_SPC) | RecentKey
				while (i < DefEnd[1])
				{
					if (DefsGroup[i] = LastGroup
						&& DefsKey[i] = KeyComb
						&& DefsKanaMode[i] = KanaMode)
					{
						if (RecentKey = KC_SPC)
							nBack := 1
						nkeys := 1
						break
					}
					i++
				}
			}
			; 3キー入力を検索
			if nkeys = 0
			{
				i := DefBegin[3]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys | Last2Keys
				while (i < DefEnd[3])
				{
					if ((DefsKey[i] & RecentKey)				; 今回のキーを含み
						&& (DefsKey[i] & KeyComb) = DefsKey[i]	; 検索中のキー集合が、いま調べている定義内にあり
						&& !((DefsKey[i] ^ KeyComb) & KC_SPC)	; ただしシフトの相違はなく
						&& DefsKanaMode[i] = KanaMode)			; 英数用、かな用の種別が一致していること
					{
						if (_lks = 3 && CombDelay > 0 && (RealKey & KC_SPC) && RecentKey != KC_SPC)
						{
							LastKeys := 0
							break
						}
						if (_lks = 3 && RecentKey != KC_SPC)	; 3キー同時→3キー同時 は仮出力バッファを全て出力
							OutBuf()
						else if _lks >= 2
							nBack := 1	; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
						else
							nBack := 2	; 前回が1キー入力だったら、2文字消して仮出力バッファへ
						nkeys := 3
						break
					}
					i++
				}
			}
			; 2キー入力を検索
			if nkeys = 0
			{
				i := DefBegin[2]	; 検索開始場所の設定
				KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys
				while (i < DefEnd[2])
				{
					if ((DefsKey[i] & RecentKey)
						&& (DefsKey[i] & KeyComb) = DefsKey[i]
						&& !((DefsKey[i] ^ KeyComb) & KC_SPC)
						&& DefsKanaMode[i] = KanaMode)
					{
						if (_lks = 2 && CombDelay > 0 && (RealKey & KC_SPC) && RecentKey != KC_SPC)
						{
							LastKeys := 0
							break
						}
						if (_lks >= 2 && RecentKey != KC_SPC)	; 2キー同時→2キー同時 は仮出力バッファを全て出力
							OutBuf()
						nBack := 1
						nkeys := 2
						break
					}
					i++
				}
			}
			; 1キー入力を検索
			if nkeys = 0
			{
				i := DefBegin[1]	; 検索開始場所の設定
				if (RecentKey = KC_SPC)
					KeyComb := KC_SPC | LastKeys
				else
					KeyComb := (RealKey & KC_SPC) | RecentKey
 				while (i < DefEnd[1])
				{
					if (DefsKey[i] = KeyComb
						&& DefsKanaMode[i] = KanaMode)
					{
						if (RecentKey = KC_SPC)
							nBack := 1
						nkeys := 1
						break
					}
					i++
				}
			}
			; スペースを押したが、定義がなかった時
			if (RecentKey = KC_SPC && nkeys = 0)
			{
				spc := 1	; 単独シフト判定フラグ
;				LastKeys |= KC_SPC
				RepeatKey := 0
				continue	; 次の入力へ
			}
			spc := 0	; 単独スペースではない

			; 出力する文字列を選ぶ
			if nkeys > 0	; 定義が見つかった時
			{
				Str1 := SelectStr(i)			; 出力する文字列
				LastSetted := DefsSetted[i]		; 出力確定するか検索
			}
			else	; 見つからなかった時
			{
				if (RealKey & KC_SPC)	; スペースキーが押されていたら、シフトを加える(SandSの実装)
					Str1 := "+" . Str1
				LastSetted := 0	; 出力確定はしない
			}

			; 仮出力バッファに入れる
			StoreBuf(nBack, Str1)
			; 出力確定文字か？
			if (!RecentKey || LastSetted > (ShiftDelay > 0 ? 1 : 0))
				OutBuf()	; 出力確定
			else if (ConvRest = 1)
			{
				; 後置シフトの判定期限タイマー起動
				if LastSetted = 1
					SetTimer, PSTimer, % ShiftDelay + 9
				; 同時押しの判定期限タイマー起動(シフト時のみ)
				if (CombDelay > 0 && (RealKey & KC_SPC))
					SetTimer, CombTimer, % CombDelay + 9
			}

			; 次回に向けて変数を更新
			Last2Keys := (nkeys >= 2 ? 0 : LastKeys)			; 2、3キー入力のときは、この前のキービットを保存しない
			LastKeys := (nkeys >= 1 ? DefsKey[i] : RecentKey)	; 今回のキービットを保存
			LastKeyTime := KeyTime		; 有効なキーを押した時間を保存
			_lks := nkeys				; 何キー同時押しだったかを保存
			LastGroup := DefsGroup[i]	; 何グループだったか保存
			if (DefsRepeat[i] & R)
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

; キー入力部
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
; キー入力部(左右シフトかな)
#If (SideShift = 1)
+sc02::	; 1
+sc03::	; 2
+sc04::	; 3
+sc05::	; 4
+sc06::	; 5
+sc07::	; 6
+sc08::	; 7
+sc09::	; 8
+sc0A::	; 9
+sc0B::	; 0
+sc0C::	; -
+sc0D::	; (JIS)^	(US)=
+sc7D::	; (JIS)\
+sc10::	; Q
+sc11::	; W
+sc12::	; E
+sc13::	; R
+sc14::	; T
+sc15::	; Y
+sc16::	; U
+sc17::	; I
+sc18::	; O
+sc19::	; P
+sc1A::	; (JIS)@	(US)[
+sc1B::	; (JIS)[	(US)]
+sc1E::	; A
+sc1F::	; S
+sc20::	; D
+sc21::	; F
+sc22::	; G
+sc23::	; H
+sc24::	; J
+sc25::	; K
+sc26::	; L
+sc27::	; ;
+sc28::	; (JIS):	(US)'
+sc2B::	; (JIS)]	(US)＼
+sc2C::	; Z
+sc2D::	; X
+sc2E::	; C
+sc2F::	; V
+sc30::	; B
+sc31::	; N
+sc32::	; M
+sc33::	; ,
+sc34::	; .
+sc35::	; /
+sc73::	; (JIS)_
#If
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
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := WinAPI_timeGetTime()
		, InBufWritePos := (InBufRest > 6 ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest > 6 ? InBufRest-- : )
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
; キー押上げ(左右シフトかな)
#If (SideShift = 1)
+sc02 up::	; 1
+sc03 up::	; 2
+sc04 up::	; 3
+sc05 up::	; 4
+sc06 up::	; 5
+sc07 up::	; 6
+sc08 up::	; 7
+sc09 up::	; 8
+sc0A up::	; 9
+sc0B up::	; 0
+sc0C up::	; -
+sc0D up::	; (JIS)^	(US)=
+sc7D up::	; (JIS)\
+sc10 up::	; Q
+sc11 up::	; W
+sc12 up::	; E
+sc13 up::	; R
+sc14 up::	; T
+sc15 up::	; Y
+sc16 up::	; U
+sc17 up::	; I
+sc18 up::	; O
+sc19 up::	; P
+sc1A up::	; (JIS)@	(US)[
+sc1B up::	; (JIS)[	(US)]
+sc1E up::	; A
+sc1F up::	; S
+sc20 up::	; D
+sc21 up::	; F
+sc22 up::	; G
+sc23 up::	; H
+sc24 up::	; J
+sc25 up::	; K
+sc26 up::	; L
+sc27 up::	; ;
+sc28 up::	; (JIS):	(US)'
+sc2B up::	; (JIS)]	(US)＼
+sc2C up::	; Z
+sc2D up::	; X
+sc2E up::	; C
+sc2F up::	; V
+sc30 up::	; B
+sc31 up::	; N
+sc32 up::	; M
+sc33 up::	; ,
+sc34 up::	; .
+sc35 up::	; /
+sc73 up::	; (JIS)_
#If
; 入力バッファへ保存
	InBufsKey[InBufWritePos] := A_ThisHotkey, InBufsTime[InBufWritePos] := WinAPI_timeGetTime()
		, InBufWritePos := (InBufRest ? ++InBufWritePos & 15 : InBufWritePos)
		, (InBufRest ? InBufRest-- : )
	Convert()	; 変換ルーチン
	return

#MaxThreadsPerHotkey 1	; 元に戻す
