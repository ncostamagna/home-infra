output "vault_kms_key_id" {
  description = "KMS key ID — use in vault values.yaml seal.awskms.kms_key_id"
  value       = module.vault_kms.kms_key_id
}

output "vault_kms_key_arn" {
  description = "KMS key ARN"
  value       = module.vault_kms.kms_key_arn
}

output "vault_aws_region" {
  description = "AWS region — use in vault values.yaml seal.awskms.region"
  value       = var.aws_region
}

output "vault_aws_access_key_id" {
  description = "AWS access key ID — store in the vault-aws-kms K8s secret"
  value       = module.vault_kms.aws_access_key_id
}

output "vault_aws_secret_access_key" {
  description = "AWS secret access key — store in the vault-aws-kms K8s secret"
  value       = module.vault_kms.aws_secret_access_key
  sensitive   = true
}
