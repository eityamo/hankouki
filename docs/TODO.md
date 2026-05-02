# TODO（やり残し課題）

## アクセシビリティ
- [x] **フォームフィールドの必須/任意表示がない**
  - `required` 属性と `presence` バリデーションを追加済み

## PDF 生成の堅牢性
- [x] **英語/中国語テキストで座標レイアウトが崩れる可能性**
  - `overflow: :shrink_to_fit` で自動縮小対応済み
- [x] **印鑑レイアウトが文字幅未考慮**
  - `overflow: :shrink_to_fit` 追加済み

## パフォーマンス / アセット

- [x] **未使用フォントファイルが 4 ウェイト含まれている**
  - ExtraLight, Medium, Normal, Regular, ZeroGothic を削除済み
- [x] **未使用画像ファイルが複数存在**
  - clipboard_black1, clipboard_brown1, favicon, favicon1, fingerprint.png, ogp5, title を削除済み
- [x] **PDF テストの実行速度改善**
  - テスト統合 + クラスレベルキャッシュで冗長レンダーを削減

## 設定 / インフラ

- [x] **vendor/bundle がリポジトリに含まれている**
  - `.gitignore` に記載済み、`vendor/.keep` のみ追跡
- [x] **database.yml の production で SQLite adapter が継承されている**
  - `url: ENV['DATABASE_URL']` で対応済み
- [ ] **Cloudflare デプロイ手順の確定・記載**
- [x] **Heroku 関連の残骸クリーンアップ**
  - README.md を Cloudflare に更新済み

## コード品質
- [x] **CSS クラスの膨大な重複（DRY 違反）**
  - `form_input_class` 等のヘルパーに集約済み
- [x] **PDF 座標のマジックナンバー**
  - 定数化済み
- [x] **ApplicationRecord が不要**
  - 削除済み
- [x] **404/500 ページが英語のみ**
  - ErrorsController で動的多言語エラーページに変更済み
- [x] **.gitignore の重複整理**
  - gibo 2重実行の重複を1つに整理済み

## UI の向上
- [x] **フォームのバリデーションエラー表示の改善**
  - 赤系配色 + エラー件数表示に変更済み
- [x] **PDF 生成中のローディング表示**
  - submit ボタン disabled + テキスト変更で対応済み
- [x] **多言語切替 UI の改善**
  - モバイル対応 + 現在ロケールハイライト表示
- [ ] **モバイルレスポンシブの確認・改善**
  - デザイン検討が必要
