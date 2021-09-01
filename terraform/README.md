# Terraform

## Set up a new environment

1. Set up a service key
    ```bash
    # login
    cf login -a api.fr.cloud.gov --sso
    # follow temporary authorization code prompts
    # select the desired OHS org and complaint tracker environment space

    # create a service instance that can log in with just a username and password
    # the value of < SPACE-NAME > should be `ct-stage` or `ct-prod` depending on where you are working
    # the value for < SERVICE-NAME > can be anything, although we recommend
    # something that communicates the purpose of the deployer
    # for example: github-action-deployer for the credentials Github Actions uses to
    # deploy the application
    ./create_space_deployer.sh < SPACE-NAME > < SERVICE-NAME >
    ```

    The script will output the `username` and `password` for your `< SERVICE-NAME >`. Read more in the [cloud.gov service account documentation](https://cloud.gov/docs/services/cloud-gov-service-account/).

1. Copy `terraform/<ENV>/secrets.auto.tfvars.example` to `secrets.auto.tfvars` and add the service key information from the above step

    ```
    cf_user = "some-user"
    cf_password = "some-password"
    ```

1. Run terraform with
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

1. Remove the service instance if it doesn't need to be used again, such as by CI/CD.
    ```bash
    # < SPACE-NAME > and < SERVICE-NAME > have the same values as used above.
    ./destroy_space_deployer.sh < SPACE-NAME > < SERVICE-NAME >
    ```

## Structure

Each environment has its own module, which relies on a shared module for everything except the providers code and environment specific variables and settings.

```
- bootstrap/
  |- main.tf
  |- providers.tf
  |- variables.tf
  |- run.sh
  |- teardown_creds.sh
- <env>/
  |- main.tf
  |- providers.tf
  |- secrets.auto.tfvars
  |- secrets.auto.tfvars.example
  |- variables.tf
- shared/
  |- database/
     |- main.tf
     |- providers.tf
     |- variables.tf
```

In the shared module:
- `providers.tf` contains set up instructions for Terraform about Cloud Foundry and AWS
- `main.tf` sets up the data and resources the application relies on
- `variables.tf` lists the required variables and applicable default values

In the environment-specific modules:
- `providers.tf` lists the required providers
- `main.tf` calls the shared Terraform code, but this is also a place where you can add any other services, resources, etc, which you would like to set up for that environment
- `variables.tf` lists the variables that will be needed, either to pass through to the child module or for use in this module
- `secrets.auto.tfvars` is a file which contains the information about the service-key and other secrets that should not be shared

In the bootstrap module:
- `providers.tf` lists the required providers
- `main.tf` sets up s3 bucket to be shared across all environments. It lives in ct-prod to communicate that it should not be deleted
- `variables.tf` lists the variables that will be needed. Most values are hard-coded in this module
- `run.sh` Helper script to set up a space deployer and run terraform. The terraform action (`show`/`plan`/`apply`/`destroy`) is passed as an argument
- `teardown_creds.sh` Helper script to remove the space deployer setup as part of `run.sh`

## Terraform State Credentials

The bootstrap module is used to create an s3 bucket for later terraform runs to store their state in.

### To run the bootstrap the first time or make changes

1. Run `./run.sh plan` to verify that the changes are what you expect
1. Run `./run.sh apply` to create the shared config bucket and retrieve the bucket credentials
1. Follow instructions under `Use bootstrap credentials`
1. Run `./teardown_creds.sh` to remove the space deployer account used to create the s3 bucket

### Retrieving existing bucket credentials

1. Run `./run.sh show` to retrieve the bucket credentials
1. Follow instructions under `Use bootstrap credentials`
1. Run `./teardown_creds.sh` to remove the space deployer account used to read the s3 bucket credentials

#### Use bootstrap credentials

##### Locally

1. Add the following to `~/.aws/config`

```
[profile ct-terraform]
region = us-gov-west-1
output = json
```

2. Add the following to `~/.aws/credentials`

```
[ct-terraform]
aws_access_key_id = <<access_key_id from bucket_credentials>>
aws_secret_access_key = <<secret_access_key from bucket_credentials>>
```

3. Copy `bucket` from `bucket_credentials` to the backend block of `<env>/providers.tf`

##### In GitHub Actions

Set environment variables for configuration, using [GitHub Environment Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-an-environment)

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
