variable "tags" {
  default     = {}
  type        = map(any)
  description = "Map of tags to assign to resources."
}

variable "aws_profile" {
  default     = ""
  type        = string
  description = "AWS Profile"
}

variable "notification_email" {
  default     = ""
  type        = string
  description = "See the attached email for a bounced message"
}


variable "function_name" { default = "suspend_email_sending_lambda" }

