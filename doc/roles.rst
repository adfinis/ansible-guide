=====
ROLES
=====


::

  .
  ├── defaults/
  │   └── main.yml
  ├── files/
  │   └── etc/
  │       └── default/
  │           └── ssh
  ├── handlers/
  │   └── main.yml
  ├── meta/
  │   └── main.yml
  ├── tasks/
  │   ├── configuration.yml
  │   ├── installation.yml
  │   └── main.yml
  ├── templates/
  │   └── etc/
  │       └── ssh/
  │           └── sshd_config.j2
  └── vars/
       ├── Debian.yml
       └── RedHat.yml


Tasks
=====

The ``main.yml`` file is just used to include the other yaml files.

.. code-block:: Yaml

  ---

  - name: include os specific vars
    include_vars: '{{ item }}'
    with_first_found:
      - '{{ ansible_distribution }}_{{ ansible_distribution_major_version }}.yml'
      - '{{ ansible_os_family }}.yml'
    tags:
      - 'role::$ROLENAME'
      - 'role::$ROLENAME:install'
      - 'role::$ROLENAME:config'

  - include: installation.yml
    tags:
      - 'role::$ROLENAME'
      - 'role::$ROLENAME:install'

  - include: configuration.yml
    tags:
      - 'role::$ROLENAME'
      - 'role::$ROLENAME:config'

Role tagging helps later while running Ansible. If ``ansible-playbook`` is
called with tags, only matching tasks, else all, will be executed.

Tasks inside the ``installation.yml`` file are to install all related
packages. The related packages are stored as a variable.

.. code-block:: Yaml

  ---

  - name: install ssh related packages
    package:
      name: '{{ item }}'
      state: present
    with_items: '{{ ssh_packages }}'

Inside ``configuration.yml`` all configurations can be modified.

.. _configure ssh:

.. code-block:: Yaml

  ---

  - name: create ssh authorized keys directory
    file:
      path: /etc/ssh/authorized_keys
      state: directory
      owner: root
      group: root
      mode: 0755
      seuser: system_u
      serole: object_r
      setype: sshd_key_t
      selevel: s0

  - name: configure ssh
    template:
      src: etc/ssh/sshd_config.j2
      dest: '{{ ssh_daemon_cfg }}'
      owner: root
      group: root
      mode: 0644
      seuser: system_u
      serole: object_r
      setype: etc_t
      selevel: s0
    notify:
      - 'ssh check sshd config and restart'

Add additional tags to installation and configuration tasks if needed, but
be aware to add also the base tags like in the ``main.yml``.

Good example:

.. code-block:: Yaml

  - name: install ssh related packages
    package:
      name: '{{ item }}'
      state: present
    with_items: '{{ ssh_packages }}'
    tags:
      - 'role::$ROLENAME'
      - 'role::$ROLENAME:install'
      - 'role::$ROLENAME:packages'

Bad example:

.. code-block:: Yaml

  - name: install ssh related packages
    package:
      name: '{{ item }}'
      state: present
    with_items: '{{ ssh_packages }}'
    tags:
      - 'role::$ROLENAME:packages'


Variables
=========

Variables are used for static data, e.g. package, service and filenames.
Don't use variables for data which can change, for that use the defaults!

In the directory ``vars/`` are required at least the files

* ``Debian.yml``
* ``RedHat.yml``

If there are special variables for some operating systems, you can specify
those in the files named:

* ``Debian_7.yml``
* ``Debian_8.yml``
* ``CentOS_6.yml``
* ``CentOS_7.yml``
* ``Ubuntu_14.yml``
* ``Ubuntu_16.yml``
* ...

Each variable start with ``<rolename>_`` and the name contains only lower
case, numbers and underline ``_``.
**A comment before the variable is required!**

.. code-block:: Yaml

  ---

  # ssh related packages
  ssh_packages:
    - openssh-client
    - openssh-server

  # ssh service name
  ssh_service: ssh

  # ssh daemon binary (absolute path)
  ssh_daemon_bin: /usr/sbin/sshd

  # ssh daemon configuration file
  ssh_daemon_cfg: /etc/ssh/sshd_config

  # ssh daemon sftp server
  ssh_sftp_server: /usr/lib/openssh/sftp-server


Defaults
========

Every variable which is used inside a template or for tasks, and which is
not defined in the vars, needs to be defined as defaults.
Defaults can be used for example for cipher suites, ntp server names or
default ports.
**A comment before the variable is required!**

There is only one defaults file, called ``main.yml``.

.. code-block:: Yaml

  ---

  # a list of ssh host keys
  ssh_host_keys:
    - /etc/ssh/ssh_host_rsa_key
    - /etc/ssh/ssh_host_ed25519_key


Handlers
========

Handlers are used to check configurations and restart services. Don't
restart a service with a task, as its run every time the role is running.
The advantage of handlers is, that they must be notified by a task or even 
multiple tasks, and they run only once per playbook.
Use handlers instead of a check when a previous task has changed.

.. code-block:: Yaml

  ---

  - name: ssh check sshd config and restart
    command: '{{ ssh_daemon_bin }} -t'
    notify: [ 'ssh restart sshd' ]

  - name: ssh restart sshd
    service:
      name: '{{ ssh_service }}'
      state: restarted

This handler gets notified by a task called `configure ssh`_ it will call the
handler ``check sshd config and restart``, but only if the task has
effected a change.


Files
=====

If some static files have to be copied, they can be stored
in the directory ``files``. Files are rarely used, they are mostly replaced
with templates. E.g. a binary or a compressed file can be copied with file.

Within this directory, we rebuild the path structure of a target system. We
do not store files in a flattened directory.

Good example:

::

  ssh/
  └── files/
      └── etc/
          ├── default/
          │   └── ssh
          └── ssh/
              └── ssh_config

Bad example:

::

  ssh/
  └── files/
      ├── ssh
      └── ssh_config


Meta
====

Meta information of a role are defined here. I.e. requirements for a role.

.. code-block:: Yaml

  ---

  dependencies:
    - pki

  galaxy_info:
    author: 'Adfinis SyGroup AG'
    description: 'Install and manage ssh and sshd'
    company: 'Adfinis SyGroup AG'
    license: 'GNU General Public License v3'
    min_ansible_version: '2.0.0'
    platforms:
      - name: Archlinux
      - name: Debian
        versions:
          - wheezy
          - jessie
      - name: Ubuntu
        versions:
          - trusty
          - xenial
      - name: CentOS
        versions:
          - 6
          - 7
    galaxy_tags:
      - ssh
      - sshd


Templates
=========

Within this directory, template files are stored with a `.j2` extension as the
files are threatend as `Jinja2 <http://jinja.pocoo.org/>`_ templates. This
allows to customize files.
Templates should have a comment with ``{{ ansible_managed }}`` as the very
beginning. This generates a comment header inside the file, warning a
potential user that changes to the file may be overwritten. 

Within this directory, we rebuild the path structure of a target system. We
do not store templates in a flattened directory.

Good example:

::

  ssh/
  └── files/
      └── etc/
          ├── default/
          │   └── ssh.j2
          └── ssh/
              └── ssh_config.j2

Bad example:

::

  ssh/
  └── files/
      ├── ssh.j2
      └── ssh_config.j2


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
