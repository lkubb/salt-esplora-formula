# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}

esplora-service-clean-service-dead:
  service.dead:
    - name: {{ esplora.lookup.service.name }}
    - enable: False
