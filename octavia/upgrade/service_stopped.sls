{%- from "octavia/map.jinja" import api,manager with context %}

octavia_service_stopped:
  test.show_notification:
    - text: "Running octavia.upgrade.service_stopped"

{%- set oservices = [] %}

{%- if api.enabled %}
  {%- do oservices.extend(api.services) %}
{%- endif %}
{%- if manager.enabled %}
  {%- do oservices.extend(manager.services) %}
{%- endif %}

{%- for oservice in oservices|unique %}
octavia_service_{{ oservice }}_stopped:
  service.dead:
  - enable: True
  - name: {{ oservice }}
{%- endfor %}
