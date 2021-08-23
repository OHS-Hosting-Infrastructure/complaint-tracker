# Terraform

## Get started

1. Set up a service key
    ```bash
    # login
    cf login -a api.fr.cloud.gov --sso
    # follow temporary authorization code prompts
    # select org "gsa-sandbox", and your space

    # create a service instance that can provision service accounts
    # the value for < YOUR-NAME > can be any version of your name, it isn't significant
    cf create-service cloud-gov-service-account space-deployer < YOUR-NAME >

    # bind a service key to the service instance
    cf create-service-key < YOUR-NAME > space-deployer-key

    # return a username/password pair for the service instance
    cf service-key < YOUR-NAME > space-deployer-key
    ```
1. Copy `terraform/<ENV>/secrets.tfvars.example` to `secrets.tfvars` and add the service key information
    ```
    cf_user = "some-dev-user"
    cf_password = "some-dev-password"
    ```
1. Run terraform with
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```
1. Assuming all is well, now you can bind RDS to your app
    ```bash
    cf bind-service < YOUR-APP > < YOUR-RDS-SERVICE >
    cf restage < YOUR-APP >
    ```

## Structure

Each environment has its own module, which relies on a shared module for everything except the providers code and environment specific variables and settings.

```
- database_<env>/
  |- main.tf
  |- providers.tf
  |- secrets.tfvars
  |- secrets.tfvars.example
  |- variables.tf
- shared/
  |- database/
     |- main.tf
     |- providers.tf
     |- variables.tf
```

In the shared module, `providers.tf` contains set up instructions for Terraform about Cloud Foundry and AWS. `main.tf` sets up the data and resources the application will rely on. In our case, that's RDS (Postgres) and S3. `variables.tf` has a big list of variables with default values.

In the environment-specific modules, `providers.tf` is essentially the same as the shared module. `main.tf` calls the shared Terraform code, but this is also a place where you can add any other services, resources, etc, which you would like to set up for that environment. `variables.tf` provides one way to override any default values set in the shared module `variables.tf` file, or you can also pass in values through the `main.tf` module block. `secrets.tfvars` is a file which is unique to you, and which you created during the setup instructions above.
