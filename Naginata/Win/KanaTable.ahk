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

; ----------------------------------------------------------------------
; 英数／かな配列の定義ファイル 【すべて縦書き用で書くこと】
;
; 例：  SetKana( KC_Q | KC_L | KC_SPC       ,"xwa"  , R, 10)    ; (ゎ)
;       ~~~~~~~  ~~~~~~~~~~~~~~~~~~~~         ~~~     ~  ~~       ~~~~
;       かな定義    スペース+Q+L        変換後の出力  ↑ ↑     コメント
;                                                     ↑ ↑
;                                   リピートあり(省略可)  ディレイ[ms](省略可)
;
; 例：   SetEisu( KC_H | KC_J           ,"{vkF2 2}"     )   ; IME ON
;        ~~~~~~~
;        英数定義
;
;   ※再読み込みか、再起動で有効になります
;   ※全角空白の違いが見えるエディタを使うことをおすすめします
;   ※UTF-8(BOM付)で保存してください
;   ※順序は自由です。同じキーの組み合わせがあると上書きします。
; ----------------------------------------------------------------------

;#Include init.ahk


; 固有名詞ショートカット
; 上段人差指＋中指
    SetKana( KC_U | KC_I | KC_1     ,"")
    SetKana( KC_U | KC_I | KC_2     ,"")
    SetKana( KC_U | KC_I | KC_3     ,"")
    SetKana( KC_U | KC_I | KC_4     ,"")
    SetKana( KC_U | KC_I | KC_5     ,"")
    SetKana( KC_E | KC_R | KC_6     ,"")
    SetKana( KC_E | KC_R | KC_7     ,"")
    SetKana( KC_E | KC_R | KC_8     ,"")
    SetKana( KC_E | KC_R | KC_9     ,"")
    SetKana( KC_E | KC_R | KC_0     ,"")
    SetKana( KC_E | KC_R | KC_MINS  ,"")
    SetKana( KC_E | KC_R | KC_EQL   ,"")
    SetKana( KC_E | KC_R | JP_YEN   ,"")

    SetKana( KC_U | KC_I | KC_Q     ,"臨兵闘者皆陣烈在前")
    SetKana( KC_U | KC_I | KC_W     ,"ネムカケ")
    SetKana( KC_U | KC_I | KC_E     ,"天狗")
    SetKana( KC_U | KC_I | KC_R     ,"シンイチ")
    SetKana( KC_U | KC_I | KC_T     ,"")
    SetKana( KC_E | KC_R | KC_Y     ,"才一")
    SetKana( KC_E | KC_R | KC_U     ,"さくら")
    SetKana( KC_E | KC_R | KC_I     ,"妖怪")
    SetKana( KC_E | KC_R | KC_O     ,"")
    SetKana( KC_E | KC_R | KC_P     ,"")
    SetKana( KC_E | KC_R | KC_LBRC  ,"")
    SetKana( KC_E | KC_R | KC_RBRC  ,"")

    SetKana( KC_U | KC_I | KC_A     ,"")
    SetKana( KC_U | KC_I | KC_S     ,"")
    SetKana( KC_U | KC_I | KC_D     ,"")
    SetKana( KC_U | KC_I | KC_F     ,"心の闇")
    SetKana( KC_U | KC_I | KC_G     ,"")
    SetKana( KC_E | KC_R | KC_H     ,"鞍馬")
    SetKana( KC_E | KC_R | KC_J     ,"青鬼")
    SetKana( KC_E | KC_R | KC_K     ,"")
    SetKana( KC_E | KC_R | KC_L     ,"")
    SetKana( KC_E | KC_R | KC_SCLN  ,"")
    SetKana( KC_E | KC_R | KC_QUOT  ,"")
    SetKana( KC_E | KC_R | KC_NUHS  ,"")
    SetKana( KC_E | KC_R | KS_BSLS  ,"")

    SetKana( KC_U | KC_I | KC_Z     ,"火よ、在れ")
    SetKana( KC_U | KC_I | KC_X     ,"火の剣")
    SetKana( KC_U | KC_I | KC_C     ,"小鴉")
    SetKana( KC_U | KC_I | KC_V     ,"光太郎")
    SetKana( KC_U | KC_I | KC_B     ,"峯")
    SetKana( KC_E | KC_R | KC_N     ,"鬼塚")
    SetKana( KC_E | KC_R | KC_M     ,"")
    SetKana( KC_E | KC_R | KC_COMM  ,"")
    SetKana( KC_E | KC_R | KC_DOT   ,"")
    SetKana( KC_E | KC_R | KC_SLSH  ,"不動金縛りの術")
    SetKana( KC_E | KC_R | KC_INT1  ,"")


; IME ON/OFF
; HJ: ON / FG: OFF
    SetKana( KC_H | KC_J            ,"{vkF2 2}"     )   ; IME ON
    SetEisu( KC_H | KC_J            ,"{vkF2 2}"     )
    SetKana( KC_F | KC_G            ,"{vkF2}{vkF3}" )   ; IME OFF
    SetEisu( KC_F | KC_G            ,"{vkF2}{vkF3}" )
    SetKana( KC_V | KC_M            ,"{Enter}"      )   ; 行送り
    SetKana( KC_V | KC_M | KC_SPC   ,"{Enter}"      )

; 英数編集モード
    SetEisu( KC_V | KC_M            ,"{Enter}"      )   ; 行送り
    SetEisu( KC_V | KC_M | KC_SPC   ,"{Enter}"      )


; 編集モード１
; 中段人差し指＋中指を押しながら
; 「て」の部分は定義できない。「ディ」があるため

; 左手
    SetKana( KC_J | KC_K | KC_Q     ,"^{End}"           )       ; ◀最末尾
    SetKana( KC_J | KC_K | KC_W     ,"|{Enter}"         )       ; ｜
    SetKana( KC_J | KC_K | KC_R     ,"^s"               )       ; 保存
    SetKana( KC_J | KC_K | KC_T     ,"/"                )       ; ・
    SetKana( KC_J | KC_K | KC_A     ,"……{確定}"       )       ; ……
    SetKana( KC_J | KC_K | KC_S     ,"《{確定}"         )       ; 《
    SetKana( KC_J | KC_K | KC_D     ,"?{Enter}"         )       ; ？
    SetKana( KC_J | KC_K | KC_F     ,"[{Enter}"         )       ; 「
    SetKana( KC_J | KC_K | KC_G     ,"({Enter}"         )       ; （
    SetKana( KC_J | KC_K | KC_Z     ,"││{確定}"       )       ; ──
    SetKana( KC_J | KC_K | KC_X     ,"》{確定}"         )       ; 》
    SetKana( KC_J | KC_K | KC_C     ,"{!}{Enter}"       )       ; ！
    SetKana( KC_J | KC_K | KC_V     ,"]{Enter}"         )       ; 」
    SetKana( KC_J | KC_K | KC_B     ,"){Enter}"         )       ; ）

; 右手(R はリピート)
    SetKana( KC_D | KC_F | KC_Y     ,"{Home}"           )       ; ▲Home
    SetKana( KC_D | KC_F | KC_U     ,"+{End}{BS}"       )       ; 末消
    SetKana( KC_D | KC_F | KC_I     ,"{vk1C}"           )       ; 再変換
    SetKana( KC_D | KC_F | KC_O     ,"{Del}"            )       ; Del
    SetKana( KC_D | KC_F | KC_P     ,"{Esc 3}"          )       ; 入力キャンセル
    SetKana( KC_D | KC_F | KC_H     ,"{Enter}{End}"     , , 10) ; 確定End▼
    SetKana( KC_D | KC_F | KC_J     ,"{Up}"             , R)    ; ↑
    SetKana( KC_D | KC_F | KC_K     ,"+{Up}"            , R)    ; 選択↑
    SetKana( KC_D | KC_F | KC_L     ,"{Up 5}"           , R)    ; 5↑
    SetKana( KC_D | KC_F | KC_SCLN  ,"^i"               )       ; カタカナ
    SetKana( KC_D | KC_F | KC_N     ,"{End}"            )       ; End▼
    SetKana( KC_D | KC_F | KC_M     ,"{Down}"           , R)    ; ↓
    SetKana( KC_D | KC_F | KC_COMM  ,"+{Down}"          , R)    ; 選択↓
    SetKana( KC_D | KC_F | KC_DOT   ,"{Down 5}"         , R)    ; 5↓
    SetKana( KC_D | KC_F | KC_SLSH  ,"^u"               )       ; ひらがな

; 英数編集モード
; 左手
    SetEisu( KC_J | KC_K | KC_Q     ,"^{End}"           )       ; ◀最末尾
    SetEisu( KC_J | KC_K | KC_W     ,"｜"               )       ; ｜
    SetEisu( KC_J | KC_K | KC_R     ,"^s"               )       ; 保存
    SetEisu( KC_J | KC_K | KC_T     ,"・"               )       ; ・
    SetEisu( KC_J | KC_K | KC_A     ,"……"             )       ; ……
    SetEisu( KC_J | KC_K | KC_S     ,"《"               )       ; 《
    SetEisu( KC_J | KC_K | KC_D     ,"？"               )       ; ？
    SetEisu( KC_J | KC_K | KC_F     ,"「"               )       ; 「
    SetEisu( KC_J | KC_K | KC_G     ,"（"               )       ; （
    SetEisu( KC_J | KC_K | KC_Z     ,"││"             )       ; ──
    SetEisu( KC_J | KC_K | KC_X     ,"》"               )       ; 》
    SetEisu( KC_J | KC_K | KC_C     ,"！"               )       ; ！
    SetEisu( KC_J | KC_K | KC_V     ,"」"               )       ; 」
    SetEisu( KC_J | KC_K | KC_B     ,"）"               )       ; ）

; 右手(R はリピート)
    SetEisu( KC_D | KC_F | KC_Y     ,"{Home}"           )       ; ▲Home
    SetEisu( KC_D | KC_F | KC_U     ,"+{End}{BS}"       )       ; 末消
    SetEisu( KC_D | KC_F | KC_I     ,"{vk1C}"           )       ; 再変換
    SetEisu( KC_D | KC_F | KC_O     ,"{Del}"            )       ; Del
    SetEisu( KC_D | KC_F | KC_P     ,"{Esc 3}"          )       ; 入力キャンセル
    SetEisu( KC_D | KC_F | KC_H     ,"{Enter}{End}"     , , 10) ; 確定End▼
    SetEisu( KC_D | KC_F | KC_J     ,"{Up}"             , R)    ; ↑
    SetEisu( KC_D | KC_F | KC_K     ,"+{Up}"            , R)    ; 選択↑
    SetEisu( KC_D | KC_F | KC_L     ,"{Up 5}"           , R)    ; 5↑
;   SetEisu( KC_D | KC_F | KC_SCLN  ,"^i"               )       ; カタカナ
    SetEisu( KC_D | KC_F | KC_N     ,"{End}"            )       ; End▼
    SetEisu( KC_D | KC_F | KC_M     ,"{Down}"           , R)    ; ↓
    SetEisu( KC_D | KC_F | KC_COMM  ,"+{Down}"          , R)    ; 選択↓
    SetEisu( KC_D | KC_F | KC_DOT   ,"{Down 5}"         , R)    ; 5↓
;   SetEisu( KC_D | KC_F | KC_SLSH  ,"^u"               )       ; ひらがな


; 編集モード２
; 下段人差指＋中指

; 左手(最後の数字はディレイの長さ[ms])
    SetKana( KC_M | KC_COMM | KC_Q  ,"／{確定}"                             )       ; ／
    SetKana( KC_M | KC_COMM | KC_W  ,"｜{確定}{End}《》{確定}{Up}"          , , 10) ; ルビマクロ
    SetKana( KC_M | KC_COMM | KC_E  ,"{Home}{Enter}{Space 3}{End}"          , , 10) ; トマクロ
    SetKana( KC_M | KC_COMM | KC_R  ,"{Home}{Enter}{Space 1}{End}"          , , 10) ; 台マクロ
    SetKana( KC_M | KC_COMM | KC_T  ,"〇{確定}"                             )       ; ○
    SetKana( KC_M | KC_COMM | KC_A  ,"【{確定}"                             )       ; 【
    SetKana( KC_M | KC_COMM | KC_S  ,"〈{確定}"                             )       ; 〈
    SetKana( KC_M | KC_COMM | KC_D  ,"『{確定}"                             )       ; 『
    SetKana( KC_M | KC_COMM | KC_F  ,"]{Enter 2}[{Enter}"                   , , 50) ; 」「マクロ
    SetKana( KC_M | KC_COMM | KC_G  ,"{Space 3}"                            )       ; □□□
    SetKana( KC_M | KC_COMM | KC_Z  ,"】{確定}"                             )       ; 】
    SetKana( KC_M | KC_COMM | KC_X  ,"〉{確定}"                             )       ; 〉
    SetKana( KC_M | KC_COMM | KC_C  ,"』{確定}"                             )       ; 』
    SetKana( KC_M | KC_COMM | KC_V  ,"]{Enter 2}{Space}"                    , , 50) ; 」□マクロ
    SetKana( KC_M | KC_COMM | KC_B  ,"　　　×　　　×　　　×{確定}{Enter}")       ; x  x   x

; 右手(R はリピート)
    SetKana( KC_C | KC_V | KC_Y     ,"+{Home}"                          )       ; ▲Home選択
    SetKana( KC_C | KC_V | KC_U     ,"^x"                               )       ; カット
    SetKana( KC_C | KC_V | KC_I     ,"^v"                               )       ; ペースト
    SetKana( KC_C | KC_V | KC_O     ,"^y"                               )       ; リドゥ
    SetKana( KC_C | KC_V | KC_P     ,"^z"                               )       ; アンドゥ
    SetKana( KC_C | KC_V | KC_H     ,"^c"                               )       ; コピー
    SetKana( KC_C | KC_V | KC_J     ,"{Right 5}"                        , R)    ; →5
    SetKana( KC_C | KC_V | KC_K     ,"+{Right 5}"                       , R)    ; →5選択
    SetKana( KC_C | KC_V | KC_L     ,"^{PgUp}"                          , R)    ; 前ページ▶先頭
    SetKana( KC_C | KC_V | KC_SCLN  ,"^{PgUp 5}"                        , R)    ; 前 5ページ▶先頭
    SetKana( KC_C | KC_V | KC_N     ,"+{End}"                           )       ; 選択End▼
    SetKana( KC_C | KC_V | KC_M     ,"{Left 5}"                         , R)    ; ←5
    SetKana( KC_C | KC_V | KC_COMM  ,"+{Left 5}"                        , R)    ; ←5選択
    SetKana( KC_C | KC_V | KC_DOT   ,"^{PgDn}"                          , R)    ; 次◀ページ先頭
    SetKana( KC_C | KC_V | KC_SLSH  ,"^{PgDn 5}"                        , R)    ; 次 5◀ページ先頭

; 英数編集モード
; 左手(最後の数字はディレイの長さ[ms])
    SetEisu( KC_M | KC_COMM | KC_Q  ,"／"                               )       ; ／
    SetEisu( KC_M | KC_COMM | KC_W  ,"｜{End}《》{Up}"                  , , 10) ; ルビマクロ
    SetEisu( KC_M | KC_COMM | KC_E  ,"{Home}{Enter}　　　{End}"         , , 10) ; トマクロ
    SetEisu( KC_M | KC_COMM | KC_R  ,"{Home}{Enter}　{End}"             , , 10) ; 台マクロ
    SetEisu( KC_M | KC_COMM | KC_T  ,"〇"                               )       ; ○
    SetEisu( KC_M | KC_COMM | KC_A  ,"【"                               )       ; 【
    SetEisu( KC_M | KC_COMM | KC_S  ,"〈"                               )       ; 〈
    SetEisu( KC_M | KC_COMM | KC_D  ,"『"                               )       ; 『
    SetEisu( KC_M | KC_COMM | KC_F  ,"」{Enter}「"                      , , 50) ; 」「マクロ
    SetEisu( KC_M | KC_COMM | KC_G  ,"　　　"                           )       ; □□□
    SetEisu( KC_M | KC_COMM | KC_Z  ,"】"                               )       ; 】
    SetEisu( KC_M | KC_COMM | KC_X  ,"〉"                               )       ; 〉
    SetEisu( KC_M | KC_COMM | KC_C  ,"』"                               )       ; 』
    SetEisu( KC_M | KC_COMM | KC_V  ,"」{Enter}　"                      , , 50) ; 」□マクロ
    SetEisu( KC_M | KC_COMM | KC_B  ,"　　　×　　　×　　　×{Enter}"  )       ; x  x   x

; 右手(R はリピート)
    SetEisu( KC_C | KC_V | KC_Y     ,"+{Home}"                          )       ; ▲Home選択
    SetEisu( KC_C | KC_V | KC_U     ,"^x"                               )       ; カット
    SetEisu( KC_C | KC_V | KC_I     ,"^v"                               )       ; ペースト
    SetEisu( KC_C | KC_V | KC_O     ,"^y"                               )       ; リドゥ
    SetEisu( KC_C | KC_V | KC_P     ,"^z"                               )       ; アンドゥ
    SetEisu( KC_C | KC_V | KC_H     ,"^c"                               )       ; コピー
    SetEisu( KC_C | KC_V | KC_J     ,"{Right 5}"                        , R)    ; →5
    SetEisu( KC_C | KC_V | KC_K     ,"+{Right 5}"                       , R)    ; →5選択
    SetEisu( KC_C | KC_V | KC_L     ,"^{PgUp}"                          , R)    ; 前ページ▶先頭
    SetEisu( KC_C | KC_V | KC_SCLN  ,"^{PgUp 5}"                        , R)    ; 前 5ページ▶先頭
    SetEisu( KC_C | KC_V | KC_N     ,"+{End}"                           )       ; 選択End▼
    SetEisu( KC_C | KC_V | KC_M     ,"{Left 5}"                         , R)    ; ←5
    SetEisu( KC_C | KC_V | KC_COMM  ,"+{Left 5}"                        , R)    ; ←5選択
    SetEisu( KC_C | KC_V | KC_DOT   ,"^{PgDn}"                          , R)    ; 次◀ページ先頭
    SetEisu( KC_C | KC_V | KC_SLSH  ,"^{PgDn 5}"                        , R)    ; 次 5◀ページ先頭


; 1キー
    SetKana( KC_W       ,"ki"       )       ; き
    SetKana( KC_E       ,"te"       )       ; て
    SetKana( KC_R       ,"si"       )       ; し
    SetKana( KC_T       ,"{Left}"   , R)    ; 左
    SetKana( KC_Y       ,"{Right}"  , R)    ; 右
    SetKana( KC_U       ,"{BS}"     , R)    ; 前文字削除
    SetKana( KC_I       ,"ru"       )       ; る
    SetKana( KC_O       ,"su"       )       ; す
    SetKana( KC_P       ,"he"       )       ; へ
    SetKana( KC_A       ,"ro"       )       ; ろ
    SetKana( KC_S       ,"ke"       )       ; け
    SetKana( KC_D       ,"to"       )       ; と
    SetKana( KC_F       ,"ka"       )       ; か
    SetKana( KC_G       ,"xtu"      , , 10) ; (っ)
    SetKana( KC_H       ,"ku"       )       ; く
    SetKana( KC_J       ,"a"        )       ; あ
    SetKana( KC_K       ,"i"        )       ; い
    SetKana( KC_L       ,"u"        )       ; う
    SetKana( KC_SCLN    ,"-"        )       ; ー
    SetKana( KC_Z       ,"ho"       )       ; ほ
    SetKana( KC_X       ,"hi"       )       ; ひ
    SetKana( KC_C       ,"ha"       )       ; は
    SetKana( KC_V       ,"ko"       )       ; こ
    SetKana( KC_B       ,"so"       )       ; そ
    SetKana( KC_N       ,"ta"       )       ; た
    SetKana( KC_M       ,"na"       )       ; な
    SetKana( KC_COMM    ,"nn"       )       ; ん
    SetKana( KC_DOT     ,"ra"       )       ; ら
    SetKana( KC_SLSH    ,"re"       )       ; れ
    SetKana( KC_INT1    ,"_"        )       ; _

    SetKana( KC_W | KC_SPC      ,"ne"       )       ; ね
    SetKana( KC_E | KC_SPC      ,"ri"       )       ; り
    SetKana( KC_R | KC_SPC      ,"me"       )       ; め
    SetKana( KC_U | KC_SPC      ,"sa"       )       ; さ
    SetKana( KC_I | KC_SPC      ,"yo"       )       ; よ
    SetKana( KC_O | KC_SPC      ,"e"        )       ; え
    SetKana( KC_P | KC_SPC      ,"yu"       )       ; ゆ
    SetKana( KC_A | KC_SPC      ,"se"       )       ; せ
    SetKana( KC_S | KC_SPC      ,"nu"       )       ; ぬ
    SetKana( KC_D | KC_SPC      ,"ni"       )       ; に
    SetKana( KC_F | KC_SPC      ,"ma"       )       ; ま
    SetKana( KC_G | KC_SPC      ,"ti"       )       ; ち
    SetKana( KC_H | KC_SPC      ,"ya"       )       ; や
    SetKana( KC_J | KC_SPC      ,"no"       )       ; の
    SetKana( KC_K | KC_SPC      ,"mo"       )       ; も
    SetKana( KC_L | KC_SPC      ,"wa"       )       ; わ
    SetKana( KC_SCLN | KC_SPC   ,"tu"       )       ; つ
    SetKana( KC_C | KC_SPC      ,"wo"       )       ; を
    SetKana( KC_V | KC_SPC      ,","        )       ; 、
    SetKana( KC_B | KC_SPC      ,"mi"       )       ; み
    SetKana( KC_N | KC_SPC      ,"o"        )       ; お
    SetKana( KC_COMM | KC_SPC   ,"mu"       )       ; む
    SetKana( KC_DOT | KC_SPC    ,"hu"       )       ; ふ
    SetKana( KC_INT1 | KC_SPC   ,"—"        )       ; —
    SetKana( KC_Z | KC_SPC      ,"ho"       )       ; ほ
    SetKana( KC_X | KC_SPC      ,"hi"       )       ; ひ
    SetKana( KC_SLSH | KC_SPC   ,"re"       )       ; れ
    SetKana( KC_M | KC_SPC      ,".{Enter}" )       ; 。
    SetKana( KC_T | KC_SPC      ,"+{Left}"  , R)    ; シフト + 左
    SetKana( KC_Y | KC_SPC      ,"+{Right}" , R)    ; シフト + 右
    SetKana( KC_RBRC | KC_SPC   ,"『"       )       ; 『
    SetKana( KC_NUHS | KC_SPC   ,"』"       )       ; 』

    SetKana( KC_Q               ,"{scF2}"   )       ; ダミー (KC_LANG1)
    SetKana( KC_Q | KC_SPC      ,"{scF2}"   )       ; ダミー (KC_LANG1)

; スペースキーの定義は不要


; 2キー同時押し
    SetKana( KC_Q | KC_L                ,"xu"   )       ; (ぅ)
    SetKana( KC_Q | KC_L | KC_SPC       ,"xwa"  , , 10) ; (ゎ)
    SetKana( KC_F | KC_U                ,"za"   )       ; ざ
    SetKana( KC_F | KC_U | KC_SPC       ,"za"   )
    SetKana( KC_F | KC_O                ,"zu"   )       ; ず
    SetKana( KC_F | KC_O | KC_SPC       ,"zu"   )
    SetKana( KC_F | KC_H                ,"gu"   )       ; ぐ
    SetKana( KC_F | KC_H | KC_SPC       ,"gu"   )
    SetKana( KC_F | KC_SCLN             ,"du"   )       ; づ
    SetKana( KC_F | KC_SCLN | KC_SPC    ,"du"   )
    SetKana( KC_F | KC_N                ,"da"   )       ; だ
    SetKana( KC_F | KC_N | KC_SPC       ,"da"   )
    SetKana( KC_F | KC_DOT              ,"bu"   )       ; ぶ
    SetKana( KC_F | KC_DOT | KC_SPC     ,"bu"   )
    SetKana( KC_F | KC_L                ,"vu"   )       ; ヴ
    SetKana( KC_F | KC_L | KC_SPC       ,"vu"   )
    SetKana( KC_F | KC_P                ,"be"   )       ; べ
    SetKana( KC_F | KC_P | KC_SPC       ,"be"   )
    SetKana( KC_J | KC_S                ,"ge"   )       ; げ
    SetKana( KC_J | KC_S | KC_SPC       ,"ge"   )
    SetKana( KC_J | KC_E                ,"de"   )       ; で
    SetKana( KC_J | KC_E | KC_SPC       ,"de"   )
    SetKana( KC_J | KC_R                ,"zi"   )       ; じ
    SetKana( KC_J | KC_R | KC_SPC       ,"zi"   )
    SetKana( KC_J | KC_A                ,"ze"   )       ; ぜ
    SetKana( KC_J | KC_A | KC_SPC       ,"ze"   )
    SetKana( KC_J | KC_W                ,"gi"   )       ; ぎ
    SetKana( KC_J | KC_W | KC_SPC       ,"gi"   )
    SetKana( KC_J | KC_D                ,"do"   )       ; ど
    SetKana( KC_J | KC_D | KC_SPC       ,"do"   )
    SetKana( KC_J | KC_F                ,"ga"   )       ; が
    SetKana( KC_J | KC_F | KC_SPC       ,"ga"   )
    SetKana( KC_J | KC_G                ,"di"   )       ; ぢ
    SetKana( KC_J | KC_G | KC_SPC       ,"di"   )
    SetKana( KC_J | KC_Z                ,"bo"   )       ; ぼ
    SetKana( KC_J | KC_Z | KC_SPC       ,"bo"   )
    SetKana( KC_J | KC_X                ,"bi"   )       ; び
    SetKana( KC_J | KC_X | KC_SPC       ,"bi"   )
    SetKana( KC_J | KC_C                ,"ba"   )       ; ば
    SetKana( KC_J | KC_C | KC_SPC       ,"ba"   )
    SetKana( KC_J | KC_V                ,"go"   )       ; ご
    SetKana( KC_J | KC_V | KC_SPC       ,"go"   )
    SetKana( KC_J | KC_B                ,"zo"   )       ; ぞ
    SetKana( KC_J | KC_B | KC_SPC       ,"zo"   )
    SetKana( KC_V | KC_DOT              ,"pu"   )       ; ぷ
    SetKana( KC_V | KC_DOT | KC_SPC     ,"pu"   )
    SetKana( KC_V | KC_P                ,"pe"   )       ; ぺ
    SetKana( KC_V | KC_P | KC_SPC       ,"pe"   )
    SetKana( KC_M | KC_Z                ,"po"   )       ; ぽ
    SetKana( KC_M | KC_Z | KC_SPC       ,"po"   )
    SetKana( KC_M | KC_X                ,"pi"   )       ; ぴ
    SetKana( KC_M | KC_X | KC_SPC       ,"pi"   )
    SetKana( KC_M | KC_C                ,"pa"   )       ; ぱ
    SetKana( KC_M | KC_C | KC_SPC       ,"pa"   )
    SetKana( KC_Q | KC_H                ,"xya"  , , 10) ; (ゃ)
    SetKana( KC_Q | KC_H | KC_SPC       ,"xya"  , , 10)
    SetKana( KC_Q | KC_P                ,"xyu"  , , 10) ; (ゅ)
    SetKana( KC_Q | KC_P | KC_SPC       ,"xyu"  , , 10)
    SetKana( KC_Q | KC_I                ,"xyo"  , , 10) ; (ょ)
    SetKana( KC_Q | KC_I | KC_SPC       ,"xyo"  , , 10)
    SetKana( KC_Q | KC_J                ,"xa"   )       ; (ぁ)
    SetKana( KC_Q | KC_J | KC_SPC       ,"xa"   )
    SetKana( KC_Q | KC_K                ,"xi"   )       ; (ぃ)
    SetKana( KC_Q | KC_K | KC_SPC       ,"xi"   )
    SetKana( KC_Q | KC_O                ,"xe"   )       ; (ぇ)
    SetKana( KC_Q | KC_O | KC_SPC       ,"xe"   )
    SetKana( KC_Q | KC_N                ,"xo"   )       ; (ぉ)
    SetKana( KC_Q | KC_N | KC_SPC       ,"xo"   )
    SetKana( KC_B | KC_H                ,"mya"  , , 10) ; みゃ
    SetKana( KC_B | KC_H | KC_SPC       ,"mya"  , , 10)
    SetKana( KC_B | KC_P                ,"myu"  , , 10) ; みゅ
    SetKana( KC_B | KC_P | KC_SPC       ,"myu"  , , 10)
    SetKana( KC_B | KC_I                ,"myo"  , , 10) ; みょ
    SetKana( KC_B | KC_I | KC_SPC       ,"myo"  , , 10)
    SetKana( KC_E | KC_H                ,"rya"  , , 10) ; りゃ
    SetKana( KC_E | KC_H | KC_SPC       ,"rya"  , , 10)
    SetKana( KC_E | KC_P                ,"ryu"  , , 10) ; りゅ
    SetKana( KC_E | KC_P | KC_SPC       ,"ryu"  , , 10)
    SetKana( KC_E | KC_I                ,"ryo"  , , 10) ; りょ
    SetKana( KC_E | KC_I | KC_SPC       ,"ryo"  , , 10)
    SetKana( KC_R | KC_H                ,"sya"  , , 10) ; しゃ
    SetKana( KC_R | KC_H | KC_SPC       ,"sya"  , , 10)
    SetKana( KC_R | KC_P                ,"syu"  , , 10) ; しゅ
    SetKana( KC_R | KC_P | KC_SPC       ,"syu"  , , 10)
    SetKana( KC_R | KC_I                ,"syo"  , , 10) ; しょ
    SetKana( KC_R | KC_I | KC_SPC       ,"syo"  , , 10)
    SetKana( KC_W | KC_H                ,"kya"  , , 10) ; きゃ
    SetKana( KC_W | KC_H | KC_SPC       ,"kya"  , , 10)
    SetKana( KC_W | KC_P                ,"kyu"  , , 10) ; きゅ
    SetKana( KC_W | KC_P | KC_SPC       ,"kyu"  , , 10)
    SetKana( KC_W | KC_I                ,"kyo"  , , 10) ; きょ
    SetKana( KC_W | KC_I | KC_SPC       ,"kyo"  , , 10)
    SetKana( KC_D | KC_H                ,"nya"  , , 10) ; にゃ
    SetKana( KC_D | KC_H | KC_SPC       ,"nya"  , , 10)
    SetKana( KC_D | KC_P                ,"nyu"  , , 10) ; にゅ
    SetKana( KC_D | KC_P | KC_SPC       ,"nyu"  , , 10)
    SetKana( KC_D | KC_I                ,"nyo"  , , 10) ; にょ
    SetKana( KC_D | KC_I | KC_SPC       ,"nyo"  , , 10)
    SetKana( KC_G | KC_H                ,"tya"  , , 10) ; ちゃ
    SetKana( KC_G | KC_H | KC_SPC       ,"tya"  , , 10)
    SetKana( KC_G | KC_P                ,"tyu"  , , 10) ; ちゅ
    SetKana( KC_G | KC_P | KC_SPC       ,"tyu"  , , 10)
    SetKana( KC_G | KC_I                ,"tyo"  , , 10) ; ちょ
    SetKana( KC_G | KC_I | KC_SPC       ,"tyo"  , , 10)
    SetKana( KC_X | KC_H                ,"hya"  , , 10) ; ひゃ
    SetKana( KC_X | KC_H | KC_SPC       ,"hya"  , , 10)
    SetKana( KC_X | KC_P                ,"hyu"  , , 10) ; ひゅ
    SetKana( KC_X | KC_P | KC_SPC       ,"hyu"  , , 10)
    SetKana( KC_X | KC_I                ,"hyo"  , , 10) ; ひょ
    SetKana( KC_X | KC_I | KC_SPC       ,"hyo"  , , 10)


; 3キー同時押し
    SetKana( KC_J | KC_R | KC_H             ,"ja"       )       ; じゃ
    SetKana( KC_J | KC_R | KC_H | KC_SPC    ,"ja"       )
    SetKana( KC_J | KC_R | KC_P             ,"ju"       )       ; じゅ
    SetKana( KC_J | KC_R | KC_P | KC_SPC    ,"ju"       )
    SetKana( KC_J | KC_R | KC_I             ,"jo"       )       ; じょ
    SetKana( KC_J | KC_R | KC_I | KC_SPC    ,"jo"       )
    SetKana( KC_J | KC_W | KC_H             ,"gya"      , , 10) ; ぎゃ
    SetKana( KC_J | KC_W | KC_H | KC_SPC    ,"gya"      , , 10)
    SetKana( KC_J | KC_W | KC_P             ,"gyu"      , , 10) ; ぎゅ
    SetKana( KC_J | KC_W | KC_P | KC_SPC    ,"gyu"      , , 10)
    SetKana( KC_J | KC_W | KC_I             ,"gyo"      , , 10) ; ぎょ
    SetKana( KC_J | KC_W | KC_I | KC_SPC    ,"gyo"      , , 10)
    SetKana( KC_J | KC_G | KC_H             ,"dya"      , , 10) ; ぢゃ
    SetKana( KC_J | KC_G | KC_H | KC_SPC    ,"dya"      , , 10)
    SetKana( KC_J | KC_G | KC_P             ,"dyu"      , , 10) ; ぢゅ
    SetKana( KC_J | KC_G | KC_P | KC_SPC    ,"dyu"      , , 10)
    SetKana( KC_J | KC_G | KC_I             ,"dyo"      , , 10) ; ぢょ
    SetKana( KC_J | KC_G | KC_I | KC_SPC    ,"dyo"      , , 10)
    SetKana( KC_J | KC_X | KC_H             ,"bya"      , , 10) ; びゃ
    SetKana( KC_J | KC_X | KC_H | KC_SPC    ,"bya"      , , 10)
    SetKana( KC_J | KC_X | KC_P             ,"byu"      , , 10) ; びゅ
    SetKana( KC_J | KC_X | KC_P | KC_SPC    ,"byu"      , , 10)
    SetKana( KC_J | KC_X | KC_I             ,"byo"      , , 10) ; びょ
    SetKana( KC_J | KC_X | KC_I | KC_SPC    ,"byo"      , , 10)
    SetKana( KC_M | KC_X | KC_H             ,"pya"      , , 10) ; ぴゃ
    SetKana( KC_M | KC_X | KC_H | KC_SPC    ,"pya"      , , 10)
    SetKana( KC_M | KC_X | KC_P             ,"pyu"      , , 10) ; ぴゅ
    SetKana( KC_M | KC_X | KC_P | KC_SPC    ,"pyu"      , , 10)
    SetKana( KC_M | KC_X | KC_I             ,"pyo"      , , 10) ; ぴょ
    SetKana( KC_M | KC_X | KC_I | KC_SPC    ,"pyo"      , , 10)
    SetKana( KC_M | KC_E | KC_K             ,"thi"      , , 10) ; てぃ
    SetKana( KC_M | KC_E | KC_K | KC_SPC    ,"thi"      , , 10)
    SetKana( KC_M | KC_E | KC_P             ,"thu"      , , 10) ; てゅ
    SetKana( KC_M | KC_E | KC_P | KC_SPC    ,"thu"      , , 10)
    SetKana( KC_J | KC_E | KC_K             ,"dhi"      , , 10) ; でぃ
    SetKana( KC_J | KC_E | KC_K | KC_SPC    ,"dhi"      , , 10)
    SetKana( KC_J | KC_E | KC_P             ,"dhu"      , , 10) ; でゅ
    SetKana( KC_J | KC_E | KC_P | KC_SPC    ,"dhu"      , , 10)
    SetKana( KC_M | KC_D | KC_L             ,"twu"      , , 10) ; とぅ
    SetKana( KC_M | KC_D | KC_L | KC_SPC    ,"twu"      , , 10)
    SetKana( KC_J | KC_D | KC_L             ,"dwu"      , , 10) ; どぅ
    SetKana( KC_J | KC_D | KC_L | KC_SPC    ,"dwu"      , , 10)
    SetKana( KC_M | KC_R | KC_O             ,"sye"      , , 10) ; しぇ
    SetKana( KC_M | KC_R | KC_O | KC_SPC    ,"sye"      , , 10)
    SetKana( KC_M | KC_G | KC_O             ,"tye"      , , 10) ; ちぇ
    SetKana( KC_M | KC_G | KC_O | KC_SPC    ,"tye"      , , 10)
    SetKana( KC_J | KC_R | KC_O             ,"je"       )       ; じぇ
    SetKana( KC_J | KC_R | KC_O | KC_SPC    ,"je"       )
    SetKana( KC_J | KC_G | KC_O             ,"dye"      , , 10) ; ぢぇ
    SetKana( KC_J | KC_G | KC_O | KC_SPC    ,"dye"      , , 10)
    SetKana( KC_V | KC_DOT | KC_J           ,"fa"       )       ; ふぁ
    SetKana( KC_V | KC_DOT | KC_J | KC_SPC  ,"fa"       )
    SetKana( KC_V | KC_DOT | KC_K           ,"fi"       )       ; ふぃ
    SetKana( KC_V | KC_DOT | KC_K | KC_SPC  ,"fi"       )
    SetKana( KC_V | KC_DOT | KC_O           ,"fe"       )       ; ふぇ
    SetKana( KC_V | KC_DOT | KC_O | KC_SPC  ,"fe"       )
    SetKana( KC_V | KC_DOT | KC_N           ,"fo"       )       ; ふぉ
    SetKana( KC_V | KC_DOT | KC_N | KC_SPC  ,"fo"       )
    SetKana( KC_V | KC_DOT | KC_P           ,"fyu"      , , 10) ; ふゅ
    SetKana( KC_V | KC_DOT | KC_P | KC_SPC  ,"fyu"      , , 10)
    SetKana( KC_F | KC_L | KC_J             ,"va"       )       ; ヴぁ
    SetKana( KC_F | KC_L | KC_J | KC_SPC    ,"va"       )
    SetKana( KC_F | KC_L | KC_K             ,"vi"       )       ; ヴぃ
    SetKana( KC_F | KC_L | KC_K | KC_SPC    ,"vi"       )
    SetKana( KC_F | KC_L | KC_O             ,"ve"       )       ; ヴぇ
    SetKana( KC_F | KC_L | KC_O | KC_SPC    ,"ve"       )
    SetKana( KC_F | KC_L | KC_N             ,"vo"       )       ; ヴぉ
    SetKana( KC_F | KC_L | KC_N | KC_SPC    ,"vo"       )
    SetKana( KC_F | KC_L | KC_P             ,"vuxyu"    , , 10) ; ヴゅ
    SetKana( KC_F | KC_L | KC_P | KC_SPC    ,"vuxyu"    , , 10)
    SetKana( KC_V | KC_L | KC_K             ,"wi"       )       ; うぃ
    SetKana( KC_V | KC_L | KC_K | KC_SPC    ,"wi"       )
    SetKana( KC_V | KC_L | KC_O             ,"we"       )       ; うぇ
    SetKana( KC_V | KC_L | KC_O | KC_SPC    ,"we"       )
    SetKana( KC_V | KC_L | KC_N             ,"uxo"      , , 10) ; うぉ
    SetKana( KC_V | KC_L | KC_N | KC_SPC    ,"uxo"      , , 10)
    SetKana( KC_V | KC_K | KC_O             ,"ye"       )       ; いぇ
    SetKana( KC_V | KC_K | KC_O | KC_SPC    ,"ye"       )
    SetKana( KC_V | KC_H | KC_J             ,"kuxa"     , , 10) ; くぁ
    SetKana( KC_V | KC_H | KC_J | KC_SPC    ,"kuxa"     , , 10)
    SetKana( KC_V | KC_H | KC_K             ,"kuxi"     , , 10) ; くぃ
    SetKana( KC_V | KC_H | KC_K | KC_SPC    ,"kuxi"     , , 10)
    SetKana( KC_V | KC_H | KC_O             ,"kuxe"     , , 10) ; くぇ
    SetKana( KC_V | KC_H | KC_O | KC_SPC    ,"kuxe"     , , 10)
    SetKana( KC_V | KC_H | KC_N             ,"kuxo"     , , 10) ; くぉ
    SetKana( KC_V | KC_H | KC_N | KC_SPC    ,"kuxo"     , , 10)
    SetKana( KC_V | KC_H | KC_L             ,"kuxwa"    , , 10) ; くゎ
    SetKana( KC_V | KC_H | KC_L | KC_SPC    ,"kuxwa"    , , 10)
    SetKana( KC_F | KC_H | KC_J             ,"gwa"      , , 10) ; ぐぁ
    SetKana( KC_F | KC_H | KC_J | KC_SPC    ,"gwa"      , , 10)
    SetKana( KC_F | KC_H | KC_K             ,"guxi"     , , 10) ; ぐぃ
    SetKana( KC_F | KC_H | KC_K | KC_SPC    ,"guxi"     , , 10)
    SetKana( KC_F | KC_H | KC_O             ,"guxe"     , , 10) ; ぐぇ
    SetKana( KC_F | KC_H | KC_O | KC_SPC    ,"guxe"     , , 10)
    SetKana( KC_F | KC_H | KC_N             ,"guxo"     , , 10) ; ぐぉ
    SetKana( KC_F | KC_H | KC_N | KC_SPC    ,"guxo"     , , 10)
    SetKana( KC_F | KC_H | KC_L             ,"guxwa"    , , 10) ; ぐゎ
    SetKana( KC_F | KC_H | KC_L | KC_SPC    ,"guxwa"    , , 10)
    SetKana( KC_V | KC_SCLN | KC_J          ,"tsa"      , , 10) ; つぁ
    SetKana( KC_V | KC_SCLN | KC_J | KC_SPC ,"tsa"      , , 10)
    SetKana( KC_V | KC_SCLN | KC_K          ,"tsi"      , , 10) ; つぃ
    SetKana( KC_V | KC_SCLN | KC_K | KC_SPC ,"tsi"      , , 10)
    SetKana( KC_V | KC_SCLN | KC_O          ,"tse"      , , 10) ; つぇ
    SetKana( KC_V | KC_SCLN | KC_O | KC_SPC ,"tse"      , , 10)
    SetKana( KC_V | KC_SCLN | KC_N          ,"tso"      , , 10) ; つぉ
    SetKana( KC_V | KC_SCLN | KC_N | KC_SPC ,"tso"      , , 10)


; ----------------------------------------------------------------------
; 設定がUSキーボードの場合  ; 参考: https://ixsvr.dyndns.org/blog/764
; ----------------------------------------------------------------------
 RegRead, Var, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\Services\i8042prt\Parameters, LayerDriver JPN
if (Var == "kbd101.dll")
{
    SetKana( KC_NUHS | KC_SPC   ,"|"    )   ; ｜
    SetKana( KC_LBRC | KC_SPC   ,"『"   )   ; 『
    SetKana( KC_RBRC | KC_SPC   ,"』"   )   ; 』
    SetKana( KC_INT1            ,"?"    )   ; ？
    SetKana( KC_INT1 | KC_SPC   ,"{!}"  )   ; ！
; おまけ
    SetKana( JP_YEN             ,"\"    )   ; ￥
    SetKana( JP_YEN | KC_SPC    ,"|"    )   ; ｜    スペース押しながらですよ
    SetEisu( JP_YEN             ,"\"    )   ; ￥
    SetEisu( JP_YEN | KC_SPC    ,"|"    )   ; ｜    スペース押しながらですよ
    SetEisu( KC_INT1            ,"\"    )   ; ￥
    SetEisu( KC_INT1 | KC_SPC   ,"_"    )   ; ＿    スペース押しながらですよ
}
