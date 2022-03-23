---
title: "Amplifyの準備・作成"
free: true
---
# このチャプターでやること

Cloud9からamplify api addとamplify hosting addを行います。

# Cloud9のCredentialsをOFFにする。
デフォルトでCloud9についているCredentialsが邪魔になるのでOFFにします。
ヘッダー部Cloud9のアイコン -> Preferences -> AWS Settings -> Credentials
![](https://storage.googleapis.com/zenn-user-upload/b406ab184997-20220323.png)

# git clone

Cloud9コンソールに対して以下コマンドを実施
元ネタはaws blogで紹介されているgithubです。

``` sh
git clone https://github.com/renebrandel/amplify-homes.git
```

実行結果は以下の通り

``` sh
Cloning into 'amplify-homes'...
remote: Enumerating objects: 57, done.
remote: Total 57 (delta 0), reused 0 (delta 0), pack-reused 57
Receiving objects: 100% (57/57), 841.69 KiB | 23.38 MiB/s, done.
Resolving deltas: 100% (5/5), done.
```

# 不要な環境削除

github上では既存環境がすでに作成されているので、これを削除します。
一番最後に環境削除する時に邪魔になるためです。

``` sh
cd amplify-homes/
rm amplify/team-provider-info.json 
```

# amplify cliのインストール

amplifyの操作を行うために、npmでamplify cliをインストールします、以下コマンドを実施
途中WARNが出ますが、気にしない。

``` sh
nvm install 14.19.1
nvm use 14.19.1
npm i
npm install -g @aws-amplify/cli
```

# amplify init

amplify環境の初期設定を行います、以下コマンドを実施

``` sh
amplify init
```

対話形式での設定を行いますので、以下を設定
**【注意】以下はご自身の名前を設定ください。このあとの処理でS3が自動作成されるのですが、「プロジェクト名」+「環境名」+「UTC時間(時分秒)」で作成されるため、全員が同じプロジェクト名＋環境名であるとS3での衝突が発生します**
? Enter a name for the environment `yourname`

? Choose your default editor: `Visual Studio Code`

? Select the authentication method you want to use: `AWS profile`

? Setup new user `Yes`

**【注意】ご利用のリージョンをご指定下さい。**
? region:  `ap-northeast-1`

**【注意】自動的に設定された名前で問題ないです。**
? user name:  `amplify-LOfdx`

# IAM USER作成

以下の表示が出ましたら、リンクをクリックして、OPENを選択

```
Complete the user creation using the AWS console
https://console.aws.amazon.com/iam/home?region=ap-northeast-1#/users$new?step=final&accessKey&userNames=amplify-LOfdx&permissionType=policies&policies=arn:aws:iam::aws:policy%2FAdministratorAccess-Amplify
Press Enter to continue
```

IAMのUSER作成画面に進みます。
デフォルトのままで良いので、右下の青いボタンを５回クリックし、以下のように画面遷移します。
`ユーザー詳細の設定` -> `アクセス許可の設定` -> `タグの追加 (オプション)` -> `確認` -> `成功`

以下の画面まで遷移しましたら、`アクセスキーID`、`シークレットアクセスキー`をメモします。
![](https://storage.googleapis.com/zenn-user-upload/ec91b74357c9-20220226.png)

# クレデンシャル登録

メモしたIAM USERのクレデンシャル情報を登録します
? accessKeyId:  `********************`
? secretAccessKey:  `****************************************`

対話形式での設定を行いますので、以下を設定
? Profile Name: `default`
? Please choose the profile you want to use `default`

クレデンシャル情報を登録した後、この情報を利用してCloudFormationが起動します。

# amplify status

Cloud9コンソールに対して以下コマンドを実施

``` sh
amplify status
```

以下のような表示が出ればOKです。

``` sh
    Current Environment: homesoda
    
┌──────────┬───────────────┬───────────┬───────────────────┐
│ Category │ Resource name │ Operation │ Provider plugin   │
├──────────┼───────────────┼───────────┼───────────────────┤
│ Api      │ amplifyhomes  │ Create    │ awscloudformation │
└──────────┴───────────────┴───────────┴───────────────────┘

GraphQL transformer version: 2
```

これはgithub上では既に`amplify api add`が実行された結果が含まれています。
その為、何もしなくてもApiが追加されるstatusになっています。

# amplify hosting add

Cloud9コンソールに対して以下コマンドを実施

``` sh
amplify hosting add
```

対話形式での設定を行いますので、以下を設定
? Select the plugin module to execute `Hosting with Amplify Console (Managed hosting with custom domains, Continuous deployment)`
? Choose a type `Manual deployment`

# amplify publish

Cloud9コンソールに対して以下コマンドを実施

``` sh
amplify publish
```

以下のような表示になっていることを確認ください

```
    Current Environment: homesoda
    
┌──────────┬────────────────┬───────────┬───────────────────┐
│ Category │ Resource name  │ Operation │ Provider plugin   │
├──────────┼────────────────┼───────────┼───────────────────┤
│ Api      │ amplifyhomes   │ Create    │ awscloudformation │
├──────────┼────────────────┼───────────┼───────────────────┤
│ Hosting  │ amplifyhosting │ Create    │ awscloudformation │
└──────────┴────────────────┴───────────┴───────────────────┘
```

対話形式での設定を行いますので、以下を設定
? Are you sure you want to continue? `Yes`
? Do you want to update code for your updated GraphQL API `No`

無視して以下のような表示が最後に出れば成功です
途中`[DEP0148] DeprecationWarning`というWarningが出ますがお気にせず。

```
✔ Deployment complete!
https://homesoda.d2st1248z19swk.amplifyapp.com
```

ちなみに、URLにアクセスしても真っ白な画面しか出ません。
