.DEFAULT_GOAL := help

ROLES		:= $(wildcard adfinis-roles/*)
ROLES_DOC	:= $(patsubst adfinis-roles/%, doc/%.rst, $(ROLES))
ROLES_FILES	:= $(patsubst doc/%, %, $(ROLES_DOC))

all:

help:  ## display this help
	@cat $(MAKEFILE_LIST) | grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' | \
		sort -k1,1 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean:  ## cleanup
	rm -f requirements.yml
	rm -f doc/adfinis-sygroup.*.rst
	$(shell \
		cd doc; \
		make clean; \
		cd ..; \
	)

requirements: ## create requirements.yml
	echo "---" > requirements.yml
	for role in $$(ansible-galaxy search --author adfinis-sygroup | awk '/adfinis/ {print $$1}'); do \
	    echo -e "- src: $$role\n  version: master" >> requirements.yml; \
	done

install: ## install all ansible roles
	ansible-galaxy install -r requirements.yml

doc: $(ROLES_DOC)  ## create html documentation
	cp mk/role_overview.rst doc/role_overview.rst
	echo " $(ROLES_FILES)" | \
		sed "s/.rst/.rst\n/g" | \
		sort -u | \
		grep -v '_template.rst' \
		>> doc/role_overview.rst
	cd doc && make html

doc/%.rst: adfinis-roles/% doc/sphinx-template
	mk/yml2rst $* $< $@

doc/sphinx-template:
	git clone https://github.com/adfinis-sygroup/adsy-sphinx-template doc/sphinx-template

.PHONY: all help clean requirements install doc

# vim: set noexpandtab ts=4 sw=4 ft=make :
