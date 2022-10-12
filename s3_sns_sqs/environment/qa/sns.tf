module "sns" {
    source                          = "../../modules/sns&sqs"
    project_name                    = var.project_name
    snsname                         = var.snsname
    bucketname                      = var.bucketname
    sqsname                         = var.sqsname
    accountid                       = var.accountid
    region                          = var.region
}