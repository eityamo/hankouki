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

## 境界線

### 常に実行
- `bin/rails test` を通すこと（テストが存在する場合）
- `bin/rails tailwindcss:build` が成功すること
- 3言語（ja/en/zh）の翻訳キーを揃えること

### 要確認（人間の承認を得てから実行）
- DBスキーマ変更（マイグレーション追加）
- gem の追加・削除
- ルーティング変更
- Dockerfile / デプロイ設定の変更

### 禁止
- `.env`、credentials、シークレットのコミット
- `vendor/` の直接編集
- `Gemfile.lock` の手動編集
- 既存APIの破壊的変更（URLパス変更等）

## コードパターン

### フォームオブジェクト（app/forms/）
```ruby
class XxxForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  # attribute / validates を定義
end
```

### PDF生成（lib/pdf/）
```ruby
# lib/pdf/notification_pdf/xxx_pdf.rb
module NotificationPdf
  class XxxPdf
    def initialize(form)
      @form = form
    end
    def render
      # Prawn::Document で PDF 生成
    end
  end
end
```

### Turbo + バイナリレスポンス
PDFなどバイナリを返すフォームには必ず `data: { turbo: false }` を付ける。
Turbo はデフォルトで fetch 送信するため、バイナリレスポンスを正しく処理できない。

## i18n 規約

- 基準言語: **ja**（日本語を先に書き、en/zh を揃える）
- ファイル構成:
  - `config/locales/{ja,en,zh}.yml` — 汎用翻訳
  - `config/locales/views/{ja,en,zh}.yml` — ビュー固有の翻訳
  - `config/locales/activerecord/{ja,en,zh}.yml` — モデル属性名
- キー命名: Rails 規約に従う（`{モデル名/コントローラ名}.{アクション名}.{キー名}`）
- ロケール切替: URLパラメータ `?locale=xx`（ApplicationController#set_locale）

## 関連ドキュメント

- `docs/AI_DEVELOPMENT_WORKFLOW.md` — AI駆動開発ワークフロー（SDD / ハーネスエンジニアリング）
- `docs/specs/` — 機能仕様書（TEMPLATE.md あり）
- `docs/decisions/` — ADR（Architecture Decision Records）

## デプロイ

```bash
git push heroku main            # Herokuへデプロイ
```

- リモート: `origin` → GitHub (`eityamo/Notification`), `heroku` → Heroku
