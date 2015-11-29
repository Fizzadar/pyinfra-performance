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
            '192.168.13.{0}'.format(n)
            for n in xrange(10, n_hosts + 10)
        ],
        'vars': {
            'ansible_ssh_user': 'vagrant',
            'ansible_ssh_private_key_file': 'files/insecure_private_key'
        }
    }
}


# Print the JSON which Ansible reads
print json.dumps(inventory)
