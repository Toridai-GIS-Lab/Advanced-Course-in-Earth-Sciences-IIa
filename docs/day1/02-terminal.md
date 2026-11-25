# 2-1. はじめてのターミナル

**形式：ハンズオン（約70分）**

ターミナルを一度も使ったことがない人向けの時間です。GIS はまだ出てきません。
練習には、リポジトリの `practice/` フォルダを使います。

!!! success "この時間のゴール"
    - [ ] ターミナルに文字を打って、結果を読める
    - [ ] 「今どこにいるか」を確かめて、フォルダを移動できる
    - [ ] ファイルの中身を見て、コピー・移動・削除ができる
    - [ ] 困ったときの抜け出し方を知っている

## 1. ターミナルとは

ふだん、ファイルはエクスプローラ（Mac なら Finder）で **マウスで** 操作しています。
ターミナルは、同じことを **文字で命令して** 行う画面です。

| やりたいこと | マウスでは | ターミナルでは |
|--------------|------------|----------------|
| 今いるフォルダを知る | ウィンドウの上部を見る | `pwd` |
| 中身を見る | フォルダを開く | `ls` |
| 別のフォルダへ行く | ダブルクリック | `cd フォルダ名` |
| フォルダを作る | 右クリック →「新規フォルダ」 | `mkdir フォルダ名` |
| ファイルをコピーする | 右クリック →「コピー」「貼り付け」 | `cp 元 先` |
| ファイルの中身を見る | ダブルクリックしてアプリで開く | `cat ファイル名` |

できることは同じです。違うのは、**打った文字がそのまま記録として残る** ことです（[過程が残る道具を使う](../process.md)）。

### 用語

| 用語 | 意味 |
|------|------|
| ターミナル | 文字で命令を打つための画面 |
| シェル（bash） | 打った命令を読んで実行するプログラム。この講義では bash |
| コマンド | 命令のこと。`pwd` や `ls` など |
| プロンプト | 「入力を待っています」という合図。この講義の環境では `course $` |

## 2. 画面の見方

Codespaces を開くと、画面の下にターミナルがあります。

```text
course $ █
```

`course $` がプロンプト、`█` が入力位置です。

1. コマンドを打つ
2. `Enter` を押す
3. 結果が表示され、また `course $` が出てくる

!!! tip "何も表示されないのは、成功の合図"
    ターミナルでは、多くのコマンドが **成功したときは黙っています**。
    何かがおかしいときだけ、メッセージが出ます。

## 3. 最初のコマンド

1つずつ打って、`Enter` を押してみましょう。

```bash
pwd
```

```text
/workspaces/Advanced-Course-in-Earth-Sciences-IIa
```

`pwd`（print working directory）は **今いる場所** を表示します。

```bash
ls
```

```text
LICENSE  LICENSE-CODE  README.md  docs  mkdocs.yml  practice  scripts
```

`ls`（list）は、今いる場所にある **ファイルとフォルダの一覧** を表示します。

```bash
echo こんにちは
whoami
date
```

`echo` は後ろに書いた文字をそのまま表示します。`whoami` は自分のユーザー名、`date` は現在の日時です。

## 4. コマンドの形

コマンドは、**スペースで区切った** 3つの部品でできています。

```text
ls    -l      practice
^^    ^^      ^^^^^^^^
命令  オプション  対象（引数）
```

- **命令**：何をするか
- **オプション**：どのようにするか。`-` や `--` で始まる
- **対象（引数）**：何に対してするか

```bash
ls practice          # practice の中身
ls -l practice       # 詳しく（サイズ・日時つき）
ls -l -h practice    # サイズを読みやすく（KB, MB）
```

!!! warning "スペースは「区切り」の意味"
    `ls-l` と `ls -l` は別物です。前者は「`ls-l` という命令」と解釈され、エラーになります。

`#` から後ろは **コメント** で、実行されません。この資料ではコマンドの説明に使っています。

### ヘルプを見る

```bash
ls --help
```

オプションを全部覚える必要はありません。**必要になったら `--help` で調べる** のが普通です。

## 5. 場所（パス）

ファイルの場所は、フォルダを `/` でつないだ **パス** で表します。

```text
/workspaces/Advanced-Course-in-Earth-Sciences-IIa   ← ここが「course」
├── docs/
├── practice/
│   ├── README.txt
│   ├── stations.csv
│   ├── my data.csv
│   ├── notes/
│   │   └── day1.txt
│   └── weather/
│       ├── okayama_2025-01.csv
│       ├── okayama_2025-02.csv
│       └── okayama_2025-03.csv
└── scripts/
```

### 移動する：cd

```bash
cd practice        # practice に入る
pwd
ls
cd weather         # さらに weather に入る
pwd
cd ..              # 1つ上に戻る
cd ../..           # 2つ上に戻る
cd                 # 何も付けないと、自分のホームフォルダへ
cd /workspaces/Advanced-Course-in-Earth-Sciences-IIa   # 絶対パスで戻る
```

| 書き方 | 意味 |
|--------|------|
| `/` で始まる | **絶対パス**：一番上から書いた、住所のような書き方 |
| それ以外 | **相対パス**：今いる場所から見た、道案内のような書き方 |
| `.` | 今いる場所 |
| `..` | 1つ上 |
| `~` | 自分のホームフォルダ |

!!! tip "Tab キーを使おう（一番大事）"
    `cd pra` まで打って `Tab` キーを押すと、`cd practice/` まで自動で補完されます。
    候補が複数あるときは、`Tab` を2回押すと一覧が出ます。

    **打ち間違いの大半は、Tab で防げます。** パスは手で全部打たず、必ず Tab を使いましょう。

!!! example "やってみよう 1"
    1. `practice/notes` に移動して、`pwd` で場所を確かめる
    2. そこから **1回の `cd`** で `practice/weather` に移動する
    3. リポジトリ直下（`course $` と表示される場所）に戻る

    ??? note "答え"
        ```bash
        cd practice/notes
        pwd
        cd ../weather
        cd ../..
        ```

## 6. ファイルの中身を見る

以降は、リポジトリ直下（`course $`）にいる前提です。

```bash
cat practice/README.txt               # 全部表示
head practice/stations.csv            # 先頭10行
head -n 3 practice/stations.csv       # 先頭3行
tail -n 3 practice/stations.csv       # 末尾3行
wc -l practice/stations.csv           # 行数を数える
less practice/stations.csv            # ページ送りで見る（q で終了）
```

!!! warning "大きなファイルに `cat` を使わない"
    数十万行のファイルを `cat` すると、画面が流れ続けます。止めるには `Ctrl + C` を押します。
    大きなファイルは、まず `head` で先頭だけ見る習慣をつけましょう。

## 7. ファイルを操作する

自分用の作業フォルダを作って、そこで練習します。

```bash
mkdir mywork                                  # フォルダを作る
cp practice/stations.csv mywork/              # コピーする
ls mywork
mv mywork/stations.csv mywork/st.csv          # 名前を変える（移動と同じ命令）
ls mywork
cp -r practice/weather mywork/                # フォルダごとコピー（-r）
ls mywork/weather
rm mywork/st.csv                              # 削除する
ls mywork
```

!!! danger "`rm` にはゴミ箱がない"
    `rm` で消したファイルは **元に戻せません**。確認もされません。
    フォルダごと消す `rm -r` は特に注意してください。消す前に `ls` で対象を確かめましょう。

    この講義では、元データ（`data/raw/`）は **絶対に** 消さない・書き換えないルールにしています。

## 8. スペースや日本語が入ったファイル名

`practice/` には `my data.csv` という、スペース入りのファイルがあります。

```bash
cat practice/my data.csv          # エラーになる
```

```text
cat: practice/my: No such file or directory
cat: data.csv: No such file or directory
```

スペースは区切りの意味なので、`practice/my` と `data.csv` の2つのファイルだと解釈されました。
引用符 `"` で囲むと、1つの名前として扱われます。

```bash
cat "practice/my data.csv"
```

!!! tip "ファイル名のおすすめ"
    自分で作るファイル・フォルダの名前は、**半角英数字・`_`・`-` だけ** にしておくと、トラブルがほぼなくなります。

    - ○ `okayama_dem_2025.tif`
    - × `岡山 DEM（2025年）.tif`

## 9. まとめて指定する：ワイルドカード `*`

`*` は「何文字でもよい」という意味です。

```bash
ls practice/weather/*.csv              # .csv で終わるもの全部
head -n 2 practice/weather/*.csv       # 全部の先頭2行
ls practice/weather/*-02.csv           # 2月だけ
```

!!! question "考えてみよう"
    `ls practice/weather/*02*` とすると、2月だけでなく3ファイルすべてが表示されます。なぜでしょうか？

    ??? note "答え"
        ファイル名の `2025` の中に `02` が含まれているからです。
        ワイルドカードは便利ですが、**意図しないものまで当たっていないか**、実行前に `ls` で確かめましょう。

## 10. 出力の行き先を変える：`>` と `|`

コマンドの結果は、ふつうは画面に表示されます。行き先を変えることができます。

| 記号 | 意味 | 例 |
|------|------|-----|
| `>` | ファイルに書き出す（上書き） | `ls practice > list.txt` |
| `>>` | ファイルの末尾に追記する | `date >> list.txt` |
| `\|` | 次のコマンドに渡す（パイプ） | `cat practice/stations.csv \| wc -l` |

```bash
# 鳥取県の行だけ取り出す（grep：文字を含む行を探す）
grep 鳥取県 practice/stations.csv

# それが何行あるか数える
grep 鳥取県 practice/stations.csv | wc -l

# 標高（5列目）の高い順に並べて、上位3つ
sort -t, -k5 -n -r practice/stations.csv | head -n 3

# 結果をファイルに保存する
grep 岡山県 practice/stations.csv > mywork/okayama_only.csv
cat mywork/okayama_only.csv
```

`|` でつなぐと、**小さな道具を組み合わせて** 目的の処理ができます。これが CLI の強みです。2日目には、これを GIS データで行います。

!!! danger "`>` は確認なしで上書きする"
    `>` で既存のファイルを指定すると、中身が消えて置き換わります。`rm` と同じく注意が必要です。

## 11. 困ったとき

| 状況 | 対処 |
|------|------|
| コマンドが終わらない・画面が流れ続ける | `Ctrl + C`（中断） |
| `less` や `--help` の画面から出られない | `q` |
| プロンプトが `>` だけになった | 引用符 `"` が閉じていない。`Ctrl + C` でやり直す |
| さっきのコマンドをもう一度使いたい | `↑` キー |
| 画面がごちゃごちゃしてきた | `clear`（または `Ctrl + L`） |
| これまで打ったコマンドを見たい | `history` |

### エラーメッセージを読む

エラーは怖いものではなく、**何が悪いかを教えてくれるメッセージ** です。英語ですが、パターンは限られています。

| メッセージ | 意味 | よくある原因 |
|------------|------|--------------|
| `command not found` | そんな命令はない | 打ち間違い（`sl`、`gadl` など） |
| `No such file or directory` | そのファイル・フォルダはない | パスの打ち間違い、今いる場所が違う |
| `Permission denied` | 権限がない | 書き込めない場所に書こうとした |
| `File exists` / `already exists` | すでにある | 同じ名前の出力がある（GDAL なら `--overwrite`） |

!!! tip "エラーが出たら、まず `pwd` と `ls`"
    `No such file or directory` の原因の多くは、「思っている場所と、今いる場所が違う」ことです。

### コピー＆ペースト

- **Mac**：`Cmd + C` / `Cmd + V`
- **Windows**：ターミナル上で **右クリック** して「コピー」「貼り付け」を選ぶのが確実です
- 初回の貼り付けで、ブラウザが「クリップボードへのアクセス」の許可を求めることがあります。許可してください

!!! warning "ターミナルの `Ctrl + C` は「中断」"
    ターミナルの中では、`Ctrl + C` は基本的にコピーではなく「実行中のコマンドを止める」意味になります。

## 12. 練習問題

リポジトリ直下（`course $`）から始めます。答えを見る前に、自分で打ってみましょう。

!!! example "問題 1"
    `practice/stations.csv` には、見出し行を除いて何地点のデータがありますか？

    ??? note "答え"
        ```bash
        wc -l practice/stations.csv
        ```
        11行と表示されます。1行目は見出しなので、**10地点** です。

!!! example "問題 2"
    岡山県の地点はいくつありますか？ コマンド1行で数を出してください。

    ??? note "答え"
        ```bash
        grep 岡山県 practice/stations.csv | wc -l
        ```

!!! example "問題 3"
    `mywork/` の中に `backup` フォルダを作り、`practice/weather/` の **1月と2月のファイルだけ** をコピーしてください。

    ??? note "答え"
        ```bash
        mkdir mywork/backup
        cp practice/weather/*-01.csv practice/weather/*-02.csv mywork/backup/
        ls mywork/backup
        ```

!!! example "問題 4"
    3か月分の気象データ（`practice/weather/` の3ファイル）を、見出し行を除いて1つのファイル `mywork/all_rows.csv` にまとめてください。
    （ヒント：`cat` は複数のファイルを続けて表示できます。`grep -v 文字` は「その文字を含まない行」を取り出します。）

    ??? note "答え"
        ```bash
        cat practice/weather/*.csv | grep -v date > mywork/all_rows.csv
        wc -l mywork/all_rows.csv
        ```
        15行（5日 × 3か月）になれば正解です。

!!! example "問題 5"
    ここまでに自分が打ったコマンドを、`mywork/my_history.txt` に保存してください。

    ??? note "答え"
        ```bash
        history > mywork/my_history.txt
        cat mywork/my_history.txt
        ```
        これが、あなたが今日行った作業の **記録** です。マウス操作では、この記録は残りません。

## 後片付け

```bash
rm -r mywork
```

!!! info "この時間で使ったコマンド"
    `pwd` `ls` `cd` `echo` `cat` `head` `tail` `wc` `less` `mkdir` `cp` `mv` `rm` `grep` `sort` `history` `clear`

    次の時間からは、これに `gdal` が加わります。**`gdal` も、ここで覚えたのと同じ形（命令・オプション・対象）のコマンドです。**
