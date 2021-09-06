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