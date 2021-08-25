# 6. Dynamic API Wrapper

Date: 2021-08-25

## Status

Accepted

## Context

As our system grows, we will be incorporating three different OHS systems into our tracker. Having a consistent API
wrapper for us to make requests will make our codebase more easily extendable and understandable.

We also would like to be able to seamlessly switch to our FakeData when we are working in a dev or test envinronment.

## Decision

There will be a top-level `Api` class that is envoked via a `self.request` method. This method will take 2 required
arguments and an options hash. The required arguments will be the name of the system, and the name of the endpoint.
The `Api` class will check the environment and optionally include the FakeData namespace.

Each endpoint will be its own class namespaced within their system's class.
So trying to hit the HSES issue detail api in production would look like `Api::Hses::Issue`. In a dev environment,
that would look like `Api::FakeData::Hses::Issue`.

The `Api` class will instantiate the object with any options that have been passed in, and then call a `request`
method that will fetch the requested data.

## Consequences

There is an easily extendable structure for us to add diferent systems and endpoints moving forward. The business
logic gets an easy entry point into the Api, each endpoint can handle its own implemetation details, and the system
level class can handle individual system details and config.

Metaprogramming always comes with the risk of being hard to understand at a glance, but we pulled the bulk of the
metaprogramming into a named method to make it clearer what is going on, and including a comment and extensive tests
to make the behavior clearer.