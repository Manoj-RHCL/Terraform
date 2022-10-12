##########S3 Output##########
output "BUCKET_NAME" {
    value = module.s3.bucket_name
}

##########SNS & SQS Output##########
output "SNS_ARN" {
    value = module.sns.SNS_ARN
}

output "SQS_ARN" {
    value = module.sns.SQS_ARN
}