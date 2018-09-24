try:
    import os_client_config
    from keystoneauth1 import exceptions as ka_exceptions
    REQUIREMENTS_MET = True
except ImportError:
    REQUIREMENTS_MET = False

from octaviav2 import loadbalancers


loadbalancer_list = loadbalancers.loadbalancer_list
loadbalancer_get_details = loadbalancers.loadbalancer_get_details
loadbalancer_update = loadbalancers.loadbalancer_update
loadbalancer_delete = loadbalancers.loadbalancer_delete
loadbalancer_create = loadbalancers.loadbalancer_create


__all__ = (
    'loadbalancer_get_details', 'loadbalancer_update', 'loadbalancer_delete',
    'loadbalancer_list', 'loadbalancer_create',
)


def __virtual__():
    """Only load neutronv2 if requirements are available."""
    if REQUIREMENTS_MET:
        return 'octaviav2'
    else:
        return False, ("The octaviav2 execution module cannot be loaded: "
                       "os_client_config or keystoneauth are unavailable.")
