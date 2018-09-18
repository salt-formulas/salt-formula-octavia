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
        ssh:
          private_key: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEpAIBAAKCAQEAtjnPDJsQToHBtoqIo15mdSYpfi8z6DFMi8Gbo0KCN33OUn5u
            OctbdtjUfeuhvI6px1SCnvyWi09Ft8eWwq+KwLCGKbUxLvqKltuJ7K3LIrGXkt+m
            qZN4O9XKeVKfZH+mQWkkxRWgX2r8RKNV3GkdNtd74VjhP+R6XSKJQ1Z8b7eHM10v
            6IjTY/jPczjK+eyCeEj4qbSnV8eKlqLhhquuSQRmUO2DRSjLVdpdf2BB4/BdWFsD
            YOmX7mb8kpEr9vQ+c1JKMXDwD6ehzyU8kE+1kVm5zOeEy4HdYIMpvUfN49P1anRV
            2ISQ1ZE+r22IAMKl0tekrGH0e/1NP1DF5rINMwIDAQABAoIBAQCkP/cgpaRNHyg8
            ISKIHs67SWqdEm73G3ijgB+JSKmW2w7dzJgN//6xYUAnP/zIuM7PnJ0gMQyBBTMS
            NBTv5spqZLKJZYivj6Tb1Ya8jupKm0jEWlMfBo2ZYVrfgFmrfGOfEebSvmuPlh9M
            vuzlftmWVSSUOkjODmM9D6QpzgrbpktBuA/WpX+6esMTwJpOcQ5xZWEnHXnVzuTc
            SncodVweE4gz6F1qorbqIJz8UAUQ5T0OZTdHzIS1IbamACHWaxQfixAO2s4+BoUK
            ANGGZWkfneCxx7lthvY8DiKn7M5cSRnqFyDToGqaLezdkMNlGC7v3U11FF5blSEW
            fL1o/HwBAoGBAOavhTr8eqezTchqZvarorFIq7HFWk/l0vguIotu6/wlh1V/KdF+
            aLLHgPgJ5j+RrCMvTBoKqMeeHfVGrS2udEy8L1mK6b3meG+tMxU05OA55abmhYn7
            7vF0q8XJmYIHIXmuCgF90R8Piscb0eaMlmHW9unKTKo8EOs5j+D8+AMJAoGBAMo4
            8WW+D3XiD7fsymsfXalf7VpAt/H834QTbNZJweUWhg11eLutyahyyfjjHV200nNZ
            cnU09DWKpBbLg7d1pyT69CNLXpNnxuWCt8oiUjhWCUpNqVm2nDJbUdlRFTzYb2fS
            ZC4r0oQaPD5kMLSipjcwzMWe0PniySxNvKXKInFbAoGBAKxW2qD7uKKKuQSOQUft
            aAksMmEIAHWKTDdvOA2VG6XvX5DHBLXmy08s7rPfqW06ZjCPCDq4Velzvgvc9koX
            d/lP6cvqlL9za+x6p5wjPQ4rEt/CfmdcmOE4eY+1EgLrUt314LHGjjG3ScWAiirE
            QyDrGOIGaYoQf89L3KqIMr0JAoGARYAklw8nSSCUvmXHe+Gf0yKA9M/haG28dCwo
            780RsqZ3FBEXmYk1EYvCFqQX56jJ25MWX2n/tJcdpifz8Q2ikHcfiTHSI187YI34
            lKQPFgWb08m1NnwoWrY//yx63BqWz1vjymqNQ5GwutC8XJi5/6Xp+tGGiRuEgJGH
            EIPUKpkCgYAjBIVMkpNiLCREZ6b+qjrPV96ed3iTUt7TqP7yGlFI/OkORFS38xqC
            hBP6Fk8iNWuOWQD+ohM/vMMnvIhk5jwlcwn+kF0ra04gi5KBFWSh/ddWMJxUtPC1
            2htvlEc6zQAR6QfqXHmwhg1hP81JcpqpicQzCMhkzLoR1DC6stXdLg==
            -----END RSA PRIVATE KEY-----
          user: octavia
          group: octavia


Upgrades
========
 Each openstack formula provide set of phases (logical bloks) that will help to
build flexible upgrade orchestration logic for particular components. The list
of phases might and theirs descriptions are listed in table below:
 +-------------------------------+------------------------------------------------------+
| State                         | Description                                          |
+===============================+======================================================+
| <app>.upgrade.service_running | Ensure that all services for particular application  |
|                               | are enabled for autostart and running                |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.service_stopped | Ensure that all services for particular application  |
|                               | disabled for autostart and dead                      |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.pkg_latest      | Ensure that packages used by particular application  |
|                               | are installed to latest available version.           |
|                               | This will not upgrade data plane packages like qemu  |
|                               | and openvswitch as usually minimal required version  |
|                               | in openstack services is really old. The data plane  |
|                               | packages should be upgraded separately by `apt-get   |
|                               | upgrade` or `apt-get dist-upgrade`                   |
|                               | Applying this state will not autostart service.      |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.render_config   | Ensure configuration is rendered actual version.     +
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.pre             | We assume this state is applied on all nodes in the  |
|                               | cloud before running upgrade.                        |
|                               | Only non destructive actions will be applied during  |
|                               | this phase. Perform service built in service check   |
|                               | like (keystone-manage doctor and nova-status upgrade)|
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade.pre     | Mostly applicable for data plane nodes. During this  |
|                               | phase resources will be gracefully removed from      |
|                               | current node if it is allowed. Services for upgraded |
|                               | application will be set to admin disabled state to   |
|                               | make sure node will not participate in resources     |
|                               | scheduling. For example on gtw nodes this will set   |
|                               | all agents to admin disable state and will move all  |
|                               | routers to other agents.                             |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade         | This state will basically upgrade application on     |
|                               | particular target. Stop services, render             |
|                               | configuration, install new packages, run offline     |
|                               | dbsync (for ctl), start services. Data plane should  |
|                               | not be affected, only OpenStack python services.     |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.upgrade.post    | Add services back to scheduling.                     |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.post            | This phase should be launched only when upgrade of   |
|                               | the cloud is completed.                              |
+-------------------------------+------------------------------------------------------+
| <app>.upgrade.verify          | Here we will do basic health checks (API CRUD        |
|                               | operations, verify do not have dead network          |
|                               | agents/compute services)                             |
+-------------------------------+------------------------------------------------------+


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
