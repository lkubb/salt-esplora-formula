# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{#-
    This manages then environment variables for the prerender-server used
    when nojs support is active.
#}

include:
  - {{ sls_package_install }}

Esplora configuration is managed:
  file.managed:
    - name: {{ esplora.lookup.config }}
    - source: {{ files_switch(["esplora-prerenderer.env", "esplora-prerenderer.env.j2"],
                              lookup="Esplora Block Explorer configuration is managed"
                 )
             }}
    - mode: "0600"
    - user: root
    - group: {{ esplora.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        esplora: {{ esplora | json }}
