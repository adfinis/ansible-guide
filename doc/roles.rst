=====
Roles
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
       ├── RedHat.yml
       └── Ubuntu.yml


Tasks
=====

The ``main.yml`` file include just the other files.

.. code-block:: Yaml

  ---

  - name: include os specific vars
    include_vars: '{{ item }}'
    with_first_found:
      - '{{ ansible_distribution }}_{{ ansible_distribution_major_version }}.yml'
      - '{{ ansible_os_family }}.yml'

  - include: installation.yml
  - include: configuration.yml

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
    notify: [ 'check sshd config and restart' ]


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
