# NOTE-0001: Is the Dart Sass step in CI actually needed?

*Investigated 2026-10-02, against Hugo pinned at 0.111.3 and `themes/minima` at `9de8a60` (`ilirium_tune`).*

## Question

`.github/workflows/hugo.yml` runs `sudo snap install dart-sass-embedded` before building.
The snap is stale (last stable 1.62.1, June 2023, flagged unmaintained on the Snap Store).
Can the step be dropped?

## Short answer

Yes at the current Hugo pin — it is never consulted. But **keep it anyway**: it becomes
necessary again the moment Hugo is upgraded past the point where the SCSS transpiler
default flips. Retire it as part of that upgrade, not on its own.

## Evidence

**1. Hugo 0.111.3 defaults to LibSass, and Dart Sass is strictly opt-in.**
From that exact tag's source, `tpl/resources/resources.go`:

```go
// Transpiler implementation can be controlled from the client by
// setting the 'transpiler' option.
// Default is currently 'libsass', but that may change.
...
transpiler = transpilerLibSass                                 // line 352
...
if t, found := maps.LookupEqualFold(m, "transpiler"); found {  // line 365
```

Hugo only looks for a Dart Sass binary when the options map carries a `transpiler` key.

**2. The theme never sets that key.** Its single call site,
`themes/minima/layouts/partials/head.html:19`:

```go-html-template
{{ $options := (dict "targetPath" "minima.css" "outputStyle" "compressed" "enableSourceMap" true) }}
{{ $style := resources.Get "css/main.scss" | resources.ToCSS $options }}
```

A grep for `transpiler` / `dartsass` / `dart-sass` across the whole theme returns nothing.

**3. The SCSS needs no Dart-Sass-only features.** `main.scss` pulls in its five partials
with old-style `@import`. None of `@use`, `@forward`, `sass:` modules, `math.div`,
`color.adjust`, or `map.get` appear in any of the six files — those are the constructs
that would force Dart Sass.

**4. LibSass ships inside the binary CI installs.** The workflow installs
`hugo_extended_${HUGO_VERSION}`, and LibSass is compiled into the extended build.
No external binary is required.

**5. The theme is not straining against the Hugo pin.** `themes/minima/theme.toml`
declares `min_version = "0.85.0"`, comfortably below 0.111.3.

## Two hypotheses that were considered and ruled out

- *Maybe the older Hugo depends on Dart Sass?* The reverse. Older Hugo is **less** likely
  to need it: LibSass was the default and Dart Sass the opt-in newcomer. The dependency
  direction only tightens over time.
- *Maybe the theme requires it, being an older version?* The theme sits squarely on the
  LibSass side (point 3), and predates the pin rather than outrunning it.

## Why it stays anyway

Both versions flag the default as temporary. Hugo 0.167.0 moved `ToCSS` to `tpl/css/css.go`,
where line 147 now reads:

```go
transpiler = sass.TranspilerLibSass // Deprecated default. Will be dartsass in future versions.
```

So this step is not dead weight so much as **a dependency of the Hugo upgrade, parked early**.
When Hugo is bumped:

- expect the transpiler default to flip to Dart Sass;
- replace `dart-sass-embedded` (frozen 2023; Dart Sass folded embedded support into the main
  distribution) with the current `dart-sass`;
- note separately that `config.yaml` uses `paginate: 12`, which later Hugo versions deprecate
  in favour of `pagination.pagerSize`.

## Not verified

This rests on reading the pinned version's source, not on a build. The empirical check —
install `hugo_extended` 0.111.3 with no Dart Sass on PATH and run `hugo` — was not performed.
