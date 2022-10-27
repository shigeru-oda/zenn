#!/bin/bash
set -e -o pipefail
LogFile=`basename "$0"`.log

# ■AWS Account IDの取得
function AccountID () {
AccountID=`aws sts get-caller-identity --query Account --output text`
}


# ■VPCの作成
function CreateVpc () {
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specification "ResourceType=vpc,Tags=[{Key=Name,Value=ContainerHandsOn}]"

VpcId=`aws ec2 describe-vpcs \
    --query 'Vpcs[*].VpcId' \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOn" \
    --output text`

aws ec2 modify-vpc-attribute \
  --vpc-id ${VpcId}  \
  --enable-dns-support  '{"Value":true}' 

aws ec2 modify-vpc-attribute \
  --vpc-id ${VpcId}  \
  --enable-dns-hostnames  '{"Value":true}' 
}


# ■Subnetの作成
function CreateSubnet () {
aws ec2 create-subnet \
  --vpc-id $VpcId \
  --availability-zone ap-northeast-1a \
  --cidr-block 10.0.0.0/24 \
  --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=ContainerHandsOnPublic}]"

aws ec2 create-subnet \
    --vpc-id $VpcId \
    --availability-zone ap-northeast-1c \
    --cidr-block 10.0.1.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=ContainerHandsOnPublic}]"

aws ec2 create-subnet \
    --vpc-id $VpcId \
    --availability-zone ap-northeast-1a \
    --cidr-block 10.0.2.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=ContainerHandsOnPrivate}]"

aws ec2 create-subnet \
    --vpc-id $VpcId \
    --availability-zone ap-northeast-1c \
    --cidr-block 10.0.3.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=ContainerHandsOnPrivate}]"

SubnetId1aPublic=`aws ec2 describe-subnets \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPublic" \
    "Name=availabilityZone,Values=ap-northeast-1a" \
    --query "Subnets[*].SubnetId" \
    --output text`

SubnetId1cPublic=`aws ec2 describe-subnets \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPublic" \
    "Name=availabilityZone,Values=ap-northeast-1c" \
    --query "Subnets[*].SubnetId" \
    --output text`

SubnetId1aPrivate=`aws ec2 describe-subnets \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPrivate" \
    "Name=availabilityZone,Values=ap-northeast-1a" \
    --query "Subnets[*].SubnetId" \
    --output text`

SubnetId1cPrivate=`aws ec2 describe-subnets \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPrivate" \
    "Name=availabilityZone,Values=ap-northeast-1c" \
    --query "Subnets[*].SubnetId" \
    --output text`
}

# ■InternetGatewayの作成
function CreateInternetGateway () {
aws ec2 create-internet-gateway \
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=ContainerHandsOn}]"

InternetGatewayId=`aws ec2 describe-internet-gateways \
    --query 'InternetGateways[*].InternetGatewayId' \
    --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOn" \
    --output text`

aws ec2 attach-internet-gateway \
    --internet-gateway-id ${InternetGatewayId} \
    --vpc-id ${VpcId}
}


# ■RouteTableの作成
function CreateRouteTable () {
aws ec2 create-route-table \
  --vpc-id ${VpcId} \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=ContainerHandsOnPublic}]"

aws ec2 create-route-table \
  --vpc-id ${VpcId} \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=ContainerHandsOnPrivate}]"

RouteTableIdPublic=`aws ec2 describe-route-tables \
  --query "RouteTables[*].RouteTableId" \
  --filters "Name=vpc-id,Values=${VpcId}" \
  "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPublic" \
  --output text`

RouteTableIdPrivate=`aws ec2 describe-route-tables \
  --query "RouteTables[*].RouteTableId" \
  --filters "Name=vpc-id,Values=${VpcId}" \
  "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOnPrivate" \
  --output text`

aws ec2 associate-route-table \
  --route-table-id ${RouteTableIdPublic} \
  --subnet-id ${SubnetId1aPublic}

aws ec2 associate-route-table \
  --route-table-id ${RouteTableIdPublic} \
  --subnet-id ${SubnetId1cPublic}

aws ec2 associate-route-table \
  --route-table-id ${RouteTableIdPrivate} \
  --subnet-id ${SubnetId1aPrivate}

aws ec2 associate-route-table \
  --route-table-id ${RouteTableIdPrivate} \
  --subnet-id ${SubnetId1cPrivate}

aws ec2 create-route \
  --route-table-id ${RouteTableIdPublic} \
  --destination-cidr-block "0.0.0.0/0" \
  --gateway-id ${InternetGatewayId}
}


# ■SecurityGroup作成
function CreateSecurityGroup () {
aws ec2 create-security-group \
  --group-name PublicSecurityGroup \
  --description "Public Security Group" \
  --vpc-id ${VpcId} \
  --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=ContainerHandsOn-PublicSecurityGroup}]"

aws ec2 create-security-group \
  --group-name PrivateSecurityGroup \
  --description "Private Security Group" \
  --vpc-id ${VpcId} \
  --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=ContainerHandsOn-PrivateSecurityGroup}]"

PublicSecurityGroupsId=`aws ec2 describe-security-groups \
  --query 'SecurityGroups[*].GroupId' \
  --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOn-PublicSecurityGroup" \
    --output text`

PrivateSecurityGroupsId=`aws ec2 describe-security-groups \
  --query 'SecurityGroups[*].GroupId' \
  --filters "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=ContainerHandsOn-PrivateSecurityGroup" \
    --output text`

aws ec2 authorize-security-group-ingress \
    --group-id ${PublicSecurityGroupsId} \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-id ${PrivateSecurityGroupsId} \
    --protocol tcp \
    --port 80 \
    --source-group ${PublicSecurityGroupsId}

aws ec2 authorize-security-group-ingress \
    --group-id ${PrivateSecurityGroupsId} \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0
}


# ■CloudWatch LogGroupの作成
function CreateLogGroup () {
aws logs create-log-group --log-group-name awslogs-container-hands-on
}

# ■環境変数処理
function ExportEnvironmentVariable () {
clear; cat << EOF > ${LogFile}
##### 正常終了 ##########################################
##### 以下をCopyして、コンソールに貼り付けて下さい。#####
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
#########################################################
EOF
cat ${LogFile}
}


# ■exec
echo "##### AWS Account ID取得 `date` #####"
AccountID
echo "##### Vpc処理 `date` #####"
CreateVpc
echo "##### Subnet処理 `date` #####"
CreateSubnet
echo "##### InternetGateway処理 `date` #####"
CreateInternetGateway
echo "##### RouteTable処理 `date` #####"
CreateRouteTable
echo "##### SecurityGroup処理 `date` #####"
CreateSecurityGroup
echo "##### LogGroup処理 `date` #####"
CreateLogGroup
echo "##### 環境変数処理 `date` #####"
ExportEnvironmentVariable


