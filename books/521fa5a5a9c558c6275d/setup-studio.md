---
title: "Amplify Studioの準備・作成"
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

画面を一つ戻ると、`Studioを起動する`ボタンに切り替わっていますので、ボタンをクリックしてStudioを起動します。
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

以下画像をブラウザ上でコピーします。
![](https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100.png)

Figmaフレーム外を選択した状態で、ペーストを行います。

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

Amplify Studioの画面に戻り`② Paste your Figma file link`配下にCopyしたアドレスを貼り付けます。その後`Continue`ボタン押下
![](https://storage.googleapis.com/zenn-user-upload/0d921c960df6-20220227.png)

画面右上の`Accept All`ボタンを押下し、FigmaとAmplify Studioを同期します。
![](https://storage.googleapis.com/zenn-user-upload/ccb2a2e37049-20220227.png)

# UIコンポーネントに表示されるデータを準備

## 画面遷移

左ペインの`Content`を選択し、`Auto-generate seed data`ボタン押下します。
![](https://storage.googleapis.com/zenn-user-upload/61eceeff19a0-20220227.png)
自動作成する行数を指定し、`Generate data`ボタン押下します。ここでは５行データを選択します。
![](https://storage.googleapis.com/zenn-user-upload/72450901999c-20220227.png)
ランダムなデータが５行あることを確認できます。
![](https://storage.googleapis.com/zenn-user-upload/cdb13782a618-20220227.png)

行をクリックするとデータ修正ができますので、`image_url`を好きな画像のURLに変更します。
皆様の好きな画像でも良いですが、なんでも宜しければ、以下画像をご利用ください。

- <https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100-1.png>
- <https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100-2.png>
- <https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100-3.png>
- <https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100-4.png>
- <https://raw.githubusercontent.com/shigeru-oda/zenn/main/books/521fa5a5a9c558c6275d/300-100-5.png>

# UIコンポーネントをデータと紐付ける

## 画面遷移

コンポーネントをデータと紐付けます。
`Amplify Studio` -> `UI Library` -> `My Components` -> `HomeCard` -> `Configure`ボタン
![](https://storage.googleapis.com/zenn-user-upload/ead3e845e026-20220227.png)

## Component properties

画面右上にComponent propertiesという項目があるので`+`を選択

- Name : `home`
- Type : `Home`
![](https://storage.googleapis.com/zenn-user-upload/bae64b0cef73-20220323.png)

画像をクリックするとChild propertiesという項目が表示されるので`+`を選択

- Name : `src`
- Type : `home.image_url`
![](https://storage.googleapis.com/zenn-user-upload/820b8eac55f9-20220323.png)

TitleをクリックするとChild propertiesという項目が表示されるので`Set prop`を選択

- Name : `label`
- Type : `home.address`
![](https://storage.googleapis.com/zenn-user-upload/46ae7bc5f0d6-20220227.png)

DescriptionをクリックするとChild propertiesという項目が表示されるので`Set prop`を選択

- Name : `label`
- Type : `home.price`
![](https://storage.googleapis.com/zenn-user-upload/a268c94b571d-20220227.png)

# コレクションを作成する

５つのデータがあるので、これをコレクションとして並べて表示します。
右上にある`Create collection`ボタンを選択。
サブ画面が表示されるので名前を設定します、ここでは`NewHomes`とします。
![](https://storage.googleapis.com/zenn-user-upload/0d503c7d8c35-20220227.png)

このような画面に遷移します、画像はリアルタイムに読み込まないようで表示されない可能性もあります。
![](https://storage.googleapis.com/zenn-user-upload/6b78c4fa9e7b-20220227.png)

## 　ここから環境によっては画面がバグる可能性があります。私の環境でうまく行った手順は以下です

- 画面左のPaddingを10pxで上下左右設定します。
![](https://storage.googleapis.com/zenn-user-upload/2e277c70811f-20220227.png)

- TypeをGridを選択します。
![](https://storage.googleapis.com/zenn-user-upload/de6364ea78b3-20220227.png)

- 画面右の`Collection data`で`View/Edit`を選択、別画面が表示されます。
- Sort byの項目で`image_url`: `ascending`を選択して、`Create data set`をクリックします。
![](https://storage.googleapis.com/zenn-user-upload/ba40fc71ea2b-20220227.png)

- 画面下の`Get componet code`ボタンを選択、別画面が表示されますので、表示されているamplify pullコマンドを後程Cloud9にコピペします。
![](https://storage.googleapis.com/zenn-user-upload/79caba1f28d5-20220228.png)

## 　画面がバグってしまった方へ（対象の方のみ）

画像が壊れてしまう時があります。
この場合には作成したcollectionである`NewHomes`を削除し、再作成ください。
`UI Library` -> `My Components` -> `NewHomes` -> `Deelte`ボタン
以下、壊れた例。
![](https://storage.googleapis.com/zenn-user-upload/81e1fabf6bed-20220227.png)
