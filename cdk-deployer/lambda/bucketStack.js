const {App, Stack, CfnOutput, RemovalPolicy} = require("@aws-cdk/core");
const {Bucket} = require('@aws-cdk/aws-s3');
const {PolicyStatement, Effect} = require('@aws-cdk/aws-iam');

const STACK_ID = process.env.ID_ENV;

class MyBucketStack extends Stack {
  constructor(scope, id, props) {
    super(scope, id, props);

    const siteBucket = new Bucket(this, 'siteBucket', {
      removalPolicy: RemovalPolicy.DESTROY,
    });

    const bucketPolicyStatement = new PolicyStatement({
      effect: Effect.ALLOW,
      resources: [
        `${siteBucket.bucketArn}/*`
      ],
      actions: ["s3:GetObject"]
    })

    bucketPolicyStatement.addAnyPrincipal();
    siteBucket.addToResourcePolicy(bucketPolicyStatement);

    new CfnOutput(this, 'bucketName', {
      value: siteBucket.bucketName
    });
  }
}

const runStack = () => {
  new MyBucketStack(new App(), STACK_ID);
}

module.exports = {
  runStack
}
