import logging
import random

log = logging.getLogger(__name__)


def __virtual__():
    return 'octaviav2' if 'octaviav2.loadbalancer_list' in __salt__ else False


def _octaviav2_call(fname, *args, **kwargs):
    return __salt__['octaviav2.{}'.format(fname)](*args, **kwargs)


def _resource_present(resource, name, changeable_params, cloud_name, **kwargs):
    try:
        method_name = '{}_get_details'.format(resource)
        exact_resource = _octaviav2_call(
            method_name, name, cloud_name=cloud_name
        )[resource]
    except Exception as e:
        if 'ResourceNotFound' in repr(e):
            try:
                method_name = '{}_create'.format(resource)
                resp = _octaviav2_call(
                    method_name, name=name, cloud_name=cloud_name, **kwargs
                )
            except Exception as e:
                log.exception('Octavia {0} create failed with {1}'.
                    format(resource, e))
                return _failed('create', name, resource)
            return _succeeded('create', name, resource, resp)
        elif 'MultipleResourcesFound' in repr(e):
            return _failed('find', name, resource)
        else:
            raise

    to_update = {}
    for key in kwargs:
        if key in changeable_params and (key not in exact_resource
                or kwargs[key] != exact_resource[key]):
            to_update[key] = kwargs[key]
    try:
        method_name = '{}_update'.format(resource)
        resp = _octaviav2_call(
            method_name, name, cloud_name=cloud_name, **to_update
        )
    except Exception as e:
        log.exception('Octavia {0} update failed with {1}'.format(resource, e))
        return _failed('update', name, resource)
    return _succeeded('update', name, resource, resp)


def _resource_absent(resource, name, cloud_name):
    try:
        method_name = '{}_get_details'.format(resource)
        _octaviav2_call(
            method_name, name, cloud_name=cloud_name
        )[resource]
    except Exception as e:
        if 'ResourceNotFound' in repr(e):
            return _succeeded('absent', name, resource)
        if 'MultipleResourcesFound' in repr(e):
            return _failed('find', name, resource)
    try:
        method_name = '{}_delete'.format(resource)
        _octaviav2_call(
            method_name, name, cloud_name=cloud_name
        )
    except Exception as e:
        log.error('Octavia delete {0} failed with {1}'.format(resource, e))
        return _failed('delete', name, resource)
    return _succeeded('delete', name, resource)


def loadbalancer_present(name, cloud_name, **kwargs):
    changeable = (
        'admin_state_up', 'vip_qos_policy_id', 'description',
    )

    return _resource_present('loadbalancer', name, changeable, cloud_name, **kwargs)


def loadbalancer_absent(name, cloud_name):
    return _resource_absent('loadbalancer', name, cloud_name)

def _succeeded(op, name, resource, changes=None):
    msg_map = {
        'create': '{0} {1} created',
        'delete': '{0} {1} removed',
        'update': '{0} {1} updated',
        'no_changes': '{0} {1} is in desired state',
        'absent': '{0} {1} not present',
    }
    changes_dict = {
        'name': name,
        'result': True,
        'comment': msg_map[op].format(resource, name),
        'changes': changes or {},
    }
    return changes_dict


def _failed(op, name, resource):
    msg_map = {
        'create': '{0} {1} failed to create',
        'delete': '{0} {1} failed to delete',
        'update': '{0} {1} failed to update',
        'find': '{0} {1} found multiple {0}',
    }
    changes_dict = {
        'name': name,
        'result': False,
        'comment': msg_map[op].format(resource, name),
        'changes': {},
    }
    return changes_dict
