# Get Ubuntu OS
FROM ubuntu:16.04

# Update Software repository
RUN apt-get update

# Install pre-requisites packages
RUN apt-get install -y curl
RUN apt-get install -y python
RUN apt-get install -y yum
RUN apt-get install -y dpkg

# Configure supervisord
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /etc/supervisor/
ADD supervisord.conf /etc/supervisor/

# Install supervisor_stdout
WORKDIR /opt
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /etc/openvswitch
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install setuptools && \
    pip install supervisor && \
    pip install supervisor-stdout

# Get Open vSwitch
WORKDIR /root

# Install ovs dependencies
RUN apt-get install -y openssl iproute

# Install ovs packages
RUN apt-get install -y openvswitch-switch openvswitch-common && \
    mkdir -p /var/run/openvswitch/ && \
    mkdir /dev/net && \
    mknod /dev/net/tun c 10 200

# Configure ovs
ADD configure-ovs.sh /usr/share/openvswitch/
ADD mk-net-dev.sh /usr/share/openvswitch/

# Create the database
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema

CMD ["/usr/local/bin/supervisord"]
