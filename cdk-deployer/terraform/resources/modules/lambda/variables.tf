variable "env" {
  description = "Deployment environment"
}

variable "service_prefix" {
  type = string
}

variable "service_lambda_execution_role" {
  type = string
}

variable "env_vars" {
  description = "A map that defines environment variables for the Lambda Functions"
  type        = map(string)
  default     = {}
}

variable "layers" {
  type        = list(string)
  description = "Lambda layer ARNs"
}
