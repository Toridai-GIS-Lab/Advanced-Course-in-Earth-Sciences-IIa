# Advanced Course in Earth Sciences IIa

岡山大学 集中講義「CLIによる空間データ処理」（原案）の講義サイトのソース。

公開URL: https://toridai-gis-lab.github.io/Advanced-Course-in-Earth-Sciences-IIa/

MkDocs Material で作成した講義サイトのソース。

## ローカルで確認

```bash
pip install mkdocs-material
mkdocs serve
```

## 公開

`main` に push すると GitHub Actions が `gh-pages` ブランチにビルドする。
初回のみ、リポジトリの Settings → Pages → Source を `gh-pages` ブランチに設定する。

## 構成

- `docs/process.md` … 講義の中心となる考え方（過程が残る道具を使う）
- `docs/day1/`, `docs/day2/` … 各コマの資料
- `.devcontainer/` … Codespaces 用の受講環境定義

## ライセンス

本リポジトリの内容は [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja) で提供する。
