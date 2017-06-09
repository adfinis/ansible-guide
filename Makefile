.DEFAULT_GOAL := help

ROLES_DFLT			:= $(wildcard adsy-roles/*/defaults/main.yml)
ROLES_DFLT_DOC		:= $(patsubst adsy-roles/%/defaults/main.yml, doc/%.yml.rst, $(ROLES_DFLT))
ROLES_DFLT_FILES	:= $(patsubst doc/%, %, $(ROLES_DFLT_DOC))

all:

help:  ## display this help
	@cat $(MAKEFILE_LIST) | grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' | \
		sort -k1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## clean vagrant boxes
	vagrant destroy -f
	rm doc/*.yml.rst
	$(shell \
		cd doc; \
		make clean; \
		cd ..; \
	)

test:  ## run test environment
	vagrant up --provision

doc: $(ROLES_DFLT_DOC)  ## create html documentation
	cp mk/role_overview.rst doc/role_overview.rst
	echo " $(ROLES_DFLT_FILES)" | \
		sed "s/.rst/.rst\n/g" | \
		sort -u | \
		grep -v '_template.yml.rst' \
		>> doc/role_overview.rst
	cd doc && make html

doc/%.yml.rst: adsy-roles/%
	mk/yml2rst $* $< $@

.PHONY: all help test doc

# vim: set noexpandtab ts=4 sw=4 ft=make :
