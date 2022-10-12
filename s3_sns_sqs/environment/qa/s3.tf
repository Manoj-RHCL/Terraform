module "s3" {
    source                          = "../../modules/s3"
    project_name                    = var.project_name
    bucketname                      = var.bucketname
    snsname                         = var.snsname
    sqsname                         = var.sqsname
    accountid                       = var.accountid
    region                          = var.region
}