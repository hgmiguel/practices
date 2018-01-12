#!/bin/bash

while getopts "h?ve:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    e)  case "$OPTARG" in
          testing)
            source infrastructure/vars/testing.sh;
          ;;
          staging)
            source infrastructure/vars/staging.sh;
          ;;
        esac
        ;;
    esac
done

if [[ $verbose == 1 ]]; then
  echo  $CF_PARAMETERS

echo "aws "
echo "  --profile hgmiguel "
echo "  --region us-east-1"
echo "  cloudformation deploy" 
echo "  --template-file infrastructure/vpc.yaml "
echo "  --stack-name vpc-$ENVIRONMENT "
echo "  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM "
echo "  --parameter-override $CF_PARAMETERS"
fi

aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file infrastructure/vpc.yaml \
  --stack-name "vpc-$ENVIRONMENT" \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
  --parameter-override $CF_PARAMETERS

aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file infrastructure/networking.yml \
  --stack-name "networking-$ENVIRONMENT" \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
  --parameter-override $CF_PARAMETERS

aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file infrastructure/security-groups.yml \
  --stack-name "security-groups-$ENVIRONMENT" \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
  --parameter-override $CF_PARAMETERS

aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file tooling/bastion.yml \
  --stack-name "bastion-$ENVIRONMENT" \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
  --parameter-override $CF_PARAMETERS
