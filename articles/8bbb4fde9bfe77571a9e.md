---
title: "【#awsbasics】re:Invent 2022 re:Cap 2nd Night整理"
emoji: "🚴🏻‍♀️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["aws","感想"]
published: true
---

# 概要
「AWSの基礎を学ぼう」で”re:Invent 2022 re:Cap 2nd Night”自分のため整理記事です。

# 「AWS エバンジェリストシリーズ　AWSの基礎を学ぼう」とは
[AWS エバンジェリストシリーズ　AWSの基礎を学ぼう](https://awsbasics.connpass.com)

以下、Connpassページより引用

> Amazon Web Services (AWS)は現在200を超えるサービスを提供し、日々サービスの拡充を続けています。
> このAWS エバンンジェリストシリーズでは週次でAWSのサービスをひとつづつ取り上げながらその基礎を説明していく 初心者、中級者をターゲットとした講座です。午後の仕事前にスキルアップを一緒にしませんか？
> 注意点 登壇者による発表内容はアマゾン ウェブ サービス ジャパンとして主催しているものではなく、コミュニティ活動の一環として勉強会の主催を行っているものです。

# 整理

## AWS Nitro
- EC2やLambdaなどを支えている仮想化基盤
- re:inventでは5世代目が発表された
- ソフトウェアのHypervisorはNetWork,Strage,Managementを扱うためにGuestOSに一定のリソースが必要になる
- 上記をハードウェアに順次オフロードしているのがNitoroシステム
- パフォーマンスの向上、セキュリティの向上、暗号処理のオフロードが可能。
- またイノベーションとしてAPI化することでMac MiniをNitroで稼働することができる。

## Nitoro v5
- 全世代と比べて、２倍の計算能力

## C7gn
- データ分析・密結合なクラスタ・ネットワーク要求が厳しいワークロード
- C:汎用に比べてCpu特化
- 7:世代数
- g:Graviton
- n:NetWork強化

## Gravitons3E
- Gravitons3の派生でHPC向けの浮動小数点、ベクトル演算のパフォーマンス向上

## HPC7g
- Gravitons3Eベース、HPC向けの浮動小数点、ベクトル演算のパフォーマンス向上
- HPC:ハイパフォーマンス コンピューティング
- 7:世代数
- g:Graviton

## SRD
- AWSのデータセンターで動いているプロトコル
- 普通のデータセンターのルーターはピラミッド型であるが、ルートがボトルネックになる
- そのためフルメッシュで連携したい。
- TCPでの通信は、ネットワーク上で衝突しやすく、衝突が発生すると待機状態になり無駄なコストが発生する
- 上記TCPの問題を解決するためにSRDというプロトコルを開発し、Nitro経由でAppとやりとりする。

## EBS io2
- EBS io2をTCPからSRDに切り替えを行う予定。2023年早期

## ENA Express
- SRDを採用したNWIF提供予定
- ただし現状C6gn.16xlインスタンスからなので、一般で使えるにはまだ先かしら。

## Trn1n
- Trn:Trainium
- 1:世代
- n:NW強化
- 1.6TNpsで機械学習向けのインスタンス


## AWS Lambda SnapStart
- Corretto(java11)でのコールドスタート時の処理時間を90%短縮
- havaのinitフェーズ後の状態をスナップショットを撮る、2回目以降はこのSSを使うことで高速化する
- 14日間保存される


## サスティナブル
- 2025年までに100%再生エネルギーでデータセンターを運用する
- 2030年までにデータセンターで利用する水よりも多く還元する

## OpenSearch Service Serveless
- OpenSearchのサーバーレス化
- CPUとストレージを切り分けて、CPUは利用時のみ、ストレージは永続化

## Aurora Zero-ETL With RedShift
- Auroraのトランザクションに対して、数秒でRedShiftに反映させることが可能
- RedShiftでほぼリアルタイムな分析やMLを可能とする
- Glue経由である必要がなくなった

## Redshift apach Spark
- Redshiftでapach Sparkが利用可能に

## Amazon DataZone
- 大規模なデータ共有・検索。発見を実現する
- 他の方が作ったデータセットをカタログで検索することができる、なのでGlueでやる

## ML-powered forecasting with Q/Why Question With Q
- forecastと入力すると指標の予測を生成
- whyと入力すると貢献度分析を行う

## Amazon Security Lake
- ダッシュボードするモノではない
- イベント発火するモノではない
- OCSF（Open Cybersecurity Schema Framework）にログを変換させる

## Inf2
- Inferentia 推論専用チップ
- Inf1と比較して3倍の計算性能
- Inf1が分散処理を苦手としていたので、それを解決したもの

## Hpc6id
- i:Intel
- d:一時ディスクディスク

## SimSpace Weaver
- 大規模空間シュミレーション
- 空間を分割して、分散処理も可能

## Connect
- 事前準備したFAQを会話の中からConnectが提案する
- エージェントの休みなどを考慮したシフト勤務体制を提案する

## Supply Chain
- SAPとデータ連携
- ML処理
- 在庫管理や問題点を連携してくれる
- 管理者が注意しておきたい箇所をMLでチェックしてくれる
- Insightで売り上げ・在庫管理　MLでの予測が対応

## Clean Rooms
- プライバシー保護の観点から広告の配信結果。・計測内容に制限が発生する
- 顧客情報をマスキングすることが可能

## Amazon Omics
- ゲノム等のおミックスデータを保存・紹介・分析
- 複数機関で安全に運用するのが目的

## M6in/M6idn
- 従来より優れたパフォーマンス、SAP認定済

## R6in/R6idn
- 従来より優れたパフォーマンス、SAP認定済
- Rはメモリ特化

## QuickSigh Expanded API Capability
- AWS SDKを利用して、QuickSightダッシュボードと分析へプログラムによるアクセスを可能

## QuickSigh Pagenated Report
- ページネーションなど綺麗にレポート出してくれる

## QuickSigh Automated data preparation
- Qで"東京"と聞いてもどの項目が準備する必要があったが、対話型でより簡単に作れるようになった

## Inspector Aws Lambda
- CVEと突合し脆弱性評価が可能に

## Compute OPtimizer External metric support
- サードパーティツールでAWS環境監視を行う際にメモリ情報を提供している
- 上記を利用してCompute OPtimizerするようにする

## ELB ターゲットグループ単位のクロスゾーン負荷分散切り離し
- ALBは元々クロスゾーン負荷分散をOFFにできない
- 今回ターゲットグループ単位でOFFにできるようになった
- ヘルスチェックとしては生きているが、少しずつ死んでいくAZがある場合に切り離しができる

## ELBのヘルスチェック
- 詳細設定が可能になった

## ELB Zonal shift for ALB and NLB
- Route53でのDR対応をAZ単位で実施することが可能