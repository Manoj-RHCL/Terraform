output "kms_arn" {
    value = aws_kms_key.kms-key.arn
}

output "kms_id" {
    value = aws_kms_key.kms-key.key_id
}