# 環境構築

!!! tip "推奨順"
    受講者全員が **同じ環境** で作業できることを優先します。迷ったら A を選んでください。

## 必要なもの

| 道具 | 用途 | 確認コマンド |
|------|------|--------------|
| GDAL 3.10 以上（3.11 以上推奨） | 空間データ処理 | `gdalinfo --version` |
| bash 系シェル | コマンド実行、スクリプト | `echo $SHELL` |
| jq | JSON の整形・抽出 | `jq --version` |
| Git | 履歴の記録 | `git --version` |
| QGIS | GUIとの比較・結果の確認 | — |

## A. GitHub Codespaces（推奨・インストール不要）

ブラウザだけで、講師と同じ Linux 環境が使えます。

1. 講義用リポジトリを開く
2. 「Code」→「Codespaces」→「Create codespace on main」
3. 起動したら、下部のターミナルで確認

```bash
gdalinfo --version
```

!!! note
    リポジトリの `.devcontainer/devcontainer.json` に環境が定義されています。
    **環境そのものがコードとして残っている** ことも、この講義のテーマの一部です。

## B. 自分のPCに入れる（conda-forge）

講義後も自分の研究で使う人はこちら。

=== "Windows"

    1. [Miniforge](https://github.com/conda-forge/miniforge) をインストール
    2. [Git for Windows](https://gitforwindows.org/) をインストール（Git Bash が付属）
    3. Miniforge Prompt で以下を実行

    ```bash
    conda create -n cligis -c conda-forge gdal jq
    conda activate cligis
    ```

    !!! warning
        OSGeo4W Shell（QGIS付属）でも GDAL は動きますが、中身は Windows の `cmd` です。
        2日目の `for` ループやシェルスクリプトがそのまま動かないため、この講義では推奨しません。
        WSL（Windows Subsystem for Linux）が使える人は、WSL 上で macOS/Linux の手順に従ってください。

=== "macOS / Linux"

    ```bash
    # Miniforge をインストール後
    conda create -n cligis -c conda-forge gdal jq
    conda activate cligis
    gdalinfo --version
    ```

## C. Docker

```bash
docker run --rm -it -v "$PWD":/work -w /work ghcr.io/osgeo/gdal:ubuntu-small-latest bash
```

## 動作確認

以下がすべてエラーなく表示されれば準備完了です。

```bash
gdalinfo --version
ogrinfo --formats | head
gdal --version     # GDAL 3.11 以上のみ。エラーでも1日目は問題なし
jq --version
git --version
```
