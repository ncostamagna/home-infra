output "kms_key_id" {
  description = "KMS key ID"
  value       = aws_kms_key.vault_unseal.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = aws_kms_key.vault_unseal.arn
}

output "aws_access_key_id" {
  description = "AWS access key ID"
  value       = aws_iam_access_key.vault_unseal.id
}

output "aws_secret_access_key" {
  description = "AWS secret access key"
  value       = aws_iam_access_key.vault_unseal.secret
  sensitive   = true
}
