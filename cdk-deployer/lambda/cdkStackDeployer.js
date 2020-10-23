'use strict';

const AWS = require('aws-sdk');
const cloudformation = new AWS.CloudFormation();
const {execSync} = require('child_process');
const default_region = process.env.AWS_REGION || 'eu-west-1';
const {emptyBucket} = require('./utils/empty-bucket');

const deploySucceeded = (id) => {
  console.log(`Deploy succeed. Id ${id}`);
}

const deployFailed = (res, id) => {
  console.log(`Deploy deployFailed. Id ${id}`);
  console.log(`Reason: ${res}`);
}

const destroySucceeded = (id) => {
  console.log(`Destroy succeeded. id: ${id}`);
}

const destroyFailed = (res, id) => {
  console.log(`Destroy failed: ${id}`);
  console.log(`Reason: ${res}`);
}

module.exports.deploy = async (id) => {
  console.log(`Deploy stack ${id}`);
  console.log(id);
  let res;
  try {
    res = await deployCDK({
      id: id,
      command: 'deploy',
      additionalCommandParam: ''
    });
  } catch (e) {
    deployFailed("Failed to deploy CDK" + e, id);
  }

  console.log('Deploy returned');
  console.log(res);

  // CDK deploy finished/failed
  if (isResultReturnCloudformationArn(res)) {
    const stackName = res.split('/')[1];
    console.log(`Deploy succeeded, stack name - ${stackName}`);
    deploySucceeded(id);
  } else {
    console.log('Deploy failed - return result is not stack arn');
    deployFailed(res, id);
  }
}

module.exports.destroy = async (id) => {
  console.log(`Destroy stack ${id}`);

  // empty buckets so that CDK destroy can delete it
  const siteBucketName = await getOutputFromStack(id, 'bucketName');
  await emptyBucket(siteBucketName);

  const res = await deployCDK({
    id: id,
    awsRegion: default_region,
    command: 'destroy',
    additionalCommandParam: '--force'
  });

  console.log('Destroy returned');
  console.log(res);

  if (res === "") {
    await destroySucceeded(id);
  } else {
    await destroyFailed(res, id);
  }
}

const isResultReturnCloudformationArn = (res) =>{
  const regex = new RegExp('^arn:aws:cloudformation:' + default_region + ':.+:stack\\/.*\\/.*', 'gi');
  return regex.test(res);
}

const getOutputFromStack = async (stackId, outputKey) => {
  return new Promise((resolve, reject) => {
    try {
      const params = {
        StackName: stackId
      };

      cloudformation.describeStacks(params, function (err, data) {
        if (err) {
          console.log(err, err.stack);
          reject();
        } else {
          console.log(data);
          console.log(data.Stacks[0].Outputs);
          resolve(data.Stacks[0].Outputs.find(stackOutput => stackOutput.OutputKey === outputKey).OutputValue);
        }
      });
    } catch (e) {
      console.log(e);
      reject();
    }
  });
}

const deployCDK = async (params) => {
  console.log(`Stack request for: ${params.id}`);
  console.log('Request started');

  // Set process.env.HOME Lambda default HOME is /home/usrXXX.
  const cmd = `
  export HOME='/tmp'
  ID_ENV='${params.id}' /opt/nodejs/node_modules/aws-cdk/bin/cdk ${params.command} -v ${params.additionalCommandParam}
  `;

  console.log(cmd);

  return execSync(cmd).toString();
}

