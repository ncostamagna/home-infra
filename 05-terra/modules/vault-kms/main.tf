data "aws_caller_identity" "current" {}

resource "aws_kms_key" "vault_unseal" {
  description             = "Vault auto-unseal key"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable root account full access"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Vault to use the key for auto-unseal"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.vault_unseal.arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "vault_unseal" {
  name          = "alias/${var.key_alias}"
  target_key_id = aws_kms_key.vault_unseal.key_id
}

resource "aws_iam_user" "vault_unseal" {
  name = var.iam_user_name
  path = "/system/"
}

resource "aws_iam_user_policy" "vault_unseal" {
  name = "vault-unseal-kms"
  user = aws_iam_user.vault_unseal.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
        ]
        Resource = aws_kms_key.vault_unseal.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "vault_unseal" {
  user = aws_iam_user.vault_unseal.name
}
