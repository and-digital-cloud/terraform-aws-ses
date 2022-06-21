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
# Email Verification

# Usage
<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_profile | aws profile to run cli commands as null resource (temporary untill terraform support) | `string` | `""` | no |
| email\_to\_verify | n/a | `list` | `[]` | no |

## Outputs

No output.
<!--- END_TF_DOCS --->

# Monitoring Governance

# Usage
<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws\_profile | AWS Profile | `string` | `""` | no |
| function\_name | n/a | `string` | `"suspend_email_sending_lambda"` | no |
| notification\_email | See the attached email for a bounced message | `string` | `""` | no |
| tags | Map of tags to assign to resources. | `map(any)` | `{}` | no |

## Outputs

No output.
<!--- END_TF_DOCS --->
<!-- END_TF_DOCS -->