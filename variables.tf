################################################################################
# Distribution
################################################################################

variable "create_distribution" {
  description = "Controls if CloudFront distribution should be created"
  type        = bool
  default     = true
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type        = list(string)
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution"
  type        = string
  default     = null
}

variable "continuous_deployment_policy_id" {
  description = "Identifier of a continuous deployment policy. This argument should only be set on a production distribution"
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2"
  type        = string
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution"
  type        = bool
  default     = null
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards"
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process"
  type        = bool
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL"
  type        = string
  default     = null
}

variable "staging" {
  description = "Whether the distribution is a staging distribution"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)"
  type        = any
  default     = null
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)"
  type        = any
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)"
  type        = any
  default     = {}
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0"
  type        = any
  default     = []
}

################################################################################
# Origin Access Control
################################################################################

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

variable "origin_access_control" {
  description = "Map of CloudFront origin access control"
  type = map(object({
    name             = optional(string)
    description      = string
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  }))

  default = {
    s3 = {
      description      = "",
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
}

################################################################################
# VPC Origin
################################################################################

variable "create_vpc_origin" {
  description = "If enabled, the resource for VPC origin will be created"
  type        = bool
  default     = false
}

variable "vpc_origin" {
  description = "Map of CloudFront VPC origin"
  type = map(object({
    name                   = string
    arn                    = string
    http_port              = number
    https_port             = number
    origin_protocol_policy = string
    origin_ssl_protocols = object({
      items    = list(string)
      quantity = number
    })
  }))
  default = {}
}

variable "vpc_origin_timeouts" {
  description = "Create, update, and delete timeout configurations for vpc origin"
  type        = map(string)
  default     = {}
}

################################################################################
# Response Headers Policy
################################################################################

variable "create_response_headers_policy" {
  description = "Controls if CloudFront response headers policies should be created"
  type        = bool
  default     = false
}

variable "response_headers_policies" {
  description = "Map of CloudFront response headers policies with their configurations"
  type = map(object({
    name    = optional(string)
    comment = optional(string)
    cors_config = optional(object({
      access_control_allow_credentials = bool
      origin_override                  = bool
      access_control_allow_headers = object({
        items = list(string)
      })
      access_control_allow_methods = object({
        items = list(string)
      })
      access_control_allow_origins = object({
        items = list(string)
      })
      access_control_expose_headers = optional(object({
        items = list(string)
      }))
      access_control_max_age_sec = optional(number)
    }))
    custom_headers_config = optional(object({
      items = list(object({
        header   = string
        override = bool
        value    = string
      }))
    }))
    remove_headers_config = optional(object({
      items = list(object({
        header = string
      }))
    }))
    security_headers_config = optional(object({
      content_security_policy = optional(object({
        content_security_policy = string
        override                = bool
      }))
      content_type_options = optional(object({
        override = bool
      }))
      frame_options = optional(object({
        frame_option = string
        override     = bool
      }))
      referrer_policy = optional(object({
        referrer_policy = string
        override        = bool
      }))
      strict_transport_security = optional(object({
        access_control_max_age_sec = number
        override                   = bool
        include_subdomains         = optional(bool)
        preload                    = optional(bool)
      }))
      xss_protection = optional(object({
        mode_block = bool
        override   = bool
        protection = bool
        report_uri = optional(string)
      }))
    }))
    server_timing_headers_config = optional(object({
      enabled       = bool
      sampling_rate = number
    }))
  }))
  default = null
}

################################################################################
# Function(s)
################################################################################

variable "create_cloudfront_function" {
  description = "Controls if CloudFront Functions should be created"
  type        = bool
  default     = false
}

variable "cloudfront_functions" {
  description = "Map of CloudFront Function configurations. Key is used as default function name if 'name' not specified"
  type = map(object({
    name                         = optional(string)
    runtime                      = optional(string, "cloudfront-js-2.0")
    comment                      = optional(string)
    publish                      = optional(bool)
    code                         = string
    key_value_store_associations = optional(list(string))
  }))
  default = null
}

################################################################################
# Monitoring Subscription
################################################################################

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created"
  type        = bool
  default     = false
}

variable "realtime_metrics_subscription_status" {
  description = "A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`"
  type        = string
  default     = "Enabled"
}
