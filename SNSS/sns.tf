resource "aws_sns_topic" "snstopic" {
  name = local.snsname

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:${var.awsregion}:${var.accountid}:${local.snsname}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.bucket.arn}"}
        }
    }]
    "Statement":[{
        "Effect": "Allow",
        "Principal":  "*" ,
        "Action": "SNS:Subscribe",
        "Resource": "arn:aws:sqs:${var.awsregion}:${var.accountid}:${local.sqsname}",
        }]
}
POLICY
}
resource "aws_sns_topic" "snstopic1" {
  name            = local.snsname
  delivery_policy = <<EOF
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

resource "aws_sns_topic" "snsencrypt" {
  name              = local.snsname
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.snstopic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqsqueue.arn
}