#!/bin/bash

set -e

echo "--> Reset results.csv"
echo "test,hosts,time" > results.csv

./run_tests.sh -t 1
./run_tests.sh -t 5
./run_tests.sh -t 25
./run_tests.sh -t 50
./run_tests.sh -t 100
./run_tests.sh -t 250
./run_tests.sh -t 500
./run_tests.sh -t 1000
