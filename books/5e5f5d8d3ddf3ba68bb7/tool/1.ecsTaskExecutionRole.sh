#!/bin/bash
set -e -o pipefail
LogFile=`basename "$0"`.log

# ■ECSタスクの実行Role作成
function ecsTaskExecutionRole () {
cd ~/
cat << EOF > assume-role-policy-document.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name ecsTaskExecutionRole \
  --assume-role-policy-document file://assume-role-policy-document.json

aws iam attach-role-policy \
  --role-name ecsTaskExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
}

echo "##### ecsTaskExecutionRole処理 `date` #####"
ecsTaskExecutionRole
echo "##### 正常終了 #####"

