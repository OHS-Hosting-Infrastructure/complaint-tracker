# 7. Use OWASP ZAP for dynamic security scans

Date: 2021-08-26

## Status

Accepted

Amends [4. Security Scans](0004-security-scans.md)

## Context

In order to maintain a secure system, we want to scan a running version of the code with a scanner
that can simulate actual attacks.

We want to do this on every code change, so we can know immediately if or when a vulnerability is introduced.

We also want to do this daily, so that we are aware as quickly as possible when new problems are found.

## Decision

We will add [OWASP Zap](https://www.zaproxy.org/) to our CI/CD pipeline, in addition to the scans
already defined by [4. Security Scans](0004-security-scans.md).

An additional `RAILS_ENV` has been created called `ci`. It inherits from `production` to ensure
that the system being tested is as close as possible to `production` while allowing for bypassing authentication
in a secure way.

## Consequences

We now have real-time information on security vulnerabilities that can arise from the running application.

We can now allow for CI/CD actions to test authenticated pages without opening a security hole in our real deployed
application.
