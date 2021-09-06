data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

data "aws_iam_policy_document" "lambda_execute_role" {

  statement {
    sid    = "SES"
    effect = "Allow"

    actions = [
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "Logs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "s3Access"
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
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

    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:Referer"
      values   = [data.aws_caller_identity.current.account_id]
    }

  }

}