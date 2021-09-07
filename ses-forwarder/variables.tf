variable "tags" {
  default = {}
  type = map
  description = "Map of tags to assign to resources."
}

variable "sender" {
  description = "Email address that has received the email."
  type = list(string)
}

variable "to_email" {
  description = "Address for forward emails onto."
  type = string
}

variable "domain_name" {
  description = "Domain being use to send email (Used to create MX records)."
  type = string
}
