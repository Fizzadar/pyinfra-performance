# pyinfra Performance
# File: deploy/cleanup.py
# Desc: reverts changes in deploy.py

from pyinfra.modules import server, files

SUDO = True
TIMEOUT = 1

# Remove pyinfra user & homedir
server.user('pyinfra', present=False)
files.directory('/home/pyinfra', present=False)

# Remove log file, test file and test template
for filename in (
    '/var/log/pyinfra.log',
    '/home/pyinfra/test_file.txt',
    '/home/pyinfra/test_template.txt'
):
    files.file(filename, present=False)
