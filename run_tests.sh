#!/bin/sh

# pyinfra Performance
# File: run_tests.sh
# Desc: let the performance tests begin!

bold=`tput bold`
normal=`tput sgr0`

# Define our tests to time
declare -a TESTS=(
    "pyinfra -i deploy/inventory.py deploy/deploy.py"
    "ansible-playbook -i playbook/inventory.py playbook/playbook.yaml"
)

# Forces Ansible to accept all host keys
export ANSIBLE_HOST_KEY_CHECKING=False


echo "### ${bold}pyinfra Performance Tests${normal}"

# Work out the number of hosts (5 is default)
n_hosts=`echo $PYINFRA_TEST_HOSTS`
if [ "${n_hosts}" = "" ]; then
    n_hosts='5'
fi
echo "--> Running with ${n_hosts} hosts"
echo


function run_test() {
    echo "--> Running test: ${bold}${@}${normal}"

    # Remove existing hosts (as they will skew tests)
    echo "--> Removing any existing hosts"
    vagrant destroy -f > /dev/null

    # Bring up a bunch of new/clean boxes
    echo "--> Bringing up new hosts"
    vagrant up > /dev/null

    echo "--> Sleeping for 20s"
    sleep 20

    # Execute the first run
    START=`date +%s.%N`
    echo "--> Executing first run..."
    ${@} > /dev/null
    END=`date +%s.%N`
    FIRST_DIFF=`echo "$END - $START" | bc`

    # Execute the second run
    START=`date +%s.%N`
    echo "--> Executing second run..."
    ${@} > /dev/null
    END=`date +%s.%N`
    SECOND_DIFF=`echo "$END - $START" | bc`

    echo
    echo "--> First complete in ${FIRST_DIFF} seconds"
    echo "--> Second complete in ${SECOND_DIFF} seconds"
    echo
}

for TEST in "${TESTS[@]}"; do
    run_test $TEST
done

echo "<-- All tests complete!"
