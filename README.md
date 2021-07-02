# Complaint Tracker

The Complaint Tracker is intended to connect complaints data across the OHS ecosystem for greater
visibility into status and actions taken to address a complaint.

## Development

### Local Setup

1. Install Ruby 3.0.1
1. Install NodeJS 14.17.2
1. Install PostgreSQL 12.x: `brew install postgresql@12`
  * Add postgres to your PATH if it wasn't done automatically
  `echo 'export PATH="/usr/local/opt/postgresql@12/bin:$PATH"' >> ~/.zshrc`
  * Start the server
  `brew services start postgresql@12`
1. Install Ruby dependencies: `bundle install`
1. Install JS dependencies: `yarn install`
1. Create database: `bundle exec rake db:create`
1. Run migrations: `bundle exec rake db:migrate`
1. Run the server: `bundle exec rails s`

### Running Tests

Ruby linter: `bundle exec rake standard`
Tests: `bundle exec rake spec`

Run everything: `bundle exec rake`

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