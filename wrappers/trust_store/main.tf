module "wrapper" {
  source = "../../modules/trust_store"

  for_each = var.items

  ca_cert_bucket  = try(each.value.ca_cert_bucket, var.defaults.ca_cert_bucket, null)
  ca_cert_key     = try(each.value.ca_cert_key, var.defaults.ca_cert_key, null)
  ca_cert_region  = try(each.value.ca_cert_region, var.defaults.ca_cert_region, null)
  ca_cert_version = try(each.value.ca_cert_version, var.defaults.ca_cert_version, null)
  create          = try(each.value.create, var.defaults.create, true)
  name            = try(each.value.name, var.defaults.name, null)
  tags            = try(each.value.tags, var.defaults.tags, {})
}
