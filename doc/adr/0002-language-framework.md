# 2. Language/framework

Date: 2021-07-01

## Status

Accepted

## Context

This app is a prototype to demonstrate the value of data-sharing from systems across the OHS IT ecosystem. These systems include
two Java-based systems, one JavaScript system, and one Drupal site. The long-term home of this prototype is currently unknown.
We would like to balance the potential adaptability to an existing system with up-front development time as we build out. The three developers
working on the prototype are all experienced Ruby developers, with varying levels of JavaScript experience, and very limited Java experience.

## Decision

We will use [Ruby on Rails](https://rubyonrails.org/) to build this prototype.

## Consequences

By choosing Ruby on Rails, we are using a straightforward, easily deployable framework that we are all familiar with.

* Hit the ground running
  * No need to sink time into learning/researching components of a language or framework
  * All developers are able to immediately work on the code and have a deep understanding of the existing patterns.
  * Very easy framework to start from scratch

This is a language that does not currenly exist in the OHS ecosystem. One identified risk is that it will be difficult to maintain for the existing
system vendors. We don't want to create a situation where vendors need to maintain a service in a language and framework in which they have
no expertise.

~mitigation steps~

* Create an app that has easy patterns to replicate in another language -- especially Java
  * Rails has a straightforward MVC pattern that could map to a Java system
* Writing an explicit guide for moving the data from our app to another database