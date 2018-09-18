{%- from "octavia/map.jinja" import api,manager with context %}

octavia_render_config:
  test.show_notification:
    - text: "Running octavia.upgrade.render_config"

/etc/octavia/certificates/openssl.cnf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/certificates/openssl.cnf

{%- if api.enabled %}
/etc/octavia/octavia_api.conf:
  file.managed:
  - source: salt://octavia/files/{{ api.version }}/octavia_api.conf
  - template: jinja
{%- endif %}

{%- if manager.enabled %}
{%- set ssh_dir = salt['file.dirname'](manager.ssh.private_key_file) %}
{%- set image_mine_data = salt['mine.get']('glance:client', 'glanceng.get_image_owner_id', 'pillar').values() %}
{%- set network_mine_data = salt['mine.get']('neutron:client', 'list_octavia_networks', 'pillar').values() %}
{%- set secgroup_mine_data = salt['mine.get']('neutron:client', 'list_octavia_mgmt_security_groups', 'pillar').values() %}

{%- if image_mine_data and network_mine_data and secgroup_mine_data %}
/etc/octavia/octavia_manager.conf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/octavia_manager.conf
  - template: jinja
  - context:
    amp_image_owner_id: {{ image_mine_data|first }}
    amp_boot_network_list: {{ (network_mine_data|first)['networks'][0]['id'] }}
    amp_secgroup_list: {{ (secgroup_mine_data|first)['lb-mgmt-sec-grp']['id'] }}
{%- endif %}

{% set dhclient_conf_path = '/etc/octavia/dhcp/dhclient.conf' %}

{{ dhclient_conf_path }}:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/dhcp/dhclient.conf

{%- endif %}
