output "bucket_name" {
    value = var.bucketname
}

output "bucket_id" {
    value = aws_s3_bucket.bucket.id
}