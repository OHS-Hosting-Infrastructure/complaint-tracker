# 10. Rails CSP compliant script tag helpers

Date: 2021-10-22

## Status

Accepted

Supercedes [8. CSP compliant script tag helpers](0008-csp-compliant-script-tag-helpers.md)

## Context

The CSP controls and helpers used previously do not work when utilizing Rails UJS Ajax forms.

## Decision

Using Rails built-in CSP controls while keeping SecureHeaders in place for other headers results
in a secure system that works seamlessly.

## Consequences

In order to define an inline `<script>` tag, use the `nonce: true` option.

```
<%= javascript_tag nonce: true do %>
  alert("my js runs here");
<% end %>
```

Please note that all of the pitfalls laid out in [8. CSP compliant script tag helpers](0008-csp-compliant-script-tag-helpers.md)
still apply to this helper.
