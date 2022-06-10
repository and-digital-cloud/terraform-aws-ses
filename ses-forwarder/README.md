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
