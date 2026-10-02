# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Hugo static site — Ilya Kalimulin's ("Ilirium") personal blog. Published at https://ilirium.net/ (also reachable at https://ilirium.github.io/). The repo contains only content and configuration; all layouts, partials, and styles live in the theme submodule.

## Commands

```sh
make git_submodules_update   # git submodule update --init --recursive — run first on a fresh clone
make dev_server              # hugo server — live reload at :1313, drafts hidden
make dev_server_with_drafts  # hugo server --buildDrafts
make new_post                # creates content/posts/new_post.md from archetypes/default.md (rename it after)
make build                   # hugo → ./public (gitignored)
```

`hugo new posts/<slug>.md` is the general form of `make new_post`. There is no test or lint step.

The theme lives in the `themes/minima` submodule and `hugo` fails without it, so `make git_submodules_update` is the first step on a fresh clone. Its remote is an SSH URL (`git@github.com:ilirium/hugo-theme-minima.git`), so it needs SSH access to that repo.

## Architecture

- `config.yaml` — the single source of site behavior. Beyond standard Hugo keys it drives the theme through `params`: `switch` (light/dark toggle emojis), `defaultTheme`, `displayDate`/`displayDescription` (home-page listing), `social` (footer links), and the `math` / `diagram` / `comment` plugin blocks (all currently disabled; enabling one is a config edit, not a template edit). `params.mainSections` is `[posts]`, so only `content/posts/` appears in listings and the RSS feed.
- `menu.main` in `config.yaml` is the nav bar. Entries with `params.targetBlank: true` open in a new tab (used for the external WASM demo link).
- `content/posts/*.md` — blog posts. `content/*.md` at the top level are standalone pages (`about.md`, `hire-me.md`) linked from `menu.main`; `hire-me.md` sets `headless: true`.
- Front matter in use: `title`, `description` (shown on the home page), `date`, and `draft`. The archetype sets `draft: true`, so new posts need that removed or flipped before they publish.
- `themes/minima/` — submodule, the only place with templates/assets (`layouts/_default/`, `layouts/partials/`). It is https://github.com/ilirium/hugo-theme-minima, a personal fork of mivinci/hugo-theme-minima, pinned to a commit on its `ilirium_tune` branch. Changes to markup or styling belong in that repo, not here: edit it there, push, then commit the bumped submodule pointer in this repo. `assets/jsconfig.json` just maps `*` to the theme's assets for IDE resolution.
- `static/` is copied verbatim to the site root (currently just `favicon.ico`).

## Deploy

`.github/workflows/hugo.yml` builds and deploys to GitHub Pages on every push to `main` (or manual dispatch). It pins `HUGO_VERSION: 0.111.3` (extended — the version the README names for local work too), checks out submodules recursively, and runs `hugo --gc --minify --baseURL "<pages base_url>/"` — the `--baseURL` flag overrides `baseURL` in `config.yaml`, so the custom domain is configured in the GitHub Pages settings rather than in a `CNAME` file here. Keep local Hugo close to 0.111.3 to avoid build drift.
