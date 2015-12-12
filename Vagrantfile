# pyinfra Performance
# File: Vagrantfile
# Desc: dynamic Vagrant VM config


# Figure out number of hosts from ENV, defaulting to 5
hosts = ENV['PYINFRA_TEST_HOSTS'] || 5
HOST_COUNT = hosts.to_i


# Configure the VM's
Vagrant.configure('2') do |config|
    config.vm.box = 'ubuntu/trusty64'

    # Setup SSH key
    config.ssh.insert_key = false
    config.ssh.private_key_path = 'files/insecure_private_key'

    # Give less rams
    config.vm.provider 'virtualbox' do |vb|
        vb.memory = 200
    end

    # Actually generate the VM's
    HOST_COUNT.times do |i|
        # Make VM's go from 1, 2, 3, ...
        host_number = i + 1
        host_id = "pyinfra-perf-#{host_number}"

        # IP's start at 10, 11, 12, ...
        network_number = i + 10

        config.vm.define host_id do |host|
            host.vm.network :private_network, ip: "192.168.13.#{network_number}"
            host.vm.hostname = host_id
        end
    end
end
