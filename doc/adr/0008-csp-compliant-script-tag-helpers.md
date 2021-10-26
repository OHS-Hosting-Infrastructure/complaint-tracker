# 8. CSP compliant script tag helpers

Date: 2021-08-27

## Status

Superceded by [10. Rails CSP compliant script tag helpers](0010-rails-csp-compliant-script-tag-helpers.md)

## Context

There are two methods of specifying inline `<script>` tags that will comply with [CSP](https://content-security-policy.com/)
directives that we are setting using the [secure_headers](https://github.com/github/secure_headers) gem.

1. [`hashed_javascript_tag`](https://github.com/github/secure_headers/blob/main/docs/hashes.md)
1. [`nonced_javascript_tag`](https://github.com/github/secure_headers/blob/8e28012493298c622cf811b6ea1fa8a198062f35/lib/secure_headers/view_helper.rb#L31)

This ADR will talk about when and why you would use each.

Note: the same decision process applies to `hashed_style_tag` vs `nonced_style_tag` for inline `<style>`

## Decision

Whenever possible, use `hashed_javascript_tag`. Hashes are computed ahead of time, so any accidentally injected JS
will fail the hash and be prevented from running.

On the other hand, if any javascript must be dynamically generated, then `nonced_javascript_tag` must be used. This is because hashes must be generated ahead of time.

## Consequences

Requiring a [hash](https://content-security-policy.com/hash/) or [nonce](https://content-security-policy.com/nonce/) on all inline scripts and styles results in a far more secure system.

When changes are made to any hashed inline javascript, `rake secure_headers:generate_hashes` must be run to update `config/secure_headers_generated_hashes.yml`

There is an [issue with secure_headers](https://github.com/github/secure_headers/issues/432) where hashes will be generated incorrectly if the `hashed...` helper is indented.

### Nonce pitfall

[source](https://content-security-policy.com/nonce/#:~:text=Avoid%20this%20common%20nonce%20mistake)

If you are outputting variables inside a nonce protected script tag, you could cancel out the XSS protection that CSP is giving you.

For example assume you have a URL such as `/example/?id=123` and you are outputting that id value from the URL in your script block:

```
<%= nonced_javascript_tag do %>
  var id = <%= params[:id] %>
<% end %>
```

In the above example assume that the variable token `#url.id#` is the id value from the query string. Now an attacker could request the URL: `/example/?id=doSomethingBad()`, and your application would send back:

```
<script nonce="rAnd0m">
	var id = doSomethingBad()
</script>
```

As you can see we just threw away all of the cross site scripting protections of CSP by improperly using the nonce.
