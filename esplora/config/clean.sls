# vim: ft=sls

{#-
    Removes the configuration of the esplora service and has a
    dependency on `esplora.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}

include:
  - {{ sls_service_clean }}

Esplora Block Explorer configuration is absent:
  file.absent:
    - name: {{ esplora.lookup.config }}
    - require:
      - sls: {{ sls_service_clean }}
