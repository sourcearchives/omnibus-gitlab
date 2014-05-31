PROJECT=gitlab
PUBLIC:=$(shell support/is_gitlab_ee.sh || support/is_gitlab_com.sh || echo --public)

build:
	touch build.txt
	OMNIBUS_APPEND_TIMESTAMP=0 bin/omnibus build project ${PROJECT}

do_release: no_changes on_tag purge build sync

no_changes:
	git diff --quiet HEAD

on_tag:
	git describe --exact-match

purge:
	rm -rf /var/cache/omnibus/src/gitlab-rails
	rm -rf /var/cache/omnibus/pkg
	mkdir -p pkg
	(cd pkg && find . -delete)

sync: upload_to_s3 show_url show_metadata

upload_to_s3:
	find pkg -newer build.txt -type f -not -name '*.json' -exec bin/omnibus release package ${PUBLIC} {} \;

show_url:
	find pkg -newer build.txt -name '*.json' -exec bundle exec ruby support/show_url.rb ${PUBLIC} {} \;

show_metadata:
	find pkg -newer build.txt -name '*.json' -exec cat {} \; -exec echo \;
