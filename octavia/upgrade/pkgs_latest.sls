{%- from "octavia/map.jinja" import api,manager,client with context %}

octavia_task_pkg_latest:
  test.show_notification:
    - text: "Running octavia.upgrade.pkg_latest"

policy-rc.d_present:
  file.managed:
    - name: /usr/sbin/policy-rc.d
    - mode: 755
    - contents: |
        #!/bin/sh
        exit 101

{%- set pkgs = [] %}
{%- if api.enabled %}
  {%- do pkgs.extend(api.pkgs) %}
{%- endif %}
{%- if manager.enabled %}
  {%- do pkgs.extend(manager.pkgs) %}
{%- endif %}
{%- if client.enabled %}
  {%- do pkgs.extend(client.pkgs) %}
{%- endif %}

octavia_pkg_latest:
  pkg.latest:
  - names: {{ pkgs|unique }}
  - require:
    - file: policy-rc.d_present
  - require_in:
    - file: policy-rc.d_absent

policy-rc.d_absent:
  file.absent:
    - name: /usr/sbin/policy-rc.d
