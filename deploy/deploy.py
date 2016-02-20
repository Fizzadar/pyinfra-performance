# pyinfra Performance
# File: deploy/deploy.py
# Desc: the pyinfra deploy!

from pyinfra.modules import server, files, init

SUDO = True
TIMEOUT = 1

# Add pyinfra user
server.user('pyinfra', home='/home/pyinfra', shell='/bin/bash')

# Add log file
files.file('/var/log/pyinfra.log', user='pyinfra', mode=777)

# Copy a file
files.put('../files/test_file.txt', '/home/pyinfra/test_file.txt', user='pyinfra')

# Generate & copy a template
files.template(
    '../templates/test_template.jn2',
    '/home/pyinfra/test_template.txt',
    user='pyinfra'
)

# Restart cron service
init.upstart('cron', running=True)

# Run some shell
server.shell('echo "hi!"')
