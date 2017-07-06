{%- from "octavia/map.jinja" import manager with context %}

{%- if manager.enabled %}
{%- set mine_data = salt['mine.get']('glance:client', 'glanceng.get_image_owner_id', 'pillar').values() %}

octavia_manager_packages:
  pkg.installed:
  - names: {{ manager.pkgs }}

{%- if mine_data %}
/etc/octavia/octavia.conf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/octavia_manager.conf
  - template: jinja
  - require:
    - pkg: octavia_manager_packages
  - context:
    amp_image_owner_id: {{ mine_data|first }}
{%- endif %}

/etc/octavia/certificates/openssl.cnf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/certificates/openssl.cnf
  - require:
    - pkg: octavia_manager_packages

{% set dhclient_conf_path = '/etc/octavia/dhcp/dhclient.conf' %}

{{ dhclient_conf_path }}:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/dhcp/dhclient.conf
  - require:
    - pkg: octavia_manager_packages

{%- if not grains.get('noservices', False) %}

health_manager_ovs_port:
  cmd.run:
  - name: "ovs-vsctl -- --may-exist add-port br-int o-hm0 -- set Interface
  o-hm0 type=internal -- set Interface o-hm0 external-ids:iface-status=active
  -- set Interface o-hm0 external-ids:attached-mac={{
  manager.controller_worker.amp_hm_port_mac }} -- set Interface o-hm0
  external-ids:iface-id={{ manager.controller_worker.amp_hm_port_id }} -- set
  Interface o-hm0 external-ids:skip_cleanup=true"
  - unless: ovs-vsctl show | grep o-hm0

health_manager_port_set_mac:
  cmd.run:
  - name: "ip link set dev o-hm0 address {{
  manager.controller_worker.amp_hm_port_mac }}"
  - unless: "ip link show o-hm0 | grep {{
  manager.controller_worker.amp_hm_port_mac }}"
  - require:
    - cmd: health_manager_ovs_port

health_manager_port_dhclient:
  cmd.run:
  - name: dhclient -v o-hm0 -cf {{ dhclient_conf_path }}
  - require:
    - cmd: health_manager_port_set_mac

health_manager_port_add_rule:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - in-interface: o-hm0
    - dport: 5555
    - proto: udp
    - save: True

{%- if mine_data %}
octavia_manager_services:
  service.running:
  - names: {{ manager.services }}
  - enable: true
  - watch:
    - file: /etc/octavia/octavia.conf
{%- endif %}
{%- endif %}

{%- endif %}
