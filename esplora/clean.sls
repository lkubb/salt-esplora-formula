# -*- coding: utf-8 -*-
# vim: ft=sls

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
