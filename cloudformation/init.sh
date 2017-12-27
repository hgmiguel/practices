#!/bin/bash
 aws cloudformation validate-template \
  --template-body file://~/Source/practices/cloudformation/projects/webserver.yaml \
  --region us-east-1  \
  --profile hgmiguel 

 aws cloudformation create-stack \
  --stack-name sysop-training \
  --template-body file://~/Source/practices/cloudformation/projects/webserver.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --region us-east-1  \
  --tags Key=CostCenter,Value=study Key=Environment,Value=testing  \
  --profile hgmiguel 

 aws cloudformation describe-stacks \
  --stack-name sysop-training \
  --region us-east-1  \
  --profile hgmiguel 

