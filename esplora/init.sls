# vim: ft=sls

{#-
    This builds esplora and, if configured, the prerender-server,
    manages the prerender-server configuration file and then
    starts the prerender-server service.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}

include:
  - .package
{%- if esplora.nojs %}
  - .config
  - .service
{%- endif %}
{%- if esplora.nginx %}
  - .nginx
{%- endif %}
