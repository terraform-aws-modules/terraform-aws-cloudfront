terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws    = ">= 3.28.0"
    random = "~> 2"
    null   = "~> 2"
  }
}
