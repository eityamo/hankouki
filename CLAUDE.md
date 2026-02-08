# CLAUDE.md

## プロジェクト概要

反抗期届け — フォーム入力からPDF（反抗期届け）を生成するRailsアプリ。
多言語対応（ja / en / zh）。認証なし・ステートレスな構成。

## 技術スタック

- Ruby 3.3.6 / Rails 7.1.x
- importmap-rails + Tailwind CSS 4 (tailwindcss-rails)
- Turbo (turbo-rails)
- SQLite3 (dev/test) / PostgreSQL (production)
- PDF生成: Prawn / Prawn-Table
- デプロイ: Heroku (Docker)

## 開発コマンド

```bash
# サーバー起動
bin/rails server                  # localhost:3000
bin/rails tailwindcss:watch       # Tailwind CSS ビルド（別ターミナル、開発時）

# テスト
bin/rails test                    # Minitest

# DB
bin/rails db:create
bin/rails db:migrate

# コンソール
bin/rails console                 # pry-rails

# ルート確認
bin/rails routes

# アセット
bin/rails assets:precompile
bin/rails tailwindcss:build       # Tailwind CSS ビルド（単発）
```

## 注意事項

- Node.js は不要（importmap + tailwindcss-rails はNode非依存）
- `Procfile` / `Procfile.dev` は存在しない。サーバーとTailwind watchは別ターミナルで起動する
- テストはMinitest（デフォルト生成のスケルトンのみ）

## ディレクトリ構成（主要部分）

```
app/
  controllers/
    application_controller.rb   # ロケール管理
    records_controller.rb       # フォーム表示・PDF生成
  forms/
    records_form.rb             # バリデーション付きフォームオブジェクト
  views/records/                # フォーム・利用規約・プライバシーポリシー
  javascript/
    application.js              # importmap エントリーポイント
  assets/
    tailwind/application.css    # Tailwind CSS エントリーポイント
lib/pdf/
  notification_pdf/post_pdf.rb  # PDF生成ロジック (Prawn)
config/
  importmap.rb                  # JavaScript モジュールのピン設定
  locales/                      # i18n翻訳ファイル (ja/en/zh)
```

## コーディング規約

- コミットメッセージ・コメントは日本語OK
- ビューのインデントはタブ（既存コードに合わせる）
- Rubyコードはスペース2つインデント

## デプロイ

```bash
git push heroku main            # Herokuへデプロイ
```

- リモート: `origin` → GitHub (`eityamo/Notification`), `heroku` → Heroku
