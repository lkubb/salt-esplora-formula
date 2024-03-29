# vim: ft=sls

{#-
    Removes Esplora/the prerender-server and its unit file
    as well as the dedicated user account.
    Has a dependency on `esplora.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}

include:
  - {{ sls_config_clean }}

Esplora is absent:
  file.absent:
    - names:
      - {{ esplora.lookup.paths.build }}
      - {{ esplora.lookup.paths.www }}
      - {{ esplora.lookup.service.unit.format(name=esplora.lookup.service.name) }}

Esplora user/group are absent:
  user.absent:
    - name: {{ esplora.lookup.user }}
    - require:
      - Esplora is absent
  group.absent:
    - name: {{ esplora.lookup.group }}
    - require:
      - Esplora is absent
