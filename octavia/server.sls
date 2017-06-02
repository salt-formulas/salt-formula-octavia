{%- from "octavia/map.jinja" import server with context %}

{%- if server.enabled %}

show_uptime:
  cmd.run:
    - name: uptime

{%- endif %}
