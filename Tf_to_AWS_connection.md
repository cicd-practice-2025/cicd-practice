# Terraform が AWSにアクセスする方法

## パターン
1. シークレットキーを利用する（一般的）  
利点 : 簡単に設定できる  
欠点 : ローカルに鍵を保管するため情報漏洩のリスクが高まる

2. OIDC（推奨）  
説明 :   
AWS上にアクセス用のIDプロバイダ情報とIAM ロールを設定する  
Terraformはその設定に当てはまれば一時的にAWSアクセスが可能になる  

    利点 : 安全である  
    欠点 : 接続の都度、workflowの Permission を書き換える必要がある  
    欠点 : Github ActionやIAMロールの設定の初期構築が必要になる

## OIDC 設定方法

### 必要な設定一覧
1. プロバイダー設定
2. IAM　ロール設定
3. workflow 設定

### 1.プロバイダー設定
AWSのIAM [プロバイダ] から作成する。値は以下の通り入力する
``` properties
# 「アクセスキー（IDとパスワード）」を使わずに認証するための設定
プロバイダTYPE : OpenID Connect
プロバイダURL  : https://token.actions.githubusercontent.com
対象者 (Audience) : sts.amazonaws.com
```

### 2.IAMロール設定
``` properties
# 具体的にどのリポジトリからのアクセスを許可するか？等を設定する

# 1. 信頼関係 : Web Identity から作成済みの IDプロバイダーを選択する

# 2. 許可ポリシー : AdministratorAccess を選択する
  # 本来は最小権限を与えるのが望ましい

# 3. IAMロール : GitHub Actionsからの接続条件（Condition）を設定
"Condition": {
    "StringLike": {
        "token.actions.githubusercontent.com:aud": [
            "sts.amazonaws.com"
        ],
        "token.actions.githubusercontent.com:sub": [
            "repo:{ORGANIZATION}/{REPOSITORY}:*" # ここで接続リポジトリを制限できる
        ]
    }
}
```

### 3.workflow設定
```yaml
# permissions の部分は、AWSとの連携（OIDC認証）を成功させるために不可欠
# Github ActionsのAPIを実行する際に必要な権限を設定している

# workflowファイルに記述する

#--- 省略 ---
permissions:
  id-token: write # 書き換え許可
  contents: read  # 読み取り許可
```