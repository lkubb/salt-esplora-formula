# vim: ft=sls

{#-
    Undoes everything performed in the ``esplora`` meta-state in reverse order, i.e.
    stops the prerender-server service,
    removes the prerender-server configuration file and
    then uninstalls esplora and the prerender-server.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}


include:
{%- if esplora.nginx %}
  - .nginx.clean
{%- endif %}
{%- if esplora.nojs %}
  - .service.clean
  - .config.clean
{%- endif %}
  - .package.clean
