# terraform-aws-ses [![Build Status](https://github.com/and-digital/terraform-aws-ses/workflows/build/badge.svg)](https://github.com/and-digital/terraform-aws-ses/actions)

> A terraform module for creating AWS SES resources.

## Table of Contents

- [Maintenance](#maintenance)
- [Getting Started](#getting-started)
- [License](#license)

## Maintenance

This project is maintained [AND Digital](https://github.com/and-digital), anyone is welcome to contribute.

## Getting Started
<!--- BEGIN_TF_DOCS --->
Email Verification
```hcl
// TODO - There is a terraform resource in progress for this:
// https://github.com/terraform-providers/terraform-provider-aws/pull/6575

resource "null_resource" "verify_email" {
  # This takes the client email and adds it to the email addresses in SES (will need to be verified by the email box owner)
  count = "${length(var.email_to_verify)}"
  provisioner "local-exec" {
    command = "aws --profile ${lower(var.aws_profile)} ses verify-email-identity --email-address ${element(var.email_to_verify, count.index)} "
  }
}

//TODO - https://docs.aws.amazon.com/cli/latest/reference/ses/put-identity-policy.html
// https://github.com/terraform-providers/terraform-provider-aws/pull/5128

resource "null_resource" "identity_policy" {
  # This takes the client email and adds it a policy to prevent another aws account from using it to send email
  count = "${length(var.email_to_verify)}"

  provisioner "local-exec" {
    command = "aws --profile ${lower(var.aws_profile)} ses put-identity-policy --identity ${element(var.email_to_verify, count.index)} --policy-name IdentPolicy --policy '${data.template_file.identity_template.rendered}'"
  }
}

data "template_file" "identity_template" {

  template = "${file("${path.module}/identity_policy.json")}"
  count = "${length(var.email_to_verify)}"

  vars {
    account_number = "${data.aws_caller_identity.current.account_id}"
    email_to_verify = "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identity/${element(var.email_to_verify, count.index)}"
  }

}
```
SES Forwarder
```hcl
locals {
  function_name = "email-forwarder"
  file_dir      = "${path.module}/lib"
  module_name   = "email-forwarder"
}

data "archive_file" "zip_file" {
  type        = "zip"
  output_path = "${local.file_dir}/${local.function_name}.zip"
  source_file = "${local.file_dir}/main.go"
}

###################
# Lambda          
###################

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
  tags              = var.tags
}

module "lambda_role" {
  source = "github.com/barundel/terraform-aws-iam?ref=v1.0.1"

  create_role = true
  role_name   = "${local.function_name}-Role"

  role_description = "Permissions for the ${local.function_name} Lambda."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  inline_policies_to_create = {
    "Permissions" = data.aws_iam_policy_document.lambda_execute_role.json
  }

  tags = var.tags

}

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "AllowExecutionFromSES"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.function.function_name
  principal      = "ses.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_lambda_function" "function" {

  filename      = "${local.file_dir}/lambda_ses_forwarder.zip"
  function_name = "${replace(local.module_name, ".", "-")}-lambda"
  handler       = "lambda_ses_forwarder_linux"
  role          = module.lambda_role.iam_role_arn[0]
  runtime       = "go1.x"
  timeout       = 5
  publish       = true

  environment {
    variables = {
      FORWARD_FROM = "%s forwarded by lambda for <noreply@digital.planixsops.com>"
      FORWARD_TO   = var.to_email
      S3_BUCKET    = aws_s3_bucket.bucket.id
    }
  }

  tags = var.tags
}

###################
# Bucket
###################
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.module_name}-${var.domain_name}-email-store"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "lb_logs_access_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

###################
# SES Email Identity
###################

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_domain_amazonses_verification_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "_amazonses.${var.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses_domain.verification_token]
}

###################
# SES Receipt Rule Config
###################

resource "aws_ses_receipt_rule_set" "ruleset" {
  rule_set_name = "${local.module_name}-recipt-ruleset"
}

resource "aws_ses_receipt_rule" "send_to_lambda_rule" {
  depends_on = [aws_ses_receipt_rule_set.ruleset]

  name          = "send_to_${local.module_name}"
  rule_set_name = aws_ses_receipt_rule_set.ruleset.rule_set_name
  enabled       = true
  scan_enabled  = true

  s3_action {
    position    = 1
    bucket_name = aws_s3_bucket.bucket.id
  }

  lambda_action {
    function_arn    = aws_lambda_function.function.arn
    position        = 2
    invocation_type = "Event"
  }

  recipients = var.sender
}

resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = aws_ses_receipt_rule_set.ruleset.rule_set_name
}



###################
# Route53 MX Record
###################

resource "aws_route53_record" "ses_receive" {
  name    = var.domain_name
  type    = "MX"
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  records = ["10 inbound-smtp.${data.aws_region.current.name}.amazonaws.com"]
  ttl     = "600"
}
```
Verify Domain
```hcl
resource "aws_ses_domain_identity" "ses_domain" {
  domain = "${var.domain}"
}

resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name    = "_amazonses.${aws_ses_domain_identity.ses_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = ["${aws_ses_domain_identity.ses_domain.verification_token}"]
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain = "${aws_ses_domain_identity.ses_domain.id}"
  depends_on = ["aws_route53_record.amazonses_verification_record"]
}
```
## Providers

No providers.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email_to_verify"></a> [email\_to\_verify](#input\_email\_to\_verify) | n/a | `list(string)` | `[]` | no |
## Outputs

No outputs.

<!--- END_TF_DOCS --->

## License

Apache 2 Licensed. See [HERE](https://github.com/and-digital/terraform-aws-ses/tree/master/LICENSE) for full details.