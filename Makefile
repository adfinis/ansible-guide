.DEFAULT_GOAL := help

all: doc

help:  ## display this help
	@cat $(MAKEFILE_LIST) | grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' | \
		sort -k1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## cleanup
	cd doc && make clean

doc: ## create html documentation
	rm -rf doc/_build/
	poetry install --no-root
	poetry run sh -c 'cd doc && make html'

.PHONY: all help clean doc
# vim: set noexpandtab ts=4 sw=4 ft=make :
