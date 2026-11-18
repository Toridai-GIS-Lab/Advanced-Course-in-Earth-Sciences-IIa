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

| 対象 | ライセンス |
|------|------------|
| 文章・図（`docs/` 内の解説文など） | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja)（`LICENSE`） |
| コード（コマンド例、`scripts/` 内のスクリプト、設定ファイル） | [The Unlicense](https://unlicense.org/)（`LICENSE-CODE`） |

資料中のコマンド例やスクリプトの多くは、GDAL などの道具の標準的な使い方を並べたものであり、著作物には当たらないと考えています。
ただし、その判断は個々のケースで異なりうるため、権利関係で利用をためらうことがないよう、コード部分は The Unlicense によりパブリックドメインに提供します。
クレジット表示なしで、自由にコピー・改変・再利用してください。
