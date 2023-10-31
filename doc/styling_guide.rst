=============
Styling Guide
=============

YAML Syntax
===========

There is a basic guide at `ansible docs
<https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html>`_.

- We use an indention of 2 spaces, no tabs.
- We preferrably only use `true` and `false` for booleans.

Tasks
-----
.. code-block:: Yaml

  ---

  - name: Task 1
    example.collection.module:
      arg1: Foo
      arg2: Bar
      arg3: "{{ item }}"
    loop: "{{ role_data }}"

- Each file starts with ``---`` and a empty line after that.
- Each task has a empty line above the task.
- Tasks have a name which contains only letters, numbers
  and spaces.  Task names start with an uppercase letter.
- Module names are written as FQCN whereever possible.
- Each argument of a module is on its own line.
- Key and value are separated by colon and space.
- Values don't need to be quoted if they are single words.
- Variables are always quoted and have a leading and a trailing space around the name.
- Double quotes are preferred over single quotes for quoting strings,
  as they allow escape sequences such as ``\\``, ``\n``.  Single
  quotes can be used to make nested quoting more readable.


Handler Tasks
-------------
.. code-block:: Yaml

  ---

  - name: Role handler task 1
    example.collection.module:
      arg1: Foo
      arg2: '{{ role_service }}'

- Handlers follow the same rules as tasks.
- Each handler name must start with the role name.


Variables
---------
.. code-block:: Yaml

  ---

  # role_var1 description
  role_var1: 'Foo Bar'

* Variable names contains only lower case letters, numbers and underscores.
* Each name starts with a role-name and an underline.
* Use the collection name rather than the role name as prefix for variables that are shared between roles in a collection.
  * Even though Ansible doesn't really support the "sharing" of variables between roles in a collection, closely related roles may need to use the same set of variables.
  * Shared defaults must be kept in sync between roles. As there are no collection-wide defaults, the defaults must be maintained in each role separately. They should be maintained in a separate file, e.g. ``defaults/main/shared.yml``.
  * Only share variable names between roles in the same collection. If there are other roles that need to use the same set of shared variables, consider if they might belong to the same collection.
* Values are quoted if they contain variables or spaces.
* Double quotes are preferred over single quotes for quoting strings,
  as they allow escape sequences such as ``\\``, ``\n``.  Single
  quotes can be used to make nested quoting more readable.
* Each variable has a description above.


Registered variables
--------------------
.. code-block:: Yaml

  ---

  - name: Task 1
    example.collection.module:
      arg1: Foo
      arg2: Bar
    register: role_register_baz

- Registered variables contains only lower letters, numbers and underlines
- The name starts with the role-name and ``_register_`` concatenated (except
  special cases, where the registered variable should overwrite default
  variables).


Linting
=======

The tool `ansible-lint <https://github.com/ansible/ansible-lint/>`_
can be used to check your playbooks, collections and roles for
compliance.  We recommend running it in a CI pipeline for all Ansible
artifacts.


vim Config
==========

For syntax highlighting there is a vim plugin on GitHub
`pearofducks/ansible-vim <https://github.com/pearofducks/ansible-vim>`_.
This plugin will also make a better indention feeling in vim with yaml.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
