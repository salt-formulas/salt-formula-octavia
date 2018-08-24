include:
{%- if pillar.octavia.api is defined %}
- octavia.api
{%- endif %}
{%- if pillar.octavia.manager is defined %}
- octavia.manager
{%- endif %}
{% if pillar.octavia.client is defined %}
- octavia.client
{% endif %}
