linux:
  system:
    enabled: true
    repo:
      mirantis_openstack:
        source: "deb http://mirror.mirantis.com/stable/openstack-queens/xenial/ xenial main"
        architectures: amd64
        key_url: "http://mirror.mirantis.com/nightly/openstack-queens/xenial/archive-queens.key"
