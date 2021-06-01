variable "secret_id" {
  description = "(Required) Specifies the secret containing the version that you want to retrieve. You can specify either the Amazon Resource Name (ARN) or the friendly name of the secret."
  type        = string
  default     = ""
}

