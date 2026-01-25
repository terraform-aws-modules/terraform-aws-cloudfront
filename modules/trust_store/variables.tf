variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the trust store. Changing this forces a new resource to be created"
  type        = string
  default     = null
}

variable "ca_cert_bucket" {
  description = "S3 bucket name containing the CA certificates bundle"
  type        = string
  default     = null
}

variable "ca_cert_key" {
  description = "S3 object key for the CA certificates bundle"
  type        = string
  default     = null
}

variable "ca_cert_region" {
  description = "AWS region of the S3 bucket"
  type        = string
  default     = null
}

variable "ca_cert_version" {
  description = "S3 object version ID for the CA certificates bundle"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the place index"
  type        = map(string)
  default     = {}
}
