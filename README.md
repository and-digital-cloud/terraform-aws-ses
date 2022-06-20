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

## Outputs

No output.
<!--- END_TF_DOCS --->
```
SES Forwarder
```hcl
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
| domain\_name | Domain being use to send email (Used to create MX records). | `string` | n/a | yes |
| sender | Email address that has received the email. | `list(string)` | n/a | yes |
| tags | Map of tags to assign to resources. | `map` | `{}` | no |
| to\_email | Address for forward emails onto. | `string` | n/a | yes |

## Outputs

No output.
<!--- END_TF_DOCS --->
```
Verify Domain
```hcl
# Usage
<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| domain | n/a | `string` | `""` | no |

## Outputs

No output.
<!--- END_TF_DOCS --->
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