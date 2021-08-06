# Complaint Tracker

The Complaint Tracker is intended to connect complaints data across the OHS ecosystem for greater
visibility into status and actions taken to address a complaint.

## Development

### Local Setup

* Install Ruby 3.0.1
* Install NodeJS 14.17.2
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
reach out in the #ph-ohs-oneteam channel for help in requesting one.

Consider [setting up automatic linting and testing](#set-up-automatic-linting-and-testing) while you're at it!

### Running Tests

Tests: `bundle exec rake spec`
Ruby linter: `bundle exec rake standard`
Ruby dependency checks: `bundle exec rake bundle:audit`
JS dependency checks: `bundle exec rake yarn:audit`
Ruby static security scan: `bundle exec rake brakeman`

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

TBD

### Deployment

TBD

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
