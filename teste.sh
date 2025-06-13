#!/bin/bash

VPC_ID="vpc-09c617d55901b3573"

echo "🔍 Procurando recursos na VPC: $VPC_ID"
echo "====================================="

echo -e "\n🔹 ECS Clusters (Fargate):"
for cluster in $(aws ecs list-clusters --output text --query 'clusterArns[]'); do
  echo "Cluster: $cluster"
  aws ecs list-tasks --cluster $cluster --query "taskArns[]" --output text | while read task; do
    details=$(aws ecs describe-tasks --cluster $cluster --tasks $task --query "tasks[].attachments[].details" --output text)
    if echo "$details" | grep -q "$VPC_ID"; then
      echo " - Task $task usa a VPC $VPC_ID"
    fi
  done
done

echo -e "\n🔹 EFS File Systems:"
aws efs describe-file-systems \
  --query "FileSystems[].FileSystemId" --output text | while read fs; do
    if aws efs describe-mount-targets --file-system-id "$fs" \
      --query "MountTargets[?VpcId=='$VPC_ID'].[MountTargetId]" --output text | grep -q .; then
      echo " - EFS $fs usa a VPC $VPC_ID"
    fi
done

