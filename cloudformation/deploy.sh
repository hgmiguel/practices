#!/bin/bash
aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file infrastructure/vpc.yaml \
  --stack-name vpc-testing \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
  --parameter-override SSHKeyName="public-globant-hgmiguel-key"


