#!/bin/bash
set -e -o pipefail

# ■Cloud9の作成
function CreateCloud9 () {
aws cloud9 create-environment-ec2 \
  --name ContainerHandsOn \
  --description "ContainerHandsOn" \
  --instance-type t3.small  \
  --subnet-id ${SubnetId1aPublic}  \
  --automatic-stop-time-minutes 60 

cd ~/
cat << EOF > assume-role-policy-document.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name ContainerHandsOnForCloud9 \
  --assume-role-policy-document file://assume-role-policy-document.json

aws iam attach-role-policy \
  --role-name ContainerHandsOnForCloud9 \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam create-instance-profile \
    --instance-profile-name ContainerHandsOnForCloud9

aws iam add-role-to-instance-profile \
    --role-name ContainerHandsOnForCloud9 \
    --instance-profile-name ContainerHandsOnForCloud9

echo "インスタンス起動の為、sleep 60"
sleep 60

InstanceId=`aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].InstanceId" \
    --filters "Name=vpc-id,Values=${VpcId}" \
    --output text`

aws ec2 associate-iam-instance-profile \
    --instance-id ${InstanceId} \
    --iam-instance-profile Name=ContainerHandsOnForCloud9
}

# ■環境変数処理
function ExportEnvironmentVariable () {
echo "##### 正常終了 #####"
echo "##### 環境変数出力 #####"
clear; cat << EOF > 3.cloud9-output.env
export AccountID="${AccountID}"
export VpcId="${VpcId}"
export SubnetId1aPublic="${SubnetId1aPublic}"
export SubnetId1cPublic="${SubnetId1cPublic}"
export SubnetId1aPrivate="${SubnetId1aPrivate}"
export SubnetId1cPrivate="${SubnetId1cPrivate}"
export InternetGatewayId="${InternetGatewayId}"
export RouteTableIdPublic="${RouteTableIdPublic}"
export RouteTableIdPrivate="${RouteTableIdPrivate}"
export PublicSecurityGroupsId="${PublicSecurityGroupsId}"
export PrivateSecurityGroupsId="${PrivateSecurityGroupsId}"
export InstanceId="${InstanceId}"
EOF
cat 3.cloud9-output.env
}


# ■exec
echo "##### Cloud9処理 `date` #####"
CreateCloud9
echo "##### 環境変数処理 `date` #####"
ExportEnvironmentVariable

