#!/usr/bin/env sh

rm -r function.zip
rm -r ./out
npm install
npm run-script build
cp cdk.json ./out
# see https://github.com/aws/aws-cdk/issues/7284. this line is not needed if you don't use custom resources.
#cp ./node_modules/@aws-cdk/custom-resources/lib/aws-custom-resource/sdk-api-metadata.json ./out
cd ./out && zip -r function.zip ./* && cd .. && mv ./out/function.zip ./function.zip
