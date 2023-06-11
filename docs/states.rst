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


