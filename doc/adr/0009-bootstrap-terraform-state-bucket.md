# 9. bootstrap terraform state bucket

Date: 2021-08-31

## Status

Accepted

## Context

Terraform needs an s3 bucket to store shared state, but we can't easily create that bucket in the terraform
it is needed in.

## Decision

We will create one bootstrap module to create only an s3 bucket in the `ct-prod` space and use that to store terraform
state for all environments.

It is located in the `ct-prod` space to lower the possibility that data supporting production will be wiped by someone
thinking they are only operating on `ct-stage`

### Other options

Create a new space just for this bucket. This was determined to be overkill, and required assistance from
HSES program staff as we do not have the access required to create a new space in the HSES cloud.gov organization.

Create a state bucket for each environment. Similarly to creating a new space, we do not have sufficient
permissions to grant a space-deployer user access to multiple spaces. That meant that we would need separate
bootstrap modules for each environment.

## Consequences

Terraform will be easier to run across developers and CI/CD pipeline runs with the state stored in s3.

Credentials for an s3 bucket will need to be shared across environments, but that should not grant access
to anything other than the s3 bucket, and the s3 bucket is not used for any application data.
