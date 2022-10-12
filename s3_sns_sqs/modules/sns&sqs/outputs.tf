output "SNS_ARN" {
    value = aws_sns_topic.snstopic.arn
}

output "SQS_ARN" {
    value = aws_sqs_queue.sqsqueue.arn
}