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
* We also recommend to put each role or collection into its own Git
  repository. Again, this makes reuse easier.
* We generally recommend to prefer collections over single-role
  repositories.  While there is no official "don't use single-role
  repos" announcement yet, and they won't go away for a long time,
  they for example are not supported in Ansible Automation Hub.


Roles
=====

The following recommendations apply to both roles within collections
as well as single-role repositories.

A new role with all its boilerplate can be created using the command
``ansible-galaxy role init <rolename>``.  This can be used both within
the ``roles/`` folder of a collection and for a standalone role
repository.


Role Directory Layout
---------------------

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
  │   ├── config.yml
  │   ├── install.yml
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

We use ``main.yml`` only to import other YAML files and to assign tags to the imported tasks:

.. code-block:: Yaml

  ---

  - name: Include OS-specific vars
    ansible.builtin.include_vars: "{{ item }}"
    with_first_found:
      - "{{ ansible_facts.distribution }}_{{ ansible_facts.distribution_major_version }}.yml"
      - "{{ ansible_facts.distribution }}.yml"
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
called with ``--tags``, only matching tasks will be executed.

The actual tasks are split up into individual logical units, each
within one task file.  The example above e.g. splits the tasks into
installation and configuration components.  Tasks inside the
``install.yml`` file are used to install all related packages:

.. code-block:: Yaml

  ---

  - name: install | Install SSH-related packages
    ansible.builtin.package:
      name: "{{ sshd_packages }}"
      state: present

The configuration files are rendered in ``config.yml``:

.. code-block:: Yaml

  ---

  - name: config | Create SSH authorized_keys directory
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

  - name: config | Configure SSHd
    ansible.builtin.template:
      src: etc/ssh/sshd_config.j2
      dest: "{{ sshd_daemon_cfg }}"
      owner: root
      group: root
      mode: "0644"
      seuser: system_u
      serole: object_r
      setype: etc_t
      selevel: s0
      validate: "{{ sshd_daemon_bin }} -t -f %s"
    notify:
      - Restart sshd

If necessary, you can add additional tags to individual tasks inside
the imported files.  However, since this ad-hoc tag list overrides the
one defined in ``main.yml``, you must also provide all the tags from
``main.yml`` again for the single task:

Good example:

.. code-block:: Yaml

  - name: install | Install SSH related packages
    ansible.builtin.package:
      name: "{{ sshd_packages }}"
      state: present
    tags:
      # This tag is added only for this task
      - "role::sshd:packages"
      # These two tags must  be provided again, as the tag list from main.yml is overwritten by this tag list.
      - "role::sshd"
      - "role::sshd:install"

Bad example:

.. code-block:: Yaml

  - name: install | Install SSH related packages
    ansible.builtin.package:
      name: "{{ sshd_packages }}"
      state: present
    tags:
      - "role::sshd:packages"

This task is no longer executed when run via ``--tags role::sshd``.

Variables
---------

Variables in ``vars/`` are used for static data, e.g. package-, service-
and filenames.  Only use ``vars/`` for data that does not change on a
host-by-host basis, for that use the defaults!

The variables stored in ``vars/`` can be loaded dynamically.  This can
be used to e.g. load OS-dependent variables.  The example above uses
this to load the ``ssh_packages`` variable dependent on the
``os_family`` and ``distribution`` host fact.
Common fact examples can be found in 
`<Commonly-used facts https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#commonly-used-facts>`.

To achieve this, you put the variables into files named after ``os_family`` inside the ``vars/`` directory:

* ``Debian.yml``
* ``RedHat.yml``

Some distributions share the same ``os_family`` (for example Ubuntu has
"Debian" as its ``os_family``), while working vastly different.

For such cases you can create a dedicated vars file for this
distribution if the values from ``os_family`` are not applicable for
this distribution. For example:

* ``Fedora.yml``
* ``Ubuntu.yml``

If there are special variables for some operating system versions, you can specify
those in the files named:

* ``Debian_11.yml``
* ``Debian_12.yml``
* ``CentOS_7.yml``
* ``CentOS_8.yml``
* ``CentOS_9.yml``
* ``Ubuntu_20.yml``
* ``Ubuntu_22.yml``
* ...

This logic is implemented using the ``with_first_found`` iterator in
the example above.  For more information, check out the documentation
on `Loops <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html>`_.
  
By our convention, each variable name start with ``<rolename>_`` and
the name contains only lower case letters, numbers and underline
``_``:

.. code-block:: Yaml

  ---

  # ssh related packages
  sshd_packages:
    - openssh-client
    - openssh-server

  # ssh service name
  sshd_service: ssh

  # ssh daemon binary (absolute path)
  sshd_daemon_bin: /usr/sbin/sshd

  # ssh daemon configuration file
  sshd_daemon_cfg: /etc/ssh/sshd_config

  # ssh daemon sftp server
  sshd_sftp_server: /usr/lib/openssh/sftp-server


Defaults
--------

Every variable which is used inside a template or for tasks, and which
is not defined in the vars, needs to be defined as defaults.  If there
is no reasonable default value, the README should make it clear that
the value must be provided via host vars.  Defaults can be used for
example for default ports and hostnames (e.g. binding a service to
`localhost:80` unless overwritten via host vars).

There is only one defaults file, called ``main.yml``:

.. code-block:: Yaml

  ---

  # The ports to bind sshd on
  sshd_ports:
    - 22

  # a list of ssh host keys
  sshd_host_keys:
    - /etc/ssh/ssh_host_rsa_key
    - /etc/ssh/ssh_host_ed25519_key


Handlers
--------

Handlers are used to perform additional tasks required to apply
changed configuration, such as restarting services.  That way a
service does not get restarted with every playbook run, but only when
required. Another advantage of handlers is that they can be notified
by multiple tasks, yet only get executed once per playbook run..

.. code-block:: Yaml

  ---

  - name: Restart SSHd
    ansible.builtin.service:
      name: "{{ sshd_service }}"
      state: restarted

This handler gets notified by a task called ``Configure SSHd``. it
will call the handler ``Restart SSHd``, but only if the task has
effected a change.

Using handlers should always be preferred over implementing your own
conditional restart logic, unless the restart requires additional
logic that can't be covered by handlers.

Bad example:

.. code-block:: Yaml

  ---

  - name: Render /etc/ssh/sshd_config
    ansible.builtin.template: ...
    register: sshd_register_sshd_config

  - name: Restart SSHd
    ansible.builtin.service:
      name: "{{ sshd_service }}"
      state: restarted
    when: "{{ sshd_register_sshd_config.changed }}"


Files
-----

If some static files have to be copied, they can be stored
in the directory ``files/``.

Within this directory, we rebuild the path structure of a target system. We
do not store files in a flattened directory:

Good example:

::

  sshd/
  └── files/
      └── etc/
          ├── default/
          │   └── ssh
          └── ssh/
              └── sshd_config

Bad example:

::

  sshd/
  └── files/
      ├── ssh
      └── sshd_config

We usually only use ``files/`` for binary files, e.g. executables or
archives.  Most text files would usually go into ``templates/``
instead (see below); even if you don't need to put any dynamic content
into a text file, we recommend to use a template and add an
``{{ ansible_managed | comment }}`` header whenever possible.


Templates
---------

Within this directory, template files are stored with a ``.j2``
extension as the files are treated as `Jinja
<https://jinja.palletsprojects.com/en/3.1.x/>`_ templates. This allows
file contents to be modified based on Ansible variables, host vars and
system facts.

Templates should have a comment with ``{{ ansible_managed |
comment }}`` at the very beginning.  This generates a comment header
inside the file, warning a potential user that changes to the file may
be overwritten.  We recommend to use ``{{ ansible_managed | comment
}}`` rather than ``# {{ ansible_managed }}``, as the latter does not
work with multiline ansible_managed comments.  For customization of
the comment, check out the `documentation of the comment filter
<https://docs.ansible.com/ansible/latest/collections/ansible/builtin/comment_filter.html>`_.

If possible, validate the template before copying it into place. This
will guarantee that configuration will work after restarting the
corresponding service.  A lot of daemon binaries come with a config
test flag intended for exactly this purpose.

Good example:

.. code-block:: Yaml

  ---

  - name: config | Configure the ssh daemon
    ansible.builtin.template:
      src: etc/ssh/sshd_config.j2
      dest: "{{ sshd_daemon_cfg }}"
      owner: root
      group: root
      mode: 0644
      seuser: system_u
      serole: object_r
      setype: etc_t
      selevel: s0
      validate: "{{ sshd_daemon_bin }} -t -f %s"
    notify:
      - "Restart SSHd"

Within the ``template/`` directory, we rebuild the path structure of a target system. We
do not store templates in a flattened directory.

Good example:

::

  sshd/
  └── templates/
      └── etc/
          ├── default/
          │   └── ssh.j2
          └── ssh/
              └── sshd_config.j2

Bad example:

::

  sshd/
  └── templates/
      ├── ssh.j2
      └── sshd_config.j2


      

Meta
----

The file ``meta/main.yml`` contains metadata about a role.  For
standalone roles, this file is required in order to be submitted to
Ansible Galaxy.  For roles in a collection, this file is optional, but
recommmended.

.. code-block:: Yaml

  ---

  galaxy_info:
    author: 'Adfinis AG'
    description: 'Install and manage sshd'
    company: 'Adfinis AG'
    license: GPL-3.0-only
    min_ansible_version: 2.10
    platforms:
      - name: Debian
        versions:
          - buster
          - bullseye
          - bookworm
      - name: Ubuntu
        versions:
          - jammy
          - lunar
          - mantic
      - name: CentOS
        versions:
          - 7
          - 8
          - 9
    galaxy_tags:
      - ssh
      - sshd

  # The roles listed here are automatically applied before applying this role.
  dependencies:
    - role: adfinis.linux


Collections
===========

Collections are the new format for packaging roles, plugins, playbooks
and other Ansible artifacts.

For more in-detail information, please refer to the upstream
documentation: `Developing collections
<https://docs.ansible.com/ansible/3/dev_guide/developing_collections.html>`_.

A new collection can be created using the command ``ansible-galaxy
collection init <namespace>.<collection>``.  The collection will be
created in the directory ``./<namespace>/<collection/``.

We also provide a Github template for Ansible collection repositories,
which comes with a CI pipeline for `ansible-lint` and automated
release to Ansible Galaxy: `adfinis/ansible-collection-template
<https://github.com/adfinis/ansible-collection-template>`_.

Artifacts in a collection should always be referred to by their FQCN
(fully-qualified collection name) consisting of
``<namespace>.<collection>.<artifact>``.  For example, the role
``sshd`` in the collection ``adfinis.linux`` is referred to as
``adfinis.linux.sshd``.  The same applies to other artifacts such as
plugins or playbooks as well.

Collection Directory Layout
---------------------------

::

  .
  ├── docs/
  ├── galaxy.yml
  ├── meta/
  │   └── runtime.yml
  ├── plugins/
  │   ├── callback/
  │   ├── inventory/
  │   └── modules/
  │       └── example.py
  ├── README.md
  ├── roles/
  │   ├── sshd/
  │   └── pki/
  ├── playbooks/
  │   ├── playbook.yml
  │   ├── templates/
  │   └── tasks/
  └── tests/


galaxy.yml
----------

The ``galaxy.yml`` file at the root of your collection contains the
metadata required in order to publish your collection to Ansible
Galaxy:

.. code-block:: Yaml

  ---
  namespace: adfinis
  name: linux
  version: "1.0.0"
  readme: README.md
  authors:
    - Adfinis AG <support@adfinis.com>
  repository: http
  description: Collection of roles for basic configuration of a Linux server
  license: GPL-3.0-only
  tags:
    - linux
  dependencies:
    community.general: "7.5.0"
    community.crypto: "2.15.1"
  repository: https://github.com/adfinis/linux
  documentation: https://adfinis.github.io/...
  homepage: https://adfinis.com
  issues: https://github.com/adfinis/linux/issues
  build_ignore: []

meta/runtime.yml
----------------

Usually this file only contains one entry: Which Ansible version is required to use this collection:

.. code-block:: Yaml

  ---
  requires_ansible: ">=2.10.0"

.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
