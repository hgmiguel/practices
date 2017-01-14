# Create an application
aws deploy create-application \
  --application-name RegalosYDetallesDiamante \
  --profile=hgmiguel

aws deploy push \
  --application-name RegalosYDetallesDiamante \
  --s3-location s3://hgmiguel.regalosydetallesdiamante/RegalosYDetallesDiamante.zip \
  --ignore-hidden-files \
  --profile=hgmiguel

aws deploy create-deployment-group \
  --application-name RegalosYDetallesDiamante \
  --deployment-group-name RegalosYDetallesDiamante_DepGroup \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --ec2-tag-filters Key=Name,Value=RegalosYDetallesDiamante,Type=KEY_AND_VALUE \
  --service-role-arn {{OUTPUT CLOUDFORMATION CodeDeployTrustRoleARN	}} \
  --profile=hgmiguel
#####


## create cloudformation
aws cloudformation create-stack \
    --stack-name RegalosYDetallesDiamante \
    --template-body file:///home/miguel.huerta/Source/practices/wooecommerce/CodeDeploy.yml \
    --parameters ParameterKey=InstanceCount,ParameterValue=1 ParameterKey=InstanceType,ParameterValue=t1.micro \
      ParameterKey=KeyPairName,ParameterValue=public-globant-hgmiguel-key ParameterKey=OperatingSystem,ParameterValue=Linux \
      ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 ParameterKey=TagKey,ParameterValue=Name \
      ParameterKey=TagValue,ParameterValue=regalosydetallesdiamante \
    --capabilities CAPABILITY_IAM \
    --profile hgmiguel


####

# Deploy and redeploy
aws deploy create-deployment \
  --application-name RegalosYDetallesDiamante \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name RegalosYDetallesDiamante_DepGroup \
  --s3-location bucket=hgmiguel.regalosydetallesdiamante,bundleType=zip,key=RegalosYDetallesDiamante.zip,version=0.0.1 \
  --profile=hgmiguel

aws deploy create-deployment \
  --application-name RegalosYDetallesDiamante \
  --s3-location bucket=hgmiguel.regalosydetallesdiamante,key=RegalosYDetallesDiamante.zip,bundleType=zip,eTag=a0fde6a56f3205e051b22234bd45bfa3-5 \
  --deployment-group-name RegalosYDetallesDiamante_DepGroup \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --profile=hgmiguel


aws deploy push \
  --application-name RegalosYDetallesDiamante \
  --s3-location s3://hgmiguel.regalosydetallesdiamante/RegalosYDetallesDiamante.zip \
  --profile=hgmiguel


### /opt/codedeploy-agent/deployment-root and /var/log/ 
