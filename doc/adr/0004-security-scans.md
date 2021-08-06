# 4. Security Scans

Date: 2021-08-06

## Status

Accepted

## Context

In order to maintain a secure system, it is important that we are kept notified of any potential
vulnerabilities as early as possible, so we can mitigate them.

## Decision

We will add three new scans to our CI/CD Pipeline.

### Brakeman

Brakeman is a static code scanner designed to find security issues in Ruby on Rails code. It can flag
potential SQL injection, Command Injection, open redirects, and other common vulnerabilities.

### Bundle Audit

bundle-audit checks our Ruby dependencies against a database of known CVE numbers.

### Yarn Audit

yarn audit checks our Javascript dependencies against a database of known CVE numbers.
The change that we're proposing or have agreed to implement.

## Consequences

We now have real-time information on any security vulnerabilities we may have introduced, as well as continuous
monitoring and alerting of discovered vulnerabilities in our software dependencies.

Our system security posture is overall improved by these additions.
