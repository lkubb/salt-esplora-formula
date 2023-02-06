# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as esplora with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

# Running npm as root is probably not the best idea
Esplora user/group are present:
  user.present:
    - name: {{ esplora.lookup.user }}
    - fullname: Esplora Block Explorer
    - system: true
    - usergroup: {{ esplora.lookup.group == esplora.lookup.user }}
{%- if esplora.lookup.group != esplora.lookup.user %}
    - gid: {{ esplora.lookup.group }}
    - require:
      - group: {{ esplora.lookup.group }}
  group.present:
    - name: {{ esplora.lookup.group }}
    - system: true
{%- endif %}

Esplora paths are setup:
  file.directory:
    - names:
      - {{ esplora.lookup.paths.build }}
      - {{ esplora.lookup.paths.www }}:
        - user: {{ esplora.lookup.www_user }}
        - group: {{ esplora.lookup.www_group }}
    - user: {{ esplora.lookup.user }}
    - group: {{ esplora.lookup.group }}
    - mode: '0755'
    - makedirs: true
    - require:
      - Esplora user/group are present

Requirements for building Esplora are installed:
  pkg.installed:
    - pkgs: {{ esplora.lookup.requirements.base }}
    # This would pull in an enormous amount of bloat on a minimal Debian system.
    - install_recommends: false

Esplora repository is up to date:
  git.latest:
    - name: {{ esplora.lookup.pkg.source }}
    - target: {{ esplora.lookup.paths.build }}
    - rev: {{ "HEAD" if "latest" == esplora.version else esplora.version }}
    - force_reset: remote-changes
    - user: {{ esplora.lookup.user }}
    - require:
      - Esplora paths are setup

NPM dependencies for Esplora are installed:
  cmd.run:
    - name: npm install
    - cwd: {{ esplora.lookup.paths.build }}
    - runas: {{ esplora.lookup.user }}
    - onchanges:
      - Esplora repository is up to date

Esplora SPA is built:
  cmd.script:
    - name: {{ esplora.lookup.paths.build | path_join("build.sh") }}
    - cwd: {{ esplora.lookup.paths.build }}
    - runas: {{ esplora.lookup.user }}
    - onchanges:
      - Esplora repository is up to date
    - require:
      - NPM dependencies for Esplora are installed
    - env:
{%- for conf, val in esplora.config.items() %}
      - {{ conf | upper }}: {{ val | yaml }}
{%- endfor %}
      - DEST: dist
      # This is hardcoded since the user is likely to be created after Jinja is evaluated,
      # so running salt["cmd.run_stdout"]("echo $PATH", runas=esplora.lookup.user, python_shell=True)
      # would fail. It is needed because the script relies on `pug`, which is installed with npm.
      # This is incompatible with Windows and probably M1 Macs (/opt/homebrew), at least.
      - PATH: /usr/local/bin:/usr/bin:/bin:{{ esplora.lookup.paths.build | path_join("node_modules", ".bin") }}

Esplora is installed:
  file.copy:
    - name: {{ esplora.lookup.paths.www }}
    - source: {{ esplora.lookup.paths.build | path_join("dist") }}
    - force: true
    - user: {{ esplora.lookup.www_user }}
    - group: {{ esplora.lookup.www_group }}
    - mode: '0755'
    - onchanges:
      - Esplora repository is up to date
    - require:
      - NPM dependencies for Esplora are installed

{%- if esplora.nojs %}

Esplora prerender-server is built:
  cmd.script:
    - name: {{ esplora.lookup.paths.build | path_join("prerender-server", "build.sh") }}
    - cwd: {{ esplora.lookup.paths.build | path_join("prerender-server") }}
    - runas: {{ esplora.lookup.user }}
    - onchanges:
      - Esplora repository is up to date
    - require:
      - NPM dependencies for Esplora are installed

Esplora prerender-server service is installed:
  file.managed:
    - name: {{ esplora.lookup.service.unit.format(name=esplora.lookup.service.name) }}
    - source: {{ files_switch(
                    ["esplora-prerenderer.service", "esplora-prerenderer.service.j2"],
                    lookup="Esplora prerender-server service is installed",
                  ) }}
    - template: jinja
    - mode: '0644'
    - user: root
    - group: {{ esplora.lookup.rootgroup }}
    - makedirs: true
    - context: {{ {"esplora": esplora} | json }}
    - require:
      - Esplora prerender-server is built
{%-   if "systemctl" | which %}
  # this executes systemctl daemon-reload
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: {{ esplora.lookup.service.unit.format(name=esplora.lookup.service.name) }}
{%-   endif %}
{%- endif %}
