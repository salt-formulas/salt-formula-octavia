octavia:
  manager:
    enabled: true
    version: ocata
    database:
      engine: mysql
      host: 127.0.0.1
      port: 3306
      name: octavia
      user: octavia
      password: password
    identity:
      engine: keystone
      region: RegionOne
      host: 127.0.0.1
      port: 35357
      user: octavia
      password: password
      tenant: service
    message_queue:
      engine: rabbitmq
      host: 127.0.0.1
      port: 5672
      user: openstack
      password: password
      virtual_host: '/openstack'
    certificates:
      ca_private_key_passphrase: foobar
      ca_private_key: '/etc/octavia/certs/private/cakey.pem'
      ca_certificate: '/etc/octavia/certs/ca_01.pem'
    controller_worker:
      amp_boot_network_list: '01d3edaa-422c-40b9-b265-425c981691e7'
      amp_flavor_id: '967972bb-ab54-4679-9f53-bf81d5e28154'
      amp_image_owner_id: '68520e9f926441ddb37b7c744c4005b7'
      amp_image_tag: amphora
      amp_secgroup_list: '9fcd532e-5715-423a-8e3f-51abddbe7705'
      amp_ssh_key_name: octavia_ssh_key
      amp_hm_port_id: a52a982d-876d-414e-b8d3-4a0ce8c060c6
      amp_hm_port_mac: fa:16:3e:c4:bf:b2
      loadbalancer_topology: 'SINGLE'
    haproxy_amphora:
      client_cert: '/etc/octavia/certs/client.pem'
      server_ca: '/etc/octavia/certs/ca_01.pem'
    health_manager:
      bind_ip: 192.168.0.12
      heartbeat_key: 'insecure'
    house_keeping:
      spare_amphora_pool_size: 0
