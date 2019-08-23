#!/usr/bin/env bash

# pyinfra Performance
# File: run_tests.sh
# Desc: let the performance tests begin!

set -e

bold=`tput bold`
normal=`tput sgr0`

# Define our tests to time
declare -A TESTS=(
    ["pyinfra"]="pyinfra tests/deploy/inventory.py tests/deploy/deploy.py"
    ["ansible-ssh"]="ansible-playbook -i tests/playbook/inventory.py tests/playbook/playbook.yml -c ssh"
    ["ansible-paramiko"]="ansible-playbook -i tests/playbook/inventory.py tests/playbook/playbook.yml -c paramiko"
    ["fabric"]="python tests/fabfile.py"
)

# Forces Ansible to accept all host keys
export ANSIBLE_HOST_KEY_CHECKING=False

# Work out if printing output
VERBOSE="false"
if [ "${1}" = "-v" ]; then
    VERBOSE="true"
fi


function start_containers() {
    echo "Starting ${1} containers"

    for i in `seq 1 ${1}`; do
        docker run -d -p $((8999 + i)):22 pyinfra-performance-sshd >/dev/null &

        if ! (( $i % 50 )); then
            echo "${i}/${1}"
            wait
        fi
    done

    wait
}


function kill_containers() {
    local containers=`docker ps -q`

    if [ ! "$containers" = "" ]; then
        docker kill $containers > /dev/null
    fi
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
    echo "${@:2},${n_hosts},${test_name},${DIFF}" >> results.csv
    return
}


function run_tests() {
    echo "--> Running ${bold}${1}${normal} tests"
    echo

    declare -a test_names=( "First" "Second" )
    for test_name in "${test_names[@]}"; do
        run_test "${test_name}" "${@:2}"

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

echo "--> ssh-add the key"
ssh-add ./docker/performance_rsa > /dev/null 2>&1

echo "--> Building docker SSH image..."
docker build -t pyinfra-performance-sshd -f docker/Dockerfile ./docker > /dev/null

# Run each test
for TEST in "${!TESTS[@]}"; do
    # Remove any existihg containers
    echo "--> Removing any containers..."
    kill_containers

    # Up new containers
    echo "--> Spawning ${n_hosts} containers..."
    start_containers ${n_hosts}

    sleep 5

    # Do the tests
    time run_tests ${TEST} ${TESTS[$TEST]}
    echo
done

echo "--> Cleaning up remaining containers..."
kill_containers

echo "<-- All tests complete!"
