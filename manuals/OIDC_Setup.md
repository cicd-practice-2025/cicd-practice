### OIDC Setup
------------------------------
### 1）OIDC
```properties
# OIDCとは: 
# AWS上で [IDプロバイダ] と [IAMロール] を設定し、
# Terraformに一時的にAWSアクセスを許可する仕組み

# 必要な設定:
# (AWS) プロバイダー設定
# (AWS) IAMロール設定
# (Workflow) Permission設定
```

------------------------------
#### a）プロバイダー設定
``` properties
# AWSのIAM [プロバイダ] から作成する。値は以下の通り入力する
#「アクセスキー（IDとパスワード）」を使わずに認証するための設定

プロバイダTYPE : OpenID Connect
プロバイダURL  : https://token.actions.githubusercontent.com
対象者 (Audience) : sts.amazonaws.com
```

------------------------------
#### b）IAMロール設定
``` properties
# どのリポジトリからのアクセスを許可するか？を設定する

# 1. 信頼関係:
# Web Identity から作成済みの IDプロバイダーを選択する

# 2. 許可ポリシー:
# AdministratorAccess を選択する
# 本来は最小権限を与えるのが望ましい

# 3. IAMロール:
# GitHub Actionsからの接続条件（Condition）を設定
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
------------------------------
#### c）Workflow設定
```yaml
# permissions は AWSとの連携（OIDC認証）を成功させるために不可欠
# Github ActionsのAPIを実行する際に必要な権限を設定している

#--- 省略 ---
permissions:
  id-token: write # 書き換え許可
  contents: read  # 読み取り許可
```
------------------------------