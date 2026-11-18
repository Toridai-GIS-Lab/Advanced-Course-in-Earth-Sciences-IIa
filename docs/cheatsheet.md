# コマンド早見表

この講義では GDAL の統一コマンド **`gdal`** を使います（GDAL 3.13.3 で動作確認）。
右の列の **従来コマンド** は、Webの解説や QGIS のプロセシング履歴を読むときの対応表として使ってください。

## 確認

| やりたいこと | この講義 | 従来コマンド |
|--------------|----------|--------------|
| ラスタの情報 | `gdal raster info dem.tif` | `gdalinfo dem.tif` |
| ラスタの統計 | `gdal raster info --stats dem.tif` | `gdalinfo -stats dem.tif` |
| ベクタの概要 | `gdal vector info a.gpkg` | `ogrinfo -so -al a.gpkg` |
| 地物の中身 | `gdal vector info --limit 3 a.gpkg` | `ogrinfo -al a.gpkg` |
| JSONで出力 | `gdal raster info --format json dem.tif` | `gdalinfo -json dem.tif` |
| SQLで問い合わせ | `gdal vector info --features --sql "SELECT ..." a.gpkg` | `ogrinfo -sql "SELECT ..." a.gpkg` |

## 変換

| やりたいこと | この講義 | 従来コマンド |
|--------------|----------|--------------|
| ベクタ形式変換 | `gdal vector convert in.shp out.gpkg` | `ogr2ogr out.gpkg in.shp` |
| ラスタ形式変換 | `gdal raster convert --of COG in.tif out.tif` | `gdal_translate -of COG in.tif out.tif` |
| CSV → 点 | `gdal vector make-point --x lon --y lat --output-crs EPSG:4326 in.csv out.gpkg` | `ogr2ogr -oo X_POSSIBLE_NAMES=lon ...` |
| ベクタ座標変換 | `gdal vector reproject -d EPSG:6673 in.gpkg out.gpkg` | `ogr2ogr -t_srs EPSG:6673 out.gpkg in.gpkg` |
| ラスタ座標変換 | `gdal raster reproject -d EPSG:6673 -r bilinear in.tif out.tif` | `gdalwarp -t_srs EPSG:6673 -r bilinear in.tif out.tif` |
| 座標系の付け替え | `gdal raster edit --crs EPSG:6668 a.tif` | `gdal_edit.py -a_srs EPSG:6668 a.tif` |

## 切り出し・結合

| やりたいこと | この講義 | 従来コマンド |
|--------------|----------|--------------|
| ラスタを範囲で切る | `gdal raster clip --bbox xmin,ymin,xmax,ymax in.tif out.tif` | `gdal_translate -projwin xmin ymax xmax ymin in.tif out.tif` |
| ラスタを形で切る | `gdal raster clip --like a.gpkg in.tif out.tif` | `gdalwarp -cutline a.gpkg -crop_to_cutline in.tif out.tif` |
| ベクタを形で切る | `gdal vector clip --like a.gpkg in.gpkg out.gpkg` | `ogr2ogr -clipsrc a.gpkg out.gpkg in.gpkg` |
| 属性で抽出 | `gdal vector filter --where "pop>1000" in.gpkg out.gpkg` | `ogr2ogr -where "pop>1000" out.gpkg in.gpkg` |
| ラスタの結合 | `gdal raster mosaic *.tif m.vrt` | `gdalbuildvrt m.vrt *.tif` |
| ベクタの結合 | `gdal vector concat --mode=single *.shp m.gpkg` | `ogrmerge.py -single -o m.gpkg *.shp` |

## 解析

| やりたいこと | この講義 | 従来コマンド |
|--------------|----------|--------------|
| 陰影図 | `gdal raster hillshade dem.tif hs.tif` | `gdaldem hillshade dem.tif hs.tif` |
| 傾斜 | `gdal raster slope dem.tif slope.tif` | `gdaldem slope dem.tif slope.tif` |
| ラスタ演算 | `gdal raster calc -i A=slope.tif --calc "A > 15" out.tif` | `gdal_calc.py -A slope.tif --calc "A>15" --outfile out.tif` |
| 再分類 | `gdal raster reclassify -m "[0,15)=1; [15,90]=2; NO_DATA=NO_DATA" in.tif out.tif` | （`gdal_calc.py` で式を書く） |
| ゾーン統計 | `gdal raster zonal-stats --zones a.gpkg --stat mean dem.tif out.csv` | （従来コマンドには無い） |
| バッファ | `gdal vector buffer --distance 1000 in.gpkg out.gpkg` | `ogr2ogr -dialect SQLite -sql "SELECT ST_Buffer(geom,1000) ..."` |

## つなぐ

```bash
# GDAL の処理を ! でつなぐ（中間ファイルなし）
gdal raster pipeline read in.tif ! reproject -d EPSG:6673 ! clip --like a.gpkg ! write out.tif
gdal vector pipeline read in.gpkg ! filter --where "..." ! reproject -d EPSG:6673 ! write out.gpkg
```

## 共通オプション

| オプション | 意味 |
|-----------|------|
| `--overwrite` | 出力ファイルを上書きする（無いと、既存ファイルがあればエラー） |
| `--of`, `-f` | 出力形式（`COG`, `GPKG`, `CSV` など） |
| `--quiet` | 進捗表示を出さない（ループの中で便利） |
| `--output-layer` | 出力レイヤ名（ベクタ） |
| `--format json` | `info` の結果を JSON で出す |
| `--help` | ヘルプ（オプション名に迷ったらまずこれ） |

## よく使う座標参照系（岡山周辺）

| EPSG | 名称 | 用途 |
|------|------|------|
| 4326 | WGS 84（緯度経度） | GPS、Webで配布されるデータ |
| 6668 | JGD2011（緯度経度）※ | 国土数値情報など国内データ |
| 6673 | JGD2011 / 平面直角座標系 第V系 ※ | 岡山・鳥取・兵庫での距離・面積計算 |
| 6690 | JGD2011 / UTM 53N ※ | 県境をまたぐ広域 |
| 3857 | Web メルカトル | Web地図タイル（面積計算には使わない） |

※ 最近の GDAL/PROJ では名称が **JGD2024** と表示されます（コード番号は同じ）。

## シェルの基本

| コマンド | 意味 |
|----------|------|
| `pwd` | 今いる場所 |
| `ls -l` | ファイル一覧 |
| `cd data/raw` | 移動 |
| `mkdir -p data/work` | フォルダ作成 |
| `cmd > log.txt` | 出力をファイルへ |
| `cmd1 \| cmd2` | 出力を次のコマンドへ渡す |
| `history` | 自分が実行したコマンドの履歴 |
