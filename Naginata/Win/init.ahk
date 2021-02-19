; Copyright 2021 Satoru NAKAYA
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

; **********************************************************************
;   3キー同時押し配列 初期設定
; **********************************************************************

; ----------------------------------------------------------------------
; 配列定義で使う変数
; ----------------------------------------------------------------------
; キーを64bitの各ビットに割り当てる
; 右側の数字は仮想キーコードになっている
KC_1    := 1 << 0x02
KC_2    := 1 << 0x03
KC_3    := 1 << 0x04
KC_4    := 1 << 0x05
KC_5    := 1 << 0x06
KC_6    := 1 << 0x07

KC_7    := 1 << 0x08
KC_8    := 1 << 0x09
KC_9    := 1 << 0x0A
KC_0    := 1 << 0x0B
KC_MINS := 1 << 0x0C
KC_EQL  := 1 << 0x0D
JP_YEN  := 1 << 0x37    ; sc7D

KC_Q    := 1 << 0x10
KC_W    := 1 << 0x11
KC_E    := 1 << 0x12
KC_R    := 1 << 0x13
KC_T    := 1 << 0x14

KC_Y    := 1 << 0x15
KC_U    := 1 << 0x16
KC_I    := 1 << 0x17
KC_O    := 1 << 0x18
KC_P    := 1 << 0x19
KC_LBRC := 1 << 0x1A
KC_RBRC := 1 << 0x1B

KC_A    := 1 << 0x1E
KC_S    := 1 << 0x1F
KC_D    := 1 << 0x20
KC_F    := 1 << 0x21
KC_G    := 1 << 0x22

KC_H    := 1 << 0x23
KC_J    := 1 << 0x24
KC_K    := 1 << 0x25
KC_L    := 1 << 0x26
KC_SCLN := 1 << 0x27
KC_QUOT := 1 << 0x28
KC_NUHS := 1 << 0x2B

KC_Z    := 1 << 0x2C
KC_X    := 1 << 0x2D
KC_C    := 1 << 0x2E
KC_V    := 1 << 0x2F
KC_B    := 1 << 0x30

KC_N    := 1 << 0x31
KC_M    := 1 << 0x32
KC_COMM := 1 << 0x33
KC_DOT  := 1 << 0x34
KC_SLSH := 1 << 0x35
KC_INT1 := 1 << 0x38    ; sc73

KC_SPC  := 1 << 0x39

; リピート定義用
R := 1


; ----------------------------------------------------------------------
; 共通変数
; ----------------------------------------------------------------------
; 入れ物の定義
Key := []           ; キービットの集合
Kana := []          ; かな定義
KanaYoko := []      ; かな定義(横書き) ※縦書きと違う場合のみ使用
KanaSetted := []    ; 1: 出力確定となる「かな」
Eisu := []          ; 英数定義
EisuSetted := []    ; 1: 出力確定となる「英数」
Repeatable := []    ; 1: リピートできる
KeyDelay := []      ; 0以外: キーストローク間のディレイ(SetKeyDelay用)を登録

BeginTable := [1001, 20001, 300001] ; 定義の始め 1キー, 2キー同時, 3キー同時
EndTable := [1001, 20001, 300001]   ; 定義の終わり 1キー, 2キー同時, 3キー同時

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
;   local count, i

    KeyComb &= KC_SPC ^ (-1)    ; スペースキーは数えない

    count := 0
    i := 0
    while (i < 64 && count < 3) ; 3になったら数えない
    {
        count += KeyComb & 1
        KeyComb >>= 1
        i++
    }
    return count
}

; 縦書き用定義から横書き用に変換
ConvTateYoko(Str)
{
;   local Temp

    StringReplace, Str, Str, {Up, {Temp, A
    StringReplace, Str, Str, {Right, {Up, A
    StringReplace, Str, Str, {Down, {Right, A
    StringReplace, Str, Str, {Left, {Down, A
    StringReplace, Str, Str, {Temp, {Left, A

    return Str
}

; 機能置き換え処理 - DvorakJ との互換用
StrReplace(Str)
{
    StringReplace, Str, Str, {確定}{改行},  {Enter 2},      A
    StringReplace, Str, Str, {確定},        n^{Enter}{BS},  A   ; かな配列専用
;   StringReplace, Str, Str, {確定},        nn^{Enter}{BS}, A   ; 行段・かな配列共用

    StringReplace, Str, Str, {→,           {Right,     A
    StringReplace, Str, Str, {->,           {Right,     A
    StringReplace, Str, Str, {右,           {Right,     A
    StringReplace, Str, Str, {←,           {Left,      A
    StringReplace, Str, Str, {<-,           {Left,      A
    StringReplace, Str, Str, {左,           {Right,     A
    StringReplace, Str, Str, {↑,           {Up,        A
    StringReplace, Str, Str, {上,           {Up,        A
    StringReplace, Str, Str, {↓,           {Down,      A
    StringReplace, Str, Str, {下,           {Down,      A
    StringReplace, Str, Str, {ペースト},    ^v,         A
    StringReplace, Str, Str, {貼付},        ^v,         A
    StringReplace, Str, Str, {貼り付け},    ^v,         A
    StringReplace, Str, Str, {カット},      ^x,         A
    StringReplace, Str, Str, {切取},        ^x,         A
    StringReplace, Str, Str, {切り取り},    ^x,         A
    StringReplace, Str, Str, {コピー},      ^c,         A
    StringReplace, Str, Str, {無変換,       {vk1D,      A
    StringReplace, Str, Str, {変換,         {vk1C,      A
    StringReplace, Str, Str, {ひらがな,     {vkF2,      A
    StringReplace, Str, Str, {改行,         {Enter,     A
    StringReplace, Str, Str, {後退,         {BS,        A
    StringReplace, Str, Str, {取消,         {Esc,       A
    StringReplace, Str, Str, {削除,         {Del,       A
    StringReplace, Str, Str, {全角,         {vkF3,      A
    StringReplace, Str, Str, {タブ,         {Tab,       A
    StringReplace, Str, Str, {空白          {Space,     A
    StringReplace, Str, Str, {メニュー,     {AppsKey,   A

    StringReplace, Str, Str, {Caps Lock,    {vkF0,      A
    StringReplace, Str, Str, {Back Space,   {BS,        A

    return Str
}

; かな定義登録  (定義が多すぎても警告は出ません)
SetKana(KeyComb, TateStr, Repeat:=0, Delay:=-2)
{
    global Key, Kana, KanaYoko, Repeatable, KeyDelay
        , BeginTable, EndTable
;   local nkeys     ; 何キー同時押しか
;       , i         ; カウンタ
;       , YokoStr

    TateStr := StrReplace(TateStr)  ; 機能置き換え処理

    nkeys := CountBit(KeyComb)  ; 何キー同時押しか
    i := BeginTable[nkeys]
    while (i < EndTable[nkeys])
    {
        if (Key[i] = KeyComb && Kana[i] != "")  ; 定義の重複があったら、古いのを消す
        {
            Key[i] := ""
            Kana[i] := ""
            KanaYoko[i] := ""
            Repeatable[i] := ""
            KeyDelay[i] := ""
        }
        i++
    }
    if (TateStr != "")  ; 定義あり
    {
;       i := EndTable[nkeys]
        Key[i] := KeyComb
        Kana[i] := TateStr
        YokoStr := ConvTateYoko(TateStr)    ; 縦横変換
        if (YokoStr != TateStr)
            KanaYoko[i] := YokoStr
        Repeatable[i] := Repeat
        KeyDelay[i] := Delay
        EndTable[nkeys]++
    }

    return
}

; 英数定義登録  (定義が多すぎても警告は出ません)
SetEisu(KeyComb, TateStr, Repeat:=0, Delay:=-2)
{
    global Key, Eisu, EisuYoko, Repeatable, KeyDelay
        , BeginTable, EndTable
;   local nkeys     ; 何キー同時押しか
;       , i         ; カウンタ
;       , YokoStr

    TateStr := StrReplace(TateStr)  ; 機能置き換え処理

    nkeys := CountBit(KeyComb)  ; 何キー同時押しか
    i := BeginTable[nkeys]
    while (i < EndTable[nkeys])
    {
        if (Key[i] = KeyComb && Eisu[i] != "")  ; 定義の重複があったら、古いのを消す
        {
            Key[i] := ""
            Eisu[i] := ""
            EisuYoko[i] := ""
            Repeatable[i] := ""
            KeyDelay[i] := ""
        }
        i++
    }
    if (TateStr != "")  ; 定義あり
    {
;       i := EndTable[nkeys]
        Key[i] := KeyComb
        Eisu[i] := TateStr
        YokoStr := ConvTateYoko(TateStr)    ; 縦横変換
        if (YokoStr != TateStr)
            EisuYoko[i] := YokoStr
        Repeatable[i] := Repeat
        KeyDelay[i] := Delay
        EndTable[nkeys]++
    }

    return
}

; かな定義で出力確定する組み合わせに印をつける
KanaSetting()
{
    global Key, Kana, KanaSetted
        , BeginTable, EndTable
;   local i, j  ; カウンタ

    ; 3キー同時押しは全て出力が確定する
    i := BeginTable[3]
    while (i < EndTable[3])
    {
        if (Kana[i] != "")
            KanaSetted[i] := 1
        i++
    }

    ; 2キー同時押しのキーが、3キー同時押しで使われていなければ、出力が確定する
    i := BeginTable[2]
    while (i < EndTable[2])
    {
        if (Kana[i] != "")
        {
            j := BeginTable[3]
            while (j < EndTable[3])
            {
                if (Kana[i] != ""                           ; かな定義があり
                 && (Key[i] & Key[j]) = Key[i]              ; 2キー同時押し Key[i] は、
                                                            ; 3キー同時押し Key[j] に内包されている。
                 && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))  ; ただしシフトの相違はない
                    break   ; まだ出力は確定しない
                j++
            }
            if (j >= EndTable[3])
                KanaSetted[i] := 1
        }
        i++
    }

    ; 1キー押しのキーが、3キー、2キー同時押しで使われていなければ、出力が確定する
    i := BeginTable[1]
    while (i < EndTable[1])
    {
        if (Kana[i] != "")
        {
            j := BeginTable[3]
            while (j < EndTable[3])
            {
                if (Kana[i] != "" && (Key[i] & Key[j]) = Key[i] && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))
                    break
                j++
            }
            if (j >= EndTable[3])
            {
                j := BeginTable[2]
                while (j < EndTable[2])
                {
                    if (Kana[i] != "" && (Key[i] & Key[j]) = Key[i] && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))
                        break
                    j++
                }
                if (j >= EndTable[2])
                    KanaSetted[i] := 1
            }
        }
        i++
    }

    return
}

; 英数定義で出力確定する組み合わせに印をつける
EisuSetting()
{
    global Key, Eisu, EisuSetted
        , BeginTable, EndTable
;   local i, j  ; カウンタ

    ; 3キー同時押しは全て出力が確定する
    i := BeginTable[3]
    while (i < EndTable[3])
    {
        if (Eisu[i] != "")
            EisuSetted[i] := 1
        i++
    }

    ; 2キー同時押しのキーが、3キー同時押しで使われていなければ、出力が確定する
    i := BeginTable[2]
    while (i < EndTable[2])
    {
        if (Eisu[i] != "")
        {
            j := BeginTable[3]
            while (j < EndTable[3])
            {
                if (Eisu[j] != ""                           ; 英数定義があり
                 && (Key[i] & Key[j]) = Key[i]              ; 2キー同時押し Key[i] は、
                                                            ; 3キー同時押し Key[j] に内包されている。
                 && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))  ; ただしシフトの相違はない
                    break
                j++
            }
            if (j >= EndTable[3])
                EisuSetted[i] := 1
        }
        i++
    }

    ; 1キー押しのキーが、3キー、2キー同時押しで使われていなければ、出力が確定する
    i := BeginTable[1]
    while (i < EndTable[1])
    {
        if (Eisu[i] != "")
        {
            j := BeginTable[3]
            while (j < EndTable[3])
            {
                if (Eisu[j] != "" && (Key[i] & Key[j]) = Key[i] && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))
                    break
                j++
            }
            if (j >= EndTable[3])
            {
                j := BeginTable[2]
                while (j < EndTable[2])
                {
                    if (Eisu[j] != "" && (Key[i] & Key[j]) = Key[i] && (Key[i] & KC_SPC) = (Key[j] & KC_SPC))
                        break
                    j++
                }
                if (j >= EndTable[2])
                    EisuSetted[i] := 1
            }
        }
        i++
    }

    return
}
