.. _readme:

Esplora Block Explorer Formula
==============================

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Esplora Block Explorer for the Bitcoin and Liquid networks (by Blockstream) with Salt.

This formula manages the frontend. For the backend, see `electrs-formula <https://github.com/lkubb/salt-electrs-formula>`_ (and `bitcoin-formula <https://github.com/lkubb/salt-bitcoin-formula>`_).

The interaction between the three components needs to be configured properly. The formulae do not influence each other. Please refer to the `official docs <https://github.com/Blockstream/esplora>`_ as well, although they are sparse.

Mind that the tests are currently not implemented.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* To be able to manage the nginx configuration with this formula, custom Salt modules are necessary. You can refer to the nginx example configuration to find hints for the proper format. @TODO publish and insert link
* To run the prerender-server, the server running it needs to be able to contact the electrs backend directly. This is also true if you run the reverse proxy for the ``/api`` endpoint on the same nginx instance.
* Mind that the provided nginx configuration currently hardcodes the prerender-server to ``127.0.0.1:5001``, so it needs to run on localhost and with the default port. @TODO make this configurable

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``esplora``
^^^^^^^^^^^
This builds esplora and, if configured, the prerender-server,
manages the prerender-server configuration file and then
starts the prerender-server service.


``esplora.package``
^^^^^^^^^^^^^^^^^^^
Installs NodeJS, builds Esplora and, if configured,
the prerender-server, using a dedicated user account,
Installs prerender-server service unit file, if configured.


``esplora.config``
^^^^^^^^^^^^^^^^^^
Configures the prerender-server service.
Has a dependency on `esplora.package`_.


``esplora.service``
^^^^^^^^^^^^^^^^^^^
Starts the esplora ``prerender-server`` service and enables it at boot time.
Has a dependency on `esplora.config`_.


``esplora.nginx``
^^^^^^^^^^^^^^^^^
Makes use of my `custom nginx modules <https://github.com/lkubb/salt-nginx-formula>`_
to set up a reverse proxy to Esplora.


``esplora.clean``
^^^^^^^^^^^^^^^^^
Undoes everything performed in the ``esplora`` meta-state in reverse order, i.e.
stops the prerender-server service,
removes the prerender-server configuration file and
then uninstalls esplora and the prerender-server.


``esplora.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Removes Esplora/the prerender-server and its unit file
as well as the dedicated user account.
Has a dependency on `esplora.config.clean`_.


``esplora.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the esplora service and has a
dependency on `esplora.service.clean`_.


``esplora.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^
Stops the esplora ``prerender-server`` service and disables it at boot time.


``esplora.nginx.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Ensures Esplora is not reverse-proxied by Nginx.



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
