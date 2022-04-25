# -*- coding: utf-8 -*-
# vim: ft=yaml
---
esplora:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    config: '/etc/esplora/prerenderer.env'
    group: esplora
    paths:
      build: /opt/esplora/src
      www: /var/www/esplora
    pkg:
      source: https://github.com/Blockstream/esplora.git
    requirements:
      base:
        - npm
    service:
      name: esplora-prerenderer
      unit: /etc/systemd/system/{name}.service
    user: esplora
    www_group: www-data
    www_user: www-data
  config:
    api_url: /api
    node_env: production
  electrs: 127.0.0.1:3000
  network: bitcoin_mainnet
  nginx:
    csp: default-src 'self'; script-src 'self' 'unsafe-eval'; img-src 'self' data:;
      style-src 'self' 'unsafe-inline'; font-src 'self' data:; object-src 'none'
    listen: '80'
    logging: access_log off
    prefix: ''
  nojs: true
  service:
    wants: []
  version: latest

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://esplora/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   esplora-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      esplora-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
