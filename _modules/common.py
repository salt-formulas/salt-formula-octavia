import logging
import os_client_config
from uuid import UUID

log = logging.getLogger(__name__)


class OctaviaException(Exception):

    _msg = "Octavia module exception occured."

    def __init__(self, message=None, **kwargs):
        super(OctaviaException, self).__init__(message or self._msg)


class NoAuthPluginConfigured(OctaviaException):
    _msg = ("You are using keystoneauth auth plugin that does not support "
            "fetching endpoint list from token (noauth or admin_token).")


class NoCredentials(OctaviaException):
    _msg = "Please provide cloud name present in clouds.yaml."


class ResourceNotFound(OctaviaException):
    _msg = "Uniq resource: {resource} with name: {name} not found."

    def __init__(self, resource, name, **kwargs):
        super(ResourceNotFound, self).__init__(
            self._msg.format(resource=resource, name=name))


class MultipleResourcesFound(OctaviaException):
    _msg = "Multiple resource: {resource} with name: {name} found."

    def __init__(self, resource, name, **kwargs):
        super(MultipleResourcesFound, self).__init__(
            self._msg.format(resource=resource, name=name))


def _get_raw_client(cloud_name):
    service_type = 'load-balancer'
    config = os_client_config.OpenStackConfig()
    cloud = config.get_one_cloud(cloud_name)
    adapter = cloud.get_session_client(service_type)
    # workaround for IndexError as Octavia doen's have a version discovery
    # document till Rocky (https://review.openstack.org/#/c/559460/)
    adapter.min_version = None
    adapter.max_version = None
    adapter.version = None
    try:
        access_info = adapter.session.auth.get_access(adapter.session)
        access_info.service_catalog.get_endpoints()
    except (AttributeError, ValueError):
        e = NoAuthPluginConfigured()
        log.exception('%s' % e)
        raise e
    return adapter


def send(method):
    def wrap(func):
        def wrapped_f(*args, **kwargs):
            cloud_name = kwargs.pop('cloud_name')
            if not cloud_name:
                e = NoCredentials()
                log.error('%s' % e)
                raise e
            adapter = _get_raw_client(cloud_name)
            # Remove salt internal kwargs
            kwarg_keys = list(kwargs.keys())
            for k in kwarg_keys:
                if k.startswith('__'):
                    kwargs.pop(k)
            url, request_kwargs = func(*args, **kwargs)
            response = getattr(adapter, method)(url, **request_kwargs)
            if not response.content:
                return {}
            return response.json()
        return wrapped_f
    return wrap


def _check_uuid(val):
    try:
        return str(UUID(val)).replace('-', '') == val.replace('-', '')
    except (TypeError, ValueError, AttributeError):
        return False


def get_by_name_or_uuid(resource_list, resp_key, resp_id_key='id'):
    def wrap(func):
        def wrapped_f(*args, **kwargs):
            if 'name' in kwargs:
                ref = kwargs.pop('name', None)
                start_arg = 0
            else:
                start_arg = 1
                ref = args[0]
            if _check_uuid(ref):
                uuid = ref
            else:
                # Then we have name not uuid
                cloud_name = kwargs['cloud_name']
                resp = resource_list(
                    name=ref, cloud_name=cloud_name)[resp_key]
                if len(resp) == 0:
                    raise ResourceNotFound(resp_key, ref)
                elif len(resp) > 1:
                    raise MultipleResourcesFound(resp_key, ref)
                uuid = resp[0][resp_id_key]
            return func(uuid, *args[start_arg:], **kwargs)
        return wrapped_f
    return wrap
