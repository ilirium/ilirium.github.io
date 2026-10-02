# NOTE-0002: Migrating to Hugo 0.167.0 and upstream Minima

*Investigated 2026-10-02. From: Hugo 0.111.3, `themes/minima` fork `ilirium_tune` @ `9de8a60`.
To: Hugo 0.167.0, upstream `Mivinci/hugo-theme-minima` @ `ebe8c37` (branch `upstream-20261002`).*

## Method

Built the real site with 0.167.0 against the already-switched submodule and inspected the
generated HTML, RSS and file tree. Every item below was observed in output or tested
directly — not inferred from release notes.

## Headline result

The build is clean: **exit 0, 31 ms, no template errors**, despite upstream declaring
`min_version = "0.128.0"` rather than 0.167. That was the one risk that could not be
planned around in advance. Four things are nonetheless broken in the *output*.

## Breaking

| # | symptom | cause | fix |
|---|---|---|---|
| 1 | `/hire-me/` is not generated at all, while the nav still links to it | `headless: true` | remove it |
| 2 | WASM demo link emits `/wasm-demo`, loses `target="_blank"` | both `header.html` fork patches dropped | project-level override |
| 3 | `<img ... src="" alt="avatar">`, no intro text | theme reads `.Site.Params.Author.*` | move `author:` under `params:` |
| 4 | `/about/` appears in the home listing and the RSS feed | both `mainSections` fork patches dropped | `_build.list: never` |

### 1. The missing page

Easy to miss by reading config alone, and the most damaging. `content/hire-me.md` carries
`headless: true`, which Hugo 0.111.3 ignored on a non-bundle page. Hugo 0.167 honours it and
renders nothing.

- live site today: `curl -o /dev/null -w "%{http_code}" https://ilirium.net/hire-me/` → **200**
- new build: no `hire-me/` directory, while `layouts/partials/header.html` still links to it
- verified by removing the line and rebuilding: the page appears

### 2. The menu patches were load-bearing

Upstream still renders `href="{{ relLangURL .Identifier }}"`, so a menu entry whose `url` is
external resolves to its *identifier* instead. Confirmed in output:

```html
<a href="/wasm-demo">Demo: wasm_simple</a>     <!-- want https://ilirium.net/rust_hello_wasm/ -->
```

Upstream has no `targetBlank` support either. Both patches must survive the upgrade — but as a
project-level `layouts/partials/header.html`, which wins over the theme's copy in Hugo's lookup
order, so the submodule stays pristine.

### 4. Interaction with #1

Removing `headless: true` puts `hire-me` back into the page collections, so it will then leak
into the listing and feed exactly as `about` does now. **Both** pages need:

```yaml
_build:
  list: never
```

Per `resources/page/pagemeta/pagemeta.go:36`, `List` controls "whether to add it to any of the
page collections"; `Render` stays `always`, so the pages still build at their URLs. This
replaces two fork patches with two lines of content front matter.

## Non-breaking

- **`paginate: 12` is dead config.** Not present in `config/allconfig/allconfig.go`; pagination
  moved to its own `Pagination` struct. Silently ignored, *no warning*. Invisible at one post,
  but the default of 10 would quietly apply past 13 posts. → `pagination.pagerSize: 12`.
- **Deprecation warnings.** `languageCode` → `locale` is ours. `.Site.Data` and
  `.Site.LanguageCode` come from the theme's templates — upstream's to fix, not actionable here.
- **`params.mainSections` becomes unused** once `_build` handles the filtering; upstream's
  templates never read it.

## Checklist

| # | file | change |
|---|---|---|
| 1 | `content/hire-me.md` | remove `headless: true`; add `_build.list: never` |
| 2 | `content/about.md` | add `_build.list: never` |
| 3 | `layouts/partials/header.html` (new) | override: `.URL` + `targetBlank` |
| 4 | `config.yaml` | `author:` → under `params:` (unblocks the avatar) |
| 5 | `config.yaml` | `paginate: 12` → `pagination.pagerSize: 12` |
| 6 | `config.yaml` | `languageCode` → `locale`; drop `params.mainSections` |
| 7 | `.github/workflows/hugo.yml`, `README.md` | `HUGO_VERSION` 0.111.3 → 0.167.0 |

## Decisions taken

- **Keep the fork as a mirror, do not merge upstream into it.** All four local patches touch
  files upstream rewrote; two are replaced by front matter and two move into this repo, so
  branching fresh from `upstream/main` is cleaner than resolving conflicts in code about to be
  deleted.
- **Submodule, not Hugo Modules.** Upstream has no `go.mod`, and its only tags (`v1.0.0`,
  `v1.1.0`) are from 2021–2022 and predate the avatar entirely — so there is nothing meaningful
  to pin to, and a submodule already pins an exact commit. Modules would also add a Go
  dependency to CI.
- **Customizations live in this repo, not the theme**, so `themes/minima` stays
  fast-forwardable.

## Dart Sass, revisited

[[NOTE-0001]]'s conclusion survives the upgrade. Upstream's new pipeline is `css.Sass $options`
with **no `transpiler` key**, and Hugo 0.167 still defaults to LibSass
(`tpl/css/css.go:147`, "Deprecated default. Will be dartsass in future versions."). The CI step
remains unused, and remains worth keeping parked for when that default flips.

## Not verified

Visual/CSS parity. The build is clean and the URLs check out, but no rendered-page comparison
against the live site was made — upstream rewrote `head.html`, `single.html`, `item.html`,
`footer.html` and the i18n files, so styling and layout differences are likely and unexamined.
