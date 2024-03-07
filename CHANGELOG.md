# Changelog

All notable changes to this project will be documented in this file.

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
