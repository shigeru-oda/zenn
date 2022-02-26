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