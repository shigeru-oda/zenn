---
title: "AWSの開発環境作成・準備（Studio）"
free: true
---
# このチャプターでやること

Cloud9からAmplify StudioとFigmaで画面構築を行います。

# 画面遷移

ヘッダー検索 -> amplify -> amplifyhomes -> Backend environmentsタブ -> `Set up Amplify Studio`ボタン押下
![](https://storage.googleapis.com/zenn-user-upload/72ac0a88e75b-20220226.png)

# Amplify Studioの有効化

有効化をONに設定します。
![](https://storage.googleapis.com/zenn-user-upload/c6b635eaec19-20220226.png)

あとで削除しますが、ONにすることで、以下が自動作成されています。

- Cognito UserPool
- Cognito Federated Identities
- Lambda ✖️ 4つ
- IAM Role

画面を一つ戻ると、`Studioを起動する`ボタンに切り替わっています。
![](https://storage.googleapis.com/zenn-user-upload/ce4b598cacf7-20220226.png)

# Data modeling

左メニューから`Data`を選択します。
以下の画面がすでに出来ています。前チャプターでのAPIが作成されましたが、そこで作成された物です。
![](https://storage.googleapis.com/zenn-user-upload/676752a2948a-20220226.png)

画面右上にある`Deploy`ボタンを押下します。確認画面が出ますがこちらでも`Deploy`ボタン押下

# UI Library

左メニューから`UI Library`を選択し、`Get started`ボタン押下
![](https://storage.googleapis.com/zenn-user-upload/f4ce59c0c284-20220226.png)

`①Use our Figma templateto get started`をクリックし、Figmaに画面遷移
![](https://storage.googleapis.com/zenn-user-upload/bd08a01e7733-20220226.png)

`Duplicate`をクリック
![](https://storage.googleapis.com/zenn-user-upload/e4098d26b11e-20220226.png)
クリック後しばらくすると、Figmaの画面に遷移します。
![](https://storage.googleapis.com/zenn-user-upload/c2f70f5c9b42-20220227.png)
AWSが準備されている`AWS Amplify UI Kit`を自分のアカウントにフォークされました。

# Figma
## Flame
ヘッダーの＃マークを選択し、画面上の空いているスペースにFlameを設定します。
大きさは300-200にしていますが、厳密である必要はないです。
厳密に設定したい方はフレームを選択した後に右ペインの`W`,`H`で微調整可能です
![](https://storage.googleapis.com/zenn-user-upload/d45b77bd07f5-20220227.png)

## Image
何かしらの画像をコピーします。フレーム外を選択した状態で、ペーストを行います。
![](https://storage.googleapis.com/zenn-user-upload/d9379faf21c7-20220227.png)
その後、フレームの上部に画像が収まるように移動・調整を行います。
![](https://storage.googleapis.com/zenn-user-upload/affb774ec65d-20220227.png)

## Text
ヘッダーのTマークを選択し、フレームに収まるように配置します。
Textの１つ目としてTitleを設定しました。
![](https://storage.googleapis.com/zenn-user-upload/7ecace1dd9df-20220227.png)
Textの２つ目としてDescriptionを設定しました。
![](https://storage.googleapis.com/zenn-user-upload/88933aa519d7-20220227.png)

## Create Component
Flame、Image、Textの２つを選択した状態で右クリックをし、`Create Component`を選択します。
![](https://storage.googleapis.com/zenn-user-upload/62e1014d52ff-20220227.png)

選択範囲が`Component`になりました。
![](https://storage.googleapis.com/zenn-user-upload/245fa77ec98e-20220227.png)

Componentの名前はダブルクリックで編集できますので、`HomeCard`と変更します。
![](https://storage.googleapis.com/zenn-user-upload/04921cd244c9-20220227.png)

## Share
画面右上の`Share`ボタンを押下します。サブウィンドウが立ち上がりますので、`Copy link`を選択
![](https://storage.googleapis.com/zenn-user-upload/8c5c3adca7d2-20220227.png)

## Sync with Figma
Amplify Studioの画面に戻り`② Paste your Figma file link`配下にCopyしたアドレスを貼り付けます。
その後`Continue`ボタン押下
![](https://storage.googleapis.com/zenn-user-upload/0d921c960df6-20220227.png)

画面右上の`Accept All`ボタンを押下し、FigmaとAmplify Studioを同期します。
![](https://storage.googleapis.com/zenn-user-upload/ccb2a2e37049-20220227.png)