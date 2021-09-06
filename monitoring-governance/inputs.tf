variable "tags" {
  default     = {}
  type        = map(any)
  description = "Map of tags to assign to resources."
}

variable "aws_profile" {
  default     = ""
  type        = string
  description = "value"
}

variable "notification_email" {
  default     = ""
  type        = string
  description = "value"
}

# variable "iam_path" {
#   default     = ""
#   type        = string
#   description = "value"
# }

