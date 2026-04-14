# Example: Policy IDs with newly created CloudFront Functions

This example demonstrates using `enable_policy_name_data_sources = false` to avoid a
plan-time `"Invalid for_each argument"` error when:

1. All cache behaviors reference CloudFront policies by **ID** (not by name), and
2. One or more `aws_cloudfront_function` resources are **created in the same plan** as
   the distribution, so their ARNs are `(known after apply)`.

## The problem

When any behavior in `ordered_cache_behavior` includes a `function_association` whose
`function_arn` is unknown at plan time, Terraform treats the **entire behavior object**
as partially unknown. The module's policy-name data sources iterate over
`local.cache_behaviors` (which includes those behaviors), causing:

```
Error: Invalid for_each argument

  on .terraform/modules/cloudfront/main.tf line 542:
  542:   for_each = toset([for v in local.cache_behaviors : v.cache_policy_name if v.cache_policy_name != null])

The "for_each" set includes values derived from resource attributes that cannot be
determined until apply, and so Terraform cannot determine the full set of keys that
will identify the instances of this resource.
```

This error occurs even when **no** behavior sets a `*_policy_name` field.

## The fix

Set `enable_policy_name_data_sources = false`. This makes the three policy data sources
use `for_each = toset([])` (empty), so Terraform does not walk `local.cache_behaviors`
for them at plan time. Since all policies are referenced by ID, the `try(coalesce(...), null)`
calls in the distribution resource still resolve correctly.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
