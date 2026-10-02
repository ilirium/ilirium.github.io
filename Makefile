git_submodules_update:
	git submodule update --init --recursive

dev_server:
	hugo server

dev_server_with_drafts:
	hugo server --buildDrafts

new_post:
	hugo new posts/new_post.md

build:
	hugo
