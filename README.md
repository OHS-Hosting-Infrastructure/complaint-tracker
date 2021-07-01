# Complaint Tracker

The Complaint Tracker is intended to connect complaints data across the OHS ecosystem for greater
visibility into status and actions taken to address a complaint.

## Development

### Local Setup

1. Install Ruby 3.0.1
1. Install NodeJS 14.16.1
1. Install PostgreSQL 12.x: `brew install postgresql@12`
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

Architectural Decision Records are stored in `doc/adr`
