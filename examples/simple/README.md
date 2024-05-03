# Simple CloudFront distribution with a s3 frontend and alb backend

Configuration in this directory creates CloudFront distribution with capabilities:
- origins and origin groups
- caching behaviours
- legacy forwaded values
- Origin Access Identities (with S3 bucket policy)



## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.
