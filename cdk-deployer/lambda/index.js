'use strict';

const {deploy, destroy} = require("./cdkStackDeployer");

// might need to run "cdk bootstrap --profile <profile_if_you_use> aws://<accountId>/<AWS_REGION>" in the acc/region when setting up for the first time
exports.deploy = async (event) => {
  console.log(event);
  await deploy(event['id']);
}

exports.destroy = async (event) => {
  console.log(event);
  await destroy(event['id']);
}
