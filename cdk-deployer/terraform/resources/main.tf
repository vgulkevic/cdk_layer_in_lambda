locals {
  service_prefix = "cdk-deployer"
  lambda_layers  = [aws_lambda_layer_version.lambda_cdk_layer.arn]
}

resource "aws_lambda_layer_version" "lambda_cdk_layer" {
  layer_name          = "${local.service_prefix}-cdk-${var.env}"
  filename            = "../../../cdk-lambda-layer/layer.zip"
  source_code_hash    = filebase64sha256("../../../cdk-lambda-layer/layer.zip")
  compatible_runtimes = ["nodejs12.x"]
}

module "lambda" {
  source                        = "./modules/lambda"
  service_prefix                = local.service_prefix
  env                           = var.env
  layers                        = local.lambda_layers
  service_lambda_execution_role = module.service_lambda_execution_role.role_arn

  env_vars = {
    MY_ENV = "ENV_TO_PASS_TO_LAMBDA"
  }
}

// NOTE: amend the role permissions to meet your needs
resource "aws_iam_policy" "allow_deploy_destroy" {
  name_prefix = "${local.service_prefix}-${var.env}"
  policy      = templatefile("../resources/res/deployer_lambda_policy.tpl", {})
}

module "service_lambda_execution_role" {
  source              = "../../../terraform-utils/modules/service_prefixed_lambda_role"
  additional_policies = [aws_iam_policy.allow_deploy_destroy.arn]
  name_prefix         = "${local.service_prefix}-${var.env}"

  allowed_service_prefixes = [
    local.service_prefix
  ]
}
