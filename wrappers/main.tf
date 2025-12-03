module "wrapper" {
  source = "../"

  for_each = var.items

  aliases                         = try(each.value.aliases, var.defaults.aliases, null)
  anycast_ip_list_id              = try(each.value.anycast_ip_list_id, var.defaults.anycast_ip_list_id, null)
  cloudfront_functions            = try(each.value.cloudfront_functions, var.defaults.cloudfront_functions, null)
  comment                         = try(each.value.comment, var.defaults.comment, null)
  continuous_deployment_policy_id = try(each.value.continuous_deployment_policy_id, var.defaults.continuous_deployment_policy_id, null)
  create                          = try(each.value.create, var.defaults.create, true)
  create_monitoring_subscription  = try(each.value.create_monitoring_subscription, var.defaults.create_monitoring_subscription, false)
  custom_error_response           = try(each.value.custom_error_response, var.defaults.custom_error_response, null)
  default_cache_behavior          = try(each.value.default_cache_behavior, var.defaults.default_cache_behavior)
  default_root_object             = try(each.value.default_root_object, var.defaults.default_root_object, null)
  enabled                         = try(each.value.enabled, var.defaults.enabled, true)
  http_version                    = try(each.value.http_version, var.defaults.http_version, "http2")
  is_ipv6_enabled                 = try(each.value.is_ipv6_enabled, var.defaults.is_ipv6_enabled, true)
  logging_config                  = try(each.value.logging_config, var.defaults.logging_config, null)
  ordered_cache_behavior          = try(each.value.ordered_cache_behavior, var.defaults.ordered_cache_behavior, [])
  origin                          = try(each.value.origin, var.defaults.origin, {})
  origin_access_control = try(each.value.origin_access_control, var.defaults.origin_access_control, {
    s3 = {
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  })
  origin_group                         = try(each.value.origin_group, var.defaults.origin_group, null)
  price_class                          = try(each.value.price_class, var.defaults.price_class, null)
  realtime_metrics_subscription_status = try(each.value.realtime_metrics_subscription_status, var.defaults.realtime_metrics_subscription_status, "Enabled")
  response_headers_policies            = try(each.value.response_headers_policies, var.defaults.response_headers_policies, null)
  restrictions = try(each.value.restrictions, var.defaults.restrictions, {
    geo_restriction = {
      restriction_type = "none"
    }
  })
  retain_on_delete    = try(each.value.retain_on_delete, var.defaults.retain_on_delete, null)
  staging             = try(each.value.staging, var.defaults.staging, null)
  tags                = try(each.value.tags, var.defaults.tags, {})
  viewer_certificate  = try(each.value.viewer_certificate, var.defaults.viewer_certificate, {})
  vpc_origin          = try(each.value.vpc_origin, var.defaults.vpc_origin, null)
  wait_for_deployment = try(each.value.wait_for_deployment, var.defaults.wait_for_deployment, null)
  web_acl_id          = try(each.value.web_acl_id, var.defaults.web_acl_id, null)
}
