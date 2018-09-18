{%- from "octavia/map.jinja" import api,manager with context %}

octavia_service_running:
  test.show_notification:
    - text: "Running octavia.upgrade.service_running"

{%- set oservices = [] %}

{%- if api.enabled %}
  {%- do oservices.extend(api.services) %}
{%- endif %}
{%- if manager.enabled %}
  {%- do oservices.extend(manager.services) %}
{%- endif %}

{%- for oservice in oservices|unique %}
octavia_service_{{ oservice }}_running:
  service.running:
  - enable: True
  - name: {{ oservice }}
{%- endfor %}
