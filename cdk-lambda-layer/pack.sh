#!/usr/bin/env sh

# lambda layer should be in a /nodejs/node_modules folder
rm -r ./nodejs
npm install
mkdir -p ./nodejs/node_modules
# remove aws-sdk as it's size is 50mb and it is available in Lambda anyway
rm -r ./node_modules/aws-cdk/node_modules/aws-sdk
cp -r ./node_modules/aws-cdk ./nodejs/node_modules
# zip lambda layer
zip -9 -FS -r layer.zip ./nodejs

# note that the maximum size of the a lambda and all its layers is 250mb
