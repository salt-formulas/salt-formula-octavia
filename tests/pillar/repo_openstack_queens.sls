linux:
  system:
    enabled: true
    repo:
      mirantis_openstack:
        source: "deb https://mirror.mirantis.com/nightly/openstack-queens/xenial/ xenial main"
        architectures: amd64
        key_url: "https://mirror.mirantis.com/nightly/openstack-queens/xenial/archive-queens.key"
