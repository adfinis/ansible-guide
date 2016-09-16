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
----------------------------

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
  │   │       ├── RedHat.yml
  │   │       └── Ubuntu.yml
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
  │            ├── RedHat.yml
  │            └── Ubuntu.yml
  └── vars/
      ├── Debian.yml
      ├── RedHat.yml
      └── Ubuntu.yml


/group_vars/
~~~~~~~~~~~~
In this directory, the group variables are placed within files. Group variables
will overwrite defaults set by the roles themselves.

/roles
~~~~~~
All roles have one directory in here.

/roles/rolea/defaults/main.yml
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In this file, the default variables for this role are defined and set.

/roles/rolea/handlers/main.yml
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Handlers are stored in here. These handlers allow to be triggered when
something specific is happening.

/roles/rolea/meta/main.yml
~~~~~~~~~~~~~~~~~~~~~~~~~~
Meta information of a role is defined here. I.e. requirements for a role.

/roles/rolea/tasks/main.yml
~~~~~~~~~~~~~~~~~~~~~~~~~~~
The main tasks for this role are define within this file.

/roles/rolea/templates/
~~~~~~~~~~~~~~~~~~~~~~~
Within this directory, template files are stored with a `.j2` extension as the
files are threatend as `Jinja2 <http://jinja.pocoo.org/>`_ templates. This
allows to customize files

/README.md
~~~~~~~~~~
Describive readme file.

/playbooka.yml
~~~~~~~~~~~~~~
Playbook files.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et nowrap tw=76 :
