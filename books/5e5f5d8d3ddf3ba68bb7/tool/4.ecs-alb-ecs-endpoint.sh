#!/bin/bash
set -e -o pipefail
LogFile=`basename "$0"`.log

# ■AWS CLI変数処理
function SettingEnvironmentVariable () {
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_DEFAULT_OUTPUT=json
}


# ■ECRの作成
function CreateRepository () {
aws ecr create-repository \
    --repository-name jaws-days-2022/container-hands-on \
    --tags "Key=Name,Value=ContainerHandsOn"
}


# ■Dockerfileの作成
function CreateDockerfile () {
cd ~/environment
cat << EOF > Dockerfile
FROM php:7.4.0-apache
COPY src/ /var/www/html/
EOF

mkdir src

cat << EOF > ./src/index.php
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>Hello! Jaws Days 2022!!</title>
  </head>
  <body>
    <p>Hello! Jaws Days 2022!!</p>
    <?php echo gethostname(); ?>
  </body>
</html>
EOF

docker build -t jaws-days-2022/container-hands-on .

docker tag jaws-days-2022/container-hands-on:latest `echo ${AccountID}`.dkr.ecr.ap-northeast-1.amazonaws.com/jaws-days-2022/container-hands-on:latest

aws ecr get-login-password \
  --region ap-northeast-1 | \
  docker login \
  --username AWS \
  --password-stdin `echo ${AccountID}`.dkr.ecr.ap-northeast-1.amazonaws.com

docker push ${AccountID}.dkr.ecr.ap-northeast-1.amazonaws.com/jaws-days-2022/container-hands-on:latest
}

# ■VPCエンドポイント作成
function CreateVpcEndpoint () {
aws ec2 create-vpc-endpoint \
    --vpc-id ${VpcId} \
    --vpc-endpoint-type Gateway \
    --service-name com.amazonaws.ap-northeast-1.s3 \
    --route-table-ids ${RouteTableIdPrivate} \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=ContainerHandsOn}]"

aws ec2 create-vpc-endpoint \
    --vpc-id ${VpcId} \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.ap-northeast-1.ecr.dkr \
    --subnet-ids ${SubnetId1aPrivate} ${SubnetId1cPrivate} \
    --security-group-id ${PrivateSecurityGroupsId} \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=ContainerHandsOn}]"

aws ec2 create-vpc-endpoint \
    --vpc-id ${VpcId} \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.ap-northeast-1.ecr.api \
    --subnet-ids ${SubnetId1aPrivate} ${SubnetId1cPrivate} \
    --security-group-id ${PrivateSecurityGroupsId} \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=ContainerHandsOn}]"

aws ec2 create-vpc-endpoint \
    --vpc-id ${VpcId} \
    --vpc-endpoint-type Interface \
    --service-name com.amazonaws.ap-northeast-1.logs \
    --subnet-ids ${SubnetId1aPrivate} ${SubnetId1cPrivate} \
    --security-group-id ${PrivateSecurityGroupsId} \
    --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=ContainerHandsOn}]"
}


# ■ALB作成
function CreateAlb () {
aws elbv2 create-load-balancer \
    --name ContainerHandsOn \
    --subnets ${SubnetId1aPublic} ${SubnetId1cPublic} \
    --security-groups ${PublicSecurityGroupsId} \
    --tags "Key=Name,Value=ContainerHandsOn"

aws elbv2 create-target-group \
    --name ContainerHandsOn \
    --protocol HTTP \
    --port 80 \
    --target-type ip \
    --health-check-protocol HTTP \
    --health-check-port traffic-port \
    --health-check-path /index.php \
    --vpc-id ${VpcId}

LoadBalancersDnsName=`aws elbv2 describe-load-balancers \
  --names ContainerHandsOn \
  --query "LoadBalancers[*].DNSName" \
  --output text`

LoadBalancerArn=`aws elbv2 describe-load-balancers \
  --names ContainerHandsOn \
  --query "LoadBalancers[*].LoadBalancerArn" \
  --output text`

TargetGroupArn=`aws elbv2 describe-target-groups \
  --names ContainerHandsOn \
  --query "TargetGroups[*].TargetGroupArn" \
  --output text`

aws elbv2 create-listener \
    --load-balancer-arn ${LoadBalancerArn} \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=${TargetGroupArn}
}


# ■ECS/Fargate作成
function CreateEcsFargate () {
aws ecs create-cluster \
    --cluster-name ContainerHandsOn \
    --tags "key=Name,value=ContainerHandsOn"

cd ~/environment
cat << EOF > register-task-definition.json
{
    "family": "ContainerHandsOn", 
    "executionRoleArn": "arn:aws:iam::${AccountID}:role/ecsTaskExecutionRole", 
    "networkMode": "awsvpc", 
    "containerDefinitions": [
        {
            "name": "ContainerHandsOn", 
            "image": "${AccountID}.dkr.ecr.ap-northeast-1.amazonaws.com/jaws-days-2022/container-hands-on:latest", 
            "portMappings": [
                {
                    "containerPort": 80, 
                    "hostPort": 80, 
                    "protocol": "tcp"
                }
            ], 
            "essential": true,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-group": "awslogs-container-hands-on",
                    "awslogs-region": "ap-northeast-1",
                    "awslogs-stream-prefix": "hands-on"
                }
            }
        }
    ], 
    "requiresCompatibilities": [
        "FARGATE"
    ], 
    "cpu": "256", 
    "memory": "512",
    "runtimePlatform": {
        "cpuArchitecture": "X86_64",
        "operatingSystemFamily": "LINUX"
    }
}
EOF

aws ecs register-task-definition \
  --cli-input-json file://register-task-definition.json \
  --tags "key=Name,value=ContainerHandsOn"

RevisionNo=`aws ecs list-task-definitions \
  --family-prefix ContainerHandsOn \
  --status ACTIVE \
  --sort ASC | \
  grep ContainerHandsOn | tail -1 | sed -e 's/"//g' | cut -f 7 --delim=":"`

aws ecs create-service \
    --cluster ContainerHandsOn \
    --service-name ContainerHandsOn \
    --task-definition ContainerHandsOn:${RevisionNo} \
    --deployment-controller type=CODE_DEPLOY \
    --desired-count 2 \
    --launch-type FARGATE \
    --platform-version LATEST \
    --network-configuration "awsvpcConfiguration={subnets=[${SubnetId1aPrivate},${SubnetId1cPrivate}],securityGroups=[${PrivateSecurityGroupsId}],assignPublicIp=DISABLED}" \
    --load-balancers targetGroupArn=${TargetGroupArn},containerName=ContainerHandsOn,containerPort=80 
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
export InstanceId="${InstanceId}"
export LoadBalancerArn="${LoadBalancerArn}"
export TargetGroupArn="${TargetGroupArn}"
export LoadBalancersDnsName="${LoadBalancersDnsName}"
export RevisionNo="${RevisionNo}"
#########################################################
EOF
cat ${LogFile}
}


# ■exec
echo "##### AWS CLI変数処理 `date` #####"
SettingEnvironmentVariable
echo "##### ECRの作成処理 `date` #####"
CreateRepository
echo "##### Dockerfile作成処理 `date` #####"
CreateDockerfile
echo "##### VPCエンドポイント作成処理 `date` #####"
CreateVpcEndpoint
echo "##### ALB作成処理 `date` #####"
CreateAlb
echo "##### ECS/Fargate作成処理 `date` #####"
CreateEcsFargate
echo "##### 環境変数処理 `date` #####"
ExportEnvironmentVariable


