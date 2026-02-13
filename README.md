# 反抗期届

フォーム入力から「反抗期届」のPDFを生成するWebアプリケーション。
多言語対応（日本語 / English / 中文）。

## 技術スタック

- Ruby 3.3.6 / Rails 7.1
- Puma 7
- importmap-rails（Node.js 不要）
- Tailwind CSS 4（tailwindcss-rails）
- Turbo（turbo-rails）
- SQLite3（開発・テスト） / PostgreSQL（本番）
- PDF生成: Prawn / Prawn-Table
- デプロイ: Heroku（Docker）

## 必要な環境

- Ruby 3.3.6
- Bundler 2.5+
- SQLite3

Node.js は不要です。

## セットアップ

```bash
# リポジトリをクローン
git clone https://github.com/eityamo/Notification.git
cd Notification

# gem のインストール
bundle install

# データベースの作成・マイグレーション
bin/rails db:create
bin/rails db:migrate
```

## 開発サーバーの起動

ターミナルを2つ使います。

```bash
# ターミナル1: Rails サーバー
bin/rails server
```

```bash
# ターミナル2: Tailwind CSS のウォッチビルド
bin/rails tailwindcss:watch
```

http://localhost:3000 でアクセスできます。

## テスト

```bash
bin/rails test
```

## デプロイ（Heroku）

```bash
git push heroku main
```

`Dockerfile` / `entrypoint.sh` は Heroku デプロイ専用です。ローカル開発では Docker は使用しません。
