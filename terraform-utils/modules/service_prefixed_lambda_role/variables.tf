variable "name_prefix" {
  type = string
}

variable "allowed_service_prefixes" {
  type = list(string)
}

variable "additional_policies" {
  type        = list(string)
  default     = []
  description = "A list of additional IAM policy ARNs. Will be attached to execution role"
}