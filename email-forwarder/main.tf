locals {
  function_name = "email-forwarder"
  file_dir = "${path.module}/lib"
}

data "archive_file" "zip_file" {
  type        = "zip"
  output_path = "${local.file_dir}/${local.function_name}.zip"
  source_file = "${local.file_dir}/${local.function_name}.js"
}


module "lambda_role" {
  source = "git::https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/terraform.aws.iam//modules/lambda_execution_role"

  role_name   = "${local.function_name}-Role"

  role_description = "Permissions for the ${local.function_name} Lambda."

  role_policy_statements = "${data.aws_iam_policy_document.lambda_execute_role.json}"

  tags = "${var.tags}"


}

resource "aws_lambda_permission" "allow_ses" {
  statement_id  = "AllowExecutionFromSES"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "ses.amazonaws.com"
  source_account    = "${data.aws_caller_identity.current.account_id}"
}


resource "aws_lambda_function" "function" {

  filename      = "${local.file_dir}/${local.function_name}.zip"
  function_name = "${replace(var.domain, ".", "-")}-${local.function_name}"
  handler       = "${local.function_name}.handler"
  role          = "${module.lambda_role.role_arn}"
  runtime       = "nodejs8.10"
  timeout       = 5
  publish = true

    environment {
      variables = {
        BUCKET_NAME = "${module.s3_bucket.bucket_id}"
      }
    }

  tags = "${var.tags}"
}

////////// S3 BUCKET CRREATION //////////
module "s3_bucket" {

  source               = "git::https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/terraform.aws.s3?ref=v1.2.1"
  sse_algorithm = "AES256"
  create_bucket_policy = true
  bucket_policy_iam = "${data.aws_iam_policy_document.bucket_policy.json}"
  tags   = "${var.tags}"
  logging_bucket = "flatfrog-infrastructure-bucket"
}

////////// SES RECIPT RULE CONFIG //////////

resource "aws_ses_receipt_rule_set" "ruleset" {
  rule_set_name = "${local.function_name}-recipt-ruleset"
}

resource "aws_ses_receipt_rule" "send_to_rule" {
  name          = "send_to_${local.function_name}"
  rule_set_name = "${aws_ses_receipt_rule_set.ruleset.rule_set_name}"
  enabled       = true
  scan_enabled  = true

  s3_action {
    position    = 1
    bucket_name = "${module.s3_bucket.bucket_id}"
  }

  lambda_action {
    function_arn    = "${aws_lambda_function.function.arn}"
    position        = 2
    invocation_type = "Event"
  }

  recipients = [
    "${var.emails_to_forward}",
  ]
}

resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = "${aws_ses_receipt_rule_set.ruleset.rule_set_name}"
}

////////// ROUTE53 CONFIG //////////

resource "aws_route53_record" "ses_receive" {
  name    = "${var.domain}"
  type    = "MX"
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  records = ["10 inbound-smtp.eu-west-1.amazonaws.com"]
  ttl     = "600"
}

