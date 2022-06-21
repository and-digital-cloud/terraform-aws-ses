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
