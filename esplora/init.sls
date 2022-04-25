# -*- coding: utf-8 -*-
# vim: ft=sls

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
