# pyinfra Performance
# File: deploy/deploy.py
# Desc: prepares the test VM by installing Docker

from pyinfra.modules import apt, server, pip

SUDO = True


# Add Docker key
apt.key(
    keyserver='hkp://p80.pool.sks-keyservers.net:80',
    keyid='58118E89F3A912897C070ADBF76221572C52609D'
)

# Install Docker & pip
apt.packages(
    ['docker.io', 'python-pip', 'python-dev'],
    update=True,
    cache_time=3600
)

# Install pyinfra/Ansible/Fabric
pip.packages(['pyinfra==0.1.dev9', 'ansible', 'fabric'])

# Final prep
server.shell(
    # Pull the rastasheep/ubuntu-sshd Docker image
    'docker pull rastasheep/ubuntu-sshd',

    # Lazy: jump to /opt/perf on login
    'echo "cd /opt/performance && sudo su" >> /home/vagrant/.bash_profile'
)
