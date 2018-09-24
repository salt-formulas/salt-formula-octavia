{%- from "octavia/map.jinja" import api with context %}
{%- from "keystone/map.jinja" import client as kclient with context %}


octavia_upgrade_verify_api:
  test.show_notification:
    - text: "Running octavia.upgrade.verify.api"


{%- if kclient.enabled and kclient.get('os_client_config', {}).get('enabled', False)  %}
  {%- if api.enabled %}

octaviav2_loadbalancer_list:
  module.run:
    - name: octaviav2.loadbalancer_list
    - kwargs:
        cloud_name: admin_identity

  {%- endif %}
{%- endif %}
