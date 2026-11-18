# 配布データ

!!! warning "原案"
    ファイル名・入手先は講義前に講師が確定し、リポジトリの `data/raw/` に置きます。
    受講者は **`data/raw/` の中身を書き換えない** でください（元データは読むだけ）。

## フォルダ構成

```text
data/
├── raw/          # 元データ（読み取り専用。手で触らない）
├── work/         # 中間ファイル（消しても再生成できる）
└── output/       # 最終成果物
```

`work/` と `output/` は **消しても、スクリプトを実行すれば元に戻る** ことが前提です。
戻らないなら、どこかで手作業が入っています。

## 使用データ（案）

| ファイル（案） | 内容 | 種類 | 出典 |
|----------------|------|------|------|
| `okayama_admin.gpkg` | 岡山県の市町村境界 | ベクタ（ポリゴン） | 国土数値情報 行政区域データ（N03） |
| `dem/*.tif` | 岡山県周辺の標高（約30m） | ラスタ（複数タイル） | Copernicus DEM GLO-30 |
| `landuse/*.shp` | 土地利用細分メッシュ | ベクタ | 国土数値情報 土地利用細分メッシュ（L03-b） |
| `stations.csv` | 気象観測所の位置（緯度経度） | 表（点） | 気象庁 |

### Copernicus DEM をCLIで直接読む

Copernicus DEM は COG（Cloud Optimized GeoTIFF）でクラウド上に公開されており、**ダウンロードせずに** GDAL で読めます。

```bash
gdal raster info /vsicurl/https://copernicus-dem-30m.s3.amazonaws.com/Copernicus_DSM_COG_10_N34_00_E133_00_DEM/Copernicus_DSM_COG_10_N34_00_E133_00_DEM.tif
```

<!-- TODO: URL・タイル名は講義前に要確認 -->

## ライセンス

各データの利用条件は出典元に従います。国土数値情報は商用利用可否がデータごとに異なるため、成果物を公開する場合は確認してください。
