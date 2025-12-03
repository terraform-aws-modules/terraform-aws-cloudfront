variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Distribution
################################################################################

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution"
  type        = list(string)
  default     = null
}

variable "anycast_ip_list_id" {
  description = "ID of the Anycast static IP list that is associated with the distribution"
  type        = string
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

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type = list(object({
    error_caching_min_ttl = optional(number)
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
  }))
  default = null
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type = object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cache_policy_id           = optional(string)
    cache_policy_name         = optional(string)
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    compress                  = optional(bool, true)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    forwarded_values = optional(object({
      cookies = object({
        forward           = optional(string, "none")
        whitelisted_names = optional(list(string))
      })
      headers                 = optional(list(string))
      query_string            = optional(bool, false)
      query_string_cache_keys = optional(list(string))
      }),
      {
        cookies = {
          forward = "none"
        }
        query_string = false
      }
    )
    function_association = optional(map(object({
      event_type   = optional(string)
      function_arn = optional(string)
      function_key = optional(string)
    })))
    grpc_config = optional(object({
      enabled = optional(bool)
    }))
    lambda_function_association = optional(map(object({
      event_type   = optional(string)
      include_body = optional(bool)
      lambda_arn   = string
    })))
    max_ttl                      = optional(number)
    min_ttl                      = optional(number)
    origin_request_policy_id     = optional(string)
    origin_request_policy_name   = optional(string)
    realtime_log_config_arn      = optional(string)
    response_headers_policy_id   = optional(string)
    response_headers_policy_name = optional(string)
    smooth_streaming             = optional(bool)
    target_origin_id             = string
    trusted_key_groups           = optional(list(string))
    trusted_signers              = optional(list(string))
    viewer_protocol_policy       = optional(string, "https-only")
  })
  nullable = false
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
  default     = true
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)"
  type = object({
    bucket          = optional(string)
    include_cookies = optional(bool)
    prefix          = optional(string)
  })
  default = null
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0"
  type = list(object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    cache_policy_id           = optional(string)
    cache_policy_name         = optional(string)
    compress                  = optional(bool, true)
    default_ttl               = optional(number)
    field_level_encryption_id = optional(string)
    forwarded_values = optional(object({
      cookies = object({
        forward           = optional(string, "none")
        whitelisted_names = optional(list(string))
      })
      headers                 = optional(list(string))
      query_string            = optional(bool, false)
      query_string_cache_keys = optional(list(string))
      }),
      {
        cookies = {
          forward = "none"
        }
        query_string = false
      }
    )
    function_association = optional(map(object({
      event_type   = optional(string)
      function_arn = optional(string)
      function_key = optional(string)
    })))
    grpc_config = optional(object({
      enabled = optional(bool)
    }))
    lambda_function_association = optional(map(object({
      event_type   = optional(string)
      include_body = optional(bool)
      lambda_arn   = string
    })))
    max_ttl                      = optional(number)
    min_ttl                      = optional(number)
    origin_request_policy_id     = optional(string)
    origin_request_policy_name   = optional(string)
    path_pattern                 = string
    realtime_log_config_arn      = optional(string)
    response_headers_policy_id   = optional(string)
    response_headers_policy_name = optional(string)
    smooth_streaming             = optional(bool)
    target_origin_id             = string
    trusted_key_groups           = optional(list(string))
    trusted_signers              = optional(list(string))
    viewer_protocol_policy       = string
  }))
  default  = []
  nullable = false
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)"
  type = map(object({
    failover_criteria = object({
      status_codes = list(number)
    })
    member = list(object({
      origin_id = string
    }))
    origin_id = optional(string)
  }))
  default = null
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)"
  type = map(object({
    connection_attempts = optional(number)
    connection_timeout  = optional(number)
    custom_header       = optional(map(string))
    custom_origin_config = optional(object({
      http_port                = number
      https_port               = number
      ip_address_type          = optional(string)
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
      origin_protocol_policy   = string
      origin_ssl_protocols     = optional(list(string), ["TLSv1.2"])
    }))
    domain_name               = string
    origin_access_control_key = optional(string)
    origin_access_control_id  = optional(string)
    origin_id                 = optional(string)
    origin_path               = optional(string)
    origin_shield = optional(object({
      enabled              = bool
      origin_shield_region = optional(string)
    }))
    response_completion_timeout = optional(number)
    vpc_origin_config = optional(object({
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
      vpc_origin_id            = optional(string)
      vpc_origin_key           = optional(string)
    }))
  }))
  default  = {}
  nullable = false
}

variable "price_class" {
  description = "The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
  type        = string
  default     = null
}

variable "restrictions" {
  description = "The restrictions configuration for this distribution"
  type = object({
    geo_restriction = object({
      locations        = optional(list(string))
      restriction_type = optional(string, "none")
    })
  })
  default = {
    geo_restriction = {
      restriction_type = "none"
    }
  }
  nullable = false
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards"
  type        = bool
  default     = null
}

variable "staging" {
  description = "Whether the distribution is a staging distribution"
  type        = bool
  default     = null
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string, "TLSv1.2_2025")
    ssl_support_method             = optional(string)
  })
  default  = {}
  nullable = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process"
  type        = bool
  default     = null
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL"
  type        = string
  default     = null
}

################################################################################
# Origin Access Control
################################################################################

variable "origin_access_control" {
  description = "Map of CloudFront origin access control"
  type = map(object({
    description      = optional(string)
    name             = optional(string)
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  }))
  default = {
    s3 = {
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
}

################################################################################
# VPC Origin
################################################################################

variable "vpc_origin" {
  description = "Map of CloudFront VPC origins"
  type = map(object({
    arn                    = string
    http_port              = number
    https_port             = number
    name                   = optional(string)
    origin_protocol_policy = string
    origin_ssl_protocols = object({
      items    = optional(list(string), ["TLSv1.2"])
      quantity = optional(number, 1)
    })
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default = null
}

################################################################################
# Response Headers Policy
################################################################################

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
