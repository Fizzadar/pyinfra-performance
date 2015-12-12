#!/bin/sh

# pyinfra Performance
# File: run_tests.sh
# Desc: let the performance tests begin!

bold=`tput bold`
normal=`tput sgr0`

# Define our tests to time
declare -a TESTS=(
    "pyinfra -i deploy/inventory.py deploy/deploy.py"
    "ansible-playbook -i playbook/inventory.py playbook/playbook.yaml -c ssh"
    "ansible-playbook -i playbook/inventory.py playbook/playbook.yaml -c paramiko"
)

# Forces Ansible to accept all host keys
export ANSIBLE_HOST_KEY_CHECKING=False

# Work out if printing output
VERBOSE="false"
if [ "${1}" = "-v" ]; then
    VERBOSE="true"
fi


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
        sleep 5

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

# Up the VM's
if [ ! "${SKIP_VAGRANT}" = "true" ]; then
    echo "--> Bringing up VM's..."
    vagrant up > /dev/null
else
    echo "--> Skipping vagrant up"
fi

# Run each test
for TEST in "${TESTS[@]}"; do
    # This pyinfra deploy reverts any changes the test deploys make
    echo
    echo "--> Pre-test cleanup..."
    pyinfra -i deploy/inventory.py deploy/cleanup.py > /dev/null

    time run_tests "${TEST}"
done


echo
echo "<-- All tests complete!"
