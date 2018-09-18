{%- from "octavia/map.jinja" import api with context %}

octavia_db_manage:
  cmd.run:
  - name: octavia-db-manage --config-file /etc/octavia/octavia_api.conf upgrade head
  {%- if grains.get('noservices') or api.get('role', 'primary') == 'secondary' %}
  - onlyif: /bin/false
  {%- endif %}
