#!/bin/bash
 aws cloudformation create-change-set \
  --change-set-name user-data \
  --stack-name sysop-training \
  --template-body file://~/Source/practices/cloudformation/projects/webserver.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --region us-east-1  \
  --profile hgmiguel 

 #/opt/aws/bin/cfn-init -v --stack sysop-training --resource EC2InstanceToWatch --configsets CloudWatch --region us-east-1
