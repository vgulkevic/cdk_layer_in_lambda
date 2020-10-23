output "deploy_online_auction_lambda_arn" {
  value = module.cdk_deploy_lambda.lambda_invoke_arn
}

output "destroy_online_auction_lambda_arn" {
  value = module.cdk_destroy_lambda.lambda_invoke_arn
}
