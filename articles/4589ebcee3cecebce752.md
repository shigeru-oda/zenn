---
title: "【Amazon Neptune】AWSの基礎を学ぼう 特別編"
emoji: "🚴🏻‍♀️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["aws","座学","感想"]
published: true
---
# 概要
「AWS エバンジェリストシリーズ　AWSの基礎を学ぼう」で”最新サービスをみんなで触ってみる 初めてのグラフデータベース”というイベントに参加した感想ページです。

# 「AWS エバンジェリストシリーズ　AWSの基礎を学ぼう」とは
[AWS エバンジェリストシリーズ　AWSの基礎を学ぼう](https://awsbasics.connpass.com)

以下、Connpassページより引用

>  Amazon Web Services (AWS)は現在200を超えるサービスを提供し、日々サービスの拡充を続けています。
> このAWS エバンンジェリストシリーズでは週次でAWSのサービスをひとつづつ取り上げながらその基礎を説明していく 初心者、中級者をターゲットとした講座です。午後の仕事前にスキルアップを一緒にしませんか？
> 注意点 登壇者による発表内容はアマゾン ウェブ サービス ジャパンとして主催しているものではなく、コミュニティ活動の一環として勉強会の主催を行っているものです。

毎週ありがとうございます！

# Amazon Neptuneとは
https://aws.amazon.com/jp/neptune/faqs/

Amazon Neptune は高速で信頼性が高いフルマネージドグラフデータベースサービスです。このサービスを使用することで高度に接続されたデータベースと連携するアプリケーションの簡単に構築および実行できます。高度に接続されたデータの SQL クエリは複雑で、パフォーマンスの調整は困難です。代わりに、Amazon Neptune では、公開されている一般的なグラフクエリ言語を使用して、書き込みが容易で、接続されたデータをうまく処理する強力なクエリを実行できます。Neptune の核となるのは、数十億のリレーションシップの保存とミリ秒台のレイテンシーでのグラフのクエリに最適化された、専用の高パフォーマンスグラフデータベースエンジンです。
（略）
Amazon Neptune では、オープンソースの Apache TinkerPop Gremlin グラフトラバーサル言語と W3C 標準 RDF (Resource Description Framework) SPARQL クエリ言語の両方がサポートされています。

# 利用用途
# ざっくり自分用整理
## RDBMSとの違い
データを正規化して複数のエンティティを持ち、1:1、1:n、n:mの関係を持つことが出来るのかRDBMS  
一方でグラフデータはエンティティで複数の関係性n1:m1、n2:m2を扱うことが出来る
## RDBMSでの課題
- 複数の関係性をSQLで表現するには複雑である
- スキーマ定義の柔軟性がない
## 用語整理
グラフデータベースでの表現方法は「プロパティグラフ」を利用する
### 図
![](https://storage.googleapis.com/zenn-user-upload/9324e1b6b9e7e3f979beed44.png)
### キーワード
- Vertex(頂点／ノード)
- Edge(関係／リレーションシップ)
- Property（属性情報）
### 補足
- Vertexはエンティティ・ドメインを表現。
- EdgeはVertexの関係性を表現。
- VertexとEdgeはPropertyを持つ。
- Propertyは非リレーショナルな情報を表現。

# sparqlって？
SPARQL（スパークル、SPARQL Protocol and RDF Query Languageの再帰的頭字語）は、RDF問合せ言語の１つである。RDFは、ウェブ上で情報を表すための、有向性の、ラベル付けされたグラフ・データ形式である。

## insert
### cmd
```
%%sparql

INSERT DATA {
    <http://s-1000-1> <http://p-1> <http://o-1> .
    <http://s-1000-2> <http://p-2> <http://o-2> .
    <http://s-1000-3> <http://p-3> <http://o-3> .
    <http://s-1000-4> <http://p-4> <http://o-4> .
    <http://s-1000-5> <http://p-5> <http://o-5> .
}
```
### 図
![](https://storage.googleapis.com/zenn-user-upload/46685da37db93e9c7e47aaee.png)
### 補足
- <http://s-1000-1> -> Vertexの開始ポイント
- <http://p-1> -> Edge
- <http://o-1> -> Vertexの終了ポイント


## select
### cmd
```
%%sparql

SELECT * WHERE {
    ?s ?p ?o
} LIMIT 10
```
### 結果
```
{
  "head": {
    "vars": [
      "s",
      "p",
      "o"
    ]
  },
  "results": {
    "bindings": [
      {
        "s": {
          "type": "uri",
          "value": "http://s-1000-1"
        },
        "p": {
          "type": "uri",
          "value": "http://p-1"
        },
        "o": {
          "type": "uri",
          "value": "http://o-1"
        }
      },
      ・・・略・・・
    ]
  }
}
```

## ちなみに
<http://s-1000-1> <http://p-1> <http://o-1>のs,p,oが意味があるのか気になったので  
<http://a-1000-21> <http://b-21> <http://c-21>でINSERTすると、以下データとなる。
```
{
  "head": {
    "vars": [
      "s",
      "p",
      "o"
    ]
  },
  "results": {
    "bindings": [
      {
        "s": {
          "type": "uri",
          "value": "http://a-1000-21"
        },
        "p": {
          "type": "uri",
          "value": "http://b-21"
        },
        "o": {
          "type": "uri",
          "value": "http://c-21"
        }
      },
              ・・・略・・・
    ]
  }
}
```
データ投入の順番に意味があるようですね。


# gremlinって？
グレムリン（英語: Gremlin）は、Apacheソフトウェア財団のApache TinkerPopにより開発されたチューリング完全なプログラミング言語。グラフデータベース操作言語である。グレムリンは多対多の関係のグラフを作成する際に有用である。

## insert
VertexとPropertyの設定
```
%%gremlin

g.addV('person').property('name', 'dan')
 .addV('person').property('name', 'mike')
 .addV('person').property('name', 'saikiran')
 ```

## select
### cmd
```
%%gremlin

g.V().limit(10)
```
### 結果
Vertexのrowid的な物が取れる
```
v[3cbdadef-3865-b31c-6a9f-3f9c0acc6e43]
v[92bdadef-3869-6b7a-3355-01d7bd96aca0]
v[98bdadef-386b-0a8d-2255-43510c1b10a1]
```

### cmd
```
%%gremlin

g.V().valueMap().limit(10)
```
### 結果
valueMap()を入れるとPropertyが見れる
```
{'name': ['dan']}
{'name': ['mike']}
{'name': ['saikiran']}
```

# 感想
gremlinの使い方になれる必要があるけど、慣れてしまえばSQL操作的にグラフデータを扱えるそうだなと思いました。
あとは実際のお仕事でどう使おうか。使えるかですかね。
NoSQLでもそうでしたが、実際に試行錯誤する必要性がありそうです。