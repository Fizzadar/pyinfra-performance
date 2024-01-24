#!/usr/bin/env bash

# pyinfra Performance
# File: run_tests.sh
# Desc: let the performance tests begin!

set -e

bold=$(tput bold)
normal=$(tput sgr0)

# Use gdate if installed (brew install coreutils) for nanosecond accuracy
DATE=$(which date)
if command -v gdate > /dev/null 2>&1; then
    DATE=$(which gdate)
fi

export TIMEFORMAT=%R

# Define our tests to time
declare -A TESTS=(
    ["pyinfra"]="pyinfra tests/pyinfra-deploy/inventory.py tests/pyinfra-deploy/deploy.py"
    ["ansible-ssh"]="ansible-playbook -i tests/ansible-playbook/inventory.py tests/ansible-playbook/playbook.yml -c ssh"
    ["ansible-paramiko"]="ansible-playbook -i tests/ansible-playbook/inventory.py tests/ansible-playbook/playbook.yml -c paramiko"
    ["fabric"]="python tests/fabric/fabfile.py"
)

# Forces Ansible to accept all host keys
export ANSIBLE_HOST_KEY_CHECKING=False

VERBOSE="false"
POSITIONAL_ARGS=()
TEST_SIZE=5
PRE_SLEEP=15

while [[ $# -gt 0 ]]; do
  case $1 in
    -v)
        VERBOSE="true"
        shift # flag
        ;;
    -t)
        TEST_SIZE=$2
        shift # flag
        shift # value
        ;;
    --pre-sleep)
        PRE_SLEEP=$2
        shift # flag
        shift # value
        ;;
    -*|--*)
        echo "Unknown option $1"
        exit 1
        ;;
    *)
        POSITIONAL_ARGS+=("$1") # save positional arg
        shift # argument
        ;;
  esac
done

export PYINFRA_TEST_HOSTS=$TEST_SIZE


array_contains () {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

function start_containers() {
    echo "Starting ${1} containers"

    for i in `seq 1 ${1}`; do
        docker run -d -p $((18999 + i)):22 pyinfra-performance-sshd > /dev/null &

        if ! (( $i % 50 )); then
            echo "${i}/${1}"
            wait
        fi
    done

    wait
}

function kill_containers() {
    local containers=$(docker ps -q)

    if [ ! "$containers" = "" ]; then
        docker kill $containers > /dev/null
        docker rm $containers > /dev/null
    fi
}

function run_test() {
    local test_name=$1

    echo "Run test $test_name command: ${@:2}"

    START=$($DATE +%s.%N)

    set +e
    if [ "${VERBOSE}" = "true" ]; then
        ${@:2}
    else
        ${@:2} > /dev/null 2>&1
    fi
    if [ ! "${?}" = "0" ]; then
        FAILED="true"
    else
        FAILED="false"
    fi
    set -e

    local END=$($DATE +%s.%N)
    local DIFF=$(echo "$END - $START" | bc)

    if [ "${FAILED}" = "true" ]; then
        echo "--> ${1} failed after ${DIFF} seconds"
    else
        echo "--> ${test_name} complete in ${DIFF} seconds"
    fi

    echo "${test_name},${TEST_SIZE},${DIFF}" >> results.csv
    return
}

function cleanup() {
    echo "--> Cleaning up remaining containers..."
    kill_containers
}
trap cleanup EXIT


# Let's go!
echo "### ${bold}pyinfra Performance Tests${normal}"

# Work out the number of hosts (5 is default)
echo "--> Running with ${TEST_SIZE} hosts"

echo "--> ssh-add the key"
ssh-add ./docker/performance_rsa

echo "--> Building docker SSH image..."
docker build -t pyinfra-performance-sshd -f docker/Dockerfile ./docker

# Run each test
for TEST in "${!TESTS[@]}"; do
    if [ ! "${POSITIONAL_ARGS}" = "" ]; then
        array_contains "$TEST" "${POSITIONAL_ARGS[@]}" || continue
    fi

    echo "--> Removing any containers..."
    kill_containers

    echo "--> Spawning ${TEST_SIZE} containers..."
    start_containers ${TEST_SIZE}

    echo "--> Sleep ${PRE_SLEEP}s..."
    sleep ${PRE_SLEEP}

    echo "--> Run test: ${TEST}"
    run_test ${TEST} ${TESTS[$TEST]}
    echo
done

echo "<-- All tests complete!"
