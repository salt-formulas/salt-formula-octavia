linux:
  system:
    enabled: true
    repo:
      mirantis_openstack:
        source: "deb https://mirror.mirantis.com/nightly/openstack-pike/xenial xenial main"
        architectures: amd64
        key_url: "https://mirror.mirantis.com/nightly/openstack-pike/xenial/archive-pike.key"
