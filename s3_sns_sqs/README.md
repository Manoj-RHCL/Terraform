# S3 bucket object, SNS & SQS
👤 **Manoj**

- Email: [manojkumaraug1@gmail.com]


Configuration in this directory creates S3 bucket objects with different configurations.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sns&sqs"></a> [sns&sqs](#module\sns&sqs) | ../../modules/sns&sqs | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\s3\) | ../../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Type |
|------|------|
| region | ap-south-1 |
| bucketname | evobrixxbck |
| project_name | dev/qa |
| snsname | testsns |
| sqsname | testsqs |
| accountid | 112233445566 |


## Outputs

| Name | Description |
|------|-------------|
| name="BUCKET_NAME" | The name of the bucket. |
| name="SNS_ARN" | The ARN of the SNS |
| name="SQS_ARN" | The ARN of the SQS |