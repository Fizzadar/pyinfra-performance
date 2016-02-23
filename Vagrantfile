# pyinfra Performance
# File: Vagrantfile
# Desc: the test VM (for non-native-Docker people)


# Configure the VM's
Vagrant.configure('2') do |config|
    config.vm.box = 'ubuntu/trusty64'
    config.vm.synced_folder './', '/opt/performance'

    # Setup SSH key
    config.ssh.insert_key = false
    config.ssh.private_key_path = 'deploy/insecure_private_key'

    # Beef up the box
    config.vm.provider 'virtualbox' do |vb|
        vb.cpus = 4
        vb.memory = 4096
    end

    config.vm.define :pyinfra_performance do |host|
        host.vm.network :private_network, ip: '192.168.13.13'
        host.vm.hostname = 'pyinfra-perf-tests'
    end
end
