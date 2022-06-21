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

