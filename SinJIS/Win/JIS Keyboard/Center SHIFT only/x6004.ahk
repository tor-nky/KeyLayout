;
;  Copyright 2017 Esrille Inc.
;
;  Licensed under the Apache License, Version 2.0 (the "License");
;  you may not use this file except in compliance with the License.
;  You may obtain a copy of the License at
;
;      http://www.apache.org/licenses/LICENSE-2.0
;
;  Unless required by applicable law or agreed to in writing, software
;  distributed under the License is distributed on an "AS IS" BASIS,
;  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  See the License for the specific language governing permissions and
;  limitations under the License.
;
; Original Script
;     https://github.com/esrille/new-stickney/blob/master/ahk/x6004.ahk
;     https://github.com/esrille/new-stickney/blob/master/ahk/NewStickney.ahk
; Arranged by Satoru NAKAYA
;   主な書き換え箇所
;     Windows 10 version 2004 の MS-IME に対応させるため、ローマ字入力化。
;     シフトを増やしやすくするため、実装方法を変更。
;   追加箇所
;     シフト状態をタスクバーのアイコンで表示。
;     IME 操作
; ----------------------------------------------------------------------
; 106日本語キーボード + MS-IME用
;   新JISかな配列(スペースバー→前置・連続シフト、変換キー→スペース)
;       (無変換キー→英数入力、ひらがなキー→(単打)かな入力(連打)再変換）
;       ローマ字入力モード
; ----------------------------------------------------------------------

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input    ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
SetStoreCapslockMode, off   ; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

#Include IME.ahk    ; 参考: https://w.atwiki.jp/eamat/pages/17.html

SetBatchLines, -1           ; 自動Sleepなし
#MenuMaskKey vk07           ; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する
#UseHook                    ; ホットキーはすべてフックを使用する
Process, Priority, , High   ; プロセスの優先度を変更
SetKeyDelay, 0, 0           ; キーストローク間のディレイを、不具合が起きなければ小さくする
SetTimer, OnTimer, 250      ; 指定サブルーチンを0.25秒ごとに実行されるようにする

Qwerty := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "{sc1A}"
    , "a", "s", "d", "f", "g", "h", "j", "k", "l", "{sc27}", "{sc28}"
    , "z", "x", "c", "v", "b", "n", "m", ",", ".", "/"
    , "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    , "-", "{sc0D}", "{sc7D}", "{sc1B}", "{sc2B}", "{sc73}"]

Kana := [ "so", "ke", "se", "te", "xyo", "tu", "nn", "no", "wo", "ri", "ti"
    , "ha", "ka", "si", "to", "ta", "ku", "u", "i", "ﾞ", "ki", "na"
    , "su", "ko", "ni", "sa", "a", "xtu", "ru", ",", ".", "re"
    , "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    , "-", "{sc0D}", "{sc7D}", "{sc1B}", "{sc2B}", "{NumpadDiv}"]

KanaShift := ["xa", "ﾟ", "ho", "hu", "me", "hi", "e", "mi", "ya", "nu", "["
    , "xi", "he", "ra", "xyu", "yo", "ma", "o", "mo", "wa", "yu", "]"
    , "xu", "xe", "xo", "ne", "xya", "mu", "ro", "/", "-", "+/"
    , "+1", "+2", "+3", "+4", "+5", "+6", "+7", "+8", "+9", "_"
    , "+-", "~", "+{sc7D}", "+{sc1B}", "+{sc2B}", ":"]

IMEMode := 0    ; IME 入力モード(IME.ahk に準ずる)
                ;               0: 直接入力 or 半英固定, 24: 全角固定,
                ;               25: ひらがな, 27: カタカナ
ShiftState := 0 ; シフトの状態  0: アンシフト,
                ;               1: 前置シフトキーを押下中, 2: 前置シフトオン
                ;               3: 連続シフト中,
                ;               4: スペースバー単独押下中(連続シフト待機)
                ;               128: リピート中
                ;               8: 16: 32: 64: ・・・未定義
Last := " "
LastIcon := -1  ; アイコンの状態を記憶  0: 英字モード,
                ;                       1: 仮名モード,アンシフト, 2: 仮名モード,シフト
IconTimer := 0

exit    ; 初期設定はここまで
; ----------------------------------------------------------------------

OnTimer:    ;タイマーに割り当てられるサブルーチンラベル
    Detect := IME_GetConvMode() ; IME の状態を検出
    if (Detect)
    {
        if (!IME_GET())         ; IME OFF の時
            IMEMode := 0
        else if (IMEMode != Detect)
        {                       ; IME ON の時
            IMEMode := Detect
            Last := " "
        }
        ChangeIcon()
        IconTimer := 8
    }
    else if IconTimer > 0       ; IME の状態が検出できない時、2秒間アイコンで表示
    {
        IMEMode := 0
        LastIcon := -1
        Menu, TRAY, Icon, x6004_UD.ico
        IconTimer--
    }
    else if IconTimer = 0
        ChangeIcon()
    return      ;タイマーサブルーチンの終了

ChangeIcon()
{
    global ShiftState, IMEMode, LastIcon, IconTimer

    IconTimer := -1
    if (!(IMEMode & 1) && LastIcon)
    {
        LastIcon := 0
        Menu, TRAY, Icon, x6004_0.ico
    }
    else if (IMEMode & 1)
    {
        if (!ShiftState && LastIcon != 1)
        {
            LastIcon := 1
            Menu, TRAY, Icon, x6004_1.ico
        }
        else if (ShiftState && LastIcon != 2)
        {
            LastIcon := 2
            Menu, TRAY, Icon, x6004_2.ico
        }
    }
    return
}

OnKeypress(keyName)
{
    global Qwerty, Kana, KanaShift, ShiftState, IMEMode, Last

    Detect := IME_GetConvMode() ; IME の状態を検出
    if (Detect)
    {
        if (!IME_GET())         ; IME OFF の時
            IMEMode := 0
        else if (IMEMode != Detect)
        {                       ; IME ON の時
            IMEMode := Detect
            Last := " "
        }
    }
    else if IconTimer >= 0
        IMEMode := 0

    state := GetKeyState("Shift", "P")  ; Shiftを押しているか保存
    if (GetKeyState("LWin", "P")        ; Win, Alt, Ctrl を併用の場合
        || GetKeyState("RWin", "P")
        || GetKeyState("Alt", "P")
        || GetKeyState("Control", "P"))
    {
        c := Qwerty[keyName]
        send, {Blind}%c%        ; そのまま出力
        Last := " "
    }
    else if (!(IMEMode & 1) || state)   ; Shiftを押しているか英字モードの場合
    {
        if (keyName = 42 && state)
            keyName := 48   ; Shift + 0 → _
        c := Qwerty[keyName]
        send, {Blind}%c%
        Last := " "
    }
    else    ; かなを変換して出力
    {
        if (ShiftState)
        {
            c := KanaShift[keyName]
;           if ShiftState = 132     ; 変換中のリピートを止める
;               send, +{Esc}
        }
        else
            c := Kana[keyName]
        ; 濁点
        if (c == "ﾞ")
        {
            pos := InStr("ksthu", SubStr(Last, 1, 1))
            if (pos)
            {
                Send, {BS}
                if pos < 5
                    c := SubStr("gzdb", pos, 1) . SubStr(Last, 2)
                else
                    c := "vu"
            }
            else
                c := " "
        }
        ; 半濁点
        else if (c == "ﾟ")
        {
            if (SubStr(Last, 1, 1) == "h")
            {
                Send, {BS}
                c := "p" . SubStr(Last, 2)
            }
            else
                c := " "
        }
        if (c != " ")
            send, % c
        Last := c
    }

    if ShiftState = 2
        ShiftState := 0
    else if (ShiftState)
        ShiftState := 3
    ChangeIcon()
    return
}

$*q::OnKeypress(1)
$*w::OnKeypress(2)
$*e::OnKeypress(3)
$*r::OnKeypress(4)
$*t::OnKeypress(5)
$*y::OnKeypress(6)
$*u::OnKeypress(7)
$*i::OnKeypress(8)
$*o::OnKeypress(9)
$*p::OnKeypress(10)
$*sc1A::OnKeypress(11)  ; (JIS)@    (US)[
$*a::OnKeypress(12)
$*s::OnKeypress(13)
$*d::OnKeypress(14)
$*f::OnKeypress(15)
$*g::OnKeypress(16)
$*h::OnKeypress(17)
$*j::OnKeypress(18)
$*k::OnKeypress(19)
$*l::OnKeypress(20)
$*sc27::OnKeypress(21)  ; (共通);
$*sc28::OnKeypress(22)  ; (JIS):    (US)'
$*z::OnKeypress(23)
$*x::OnKeypress(24)
$*c::OnKeypress(25)
$*v::OnKeypress(26)
$*b::OnKeypress(27)
$*n::OnKeypress(28)
$*m::OnKeypress(29)
$*,::OnKeypress(30)
$*.::OnKeypress(31)
$*/::OnKeypress(32)
$*1::OnKeypress(33)
$*2::OnKeypress(34)
$*3::OnKeypress(35)
$*4::OnKeypress(36)
$*5::OnKeypress(37)
$*6::OnKeypress(38)
$*7::OnKeypress(39)
$*8::OnKeypress(40)
$*9::OnKeypress(41)
$*0::OnKeypress(42)
$*-::OnKeypress(43)
$*sc0D::OnKeypress(44)  ; (JIS)^    (US)=
$*sc7D::OnKeypress(45)  ; (JIS)\
$*sc1B::OnKeypress(46)  ; (JIS)[    (US)]
$*sc2B::OnKeypress(47)  ; (JIS)]    (US)＼
$*sc73::OnKeypress(48)  ; (JIS)_

$*Space::
    if (!(IMEMode & 1)      ; Win, Alt, Ctrl を使ったり、英字モードの場合
        || GetKeyState("LWin", "P")
        || GetKeyState("RWin", "P")
        || GetKeyState("Alt", "P")
        || GetKeyState("Control", "P")
        || GetKeyState("Shift", "P"))
    {
        send, {Blind}{Space}
        Last := " "
    }
;   else if (ShiftState & 4)    ; スペースキーのリピート
;   {
;       send, {Blind}{Space}
;       ShiftState |= 128
;   }
    else
    {
        ; スペースバーを前置シフトとして使う場合、この下４行を有効にする
        if (ShiftState)
            ShiftState := 3
        else
            ShiftState := 1

        ; スペースバーを連続シフトとして使い、単独押下ではスペース入力
        ; にするには、この下１行を有効にする
;       ShiftState := 4

        ChangeIcon()
    }
    return
;$~Shift::
;   if (ShiftState)
;       ShiftState := 3
;   else
;       ShiftState := 1
;   ChangeIcon()
;   return
$Space Up::
;$~Shift Up::
    if ShiftState = 1
        ShiftState := 2
    else if (!GetKeyState("Shift", "P"))
    {
        if ShiftState = 4
        {
            send, {Space}
            Last := " "
        }
        ShiftState := 0
        ChangeIcon()
    }
    return
$sc29::     ; 半角/全角キー
$!sc29::    ; 漢字キー
    send, {vkF2}    ; ひらがな(IMEオンを兼ねる)
    if (IMEMode & 1)
    {
        send, {vkF0}    ; 英数キー
        IMEMode := 0    ; IME 入力モード    半英数
    }
    else
    {
        send, {vkF2}    ; ひらがな(旧MS-IME対策)
        IMEMode := 25   ; IME 入力モード    ひらがな
        Last := " "
        ShiftState := 0
    }
    ChangeIcon()
    return

; 他のキーやマウスボタンをパススルーするとともに、シフト状態を操作する
$*sc79::    ; 変換キー
    send, {Blind}{Space}
$*~F1::
$*~F2::
$*~F3::
$*~F4::
$*~F5::
$*~F6::
$*~F7::
$*~F8::
$*~F9::
$*~F10::
$*~F11::
$*~F12::
$*~Esc::
$*~Tab::
$*~LAlt::
$*~RAlt::
$*~LCtrl::
$*~RCtrl::
$*~Left::
$*~Right::
$*~Up::
$*~Down::
$*~Enter::
$*~PrintScreen::
$*~Delete::
$*~Home::
$*~End::
$*~PgUp::
$*~PgDn::
;
$*~Numpad0::
$*~Numpad1::
$*~Numpad2::
$*~Numpad3::
$*~Numpad4::
$*~Numpad5::
$*~Numpad6::
$*~Numpad7::
$*~Numpad8::
$*~Numpad9::
$*~NumpadDiv::
$*~NumpadMult::
$*~NumpadAdd::
$*~NumpadSub::
$*~NumpadEnter::
$*~LButton::
$*~LWin::
$*~RWin::
    Last := " "
    if ShiftState = 2
    {
        ShiftState := 0
        ChangeIcon()
    }
    else if (ShiftState)
        ShiftState := 3
    return

; ----------------------------------------------------------------------
; IME 操作
; ----------------------------------------------------------------------
$sc7B::     ; 無変換
$sc71 up::  ; (Apple Pro Keyboard)英数  (旧方式)
$vk1A::     ; (Apple Pro Keyboard)英数
    send, {vkF2}    ; ひらがな(IMEオンを兼ねる)
    send, {vkF0}    ; 英数キー
    IMEMode := 0    ; IME 入力モード    半英数
    ChangeIcon()
    return
$+sc7B::    ; Shift + 無変換
$+sc71 up:: ; (Apple Pro Keyboard)Shift + 英数  (旧方式)
$+vk1A::    ; (Apple Pro Keyboard)Shift + 英数
    IME_SET(1)                      ; IMEオン
    IME_SetConvMode(IMEMode := 24)  ; IME 入力モード    全英数
    ChangeIcon()
    return
$sc70::     ; ひらがな
$sc72 up::  ; (Apple Pro Keyboard)かな  (旧方式)
$vk16::     ; (Apple Pro Keyboard)かな
    if (A_PriorHotKey = A_ThisHotKey && A_TimeSincePriorHotkey < 200)
        send, {vk1C}    ; 2連打で 変換キー 入力
    else
    {
        send, {vkF2}    ; ひらがな(IMEオンを兼ねる)
        send, {vkF2}    ; ひらがな(旧MS-IME対策)
        IMEMode := 25   ; IME 入力モード    ひらがな
        ShiftState := 0
        Last := " "
        ChangeIcon()
    }
    return
$+sc70::    ; Shift + ひらがな
$+sc72 up:: ; (Apple Pro Keyboard)Shift + かな  (旧方式)
$+vk16::    ; (Apple Pro Keyboard)Shift + かな
    send, {vkF2 2}  ; ひらがな(旧MS-IME対策)
    send, {vkF1}    ; カタカナ
    IMEMode := 27   ; IME 入力モード    カタカナ
    ShiftState := 0
    Last := " "
    ChangeIcon()
    return
