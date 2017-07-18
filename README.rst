=======
Octavia
=======

Octavia is an open source, operator-scale load balancing solution designed to
work with OpenStack. It accomplishes its delivery of load balancing services
by managing a fleet of virtual machines, known as amphorae, which it spins up
on demand.

Octavia is designed to “plug in” to Neutron LBaaS in the same way that any
proprietary vendor solution would: through a Neutron LBaaS version 2 driver
interface. Octavia plans to supplant Neutron LBaaS as the load balancing
solution for OpenStack. At that time, third-party vendor drivers that presently
“plug in” to Neutron LBaaS will plug in to Octavia instead. For end-users,
this transition should be relatively seamless, because Octavia supports
the Neutron LBaaS v2 API and it has a similar CLI interface.


Sample pillars
==============

Octavia API service pillar:

.. code-block:: yaml

    octavia:
      api:
        enabled: true
        version: ocata
        bind:
          address: 127.0.0.1
          port: 9876
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


Octavia manager service pillar:

.. code-block:: yaml

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
          ca_private_key: '/etc/octavia/certs/private/cakey.pem'
          ca_certificate: '/etc/octavia/certs/ca_01.pem'
        controller_worker:
          amp_flavor_id: '967972bb-ab54-4679-9f53-bf81d5e28154'
          amp_image_tag: amphora
          amp_ssh_key_name: octavia_ssh_key
          loadbalancer_topology: 'SINGLE'
        haproxy_amphora:
          client_cert: '/etc/octavia/certs/client.pem'
          client_cert_key: '/etc/octavia/certs/client.key'
          client_cert_all: '/etc/octavia/certs/client_all.pem'
          server_ca: '/etc/octavia/certs/ca_01.pem'
        health_manager:
          bind_ip: 192.168.0.12
          heartbeat_key: 'insecure'
        house_keeping:
          spare_amphora_pool_size: 0



More information
================

Octavia developer documentation:

    https://docs.openstack.org/developer/octavia

Release notes:

    https://docs.openstack.org/releasenotes/octavia


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use GitHub issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-octavia/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

You should also subscribe to mailing list (salt-formulas@freelists.org):

    https://www.freelists.org/list/salt-formulas

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
