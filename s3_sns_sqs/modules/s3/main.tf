#Bucket Creation
resource "aws_s3_bucket" "bucket" {
  bucket  = "${var.accountid}-${var.region}-${var.bucketname}"
  tags                              = {
    Name                            = "${var.project_name}"
  }
}

# Creating bucket lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "rule_bucket" {
  bucket = aws_s3_bucket.bucket.id
  
    #Lifecycle Rule
  rule {
        id = "remove_old_files"
        status = "Enabled"

        expiration {
            days = 2
        }
    }
}


#Versioning Enabled
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket    = aws_s3_bucket.bucket.id
  versioning_configuration {
    status  = "Enabled"
  }
}

#The created bucket in nonpublic
resource "aws_s3_bucket_public_access_block" "block_bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


module "kms" {
    source                          = "../../modules/kms"
    project_name                    = var.project_name
    accountid                       = var.accountid
    region                          = var.region
}

# Enabling Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.kms.kms_arn
      sse_algorithm     = "aws:kms"
      
    }
    bucket_key_enabled = true
  }
}

module "sns" {
    source                          = "../../modules/sns&sqs"
    project_name                    = var.project_name
    snsname                         = var.snsname
    bucketname                      = var.bucketname
    sqsname                         = var.sqsname
    region                          = var.region
    accountid                       = var.accountid
}

# Creating Event Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket          = aws_s3_bucket.bucket.id
  topic {
    topic_arn     = module.sns.SNS_ARN
    events        = ["s3:ObjectCreated:*"] 
  }
}