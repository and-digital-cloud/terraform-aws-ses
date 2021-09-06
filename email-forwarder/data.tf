data "aws_iam_account_alias" "current" {}
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "hosted_zone" {
  name = "${var.domain}"
}

data "aws_iam_policy_document" "lambda_execute_role" {

  statement {
    sid    = "BasePermissions"
    effect = "Allow"

    actions = [
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }

  statement {
      sid    = "s3Access"
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = ["${module.s3_bucket.bucket_arn}", "${module.s3_bucket.bucket_arn}/*"]
  }

}

data "aws_iam_policy_document" "extra_kms_policy" {

  statement {
    sid    = "BasePermissions"
    effect = "Allow"

    principals {
      identifiers = ["ses.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]

    resources = ["*"]
  }

}

data "aws_iam_policy_document" "bucket_policy" {

  statement {
    sid    = "BasePermissions"
    effect = "Allow"

    principals {
      identifiers = ["ses.amazonaws.com"]
      type        = "Service"
    }

    actions = [
      "s3:PutObject",
    ]

    resources = ["${module.s3_bucket.bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }

  }

}