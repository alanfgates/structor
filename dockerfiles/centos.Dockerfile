FROM centos:6.7

ENV PUPPET_AGENT_VERSION="1.5.3"

RUN rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm && \
    yum upgrade -y && \
    yum update -y && \
    yum install -y puppet-agent-"$PUPPET_AGENT_VERSION" && \
    yum clean all
