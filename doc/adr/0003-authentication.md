# 3. Authentication

Date: 2021-07-30

## Status

Accepted

## Context

Users of the complaint tracker need to login for access to sensitive data.

All users will already have an HSES account, and HSES is the main sore of complaint data currently.

HSES is also already a provider of OAuth2 sign-in services to other OHS applications.

## Decision

Complaint Tracker will utilise HSES OAuth2 for single-sign-on, utilizing the Ruby Omniauth library to facilitate
the protocol.

## Consequences

* Users will not need another password
* Authorizing API calls to HSES will be much easier
* Stubbing in fake user sessions will be more difficult in testing or prototyping
* Uptime reliant on HSES being available
