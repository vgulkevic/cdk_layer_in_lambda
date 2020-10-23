# CDK Layer in Lambda

This is an example how I used CDK in a Lambda layer to deploy and manage multiple but similar stacks.

## Overview

Gradle is used to zip the lambda layer, run Webpack to optimize lambda's code and dependencies, pack it and to run terraform apply. Please note that in this example I used `-auto-approve` flag. (see /terraform-utils/deploy.sh)
  
## Prerequisite
  
  - terraform (v0.12.28 was used)
    
  
## Usage

If you want to run this example you need to

1. You might need to run cdk bootstrap "cdk bootstrap --profile <profile_if_you_use> aws://<accountId>/<AWS_REGION>" in the acc/region when running CDK for the first time in this AWS account

2. Setup remote state for terraform:

In `cdk-deployer/terraform/remote-state` set your provider settings and run
```
terraform init
terraform apply
```

4. Get the names of remote state S3 bucket and DynamoDB table and set them in

`cdk_layer_in_lambda/cdk-deployer/terraform/prod/main.tf

5. To deploy your lambda run:
```
sh gradlew cdk-lambda-layer:packageLayer
sh gradlew cdk-deployer:deploy
```
Or use Gradle in Intellij

6. Call deploy/destroy lambda with payload
```
{
  "id": "myStackName"
}
```

## Content
`/cdk-lambda-layer` - install CDK, prepare zip
`/cdk-deployer/lambda` - Stack definition, Lambda code
`/cdk-deployer/terraform` - terraform to deployer Lambda together with CDK in layer
