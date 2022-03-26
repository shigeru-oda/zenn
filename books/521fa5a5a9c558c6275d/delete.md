---
title: "環境削除"
free: true
---
# このチャプターでやること

不要になった環境を削除しましょう。

# amplify環境の削除
Cloud9環境のコンソールで以下を実行します
```
amplify delete
```
? Are you sure you want to continue? This CANNOT be undone. (This will delete all the environments of the project from the cloud and wipe out all the local files created by Amplify CLI) (y/N) `Yes`


# Cloud9の削除
Management Console -> Cloud9 -> このイベントで作成した環境をDelete

# Cognito UserPoolの削除
Management Console -> Cognito -> ユーザープール -> 当イベントで作成したユーザープールをDelete
`作成時刻`が作業時間内である物が対象です。

# Cognito Federated Identitiesの削除
Management Console -> Cognito -> フェデレーティッドアイデンティティ -> 当イベントで作成したフェデレーティッドアイデンティティを選択 -> ID プールの編集 -> IDプールの削除
IDが`amplify_backend_manager_xxxxxxx`であり、IDブラウザの作成時間が作業時間内である物が対象です。
手間ですが、複数個ある場合には一つ一つ確認が必要です。

# Lambdaの削除
Management Console -> Lambda -> 以下Lambdaを選択して削除
最終更新が作業時間内である物が対象です。

- `amplify-login-verify-auth-challenge-xxxx`
- `amplify-login-custom-message-xxxx`
- `amplify-login-create-auth-challenge-xxxx`
- `amplify-login-define-auth-challenge-xxxx`

# IAM Userの削除
Management Console -> IAM -> ユーザー -> 当イベントで作成したユーザーをDelete
`アクティブなキーが作成されてからの経過`が作業時間内である物が対象です。

# IAM Roleの削除
Management Console -> IAM -> ロール
`amplify-login-lambda-xxxx`
`ap-northeast-1_xxxx_Manage-only`
`ap-northeast-1_xxxx-authRole`
`ap-northeast-1_xxxx_Full-access`

`作成時間`が作業時間内である物が対象です。

作成時間は以下から表示可能です。
- 歯車マークをクリック
![](https://storage.googleapis.com/zenn-user-upload/99263de0f6db-20220326.png)
- 作成時間を有効化
![](https://storage.googleapis.com/zenn-user-upload/09af4f06e0b0-20220326.png)
