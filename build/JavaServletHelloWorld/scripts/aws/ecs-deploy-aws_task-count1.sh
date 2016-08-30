#!/bin/bash
export AWS_DEFAULT_REGION='us-east-1'

# TaskDefinition の定義
cat << EOT > /tmp/container-definitions.json
{
  "containerDefinitions": [
    {
      "name": "JavaTomcatDefinition",
      "image": "375144106126.dkr.ecr.us-east-1.amazonaws.com/java_tomcat-hello_world:latest",
      "cpu": 1,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 0,
          "protocol": "tcp"
        }
      ],
      "command": [ "/usr/bin/supervisord" ],
      "memory": 128,
      "essential": true
    }
  ],
  "family": "JavaTomcatDefinition"
}
EOT

# TaskDefinition の作成
NEW_TASK=`aws ecs register-task-definition --cli-input-json file:///tmp/container-definitions.json |  jq -r .taskDefinition.taskDefinitionArn`

# ServiceのUpdate
#   - JavaTomcatDefinitionタスクを2個実行することでdockerコンテナを2個起動する
aws ecs update-service --cluster JavaTomcatCluster --service JavaTomcatService1 --task-definition ${NEW_TASK} --desired-count 1
aws ecs update-service --cluster JavaTomcatCluster --service JavaTomcatService2 --task-definition ${NEW_TASK} --desired-count 1

# タスクの停止
RUNNING_TASKS1=`aws ecs list-tasks --cluster JavaTomcatCluster --service-name JavaTomcatService1 | jq -r '.taskArns[]'`
RUNNING_TASKS2=`aws ecs list-tasks --cluster JavaTomcatCluster --service-name JavaTomcatService2 | jq -r '.taskArns[]'`

for TASK_ARN in ${RUNNING_TASKS1}; do
  aws ecs stop-task --cluster JavaTomcatCluster --task ${TASK_ARN}
done

for TASK_ARN in ${RUNNING_TASKS2}; do
  aws ecs stop-task --cluster JavaTomcatCluster --task ${TASK_ARN}
done

