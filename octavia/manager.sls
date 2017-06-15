{%- from "octavia/map.jinja" import manager with context %}

{%- if manager.enabled %}

octavia_manager_packages:
  pkg.installed:
  - names: {{ manager.pkgs }}

/etc/octavia/octavia.conf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/octavia_manager.conf
  - template: jinja
  - require:
    - pkg: octavia_manager_packages

/etc/octavia/certificates/openssl.cnf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/certificates/openssl.cnf
  - require:
    - pkg: octavia_manager_packages

/etc/octavia/dhcp/dhclient.conf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/dhcp/dhclient.conf
  - require:
    - pkg: octavia_manager_packages

{%- if not grains.get('noservices', False) %}
octavia_manager_services:
  service.running:
  - names: {{ manager.services }}
  - enable: true
  - watch:
    - file: /etc/octavia/octavia.conf
{%- endif %}

{%- endif %}
