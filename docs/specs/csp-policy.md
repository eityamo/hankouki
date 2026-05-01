# CSP (Content Security Policy) 定義スペック

## 目的

`csp_meta_tag` が出力されているがポリシー未定義のため、適切な CSP を設定して XSS 等の攻撃を緩和する。

## 背景

- `app/views/layouts/application.html.erb` で `<%= csp_meta_tag %>` を呼んでいるが、`config/initializers/content_security_policy.rb` が存在しない
- ポリシーが未定義のため CSP ヘッダーが出力されておらず、保護が機能していない
- TODO.md のセキュリティ項目として記載済み

## 技術スタック・制約

- Rails 7.1.x / Ruby 3.3.6
- importmap-rails（自動 nonce 付与）
- Tailwind CSS 4（tailwindcss-rails、ビルド済み CSS を Sprockets 経由で配信）
- Google Analytics（環境変数 `GA_TRACKING_ID` で制御、未設定時は無効）
- Google Fonts（`@import` で `fonts.googleapis.com` を読み込み）

## スコープ

### 範囲内

- `config/initializers/content_security_policy.rb` の作成
- インラインスクリプトの nonce 対応
- 外部リソース（Google Analytics, Google Fonts）の許可設定

### 範囲外

- `report-uri` / `report-to` の設定（レポート収集サーバーが未整備）
- インラインスクリプトの外部ファイル化（別タスク）

## 既決事項

- なし

## タスク分解

### フェーズ1: CSP イニシャライザ作成・インラインスクリプト nonce 対応

1. `config/initializers/content_security_policy.rb` を作成
2. `application.html.erb` のインラインスクリプト（GA, scroll）に `nonce: true` を追加
3. テスト実行・動作確認

## 許可する外部リソース一覧

| ディレクティブ | 許可先 | 理由 |
|---|---|---|
| `default-src` | `'self'` | 基本はすべて同一オリジン |
| `script-src` | `'self'`, nonce, `https://www.googletagmanager.com` | importmap + GA |
| `style-src` | `'self'`, `https://fonts.googleapis.com` | Tailwind + Google Fonts |
| `font-src` | `'self'`, `https://fonts.gstatic.com` | Google Fonts CDN |
| `img-src` | `'self'`, `https://www.googletagmanager.com` | ローカル画像 + GA pixel |
| `connect-src` | `'self'`, `https://www.google-analytics.com`, `https://www.googletagmanager.com`, `https://*.google-analytics.com` | GA イベント送信 |
| `frame-ancestors` | `'none'` | iframe 埋め込み禁止 |
| `object-src` | `'none'` | Flash/Java 等のプラグイン禁止 |
| `base-uri` | `'self'` | base タグ制限 |

## 検証基準

- [ ] `bin/rails test` が全てパス
- [ ] ブラウザの DevTools Console で CSP 違反エラーが出ないこと
- [ ] レスポンスヘッダーに `Content-Security-Policy` が含まれること

## 境界線

- ✅ 常に: `bin/rails test` を通すこと
- ⚠️ 要確認: なし（gem 追加なし、ルーティング変更なし）
- 🚫 禁止: `unsafe-inline`、`unsafe-eval` の使用

## 備考

- Rails 7.1 の `csp_meta_tag` は nonce-based CSP と連携する。`javascript_importmap_tags` は自動で nonce を付与する
- GA が無効（`GA_TRACKING_ID` 未設定）の環境では GA 関連のインラインスクリプト自体が出力されないため、nonce 不要
