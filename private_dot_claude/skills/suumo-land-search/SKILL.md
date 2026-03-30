---
name: suumo-land-search
description: SUUMOで土地を検索しスクレイピングする。駅名・価格帯・面積等の条件を指定可能。
allowed-tools: Bash(python:*), Bash(uv:*), Read, Write
---

# SUUMO 土地検索スクレイパー

SUUMOの土地検索結果をPlaywrightでスクレイピングし、JSON形式で出力するスキル。

## 使い方

### 基本（一覧ページのみ）

```bash
cd ~/.claude/skills/suumo-land-search
uv run python scripts/suumo_scraper.py \
  --url "SUUMO_SEARCH_URL" \
  --output results.json
```

### 詳細ページ付き

```bash
uv run python scripts/suumo_scraper.py \
  --url "SUUMO_SEARCH_URL" \
  --detail \
  --output results.json
```

### 画像付き

```bash
uv run python scripts/suumo_scraper.py \
  --url "SUUMO_SEARCH_URL" \
  --detail --images \
  --output results.json --image-dir images/
```

### オプション一覧

| オプション | デフォルト | 説明 |
|-----------|-----------|------|
| `--url` | (必須) | SUUMO一覧ページURL |
| `--detail` | off | 詳細ページも取得 |
| `--images` | off | 画像もダウンロード |
| `--output` | `results.json` | 出力先JSONファイル |
| `--image-dir` | `images/` | 画像保存ディレクトリ |
| `--max-pages` | 0 (無制限) | 最大ページ数 |
| `--delay` | 1.0 | リクエスト間隔(秒) |

## URL構築

SUUMOの土地検索URLは以下の形式:
```
https://suumo.jp/jj/bukken/ichiran/JJ012FC001/?ar=030&bs=030&...
```

URLパラメータの詳細は `references/url_params.md` を参照。

### よく使う検索例

**目黒駅周辺の土地（全件）**:
```
https://suumo.jp/jj/bukken/ichiran/JJ012FC001/?ar=030&bs=030&ra=030013&rnek=000539110&rn=0005&cn=9999999&et=9999999&hb=0&ht=9999999&kb=1&kj=9&km=1&kt=9999999&mb=0&mt=9999999&ni=9999999&ohf=0&pc=30&pj=1&po=0&tb=0&tj=0&tt=9999999
```

## 出力フォーマット

### 一覧ページ（基本フィールド）
```json
{
  "title": "■ 都心近接ながら静かな住環境...",
  "detailUrl": "https://suumo.jp/tochi/tokyo/sc_meguro/nc_78312654/",
  "tags": ["建築条件付土地", "購入サポート情報"],
  "imageUrl": "https://img01.suumo.com/...",
  "物件名": "【ADCAST】 下目黒5丁目...",
  "販売価格": "7480万円",
  "所在地": "東京都目黒区下目黒５",
  "沿線・駅": "ＪＲ山手線「目黒」徒歩20分",
  "土地面積": "54.74m2（実測）",
  "坪単価": "451.8万円／坪",
  "建ぺい率・容積率": "60％・150％"
}
```

### 詳細ページ（`--detail` オプション）
```json
{
  "detail": {
    "用途地域": "１種低層",
    "私道負担・道路": "無、南西6.5ｍ幅（接道幅4.8ｍ）",
    "土地の権利形態": "所有権",
    "引き渡し時期": "即引渡し可",
    "土地状況": "更地",
    "販売区画数": "1区画",
    "建築条件": "付",
    "地目": "宅地",
    "情報提供日": "26/2/7"
  }
}
```

## セットアップ

初回実行時に以下が必要:

```bash
cd ~/.claude/skills/suumo-land-search
uv sync
uv run playwright install chromium
```
