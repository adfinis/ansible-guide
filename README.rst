=============
ANSIBLE GUIDE
=============

This repository provides an example project with the ansible roles of
Adfinis SyGroup AG. In additional, it contains a guide to ansible, written
with Sphinx-doc_.

ansible-guide status:

.. image:: https://git.adfinis-sygroup.ch/ad-sy/ansible-guide.doc/badges/master/build.svg
  :target: https://git.adfinis-sygroup.ch/ad-sy/ansible-guide.doc/commits/master

ansible-roles status:

.. image:: https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src/badges/master/build.svg
  :target: https://git.adfinis-sygroup.ch/ad-sy/ansible-roles.src/commits/master


BUILD THE DOCUMENTATION
=======================
To build the documentation, which is provided with this repository, you need
to install Sphinx-doc_.


TEST ENVIRONMENT
================
Beyond the documentation this repository is also an example project and test
environment. To use the test environment, there are some dependencies:

* vagrant
* vagrant boxes
  * adsy-debian-7
  * adsy-debian-8
  * adsy-centos-6
  * adsy-centos-7
  * adsy-ubuntu-14
  * adsy-ubuntu-16

To run the test environment use ``make test``.


REFERENCE
=========

* reStructuredText_


.. _Sphinx-doc: http://www.sphinx-doc.org/
.. _reStructuredText: http://docutils.sourceforge.net/docs/user/rst/quickref.html


.. vim: set ft=rst sw=2 ts=2 et wrap tw=76:
