# AI駆動開発ワークフロー

> 本ドキュメントは hankouki-todoke プロジェクトにおける AI（Claude Code）を活用した開発体制を定義する。
> 2026年4月時点の主要トレンドである **Spec-Driven Development (SDD)** と **Harness Engineering** を基盤とする。

---

## 1. 背景：2026年のAI開発トレンド

### 1.1 Spec-Driven Development（仕様駆動開発）

仕様を「受動的なドキュメント」から「AIの出力を制約する実行可能な契約」に変える手法。
コードは仕様から生成される成果物であり、仕様が真のソースとなる。

### 1.2 Harness Engineering（ハーネスエンジニアリング）

AIエージェントの制御層を設計する分野。2つの軸で構成される：

| 軸 | 説明 |
|---|---|
| **Feedforward（フィードフォワード）** | AIが動く前に与えるガイダンス。曖昧性を事前に排除する |
| **Feedback（フィードバック）** | AIの出力を検証するセンサー。テスト・lint・型チェック等 |

原則：**エラーが再発したら出力を直すのではなくハーネスを直す。**

---

## 2. ワークフロー全体像

```
┌─────────────────────────────────────────────────────────────┐
│                    開発ワークフロー                           │
│                                                             │
│  ① Specify（仕様化）                                        │
│    └─ 要件を SPEC.md に記述                                  │
│         ↓                                                   │
│  ② Plan（計画）                                              │
│    └─ Claude Code の Plan Mode で設計・影響範囲を策定         │
│         ↓  ← 人間レビュー関門                                │
│  ③ Task（タスク分割）                                        │
│    └─ フェーズ単位の実装タスクに分解                           │
│         ↓                                                   │
│  ④ Implement（実装）                                         │
│    └─ フェーズごとに実装 → 品質ゲート → 次フェーズ            │
│         ↓  ← 品質ゲート（テスト・lint）                      │
│  ④.5 Self-Review（AI自己レビュー）                            │
│    └─ 5観点チェック → NG があれば④に戻る                     │
│         ↓                                                   │
│  ⑤ Review（人間レビュー）                                     │
│    └─ チェックリストで確認・マージ                             │
│         ↓  フィードバックループ（§5.1）                      │
│         └─ 指摘 → 根本原因分類 → ハーネス更新                │
└─────────────────────────────────────────────────────────────┘
```

各フェーズ間に**人間の承認関門**を設ける。AIは車であり、人間が運転する。

---

## 3. ディレクトリ構成

```
hankouki-todoke/
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md    # PRテンプレート
├── CLAUDE.md                        # AI向けプロジェクト規約（既存）
├── docs/
│   ├── AI_DEVELOPMENT_WORKFLOW.md   # 本ドキュメント
│   ├── decisions/                   # ADR（Architecture Decision Records）
│   │   └── 001-pdf-library.md      # 例: Prawn採用の決定記録
│   └── specs/                       # 機能仕様書
│       └── TEMPLATE.md              # スペックテンプレート
└── ...
```

---

## 4. フェーズ詳細

### 4.1 Specify（仕様化）

機能追加・変更の前に `docs/specs/` にスペックファイルを作成する。

#### スペックの6要素

| 要素 | 内容 | 例 |
|---|---|---|
| **Outcomes** | 完了条件 | 「ユーザーがPDFをダウンロードできる」 |
| **Scope** | 範囲内/範囲外 | 範囲外: 認証機能 |
| **Constraints** | 技術的制約 | Rails 7.1, Prawn, Cloudflare |
| **Prior Decisions** | 既決事項 | ADR参照 |
| **Tasks** | タスク分解 | フェーズ1: モデル、フェーズ2: ビュー |
| **Verification** | 検証基準 | テストケース、エッジケース |

#### 境界線の3層分類

```markdown
✅ 常に実行: bin/rails test を通すこと
⚠️ 要確認: DBスキーマ変更、gem追加
🚫 禁止:   .env のコミット、vendor/ の直接編集
```

#### スペックテンプレート

```markdown
# [機能名] スペック

## 目的
[1-2文で何を達成するか]

## 背景
[なぜこの機能が必要か]

## 技術スタック・制約
- Rails 7.1.x / Ruby 3.3.6
- [追加の制約]

## スコープ
### 範囲内
- [項目]

### 範囲外
- [項目]

## タスク分解
### フェーズ1: [名前]
- [ ] [タスク]
- [ ] [タスク]

### フェーズ2: [名前]
- [ ] [タスク]

## 検証基準
- [ ] [テスト条件]
- [ ] [エッジケース]

## 境界線
- ✅ 常に: [項目]
- ⚠️ 要確認: [項目]
- 🚫 禁止: [項目]
```

### 4.2 Plan（計画）

Claude Code の **Plan Mode** を使い、以下を策定する：

1. **リポジトリインパクトマップ** — 変更対象ファイルの一覧と影響範囲
2. **実装方針** — 既存パターンへの準拠確認
3. **フェーズ分割** — 1フェーズ = 1セッションの粒度

```
Plan Mode での確認項目:
- 変更対象ファイルは実在するか？
- 既存のコードパターンに沿っているか？
- テスト戦略は明確か？
```

**人間が計画を承認してから次に進む。**

### 4.3 Task（タスク分割）

計画をフェーズ単位のタスクに分解する。各タスクは以下の形式：

```markdown
## タスク: [タスク名]
- Repository: hankouki-todoke
- Files to Modify: app/controllers/records_controller.rb, ...
- Implementation Notes: 既存の records#new パターンに従う
- Acceptance Criteria:
  - [ ] bin/rails test が全てパス
  - [ ] 既存機能に影響なし
```

### 4.4 Implement（実装）

#### 実装ルール

1. **フェーズごとに新規セッション** — コンテキスト肥大化を防ぐ
2. **1セッション = 1-2フェーズ** — コンテキストウィンドウの50%を超えたら切り替え
3. **スコープドリフト防止** — 計画外のファイル変更を行わない

#### 品質ゲート（実装後に自動実行）

| ゲート | コマンド | 目的 |
|---|---|---|
| テスト | `bin/rails test` | 回帰テスト |
| Tailwind | `bin/rails tailwindcss:build` | CSSビルド確認 |

### 4.4.5 Self-Review（AI自己レビュー）

実装完了後、人間レビューに進む前にAIが以下の5観点で自己チェックを行う。

| # | 観点 | チェック内容 |
|---|---|---|
| 1 | **CLAUDE.md 準拠** | コーディング規約・パターン・境界線に違反していないか |
| 2 | **スコープドリフト** | 計画外のファイル変更・機能追加が含まれていないか |
| 3 | **i18n 完全性** | 3言語（ja/en/zh）の翻訳キーが揃っているか |
| 4 | **セキュリティ** | シークレットの混入、入力値の未検証、OWASP Top 10 リスクがないか |
| 5 | **テストカバレッジ** | 新規・変更コードに対するテストが存在するか |

#### 出力形式

PR説明に貼付できる構造化フォーマットで結果を出力する：

```markdown
## AI Self-Review

| 観点 | 結果 | 備考 |
|---|---|---|
| CLAUDE.md 準拠 | ✅ OK | — |
| スコープドリフト | ✅ OK | — |
| i18n 完全性 | ⚠️ NG | zh.yml に `foo.bar` キーが不足 |
| セキュリティ | ✅ OK | — |
| テストカバレッジ | ✅ OK | — |
```

**NG が1つでもあれば修正してから人間レビューへ進む。**

### 4.5 Review（人間レビュー）

レビュアーは以下のカテゴリ別チェックリストに沿って確認し、マージする。

#### 仕様準拠

- [ ] スペックの検証基準をすべて満たしているか
- [ ] スコープ外の変更が含まれていないか（スコープドリフト）
- [ ] 既存のADRと矛盾する実装がないか

#### 品質ゲート

- [ ] `bin/rails test` が全てパスするか
- [ ] `bin/rails tailwindcss:build` が成功するか

#### i18n

- [ ] 3言語（ja/en/zh）の翻訳キーが一致しているか
- [ ] ビュー内にハードコードされた文字列がないか

#### セキュリティ

- [ ] シークレット（`.env`、credentials）がコミットに含まれていないか
- [ ] PDF生成への入力値が適切に検証されているか
- [ ] `params` の許可パラメータに不要な追加がないか

#### CLAUDE.md 準拠

- [ ] コーディング規約（インデント、命名等）に準拠しているか
- [ ] コードパターン（フォームオブジェクト、PDF生成等）に沿っているか
- [ ] 境界線（常に実行/要確認/禁止）を遵守しているか

#### コード品質

- [ ] 不要な変更（フォーマット修正のみ等）が含まれていないか
- [ ] コミット粒度が適切か（1コミット = 1論理変更）

---

## 5. CLAUDE.md の運用方針とフィードバックループ

### 5.1 フィードバックループ

レビュー指摘を一過性の修正で終わらせず、根本原因を分類してハーネスを更新する。

#### 根本原因の分類と対応先

| 分類 | 対応先 | 例 |
|---|---|---|
| 規約の欠如 | CLAUDE.md に追記 | Turbo + バイナリレスポンスのルール |
| 検証の欠如 | テスト・品質ゲート追加 | i18n キー一致テスト |
| 仕様の曖昧さ | TEMPLATE.md 改善 | 検証基準の具体化 |
| パターン未定義 | CLAUDE.md パターン追記 | 新しいファイル種別のパターン |

#### 運用ルール

- **同じ指摘が2回発生したらハーネスを更新する** — 出力を直すのではなくハーネスを直す（§1.2 原則）
- 更新対象: CLAUDE.md / スペックテンプレート / 品質ゲート / 本ワークフロー
- 更新内容はPRでレビューし、チームで共有する

### 5.2 CLAUDE.md の運用方針

`CLAUDE.md` はAIのフィードフォワード（事前ガイダンス）として機能する最重要ファイル。

#### 更新タイミング

| タイミング | 内容 |
|---|---|
| AIが同じミスを2回した時 | 注意事項に追記 |
| 新しい規約が確立した時 | コーディング規約に追記 |
| gem/ライブラリを追加した時 | 技術スタックに追記 |
| ADRを作成した時 | ディレクトリ構成に反映 |

#### 原則

- プロンプトにコピペするのではなく、リポジトリに組み込む
- バージョン管理し、PRでレビューする
- 200行以内を目安に簡潔に保つ

---

## 6. ADR（Architecture Decision Records）

技術的な意思決定を `docs/decisions/` に記録する。

```markdown
# ADR-[番号]: [タイトル]

## Status
Accepted / Proposed / Deprecated

## Context
[なぜこの決定が必要か]

## Decision
[何を決定したか]

## Consequences
[この決定の結果、何が起こるか]
```

AIはコード生成時にADRを参照し、過去の決定と矛盾しない実装を行う。

---

## 7. 本プロジェクトへの適用指針

### 小規模プロジェクトでの現実的な運用

hankouki-todoke は認証なし・ステートレスな小規模Railsアプリであるため、
フルスケールのSDD/ハーネスエンジニアリングは過剰になりうる。以下の基準で判断する：

| 変更の規模 | 推奨アプローチ |
|---|---|
| 1ファイル・数行の修正 | スペック不要。直接実装 |
| 1機能追加（3ファイル以上） | 簡易スペック + Plan Mode |
| アーキテクチャ変更 | フルスペック + ADR + フェーズ分割 |

### スペックを書くべき場面

- 複数のセッションにまたがる作業
- 複数のファイル/レイヤーに影響する変更
- やり直しコストが高い変更（DB スキーマ変更等）

### スペックを省略してよい場面

- 探索的・実験的な作業
- 1プロンプトで完結する修正
- 5分以内にレビュー可能な出力

---

## 8. 参考資料

- [Harness Engineering - Red Hat Developer](https://developers.redhat.com/articles/2026/04/07/harness-engineering-structured-workflows-ai-assisted-development)
- [How to Write a Good Spec for AI Agents - Addy Osmani](https://addyosmani.com/blog/good-spec/)
- [Beyond Vibe-Coding - InnoGames](https://blog.innogames.com/beyond-vibe-coding-a-disciplined-workflow-for-ai-assisted-software-development-with-claude-code/)
- [What Is Spec-Driven Development? - Augment Code](https://www.augmentcode.com/guides/what-is-spec-driven-development)
- [What is Spec-Driven Development? - Nathan Lasnoski](https://nathanlasnoski.com/2026/01/08/what-is-spec-driven-development/)
- [AI駆動開発の現在地 2026 - Qiita](https://qiita.com/k-yoshinobu/items/d75f8926e8aab47ac232)
- [Harness Engineering: The Missing Layer - Loiane Groner](https://loiane.com/2026/04/harness-engineering-missing-layer-specs-driven-ai-development/)
- [Awesome Harness Engineering - GitHub](https://github.com/ai-boost/awesome-harness-engineering)
