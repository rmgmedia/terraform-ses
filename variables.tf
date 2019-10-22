variable "domain" {
  type        = string
  description = "Domain to use for SES"
}

variable "ses_records" {
  type        = list(string)
  description = "Additional entries which are added to the _amazonses record"
  default     = []
}
