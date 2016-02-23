#!/usr/bin/env python

# pyinfra Performance
# File: playbook/inventory.py
# Desc: dynamic Ansible inventory

import os
import json


n_hosts = os.environ.get('PYINFRA_TEST_HOSTS', '5')
n_hosts = int(n_hosts)


inventory = {
    'all': {
        'hosts': [
            'host_{0}'.format(n)
            for n in xrange(1, n_hosts)
        ],
        'vars': {
            'ansible_ssh_user': 'vagrant',
            'ansible_ssh_private_key_file': 'files/insecure_private_key'
        },
        'hostvars': {
            'host_{0}'.format(n): {
                'ansible_ssh_port': 900 + n,
                'ansible_ssh_host': 'localhost'
            }
            for n in xrange(1, n_hosts)
        }
    }
}


# Print the JSON which Ansible reads
print json.dumps(inventory)
