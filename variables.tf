variable "distributions" {
  type = map(object({
    aliases                         = optional(list(string), [])
    comment                         = optional(string, null)
    continuous_deployment_policy_id = optional(string, null)
    default_root_object             = optional(string, null)
    enabled                         = optional(bool, true)
    http_version                    = optional(string, "http2")
    is_ipv6_enabled                 = optional(bool, null)
    price_class                     = optional(string, null)
    retain_on_delete                = optional(bool, false)
    staging                         = optional(bool, false)
    wait_for_deployment             = optional(bool, true)
    web_acl_id                      = optional(string, null)
    tags                            = map(string)

    logging_config = optional(map(string), {})

    origin = map(object({
      domain_name              = string
      origin_id                = string
      origin_path              = optional(string, "")
      connection_attempts      = optional(number, 3)
      connection_timeout       = optional(number, 10)
      origin_access_control_id = optional(string, null)

      custom_origin_config = object({
        http_port                = number
        https_port               = number
        origin_protocol_policy   = string
        origin_ssl_protocols     = list(string)
        origin_keepalive_timeout = optional(number, 60)
        origin_read_timeout      = optional(number, 30)
      })

      custom_header = optional(list(object({
        name  = string
        value = string
      })), [])

      origin_shield = optional(object({
        enabled              = optional(bool, false)
        origin_shield_region = optional(string, "us-east-1")
      }), {})
    }))

    origin_group = optional(map(object({
      origin_id                  = string
      failover_status_codes      = optional(list(number), [])
      primary_member_origin_id   = optional(string, null)
      secondary_member_origin_id = optional(string, null)
    })), {})

    default_cache_behavior = object({
      target_origin_id           = string
      viewer_protocol_policy     = optional(string, null)
      allowed_methods            = optional(list(string), ["GET", "HEAD", "OPTIONS"])
      cached_methods             = optional(list(string), ["GET", "HEAD"])
      compress                   = optional(bool, null)
      field_level_encryption_id  = optional(string, null)
      smooth_streaming           = optional(bool, null)
      trusted_signers            = optional(list(string), [])
      trusted_key_groups         = optional(list(string), [])
      cache_policy_id            = optional(string, null)
      origin_request_policy_id   = optional(string, null)
      response_headers_policy_id = optional(string, null)

      min_ttl     = optional(number, null)
      default_ttl = optional(number, null)
      max_ttl     = optional(number, null)

      use_forwarded_values    = optional(bool, true)
      query_string            = optional(bool, true)
      query_string_cache_keys = optional(list(string), [])
      headers                 = optional(list(string), [])

      cookies_forward           = optional(string, "none")
      cookies_whitelisted_names = optional(list(string), [])

      lambda_function_association = optional(list(object({
        event_type   = optional(string, null)
        lambda_arn   = optional(string, null)
        include_body = optional(bool, null)
      })), [])

      function_association = optional(list(object({
        event_type   = optional(string, null)
        function_arn = optional(string, null)
      })), [])
    })

    ordered_cache_behavior = optional(list(object({
      path_pattern               = optional(string, null)
      target_origin_id           = optional(string, null)
      viewer_protocol_policy     = string
      allowed_methods            = optional(list(string), ["GET", "HEAD"])
      cached_methods             = optional(list(string), ["GET", "HEAD"])
      compress                   = optional(bool, null)
      field_level_encryption_id  = optional(string, null)
      smooth_streaming           = optional(bool, null)
      trusted_signers            = optional(list(string), [])
      trusted_key_groups         = optional(list(string), [])
      cache_policy_id            = optional(string, null)
      origin_request_policy_id   = optional(string, null)
      response_headers_policy_id = optional(string, null)

      min_ttl     = optional(number, null)
      default_ttl = optional(number, null)
      max_ttl     = optional(number, null)

      use_forwarded_values      = optional(bool, true)
      query_string              = optional(bool, false)
      query_string_cache_keys   = optional(list(string), [])
      headers                   = optional(list(string), [])
      cookies_forward           = optional(string, "none")
      cookies_whitelisted_names = optional(list(string), [])

      lambda_function_association = optional(list(object({
        event_type   = optional(string, null)
        lambda_arn   = optional(string, null)
        include_body = optional(bool, null)
      })), [])

      function_association = optional(list(object({
        event_type   = optional(string, null)
        function_arn = optional(string, null)
      })), [])
    })), [])

    viewer_certificate = object({
      acm_certificate_arn            = string
      cloudfront_default_certificate = optional(bool, false)
      iam_certificate_id             = optional(string, null)
      minimum_protocol_version       = string
      ssl_support_method             = string
    })

    custom_error_response = optional(list(object({
      error_code            = optional(string, null)
      response_code         = optional(number, null)
      response_page_path    = optional(string, null)
      error_caching_min_ttl = optional(number, null)
    })), [])

    geo_restriction = object({
      restriction_type = string
      locations        = list(string)
    })
  }))
  description = "Map of CloudFront distributions"
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type        = any
  default     = []
}
