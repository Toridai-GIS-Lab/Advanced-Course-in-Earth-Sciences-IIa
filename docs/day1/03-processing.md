# 3. ラスタ・ベクタ処理の基本

**形式：ハンズオン中心（約100分）**

4つの基本操作を、ベクタとラスタの両方で行います。
各操作の後に、必ず `ogrinfo` / `gdalinfo` で **結果を確かめます**。

!!! note "コマンドの表記"
    従来コマンドを主に示し、新CLI（GDAL 3.11+）をタブで併記します。

## 3.1 フォーマット変換

=== "従来"

    ```bash
    # Shapefile → GeoPackage
    ogr2ogr -f GPKG data/work/landuse.gpkg data/raw/landuse/L03-b.shp

    # CSV（緯度経度）→ GeoPackage の点
    ogr2ogr -f GPKG data/work/stations.gpkg data/raw/stations.csv \
      -oo X_POSSIBLE_NAMES=lon -oo Y_POSSIBLE_NAMES=lat -a_srs EPSG:4326

    # GeoTIFF → COG
    gdal_translate -of COG data/raw/dem/dem_01.tif data/work/dem_01_cog.tif
    ```

=== "新CLI"

    ```bash
    gdal vector convert data/raw/landuse/L03-b.shp data/work/landuse.gpkg
    gdal raster convert --of=COG data/raw/dem/dem_01.tif data/work/dem_01_cog.tif
    ```

!!! example "確かめる"
    変換前後で Feature Count と属性名が変わっていないか確認しましょう。Shapefile の属性名が文字化けしていたら、`--config SHAPE_ENCODING CP932` を試します。

## 3.2 座標変換

!!! danger "座標変換と座標の「付け替え」は別物"
    - `-t_srs`：座標を **計算し直す**（変換）
    - `-a_srs`：座標はそのままで **ラベルだけ付け替える**（割り当て）

    取り違えると、データが数百km ずれます。

=== "従来"

    ```bash
    # ベクタ：JGD2011 緯度経度 → 平面直角座標系 第V系
    ogr2ogr -t_srs EPSG:6673 -nln admin data/work/admin_6673.gpkg data/raw/okayama_admin.gpkg

    # ラスタ：再投影。リサンプリング方法を必ず指定する
    gdalwarp -t_srs EPSG:6673 -r bilinear -tr 30 30 \
      data/raw/dem/dem_01.tif data/work/dem_01_6673.tif
    ```

=== "新CLI"

    ```bash
    gdal vector reproject --dst-crs=EPSG:6673 data/raw/okayama_admin.gpkg data/work/admin_6673.gpkg
    gdal raster reproject --dst-crs=EPSG:6673 -r bilinear --resolution=30,30 \
      data/raw/dem/dem_01.tif data/work/dem_01_6673.tif
    ```

| リサンプリング | 向いているデータ |
|----------------|------------------|
| `near` | 土地利用など **カテゴリ** |
| `bilinear` / `cubic` | 標高・気温など **連続量** |

## 3.3 クリップ処理

=== "従来"

    ```bash
    # ベクタ：岡山市だけ取り出す（属性で抽出）
    ogr2ogr -where "N03_004 = '岡山市'" \
      data/work/okayama_city.gpkg data/work/admin_6673.gpkg

    # ベクタ：土地利用を岡山市の範囲で切る
    ogr2ogr -clipsrc data/work/okayama_city.gpkg \
      data/work/landuse_okayama_city.gpkg data/work/landuse.gpkg

    # ラスタ：DEMを岡山市の形で切る
    gdalwarp -cutline data/work/okayama_city.gpkg -crop_to_cutline -dstnodata -9999 \
      data/work/dem_01_6673.tif data/work/dem_okayama_city.tif
    ```

=== "新CLI"

    ```bash
    gdal vector filter --where "N03_004 = '岡山市'" \
      data/work/admin_6673.gpkg data/work/okayama_city.gpkg
    gdal vector clip --like=data/work/okayama_city.gpkg \
      data/work/landuse.gpkg data/work/landuse_okayama_city.gpkg
    gdal raster clip --like=data/work/okayama_city.gpkg \
      data/work/dem_01_6673.tif data/work/dem_okayama_city.tif
    ```

!!! warning
    切る側と切られる側の **座標参照系がそろっているか** を、事前に確かめてください。

## 3.4 マージ処理

=== "従来"

    ```bash
    # ラスタ：複数タイルを仮想的に1枚にする（実体はXML。一瞬で終わる）
    gdalbuildvrt data/work/dem_mosaic.vrt data/raw/dem/*.tif
    # 実体のファイルにする
    gdal_translate -of COG data/work/dem_mosaic.vrt data/work/dem_mosaic.tif

    # ベクタ：複数ファイルを1レイヤにまとめる
    ogrmerge.py -single -f GPKG -o data/work/landuse_all.gpkg data/raw/landuse/*.shp
    ```

=== "新CLI"

    ```bash
    gdal raster mosaic data/raw/dem/*.tif data/work/dem_mosaic.vrt
    gdal vector concat --mode=single data/raw/landuse/*.shp data/work/landuse_all.gpkg
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
