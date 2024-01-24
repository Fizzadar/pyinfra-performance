#!/usr/bin/env python

# pyinfra Performance
# File: playbook/inventory.py
# Desc: dynamic Ansible inventory

import json
import os

n_hosts = os.environ["PYINFRA_TEST_HOSTS"]
n_hosts = int(n_hosts)


inventory = {
    "all": {
        "hosts": ["host_{0}".format(n) for n in range(0, n_hosts)],
        "vars": {
            "ansible_ssh_user": "root",
            "ansible_ssh_private_key_file": "docker/performance_rsa",
            "ansible_python_interpreter": "/usr/bin/python3",
            "ansible_command_timeout": 30,
        },
    },
    "_meta": {
        "hostvars": {
            "host_{0}".format(n): {
                "ansible_ssh_port": 19000 + n,
                "ansible_ssh_host": "localhost",
            }
            for n in range(0, n_hosts)
        },
    },
}


# Print the JSON which Ansible reads
print(json.dumps(inventory))
