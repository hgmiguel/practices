
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
  --service-role-arn arn:aws:iam::408460586533:role/RegalosYDetallesDiamante-CodeDeployTrustRole-19F0YAFFJIRUM \
  --profile=hgmiguel

aws deploy create-deployment \
  --application-name RegalosYDetallesDiamante \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name RegalosYDetallesDiamante_DepGroup \
  --s3-location bucket=hgmiguel.regalosydetallesdiamante,bundleType=zip,key=RegalosYDetallesDiamante.zip \
  --profile=hgmiguel

