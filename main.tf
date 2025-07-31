locals {
  create_origin_access_identity = var.create_origin_access_identity && length(keys(var.origin_access_identities)) > 0
  create_origin_access_control  = var.create_origin_access_control && length(keys(var.origin_access_control)) > 0
  create_vpc_origin             = var.create_vpc_origin && length(keys(var.vpc_origin)) > 0
}

resource "aws_cloudfront_origin_access_identity" "this" {
  for_each = local.create_origin_access_identity ? var.origin_access_identities : {}

  comment = each.value

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  for_each = local.create_origin_access_control ? var.origin_access_control : {}

  name = try(each.value.name, null) != null ? each.value.name : each.key

  description                       = each.value["description"]
  origin_access_control_origin_type = each.value["origin_type"]
  signing_behavior                  = each.value["signing_behavior"]
  signing_protocol                  = each.value["signing_protocol"]
}

resource "aws_cloudfront_vpc_origin" "this" {
  for_each = local.create_vpc_origin ? var.vpc_origin : {}

  vpc_origin_endpoint_config {
    name                   = each.value["name"]
    arn                    = each.value["arn"]
    http_port              = each.value["http_port"]
    https_port             = each.value["https_port"]
    origin_protocol_policy = each.value["origin_protocol_policy"]

    origin_ssl_protocols {
      items    = each.value.origin_ssl_protocols.items
      quantity = each.value.origin_ssl_protocols.quantity
    }
  }

  timeouts {
    create = try(var.vpc_origin_timeouts.create, null)
    update = try(var.vpc_origin_timeouts.update, null)
    delete = try(var.vpc_origin_timeouts.delete, null)
  }

  tags = var.tags
}

resource "aws_cloudfront_distribution" "this" {
  count = var.create_distribution ? 1 : 0

  aliases                         = var.aliases
  comment                         = var.comment
  continuous_deployment_policy_id = var.continuous_deployment_policy_id
  default_root_object             = var.default_root_object
  enabled                         = var.enabled
  http_version                    = var.http_version
  is_ipv6_enabled                 = var.is_ipv6_enabled
  price_class                     = var.price_class
  retain_on_delete                = var.retain_on_delete
  staging                         = var.staging
  wait_for_deployment             = var.wait_for_deployment
  web_acl_id                      = var.web_acl_id
  tags                            = var.tags

  dynamic "logging_config" {
    for_each = length(keys(var.logging_config)) == 0 ? [] : [var.logging_config]

    content {
      bucket          = logging_config.value["bucket"]
      prefix          = lookup(logging_config.value, "prefix", null)
      include_cookies = lookup(logging_config.value, "include_cookies", null)
    }
  }

  dynamic "origin" {
    for_each = var.origin

    content {
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }

      domain_name = origin.value.domain_name

      dynamic "custom_header" {
        for_each = origin.value.custom_header

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      origin_access_control_id = origin.value.origin_access_control_id
      origin_id                = coalesce(origin.value.origin_id, origin.key)
      origin_path              = origin.value.origin_path

      dynamic "origin_shield" {
        for_each = origin.value.origin_shield != null ? [origin.value.origin_shield] : []

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config != null ? [origin.value.s3_origin_config] : []

        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }

      dynamic "vpc_origin_config" {
        for_each = origin.value.vpc_origin_config != null ? [origin.value.vpc_origin_config] : []

        content {
          vpc_origin_id = coalesce(vpc_origin_config.value.vpc_origin_id,
          aws_cloudfront_vpc_origin.this[vpc_origin_config.value.vpc_origin].id)
          origin_keepalive_timeout = vpc_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = vpc_origin_config.value.origin_read_timeout
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_group

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

  default_cache_behavior {
    allowed_methods = var.default_cache_behavior.allowed_methods
    cached_methods  = var.default_cache_behavior.cached_methods
    cache_policy_id = try(
      data.aws_cloudfront_cache_policy.this[var.default_cache_behavior.cache_policy_name].id,
      var.default_cache_behavior.cache_policy_id
    )
    compress                  = var.default_cache_behavior.compress
    default_ttl               = var.default_cache_behavior.default_ttl
    field_level_encryption_id = var.default_cache_behavior.field_level_encryption_id

    dynamic "forwarded_values" {
      for_each = var.default_cache_behavior.forwarded_values != null ? [var.default_cache_behavior.forwarded_values] : []

      content {
        cookies {
          forward           = forwarded_values.value.cookies.forward
          whitelisted_names = forwarded_values.value.cookies.whitelisted_names
        }
        headers                 = forwarded_values.value.headers
        query_string            = forwarded_values.value.query_string
        query_string_cache_keys = forwarded_values.value.query_string_cache_keys
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_association

      content {
        event_type   = lambda_function_association.key
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }

    dynamic "function_association" {
      for_each = var.default_cache_behavior.function_association

      content {
        event_type   = function_association.key
        function_arn = function_association.value.function_arn
      }
    }

    max_ttl = var.default_cache_behavior.max_ttl
    min_ttl = var.default_cache_behavior.min_ttl
    origin_request_policy_id = try(
      data.aws_cloudfront_origin_request_policy.this[var.default_cache_behavior.origin_request_policy_name].id,
      var.default_cache_behavior.origin_request_policy_id
    )
    realtime_log_config_arn = var.default_cache_behavior.realtime_log_config_arn
    response_headers_policy_id = try(
      data.aws_cloudfront_response_headers_policy.this[var.default_cache_behavior.response_headers_policy_name].id,
      var.default_cache_behavior.response_headers_policy_id
    )
    smooth_streaming       = var.default_cache_behavior.smooth_streaming
    target_origin_id       = var.default_cache_behavior.target_origin_id
    trusted_key_groups     = var.default_cache_behavior.trusted_key_groups
    trusted_signers        = var.default_cache_behavior.trusted_signers
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy

    dynamic "grpc_config" {
      for_each = var.default_cache_behavior.grpc_config != null ? [var.default_cache_behavior.grpc_config] : []

      content {
        enabled = grpc_config.value.enabled
      }
    }
  }


  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    iterator = i

    content {
      allowed_methods = i.value.allowed_methods
      cached_methods  = i.value.cached_methods
      cache_policy_id = try(
        data.aws_cloudfront_cache_policy.this[i.value.cache_policy_name].id,
        i.value.cache_policy_id
      )
      compress                  = i.value.compress
      default_ttl               = i.value.default_ttl
      field_level_encryption_id = i.value.field_level_encryption_id

      dynamic "forwarded_values" {
        for_each = i.value.forwarded_values != null ? [i.value.forwarded_values] : []

        content {
          cookies {
            forward           = i.value.cookies_forward
            whitelisted_names = i.value.cookies_whitelisted_names
          }
          headers                 = i.value.headers
          query_string            = i.value.query_string
          query_string_cache_keys = i.value.query_string_cache_keys
        }
      }

      dynamic "lambda_function_association" {
        for_each = i.value.lambda_function_association
        iterator = l

        content {
          event_type   = l.key
          lambda_arn   = l.value.lambda_arn
          include_body = l.value.include_body
        }
      }

      dynamic "function_association" {
        for_each = i.value.function_association
        iterator = f

        content {
          event_type   = f.key
          function_arn = f.value.function_arn
        }
      }

      max_ttl = i.value.max_ttl
      min_ttl = i.value.min_ttl
      origin_request_policy_id = try(
        data.aws_cloudfront_origin_request_policy.this[i.value.origin_request_policy_name].id,
        i.value.origin_request_policy_id
      )
      path_pattern            = i.value.path_pattern
      realtime_log_config_arn = i.value.realtime_log_config_arn
      response_headers_policy_id = try(
        data.aws_cloudfront_response_headers_policy.this[i.value.response_headers_policy_name].id,
        i.value.response_headers_policy_id
      )
      smooth_streaming       = i.value.smooth_streaming
      target_origin_id       = i.value.target_origin_id
      trusted_key_groups     = i.value.trusted_key_groups
      trusted_signers        = i.value.trusted_signers
      viewer_protocol_policy = i.value.viewer_protocol_policy

      dynamic "grpc_config" {
        for_each = i.value.grpc_config != null ? [i.value.grpc_config] : []

        content {
          enabled = grpc_config.value.enabled
        }
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }

  dynamic "custom_error_response" {
    for_each = length(
      flatten([var.custom_error_response])[0]) > 0 ? flatten([var.custom_error_response]
    ) : []

    content {
      error_code = custom_error_response.value["error_code"]

      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }
}

resource "aws_cloudfront_monitoring_subscription" "this" {
  count = var.create_distribution && var.create_monitoring_subscription ? 1 : 0

  distribution_id = aws_cloudfront_distribution.this[0].id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.realtime_metrics_subscription_status
    }
  }
}

data "aws_cloudfront_cache_policy" "this" {
  for_each = toset([
    for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) :
    v.cache_policy_name if can(v.cache_policy_name)
  ])

  name = each.key
}

data "aws_cloudfront_origin_request_policy" "this" {
  for_each = toset([
    for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) :
    v.origin_request_policy_name if can(v.origin_request_policy_name)
  ])

  name = each.key
}

data "aws_cloudfront_response_headers_policy" "this" {
  for_each = toset([
    for v in concat([var.default_cache_behavior], var.ordered_cache_behavior) :
    v.response_headers_policy_name if can(v.response_headers_policy_name)
  ])

  name = each.key
}
