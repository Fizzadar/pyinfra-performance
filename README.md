# pyinfra Performance Comparison

This repo aims to compare the peformance of pyinfra against other deploy/automation tools. Currently supporting:

+ [pyinfra](https://github.com/Fizzadar/pyinfra) ([deploy.py](./deploy/deploy.py))
+ [Ansible](https://github.com/ansible/ansible) ([playbook.yaml](./playbook/playbook.yaml))

The most recent results are always available in [latest_results.txt](./latest_results.txt).


## Run the tests

```sh
# Run with 5 hosts
./run_tests.sh

# Or use env var with n hosts:
PYINFRA_TEST_HOSTS=50 ./run_tests.sh
```


## Test process

For each deployment tool:

+ Clear out any old test files/directories/users (see `deploy/cleanup.py`)
+ Run the test deploy twice
