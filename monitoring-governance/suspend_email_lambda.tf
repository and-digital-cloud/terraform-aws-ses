

data "archive_file" "zip_file" {
  type        = "zip"
  output_path = "${local.archive_file_dir}/${var.function_name}.zip"
  source_file = "${local.archive_file_dir}/${var.function_name}.js"
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "sns.amazonaws.com"
  statement_id  = "allow_sns_to_invoke"
}

module "lambda_role" {
  source = "github.com/barundel/terraform-aws-iam?ref=v1.0.1"

    create_role = true
  role_name   = "${var.function_name}-Role"

  role_description = "Permissions for the ${var.function_name} Lambda."

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

resource "aws_lambda_function" "function" {
  filename      = "${local.archive_file_dir}/${var.function_name}.zip"
  function_name = var.function_name
  handler       = "${var.function_name}.handler"
  role          = module.lambda_role.iam_role_arn[0]
  runtime       = "nodejs14.x"
  timeout       = "180"

  tags = var.tags
}

