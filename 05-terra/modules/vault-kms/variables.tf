variable "key_alias" {
  description = "KMS key alias"
  type        = string
  default     = "vault-unseal"
}

variable "iam_user_name" {
  description = "IAM user name for Vault unseal"
  type        = string
  default     = "vault-unseal"
}
