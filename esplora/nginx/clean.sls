# vim: ft=sls

{#-
    Ensures Esplora is not reverse-proxied by Nginx.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Esplora is not served by nginx:
  nginx.site_absent:
    - name: esplora
