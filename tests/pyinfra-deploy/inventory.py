# pyinfra Performance
# File: deploy/inventory.py
# Desc: dynamic pyinfra inventory

import os

n_hosts = os.environ["PYINFRA_TEST_HOSTS"]
n_hosts = int(n_hosts)


HOSTS = (
    [
        ("host_{0}".format(n), {"ssh_hostname": "localhost", "ssh_port": 19000 + n})
        for n in range(0, n_hosts)
    ],
    {
        "ssh_user": "root",
        "ssh_key": "docker/performance_rsa",
    },
)
