#!/usr/bin/env bash
# 元データ（data/raw）を、解析用の座標系にそろえる
set -euo pipefail

RAW=data/raw
WORK=data/work
CRS=EPSG:6673      # 平面直角座標系 第V系（岡山県）
RES=30,30          # 出力解像度 [m]

mkdir -p "$WORK"

# 1. 行政界を平面直角座標系へ
gdal vector reproject --overwrite -d "$CRS" --output-layer admin \
  "$RAW/okayama_admin.gpkg" "$WORK/admin_6673.gpkg"

# 2. DEMタイルを結合（VRT）して座標変換
gdal raster mosaic --overwrite "$RAW"/dem/*.tif "$WORK/dem_mosaic.vrt"
gdal raster reproject --overwrite -d "$CRS" -r bilinear --resolution "$RES" \
  "$WORK/dem_mosaic.vrt" "$WORK/dem_6673.tif"

# 3. 土地利用を1レイヤにまとめて、同時に座標変換
gdal vector concat --overwrite --mode=single -d "$CRS" --output-layer landuse \
  "$RAW"/landuse/*.shp "$WORK/landuse_6673.gpkg"

echo "done: $(date '+%F %T')"
