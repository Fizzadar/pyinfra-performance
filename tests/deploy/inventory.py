# pyinfra Performance
# File: deploy/inventory.py
# Desc: dynamic pyinfra inventory

import os


n_hosts = os.environ.get('PYINFRA_TEST_HOSTS', '5')
n_hosts = int(n_hosts)


HOSTS = ([
    ('localhost', {'ssh_port': 900 + n})
    for n in xrange(10, n_hosts + 10)
], {
    'ssh_user': 'root',
    'ssh_password': 'root'
})
