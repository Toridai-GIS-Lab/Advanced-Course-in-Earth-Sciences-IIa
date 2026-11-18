# 5. コマンドの連結とバッチ処理

**形式：ハンズオン（約90分）**

## 5.1 パイプ処理（20分）

### シェルのパイプ `|`

左のコマンドの出力を、右のコマンドの入力に渡します。
`gdal ... info` は `--format json` で JSON を出せるので、`jq` で必要な値だけ取り出せます。

```bash
# 市町村数
gdal vector info --format json data/work/admin_6673.gpkg | jq '.layers[0].featureCount'

# DEMの統計値だけを取り出す
gdal raster info --stats --format json data/work/dem_okayama_city.tif \
  | jq '.bands[0] | {min: .minimum, max: .maximum, mean: .mean}'

# SQL で集計（SQLite 方言）：市町村ごとの面積 [km²]
gdal vector info --features --dialect SQLite \
  --sql "SELECT N03_004, SUM(ST_Area(geom))/1e6 AS area_km2 FROM admin GROUP BY N03_004 ORDER BY area_km2 DESC" \
  data/work/admin_6673.gpkg
```

### GDAL の pipeline `!`

GDAL の処理同士は `pipeline` でつなげられます。**中間ファイルを作りません。**

```bash
gdal raster pipeline \
  read data/work/dem_mosaic.vrt ! \
  reproject -d EPSG:6673 -r bilinear --resolution 30,30 ! \
  clip --like data/work/admin_6673.gpkg --like-where "N03_004 = '岡山市'" ! \
  write --overwrite --of COG data/output/dem_okayama_city.tif
```

```bash
gdal vector pipeline \
  read data/raw/okayama_admin.gpkg ! \
  filter --where "N03_004 = '倉敷市'" ! \
  reproject -d EPSG:6673 ! \
  write --overwrite data/work/kurashiki.gpkg
```

!!! question "考えてみよう"
    `|` と `!` は何が違うでしょうか？
    （ヒント：`|` は **シェル** が文字をつなぐ。`!` は **GDAL** がデータをつなぐ。）

## 5.2 シェルスクリプトの基礎（25分）

昨日の `history` を、**ファイルに書いた手順** に変えます。

```bash title="scripts/01_prepare.sh"
--8<-- "scripts/01_prepare.sh"
```

```bash
bash scripts/01_prepare.sh
```

!!! tip "スクリプトを書くときの3原則"
    1. **パスと定数は冒頭に変数で書く**（座標系を変えたくなったら1か所直すだけ）
    2. **`set -euo pipefail` を書く**（途中で失敗したのに最後まで進むのを防ぐ）
    3. **`--overwrite` を付ける**（何度実行しても同じ結果になるように）

## 5.3 繰り返し処理（20分）

```bash
# すべてのDEMタイルを COG に変換
mkdir -p data/work/cog
for f in data/raw/dem/*.tif; do
  name=$(basename "$f" .tif)
  gdal raster convert --quiet --overwrite --of COG "$f" "data/work/cog/${name}.tif"
done
```

```bash
# 市町村ごとにDEMを切り出す
mkdir -p data/work/by_city
gdal vector info --format json --features \
  --sql "SELECT DISTINCT N03_004 FROM admin" data/work/admin_6673.gpkg \
  | jq -r '.layers[0].features[].properties.N03_004' \
  | while read -r city; do
      gdal raster clip --quiet --overwrite \
        --like data/work/admin_6673.gpkg --like-where "N03_004 = '${city}'" \
        data/work/dem_6673.tif "data/work/by_city/${city}.tif"
    done
```

## 5.4 複数データの一括処理（25分）

市町村ごとの標高統計を、1つのCSVにまとめます。

### 方法1：ループで書く

```bash
OUT=data/output/elevation_by_city.csv
mkdir -p data/output
echo "city,min,max,mean,std" > "$OUT"

for f in data/work/by_city/*.tif; do
  city=$(basename "$f" .tif)
  gdal raster info --stats --format json "$f" \
    | jq -r --arg c "$city" '.bands[0] | [$c, .minimum, .maximum, .mean, .stdDev] | @csv' \
    >> "$OUT"
done
```

### 方法2：専用のコマンドを使う

```bash title="scripts/02_stats.sh"
--8<-- "scripts/02_stats.sh"
```

!!! question "考えてみよう"
    方法1と方法2で、結果はわずかに違います。なぜでしょうか？
    （ヒント：方法1は「切り抜いたラスタ」、方法2は「元のラスタとポリゴン」から計算している。境界のセルの扱いは？）

    道具が増えると、同じ問いに複数の解き方が生まれます。**どちらで計算したかが記録に残っていれば**、違いを後から説明できます。

!!! example "やってみよう"
    平均標高が最も高い市町村を、CSVを目で見て探すのではなく、コマンドで出してみましょう。

    ```bash
    sort -t, -k4 -n -r data/output/elevation_by_city.csv | head -3
    ```
