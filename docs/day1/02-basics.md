# 2-2. データを確かめる

**形式：ハンズオン（約60分）**

[2-1. はじめてのターミナル](02-terminal.md) で覚えた操作を使って、いよいよ GIS データを扱います。

## 2.1 gdal の確認（10分）

[環境構築](../setup.md) の手順で準備した環境を開き、次を実行します。

```bash
gdal --version
```

`GDAL 3.13.x, released ...` のように表示されればOK。

!!! info "`gdal` コマンドについて"
    この講義では、GDAL 3.11 で導入された **統一コマンド `gdal`** を使います。
    すべての処理が `gdal <対象> <操作>` という同じ形で書けます。

    ```text
    gdal  raster  info     dem.tif
    gdal  vector  convert  in.shp  out.gpkg
    ^^^^  ^^^^^^  ^^^^^^^
    道具   対象     操作
    ```

    Web上の解説では `gdalinfo` や `ogr2ogr` などの **従来コマンド** をよく見かけます。中身は同じ GDAL です。読み替えは [コマンド早見表](../cheatsheet.md) を参照してください。

## 2.2 gdal のヘルプを読む（5分）

```bash
gdal --help                 # 対象（raster / vector …）の一覧
gdal raster --help          # raster でできる操作の一覧
gdal raster clip --help     # clip のオプション
```

`[OPTIONS]` は省略可能、`<INPUT>` は必須、`[required]` と書かれたオプションも必須、という読み方を覚えれば十分です。

## 2.3 データの確認（30分）

処理の前に、**データが何者かを確かめる** のが最初の一歩です。

### ベクタ：gdal vector info

```bash
gdal vector info --summary data/raw/okayama_admin.gpkg      # レイヤ一覧
gdal vector info data/raw/okayama_admin.gpkg                # 概要
gdal vector info --limit 3 data/raw/okayama_admin.gpkg      # 先頭3件の中身
```

読み取るポイント：

- [ ] Geometry（Point / LineString / Polygon）
- [ ] Feature Count（地物数）
- [ ] 座標参照系（`ID: EPSG:....`）
- [ ] Extent（範囲）
- [ ] 属性の名前と型

### ラスタ：gdal raster info

```bash
gdal raster info data/raw/dem/dem_01.tif
gdal raster info --stats data/raw/dem/dem_01.tif      # 最小・最大・平均・標準偏差
```

読み取るポイント：

- [ ] Size（列数・行数）
- [ ] Pixel Size（解像度）
- [ ] Coordinate System
- [ ] Band の型（Byte / Int16 / Float32）と NoData Value

!!! example "やってみよう"
    `okayama_admin.gpkg` の座標参照系の EPSG コードと、市町村数を答えてください。

!!! note "JGD2011 と JGD2024"
    最近の GDAL/PROJ では、`EPSG:6668` や `EPSG:6673` の名称が **JGD2024** と表示されます。
    EPSG データベース側で名称が変更されたためで、コード番号は同じです。古い資料で「JGD2011」と書かれていても、番号が同じなら GDAL 上は同じ座標参照系として扱われます。

## 2.4 ファイル形式の理解（15分）

| 形式 | 種類 | 特徴 | この講義での扱い |
|------|------|------|------------------|
| Shapefile (.shp) | ベクタ | 古くからの標準。複数ファイル1組、属性名10文字制限、2GB上限 | 読むだけ |
| GeoPackage (.gpkg) | ベクタ・ラスタ | 1ファイル、SQLite ベース、OGC標準 | **ベクタの保存はこれ** |
| GeoJSON (.geojson) | ベクタ | テキスト、Web向き、緯度経度が基本 | 小さいデータの受け渡し |
| CSV (.csv) | 表 | 緯度経度の列があれば点にできる | 観測点データ |
| GeoTIFF (.tif) | ラスタ | ラスタの標準 | **ラスタの保存はこれ** |
| COG (.tif) | ラスタ | クラウドから部分読みできる GeoTIFF | 配布・公開用 |
| VRT (.vrt) | ラスタ・ベクタ | 実体を持たない「参照ファイル」（XML） | 結合・仮想処理 |

使える形式の一覧は JSON で出てきます。`jq` で名前だけ取り出してみましょう。

```bash
gdal vector --drivers | jq -r '.[].short_name' | head -20
gdal raster --drivers | jq -r '.[].short_name' | grep -i -E "gtiff|cog|vrt"
```
