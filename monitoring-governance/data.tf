data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_trust_profile" {
  statement {
    sid = "LambdaServiceTrust"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]
  }
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