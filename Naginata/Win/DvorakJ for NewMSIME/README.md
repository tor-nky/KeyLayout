# 新MS-IME で薙刀式v13完成版を使う方法

初期設定のままの新MS-IME と DvorakJ で薙刀式を使えるようにする方法です。

## 1. 薙刀式v13完成版.txt の書き換え

### 87行目 ‘ → (半角)`
ろ|け|と|か|っ  |く  |あ  |い|う|ー|’|` |

### 861行目 IME ON
* (第１案) 変換 → (Mac)かな

  |  |  |  |  |  |{vk16}|  |  |  |  |  |

* (第２案)Windowsの更新状況や、キーボード・ドライバが特殊で、第１案が動かない場合

  |  |  |  |  |  |{vkF2}|  |  |  |  |  |

### 866〜868行目 IME OFF
* (第１案) 無変換 → (Mac)英数

  |  |  |      |  |  |  |  |  |  |  |  |

  |  |  |{vk1A}|  |  |  |  |  |  |  |  |

  |  |  |      |  |  |  |  |  |  |  |

* (第２案)Windowsの更新状況や、キーボード・ドライバが特殊で、第１案が動かない場合

  |  |  |            |  |  |  |  |  |  |  |  |

  |  |  |{vkF2}{vkF3}|  |  |  |  |  |  |  |  |

  |  |  |            |  |  |  |  |  |  |  |

### 899〜901行目 編集モード
^{End}|｜{改行}|/*ディ*/|^s      |・     ||||||||

……  |《      |？{改行}|「{改行}|({改行}||||||||

││  |》      |！{改行}|」{改行}|){改行}|||||||

### 917〜919行目 編集モード
／|｜{改行}{End}《》{↑}|{Home}{改行}{Space 3}{End}|{Home}{改行}{Space}{End}|〇||||||||

【|〈                   |『                        |」{改行 2}「{改行}      |{Space 3}||||||||

】|〉                   |』                        |」{改行 2}{Space}       |　　　×　　　×　　　×{改行}|||||||

※ 使ってみて{改行}が多すぎるところを減らした

## 2. 薙刀式v13英数.txt の書き換え

薙刀式v13完成版.txt の書き換えを参考にしてください。

## 3. DvorakJ の設定

DvorakJ の設定画面で、「IME 関連」の「Google 日本語入力を使用している」のチェックを入れる

![IME 関連](DvorakJ_Setting.png)

## 4. DvorakJ を一旦終了し、再び起動する

# 新MS-IME を使用することによる問題点

残念ながら、新MS-IME には使用をためらうような問題点があります。

* 記号入力の前に、未確定文字をすべて確定しておかなければならない。なぜなら、未確定文字の前に記号が入力される上、ソフトウェアが停止することがある。
これは、alt + テンキー数字 の入力でも起きる問題です。

* 変換窓が開いているときに文字を入力しても、英数入力に切り替えたときなど、最初の文字は入らないことがある。

* 文字入力中に編集モードの入力キャンセルをしても、推測入力の窓が残る。

* キーカスタマイズがほとんどできないばかりか、こまかな操作方法もわからなくなる。

## 参考

* [【薙刀式】v13完成版、発表。](http://oookaworks.seesaa.net/article/479173898.html#gsc.tab=0)
