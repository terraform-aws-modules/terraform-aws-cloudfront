# Upgrade from v5.x to v6.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/tree/master/examples) directory:
If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- AWS provider `v6.0` is now minimum supported version
- Support for `aws_cloudfront_origin_access_identity` has been removed in favor of `aws_cloudfront_origin_access_control`

## Additional changes

### Added

- Support for `region` parameter to specify the AWS region for the resources created if different from the provider region.

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type.

### Variable and output changes

1. Removed variables:

    - `create_origin_access_identity`
    - `origin_access_identities`

2. Renamed variables:

    -

3. Added variables:

    -

4. Removed outputs:

    - `cloudfront_vpc_origin_ids`
    - `cloudfront_origin_access_controls_ids`
    - `cloudfront_origin_access_identities`
    - `cloudfront_origin_access_identity_ids`
    - `cloudfront_origin_access_identity_iam_arns`
    - `cloudfront_distribution_tags`

5. Renamed outputs:

    -

6. Added outputs:

    - `cloudfront_vpc_origins`

## Upgrade Migrations

### Before 5.x Example

```hcl
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws/"
  version = "~> 5.0"

  # Truncated for brevity ...

}
```

### After 6.x Example

```hcl
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws/"
  version = "~> 6.0"

  # Truncated for brevity ...

}
```

### State Changes

TBD
