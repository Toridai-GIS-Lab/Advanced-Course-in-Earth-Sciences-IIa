# 環境構築

!!! tip "推奨順"
    受講者全員が **同じ環境** で作業できることを優先します。迷ったら A を選んでください。

## 必要なもの

| 道具 | 用途 | 確認コマンド |
|------|------|--------------|
| GDAL 3.13 以上 | 空間データ処理（`gdal` コマンド） | `gdal --version` |
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
gdal --version
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
    conda create -n cligis -c conda-forge "gdal>=3.13" jq
    conda activate cligis
    ```

    !!! warning
        OSGeo4W Shell（QGIS付属）でも GDAL は動きますが、中身は Windows の `cmd` です。
        2日目の `for` ループやシェルスクリプトがそのまま動かないため、この講義では推奨しません。
        WSL（Windows Subsystem for Linux）が使える人は、WSL 上で macOS/Linux の手順に従ってください。

=== "macOS / Linux"

    ```bash
    # Miniforge をインストール後
    conda create -n cligis -c conda-forge "gdal>=3.13" jq
    conda activate cligis
    gdal --version
    ```

## C. Docker

```bash
docker run --rm -it -v "$PWD":/work -w /work ghcr.io/osgeo/gdal:ubuntu-small-3.13.3 bash
```

## 動作確認

以下がすべてエラーなく表示されれば準備完了です。

```bash
gdal --version              # GDAL 3.13 以上
gdal raster zonal-stats --help | head -3
jq --version
git --version
```

!!! warning "GDAL のバージョンについて"
    この講義の `gdal` コマンドは GDAL 3.11 で導入され、その後のバージョンで操作が次々に追加されています。
    資料のコマンドは **GDAL 3.13.3 で動作確認** しています。QGIS に同梱されている GDAL は古い場合があるので、必ず `gdal --version` で確認してください。

    なお `gdal` コマンドは現時点で「暫定提供」の扱いで、将来のバージョンでオプション名が変わる可能性があります。迷ったら `--help` が正解です。
