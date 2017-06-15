linux:
  system:
    enabled: true
    repo:
      mirantis_openstack:
        source: "deb http://mirror.fuel-infra.org/mcp-repos/ocata/xenial ocata main"
        architectures: amd64
        key_url: "http://mirror.fuel-infra.org/mcp-repos/ocata/xenial/archive-mcpocata.key"
