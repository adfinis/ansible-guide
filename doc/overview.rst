========
Overview
========


If you do not know what `ansible <https://www.ansible.com/>`_ is, to check the
`intro <http://docs.ansible.com/ansible/intro.html>`_ out. For general
information, chech out the
`documentation index <http://docs.ansible.com/ansible/index.html>`_.


Guideline
=========
`Best Practices
<http://docs.ansible.com/ansible/playbooks_best_practices.html>`_

Component description
---------------------

Roles
~~~~~
`Playbook Roles and Include Statements
<http://docs.ansible.com/ansible/playbooks_roles.html>`_

Playbooks
~~~~~~~~~
`Intro to Playbooks <http://docs.ansible.com/ansible/playbooks_intro.html>`_

Group Variables
~~~~~~~~~~~~~~~


Directory and file structure
============================

::

  .
  ├── README.rst
  ├── doc/
  ├── ansible.cfg
  ├── site.yml
  ├── vault-pass
  ├── defaults/
  │   └── main.yml
  ├── files/
  │   ├── file1.txt
  │   └── file2.txt
  ├── group_vars/
  │   └── all/
  │       ├── ntp.yml
  │       └── ssh.yml
  ├── host_vars/
  │   ├── www.example.com/
  │   │   ├── ntp.yml
  │   │   └── ssh.yml
  │   └── mail.example.org/
  │       ├── ntp.yml
  │       └── ssh.yml
  ├── roles/
  │   ├── ntp/
  │   │   ├── defaults/
  │   │   │   └── main.yml
  │   │   ├── files/
  │   │   ├── handlers/
  │   │   │   └── main.yml
  │   │   ├── meta/
  │   │   │   └── main.yml
  │   │   ├── tasks/
  │   │   │   ├── configuration.yml
  │   │   │   ├── installation.yml
  │   │   │   └── main.yml
  │   │   ├── templates/
  │   │   │   └── etc/
  │   │   │       └── ntp.conf.j2
  │   │   └── vars/
  │   │       ├── Debian.yml
  │   │       └── RedHat.yml
  │   └── ssh/
  │       ├── defaults/
  │       │   └── main.yml
  │       ├── files/
  │       │   └── etc/
  │       │       └── default/
  │       │           └── ssh
  │       ├── handlers/
  │       │   └── main.yml
  │       ├── meta/
  │       │   └── main.yml
  │       ├── tasks/
  │       │   ├── configuration.yml
  │       │   ├── installation.yml
  │       │   └── main.yml
  │       ├── templates/
  │       │   └── etc/
  │       │       └── ssh/
  │       │           └── sshd_config.j2
  │       └── vars/
  │            ├── Debian.yml
  │            └── RedHat.yml
  └── vars/
      ├── Debian.yml
      └── RedHat.yml

/group_vars/
------------
In this directory, the group variables are placed within files. Group variables
will overwrite defaults set by the roles themselves.

/roles
------
All roles have one directory in here.

/roles/rolea/defaults/main.yml
------------------------------
In this file, the default variables for this role are defined and set.

/roles/rolea/handlers/main.yml
------------------------------
Handlers are stored in here. These handlers allow to be triggered when
something specific is happening.

/roles/rolea/meta/main.yml
--------------------------
Meta information of a role is defined here. I.e. requirements for a role.

/roles/rolea/tasks/main.yml
---------------------------
The main tasks for this role are define within this file.

/roles/rolea/templates/
-----------------------
Within this directory, template files are stored with a `.j2` extension as the
files are threatend as `Jinja2 <http://jinja.pocoo.org/>`_ templates. This
allows to customize files

/README.md
----------
Describive readme file.

/playbooka.yml
--------------
Playbook files.


Variable Precedence
===================

This list shows different locations and their precendence of variables.
The last listed variables winning prioritization.

- role defaults (``roles/$ROLE/defaults/main.yml``)
- inventory vars (``vars/main.yml``)
- inventory group_vars (``group_vars/$HOSTGROUP/*.yml``)
- inventory host_vars (``host_vars/$FQDN/*.yml``)
- playbook group_vars (we don't make a difference to inventory group_vars)
- playbook host_vars (we don't make a difference to inventory host_vars)
- host facts (default facts of a host `Information discovered from system
  facts
  <http://docs.ansible.com/ansible/playbooks_variables.html#information-discovered-from-systems-facts>`_)
- play vars (?)
- play vars_prompt (`Prompts
  <http://docs.ansible.com/ansible/playbooks_prompts.html>`_)
- play vars_files (?)
- registered vars (`Register Variables
  <http://docs.ansible.com/ansible/playbooks_conditionals.html#register-variables>`_)
- set_facts (`Module set_fact
  <http://docs.ansible.com/ansible/set_fact_module.html>`_)
- role and include vars (``roles/$ROLE/vars/main.yml``)
- block vars (only for tasks in block; `Blocks
  <http://docs.ansible.com/ansible/playbooks_blocks.html>`_)
- task vars (only for the task)
- extra vars (always win precedence; ``ansible --extra-vars='foo=bar'``)

We don't use all of the above locations, mostly the following locations are
used.

- role defaults (``roles/$ROLE/defaults/main.yml``)
- inventory group_vars (``group_vars/$HOSTGROUP/*.yml``)
- inventory host_vars (``host_vars/$FQDN/*.yml``)
- host facts (default facts of a host `Information discovered from system
  facts
  <http://docs.ansible.com/ansible/playbooks_variables.html#information-discovered-from-systems-facts>`_)
- registered vars (`Register Variables
  <http://docs.ansible.com/ansible/playbooks_conditionals.html#register-variables>`_)
- set_facts (`Module set_fact
  <http://docs.ansible.com/ansible/set_fact_module.html>`_)
- role and include vars (``roles/$ROLE/vars/main.yml``)
- task vars (only for the task)


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
