# Complaint Tracker

The Complaint Tracker is intended to connect complaints data across the OHS ecosystem for greater
visibility into status and actions taken to address a complaint.

## Development

### Local Setup

* Install Ruby 3.0.2
* Install NodeJS 14.17.3
* Install PostgreSQL 12.x: `brew install postgresql@12`
  * Add postgres to your PATH if it wasn't done automatically
  `echo 'export PATH="/usr/local/opt/postgresql@12/bin:$PATH"' >> ~/.zshrc`
  * Start the server
  `brew services start postgresql@12`
* Install Ruby dependencies: `bundle install`
* Install JS dependencies: `yarn install`
* Create database: `bundle exec rake db:create`
* Run migrations: `bundle exec rake db:migrate`
* Run the server: `bundle exec rails s`
* Visit the site: http://localhost:8080

#### Authentication

The Complaint Tracker is utilizing the HSES Staging environment for non-production authentication. If you need an account
reach out in the [#ph-ohs-oneteam](https://gsa-tts.slack.com/archives/C01TT2YNX0R) Slack channel for help in requesting one.

##### Bypassing HSES Authentication

HSES Authentication can be bypassed depending on the value of `RAILS_ENV`

| Environment | HSES Bypass |
| ----------- | ----------- |
| test | set `BYPASS_AUTH` environment variable to `true` |
| development | set `BYPASS_AUTH` environment variable to `true` |
| ci | always bypassed |
| production | never bypassed |

When bypassing auth, you may use `CURRENT_USER_UID` and/or `CURRENT_USER_NAME` to override the current user's HSES name or username.

Consider [setting up automatic linting and testing](#set-up-automatic-linting-and-testing) while you're at it!

### Running Tests

* Tests: `bundle exec rake spec`
* Ruby linter: `bundle exec rake standard`
* Ruby dependency checks: `bundle exec rake bundle:audit`
* JS dependency checks: `bundle exec rake yarn:audit`
* Ruby static security scan: `bundle exec rake brakeman`

Run everything: `bundle exec rake`

### Set up automatic linting and testing

If you would like the linter to run before you commit, symlink `.githooks/pre-commit` to `.git/hooks/pre-commit`.

```bash
cd .git/hooks
ln -s ../../.githooks/pre-commit pre-commit
```

To bypass the hook in order to commit something that's not perfect yet,
run one of the following:

```bash
git commit -n  # --no-verify
```

## CI/CD

GitHub actions are used to run all tests and scans as part of pull requests.

Security scans are also run on a scheduled basis. Weekly for static code scans, and daily for dependency scans.

### Deployment

#### Staging

GitHub Actions are used to deploy to staging after any PR is merged into `main`.

Branch protection rules prevent any direct pushes to `main` or PRs from being merged into `main` until all tests and scans pass.

#### Production

TBD

### Configuring ENV variables in cloud.gov

All configuration that needs to be added to the deployed application's ENV should be added to
the `env:` block in `manifest.yml`

Items that are both **public** and **consistent** across staging and production can be set directly there.

Otherwise, they are set as a `((variable))` within `manifest.yml` and the variable is defined depending on sensitivity:

#### Credentials and other Secrets

1. Store variables that must be secret using [GitHub Environment Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-an-environment)
1. Add the secret to the `env:` block of the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L20)
1. Add the appropriate `--var` addition to the `push_arguments` line on the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L27)

#### Non-secrets

Configuration that changes from staging to production, but is public, should be added to `config/deployment/stage.yml` and `config/deployment/production.yml`

## Documentation

Architectural Decision Records (ADR) are stored in `doc/adr`
To create a new ADR, first install [ADR-tools](https://github.com/npryce/adr-tools) if you don't
already have it installed.
* `brew install adr-tools`

Then create the ADR:
*  `adr new Title Of Architectural Decision`

This will create a new, numbered ADR in the `doc/adr` directory.

## Contributing

~This will continue to evolve as the project moves forward.~

* Pull down the most recent main before checking out a branch
* Write your code
* If a big architectural decision was made, add an ADR
* Submit a PR
  * If you added functionality, please add tests.
  * All tests must pass!
* Ping the other engineers for a review.
* At least one approving review is required for merge.
* Rebase against main before merge to ensure your code is up-to-date!
* Merge after review.
  * Squash commits into meaningful chunks of work and ensure that your commit messages convey meaning.

## Story Acceptance

TBD
