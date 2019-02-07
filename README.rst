=============
Ansible Guide
=============

.. image:: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg?style=flat-square
  :target: https://github.com/adfinis-sygroup/ansible-guide/blob/master/LICENSE
.. image:: https://img.shields.io/travis/adfinis-sygroup/ansible-guide/master.svg?style=flat-square
  :target: https://travis-ci.org/adfinis-sygroup/ansible-guide

This repository contains the Ansible guidelines and best practices used by
Adfinis SyGroup. The documentation is written with `Sphinx`_.

In addition it includes the README and default values of all Ansible roles
available in the Adfinis SyGroup Galaxy namespace.

The rendered `documentation`_ is available here.

Build
=====
To build the documentation, which is provided with this repository, you need
to install `Sphinx`_.


TEST ENVIRONMENT
================
Beyond the documentation this repository is also an example project and test
environment. To use the test environment, there are some dependencies:

* vagrant
* virtualbox
* internet connection
* vagrant boxes

  * adsy-debian-7
  * adsy-debian-8
  * adsy-debian-9
  * adsy-centos-6
  * adsy-centos-7
  * adsy-ubuntu-14
  * adsy-ubuntu-16

To run the test environment use ``make test``.


References
==========

* reStructuredText_


.. _documentation: https://docs.adfinis-sygroup.ch/public/ansible-guide/
.. _Sphinx: http://www.sphinx-doc.org/
.. _reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html


.. vim: set ft=rst sw=2 ts=2 et wrap tw=76:
