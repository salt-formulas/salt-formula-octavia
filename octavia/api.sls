{%- from "octavia/map.jinja" import api with context %}

{%- if api.enabled %}

include:
  - octavia.db.offline_sync

octavia_api_packages:
  pkg.installed:
  - names: {{ api.pkgs }}
  - require_in:
    - sls: octavia.db.offline_sync


/etc/octavia/octavia_api.conf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/octavia_api.conf
  - template: jinja
  - require:
    - pkg: octavia_api_packages
  - require_in:
    - sls: octavia.db.offline_sync

{%- if pillar.octavia.manager is not defined %}
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
octavia_api_services:
  service.running:
  - names: {{ api.services }}
  - enable: true
  - watch:
    - file: /etc/octavia/octavia_api.conf
  - require:
    - sls: octavia.db.offline_sync
{%- endif %}

{%- endif %}
