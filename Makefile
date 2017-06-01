.DEFAULT_GOAL := help

all:

help:  ## display this help
	@cat $(MAKEFILE_LIST) | grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' | \
		sort -k1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## clean vagrant boxes
	vagrant destroy -f
	$(shell \
		cd doc; \
		make clean; \
		cd ..; \
	)

test:  ## run test environment
	vagrant up --provision

doc:  ## create html documentation
	$(shell \
		cd adsy-roles; \
		for f in *; do \
			test -f "$$f/defaults/main.yml" && \
					cp "$$f/defaults/main.yml" "../doc/$$f.yml"; \
		done; \
	)
	cd doc && make html

.PHONY: all help test doc

# vim: set noexpandtab ts=4 sw=4 ft=make :
