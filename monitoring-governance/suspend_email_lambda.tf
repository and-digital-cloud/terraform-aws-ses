locals {
  archive_file_dir = "${path.module}/lib/"
}

variable "function_name" {default = "suspend_email_sending_lambda"}

data "archive_file" "zip_file" {
  type        = "zip"
  output_path = "${local.archive_file_dir}/${var.function_name}.zip"
  source_file = "${local.archive_file_dir}/${var.function_name}.js"
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "sns.amazonaws.com"
  statement_id  = "allow_sns_to_invoke"
}

module "lambda_role" {
  source = "git::https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/terraform.aws.iam"

  iam_path = "${var.iam_path}"

  role_name   = "${var.function_name}-Role"

  assume_role_policy = "${data.aws_iam_policy_document.lambda_trust_profile.json}"

  policies_to_attach = [
    "arn:aws:iam::aws:policy/AmazonSESFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = "${var.tags}"

}

resource "aws_lambda_function" "function" {
  filename      = "${local.archive_file_dir}/${var.function_name}.zip"
  function_name = "${var.function_name}"
  handler       = "${var.function_name}.handler"
  role          = "${module.lambda_role.iam_role_arn[0]}"
  runtime       = "nodejs8.10"
  timeout       = "180"

  tags = "${var.tags}"
}

