# pyinfra Performance
# File: deploy/deploy.py
# Desc: prepares the test VM by installing Docker

from pyinfra.modules import apt, server, pip, init

SUDO = True


# Add Docker key
apt.key(
    keyserver='hkp://p80.pool.sks-keyservers.net:80',
    keyid='58118E89F3A912897C070ADBF76221572C52609D'
)

# Add docker repo
apt.repo('deb https://apt.dockerproject.org/repo ubuntu-trusty main')

# Install Docker & pip
apt.packages(
    ['docker-engine', 'python-pip', 'python-dev', 'sshpass'],
    update=True,
    cache_time=3600
)

# Install pyinfra/Ansible/Fabric
pip.packages(['git+https://github.com/Fizzadar/pyinfra', 'ansible', 'fabric'])

# Give Vagrant user access to Docker
server.user('vagrant', groups=['docker'])

# Prep Docker
server.shell([
    # Pull the rastasheep/ubuntu-sshd Docker image
    'docker pull rastasheep/ubuntu-sshd',

    # Lazy: jump to /opt/perf on login
    'echo "cd /opt/performance" > /home/vagrant/.bash_profile'
])

# Restart Docker
init.upstart(
    'docker',
    restarted=True
)
