===================
Roles & Collections
===================


General Organization
====================

* We recommend to generally keep a strict separation between roles and
  collections on the one hand and playbook, inventory and host vars on
  the other hand.  This makes it easier to reuse roles at a later
  time.  Another advantage of this strict separation is that roles and
  collections can later on be published as open source without risking
  the exposure of sensitive customer data.
* We also recommend to put each role or collection into its on Git
  repository. Again, this makes reuse easier.
* We generally recommend to prefer collections over single-role
  repositories.  While there is no official "don't use single-role
  repos" announcement yet, and they won't go away for a long time,
  they for example are not supported in Ansible Automation Hub.


Roles
=====

The following recommendations apply to both roles within collections
as well as single-role repositories.


::

  .
  ├── defaults/
  │   └── main.yml
  ├── files/
  │   └── etc/
  │       └── default/
  │          └── ssh
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
-----

The ``main.yml`` file is just used to include the other YAML files.

.. code-block:: Yaml

  ---

  - name: Include OS-specific vars
    ansible.builtin.include_vars: "{{ item }}"
    with_first_found:
      - "{{ ansible_facts.distribution }}_{{ ansible_facts.distribution_major_version }}.yml"
      - "{{ ansible_facts.os_family }}.yml"
    tags:
      - "role::sshd"
      - "role::sshd:install"
      - "role::sshd:config"

  - name: Install SSH server
    ansible.builtin.import_tasks: install.yml
    tags:
      - "role::sshd"
      - "role::sshd:install"

  - name: Configure SSH server
    ansible.builtin.import_tasks: config.yml
    tags:
      - "role::sshd"
      - "role::sshd:config"

Role tagging helps later while running Ansible. When ``ansible-playbook`` is
called with tags, only matching tasks will be executed.

The actual tasks are split up into individual logical units, each
within one task file.  The example above e.g. splits the tasks into
installation and configuration components.  Tasks inside the
``installation.yml`` file are to install all related packages:

.. code-block:: Yaml

  ---

  - name: Install SSH-related packages
    ansible.builtin.package:
      name: "{{ ssh_packages }}"
      state: present

The configuration files are rendered in ``configuration.yml``:

.. code-block:: Yaml

  ---

  - name: Create SSH authorized_keys directory
    ansible.builtin.file:
      path: /etc/ssh/authorized_keys
      state: directory
      owner: root
      group: root
      mode: "0755"
      seuser: system_u
      serole: object_r
      setype: sshd_key_t
      selevel: s0

  - name: Configure SSHd
    ansible.builtin.template:
      src: etc/ssh/sshd_config.j2
      dest: "{{ ssh_daemon_cfg }}"
      owner: root
      group: root
      mode: "0644"
      seuser: system_u
      serole: object_r
      setype: etc_t
      selevel: s0
      validate: "{{ ssh_daemon_bin }} -t -f %s"
    notify:
      - Restart sshd

Add additional tags to installation and configuration tasks if needed, but
be aware to add also the base tags like in the ``main.yml``.

Good example:

.. code-block:: Yaml

  - name: Install SSH related packages
    ansible.builtin.package:
      name: "{{ ssh_packages }}"
      state: present
    tags:
      - "role::sshd"
      - "role::sshd:install"
      - "role::sshd:packages"

Bad example:

.. code-block:: Yaml

  - name: Install SSH related packages
    ansible.builtin.package:
      name: "{{ ssh_packages }}"
      state: present
    tags:
      - "role::sshd:packages"


Variables
---------

Variables are used for static data, e.g. package-, service- and filenames.
Don't use variables for data which can change, for that use the defaults!

The variables stored in ``vars/`` can be loaded dynamically.  This can
be used to e.g. load OS-dependent variables.  The example above uses
this to load the ``ssh_packages`` variable dependent on the
``os_family`` host fact.

To achieve this, you put the variables into files named after ``os_family`` inside the ``vars/`` directory:

* ``Debian.yml``
* ``RedHat.yml``

If there are special variables for some operating systems, you can specify
those in the files named:

* ``Debian_11.yml``
* ``Debian_12.yml``
* ``CentOS_7.yml``
* ``CentOS_8.yml``
* ``CentOS_9.yml``
* ``Ubuntu_20.yml``
* ``Ubuntu_22.yml``
* ...

Each variable name start with ``<rolename>_`` and the name contains only lower
case, numbers and underline ``_``:

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
--------

Every variable which is used inside a template or for tasks, and which
is not defined in the vars, needs to be defined as defaults.  If there
is no reasonable default value, the README should make it clear that
the value must be provided via host vars.  Defaults can be used for
example for cipher suites, ntp server names or default ports.

There is only one defaults file, called ``main.yml``.

.. code-block:: Yaml

  ---

  # a list of ssh host keys
  ssh_host_keys:
    - /etc/ssh/ssh_host_rsa_key
    - /etc/ssh/ssh_host_ed25519_key


Handlers
--------

Handlers are used to perform additional tasks required to apply
changed configuration, such as restarting services.  That way a
service does not get restarted with every playbook run, but only when
only required. Another advantage of handlers is that they can be
notified by multiple tasks, yet only get executed once per playbook
run.  Use handlers instead of a check when a previous task has
changed.

.. code-block:: Yaml

  ---

  - name: Restart sshd
    ansible.builtin.service:
      name: "{{ ssh_service }}"
      state: restarted

This handler gets notified by a task called ``Configure SSHd``. it
will call the handler ``Restart SSHd``, but only if the task has
effected a change.


Files
-----

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
----

Meta information of a role are defined here. I.e. requirements for a role.

.. code-block:: Yaml

  ---

  dependencies:
    - role: pki

  galaxy_info:
    author: 'Adfinis AG'
    description: 'Install and manage ssh and sshd'
    company: 'Adfinis AG'
    license: 'GNU General Public License v3'
    min_ansible_version: '2.0.0'
    platforms:
      - name: Archlinux
      - name: Debian
        versions:
          - wheezy
          - jessie
          - stretch
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
---------

Within this directory, template files are stored with a `.j2` extension as the
files are treated as `Jinja2 <http://jinja.pocoo.org/>`_ templates. This
allows to customize files.

Templates should have a comment with ``{{ ansible_managed }}`` as the
very beginning. This generates a comment header inside the file,
warning a potential user that changes to the file may be overwritten.
We recommend to use ``{{ ansible_managed | comment }}`` rather than
``# {{ ansible_managed }}``, as the latter does not work with
multiline ansible_managed comments.  For customization of the comment,
check out the `documentation of the comment filter
<https://docs.ansible.com/ansible/latest/collections/ansible/builtin/comment_filter.html>`_.

If possible, validate the template before copying it into place. This will
guarantee that configuration will work after restarting the corresponding
service.

Good example:

.. code-block:: Yaml

  ---

  - name: Configure the ssh daemon
    ansible.builtin.template:
      src: etc/ssh/sshd_config.j2
      dest: "{{ ssh_daemon_cfg }}"
      owner: root
      group: root
      mode: 0644
      seuser: system_u
      serole: object_r
      setype: etc_t
      selevel: s0
      validate: "{{ ssh_daemon_bin }} -t -f %s"
    notify:
      - "Restart SSHd"

If not a single configuration file is used and it isn't possible to validate
the configuration file, then do it with a handler which checks the
configuration before calling another handler which will restart the service.

Within this directory, we rebuild the path structure of a target system. We
do not store templates in a flattened directory.

Good example:

::

  ssh/
  └── templates/
      └── etc/
          ├── default/
          │   └── ssh.j2
          └── ssh/
              └── ssh_config.j2

Bad example:

::

  ssh/
  └── templates/
      ├── ssh.j2
      └── ssh_config.j2


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
