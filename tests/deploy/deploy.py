# pyinfra Performance
# File: deploy/deploy.py
# Desc: the pyinfra deploy!

from pyinfra.modules import server, files

SUDO = True
TIMEOUT = 1
FAIL_PERCENT = 0

# Add pyinfra user
server.user('pyinfra', home='/home/pyinfra', shell='/bin/bash')

# Add log file
files.file('/var/log/pyinfra.log', user='pyinfra', mode=777)

# Copy a file
files.put('../files/test_file.txt', '/home/pyinfra/test_file.txt', user='pyinfra')

)

# Run some shell
server.shell('echo "hi!"')
