.DEFAULT_GOAL := help

ROLES_DOC	:= $(doc/%.rst)

all: doc

help:  ## display this help
	@cat $(MAKEFILE_LIST) | grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' | \
		sort -k1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## cleanup
	$(shell \
		cd doc; \
		make clean; \
		cd ..; \
	)

doc: $(ROLES_DOC)  ## create html documentation
	cd doc && make html

doc/%.rst: doc/sphinx-template
	mk/yml2rst $* $< $@

doc/sphinx-template:
	git clone https://github.com/adfinis-sygroup/adsy-sphinx-template doc/sphinx-template

.PHONY: all help clean requirements install doc

# vim: set noexpandtab ts=4 sw=4 ft=make :
