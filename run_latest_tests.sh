#!/bin/bash

set -e

echo "--> Reset results.csv"
echo "test,hosts,pass,time" > results.csv

PYINFRA_TEST_HOSTS=1 ./run_tests.sh
PYINFRA_TEST_HOSTS=5 ./run_tests.sh
PYINFRA_TEST_HOSTS=25 ./run_tests.sh
PYINFRA_TEST_HOSTS=50 ./run_tests.sh
PYINFRA_TEST_HOSTS=100 ./run_tests.sh
PYINFRA_TEST_HOSTS=250 ./run_tests.sh
PYINFRA_TEST_HOSTS=500 ./run_tests.sh
