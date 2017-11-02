=============
ANSIBLE GUIDE
=============

.. image:: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg?style=flat-square
  :target: https://github.com/adfinis-sygroup/ansible-guide/blob/master/LICENSE

This repository provides an example project for the Ansible roles of
Adfinis SyGroup AG. In additional, it contains a guide to Ansible, written
with `Sphinx Documentation`_.

`Documentation`_ is available here.

Ansible Guide status:

.. image:: https://img.shields.io/travis/adfinis-sygroup/ansible-guide.svg?style=flat-square
  :target: https://github.com/adfinis-sygroup/ansible-guide

Ansible Roles status:

.. image:: https://img.shields.io/travis/adfinis-sygroup/ansible-roles.svg?style=flat-square
  :target: https://github.com/adfinis-sygroup/ansible-roles


BUILD THE DOCUMENTATION
=======================
To build the documentation, which is provided with this repository, you need
to install `Sphinx Documentation`_.


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


REFERENCE
=========

* reStructuredText_


.. _Documentation: https://docs.adfinis-sygroup.ch/public/ansible-guide/
.. _Sphinx Documentation: http://www.sphinx-doc.org/
.. _reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html


.. vim: set ft=rst sw=2 ts=2 et wrap tw=76:
