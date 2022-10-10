terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }   
  }  
  required_version = ">= 0.14.9"
}

locals {
  prefix         = "${var.accountid}-${var.projectname}"
  bucketname     = "${local.prefix}-audit"
  snsname        = "${local.prefix}-sns-topic"  
  sqsname        = "${local.prefix}-sqs" 
  default_tags   = {
    Project      = upper(var.projectname)
    
  }  
}