FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install openssh-server -y

RUN mkdir /var/run/sshd

ADD performance_rsa.pub /root/.ssh/authorized_keys

CMD /usr/sbin/sshd -D
