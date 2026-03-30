#!/usr/bin/env python3
"""SUUMO土地検索スクレイパー - Playwrightベース"""

import argparse
import json
import re
import sys
import time
import urllib.request
from pathlib import Path
from urllib.parse import urljoin, urlparse, parse_qs, urlencode

from playwright.sync_api import sync_playwright, TimeoutError as PlaywrightTimeout


def parse_args():
    parser = argparse.ArgumentParser(description="SUUMO土地検索スクレイパー")
    parser.add_argument("--url", required=True, help="SUUMO一覧ページURL")
    parser.add_argument("--detail", action="store_true", help="詳細ページも取得")
    parser.add_argument("--images", action="store_true", help="画像もダウンロード")
    parser.add_argument("--output", default="results.json", help="出力JSONファイル")
    parser.add_argument("--image-dir", default="images", help="画像保存ディレクトリ")
    parser.add_argument("--max-pages", type=int, default=0, help="最大ページ数 (0=無制限)")
    parser.add_argument("--delay", type=float, default=1.0, help="リクエスト間隔(秒)")
    return parser.parse_args()


def extract_listing_properties(page) -> list[dict]:
    """一覧ページから物件情報を抽出する"""
    return page.evaluate("""() => {
        const units = document.querySelectorAll('.property_unit');
        return Array.from(units).map(unit => {
            const prop = {};

            // Title + detail URL
            const titleA = unit.querySelector('.property_unit-title a');
            if (titleA) {
                prop.title = titleA.textContent.trim();
                prop.detailUrl = titleA.href;
            }

            // Tags
            const tags = unit.querySelectorAll('.property_unit-pcts .ui-pct');
            prop.tags = Array.from(tags)
                .map(t => t.textContent.trim())
                .filter(t => !['区画図','土地写真','前面道路','建築プラン例','周辺環境'].includes(t));

            // Main image URL (lazy-loaded via rel attribute)
            const mainImg = unit.querySelector('.ui-thumb img[rel]');
            if (mainImg) {
                prop.imageUrl = mainImg.getAttribute('rel');
            }

            // All dt/dd pairs from dottable--cassette
            const cassette = unit.querySelector('.dottable--cassette');
            if (cassette) {
                const dls = cassette.querySelectorAll('dl');
                dls.forEach(dl => {
                    const dt = dl.querySelector('dt');
                    const dd = dl.querySelector('dd');
                    if (dt && dd) {
                        const key = dt.textContent.trim();
                        // Normalize whitespace and handle sup tags (m2 → m²)
                        let value = dd.textContent.replace(/\\s+/g, ' ').trim();
                        if (key && value) {
                            prop[key] = value;
                        }
                    }
                });
            }

            return prop;
        }).filter(p => p.title);
    }""")


def get_total_count(page) -> int | None:
    """検索結果の総件数を取得"""
    return page.evaluate("""() => {
        const el = document.querySelector('.pagination_set-hit');
        if (el) {
            const m = el.textContent.match(/(\\d+)/);
            return m ? parseInt(m[1]) : null;
        }
        return null;
    }""")


def get_pagination_urls(page, base_url: str) -> list[str]:
    """ページネーションの全URLを取得"""
    return page.evaluate("""(baseUrl) => {
        const links = document.querySelectorAll('.pagination-parts a');
        const urls = new Set();
        links.forEach(a => {
            if (a.href && !a.classList.contains('pagination-current')) {
                urls.add(a.href);
            }
        });
        return Array.from(urls);
    }""", base_url)


def extract_detail_fields(page) -> dict:
    """詳細ページから追加フィールドを抽出"""
    return page.evaluate("""() => {
        const detail = {};

        // Main detail table: th/td pairs
        const rows = document.querySelectorAll('table tr');
        rows.forEach(tr => {
            const ths = tr.querySelectorAll('th');
            const tds = tr.querySelectorAll('td');
            // Handle rows with multiple th/td pairs (2-column layout)
            for (let i = 0; i < ths.length && i < tds.length; i++) {
                const thDiv = ths[i].querySelector('div.fl');
                const key = thDiv ? thDiv.textContent.trim() : ths[i].textContent.trim();
                let value = tds[i].textContent.replace(/\\s+/g, ' ').trim();
                // Clean up hint links and navigation text
                value = value.replace(/\\[.*?\\]/g, '').replace(/乗り換え案内/g, '').trim();
                if (key && value && value !== '-') {
                    detail[key] = value;
                }
            }
        });

        // 情報提供日 from definitionlist
        const dtEls = document.querySelectorAll('.definitionlist dt');
        dtEls.forEach((dt, i) => {
            const dd = dt.nextElementSibling;
            if (dd) {
                const key = dt.textContent.replace(':', '').trim();
                const value = dd.textContent.trim();
                if (key && value) {
                    detail[key] = value;
                }
            }
        });

        return detail;
    }""")


# Fields of interest from the detail page
DETAIL_FIELDS = [
    "用途地域", "私道負担・道路", "土地の権利形態", "引き渡し時期",
    "土地状況", "販売区画数", "総区画数", "建築条件", "地目",
    "その他制限事項", "その他概要・特記事項", "造成完了時期",
    "情報提供日", "次回更新予定日",
]


def scrape_listing_pages(page, start_url: str, max_pages: int, delay: float) -> list[dict]:
    """一覧ページを全ページ巡回して物件を収集"""
    all_properties = []
    visited_urls = set()

    print(f"Loading: {start_url}", file=sys.stderr)
    page.goto(start_url, wait_until="domcontentloaded")
    page.wait_for_selector(".property_unit", timeout=15000)

    total = get_total_count(page)
    if total:
        print(f"Total properties found: {total}", file=sys.stderr)

    page_num = 1
    current_url = start_url

    while True:
        if current_url in visited_urls:
            break
        visited_urls.add(current_url)

        if max_pages > 0 and page_num > max_pages:
            break

        properties = extract_listing_properties(page)
        print(f"Page {page_num}: {len(properties)} properties", file=sys.stderr)
        all_properties.extend(properties)

        # Find the next page URL
        pagination_urls = get_pagination_urls(page, current_url)

        # Find "次へ" (next) link or the next numbered page
        next_url = None
        next_link = page.evaluate("""() => {
            // Look for "次へ" link
            const links = document.querySelectorAll('.pagination-parts a');
            for (const a of links) {
                if (a.textContent.includes('次へ')) {
                    return a.href;
                }
            }
            return null;
        }""")

        if next_link:
            next_url = next_link
        elif pagination_urls:
            # Find URLs with higher page numbers
            parsed = urlparse(current_url)
            current_params = parse_qs(parsed.query)
            current_page = int(current_params.get("pn", [1])[0]) if "pn" in current_params else page_num

            for url in pagination_urls:
                p = urlparse(url)
                params = parse_qs(p.query)
                pn = int(params.get("pn", [1])[0]) if "pn" in params else 0
                if pn == current_page + 1 and url not in visited_urls:
                    next_url = url
                    break

        if not next_url:
            break

        print(f"Next page: {next_url}", file=sys.stderr)
        time.sleep(delay)
        page.goto(next_url, wait_until="domcontentloaded")
        try:
            page.wait_for_selector(".property_unit", timeout=15000)
        except PlaywrightTimeout:
            print("No properties found on page, stopping pagination.", file=sys.stderr)
            break

        current_url = next_url
        page_num += 1

    return all_properties


def scrape_detail(page, url: str, delay: float) -> dict:
    """詳細ページから追加情報を取得"""
    time.sleep(delay)
    page.goto(url, wait_until="load")
    try:
        # Wait for the main property detail table with th headers
        page.wait_for_selector("th.thSideLGray", timeout=30000)
    except PlaywrightTimeout:
        print(f"  Warning: timeout loading detail page {url}", file=sys.stderr)
        return {}

    all_fields = extract_detail_fields(page)

    # Filter to only the fields we care about
    result = {}
    for field in DETAIL_FIELDS:
        if field in all_fields:
            result[field] = all_fields[field]

    return result


def download_image(url: str, save_path: Path) -> bool:
    """画像をダウンロード"""
    try:
        req = urllib.request.Request(url, headers={
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
            "Referer": "https://suumo.jp/",
        })
        with urllib.request.urlopen(req, timeout=10) as resp:
            save_path.write_bytes(resp.read())
        return True
    except Exception as e:
        print(f"  Warning: failed to download {url}: {e}", file=sys.stderr)
        return False


def main():
    args = parse_args()
    output_path = Path(args.output)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
            locale="ja-JP",
        )
        page = context.new_page()

        # 1. Scrape listing pages
        properties = scrape_listing_pages(page, args.url, args.max_pages, args.delay)
        print(f"\nTotal properties collected: {len(properties)}", file=sys.stderr)

        # 2. Scrape detail pages if requested
        if args.detail:
            print("\nFetching detail pages...", file=sys.stderr)
            for i, prop in enumerate(properties):
                detail_url = prop.get("detailUrl")
                if not detail_url:
                    continue
                print(f"  [{i+1}/{len(properties)}] {detail_url}", file=sys.stderr)
                detail = scrape_detail(page, detail_url, args.delay)
                prop["detail"] = detail

        # 3. Download images if requested
        if args.images:
            image_dir = Path(args.image_dir)
            image_dir.mkdir(parents=True, exist_ok=True)
            print(f"\nDownloading images to {image_dir}/...", file=sys.stderr)
            for i, prop in enumerate(properties):
                image_url = prop.get("imageUrl")
                if not image_url:
                    continue
                # Generate filename from property index and URL
                ext = ".jpg"
                filename = f"property_{i+1:03d}{ext}"
                save_path = image_dir / filename
                print(f"  [{i+1}/{len(properties)}] {filename}", file=sys.stderr)
                if download_image(image_url, save_path):
                    prop["imagePath"] = str(save_path)

        browser.close()

    # 4. Output JSON
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(properties, f, ensure_ascii=False, indent=2)

    print(f"\nResults saved to {output_path}", file=sys.stderr)
    print(f"Total: {len(properties)} properties", file=sys.stderr)

    # Print summary to stdout
    print(json.dumps({
        "total": len(properties),
        "output": str(output_path),
        "fields": sorted(set(k for p in properties for k in p.keys())),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
