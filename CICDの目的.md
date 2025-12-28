### CI/CDの目的
------------------------------
#### CI：確認 (Preview) フェーズ
```properties
目的：
コードを変更した際「これを適用したらどうなるか？」を事前に動作確認する
# 主にPull Request時に実行される

1. checkout            : GitHubからソースコードを取得する（actions/checkout）
2. setup terraform     : 実行環境 (runner) にTerraformツールをインストールする
3. terraform fmt       : コードの書き方（フォーマット）が綺麗かチェックする
4. configure credential: AWSへの認証を行う（OIDC認証の設定を確認する）
5. terraform init      : Terraformの初期化（プラグインのDLなど）
6. terraform validate  : 文法的な間違いがないか検証する
7. terraform plan      : AWSに対して「何が変更されるか」だけ確認する（ドライラン）
8. slack notify        : 結果（「エラーなし」「S3が1つ追加される予定」など）をSlack通知
```

------------------------------
#### CD：適用 (Deploy) フェーズ
```properties
目的：
確認が終わって問題ないコードを、実際にAWS環境へ反映させる段階
# 主にmainブランチへマージされた時に実行される

ステップ:
# 1 ~ 4までCIと同じ
1. checkout            : GitHubからソースコードを取得する（actions/checkout）
2. setup terraform     : 実行環境 (runner) にTerraformツールをインストールする
3. terraform fmt       : コードの書き方（フォーマット）が綺麗かチェックする
4. configure credential: AWSへの認証を行う（OIDC認証の設定を確認する）
5. terraform apply     : 実際にAWSリソースを作成・変更・削除するコマンドを実行する
6. slack notify        : 「デプロイが完了しました」とSlackに通知する
```