HUGO   ?= hugo@v0.111.3

git_submodules_update:
	git submodule update --init --recursive

hugo_install:
	CGO_ENABLED=1 go install -tags extended github.com/gohugoio/$(HUGO)

dev_server:
	hugo server

dev_server_with_drafts:
	hugo server --buildDrafts

new_post:
	hugo new posts/new_post.md

build:
	hugo
