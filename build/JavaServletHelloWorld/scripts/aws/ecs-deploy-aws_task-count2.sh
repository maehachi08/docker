#!/bin/bash
export AWS_DEFAULT_REGION='us-east-1'

# TaskDefinition の定義
cat << EOT > /tmp/container-definitions.json
{
  "containerDefinitions": [
    {
      "name": "JavaTomcatDefinition_01",
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
    },
    {
      "name": "JavaTomcatDefinition_02",
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
  "family": "JavaTomcatDefinition2"
}
EOT

# TaskDefinition の作成
NEW_TASK=`aws ecs register-task-definition --cli-input-json file:///tmp/container-definitions.json |  jq -r .taskDefinition.taskDefinitionArn`

# ServiceのUpdate
aws ecs update-service --cluster JavaTomcatCluster --service JavaTomcatService_2 --task-definition ${NEW_TASK} --desired-count 2

# タスクの停止
RUNNING_TASKS=`aws ecs list-tasks --cluster JavaTomcatCluster --service-name JavaTomcatService_2 | jq -r '.taskArns[]'`
for TASK_ARN in ${RUNNING_TASKS}; do
  aws ecs stop-task --cluster JavaTomcatCluster --task ${TASK_ARN}
done

