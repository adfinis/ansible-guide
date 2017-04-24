===================
Test Infrastructure
===================

Vagrant provides an easy way to test Ansible roles in an encapsulated
environment. Vagrant is an abstraction layer for multiple virtualisation
platforms. A possible setup is defined in the Vagrantfile inside this
repository.

There are some dependencies to test Ansible roles with vagrant:

* vagrant
* virtualbox
* internet connection
* vagrant boxes

  * adsy-debian-7
  * adsy-debian-8
  * adsy-centos-6
  * adsy-centos-7
  * adsy-ubuntu-14
  * adsy-ubuntu-16

To run the test environment use ``make test``.

Furthermore you can check your Ansible stuff with multiple linters (e.g.
ansible-lint or yamllint) and you can verify your playbooks and roles with
``ansible-playbook --syntax-check``. You'll find an example how to do that
inside the GitLab CI in the ``.gitlab-ci.yml``.


.. vim: set spell spelllang=en foldmethod=marker sw=2 ts=2 et wrap tw=76 :
