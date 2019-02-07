===================
Test Infrastructure
===================

Vagrant provides an easy way to test Ansible roles in an encapsulated
environment. It is an abstraction layer for multiple virtualisation
platforms. A possible setup is defined in the Vagrantfile inside this
repository.

There are some dependencies to test Ansible roles with vagrant:

* vagrant
* virtualbox
* internet connection
* vagrant boxes

  * `adsy-debian-7
    <https://vagrant.adfinis-sygroup.ch/adsy-debian-7.8-nonminimized.box>`_
  * `adsy-debian-8
    <https://vagrant.adfinis-sygroup.ch/adsy-debian-8.9-nonminimized.box>`_
  * `adsy-debian-9
    <https://vagrant.adfinis-sygroup.ch/adsy-debian-9.1-nonminimized.box>`_
  * `adsy-centos-6
    <https://vagrant.adfinis-sygroup.ch/adsy-centos-6.7-nonminimized.box>`_
  * `adsy-centos-7
    <https://vagrant.adfinis-sygroup.ch/adsy-centos-7.4-nonminimized.box>`_
  * `adsy-ubuntu-14
    <https://vagrant.adfinis-sygroup.ch/adsy-ubuntu-14.04-nonminimized.box>`_
  * `adsy-ubuntu-16
    <https://vagrant.adfinis-sygroup.ch/adsy-ubuntu-16.04-nonminimized.box>`_

To run the test environment use ``make test``.

Furthermore you can check your Ansible stuff with multiple linters (e.g.
ansible-lint or yamllint) and you can verify your playbooks and roles with
``ansible-playbook --syntax-check``. You'll find an example how to do that
inside the GitLab CI in the ``.gitlab-ci.yml``.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
