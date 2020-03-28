# S3 lab

La intención de este lab es crear un bucket S3 y añadirle al final un hash, este hash debe ser calculado al momento y una vez creado el s3 se debe de mantener.



Al intentar ponerle un sufijo al bucket obtenemos este en cada ejecución:
```py
class S3BucketStack(core.Stack):
    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        #create an S3 bucket
        hash = uuid.uuid4().hex[:6]
        bucket_name = self.node.try_get_context("bucket_name")
        s3Bucket = s3.Bucket(self, 'Bucket', bucket_name=f'{bucket_name}-{hash}')
        core.Tag.add(s3Bucket, "key", "value")

```
```sh
 (master **)$ cdk --profile hgmiguel.mx diff
Stack cdk-labs
Resources
[~] AWS::S3::Bucket Bucket Bucket83908E77 replace
 └─ [~] BucketName (requires replacement)
     ├─ [-] hgmiguel.mx.test
     └─ [+] hgmiguel.mx.test-1a04f6
```

En la siguiente ejecución el hash vuelve a cambiar

```sh
(.env) miguelhuerta@MacBook-Pro-9 ~/Personal/cdk-labs
 (master **)$ cdk --profile hgmiguel.mx diff
Stack cdk-labs
Resources
[~] AWS::S3::Bucket Bucket Bucket83908E77 replace
 └─ [~] BucketName (requires replacement)
     ├─ [-] hgmiguel.mx.test
     └─ [+] hgmiguel.mx.test-ba38c8
```

Intenté hacer que funcionara solo con CDK, pero no me dejaba

Al aplicar la parte de synth vemos que nos crea el *parameter store* y nos guarda el hash 
```sh (master **)$ cdk --profile hgmiguel.mx synth
An error occurred (ParameterNotFound) when calling the GetParameter operation:
c6e230
Resources:
  Bucket83908E77:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: hgmiguel.mx.test-c6e230
      Tags:
        - Key: key
          Value: value
    UpdateReplacePolicy: Retain
    DeletionPolicy: Retain
    Metadata:
```

Insertar imágen aqui.

al volver a ejecutar vemos que conservamos el hash 

```sh 
 (master **)$ cdk --profile hgmiguel.mx synth
c6e230
Resources:
  Bucket83908E77:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: hgmiguel.mx.test-c6e230
      Tags:
        - Key: key
          Value: value
```

Y al hacer el deploy
```sh
 (master **)$ cdk deploy --profile hgmiguel.mx
c6e230
cdk-labs: deploying...
cdk-labs: creating CloudFormation changeset...
 0/3 | 1:11:07 PM | CREATE_IN_PROGRESS   | AWS::CDK::Metadata | CDKMetadata
 0/3 | 1:11:07 PM | CREATE_IN_PROGRESS   | AWS::S3::Bucket    | Bucket (Bucket83908E77)
 0/3 | 1:11:08 PM | CREATE_IN_PROGRESS   | AWS::S3::Bucket    | Bucket (Bucket83908E77) Resource creation Initiated
 0/3 | 1:11:09 PM | CREATE_IN_PROGRESS   | AWS::CDK::Metadata | CDKMetadata Resource creation Initiated
 1/3 | 1:11:09 PM | CREATE_COMPLETE      | AWS::CDK::Metadata | CDKMetadata
 2/3 | 1:11:29 PM | CREATE_COMPLETE      | AWS::S3::Bucket    | Bucket (Bucket83908E77)
 3/3 | 1:11:31 PM | CREATE_COMPLETE      | AWS::CloudFormation::Stack | cdk-labs

 ✅  cdk-labs    `
 ```
Insertar imágen del bucket


Si hacemos un cambio como activar la encripcion en el bucket al hacer el diff vemos que sigue ocupando el mismo hash
```sh
 (master **)$ cdk diff --profile hgmiguel.mx
c6e230
Stack cdk-labs
IAM Statement Changes
┌───┬───────────────────┬────────┬──────────────────────────────────────────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────┬───────────┐
│   │ Resource          │ Effect │ Action                                                                                       │ Principal                                                                                     │ Condition │
├───┼───────────────────┼────────┼──────────────────────────────────────────────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────────────────────────────────────┼───────────┤
│ + │ ${Bucket/Key.Arn} │ Allow  │ kms:CancelKeyDeletion                                                                        │ AWS:arn:${AWS::Partition}:iam::408460586533:root                                              │           │
│   │                   │        │ kms:Create*                                                                                  │                                                                                               │           │
│   │                   │        │ kms:Delete*                                                                                  │                                                                                               │           │
│   │                   │        │ kms:Describe*                                                                                │                                                                                               │           │
│   │                   │        │ kms:Disable*                                                                                 │                                                                                               │           │
│   │                   │        │ kms:Enable*                                                                                  │                                                                                               │           │
│   │                   │        │ kms:GenerateDataKey                                                                          │                                                                                               │           │
│   │                   │        │ kms:Get*                                                                                     │                                                                                               │           │
│   │                   │        │ kms:List*                                                                                    │                                                                                               │           │
│   │                   │        │ kms:Put*                                                                                     │                                                                                               │           │
│   │                   │        │ kms:Revoke*                                                                                  │                                                                                               │           │
│   │                   │        │ kms:ScheduleKeyDeletion                                                                      │                                                                                               │           │
│   │                   │        │ kms:TagResource                                                                              │                                                                                               │           │
│   │                   │        │ kms:UntagResource                                                                            │                                                                                               │           │
│   │                   │        │ kms:Update*                                                                                  │                                                                                               │           │
└───┴───────────────────┴────────┴──────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────┴───────────┘
(NOTE: There may be security-related changes not in this list. See https://github.com/aws/aws-cdk/issues/1299)

Resources
[+] AWS::KMS::Key Bucket/Key BucketKey7E4AEAB8
[~] AWS::S3::Bucket Bucket Bucket83908E77
 └─ [+] BucketEncryption
     └─ {"ServerSideEncryptionConfiguration":[{"ServerSideEncryptionByDefault":{"KMSMasterKeyID":{"Fn::GetAtt":["BucketKey7E4AEAB8","Arn"]},"SSEAlgorithm":"aws:kms"}}]}
```

Cuando hacemos el deploy el cambio se aplica sobre el bucket 

Insertar imagen aqui.

## Issues
cdk destroy doesn't work any more.
```2020-03-28 14:02:01 UTC-0600	Bucket83908E77	CREATE_FAILED	hgmiguel.mx.test-c6e230 already exists```

