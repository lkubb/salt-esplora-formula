# vim: ft=sls

{#-
    Installs NodeJS, builds Esplora and, if configured,
    the prerender-server, using a dedicated user account,
    Installs prerender-server service unit file, if configured.
#}

include:
  - .install
