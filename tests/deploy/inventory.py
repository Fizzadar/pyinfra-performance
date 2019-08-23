# pyinfra Performance
# File: deploy/inventory.py
# Desc: dynamic pyinfra inventory

import os


n_hosts = os.environ.get('PYINFRA_TEST_HOSTS', '5')
n_hosts = int(n_hosts)


HOSTS = ([
    ('host_{0}'.format(n), {'ssh_hostname': 'localhost', 'ssh_port': 9000 + n})
    for n in range(0, n_hosts)
], {
    'ssh_user': 'root',
    'ssh_key': '../../docker/performance_rsa',
})
