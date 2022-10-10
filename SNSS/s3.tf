
#Bucket Creation
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucketname
  
  #Lifecycle Rule
  lifecycle_rule {
        id = "remove_old_files"
        enabled = true

        expiration {
            days = 2
        }
    }
}

#Versioning Enabled
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#The created bucket in nonpublic
resource "aws_s3_bucket_public_access_block" "block_bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Encryption Key
resource "aws_kms_key" "awss3key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.awss3key.arn
      sse_algorithm     = "aws:kms"
      
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.snstopic.arn
    events        = ["s3:ObjectCreated:*"]
    
  }
}