# TODO（やり残し課題）

## バグ修正（即時対応）

- [x] **RecordsForm#vertical_stamp の nil ガード** *(dfcc98a)*
  - `stamp` が nil の場合 `NoMethodError` が発生する
  - `app/forms/records_form.rb:32`
  - テストで検出済み
- [x] **terms.html.erb に Slim 構文が混入している** *(35dff26)*
  - `app/views/records/terms.html.erb:58-63`
  - `.list-decimal.mt-2` や `li ...` は Slim 構文であり ERB では HTML として正しくレンダリングされない
- [x] **`_header.html.erb` の `</nav>` 閉じタグ欠如** *(ba352c5)*
  - `app/views/shared/_header.html.erb:11-16`
  - `<nav>` が閉じられずに `</header>` に到達しており HTML 構造が壊れている
- [x] **`</html>` の後にインラインスクリプトがある** *(36232db)*
  - `app/views/layouts/application.html.erb:46-56`
  - HTML 仕様上無効。`scroll-down` 要素がないページ（terms, privacy_policy）で JS エラー発生
- [x] **`start_end_check` の nil ガード不足** *(dfcc98a)*
  - `app/forms/records_form.rb:26`
  - `fromdate` や `todate` が nil の場合 `<` 演算子でエラー

## セキュリティ

- [x] **ロケールパラメータの params 変更（mutate）**
  - `app/controllers/application_controller.rb:9`
  - `params[:locale] ||= I18n.default_locale` が params ハッシュ自体を書き換えている
  - `params[:locale] || I18n.default_locale` に修正すべき
- [x] **GA トラッキング ID のハードコード**
  - `app/views/layouts/application.html.erb:15-22`
  - `G-GRVBKEM4C8` がテンプレートに直書き。環境変数から読み込むべき
  - 開発/テスト環境でも本番 GA にデータ送信されてしまう
- [x] **CSP (Content Security Policy) が未定義**
  - `csp_meta_tag` は出力されているがポリシー自体が `config/initializers/` に存在しない
- [x] **PDF 入力値の未サニタイズ**
  - `lib/pdf/notification_pdf/post_pdf.rb:55-76`
  - Prawn の一部メソッドはインラインフォーマッティング（`<b>` 等）を解釈するため意図しないレイアウト崩れの可能性
- [x] **`old`（年齢）のサーバーサイドバリデーション欠如**
  - `app/forms/records_form.rb`
  - HTML の `in: 1..99` はクライアントサイドのみ。0, 負数, 100以上が送信可能
- [x] **database.yml に本番の DB 名・ユーザー名がハードコード**
  - `config/database.yml:25-26`
  - `clbn7in3q001ybequb33r979b` 等がリポジトリにコミットされている

## SEO / OGP

- [x] **OGP locale が `ja_JP` に固定** *(47a87f0)*
  - `app/helpers/application_helper.rb:26`
  - en/zh ロケール時にも `ja_JP` が出力される
- [x] **meta description がプレースホルダのまま** *(7ec0209)*
  - `app/views/records/new.html.erb:1`
  - `description: 'ディスクリプション'` — 意味のある文言に修正すべき
- [x] **`<html>` タグに lang 属性がない** *(58c6c6c)*
  - `app/views/layouts/application.html.erb:2`
  - `<html lang="<%= I18n.locale %>">` とすべき（SEO + アクセシビリティ）
- [x] **terms / privacy_policy の set_meta_tags が日本語固定** *(6d67f38, a9ef3d8)*
  - `app/views/records/terms.html.erb:1`, `privacy_policy.html.erb:1`
  - i18n を使わず `'利用規約'` 等がハードコード

## i18n（国際化）

- [x] **利用規約・プライバシーポリシーが全文日本語ハードコード** *(6d67f38, a9ef3d8)*
  - `app/views/records/terms.html.erb`, `privacy_policy.html.erb` 全体
  - en/zh ロケールでアクセスしても日本語のまま表示される
- [x] **バリデーションエラーメッセージが日本語ハードコード** *(abb7667)*
  - `app/forms/records_form.rb:26`
  - `"は開始日より前の日付は登録できません。"` — i18n キーを使うべき
- [x] **PDF 内の「印」がハードコード** *(e3c306e)*
  - `lib/pdf/notification_pdf/post_pdf.rb:33`
  - 日本語固有の表現で翻訳キーが使われていない
- [x] **en ロケールの todate 翻訳値が空** *(3c73777)*
  - `config/locales/activerecord/en.yml:9`
- [x] **フッター著作権表示が 2022 年固定** *(6f5deba)*
  - `config/locales/views/{ja,en,zh}.yml:9`
  - `© 2022 反抗期届` — `Date.current.year` で動的にするか更新

## アクセシビリティ

- [x] **スクロールボタンにテキスト/aria-label がない** *(7ec0209)*
  - `app/views/records/new.html.erb:18`
  - 空の `<button>` でスクリーンリーダーから認識不可
- [x] **画像の alt 属性が不適切** *(7ec0209, 9d7950a)*
  - `app/views/records/new.html.erb:5` — `image_tag 'top4.png'` に意味のある alt がない
  - `app/views/shared/_header.html.erb:4` — `children_crossing.png` も同様
- [x] **select 要素にプレースホルダテキストがない** *(7ec0209)*
  - `app/views/records/new.html.erb:68,73`
  - `include_blank: true` だが「選択してください」等の案内がない
- [ ] **フォームフィールドの必須/任意表示がない**
  - `app/views/records/new.html.erb:37-83`
  - `required` 属性も HTML に付いていない

## PDF 生成の堅牢性

- [x] **getup/cleanup の比較がロケール依存** *(0a5a319)*
  - `lib/pdf/notification_pdf/post_pdf.rb:60-73`
  - フォームの select 値が翻訳済みテキスト（"要", "necessary", "需要"）のため、PDF 内の丸印位置判定がロケールに完全依存
  - ロケール非依存のキー（例: `"necessary"`）をフォーム値にすべき
- [x] **フォントパスが全て相対パス** *(28e6202)*
  - `lib/pdf/notification_pdf/post_pdf.rb:18,24,31,42,54,82,116`
  - `Rails.root.join(...)` を使うべき。Docker 内や作業ディレクトリが異なる環境で失敗する
- [x] **画像パスも相対パス** *(28e6202)*
  - `lib/pdf/notification_pdf/post_pdf.rb:108`
  - `image 'app/assets/images/fingerprint.jpg'` — 同上
- [x] **remark の bounding_box サイズ固定** *(28e6202)*
  - `lib/pdf/notification_pdf/post_pdf.rb:74-76`
  - `height: 60` で固定。131 文字の日本語テキストが収まらない可能性（切り捨てられる）
- [ ] **英語/中国語テキストで座標レイアウトが崩れる可能性**
  - `lib/pdf/notification_pdf/post_pdf.rb:32-48`
  - ラベル座標が日本語の文字幅基準。英語ラベルは長い場合がありテキスト重複の恐れ
- [ ] **印鑑レイアウトが文字幅未考慮**
  - `lib/pdf/notification_pdf/post_pdf.rb:85-106`
  - 幅広漢字（例: "鑑識調査"）で文字が潰れる可能性
- [x] **PDF 生成時の例外処理がない** *(ed5e585)*
  - `app/controllers/records_controller.rb:8-11`
  - フォントファイル不在や画像読み込みエラーで 500 がそのまま返る

## パフォーマンス / アセット

- [ ] **未使用フォントファイルが 4 ウェイト含まれている**
  - `app/assets/fonts/` に7ウェイト格納。実際に使用は Heavy, Bold, Light の3種のみ
  - ExtraLight, Medium, Normal, Regular は削除可能（Docker イメージサイズに直結）
- [ ] **未使用画像ファイルが複数存在**
  - `clipboard_black1.png`, `clipboard_brown1.png` — コメントアウト行からのみ参照
  - `ogp5.png`, `title.png`, `fingerprint.png`, `favicon1.png`, `.keep copy`
- [x] **フォントの冗長読み込み（DRY 違反）** *(28e6202)*
  - `lib/pdf/notification_pdf/post_pdf.rb` で `SourceHanSans-Bold.ttc` が4箇所以上で繰り返し
  - `font_families` に事前登録して名前参照にすべき
- [ ] **PDF テストの実行速度改善**
  - PostPdf テスト16件で約8秒（フォント読み込みがボトルネック）
- [ ] **テスト全体の実行時間短縮**
  - 67件で約9秒。Tailwind ビルド自動実行の省略も検討

## 設定 / インフラ

- [ ] **vendor/bundle がリポジトリに含まれている**
  - `vendor/bundle/` 配下に Ruby 3.1.0 の gem 群がコミットされている
  - `.gitignore` に追加すべき。リポジトリサイズ肥大化の原因
- [ ] **database.yml の production で SQLite adapter が継承されている**
  - `config/database.yml:23-28`
  - `<<: *default` により `adapter: sqlite3` が継承。`DATABASE_URL` 未設定時に問題
- [x] **Dockerfile に CMD がない** *(67f5e3a)*
  - `Dockerfile:37`
  - `ENTRYPOINT` のみで `CMD` 未定義。ベストプラクティスでは分離すべき
- [x] **entrypoint.sh で毎回 db:seed 実行** *(67f5e3a)*
  - `entrypoint.sh:6`
  - コンテナ再起動のたびに seed 実行。冪等でなければデータ重複
- [x] **Dockerfile のベースイメージが大きい** *(67f5e3a)*
  - `Dockerfile:4`
  - `ruby:3.3.6`（フル Debian、約1GB）→ `ruby:3.3.6-slim` で数百MB削減可能
- [x] **pry-rails がグローバル gem** *(8f9ed35)*
  - `Gemfile:40`
  - `group :development` ではなくグローバル定義のため production でも読み込まれる
- [x] **アプリケーション名が `Rename` のまま** *(bbadeca)*
  - `config/application.rb:9`
  - `module Rename` — プロジェクト名に合わせて変更すべき
- [ ] **Cloudflare デプロイ手順の確定・記載**
- [ ] **Heroku 関連の残骸クリーンアップ**

## コード品質

- [x] **RecordsController のインデント不統一** *(ed5e585)*
  - `records_controller.rb:9`
- [x] **`titile` のタイポ** *(ec70835)*
  - `app/assets/tailwind/application.css:6`, `new.html.erb:15`, `_header.html.erb:3`
  - `.titile` は `.title` のタイポ。CSS と HTML で一貫しているため動作するが保守性に問題
- [ ] **CSS クラスの膨大な重複（DRY 違反）**
  - `app/views/records/new.html.erb:39,44,49,55,57,63,68,73,78`
  - 同じ Tailwind クラス文字列が9箇所でコピペ
- [ ] **PDF 座標のマジックナンバー**
  - `lib/pdf/notification_pdf/post_pdf.rb` 全体
  - `at: [0, 700]` 等が数十箇所。定数化すべき
- [x] **不要な文字列補間** *(28e6202)*
  - `lib/pdf/notification_pdf/post_pdf.rb:55-59,75,88,93,98,105`
  - `"#{record.myname}"` → `record.myname.to_s`
- [x] **ヘッダーの言語切替リンクがパスをハードコード** *(9d7950a)*
  - `app/views/shared/_header.html.erb:12-14`
  - `"/en/records"` 等。`records_path(locale: :en)` にすべき
  - 現在のページを保持せず常に records#new に遷移してしまう
- [x] **routes.rb のインデントがタブとスペース混在** *(656f20d)*
  - `config/routes.rb`
- [ ] **ApplicationRecord が不要**
  - `app/models/application_record.rb` — DB モデルを使っていない
- [ ] **404/500 ページが英語のみ**
  - `public/404.html`, `public/500.html` — Rails デフォルトのまま
- [ ] **README.md の更新**
  - テスト実行方法、AI 開発ワークフローへの導線を追記

## CLAUDE.md の整備

- [x] **注意事項セクションの更新** *(c2502bc)*
  - 「テストはMinitest（スケルトンのみ）」→ テスト78件存在に更新
- [x] **技術スタックの DB 記述** *(c2502bc)*
  - 実際には DB 未使用。記述を実態に合わせるべき
- [x] **ディレクトリ構成に test/ と docs/ を追記** *(c2502bc)*

## UI の向上

- [ ] **フォームのバリデーションエラー表示の改善**
- [ ] **モバイルレスポンシブの確認・改善**
- [ ] **PDF 生成中のローディング表示**
- [ ] **多言語切替 UI の改善**
  - 現状ヘッダーのリンクがパスハードコードで、現在ページを保持しない

## テスト強化

- [x] **RecordsController#create のステータスコード修正** *(ed5e585)*
  - `render :new, status: :unprocessable_entity` にすべき
- [x] **i18n 翻訳キー網羅テスト** *(e04605e)*
  - ja/en/zh のキーが揃っているかの自動検証
