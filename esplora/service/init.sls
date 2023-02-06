# vim: ft=sls

{#-
    Starts the esplora ``prerender-server`` service and enables it at boot time.
    Has a dependency on `esplora.config`_.
#}

include:
  - .running
