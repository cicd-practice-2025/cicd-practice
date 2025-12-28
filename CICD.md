# CI/CD 学習メモ
CI/CD環境を構築する手順や自己理解のためのメモ

# 概要
## 1. workflow
- CI/CDを導入するリポジトリに以下の構造を作成する  
workflows下に作成した.yml をワークフローファイルと呼ぶ

``` properties
# ディレクトリ例
└── .github
    └── workflows
        └── <workflow_name>.yml
```
```yaml
# コード例
name: "Hello world"
  
on: [push]                          # トリガ
  
jobs:                               # ジョブ
  test-job:                         # ジョブID (システムが参照)
    name: Hello world job           # ジョブ名 (人間が参照するラベル)
    runs-on: ubuntu-latest          # ランナー (実行環境)
    steps:                          # ステップ 実際に実行される内容
      - users: actions/checkout@v3  # ステップ(uses)
      - run: echo "Hello world !"   # ステップ(run)
```

### トリガー
```yaml
# 何をしたら実行する？
# push, pull_request
# shedule
# workflow_dispach
# workflow_run
```

### ジョブ
```yaml
# 実行する内容
# ジョブID
# ジョブ名
# ランナー
# ステップ
```

### ステップ
```properties
# 実行する内容の詳細(2種類)
1. run : CLIプログラム (Shellスクリプト)
2. uses: アクション (マーケットから引用もしくは自作)
```
- run
```yaml
# コード例
# --- 省略 ---
jobs:
  sample:
    name: Hello World Job
    runs-on: ubuntu-latest
    steps:
      - name: Greeting message    # ステップの表示名
        id: greeting              # ステップID
        run: echo "Hello ${NAME}" # シェルスクリプト
        env:                      # (OP)環境変数
          NAME: tanaka
        shell: bash               # (OP)実行するシェル(python等も指定可)
        working-directory: tmp    # (OP)実行する場所を指定
```
```yaml
# デフォルトの実行環境を指定できる
  # ジョブのスコープ外で定義すると、すべてのジョブに適用される
  # あるジョブの中で定義すると、そのジョブ内でのみ適用される
defaults:
  run:
    shell: bash
    working-directory: tmp
```

- uses
```properties
# マーケットプレイスの利用方法

どうアクションを探す？

- https://github.com/marketplace にアクセス
 # github.com の左メニューからもアクセス可能

- 検索窓からactions名を検索
　# 必要に応じてソート順を見直す

  # ブランチの切り替え等が特に利用頻度が高い
```
```yaml
# コード例
# --- 省略 ---
jobs:
  sample:
    name: Sample Job
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository # ステップの表示名
        id: checkout              # ステップID
        uses: action/checkout@v3  # アクション(@でバージョン指定推奨)
        with:
          fetch-depth: 0          # (OP)アクションの引数

# なぜ、アクションのバージョンを指定する？
# ⇒ 暗黙のバージョンアップデートにより、突然CI/CDが動かなくなる事を避けるため

# どんな引数がとれる？
# ⇒ マーケットプレイスの各アクションの [usage] を確認する
#    英語が苦手なら右クリ → 日本語に翻訳を選択
```

### ランナー
```properties
# ジョブを実行する環境
  ランナーはジョブ単位で起動
  ジョブ間で情報を連携するには工夫が必要

# ランナーは2種類
  1. Githubホスト: Githubがホスト管理 (推奨)
  2. selfホスト  : 自分自身でホスト管理
```

### 環境変数
```
ジョブの中で定義する変数
ステップごとに環境変数の値は初期化される
```

### シークレット
```
GithubのWebページ上にクレデンシャルを秘匿する
ログイン等で利用する際は変数として呼び出す
利点はクレデンシャルをハードコードせずに済む

設定方法
Settings ⇒ Secrets and Variables ⇒ Actions ⇒ New Reposiries Secret

注意
Github Actions で定義した変数と他で定義した変数の呼出し方は異なる
Github Actionsでは ${{ 変数 }} と呼び出す
```

------------------------------------------------------------


# 学習メモ
## 重要
```
ブランチ保護 (Branch Protection)

なぜ重要？: 
⇒ SREの仕事は「自動化」だけでなく「ガードレール（安全装置）を作ること」だからです

何をする？: 
⇒ 「CI（terraform plan）が成功しないと、main ブランチにマージできないようにする」という設定です
    これが設定されていないCIは、ただの「飾り」になってしまいます

条件分岐 / ジョブ間の依存
⇒ 「plan が失敗したら apply を実行しない」といった制御に必要です
```
### 特定のブランチを保護する仕組みを指す
1. ブランチの指定 : ワイルドカードなどを用いて指定する
2. 保護する仕組み : マージ前に Pull Request によるレビューを要求など
- コードオーナー

## 余裕があれば
```
承認フロー
terraform apply（本番変更）の前に、「人間がボタンを押さないと進まない」ようにする設定です
本番運用のリアリティが出るため、ポートフォリオとしての評価が上がります

slack通知
apply の結果をSlackに飛ばす設定です
「ChatOps」の基礎として評価されます
```