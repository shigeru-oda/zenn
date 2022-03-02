---
title: "Cloud9の準備・作成"
free: true
---
# このチャプターでやること
AWS上の統合開発環境（IDE）であるCloud9のセットアップを行う。

# 画面遷移
ヘッダー検索 -> Cloud9 -> `Create environment`ボタン押下

# Name environment
以下を設定し、`Next Step`ボタン押下
- Name : （任意）
- Description : （任意）
![](https://storage.googleapis.com/zenn-user-upload/61fbf11d97db-20220226.png)

# Configure settings
以下を設定し、`Next Step`ボタン押下
- Instance type : m5.large (8 GiB RAM + 2 vCPU)
- 他項目 : デフォルト
![](https://storage.googleapis.com/zenn-user-upload/306389dc69cd-20220226.png)

# Review
`Create environment`ボタン押下
しばらくするとCloud9の画面が表示されます。

この時点でエラーになる場合には詳細はCloudFormationを確認下さい
可能性としては
- AZにm5.largeが対応していない可能性
- 権限不足
- 作成インスタンスの上限に該当
- etc
が考えられます。


# ダッシュボード
ヘッダーのCloud9のマーク -> `Go To Your Dashboard`を選択
![](https://storage.googleapis.com/zenn-user-upload/ef3ccbc24167-20220226.png)

# View details
起動したCloud9環境を指定した状態で、`View details`ボタン押下
![](https://storage.googleapis.com/zenn-user-upload/a3962ebfdd5e-20220226.png)

# Go to Instance
画面の位置にある`Go to Instance`をクリックし、起動しているEC2画面へ移動
![](https://storage.googleapis.com/zenn-user-upload/6f63cc51e8be-20220226.png)

# インスタンスの停止
表示されたインスタンスを選択し、`インスタンスの状態` -> `インスタンスを停止`を選択
![](https://storage.googleapis.com/zenn-user-upload/3f072601fb82-20220226.png)

# EBS
インスタンス画面の下部に詳細画面がありますので、`ストレージTAB` -> `ボリュームID`を選択
![](https://storage.googleapis.com/zenn-user-upload/30383010a508-20220226.png)

# ボリュームの変更
表示されたボリュームを選択し、`アクション` -> `ボリュームの変更`を選択
![](https://storage.googleapis.com/zenn-user-upload/31b424dc5165-20220226.png)

サイズを10->30に変更した上で`変更`ボタン押下。
その後、確認画面が出ますが、`変更`ボタン押下。
![](https://storage.googleapis.com/zenn-user-upload/4375275c1a8e-20220226.png)

# インスタンスの再起動
インスタンス画面に戻り、`インスタンスの状態` -> `インスタンスを再起動`を選択
その後、確認画面が出ますが、`再起動`ボタン押下。
![](https://storage.googleapis.com/zenn-user-upload/125470501e70-20220226.png)


# Cloud9での容量拡張確認
Cloud9に戻り、コンソールに対して以下コマンドを実施
``` sh
df -H
```

`/dev/nvme0n1p1`のSizeが33Gであることを確認します。
``` sh
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        4.1G     0  4.1G   0% /dev
tmpfs           4.1G     0  4.1G   0% /dev/shm
tmpfs           4.1G  467k  4.1G   1% /run
tmpfs           4.1G     0  4.1G   0% /sys/fs/cgroup
/dev/nvme0n1p1   33G  8.7G   24G  27% /
tmpfs           815M     0  815M   0% /run/user/1000
```