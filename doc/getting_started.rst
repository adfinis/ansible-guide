===============
Getting Started
===============


Project Repository
==================

First of all, you need a project repository.  For this, simply create
a directory and run ``git init``, or create a new project on the git
forge of your choice and clone the repository.

Now, let's configure Ansible.  For this, create a file named
``ansible.cfg`` in your project's root directory:

.. code-block:: ini

   [defaults]
   # Path to the default inventory file
   inventory=inventory
   # By default, roles and collections from Ansible Galaxy are installed to ~/.ansible.  To prevent conflicts
   # between different versions, it can be useful to change this to another path.  Also add to gitignore!
   collections_path=./galaxy
   roles_path=./galaxy/ansible_roles
 
   # The ansible_managed header used in templates can be multi-line; following lines need to be indented.
   # Use multi-line headers with caution when using roles where you don't know how ansible_managed
   # is used in templates.
   ansible_managed = This file is managed by Ansible.  Manual changes will be overwritten.
   Ansible repository: https://git.example.org/example/project


The next step is to create an inventory file, ``inventory``,
containing the hosts and groups of your infrastructure.  Create as
many host groups as you need.  A host can be in multiple groups,
and groups can contain other groups. Each host is automatically added
to the the group ``all``.

.. code-block:: ini

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


Next, you declare which roles and collections you need to use.  Roles
and collections installed from `Ansible Galaxy <https://galaxy.ansible.com>`_
must be listed in the ``requirements.yml`` file:

.. code-block:: yaml

  ---

  collections:

    # A collection installed from Ansible Galaxy
    - name: community.general
      version: "7.3.0"

    # A collection installed directly from a git repository
    - name: https://git.example.org/example/ansible-collection-foo
      type: git
      version: "main"  # Name of the branch or tag

  roles:

    # A single role installed from Ansible Galaxy
    - name: adfinis.users
      version: "0.3.0"


These dependencies can be installed using the ``ansible-galaxy`` command:

::

   ansible-galaxy install -r requirements.yml


To assign these roles to hosts, create a playbook; let's name it ``playbook.yml``:

.. code-block:: yaml

  ---

  - hosts: all
    roles:
      - adfinis.users

  - hosts: webservers
      - community.general.redis
      - example.foo.bar


Most roles require additional configuration.  This can be provided
both on a per-host and per-group basis.  While the exact filename does
not matter, we recommend putting the host vars of a role into
``host_vars/<hostname>/<rolename>.yml`` and group vars into
``group_vars/<groupname>/<rolename>.yml``.

For example, let's create ``group_vars/all/users.yml``:

.. code-block:: yaml
   
   ---
   
   users_default_user: adfinis
   
   users_adfinis:
     - username: adfinis
     - username: customer


Run Ansible
===========

To run Ansible with your playbook and your hosts, just start
``ansible-playbook playbook.yml``. If you want to know what has
changed, you can add the option ``--diff`` and if you want to know
that before you change anything, you can add ``--check``. With check
mode enabled, nothing gets changed, but the diff of what WOULD be
changed is printed.

As a possible way to go, start Ansible with diff and checkmode:

::

  ansible-playbook playbook.yml --diff --check

If you think the changes do what you intend to do, you can start
Ansible without check mode:

::

  ansible-playbook playbook.yml --diff


Write Roles & Collections
=========================

You will most likely run into a situation where existing roles and
collections don't match your needs rather quickly.

Under :ref:`roles_collections:Roles & Collections` we provide a
guide and best practices for writing new roles and collections.

.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
