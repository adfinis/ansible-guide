=============
Styling Guide
=============

YAML Syntax
===========

There is a basic guide at `ansible docs
<http://docs.ansible.com/ansible/YAMLSyntax.html>`_.
We use an indention of 2 spaces, no tabs.

Tasks
-----
::

  ---

  - name: task 1
    module:
      arg1: Foo
      arg2: Bar
      arg3: '{{ item }}'
    with_items: '{{ role_data }}'

- Each file starts with ``---`` and an empty line after that.
- Each task has an empty line above the task.
- Tasks have a name and this name contains only lower letters, numbers and
  whitespaces.
- Each argument of a module is on its own line.
- Key and value are separated by colon and whitespace.
- Values don't need to be quoted if they are single words.
- Variables are always quoted and have whitespaces around the name.
- Quoting with single quotes or double quotes is allowed, there is no
  preference.


Handler Tasks
-------------
::

  ---

  - name: handler task 1
    module:
      arg1: Foo
      arg2: {{ role_service }}

- Handlers follow the same rules as tasks.
- Each handler name must start with the role name.


Variables
---------
::

  ---

  # role_var1 description
  role_var1: 'Foo Bar'

- Variable names contain only lower letters, numbers and underlines.
- Each name starts with the rolename and an underline.
- Values are quoted if they contain variables or whitespaces.
- Quoting with single quotes or double quotes is allowed, there is no
  preference.
- Each variable has a description above.


Registered variables
--------------------
::

  ---

  - name: task 1
    module:
      arg1: Foo
      arg2: Bar
    register: role_register_baz

- Registered variables contain only lower letters, numbers and underline.
- The name starts with the rolename and ``_register_`` concatenated (except
  special cases, where the registered variable should overwrite default
  variables).


vim Config
==========

For syntax highlighting there is a vim plugin on GitHub
`pearofducks/ansible-vim <https://github.com/pearofducks/ansible-vim>`_.
This plugin will also make a better indention feeling in vim with yaml.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
