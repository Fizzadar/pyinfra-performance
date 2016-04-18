# pyinfra Performance Comparison

This repo aims to compare the peformance of pyinfra against other deploy/automation tools. Currently supporting:

+ [pyinfra](https://github.com/Fizzadar/pyinfra) ([deploy.py](./tests/deploy/deploy.py))
+ [Ansible](https://github.com/ansible/ansible) ([playbook.yml](./tests/playbook/playbook.yml))

The most recent results are always available in [latest_results.txt](./latest_results.txt).


## Setup & Requirements

The tests make use of Docker for quickly creating/destroying `n` servers. For those without Docker (myself included) there is a Vagrant VM provided:

```
pyinfra -i deploy/inventory.py deploy/deploy.py
```

Please note the VM's default specs are 4 CPUs & 4G ram. For tests >100 hosts I bump this up to 8CPU/8GB.


## Run the tests

```sh
# If using the Vagrant VM: vagrant ssh

# Run with 5 hosts
./run_tests.sh

# Or use env var with n hosts:
PYINFRA_TEST_HOSTS=50 ./run_tests.sh
```
