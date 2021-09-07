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
}