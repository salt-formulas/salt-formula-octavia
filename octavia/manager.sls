{%- from "octavia/map.jinja" import manager with context %}

{%- if manager.enabled %}
{%- set ssh_dir = salt['file.dirname'](manager.ssh.private_key_file) %}
{%- set image_mine_data = salt['mine.get']('glance:client', 'glanceng.get_image_owner_id', 'pillar').values() %}
{%- set network_mine_data = salt['mine.get']('neutron:client', 'list_octavia_networks', 'pillar').values() %}
{%- set secgroup_mine_data = salt['mine.get']('neutron:client', 'list_octavia_mgmt_security_groups', 'pillar').values() %}
{%- set port_mine_data = salt['mine.get']('neutron:client', 'list_octavia_hm_ports', 'pillar').values() %}

octavia_manager_packages:
  pkg.installed:
  - names: {{ manager.pkgs }}

{%- if image_mine_data and network_mine_data and secgroup_mine_data %}
/etc/octavia/octavia_manager.conf:
  file.managed:
  - source: salt://octavia/files/{{ manager.version }}/octavia_manager.conf
  - template: jinja
  - require:
    - pkg: octavia_manager_packages
  - context:
    amp_image_owner_id: {{ image_mine_data|first }}
    amp_boot_network_list: {{ (network_mine_data|first)['networks'][0]['id'] }}
    amp_secgroup_list: {{ (secgroup_mine_data|first)['lb-mgmt-sec-grp']['id'] }}
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

octavia_ssh_dir:
  file.directory:
    - name: {{ ssh_dir }}
    - user: {{ manager.ssh.user }}
    - group: {{ manager.ssh.group }}
    - makedirs: true

octavia_ssh_private_key:
  file.managed:
    - name: {{ manager.ssh.private_key_file }}
    - contents_pillar: octavia:manager:ssh:private_key
    - user: {{ manager.ssh.user }}
    - group: {{ manager.ssh.group }}
    - mode: 600
    - require:
      - file: octavia_ssh_dir


{%- if not grains.get('noservices', False) %}
{%- if image_mine_data and network_mine_data and secgroup_mine_data and port_mine_data %}

{%- set amp_hm_port_mac = port_mine_data[0]['octavia-health-manager-listen-port']['mac_address'] %}
{%- set amp_hm_port_id = port_mine_data[0]['octavia-health-manager-listen-port']['id'] %}

health_manager_ovs_port:
  cmd.run:
  - name: "ovs-vsctl -- --may-exist add-port br-int o-hm0 -- set Interface
  o-hm0 type=internal -- set Interface o-hm0 external-ids:iface-status=active
  -- set Interface o-hm0 external-ids:attached-mac={{ amp_hm_port_mac }} -- set Interface o-hm0
  external-ids:iface-id={{ amp_hm_port_id }} -- set Interface o-hm0 external-ids:skip_cleanup=true"
  - unless: ovs-vsctl show | grep o-hm0

health_manager_port_set_mac:
  cmd.run:
  - name: "ip link set dev o-hm0 address {{ amp_hm_port_mac }}"
  - unless: "ip link show o-hm0 | grep {{ amp_hm_port_mac }}"
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

octavia_manager_services:
  service.running:
  - names: {{ manager.services }}
  - enable: true
  - watch:
    - file: /etc/octavia/octavia_manager.conf
{%- endif %}
{%- endif %}

{%- endif %}
