# CLAUDE.md

## プロジェクト概要

反抗期届け — フォーム入力からPDF（反抗期届け）を生成するRailsアプリ。
多言語対応（ja / en / zh）。認証なし・ステートレスな構成。

## 技術スタック

- Ruby 3.1.1 / Rails 6.1.5
- Webpacker 5 + Tailwind CSS 2 (postcss7-compat)
- SQLite3 (dev/test) / PostgreSQL (production)
- PDF生成: Prawn / Prawn-Table
- デプロイ: Heroku (Docker)

## 開発コマンド

```bash
# サーバー起動
bin/rails server                  # localhost:3000
yarn dev                          # Webpack dev server (別ターミナル)

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
```

## 注意事項

- ローカルNodeバージョンとプロジェクト指定(.node-version: 15)が異なる場合、Webpack起動時に `NODE_OPTIONS=--openssl-legacy-provider` が必要（`yarn dev` には設定済み）
- `Procfile` / `Procfile.dev` は存在しない。サーバーとWebpackは別ターミナルで起動する
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
lib/pdf/
  notification_pdf/post_pdf.rb  # PDF生成ロジック (Prawn)
config/locales/                 # i18n翻訳ファイル (ja/en/zh)
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
