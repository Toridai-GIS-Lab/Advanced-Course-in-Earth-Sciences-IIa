# 2. 環境構築・基本操作

**形式：ハンズオン（約80分）**

## 2.1 環境の確認（15分）

[環境構築](../setup.md) の手順で準備した環境を開き、次を実行します。

```bash
gdalinfo --version
```

`GDAL 3.x.x, released ...` と表示されればOK。

## 2.2 ターミナルの基本操作（20分）

```bash
pwd                 # 今どこにいるか
ls                  # 何があるか
ls -l data/raw      # 詳しく
cd data/raw         # 移動する
cd ../..            # 2つ上に戻る
mkdir -p data/work  # フォルダを作る
```

!!! tip "迷子になったら"
    - `pwd` で現在地を確認する
    - `Tab` キーでファイル名を補完する（打ち間違いが激減します）
    - `↑` キーで直前のコマンドを呼び出す
    - `Ctrl + C` で実行中のコマンドを止める

### ヘルプの読み方

```bash
ogr2ogr --help
gdalwarp --help | less    # q で終了
```

`[ ]` は省略可能、`<>` は必須、という読み方を覚えれば十分です。

## 2.3 データの確認（30分）

処理の前に、**データが何者かを確かめる** のが最初の一歩です。

### ベクタ：ogrinfo

```bash
ogrinfo data/raw/okayama_admin.gpkg                  # レイヤ一覧
ogrinfo -so -al data/raw/okayama_admin.gpkg          # 概要（-so: summary only）
ogrinfo -al -limit 3 data/raw/okayama_admin.gpkg     # 先頭3件の中身
```

読み取るポイント：

- [ ] Geometry（Point / LineString / Polygon）
- [ ] Feature Count（地物数）
- [ ] 座標参照系（`PROJCRS` / `GEOGCRS`、`ID["EPSG",...]`）
- [ ] Extent（範囲）
- [ ] 属性の名前と型

### ラスタ：gdalinfo

```bash
gdalinfo data/raw/dem/dem_01.tif
gdalinfo -stats data/raw/dem/dem_01.tif      # 最小・最大・平均・標準偏差
```

読み取るポイント：

- [ ] Size（行数・列数）
- [ ] Pixel Size（解像度）
- [ ] Coordinate System
- [ ] Band の型（Byte / Int16 / Float32）と NoData Value

!!! example "やってみよう"
    `okayama_admin.gpkg` の座標参照系の EPSG コードと、市町村数を答えてください。

## 2.4 ファイル形式の理解（15分）

| 形式 | 種類 | 特徴 | この講義での扱い |
|------|------|------|------------------|
| Shapefile (.shp) | ベクタ | 古くからの標準。複数ファイル1組、属性名10文字制限、2GB上限 | 読むだけ |
| GeoPackage (.gpkg) | ベクタ・ラスタ | 1ファイル、SQLite ベース、OGC標準 | **ベクタの保存はこれ** |
| GeoJSON (.geojson) | ベクタ | テキスト、Web向き、緯度経度が基本 | 小さいデータの受け渡し |
| CSV (.csv) | 表 | 緯度経度の列があれば点として読める | 観測点データ |
| GeoTIFF (.tif) | ラスタ | ラスタの標準 | **ラスタの保存はこれ** |
| COG (.tif) | ラスタ | クラウドから部分読みできる GeoTIFF | 配布・公開用 |
| VRT (.vrt) | ラスタ・ベクタ | 実体を持たない「参照ファイル」（XML） | 結合・仮想処理 |

```bash
ogrinfo --formats | grep -i -E "gpkg|shapefile|geojson"
gdalinfo --formats | grep -i -E "gtiff|cog|vrt"
```
