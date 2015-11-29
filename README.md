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

+ Bring up a set of empty/clean hosts
+ Run & time a clean deploy
+ Restart the boxes
+ Run & time a repeat deploy
