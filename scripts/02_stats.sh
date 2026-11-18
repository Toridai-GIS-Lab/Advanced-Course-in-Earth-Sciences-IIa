#!/usr/bin/env bash
# 市町村ごとの標高統計を CSV にする
set -euo pipefail

WORK=data/work
OUT=data/output
mkdir -p "$OUT"

gdal raster zonal-stats --overwrite \
  --zones "$WORK/admin_6673.gpkg" --include-field N03_004 \
  --stat min --stat max --stat mean --stat stdev \
  "$WORK/dem_6673.tif" "$OUT/elevation_by_city.csv"

gdal --version > "$OUT/env.txt"
echo "wrote $OUT/elevation_by_city.csv"
