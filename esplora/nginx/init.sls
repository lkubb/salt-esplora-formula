# vim: ft=sls

{#-
    Makes use of my `custom nginx modules <https://github.com/lkubb/salt-nginx-formula>`_
    to set up a reverse proxy to Esplora.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Nginx is installed:
  pkg.installed:
    - name: {{ esplora.lookup.requirements.nginx }}

Esplora is served by nginx:
  nginx.site:
    - name: esplora
    - source: {{ files_switch(
                    ["nginx.conf", "nginx.conf.j2"],
                    config=esplora,
                    lookup="Esplora is served by nginx",
                 )
              }}
    - template: jinja
    - context:
        esplora: {{ esplora | json }}
    - require:
      - sls: {{ sls_package_install }}
      - Nginx is installed
