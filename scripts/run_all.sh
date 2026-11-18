#!/usr/bin/env bash
# これ1本で、data/raw から最終成果物まで再生成する
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf data/work data/output
bash scripts/01_prepare.sh
bash scripts/02_stats.sh
