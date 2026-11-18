# コマンド早見表

GDAL 3.11 で、`gdal <family> <操作>` という **新しい統一CLI** が導入されました。
この講義では **従来のコマンドを主に使い**、新CLIを併記します。

!!! info "なぜ両方？"
    - 従来コマンド：論文・Webの情報が圧倒的に多く、どの環境でも動く
    - 新CLI：一貫した書き方で覚えやすく、`pipeline` で処理をつなげられる。ただし現時点では experimental 扱い

## 確認

| やりたいこと | 従来 | 新CLI（3.11+） |
|--------------|------|----------------|
| ラスタの情報 | `gdalinfo dem.tif` | `gdal raster info dem.tif` |
| ラスタの統計 | `gdalinfo -stats dem.tif` | `gdal raster info --stats dem.tif` |
| ベクタの概要 | `ogrinfo -so -al a.gpkg` | `gdal vector info a.gpkg` |
| JSONで出力 | `gdalinfo -json dem.tif` | `gdal raster info --format=json dem.tif` |

## 変換

| やりたいこと | 従来 | 新CLI（3.11+） |
|--------------|------|----------------|
| ベクタ形式変換 | `ogr2ogr out.gpkg in.shp` | `gdal vector convert in.shp out.gpkg` |
| ラスタ形式変換 | `gdal_translate -of COG in.tif out.tif` | `gdal raster convert --of=COG in.tif out.tif` |
| ベクタ座標変換 | `ogr2ogr -t_srs EPSG:6673 out.gpkg in.gpkg` | `gdal vector reproject --dst-crs=EPSG:6673 in.gpkg out.gpkg` |
| ラスタ座標変換 | `gdalwarp -t_srs EPSG:6673 in.tif out.tif` | `gdal raster reproject --dst-crs=EPSG:6673 in.tif out.tif` |

## 切り出し・結合

| やりたいこと | 従来 | 新CLI（3.11+） |
|--------------|------|----------------|
| ラスタを範囲で切る | `gdal_translate -projwin xmin ymax xmax ymin in.tif out.tif` | `gdal raster clip --bbox=xmin,ymin,xmax,ymax in.tif out.tif` |
| ラスタをポリゴンで切る | `gdalwarp -cutline a.gpkg -crop_to_cutline in.tif out.tif` | `gdal raster clip --like=a.gpkg in.tif out.tif` |
| ベクタをポリゴンで切る | `ogr2ogr -clipsrc a.gpkg out.gpkg in.gpkg` | `gdal vector clip --like=a.gpkg in.gpkg out.gpkg` |
| ラスタの結合 | `gdalbuildvrt m.vrt *.tif` | `gdal raster mosaic *.tif m.vrt` |
| ベクタの結合 | `ogrmerge.py -single -o m.gpkg a.gpkg b.gpkg` | `gdal vector concat --mode=single a.gpkg b.gpkg m.gpkg` |
| 属性で抽出 | `ogr2ogr -where "pop>1000" out.gpkg in.gpkg` | `gdal vector filter --where "pop>1000" in.gpkg out.gpkg` |

## 地形解析

| やりたいこと | 従来 | 新CLI（3.11+） |
|--------------|------|----------------|
| 陰影図 | `gdaldem hillshade dem.tif hs.tif` | `gdal raster hillshade dem.tif hs.tif` |
| 傾斜 | `gdaldem slope dem.tif slope.tif` | `gdal raster slope dem.tif slope.tif` |

## よく使う座標参照系（岡山周辺）

| EPSG | 名称 | 用途 |
|------|------|------|
| 4326 | WGS 84（緯度経度） | GPS、Webで配布されるデータ |
| 6668 | JGD2011（緯度経度） | 国土数値情報など国内データ |
| 6673 | JGD2011 / 平面直角座標系 第V系 | 岡山・鳥取・兵庫での距離・面積計算 |
| 6690 | JGD2011 / UTM 53N | 県境をまたぐ広域 |
| 3857 | Web メルカトル | Web地図タイル（面積計算には使わない） |

## シェルの基本

| コマンド | 意味 |
|----------|------|
| `pwd` | 今いる場所 |
| `ls -l` | ファイル一覧 |
| `cd data/raw` | 移動 |
| `mkdir -p data/work` | フォルダ作成 |
| `cmd --help` | ヘルプを見る |
| `cmd > log.txt` | 出力をファイルへ |
| `cmd1 \| cmd2` | 出力を次のコマンドへ渡す |
| `history` | 自分が実行したコマンドの履歴 |

!!! warning "GDAL 3.11 以上の新CLIについて"
    オプション名は GDAL のバージョンで変わることがあります。使う前に必ず `gdal raster clip --help` のように確認してください。
