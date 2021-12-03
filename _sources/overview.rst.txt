========
Overview
========


If you don't know what `ansible <https://www.ansible.com/>`_ is, check out the
`intro <http://docs.ansible.com/ansible/intro.html>`_.  For general
information, check out the
`documentation index <http://docs.ansible.com/ansible/index.html>`_.


Directory and file structure
============================
The Ansible Project publishes a `Best Practices
<http://docs.ansible.com/ansible/playbooks_best_practices.html>`_
our guideline is an extension to that guide.

::

  .
  ├── README.rst
  ├── doc/
  ├── ansible.cfg
  ├── hosts
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
  ├── adfinis-roles/
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


Inventory
=========
The file ``hosts`` in the project directory contains a list of each server,
if needed with the depending connection information.

::

  jumphost.example.com

  [webservers]
  www1.example.com  ansible_host=192.0.2.50 ansible_port=2222 ansible_user=root
  www2.example.com

  [databases]
  db-[0:9].example.com

You can define groups of hosts with ``[]``. There is a group called ``all``,
each server in the hosts file is automatically in that group! Hostgroups can be used to
define special roles only for one hostgroup or to define some special
variables for this group.


Task structure
==============
- Playbooks
    A playbook is a set of roles. For each playbook it can be defined in which
    hostgroup it should be run, default is [all].
    `Intro to Playbooks
    <http://docs.ansible.com/ansible/playbooks_intro.html>`_
- Roles
    Each role configures one application and consists of multiple tasks.
    `Playbook Roles and Include Statements
    <http://docs.ansible.com/ansible/playbooks_roles.html>`_
- Tasks
    Each tasks uses one module (e.g. template, file, copy, service).


Variable structure
==================
- roles/$ROLE/defaults/main.yml
    Each variable in a role should have a default value. Default values are
    specified in this file.
- roles/$ROLE/vars/\*.yml
    We use multiple variable files per role. Define only constant data here,
    like package names. Store all data here not in the tasks.
- group_vars/$HOSTGROUPS/\*.yml
    Each host can be in multiple hostgroups, create hostgroups as many as
    you need and as few as possible. Possible variables per hostgroup
    could be ntp servers per datacenter or nameservers per net.
- host_vars/$FQDN/\*.yml
    Host specific data, e.g. webserver virtualhost configurations or ip
    configuration.


Variable Precedence
===================
This list shows different locations and their precendence of variables.
The last valid rule has winning prioritization.

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


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
