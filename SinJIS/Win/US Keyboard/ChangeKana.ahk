#Include IME.ahk    ; 参考: https://w.atwiki.jp/eamat/pages/17.html

#MenuMaskKey vk07   ; Win または Alt の押下解除時のイベントを隠蔽するためのキーを変更する

SetStoreCapslockMode, off    ; Sendコマンド実行時にCapsLockの状態を自動的に変更しない
SetKeyDelay, 0, 0   ; キーストローク間のディレイを、不具合が起きなければ小さくする

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
        if state = D
            send, {vkF1}    ; カタカナ
    }
    return
