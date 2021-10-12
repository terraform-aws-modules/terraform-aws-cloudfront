<a name="unreleased"></a>
## [Unreleased]



<a name="v2.8.0"></a>
## [v2.8.0] - 2021-10-12

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


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-cloudfront/compare/v2.8.0...HEAD
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
