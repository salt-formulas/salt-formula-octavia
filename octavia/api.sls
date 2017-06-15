{%- from "octavia/map.jinja" import api with context %}

{%- if api.enabled %}

octavia_api_packages:
  pkg.installed:
  - names: {{ api.pkgs }}

{%- if pillar.octavia.manager is not defined %}
/etc/octavia/octavia.conf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/octavia_api.conf
  - template: jinja
  - require:
    - pkg: octavia_api_packages

/etc/octavia/certificates/openssl.cnf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/certificates/openssl.cnf
  - require:
    - pkg: octavia_api_packages

/etc/octavia/dhcp/dhclient.conf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/dhcp/dhclient.conf
  - require:
    - pkg: octavia_api_packages
{%- endif %}

{%- if not grains.get('noservices', False) %}
octavia_db_manage:
  cmd.run:
  - name: octavia-db-manage upgrade head
  - require:
    - file: /etc/octavia/octavia.conf
{%- endif %}

{%- if not grains.get('noservices', False) %}
octavia_api_services:
  service.running:
  - names: {{ api.services }}
  - enable: true
  - watch:
    - file: /etc/octavia/octavia.conf
  - require:
    - cmd: octavia_db_manage
{%- endif %}

{%- endif %}
