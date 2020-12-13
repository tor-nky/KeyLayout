; ----------------------------------------------------------------------
; Apple Pro Keyboard 英語キーボード + MS-IME用
;   Mac 英語キーボードかな配列
;       (左Winキー→英数入力、右Winキー→(単打)かな入力(連打)再変換）
;       かな入力モード
; ----------------------------------------------------------------------
#SingleInstance force
SetStoreCapslockMode, off    ; Sendコマンド実行時にCapsLockの状態を自動的に変更しない

#Include IME.ahk    ; 参考: https://w.atwiki.jp/eamat/pages/17.html
#MenuMaskKey vk07   ; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する

SetKeyDelay, 0, 0   ; キーストローク間のディレイを、不具合が起きなければ小さくする

LastTickCount := A_TickCount    ; OSが起動してからの経過時間(ミリ秒)を保存

$+sc0C::        ; (US)Shift - → ほ
    if (!IME_GET()) ; IME OFF の時
        send, +{sc0C}
    else
        send, {sc0C}
    return
$sc0D::     ; (US)= → ゜
    if (!IME_GET()) ; IME OFF の時
        send, {sc0D}
    else
        send, {sc1B}
    return
$+sc0D::    ; (US)Shift = → 「
    if (!IME_GET()) ; IME OFF の時
        send, +{sc0D}
    else
        send, +[
    return
$+sc1A::    ; (US)[ → 」
    if (!IME_GET()) ; IME OFF の時
        send, +{sc1A}
    else
        send, +]
    return
$sc1B::     ; (US)] → む
    if (!IME_GET()) ; IME OFF の時
        send, {sc1B}
    else
        send, {sc2B}
    return
$+sc1B::    ; (US)Shift ] → ー
    if (!IME_GET()) ; IME OFF の時
        send, +{sc1B}
    else
        send, _
    return
$+sc28::    ; (US)' → ろ
    if (!IME_GET()) ; IME OFF の時
        send, +{sc28}
    else
        send, ~
    return
$sc2B::     ; (US)＼ → へ
    if (!IME_GET()) ; IME OFF の時
        send, {sc2B}
    else
        send, {sc0D}
    return
$+sc2B::    ; (US)Shift ＼ → へ
    if (!IME_GET()) ; IME OFF の時
        send, +{sc2B}
    else
        send, {sc0D}
    return


; ----------------------------------------------------------------------
; 左 Win キーの空打ちで IME を「英数」に切り替え
; 右 Win キーの空打ちで IME を「かな」に切り替え
; Win キーを押している間に他のキーを打つと通常の Win キーとして動作
; ----------------------------------------------------------------------
; 参考: WindowsのAlt空打ちで日本語入力(IME)を切り替えるツールを作った
;       http://www.karakaram.com/alt-ime-on-off
; アクティブになるのを抑制
$*~LWin::Send {Blind}{vk07}
$*~RWin::Send {Blind}{vk07}

; 左 Win 空打ちで IME を OFF
$LWin up::
    if (A_PriorHotkey == "$*~LWin")
    {
        GetKeyState, state, Shift
        if state = U
        {
            send, {vkF2}    ; ひらがな(IMEオンを兼ねる)
            send, {vkF3}    ; 半角/全角キー
        }
        else
        {
            IME_SET(1)                      ; IMEオン
            IME_SetConvMode(IMEMode := 24)  ; IME 入力モード    全英数
        }
    }
    return
; 右 Win 空打ちで IME を ON
$RWin up::
    if (A_PriorHotkey == "$*~RWin")
    {
        GetKeyState, state, Shift
        send, {vkF2}    ; ひらがな(IMEオンを兼ねる)
        send, {vkF2}    ; ひらがな(旧MS-IME対策)
        if state = U
        {
            if (A_TickCount - LastTickCount < 200)
                send, {vk1C}    ; 2連打で 変換キー 入力
            LastTickCount := A_TickCount    ; OSが起動してからの経過時間(ミリ秒)を保存
        }
        else
            send, {vkF1}    ; カタカナ
    }
    return
