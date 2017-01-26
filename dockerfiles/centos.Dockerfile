FROM centos:6.7

ENV PUPPET_AGENT_VERSION="1.5.3"

RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm && \
    yum upgrade -y && \
    yum update -y && \
    yum install -y puppet-agent-"$PUPPET_AGENT_VERSION"

# Install sshd
RUN yum -y install openssh-server openssh-clients && \
    ssh-keygen -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key

EXPOSE 22

# Install other tools Vagrant needs
RUN yum -y install sudo

# Create the vagrant user
RUN useradd --create-home -s /bin/bash vagrant
WORKDIR /home/vagrant

# Configure SSH access
RUN mkdir -p /home/vagrant/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys && \
    chown -R vagrant: /home/vagrant/.ssh && \
    mkdir -p /var/run/sshd && \
    chmod 0755 /var/run/sshd && \
    echo -n 'vagrant:vagrant' | chpasswd

# Enable passwordless sudo for vagrant user
RUN echo 'vagrant ALL=NOPASSWD: ALL' >> /etc/sudoers.d/vagrant
RUN chmod 440 /etc/sudoers.d/vagrant

RUN yum clean all

# Manually start sshd and don't let it detach.  This keeps the container running.
CMD /usr/sbin/sshd -D
