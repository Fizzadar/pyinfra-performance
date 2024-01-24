import os

from fabric import ThreadingGroup


def add_pyinfra_user(hosts):
    hosts.run("useradd -d /home/pyinfra -s /bin/bash pyinfra 2> /dev/null || true")
    hosts.run("mkdir -p /home/pyinfra")
    hosts.run("chown pyinfra:pyinfra /home/pyinfra")


def add_log_file(hosts):
    hosts.run("touch /var/log/pyinfra.log")
    hosts.run("chmod 777 /var/log/pyinfra.log")
    hosts.run("chown pyinfra /var/log/pyinfra.log")


def copy_a_file(hosts):
    # Fabric doesn't support parallel put yet
    # (https://github.com/fabric/fabric/issues/1810)
    for host in hosts:
        host.put("tests/files/test_file.txt", "/home/pyinfra/test_file.txt")

    hosts.run("chown pyinfra /home/pyinfra/test_file.txt")


def run_some_shell(hosts):
    hosts.run('echo "hi!"')


def run_test():
    n_hosts = os.environ["PYINFRA_TEST_HOSTS"]
    n_hosts = int(n_hosts)

    hosts = ["root@localhost:{0}".format(19000 + n) for n in range(0, n_hosts)]
    hosts = ThreadingGroup(
        *hosts,
        connect_kwargs={
            "key_filename": "docker/performance_rsa",
        }
    )

    add_pyinfra_user(hosts)
    add_log_file(hosts)
    copy_a_file(hosts)
    run_some_shell(hosts)


run_test()
