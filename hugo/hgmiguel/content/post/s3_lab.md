+++
categories = ["aws", "cdk", "laboratory"]
comments = true
date = "2020-03-28T15:59:13-04:00"
draft = true
showpagemeta = false
showcomments = true
slug = ""
tags = ["cdk", "aws", "ssm", "s3", "python"]
title = "S3 bucket with hash postfix "
description = "How to create an S3 bucket with cdk"

+++

The purpose of this laboratory is to create a S3 bucket with a random hash suffix, this hash need to be computed at the creation moment and for further updates it will be preserve.

I tried to put the suffix with a simple hash, but immediately we can notice that the suffix change every time.

Al intentar ponerle un sufijo al bucket obtenemos este en cada ejecución:
{{< highlight python "hl_lines=5 7">}}
class S3BucketStack(core.Stack):
    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        #create an S3 bucket
        hash = uuid.uuid4().hex[:6]
        bucket_name = self.node.try_get_context("bucket_name")
        s3Bucket = s3.Bucket(self, 'Bucket', bucket_name=f'{bucket_name}-{hash}')
        core.Tag.add(s3Bucket, "key", "value")

{{< / highlight >}}

{{< highlight sh "hl_lines=7">}}
 (master **)$ cdk --profile hgmiguel.mx diff
Stack cdk-labs
Resources
[~] AWS::S3::Bucket Bucket Bucket83908E77 replace
 └─ [~] BucketName (requires replacement)
     ├─ [-] hgmiguel.mx.test
     └─ [+] hgmiguel.mx.test-1a04f6
{{< / highlight >}}

En la siguiente ejecución el hash vuelve a cambiar

{{< highlight sh "hl_lines=7">}}
 (master **)$ cdk --profile hgmiguel.mx diff
Stack cdk-labs
Resources
[~] AWS::S3::Bucket Bucket Bucket83908E77 replace
 └─ [~] BucketName (requires replacement)
     ├─ [-] hgmiguel.mx.test
     └─ [+] hgmiguel.mx.test-ba38c8
{{< / highlight >}}

I tried to archive this only with CDK but I didn't make it. It was so difficult to create the parameter store at the beginning that I abandoned quickly.

I had thought about integrate sdk with boto3, and that made it.

{{< highlight python>}}
    def get_hash(self, bucket_name):
        client = boto3.client('ssm')
        s3_hash_parameter = self.node.try_get_context("s3_hash_parameter")
        try:
            response = client.get_parameter(
                Name=s3_hash_parameter,
                WithDecryption=True
            )

            s3_hashes = json.loads(response['Parameter']['Value'])
            if bucket_name in s3_hashes:
                return s3_hashes[bucket_name]
            else:
                s3_hashes[bucket_name] = uuid.uuid4().hex[:6]
        except  Exception as e:
            print(e)
            s3_hashes = {bucket_name: uuid.uuid4().hex[:6]}

        response = client.put_parameter(
            Name=s3_hash_parameter,
            Value=json.dumps(s3_hashes),
            Type='SecureString',
            Overwrite=True,
            Tier='Intelligent-Tiering'
        )

        return s3_hashes[bucket_name]
{{< / highlight >}}

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

