from octaviav2.common import send
from octaviav2.common import get_by_name_or_uuid

try:
    from urllib.parse import urlencode
except ImportError:
    from urllib import urlencode

RESOURCE_LIST_KEY = 'loadbalancers'


@send('get')
def loadbalancer_list(**kwargs):
    url = '/v2.0/lbaas/loadbalancers?{}'.format(urlencode(kwargs))
    return url, {}

@get_by_name_or_uuid(loadbalancer_list, RESOURCE_LIST_KEY)
@send('get')
def loadbalancer_get_details(loadbalancer_id, **kwargs):
    url = '/v2.0/lbaas/loadbalancers/{}?{}'.format(loadbalancer_id, urlencode(kwargs))
    return url, {}


@get_by_name_or_uuid(loadbalancer_list, RESOURCE_LIST_KEY)
@send('put')
def loadbalancer_update(loadbalancer_id, **kwargs):
    url = '/v2.0/lbaas/loadbalancers/{}'.format(loadbalancer_id)
    json = {
        'loadbalancer': kwargs,
    }
    return url, {'json': json}


@get_by_name_or_uuid(loadbalancer_list, RESOURCE_LIST_KEY)
@send('delete')
def loadbalancer_delete(loadbalancer_id, **kwargs):
    url = '/v2.0/lbaas/loadbalancers/{}'.format(loadbalancer_id)
    return url, {}


@send('post')
def loadbalancer_create(**kwargs):
    url = '/v2.0/lbaas/loadbalancers'
    json = {
        'loadbalancer': kwargs,
    }
    return url, {'json': json}
