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

- Each file starts with ``---`` and a empty line after that.
- Each task has a empty line above the task
- Tasks have a name and this name contains only lower letters and numbers
  and whitespaces
- Each argument of a module is on their own line
- Key and value are separated by colon and whitespace
- Values don't need to be quoted if they are single words
- Variables are always quoted and have whitespaces around the name
- Quoting with single quotes or double quote

Variables
---------
::

  ---

  # role_var1 description
  role_var1: 'Foo Bar'

- Variable names contains only lower letters, numbers and underlines
- Each name starts with the rolename and an underline
- Values are quoted if they contain variables or whitespaces
- Quoting with single quotes or double quote
- Each variable has a description above


vim Config
==========

For syntax highlighting there is a vim plugin on GitHub
`pearofducks/ansible-vim <https://github.com/pearofducks/ansible-vim>`_.
This plugin will also make a better indention feeling in vim with yaml.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
