===============
Getting Started
===============


Project Repository
==================

First of all, you need a project repository. For that, you can just clone
this repository or start a new one. As a Git Submodule you should add the
`ansible-roles`_ as ``roles/``:

::

  git init
  git commit -m 'Intial commit.' --allow-empty
  git submodule add https://github.com/adfinis-sygroup/ansible-roles adfinis-roles

Create the main playbook ``site.yml`` with content along the following
example. Add your roles as needed:

::

  ---

  - hosts: all
    roles:
      - ansible
      - console
      - ssh

Create an inventory file ``hosts``, create as many hostgroups as you need. A
host can be in multiple hostgroups. Each host is in the hostgroup ``all``.

::

  www1.example.com
  www2.example.com
  db1.example.com

  [webservers]
  www1.example.com
  www2.example.com

  [mysql_servers]
  db1.example.com

  [ssh_servers]
  www1.example.com
  www2.example.com
  db1.example.com

You can now start Ansible, and Ansible will connect to each host with ssh.
If you can't login with public keys, you can use ssh controlmaster with
sockets, for that, create a file called ``ansible.cfg`` in the root of your
project directory.

::

  [defaults]
  ansible_managed     = Warning: File is managed by Ansible [https://github.com/adfinis-sygroup/ansible-roles]
  retry_files_enabled = False
  hostfile            = ./hosts
  roles_path          = ./adfinis-roles

  [ssh_connection]
  ssh_args            = -o ControlMaster=auto -o ControlPersist=30s
  #control_path       = ~/.ssh/sockets/%C

You need to create the directory ``~/.ssh/sockets`` and you should
manually establish a connection to each host (with a command like ``ssh -o
ControlMaster=auto -o ControlPath='~/.ssh/sockets/%C' -o ControlPersist=30s
-l root $FQDN``). While the connection is established (and 30 seconds
after that) a socket file in ``~/.ssh/sockets/`` is generated. Ansible will use this
socket file to connect to the hosts, and doesn't' need to reauthenticate.
This speeds up Ansible operations considerably especially with many hosts.


Run Ansible
===========

To run Ansible with your playbook and your hosts, just start
``ansible-playbook -i hosts site.yml``. If you want to know what has
changed, you can add the option ``--diff`` and if you want to know that
before you change anything, you can add ``--check``. With the checkmode
enabled, nothing gets changed on any of the systems!

As a possible way to go, start Ansible with diff and checkmode:

::

  ansible-playbook -i hosts --diff --check site.yml

If you think the changes do what you intend to do, you can start Ansible without the checkmode:

::

  ansible-playbook -i hosts --diff site.yml


Special Roles
=============

If you need new roles, which aren't created yet, create them and make a
pull-requests to the `ansible-roles`_ repository. Only generic roles will
be accepted. Follow the guidelines for new roles.

To create special roles for one project (e.g. not possible as a generic
role or never needed in another project) put them inside the directory
``roles/``. Each role in this directory will override roles in the directory
``adfinis-roles/``.


.. _ansible-roles: https://github.com/adfinis-sygroup/ansible-roles


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
