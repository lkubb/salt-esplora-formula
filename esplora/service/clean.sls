# vim: ft=sls

{#-
    Stops the esplora ``prerender-server`` service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}

Esplora Block Explorer is dead:
  service.dead:
    - name: {{ esplora.lookup.service.name }}
    - enable: False
