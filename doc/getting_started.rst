===============
Getting Started
===============


Project Repository
==================

First of all, you need a project repository. For that, you can just clone
this repository or start a new one. As Git Submodule you should add the
ansible-roles.src_ as ``roles/``:

::

  git init
  git commit -m 'Intial commit.' --allow-empty
  git submodule add https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src roles

Create the main playbook ``site.yml`` with content like the following, add
your roles as needed:

::

  ---

  - hosts: all
    roles:
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

You can now start ansible, and ansible will connect to each host with ssh.
If you can't login with public keys, you can use ssh controlmaster with
sockets, for that, add a file ``ansible.cfg``.

::

  [defaults]
  connection      = ssh
  hostfile        = ./hosts
  ansible_managed = Warning: File is managed by Ansible [https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src]
  roles_path      = ./roles

  [ssh_connection]
  ssh_args = -o ControlMaster=auto -o ControlPersist=30s -o ControlPath=~/.ssh/sockets/%C

You need to create the directory ``~/.ssh/sockets/%C`` and you should
manually establish a connection to each host (with a command like ``ssh -o
ControlMaster=auto -o ControlPath='~/.ssh/sockets/%C' -o ControlPersist=30s
-l root $FQDN``). While the connection is established (and 30 seconds
longer) there is a socket file in ``~/.ssh/sockets/``, ansible will use this
socket file to connect to the hosts, and ansible don't need a login with
public keys anymore.

**Important:** please don't add the ``ansible.cfg`` to the git repository.
Not everybody use a ssh controlmaster and not everybody use the same
directory for the controlmaster sockets!


Run Ansible
===========

To run ansible with your playbook and your hosts, just start
``ansible-playbook -i hosts site.yml``. If you want to know what has
changed, you can add the option ``--diff`` and if you want to know that
before you change anything, you can add ``--check``. With the checkmode
enabled, nothing get changed on your system!

As a possible way to go, start ansible with diff and checkmode:

::

  ansible-playbook -i hosts --diff --check site.yml

If you think the changes are well, you can start ansible without checkmode:

::

  ansible-playbook -i hosts --diff site.yml


Special Roles
=============

If you need some roles, which aren't created yet, create them and make a
pull-request to the ansible-roles.src_ repository.

Special roles for some special projects shouldn't be created. But if you
think this is that what you need, then you have to fork the
ansible-roles.src_.


.. _ansible-roles.src: https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
