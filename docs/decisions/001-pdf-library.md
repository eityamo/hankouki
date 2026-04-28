# ADR-001: PDF生成ライブラリとしてPrawnを採用

## Status

Accepted

## Context

反抗期届けの PDF 出力が必要。Ruby で利用可能な PDF ライブラリとして Prawn, Wicked PDF (wkhtmltopdf), HexaPDF 等がある。

## Decision

Prawn + Prawn-Table を採用する。

理由:
- Pure Ruby で外部バイナリ依存なし（Cloudflare Docker 環境での運用が容易）
- 日本語フォント埋め込みに対応
- テーブルレイアウトは prawn-table で実現可能

## Consequences

- HTML → PDF 変換ではないため、ビューの再利用はできない
- PDF レイアウトは `lib/pdf/notification_pdf/post_pdf.rb` に Ruby コードとして記述する
- フォントファイルをリポジトリに含める必要がある
