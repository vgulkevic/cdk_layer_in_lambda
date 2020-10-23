module "cdk_deploy_lambda" {
  source         = "vladcar/serverless-common-basic-lambda/aws"
  version        = "1.2.2"
  source_path    = "../../lambda/function.zip"
  function_name  = "${var.service_prefix}-deploy-${var.env}"
  handler        = "indexbundle.deploy"
  memory_size    = 128
  runtime        = "nodejs12.x"
  execution_role = var.service_lambda_execution_role
  env_vars       = var.env_vars
  layers         = var.layers
  create_role    = false
  // amend the timeout to meet your needs
  timeout = 120
}

module "cdk_destroy_lambda" {
  source         = "vladcar/serverless-common-basic-lambda/aws"
  version        = "1.2.2"
  source_path    = "../../lambda/function.zip"
  function_name  = "${var.service_prefix}-destroy-${var.env}"
  handler        = "indexbundle.destroy"
  memory_size    = 128
  runtime        = "nodejs12.x"
  execution_role = var.service_lambda_execution_role
  env_vars       = var.env_vars
  layers         = var.layers
  create_role    = false
  // amend the timeout to meet your needs
  timeout = 120
}
