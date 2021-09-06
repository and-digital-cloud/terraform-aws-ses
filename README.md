# terraform-iam [![Build Status](https://github.com/and-digital/terraform-aws-ses/workflows/build/badge.svg)](https://github.com/and-digital/terraform-aws-ses/actions)

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

<!--- BEGIN_TF_DOCS --->
## Providers

No provider.

## Inputs

No input.

## Outputs

No output.
<!--- END_TF_DOCS --->

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.