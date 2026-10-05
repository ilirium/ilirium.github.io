# Default template overrides

Files here win over `themes/minima/layouts/_default/` in Hugo's template
lookup order, so the theme submodule can stay a plain upstream mirror.

See also `_markup/README.md` for the link render hook.

> **Note on this file.** Hugo parses *every* file under `layouts/` as a Go
> template, including Markdown. A literal action delimiter here would break
> the build, so template snippets below write them as `[[` and `]]`.

## single.html

Overrides the post template to change how `.Description` is rendered.

Upstream emits it as a bare paragraph directly above the article:

```go-html-template
<p>[[ .Description | markdownify | safeHTML ]]</p>
<article class="md">[[ .Content ]]</article>
```

which reads as the post's first paragraph rather than a summary of it. Here
it becomes a labelled `TL;DR` aside with an accent-coloured left border,
visually separated from the body.

Two side effects worth knowing:

- Wrapping it in a `with` block means posts *without* a description no
  longer emit an empty `<p></p>`. Upstream always emitted one.
- `.Description` is unchanged as a field. It still feeds `og:description`
  and `twitter:description` (via Hugo's internal templates) and the
  home-page listing excerpt in `item.html`. Only the post-page rendering
  differs, so one front-matter line still drives all three.

### Why the styles are inline

The rules live in a `style` block in the template, emitted only on posts
that have a description. The tidier-looking alternative — a project-level
`assets/css/main.scss` — does not work: Hugo's asset lookup *replaces* the
theme's file rather than merging with it, so it would mean vendoring the
theme's whole stylesheet to add eight lines.

Colours use the theme's existing `--prime` and `--text` variables, so the
callout follows light and dark mode with no extra rules.

### The TL;DR label

Hardcoded English. The theme is multilingual and has no `tldr` key in its
i18n files, so translating it would mean adding entries under
`themes/minima/i18n/` — the one thing this setup avoids. Revisit if a
second language is ever added.

## On upgrading the theme

Re-check this file against upstream's `single.html`. It is a full copy, so
unrelated upstream changes — tags, dates, draft badges, the plugin partial
— will not reach the site until merged in here by hand.
