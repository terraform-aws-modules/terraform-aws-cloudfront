resource "aws_cloudfront_distribution" "this" {
  #count = each.value.create_distribution ? 1 : 0
  for_each = { for idx, config in var.distributions : idx => config }

  aliases                         = each.value.aliases
  comment                         = each.value.comment
  continuous_deployment_policy_id = each.value.continuous_deployment_policy_id
  default_root_object             = each.value.default_root_object
  enabled                         = each.value.enabled
  http_version                    = each.value.http_version
  is_ipv6_enabled                 = each.value.is_ipv6_enabled
  price_class                     = each.value.price_class
  retain_on_delete                = each.value.retain_on_delete
  staging                         = each.value.staging
  wait_for_deployment             = each.value.wait_for_deployment
  web_acl_id                      = each.value.web_acl_id
  tags                            = each.value.tags

  dynamic "logging_config" {
    for_each = length(keys(each.value.logging_config)) == 0 ? [] : [each.value.logging_config]

    content {
      bucket          = logging_config.value["bucket"]
      prefix          = lookup(logging_config.value, "prefix", null)
      include_cookies = lookup(logging_config.value, "include_cookies", null)
    }
  }

  dynamic "origin" {
    for_each = each.value.origin

    content {
      domain_name              = origin.value.domain_name
      origin_id                = lookup(origin.value, "origin_id", origin.key)
      origin_path              = lookup(origin.value, "origin_path", "")
      connection_attempts      = lookup(origin.value, "connection_attempts", null)
      connection_timeout       = lookup(origin.value, "connection_timeout", null)
      origin_access_control_id = lookup(origin.value, "origin_access_control_id", lookup(lookup(aws_cloudfront_origin_access_control.this, lookup(origin.value, "origin_access_control", ""), {}), "id", null))

      dynamic "custom_origin_config" {
        for_each = length(lookup(origin.value, "custom_origin_config", "")) == 0 ? [] : [lookup(origin.value, "custom_origin_config", "")]

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", null)
          origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", null)
        }
      }

      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_header", [])

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "origin_shield" {
        for_each = length(keys(lookup(origin.value, "origin_shield", {}))) == 0 ? [] : [lookup(origin.value, "origin_shield", {})]

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = each.value.origin_group != null ? each.value.origin_group : {}

    content {
      origin_id = lookup(origin_group.value, "origin_id", origin_group.key)

      failover_criteria {
        status_codes = origin_group.value["failover_status_codes"]
      }

      member {
        origin_id = origin_group.value["primary_member_origin_id"]
      }

      member {
        origin_id = origin_group.value["secondary_member_origin_id"]
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = [each.value.default_cache_behavior]
    iterator = i

    content {
      target_origin_id       = i.value["target_origin_id"]
      viewer_protocol_policy = i.value["viewer_protocol_policy"]

      allowed_methods           = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods            = lookup(i.value, "cached_methods", ["GET", "HEAD"])
      compress                  = lookup(i.value, "compress", null)
      field_level_encryption_id = lookup(i.value, "field_level_encryption_id", null)
      smooth_streaming          = lookup(i.value, "smooth_streaming", null)
      trusted_signers           = lookup(i.value, "trusted_signers", null)
      trusted_key_groups        = lookup(i.value, "trusted_key_groups", null)

      cache_policy_id            = try(i.value.cache_policy_id, data.aws_cloudfront_cache_policy.this[i.value.cache_policy_name].id, null)
      origin_request_policy_id   = try(i.value.origin_request_policy_id, data.aws_cloudfront_origin_request_policy.this[i.value.origin_request_policy_name].id, null)
      response_headers_policy_id = try(i.value.response_headers_policy_id, data.aws_cloudfront_response_headers_policy.this[i.value.response_headers_policy_name].id, null)

      realtime_log_config_arn = lookup(i.value, "realtime_log_config_arn", null)

      min_ttl     = lookup(i.value, "min_ttl", null)
      default_ttl = lookup(i.value, "default_ttl", null)
      max_ttl     = lookup(i.value, "max_ttl", null)

      dynamic "forwarded_values" {
        for_each = lookup(i.value, "use_forwarded_values", true) ? [true] : []

        content {
          query_string            = lookup(i.value, "query_string", false)
          query_string_cache_keys = lookup(i.value, "query_string_cache_keys", [])
          headers                 = lookup(i.value, "headers", [])

          cookies {
            forward           = lookup(i.value, "cookies_forward", "none")
            whitelisted_names = lookup(i.value, "cookies_whitelisted_names", null)
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = lookup(i.value, "lambda_function_association", [])
        iterator = l

        content {
          event_type   = l.key
          lambda_arn   = l.value.lambda_arn
          include_body = lookup(l.value, "include_body", null)
        }
      }

      dynamic "function_association" {
        for_each = lookup(i.value, "function_association", [])
        iterator = f

        content {
          event_type   = f.key
          function_arn = f.value.function_arn
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = each.value.ordered_cache_behavior != null ? each.value.ordered_cache_behavior : []
    iterator = i

    content {
      path_pattern           = i.value["path_pattern"]
      target_origin_id       = i.value["target_origin_id"]
      viewer_protocol_policy = i.value["viewer_protocol_policy"]

      allowed_methods           = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods            = lookup(i.value, "cached_methods", ["GET", "HEAD"])
      compress                  = lookup(i.value, "compress", null)
      field_level_encryption_id = lookup(i.value, "field_level_encryption_id", null)
      smooth_streaming          = lookup(i.value, "smooth_streaming", null)
      trusted_signers           = lookup(i.value, "trusted_signers", null)
      trusted_key_groups        = lookup(i.value, "trusted_key_groups", null)

      cache_policy_id            = try(i.value.cache_policy_id, data.aws_cloudfront_cache_policy.this[i.value.cache_policy_name].id, null)
      origin_request_policy_id   = try(i.value.origin_request_policy_id, data.aws_cloudfront_origin_request_policy.this[i.value.origin_request_policy_name].id, null)
      response_headers_policy_id = try(i.value.response_headers_policy_id, data.aws_cloudfront_response_headers_policy.this[i.value.response_headers_policy_name].id, null)

      realtime_log_config_arn = lookup(i.value, "realtime_log_config_arn", null)

      min_ttl     = lookup(i.value, "min_ttl", null)
      default_ttl = lookup(i.value, "default_ttl", null)
      max_ttl     = lookup(i.value, "max_ttl", null)

      dynamic "forwarded_values" {
        for_each = lookup(i.value, "use_forwarded_values", true) ? [true] : []

        content {
          query_string            = lookup(i.value, "query_string", false)
          query_string_cache_keys = lookup(i.value, "query_string_cache_keys", [])
          headers                 = lookup(i.value, "headers", [])

          cookies {
            forward           = lookup(i.value, "cookies_forward", "none")
            whitelisted_names = lookup(i.value, "cookies_whitelisted_names", null)
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = lookup(i.value, "lambda_function_association", [])
        iterator = l

        content {
          event_type   = l.key
          lambda_arn   = l.value.lambda_arn
          include_body = lookup(l.value, "include_body", null)
        }
      }

      dynamic "function_association" {
        for_each = lookup(i.value, "function_association", [])
        iterator = f

        content {
          event_type   = f.key
          function_arn = f.value.function_arn
        }
      }
    }
  }

  /*
  dynamic "viewer_certificate" {
    for_each = each.value.viewer_certificate
    iterator = k

    content {
      acm_certificate_arn            = lookup(k.value, "acm_certificate_arn", [])
      cloudfront_default_certificate = lookup(k.value, "cloudfront_default_certificate", false)
      iam_certificate_id             = lookup(k.value, "iam_certificate_id", null)
      minimum_protocol_version       = lookup(k.value, "minimum_protocol_version", "TLSv1.2_2018")
      ssl_support_method             = lookup(k.value, "ssl_support_method", "sni-only")
    }
  }
*/

  viewer_certificate {
    acm_certificate_arn            = lookup(each.value.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(each.value.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(each.value.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(each.value.viewer_certificate, "minimum_protocol_version", "TLSv1")
    ssl_support_method       = lookup(each.value.viewer_certificate, "ssl_support_method", null)
  }


  dynamic "custom_error_response" {
    for_each = length(each.value.custom_error_response) > 0 ? each.value.custom_error_response : []

    content {
      error_code = custom_error_response.value["error_code"]

      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [each.value.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }
}

data "aws_cloudfront_cache_policy" "this" {
  for_each = toset([for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) : v.cache_policy_name if can(v.cache_policy_name)])

  name = each.key
}

data "aws_cloudfront_origin_request_policy" "this" {
  for_each = toset([for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) : v.origin_request_policy_name if can(v.origin_request_policy_name)])

  name = each.key
}

data "aws_cloudfront_response_headers_policy" "this" {
  for_each = toset([for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) : v.response_headers_policy_name if can(v.response_headers_policy_name)])

  name = each.key
}
