const path = require('path');
const webpack = require('webpack');

module.exports = {
  context: __dirname,
  entry: {
    index: './index.js',
    cdkStack: './cdkStack.js'
  },
  output: {
    path: path.join(__dirname, "/out"),
    filename: '[name]bundle.js',
    libraryTarget: 'commonjs2'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader',
          options: {
            babelrc: true
          }
        }
      }
    ],
  },
  optimization:{
    minimize: false,
  },
  target: 'node',
  externals: [ "custom_common_lib", "aws-sdk"]
};