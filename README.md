# terraform-aws-ses [![Build Status](https://github.com/and-digital/terraform-aws-ses/workflows/build/badge.svg)](https://github.com/and-digital/terraform-aws-ses/actions)

> A terraform module for creating AWS SES resources.

## Table of Contents

- [Maintenance](#maintenance)
- [Getting Started](#getting-started)
- [License](#license)

## Maintenance

This project is maintained [AND Digital](https://github.com/and-digital), anyone is welcome to contribute.

## Getting Started

#### SES Forwarder

```
module "ses_forwarder" {
  source = "../../"

  sender = ["email@digital.domain.com"]
  to_email = "hello@domain.com"
  domain_name = "digital.domain.com"
  
     tags = {
    Name = "Email-Forwarder"
  }

```

## License

Apache 2 Licensed. See [HERE](https://github.com/and-digital/terraform-aws-ses/tree/master/LICENSE) for full details.
<!-- BEGIN_TF_DOCS -->
## email-verification

###Email Verifcation Code

This module is currnetly using null resource to run aws cli commands to verify an email and ad a policy to protect the email. There are terraform resoruces currently in development to support this feature. At the moment you have to passin the aws profile. 

### The Verification
If the email you are verifying is not going to be a real mailbox, instead you are going to use the forwarder you need to make sure that your email is included in the SES recipt rule as part of the forwarder module. 

### The Error
Part of this code is putting an policy wrap around the email, this can only happen when the email is verified, when you run the code you will get an error stating the email must be verified, so go and verify it via the email you get and run the code again. 


### The Terraform Work
https://github.com/terraform-providers/terraform-provider-aws/pull/6575
https://github.com/terraform-providers/terraform-provider-aws/pull/5128

<!--- BEGIN_TF_DOCS --->
## Providers

No provider.

## Inputs

No input.

## Outputs

No output.
<!--- END_TF_DOCS --->

## monitoring-governance

This module creates alarms for bounce and complaint rates and also a topic to send alerts to.

It also contains a lambda to suspend email sending should the rate reach a level of account suspension. 

<!--- BEGIN_TF_DOCS --->
## Providers

No provider.

## Inputs

No input.

## Outputs

No output.
<!--- END_TF_DOCS --->
<!-- END_TF_DOCS -->