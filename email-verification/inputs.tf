

variable "email_to_verify" {type = "list" default = []}

// aws profile to run cli commands as null resource (temporary untill terraform support)
variable "aws_profile" {default = ""}