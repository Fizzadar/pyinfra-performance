# pyinfra Performance
# File: deploy/deploy.py
# Desc: the pyinfra deploy!

from pyinfra.modules import files, server

CONNECT_TIMEOUT = 1
FAIL_PERCENT = 0

server.user(
    {'Add pyinfra user'},
    'pyinfra',
    home='/home/pyinfra', shell='/bin/bash',
)

files.file(
    {'Add log file'},
    '/var/log/pyinfra.log',
    user='pyinfra', mode=777,
)

files.put(
    {'Copy a file'},
    '../files/test_file.txt', '/home/pyinfra/test_file.txt',
    user='pyinfra',
)

server.shell(
    {'Run some shell'},
    'echo "hi!"',
)
