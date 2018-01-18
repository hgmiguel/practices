First we need to package the project
aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation package \
 --template-file master-testing.yml 
         --s3-bucket  hgmiguel.mx.cloudformation
         --output-template-file packaged-master-testing.yml


Then we need to deploy it
aws \
  --profile hgmiguel \
  --region us-east-1 \
  cloudformation deploy \
  --template-file packaged-master-testing.yml \
  --stack-name bautizos
