# 5. コマンドの連結とバッチ処理

**形式：ハンズオン（約90分）**

## 5.1 パイプ処理（20分）

`|`（パイプ）は、左のコマンドの出力を右のコマンドの入力に渡します。

```bash
# 市町村名の一覧を取り出す
ogrinfo -al -q data/work/admin_6673.gpkg | grep "N03_004" | sort -u

# DEMの統計値だけを JSON から取り出す
gdalinfo -stats -json data/work/dem_okayama_city.tif \
  | jq '.bands[0] | {min: .minimum, max: .maximum, mean: .mean}'

# SQL で集計（OGR SQL / SQLite 方言）
ogrinfo -dialect SQLite -sql \
  "SELECT N03_004, SUM(ST_Area(geom))/1e6 AS area_km2 FROM admin GROUP BY N03_004 ORDER BY area_km2 DESC" \
  data/work/admin_6673.gpkg
```

### 新CLIの pipeline（GDAL 3.11+）

中間ファイルを作らずに、GDALの処理同士をつなげられます。

```bash
gdal raster pipeline \
  read data/work/dem_mosaic.vrt ! \
  reproject --dst-crs=EPSG:6673 -r bilinear ! \
  clip --like=data/work/okayama_city.gpkg ! \
  write --of=COG data/output/dem_okayama_city.tif
```

## 5.2 シェルスクリプトの基礎（25分）

昨日の `history` を、**ファイルに書いた手順** に変えます。

```bash title="scripts/01_prepare.sh"
#!/usr/bin/env bash
set -euo pipefail   # エラーが起きたら止まる・未定義変数を禁止

RAW=data/raw
WORK=data/work
CRS=EPSG:6673

mkdir -p "$WORK"

# 1. 行政界を平面直角座標系へ
ogr2ogr -overwrite -t_srs "$CRS" -nln admin "$WORK/admin_6673.gpkg" "$RAW/okayama_admin.gpkg"

# 2. DEMタイルを結合して座標変換
gdalbuildvrt -overwrite "$WORK/dem_mosaic.vrt" "$RAW"/dem/*.tif
gdalwarp -overwrite -t_srs "$CRS" -r bilinear -tr 30 30 \
  "$WORK/dem_mosaic.vrt" "$WORK/dem_6673.tif"

echo "done: $(date '+%F %T')"
```

```bash
bash scripts/01_prepare.sh
```

!!! tip "スクリプトを書くときの3原則"
    1. **パスと定数は冒頭に変数で書く**（座標系を変えたくなったら1か所直すだけ）
    2. **`set -euo pipefail` を書く**（途中で失敗したのに最後まで進むのを防ぐ）
    3. **`-overwrite` を付ける**（何度実行しても同じ結果になるように）

## 5.3 繰り返し処理（20分）

```bash
# すべてのDEMタイルを COG に変換
mkdir -p data/work/cog
for f in data/raw/dem/*.tif; do
  name=$(basename "$f" .tif)
  gdal_translate -of COG "$f" "data/work/cog/${name}.tif"
done
```

```bash
# 市町村ごとにDEMを切り出す
mkdir -p data/work/by_city
ogrinfo -q -dialect SQLite -sql "SELECT DISTINCT N03_004 FROM admin" \
  data/work/admin_6673.gpkg | grep "N03_004 (String)" | sed 's/.*= //' \
  | while read -r city; do
      gdalwarp -overwrite -cutline data/work/admin_6673.gpkg \
        -cwhere "N03_004 = '${city}'" -crop_to_cutline -dstnodata -9999 \
        data/work/dem_6673.tif "data/work/by_city/${city}.tif"
    done
```

## 5.4 複数データの一括処理（25分）

市町村ごとの標高統計を、1つのCSVにまとめます。

```bash title="scripts/02_stats.sh"
#!/usr/bin/env bash
set -euo pipefail

OUT=data/output/elevation_by_city.csv
mkdir -p data/output
echo "city,min,max,mean,std" > "$OUT"

for f in data/work/by_city/*.tif; do
  city=$(basename "$f" .tif)
  gdalinfo -stats -json "$f" \
    | jq -r --arg c "$city" \
      '.bands[0] | [$c, .minimum, .maximum, .mean, .stdDev] | @csv' \
    >> "$OUT"
done

echo "wrote $OUT"
```

!!! example "やってみよう"
    `elevation_by_city.csv` を開いて、平均標高が最も高い市町村を答えてください。
    答えを **CSVを目で見て探す** のではなく、コマンドで出してみましょう。

    ```bash
    sort -t, -k4 -n -r data/output/elevation_by_city.csv | head -3
    ```
