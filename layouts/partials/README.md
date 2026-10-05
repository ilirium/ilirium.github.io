# Partial overrides

Files here win over `themes/minima/layouts/partials/` in Hugo's template
lookup order, so the theme submodule can stay a plain upstream mirror.

> **Note on this file.** Hugo parses *every* file under `layouts/` as a Go
> template, including Markdown. A literal action delimiter here would break
> the build, so template snippets below write them as `[[` and `]]`.

## header.html

Overrides the theme's nav bar for two reasons.

**1. Menu entries use `.URL`, not `.Identifier`.** Upstream renders:

```go-html-template
<a href="[[ relLangURL .Identifier ]]">
```

which ignores the `url` set in `config.yaml` and links to the entry's
identifier instead. The "Demo: wasm_simple" entry points at an external
address, so upstream produced a dead `/wasm-demo` link.

**2. `targetBlank` support.** Upstream has no way to open a menu entry in a
new tab. An entry can now set:

```yaml
- identifier: wasm-demo
  url: https://ilirium.net/rust_hello_wasm/
  params:
    targetBlank: true
```

and gets `target="_blank" rel="noopener noreferrer"`.

Absolute URLs pass through untouched — `relLangURL` is applied only to
scheme-less destinations, so an entry pointing at another domain is not
stripped down to a path.

## On upgrading the theme

Re-check this file against upstream's `header.html`. It is a full copy, so
any unrelated upstream change to the header — brand, language switcher,
styling — will not reach the site until merged in here by hand.
