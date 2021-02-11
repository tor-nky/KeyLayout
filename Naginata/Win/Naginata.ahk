﻿; Copyright 2021 Satoru NAKAYA
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

; ----------------------------------------------------------------------
;   3キー同時押し配列
;       ローマ字入力モード
;   ※MS-IME は初期設定のままでも使えます
;   ※ATOK を使う場合のキー設定
;       変換        → [文字未入力]再変換
;       ひらがな    → 入力文字種全角ひらがな(あ)
;       カタカナ    → 入力文字種全角カタカナ(ア)
;       半角／全角  → [文字未入力]日本語入力ON/OFF [他]入力文字種半角無変換(A)
; ----------------------------------------------------------------------

SetWorkingDir %A_ScriptDir% ; スクリプトの作業ディレクトリを変更
#SingleInstance force       ; 既存のプロセスを終了して実行開始

#NoEnv                      ; 変数名を解釈するとき、環境変数を無視する
SetBatchLines, -1           ; 自動Sleepなし
ListLines, Off              ; スクリプトの実行履歴を取らない
SetKeyDelay, 0, 0           ; キーストローク間のディレイを変更
#MenuMaskKey vk07           ; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
#UseHook                    ; ホットキーはすべてフックを使用する
; Process, Priority, , High ; プロセスの優先度を変更
;Thread, interrupt, 15, 6   ; スレッド開始から15ミリ秒ないし6行以内の割り込みを、絶対禁止
SetStoreCapslockMode, off   ; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

SetFormat, Integer, H       ; 数値演算の結果を、16進数の整数による文字列で表現する

#Include IME.ahk    ; 参考: https://w.atwiki.jp/eamat/pages/17.html
#Include init.ahk
#Include KanaTable.ahk

; グローバル変数
KanaMode := 0   ; 0: 英数入力, 1: かな入力
; 入力バッファ
InBuf := []
InBufTime := [] ; 入力の時間
InBufRead := 1  ; 読み出し位置
InBufWrite := 1 ; 書き込み位置
InBufRest := 15
; 仮出力バッファ
OutStr := []
OutDelay := []  ; キーストローク間のディレイ
_usc := 0       ; 保存されている文字数

Reset := 0
Yoko := 0       ; 0: 縦書き用, 1: 横書き用

    KanaSetting()   ; 出力確定する定義に印をつける
    EisuSetting()
;   TrayTip, %A_ScriptName%, 準備完了, , 16

exit    ; 初期設定はここまで
; ----------------------------------------------------------------------

; 仮出力バッファの先頭から chars 文字出力する
OutBuf(chars)
{
    global _usc, OutStr, OutDelay

    while (chars > 0 && _usc > 0)
    {
        SetKeyDelay, OutDelay[1], 0
        send, % OutStr[1]

        OutStr[1] := OutStr[2]
        OutDelay[1] := OutDelay[2]
        _usc--
        chars--
    }
    return
}

; 仮出力バッファを最後から nBack の分だけ削除して、Str を保存
StoreBuf(nBack, Str, Delay=0)
{
    global _usc, OutStr, OutDelay

    if nBack > 0
    {
        _usc -= nBack
        if _usc <= 0
            _usc := 0
        else
            OutBuf(1)   ; nBack の分だけ戻って、残りのバッファは出力する
    }
    else if _usc = 2    ; バッファがいっぱいなので、1文字出力
        OutBuf(1)
    _usc++
    OutStr[_usc] := Str
    OutDelay[_usc] := Delay

    return
}

; 出力する文字列を選択
SelectStr(i)
{
    global KanaMode, Eisu, EisuYoko, Kana, KanaYoko, Yoko
;   local Str

    if (!KanaMode)
    {
        if (!Yoko || EisuYoko[i] == "")
            Str := Eisu[i]
        else
            Str := EisuYoko[i]
    }
    else if (!Yoko || KanaYoko[i] == "")
        Str := Kana[i]
    else
        Str := KanaYoko[i]

    return Str
}

Convert()
{
    global KanaMode
        , InBuf, InBufRead, InBufRest
        , KC_SPC, JP_YEN, KC_INT1
        , Key, Kana, KanaSetted, Eisu, EisuSetted, Repeatable, KeyDelay
        , BeginTable, EndTable
        , Reset, Yoko
    static run      := 0    ; 多重起動防止フラグ
        , spc       := 0    ; スペースキーの単押しを空白入力にするためのフラグ
        , RealKey   := 0    ; 今押している全部のキービットの集合
        , LastKeys  := 0    ; 前回のキービット
        , Last2Keys := 0    ; 前々回のキービット
        , _lks      := 0    ; 前回、何キー同時押しだったか？
        , RepeatKey := 0    ; リピート中のキーのビット
;   local Str
;       , Term      ; 入力の末端2文字
;       , RecentKey ; 今回のキービット
;       , KeyComb   ; いま検索しようとしているキーの集合
;       , i         ; カウンタ
;       , nkeys     ; 今回は何キー同時押しか

    if (run)
        return  ; 多重起動防止で終了

    run := 1

    while (InBufRest < 15)
    {
        ; 入力バッファから読み出し
        Str := InBuf[InBufRead++]
        if InBufRead > 16
            InBufRead := 1
        InBufRest++

        if (Reset)      ; リセットが押された時
            continue    ; 入力バッファが空になるまで回す

        ; IME の状態を検出
        KanaMode := IME_GetConvMode() & 1
        if (!KanaMode | !IME_GET())
            KanaMode := 0   ; 検出できない、または IME OFF の時

        StringRight, Term, Str, 2   ; Term に入力末尾の2文字を入れる
        if (Term == "Up")   ; キーが離れた時
            RecentKey := "0x" . SubStr(Str, StrLen(Str) - 4, 2)
        else                ; キーが押された時
        {
            RecentKey := "0x" . Term
            Str := "{sc" . Term . "}"
        }   ; いま RecentKey に sc○○ から 0x○○ に変換されたものが入っている。
            ; これを Autohotkey は十六進数の数値としてそのまま扱える

        ; ビットに変換
        if RecentKey = 0x7D         ; (JIS)\
            RecentKey := JP_YEN
        else if RecentKey = 0x73    ; (JIS)_
            RecentKey := KC_INT1
        else
            RecentKey := 1 << RecentKey

        ; キーリリース時
        if (Term == "Up")
        {
            if (spc = 1 && RecentKey = KC_SPC)  ; スペースキー単押しだったなら、空白出力
            {
                Str := "{Space}"
                StoreBuf(0, Str)
                spc := 0
            }
            OutBuf(2)
            RealKey &= RecentKey ^ (-1) ; RealKey &= ~RecentKey では
                                        ; 32ビット計算になることがあり、不適切
            LastKeys := RealKey
            RepeatKey := 0  ; リピート解除
        }
        else if (RecentKey = KC_SPC)
        {   ; スペースキー(シフト)が押された時
            spc := 1
            OutBuf(2)
            RealKey |= KC_SPC
            RepeatKey := 0  ; リピート解除
        }
        ; スペース以外のキーが押された時
        else if (!(RealKey & RecentKey) || RecentKey = RepeatKey)
        {
            spc := 0
            RealKey |= RecentKey
            nkeys := 0  ; 何キー同時押しか、を入れる変数

            ; 3キー入力を検索
            i := BeginTable[3]  ; 検索開始場所の設定
            KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys | Last2Keys
            while (i < EndTable[3])
            {
                if ((Key[i] & RecentKey)            ; 今回のキーを含み
                    && (Key[i] & KeyComb) = key[i]  ; 検索中のキー集合が、いま調べている定義にあり
                    && (Key[i] & KC_SPC) = (KeyComb & KC_SPC)   ; ただしシフトの相違はなく
                    && ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
                {                                   ; かな入力中なら、かな定義が、英数入力中なら英数定義があること
                    nkeys := 3
                    if _lks >= 2
                        nBack := 1  ; 前回が2キー、3キー同時押しだったら、1文字消して仮出力バッファへ
                    else
                        nBack := 2  ; 前回が1キー入力だったら、2文字消して仮出力バッファへ
                    ; 出力する文字列を選択
                    Str := SelectStr(i)
                    ; 仮出力バッファに入れる
                    StoreBuf(nBack, Str, KeyDelay[i])
                    OutBuf(2)   ; 3キー同時押しは全て出力が確定する
                    Last2Keys := 0
                    LastKeys :=  Key[i]
                    break
                }
                i++
            }
            ; 2キー入力を検索
            if nkeys = 0
            {
                i := BeginTable[2]  ; 検索開始場所の設定
                KeyComb := (RealKey & KC_SPC) | RecentKey | LastKeys
                while (i < EndTable[2])
                {
                    if ((Key[i] & RecentKey)
                        && (Key[i] & KeyComb) = key[i]
                        && (Key[i] & KC_SPC) = (KeyComb & KC_SPC)
                        && ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
                    {
                        nkeys := 2
                        if _lks >= 2    ; 2キー同時→2キー同時 は出力確定
                            OutBuf(2)
                        ; 出力する文字列を選択
                        Str := SelectStr(i)
                        ; 仮出力バッファに入れる
                        StoreBuf(1, Str, KeyDelay[i])
                        if ((KanaMode && KanaSetted[i]) || (!KanaMode && EisuSetted[i]))
                            OutBuf(2)   ; 出力確定
                        Last2Keys := 0
                        LastKeys :=  Key[i]
                        break
                    }
                    i++
                }
            }
            ; 1キー入力を検索
            if nkeys = 0
            {
                i := BeginTable[1]  ; 検索開始場所の設定
                KeyComb := (RealKey & KC_SPC) | RecentKey
                while (i < EndTable[1])
                {
                    if (Key[i] = KeyComb
                        && ((KanaMode && Kana[i] != "") || (!KanaMode && Eisu[i] != "")))
                    {
                        nkeys := 1
                        ; 出力する文字列を選択
                        Str := SelectStr(i)
                        ; 仮出力バッファに入れる
                        StoreBuf(0, Str, KeyDelay[i])
                        if ((KanaMode && KanaSetted[i]) || (!KanaMode && EisuSetted[i]))
                            OutBuf(2)   ; 出力確定
                        Last2Keys := LastKeys
                        LastKeys := RecentKey
                        break
                    }
                    i++
                }
            }
            if nkeys = 0    ; 見つからなかった時
            {
                nkeys := 1
                if (RealKey & KC_SPC)   ; シフト
                    Str := "+" . Str
                StoreBuf(0, Str)
                Last2Keys := LastKeys
                LastKeys := RecentKey
            }
            _lks := nkeys
            if (Repeatable[i] != "")
                RepeatKey := RecentKey  ; キーリピートできる
;MsgBox, , , Test: %RepeatKey%, 1   ; デバッグ用
        }
    }

    if (Reset)  ; リセットが押された時
    {
        StoreBuf(2, "")     ; 仮出力バッファをクリア
        spc := 0, RealKey := 0, LastKeys := 0, Last2Keys := 0
        Reset := 0
    }

    run := 0    ; 入力バッファが空になったので、処理終了
    return
}


; キー入力部(シフトなし)
sc02::  ; 1
sc03::  ; 2
sc04::  ; 3
sc05::  ; 4
sc06::  ; 5
sc07::  ; 6
sc08::  ; 7
sc09::  ; 8
sc0A::  ; 9
sc0B::  ; 0
sc0C::  ; -
sc0D::  ; (JIS)^    (US)=
sc7D::  ; (JIS)\
sc10::  ; Q
sc11::  ; W
sc12::  ; E
sc13::  ; R
sc14::  ; T
sc15::  ; Y
sc16::  ; U
sc17::  ; I
sc18::  ; O
sc19::  ; P
sc1A::  ; (JIS)@    (US)[
sc1B::  ; (JIS)[    (US)]
sc1E::  ; A
sc1F::  ; S
sc20::  ; D
sc21::  ; F
sc22::  ; G
sc23::  ; H
sc24::  ; J
sc25::  ; K
sc26::  ; L
sc27::  ; ;
sc28::  ; (JIS):    (US)'
sc2B::  ; (JIS)]    (US)＼
sc2C::  ; Z
sc2D::  ; X
sc2E::  ; C
sc2F::  ; V
sc30::  ; B
sc31::  ; N
sc32::  ; M
sc33::  ; ,
sc34::  ; .
sc35::  ; /
sc73::  ; (JIS)_
sc39::  ; Space
; キー押上げ
sc02 Up::   ; 1
sc03 Up::   ; 2
sc04 Up::   ; 3
sc05 Up::   ; 4
sc06 Up::   ; 5
sc07 Up::   ; 6
sc08 Up::   ; 7
sc09 Up::   ; 8
sc0A Up::   ; 9
sc0B Up::   ; 0
sc0C Up::   ; -
sc0D Up::   ; (JIS)^    (US)=
sc7D Up::   ; (JIS)\
sc10 Up::   ; Q
sc11 Up::   ; W
sc12 Up::   ; E
sc13 Up::   ; R
sc14 Up::   ; T
sc15 Up::   ; Y
sc16 Up::   ; U
sc17 Up::   ; I
sc18 Up::   ; O
sc19 Up::   ; P
sc1A Up::   ; (JIS)@    (US)[
sc1B Up::   ; (JIS)[    (US)]
sc1E Up::   ; A
sc1F Up::   ; S
sc20 Up::   ; D
sc21 Up::   ; F
sc22 Up::   ; G
sc23 Up::   ; H
sc24 Up::   ; J
sc25 Up::   ; K
sc26 Up::   ; L
sc27 Up::   ; ;
sc28 Up::   ; (JIS):    (US)'
sc2B Up::   ; (JIS)]    (US)＼
sc2C Up::   ; Z
sc2D Up::   ; X
sc2E Up::   ; C
sc2F Up::   ; V
sc30 Up::   ; B
sc31 Up::   ; N
sc32 Up::   ; M
sc33 Up::   ; ,
sc34 Up::   ; .
sc35 Up::   ; /
sc73 Up::   ; (JIS)_
sc39 Up::   ; Space
    ; 入力バッファへ保存
    InBuf[InBufWrite] := A_ThisHotkey, InBufTime[InBufWrite] := A_TickCount
        , InBufWrite -= InBufRest ? (++InBufWrite > 16 ? 16 : 0) : 0
        , InBufRest -= InBufRest ? 1 : 0
    Convert()   ; 変換ルーチン
    return

~Esc::  ; 放し忘れのキーをなくすリセットを兼ねる
    Reset := 1
    Convert()
    return
