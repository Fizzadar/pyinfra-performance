# pyinfra Performance
# File: deploy/deploy.py
# Desc: the pyinfra deploy!

from pyinfra.operations import files, server

CONNECT_TIMEOUT = 1
FAIL_PERCENT = 0

server.user(
    name="Add pyinfra user",
    user="pyinfra",
    home="/home/pyinfra",
    shell="/bin/bash",
)

files.file(
    name="Add log file",
    path="/var/log/pyinfra.log",
    user="pyinfra",
    mode=777,
)

files.put(
    name="Copy a file",
    src="tests/files/test_file.txt",
    dest="/home/pyinfra/test_file.txt",
    user="pyinfra",
)

server.shell(
    name="Run some shell",
    commands=['echo "hi!"'],
)
