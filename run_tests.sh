#!/bin/bash

# pyinfra Performance
# File: run_tests.sh
# Desc: let the performance tests begin!

set -e

bold=`tput bold`
normal=`tput sgr0`

# Define our tests to time
declare -a TESTS=(
    "pyinfra -i tests/deploy/inventory.py tests/deploy/deploy.py"
    "ansible-playbook -i tests/playbook/inventory.py tests/playbook/playbook.yml -c ssh"
    "ansible-playbook -i tests/playbook/inventory.py tests/playbook/playbook.yml -c paramiko"
)

# Forces Ansible to accept all host keys
export ANSIBLE_HOST_KEY_CHECKING=False

# Work out if printing output
VERBOSE="false"
if [ "${1}" = "-v" ]; then
    VERBOSE="true"
fi


function kill_containers() {
    # Ignore this (no containers)
    docker kill `docker ps -q` > /dev/null || true
}


function run_test() {
    START=`date +%s.%N`

    # Are we printing output?
    if [ "${VERBOSE}" = "true" ]; then
        ${@:2}
    else
        ${@:2} > /dev/null
    fi

    # Flag whether failed or not
    if [ ! "${?}" = "0" ]; then
        FAILED="true"
    else
        FAILED="false"
    fi

    END=`date +%s.%N`
    DIFF=`echo "$END - $START" | bc`

    if [ "${FAILED}" = "true" ]; then
        echo "--> ${1} failed after ${DIFF} seconds"
        return 1
    fi

    echo "--> ${test_name} complete in ${DIFF} seconds"
    return
}


function run_tests() {
    echo "--> Running tests: ${bold}${@}${normal}"
    echo

    declare -a test_names=( "First" "Second" )
    for test_name in "${test_names[@]}"; do
        run_test "${test_name}" "${@}"

        if [ ! "${?}" = "0" ]; then
            return 1
        fi
    done
}


# Let's go!
echo "### ${bold}pyinfra Performance Tests${normal}"

# Work out the number of hosts (5 is default)
n_hosts=`echo $PYINFRA_TEST_HOSTS`
if [ "${n_hosts}" = "" ]; then
    n_hosts="5"
fi
echo "--> Running with ${n_hosts} hosts"


# Run each test
for TEST in "${TESTS[@]}"; do
    # Remove any existihg containers
    echo "--> Removing any containers"
    kill_containers

    # Up new containers
    for i in `seq 1 ${n_hosts}`; do
        echo "--> Bringing up new container #${i}"
        docker run -d -p 900${i}:22 rastasheep/ubuntu-sshd > /dev/null
    done

    # Do the tests!
    time run_tests "${TEST}"

    # echo
    # echo "--> Resting for 5s..."
    # sleep 5
done


echo
echo "<-- All tests complete!"
