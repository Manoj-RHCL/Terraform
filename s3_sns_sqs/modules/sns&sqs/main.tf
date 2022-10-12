# SNS Topic Creation
resource "aws_sns_topic" "snstopic" {
  name                              = var.snsname
  tags                              = {
    Name                            = "${var.project_name}"
  }
  policy                            = <<POLICY
{
    "Version": "2008-10-17",
    "Id": "__default_policy_ID",
    "Statement": [{
            "Sid": "__default_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "SNS:Publish",
                "SNS:RemovePermission",
                "SNS:SetTopicAttributes",
                "SNS:DeleteTopic",
                "SNS:ListSubscriptionsByTopic",
                "SNS:GetTopicAttributes",
                "SNS:AddPermission",
                "SNS:Subscribe"
            ],
            "Resource": "arn:aws:sns:${var.region}:${var.accountid}:${var.snsname}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceOwner": "${var.accountid}"
                }
            }
        },
        {
            "Sid": "Example SNS topic policy",
            "Effect": "Allow",
            "Principal": {
                "Service": "s3.amazonaws.com"
            },
            "Action": [
                "SNS:Publish"
                
            ],
            "Resource": "arn:aws:sns:${var.region}:${var.accountid}:${var.snsname}",
            "Condition": {
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:*:*:${var.accountid}-${var.region}-${var.bucketname}"
                },
                "StringEquals": {
                    "aws:SourceAccount": "${var.accountid}"
                }
            }
        },
        {
            "Sid": "__console_pub_0",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "SNS:Publish",
            "Resource": "arn:aws:sns:${var.region}:${var.accountid}:${var.snsname}"
        },
        {
            "Sid": "__console_sub_0",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "SNS:Subscribe",
            "Resource": "arn:aws:sns:${var.region}:${var.accountid}:${var.snsname}"
        }
    ]
}
POLICY
}

# SNS Topic Delivery Policy Update
resource "aws_sns_topic" "snstopic1" {
  name                              = var.snsname
  delivery_policy                   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

# SNS Encryption Using KMS
resource "aws_sns_topic" "snsencrypt" {
  name                              = var.snsname
  kms_master_key_id                 = "alias/${var.project_name}-evobrixX-audit-keys"
}

# SNS 
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn                         = aws_sns_topic.snstopic.arn
  protocol                          = "sqs"
  endpoint                          = aws_sqs_queue.sqsqueue.arn
}

# Creating SQS Queue
resource "aws_sqs_queue" "sqsqueue" {
  name                              = var.sqsname
  kms_master_key_id                 = "alias/${var.project_name}-evobrixX-audit-keys"
  kms_data_key_reuse_period_seconds = 300
  tags                              = {
    Name                            = "${var.project_name}"
  } 
}

# Adding SQS Policy
resource "aws_sqs_queue_policy" "sqspolicy" {
  queue_url                         = aws_sqs_queue.sqsqueue.id
  policy                            = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqsqueue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.snstopic.arn}"
        }
      }
    }
  ]
}
POLICY
}