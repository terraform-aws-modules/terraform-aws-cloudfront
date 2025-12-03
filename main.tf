################################################################################
# Distribution
################################################################################

resource "aws_cloudfront_distribution" "this" {
  count = var.create ? 1 : 0

  aliases                         = var.aliases
  anycast_ip_list_id              = var.anycast_ip_list_id
  comment                         = var.comment
  continuous_deployment_policy_id = var.continuous_deployment_policy_id

  dynamic "custom_error_response" {
    for_each = var.custom_error_response != null ? var.custom_error_response : []

    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]

    content {
      allowed_methods           = default_cache_behavior.value.allowed_methods
      cache_policy_id           = try(coalesce(default_cache_behavior.value.cache_policy_id, try(data.aws_cloudfront_cache_policy.this[default_cache_behavior.value.cache_policy_name].id, null)), null)
      cached_methods            = default_cache_behavior.value.cached_methods
      compress                  = default_cache_behavior.value.compress
      default_ttl               = default_cache_behavior.value.default_ttl
      field_level_encryption_id = default_cache_behavior.value.field_level_encryption_id

      dynamic "forwarded_values" {
        # If a cache policy is specified, then `forwarded_values` must not be set
        for_each = default_cache_behavior.value.cache_policy_id == null && default_cache_behavior.value.cache_policy_name == null && default_cache_behavior.value.forwarded_values != null ? [default_cache_behavior.value.forwarded_values] : []

        content {
          dynamic "cookies" {
            for_each = [forwarded_values.value.cookies]

            content {
              forward           = cookies.value.forward
              whitelisted_names = cookies.value.whitelisted_names
            }
          }

          headers                 = forwarded_values.value.headers
          query_string            = forwarded_values.value.query_string
          query_string_cache_keys = forwarded_values.value.query_string_cache_keys
        }
      }

      dynamic "function_association" {
        for_each = default_cache_behavior.value.function_association != null ? default_cache_behavior.value.function_association : {}

        content {
          event_type   = try(coalesce(function_association.value.event_type, function_association.key))
          function_arn = try(coalesce(function_association.value.function_arn, try(aws_cloudfront_function.this[function_association.value.function_key].arn, null)), null)
        }
      }

      dynamic "grpc_config" {
        for_each = default_cache_behavior.value.grpc_config != null ? [default_cache_behavior.value.grpc_config] : []

        content {
          enabled = grpc_config.value.enabled
        }
      }

      dynamic "lambda_function_association" {
        for_each = default_cache_behavior.value.lambda_function_association != null ? default_cache_behavior.value.lambda_function_association : {}

        content {
          event_type   = try(coalesce(lambda_function_association.value.event_type, lambda_function_association.key))
          include_body = lambda_function_association.value.include_body
          lambda_arn   = lambda_function_association.value.lambda_arn
        }
      }

      max_ttl                    = default_cache_behavior.value.max_ttl
      min_ttl                    = default_cache_behavior.value.min_ttl
      origin_request_policy_id   = try(coalesce(default_cache_behavior.value.origin_request_policy_id, try(data.aws_cloudfront_origin_request_policy.this[default_cache_behavior.value.origin_request_policy_name].id, null)), null)
      realtime_log_config_arn    = default_cache_behavior.value.realtime_log_config_arn
      response_headers_policy_id = try(coalesce(default_cache_behavior.value.response_headers_policy_id, try(data.aws_cloudfront_response_headers_policy.this[default_cache_behavior.value.response_headers_policy_name].id, null)), null)
      smooth_streaming           = default_cache_behavior.value.smooth_streaming
      target_origin_id           = default_cache_behavior.value.target_origin_id
      trusted_key_groups         = default_cache_behavior.value.trusted_key_groups
      trusted_signers            = default_cache_behavior.value.trusted_signers
      viewer_protocol_policy     = default_cache_behavior.value.viewer_protocol_policy
    }
  }

  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []

    content {
      bucket          = logging_config.value.bucket
      include_cookies = logging_config.value.include_cookies
      prefix          = logging_config.value.prefix
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = length(var.ordered_cache_behavior) > 0 ? var.ordered_cache_behavior : []

    content {
      allowed_methods           = ordered_cache_behavior.value.allowed_methods
      cached_methods            = ordered_cache_behavior.value.cached_methods
      cache_policy_id           = try(coalesce(ordered_cache_behavior.value.cache_policy_id, try(data.aws_cloudfront_cache_policy.this[ordered_cache_behavior.value.cache_policy_name].id, null)), null)
      compress                  = ordered_cache_behavior.value.compress
      default_ttl               = ordered_cache_behavior.value.default_ttl
      field_level_encryption_id = ordered_cache_behavior.value.field_level_encryption_id

      dynamic "forwarded_values" {
        # If a cache policy is specified, then `forwarded_values` must not be set
        for_each = ordered_cache_behavior.value.cache_policy_id == null && ordered_cache_behavior.value.cache_policy_name == null && ordered_cache_behavior.value.forwarded_values != null ? [ordered_cache_behavior.value.forwarded_values] : []

        content {
          dynamic "cookies" {
            for_each = [forwarded_values.value.cookies]

            content {
              forward           = cookies.value.forward
              whitelisted_names = cookies.value.whitelisted_names
            }
          }

          headers                 = forwarded_values.value.headers
          query_string            = forwarded_values.value.query_string
          query_string_cache_keys = forwarded_values.value.query_string_cache_keys
        }
      }

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_association != null ? ordered_cache_behavior.value.function_association : {}

        content {
          event_type   = try(coalesce(function_association.value.event_type, function_association.key))
          function_arn = try(coalesce(function_association.value.function_arn, try(aws_cloudfront_function.this[function_association.value.function_key].arn, null)), null)
        }
      }

      dynamic "grpc_config" {
        for_each = ordered_cache_behavior.value.grpc_config != null ? [ordered_cache_behavior.value.grpc_config] : []

        content {
          enabled = grpc_config.value.enabled
        }
      }

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_association != null ? ordered_cache_behavior.value.lambda_function_association : {}

        content {
          event_type   = try(coalesce(lambda_function_association.value.event_type, lambda_function_association.key))
          include_body = lambda_function_association.value.include_body
          lambda_arn   = lambda_function_association.value.lambda_arn
        }
      }

      max_ttl                    = ordered_cache_behavior.value.max_ttl
      min_ttl                    = ordered_cache_behavior.value.min_ttl
      origin_request_policy_id   = try(coalesce(ordered_cache_behavior.value.origin_request_policy_id, try(data.aws_cloudfront_origin_request_policy.this[ordered_cache_behavior.value.origin_request_policy_name].id, null)), null)
      path_pattern               = ordered_cache_behavior.value.path_pattern
      realtime_log_config_arn    = ordered_cache_behavior.value.realtime_log_config_arn
      response_headers_policy_id = try(coalesce(ordered_cache_behavior.value.response_headers_policy_id, try(data.aws_cloudfront_response_headers_policy.this[ordered_cache_behavior.value.response_headers_policy_name].id, null)), null)
      smooth_streaming           = ordered_cache_behavior.value.smooth_streaming
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      trusted_key_groups         = ordered_cache_behavior.value.trusted_key_groups
      trusted_signers            = ordered_cache_behavior.value.trusted_signers
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_group != null ? var.origin_group : {}

    content {
      dynamic "failover_criteria" {
        for_each = [origin_group.value.failover_criteria]

        content {
          status_codes = failover_criteria.value.status_codes
        }
      }

      dynamic "member" {
        for_each = origin_group.value.member

        content {
          origin_id = member.value.origin_id
        }
      }

      origin_id = try(coalesce(origin_group.value.origin_id, origin_group.key))
    }
  }

  dynamic "origin" {
    for_each = var.origin

    content {
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout

      dynamic "custom_header" {
        for_each = origin.value.custom_header != null ? origin.value.custom_header : {}

        content {
          name  = custom_header.key
          value = custom_header.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          ip_address_type          = custom_origin_config.value.ip_address_type
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
        }
      }

      domain_name              = origin.value.domain_name
      origin_access_control_id = try(coalesce(origin.value.origin_access_control_id, try(aws_cloudfront_origin_access_control.this[origin.value.origin_access_control_key].id, null)), null)
      origin_id                = try(coalesce(origin.value.origin_id, origin.key))
      origin_path              = origin.value.origin_path

      dynamic "origin_shield" {
        for_each = origin.value.origin_shield != null ? [origin.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }

      response_completion_timeout = origin.value.response_completion_timeout

      dynamic "vpc_origin_config" {
        for_each = origin.value.vpc_origin_config != null ? [origin.value.vpc_origin_config] : []

        content {
          origin_keepalive_timeout = vpc_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = vpc_origin_config.value.origin_read_timeout
          vpc_origin_id            = try(coalesce(vpc_origin_config.value.vpc_origin_id, try(aws_cloudfront_vpc_origin.this[vpc_origin_config.value.vpc_origin_key].id, null)), null)
        }
      }
    }
  }

  price_class = var.price_class

  dynamic "restrictions" {
    for_each = [var.restrictions]

    content {
      dynamic "geo_restriction" {
        for_each = [restrictions.value.geo_restriction]

        content {
          restriction_type = geo_restriction.value.restriction_type
          locations        = geo_restriction.value.locations
        }
      }
    }
  }

  retain_on_delete = var.retain_on_delete
  staging          = var.staging

  dynamic "viewer_certificate" {
    for_each = [var.viewer_certificate]

    content {
      acm_certificate_arn            = viewer_certificate.value.acm_certificate_arn
      cloudfront_default_certificate = viewer_certificate.value.cloudfront_default_certificate
      iam_certificate_id             = viewer_certificate.value.iam_certificate_id
      minimum_protocol_version       = viewer_certificate.value.minimum_protocol_version
      ssl_support_method             = viewer_certificate.value.ssl_support_method
    }
  }

  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id
  tags                = var.tags

  depends_on = [
    aws_cloudfront_function.this
  ]
}

################################################################################
# Origin Access Control
################################################################################

resource "aws_cloudfront_origin_access_control" "this" {
  for_each = var.origin_access_control != null ? var.origin_access_control : {}

  description                       = try(coalesce(each.value.description, "Origin Access Control for ${try(coalesce(each.value.name, each.key))}"))
  name                              = try(coalesce(each.value.name, each.key))
  origin_access_control_origin_type = each.value.origin_type
  signing_behavior                  = each.value.signing_behavior
  signing_protocol                  = each.value.signing_protocol
}

################################################################################
# VPC Origin
################################################################################

resource "aws_cloudfront_vpc_origin" "this" {
  for_each = var.vpc_origin != null ? var.vpc_origin : {}

  vpc_origin_endpoint_config {
    arn                    = each.value.arn
    http_port              = each.value.http_port
    https_port             = each.value.https_port
    name                   = try(coalesce(each.value.name, each.key))
    origin_protocol_policy = each.value.origin_protocol_policy
    dynamic "origin_ssl_protocols" {
      for_each = each.value.origin_ssl_protocols != null ? [each.value.origin_ssl_protocols] : []

      content {
        items    = origin_ssl_protocols.value.items
        quantity = origin_ssl_protocols.value.quantity
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = merge(
    var.tags,
    each.value.tags,
  )
}

################################################################################
# Response Headers Policy
################################################################################

resource "aws_cloudfront_response_headers_policy" "this" {
  for_each = var.response_headers_policies != null ? var.response_headers_policies : {}

  name    = try(coalesce(each.value.name, each.key))
  comment = each.value.comment

  dynamic "cors_config" {
    for_each = each.value.cors_config != null ? [each.value.cors_config] : []

    content {
      access_control_allow_credentials = cors_config.value.access_control_allow_credentials
      origin_override                  = cors_config.value.origin_override
      access_control_max_age_sec       = cors_config.value.access_control_max_age_sec

      access_control_allow_headers {
        items = cors_config.value.access_control_allow_headers.items
      }

      access_control_allow_methods {
        items = cors_config.value.access_control_allow_methods.items
      }

      access_control_allow_origins {
        items = cors_config.value.access_control_allow_origins.items
      }

      dynamic "access_control_expose_headers" {
        for_each = cors_config.value.access_control_expose_headers != null ? [cors_config.value.access_control_expose_headers] : []

        content {
          items = access_control_expose_headers.value.items
        }
      }
    }
  }

  dynamic "custom_headers_config" {
    for_each = each.value.custom_headers_config != null ? [each.value.custom_headers_config] : []

    content {
      dynamic "items" {
        for_each = custom_headers_config.value.items

        content {
          header   = items.value.header
          override = items.value.override
          value    = items.value.value
        }
      }
    }
  }

  dynamic "remove_headers_config" {
    for_each = each.value.remove_headers_config != null ? [each.value.remove_headers_config] : []

    content {
      dynamic "items" {
        for_each = remove_headers_config.value.items

        content {
          header = items.value.header
        }
      }
    }
  }

  dynamic "security_headers_config" {
    for_each = each.value.security_headers_config != null ? [each.value.security_headers_config] : []

    content {
      dynamic "content_security_policy" {
        for_each = security_headers_config.value.content_security_policy != null ? [security_headers_config.value.content_security_policy] : []

        content {
          content_security_policy = content_security_policy.value.content_security_policy
          override                = content_security_policy.value.override
        }
      }

      dynamic "content_type_options" {
        for_each = security_headers_config.value.content_type_options != null ? [security_headers_config.value.content_type_options] : []

        content {
          override = content_type_options.value.override
        }
      }

      dynamic "frame_options" {
        for_each = security_headers_config.value.frame_options != null ? [security_headers_config.value.frame_options] : []

        content {
          frame_option = frame_options.value.frame_option
          override     = frame_options.value.override
        }
      }

      dynamic "referrer_policy" {
        for_each = security_headers_config.value.referrer_policy != null ? [security_headers_config.value.referrer_policy] : []

        content {
          referrer_policy = referrer_policy.value.referrer_policy
          override        = referrer_policy.value.override
        }
      }

      dynamic "strict_transport_security" {
        for_each = security_headers_config.value.strict_transport_security != null ? [security_headers_config.value.strict_transport_security] : []

        content {
          access_control_max_age_sec = strict_transport_security.value.access_control_max_age_sec
          override                   = strict_transport_security.value.override
          include_subdomains         = strict_transport_security.value.include_subdomains
          preload                    = strict_transport_security.value.preload
        }
      }

      dynamic "xss_protection" {
        for_each = security_headers_config.value.xss_protection != null ? [security_headers_config.value.xss_protection] : []

        content {
          mode_block = xss_protection.value.mode_block
          override   = xss_protection.value.override
          protection = xss_protection.value.protection
          report_uri = xss_protection.value.report_uri
        }
      }
    }
  }

  dynamic "server_timing_headers_config" {
    for_each = each.value.server_timing_headers_config != null ? [each.value.server_timing_headers_config] : []

    content {
      enabled       = server_timing_headers_config.value.enabled
      sampling_rate = server_timing_headers_config.value.sampling_rate
    }
  }
}

################################################################################
# Function(s)
################################################################################

resource "aws_cloudfront_function" "this" {
  for_each = var.cloudfront_functions != null ? var.cloudfront_functions : {}

  code                         = each.value.code
  comment                      = each.value.comment
  key_value_store_associations = each.value.key_value_store_associations
  name                         = try(coalesce(each.value.name, each.key))
  publish                      = each.value.publish
  runtime                      = each.value.runtime
}

################################################################################
# Monitoring Subscription
################################################################################

resource "aws_cloudfront_monitoring_subscription" "this" {
  count = var.create && var.create_monitoring_subscription ? 1 : 0

  distribution_id = aws_cloudfront_distribution.this[0].id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.realtime_metrics_subscription_status
    }
  }
}

################################################################################
# Data source reverse lookup by name
# These are used to refer to resources by name instead of ID
################################################################################

locals {
  cache_behaviors = concat([var.default_cache_behavior], var.ordered_cache_behavior)
}

data "aws_cloudfront_cache_policy" "this" {
  for_each = toset([for v in local.cache_behaviors : v.cache_policy_name if v.cache_policy_name != null])

  name = each.key
}

data "aws_cloudfront_origin_request_policy" "this" {
  for_each = toset([for v in local.cache_behaviors : v.origin_request_policy_name if v.origin_request_policy_name != null])

  name = each.key
}

data "aws_cloudfront_response_headers_policy" "this" {
  for_each = toset([for v in local.cache_behaviors : v.response_headers_policy_name if v.response_headers_policy_name != null])

  name = each.key
}
