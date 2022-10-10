resource "aws_sqs_queue" "sqsqueue" {
  name = local.sqsname 
}

resource "aws_sqs_queue_policy" "sqspolicy" {
  queue_url = aws_sqs_queue.sqsqueue.id

  policy = <<POLICY
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

#resource "aws_sqs_queue" "sqsencrypt" {
#  name                              = local.sqsname 
#  kms_master_key_id                 = "alias/aws/sqs"
#}