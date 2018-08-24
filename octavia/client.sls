{%- from "octavia/map.jinja" import client with context %}
{%- if client.enabled %}

octavia_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- endif %}