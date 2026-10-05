GOBIN_DIR ?= $(HOME)/go/bin

HUGO_OLD_VER ?= 0.111.3
HUGO_LATEST_VER ?= 0.167.0

HUGO_OLD ?= $(GOBIN_DIR)/hugo$(HUGO_OLD_VER)+extended
HUGO_LATEST ?= $(GOBIN_DIR)/hugo$(HUGO_LATEST_VER)+extended
HUGO ?= $(HUGO_LATEST)

.PHONY: git_submodules_update \
	git_local_setup \
	hugo_install_old \
	hugo_install_latest \
	go_install_old \
	go_install_latest \
	theme_minima_latest \
	hugo_version \
	dev_server \
	dev_server_with_drafts \
	new_post \
	build

# Local-only git settings for this checkout. They live in .git/, so neither
# repo tracks them and a fresh clone will not have them -- re-run this then.
# Safe to re-run: both steps are guarded.
git_local_setup:
	@if git -C themes/minima remote get-url upstream >/dev/null 2>&1; then \
		git -C themes/minima remote set-url --push upstream DISABLED; \
		echo "ok: push to the upstream remote disabled"; \
	else \
		echo "skip: no 'upstream' remote in themes/minima (run theme_minima_latest first)"; \
	fi
	@GITDIR="$$(git -C themes/minima rev-parse --absolute-git-dir)"; \
	mkdir -p "$$GITDIR/info"; \
	if grep -qxF '.idea/' "$$GITDIR/info/exclude" 2>/dev/null; then \
		echo "ok: .idea/ already excluded in themes/minima"; \
	else \
		printf '\n# Local-only: JetBrains project files for this checkout.\n.idea/\n' >> "$$GITDIR/info/exclude"; \
		echo "ok: .idea/ excluded in themes/minima"; \
	fi

git_submodules_update:
	git submodule update --init --recursive

hugo_install_old:
	CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@v$(HUGO_OLD_VER)
	mv $(GOBIN_DIR)/hugo $(HUGO_OLD)
	ls -lh $(GOBIN_DIR)

hugo_install_latest:
	CGO_ENABLED=1 go1.27.0 install -tags extended github.com/gohugoio/hugo@v$(HUGO_LATEST_VER)
	mv $(GOBIN_DIR)/hugo $(HUGO_LATEST)
	ls -lh $(GOBIN_DIR)

go_install_old:
	go install golang.org/dl/go1.19.1@latest
	ls -lh $(GOBIN_DIR)

go_install_latest:
	go install golang.org/dl/go1.27.0@latest
	ls -lh $(GOBIN_DIR)

theme_minima_latest:
	cd themes/minima && \
	( git remote get-url upstream >/dev/null 2>&1 || \
	  git remote add upstream https://github.com/Mivinci/hugo-theme-minima.git ) && \
	git fetch upstream && \
	git switch -C upstream-$$(date +%Y%m%d) upstream/main

hugo_version:
	$(HUGO) version

dev_server:
	$(HUGO) server

dev_server_with_drafts:
	$(HUGO) server --buildDrafts

new_post:
	$(HUGO) new posts/new_post.md

build:
	$(HUGO)
