# 3. ラスタ・ベクタ処理の基本

**形式：ハンズオン中心（約100分）**

4つの基本操作を、ベクタとラスタの両方で行います。
各操作の後に、必ず `gdal vector info` / `gdal raster info` で **結果を確かめます**。

!!! note "コマンドの形"
    どの操作も `gdal <raster|vector> <操作> [オプション] 入力 出力` です。
    同じ名前の出力ファイルがあるとエラーになるので、やり直すときは `--overwrite` を付けます。

## 3.1 フォーマット変換

```bash
# Shapefile → GeoPackage
gdal vector convert data/raw/landuse/L03-b_west.shp data/work/landuse_west.gpkg

# CSV（緯度経度の列）→ 点の GeoPackage
gdal vector make-point --x lon --y lat --output-crs EPSG:4326 \
  data/raw/stations.csv data/work/stations.gpkg

# GeoTIFF → COG
gdal raster convert --of COG data/raw/dem/dem_01.tif data/work/dem_01_cog.tif
```

!!! example "確かめる"
    変換前後で Feature Count と属性名が変わっていないか確認しましょう。
    Shapefile の属性が文字化けしていたら、`--oo ENCODING=CP932` を付けて読み直します。

## 3.2 座標変換

```bash
# ベクタ：JGD2011 緯度経度 → 平面直角座標系 第V系
gdal vector reproject -d EPSG:6673 --output-layer admin \
  data/raw/okayama_admin.gpkg data/work/admin_6673.gpkg

# ラスタ：再投影。リサンプリング方法と解像度を必ず指定する
gdal raster reproject -d EPSG:6673 -r bilinear --resolution 30,30 \
  data/raw/dem/dem_01.tif data/work/dem_01_6673.tif
```

`-d` は `--output-crs`（出力の座標参照系）の短縮形です。

!!! danger "座標変換と座標の「付け替え」は別物"
    - `reproject -d`：座標を **計算し直す**（変換）
    - `edit --crs`：座標はそのままで **ラベルだけ付け替える**（割り当て）

    取り違えると、データが数百km ずれます。`edit --crs` は「座標系が書かれていないデータに、正しい座標系を書き込む」ときだけ使います。

| リサンプリング `-r` | 向いているデータ |
|---------------------|------------------|
| `nearest` | 土地利用など **カテゴリ** |
| `bilinear` / `cubic` | 標高・気温など **連続量** |

## 3.3 クリップ処理

```bash
# ベクタ：岡山市だけ取り出す（属性で抽出）
gdal vector filter --where "N03_004 = '岡山市'" \
  data/work/admin_6673.gpkg data/work/okayama_city.gpkg

# ベクタ：土地利用を岡山市の形で切る
gdal vector clip --like data/work/okayama_city.gpkg \
  data/work/landuse_west.gpkg data/work/landuse_okayama_city.gpkg

# ラスタ：DEMを岡山市の形で切る
gdal raster clip --like data/work/okayama_city.gpkg \
  data/work/dem_01_6673.tif data/work/dem_okayama_city.tif
```

!!! tip "抽出と切り抜きを1回で"
    `--like-where` を使うと、市町村を選ぶ処理と切り抜きを1つのコマンドで書けます。

    ```bash
    gdal raster clip --like data/work/admin_6673.gpkg --like-where "N03_004 = '岡山市'" \
      data/work/dem_01_6673.tif data/work/dem_okayama_city.tif
    ```

!!! warning
    `--like` は形で切り抜きます。範囲（外接矩形）だけで切りたいときは `--only-bbox` を付けます。
    切る側と切られる側の座標参照系が違っても、GDAL が切り抜き形状を自動で変換します。
    ただし **出力の座標参照系は切られる側（入力）のまま** です。上の例では、土地利用は緯度経度のまま残ります。

## 3.4 マージ処理

```bash
# ラスタ：複数タイルを仮想的に1枚にする（実体はXML。一瞬で終わる）
gdal raster mosaic data/raw/dem/*.tif data/work/dem_mosaic.vrt

# 実体のファイルにしたいときは、出力を .tif にするだけ
gdal raster mosaic --of COG data/raw/dem/*.tif data/work/dem_mosaic.tif

# ベクタ：複数ファイルを1レイヤにまとめる
gdal vector concat --mode=single --output-layer landuse \
  data/raw/landuse/*.shp data/work/landuse_all.gpkg
```

!!! tip "VRT は「処理の予約票」"
    VRT はデータそのものではなく、「どのファイルをどう並べるか」を書いたテキストです。`cat data/work/dem_mosaic.vrt` で中身を読めます。**手順がファイルとして残る** 典型例です。

## 3.5 ここまでの振り返り

```bash
history | tail -30
```

ここまでに打ったコマンドが、すべて残っています。これをファイルに保存すれば、それが今日の処理の「記録」です。

```bash
history | tail -30 > day1_log.txt
```
