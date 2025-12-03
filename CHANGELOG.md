# Changelog

All notable changes to this project will be documented in this file.

## [6.0.2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v6.0.1...v6.0.2) (2025-12-03)

### Bug Fixes

* Change default value for `ordered_cache_behavior` to empty list to avoid type checking acrobatics and type mis-matches ([#183](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/183)) ([5427273](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/54272736d43f6a946e0af07eda9475a4587bc588))

## [6.0.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v6.0.0...v6.0.1) (2025-12-01)

### Bug Fixes

* Avoid adding a `null` value to `concat()` function for cache behaviors local variable ([#179](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/179)) ([dd9a7a6](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/dd9a7a6051db365e437cd2eb8b25b77348427cdd))

## [6.0.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v5.2.0...v6.0.0) (2025-11-29)

### ⚠ BREAKING CHANGES

* Upgrade MSV of AWS provider to `6.20`, remove support for origin access identities (#177)

### Features

* Upgrade MSV of AWS provider to `6.20`, remove support for origin access identities ([#177](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/177)) ([5896259](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/5896259f75eba82d3b2465e7530b3ab23f0cd181))

## [5.2.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v5.1.0...v5.2.0) (2025-11-27)

### Features

* Cloudfront function support ([#175](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/175)) ([812763b](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/812763b5e547595cd3717e7ce8c94e0099f06552))

## [5.1.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v5.0.1...v5.1.0) (2025-11-27)

### Features

* Add cloudfront response header policy support ([#174](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/174)) ([8488553](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/8488553852495e4fe5b8b10574d454149a735c31))

## [5.0.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v5.0.0...v5.0.1) (2025-10-21)

### Bug Fixes

* Update CI workflow versions to latest ([#172](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/172)) ([7f42384](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/7f42384fc445a8f56a966b1c3cb396c8a970bc1b))

## [5.0.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v4.2.0...v5.0.0) (2025-07-06)


### ⚠ BREAKING CHANGES

* Support specifying name for OAC and Terraform MSV 1.5.7 (#166)

### Features

* Support specifying name for OAC and Terraform MSV 1.5.7 ([#166](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/166)) ([736ce3b](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/736ce3bbf7e731b35c3b36d354f238fe112df2ed))

## [4.2.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v4.1.0...v4.2.0) (2025-06-27)


### Features

* Add timeouts block for vpc origin resource ([#165](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/165)) ([dac9b8a](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/dac9b8a592afb7219a253c8d9faab6d37e81de6f))

## [4.1.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v4.0.0...v4.1.0) (2025-01-21)


### Features

* Support `grpc_config` in `default_cache_behavior` and `ordered_cache_behavior` ([#155](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/155)) ([7f176ff](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/7f176ff39790083a418a8e5921ba3088baf56e3e))

## [4.0.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.4.1...v4.0.0) (2024-12-22)


### ⚠ BREAKING CHANGES

* Bump AWS provider version to 5.82, added VPC Origin support (#153)

### Features

* Bump AWS provider version to 5.82, added VPC Origin support ([#153](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/153)) ([9ff6c63](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/9ff6c63ab665709aaef8e0429ed00b2bea06af31))

## [3.4.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.4.0...v3.4.1) (2024-10-11)


### Bug Fixes

* Update CI workflow versions to latest ([#149](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/149)) ([b2f4809](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/b2f48097c5ae05df807eb1d750ec42e5d872ea52))

## [3.4.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.3.2...v3.4.0) (2024-03-15)


### Features

* Allow all policies to be specified by name or ID ([#134](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/134)) ([fcd12c3](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/fcd12c3fee578b8a0c2b796c00b5cbda782819c2))

## [3.3.2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.3.1...v3.3.2) (2024-03-07)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#133](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/133)) ([6af330d](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/6af330d69b927a1ddf4ddefd0183b82a756d80a2))

### [3.3.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.3.0...v3.3.1) (2024-03-04)


### Bug Fixes

* Fix provider version for `staging` and `continuous_deployment_policy_id` params ([#132](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/132)) ([334f2f7](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/334f2f7f41e20f8532f0e609e7286b87f31a5f6d))

## [3.3.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.2.2...v3.3.0) (2024-03-01)


### Features

* Added support for Staging Distribution ([#130](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/130)) ([601df49](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/601df4903d11e8bff2c907a9c8ce711ccb43a05c))

### [3.2.2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.2.1...v3.2.2) (2024-02-09)


### Bug Fixes

* Fixed logging in the example code ([#129](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/129)) ([0ac8cd1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/0ac8cd177b0ce1191799a6d258cbda2d2b047551))

### [3.2.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.2.0...v3.2.1) (2023-03-10)


### Bug Fixes

* Fixed possible values for http_version input ([#106](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/106)) ([de6ffe3](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/de6ffe36dba1ccbec0a84542eb84273e7c8b1c25))

## [3.2.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.1.0...v3.2.0) (2023-01-27)


### Features

* Added Origin Access Control (OAC) ([#97](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/97)) ([c76dad4](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/c76dad42cbb5abfc2370f06431e8899ac8077cd0))

## [3.1.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.0.3...v3.1.0) (2022-11-26)


### Features

* Replace hardcoded cloudfront canonical user ID in example ([#96](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/96)) ([2b22eb5](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/2b22eb5cd6c00ca9551392d7cbf79a62d3b06b5a))

### [3.0.3](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.0.2...v3.0.3) (2022-11-14)


### Bug Fixes

* Fixed bug when custom_error_response is empty ([#91](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/91)) ([ce35c50](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/ce35c50d47b1f491c10661bd140318b7b5a6e134))

### [3.0.2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.0.1...v3.0.2) (2022-11-14)


### Bug Fixes

* Updated handling of one or many custom_error_response values ([#89](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/89)) ([0945c77](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/0945c773106ba60c5ada5818728d407e5613c3ae))

### [3.0.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v3.0.0...v3.0.1) (2022-10-27)


### Bug Fixes

* Update CI configuration files to use latest version ([#84](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/84)) ([035ea6c](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/035ea6c5817b70bf2e544664ca500d0a2210cf39))

## [3.0.0](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.9.3...v3.0.0) (2022-09-12)


### ⚠ BREAKING CHANGES

* Added support for origin_access_control_id, bumped AWS provider version (#79)

### Features

* Added support for origin_access_control_id, bumped AWS provider version ([#79](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/79)) ([403ca24](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/403ca2446e2711307268d62bdac24f8691be3faa))

### [2.9.3](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.9.2...v2.9.3) (2022-03-18)


### Bug Fixes

* Added outputs of tags of distribution ([#70](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/70)) ([bc945b4](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/bc945b492078c4bb6776fb3afcde5fa1c09a53fd))

### [2.9.2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.9.1...v2.9.2) (2022-01-14)


### Bug Fixes

* Add lifecycle clause for aws_cloudfront_origin_access_identity ([#65](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/65)) ([d31306d](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/d31306d96caf66ae88f651425921175132f0322f))

## [2.9.1](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.9.0...v2.9.1) (2021-11-22)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#59](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/59)) ([507c1ba](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/commit/507c1ba4cc40420b765cc0110651242f68514821))

<a name="v2.9.0"></a>
## [v2.9.0] - 2021-11-09

- feat: Added support for response headers policy ([#57](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/57))


<a name="v2.8.0"></a>
## [v2.8.0] - 2021-10-12

- Updated CHANGELOG
- feat: Add support for additional CloudFront metrics ([#54](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/54))
- docs: Add TLSv1.1 and TLSv1.2 for origin_ssl_protocols in examples ([#51](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/51))


<a name="v2.7.0"></a>
## [v2.7.0] - 2021-08-13

- Updated CHANGELOG
- feat: Added support for connection_attempts, connection_timeout, and origin_shield ([#47](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/47))


<a name="v2.6.0"></a>
## [v2.6.0] - 2021-06-28

- Updated CHANGELOG
- feat: Add support of realtime_log_config_arn (no creation) ([#31](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/31))


<a name="v2.5.0"></a>
## [v2.5.0] - 2021-05-28

- Updated CHANGELOG
- feat: Support for CloudFront Functions ([#41](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/41))


<a name="v2.4.0"></a>
## [v2.4.0] - 2021-05-07

- Updated CHANGELOG
- fix: Use empty list for headers by default instead of null ([#39](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/39))


<a name="v2.3.0"></a>
## [v2.3.0] - 2021-05-05

- Updated CHANGELOG
- fix: Use empty origin_path by default ([#38](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/38))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#36](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/36))


<a name="v2.2.0"></a>
## [v2.2.0] - 2021-04-30

- Updated CHANGELOG
- feat: Adding support for trusted_key_groups in ordered_cache_behavior ([#35](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/35))


<a name="v2.1.0"></a>
## [v2.1.0] - 2021-04-27

- Updated CHANGELOG
- feat: added support of trusted_key_groups ([#33](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/33))


<a name="v2.0.0"></a>
## [v2.0.0] - 2021-04-26

- Updated CHANGELOG
- feat: Shorten outputs (removing this_) ([#34](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/34))
- chore: update CI/CD workflow for terraform_docs workflow ([#32](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/32))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#27](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/27))


<a name="v1.9.0"></a>
## [v1.9.0] - 2021-03-22

- Updated CHANGELOG
- fix: Fixed type of ordered_cache_behavior ([#26](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/26))
- chore: align ci-cd static checks to use individual minimum Terraform versions ([#24](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/24))


<a name="v1.8.0"></a>
## [v1.8.0] - 2021-03-02

- Updated CHANGELOG
- fix: Removing forwarded_values if cache_policy_id exists ([#21](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/21))


<a name="v1.7.0"></a>
## [v1.7.0] - 2021-03-01

- Updated CHANGELOG
- fix: Update syntax for Terraform 0.15 ([#23](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/23))
- feat: Updated minimum required version of Terraform to 0.13 ([#19](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/19))
- chore: add ci-cd workflow for pre-commit checks ([#18](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/18))


<a name="v1.6.0"></a>
## [v1.6.0] - 2021-02-22

- Updated CHANGELOG
- feat: add origin_request_policy_id & cache_policy_id to caching ([#17](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/17))


<a name="v1.5.0"></a>
## [v1.5.0] - 2021-01-14

- Updated CHANGELOG
- Updated README (after [#12](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/12))
- fix: preserve ordering of cache behaviors ([#12](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/12))


<a name="v1.4.0"></a>
## [v1.4.0] - 2020-12-08

- Updated CHANGELOG
- fix: Fixed viewer_certificate variable ([#9](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/9))


<a name="v1.3.0"></a>
## [v1.3.0] - 2020-12-04

- Updated CHANGELOG
- refactor: change origin access identity output types ([#6](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/6))


<a name="v1.2.0"></a>
## [v1.2.0] - 2020-10-22

- Updated CHANGELOG
- feat: Adds outputs for origin access identities ([#5](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/5))


<a name="v1.1.0"></a>
## [v1.1.0] - 2020-10-12

- Updated CHANGELOG
- fix: Updates aws provider to at least 3.0.0 ([#4](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/4))
- Updated example for logs delivery


<a name="v1.0.0"></a>
## [v1.0.0] - 2020-10-05

- Updated CHANGELOG
- feat: Added support for custom_header to origin ([#2](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/issues/2))


<a name="v0.3.0"></a>
## [v0.3.0] - 2020-09-16

- Updated CHANGELOG
- fix: Value of geo_restriction


<a name="v0.2.0"></a>
## [v0.2.0] - 2020-09-15

- Updated CHANGELOG
- Fixed some variables types


<a name="v0.1.0"></a>
## v0.1.0 - 2020-09-15

- Updated CHANGELOG
- Add most of the code


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.9.0...HEAD
[v2.9.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.8.0...v2.9.0
[v2.8.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.7.0...v2.8.0
[v2.7.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.6.0...v2.7.0
[v2.6.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.5.0...v2.6.0
[v2.5.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.4.0...v2.5.0
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.9.0...v2.0.0
[v1.9.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.5.0...v1.6.0
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v0.3.0...v1.0.0
[v0.3.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v0.1.0...v0.2.0
