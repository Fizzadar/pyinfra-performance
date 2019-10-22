#!/bin/bash

set -e

echo "--> Reset results.csv"
echo "test,hosts,time" > results.csv

PYINFRA_TEST_HOSTS=1 ./run_tests.sh
PYINFRA_TEST_HOSTS=5 ./run_tests.sh
PYINFRA_TEST_HOSTS=25 ./run_tests.sh
PYINFRA_TEST_HOSTS=50 ./run_tests.sh
PYINFRA_TEST_HOSTS=100 ./run_tests.sh
PYINFRA_TEST_HOSTS=150 ./run_tests.sh
PYINFRA_TEST_HOSTS=200 ./run_tests.sh
PYINFRA_TEST_HOSTS=250 ./run_tests.sh
PYINFRA_TEST_HOSTS=300 ./run_tests.sh
PYINFRA_TEST_HOSTS=350 ./run_tests.sh
PYINFRA_TEST_HOSTS=400 ./run_tests.sh
PYINFRA_TEST_HOSTS=450 ./run_tests.sh
PYINFRA_TEST_HOSTS=500 ./run_tests.sh
