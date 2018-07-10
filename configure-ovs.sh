#!/bin/sh
ovs_version=$(ovs-vsctl -V | grep ovs-vsctl | awk '{print $4}')
ovs_db_version=$(ovsdb-tool schema-version /usr/share/openvswitch/vswitch.ovsschema)
local_ip=$(ip a show enp0s8 | awk '/inet / {print $2}' | grep -o ^[^/]*)
mode=${1:-tcp}

# give ovsdb-server and vswitchd some space...
sleep 3
# begin configuring
ovs-vsctl --no-wait -- init
ovs-vsctl --no-wait -- set Open_vSwitch . db-version="${ovs_db_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . ovs-version="${ovs_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . system-type="docker-ovs"
ovs-vsctl --no-wait -- set Open_vSwitch . system-version="0.1"
ovs-vsctl --no-wait -- set Open_vSwitch . external-ids:system-id=`cat /proc/sys/kernel/random/uuid`
ovs-vsctl set Open_vSwitch . other_config:local_ip=$local_ip
ovs-vsctl --no-wait -- add-br br-int
if [ $mode == "ptcp" ]
then
    ovs-vsctl --no-wait -- set-manager ptcp:6640
elif [ $mode == "none" ]
then
    echo nothing
else
    controller_ip=$(echo $mode | grep tcp:)
    controller_ip=${controller_ip:-tcp:$(ip route | grep default | cut -d\  -f3)}
    ovs-vsctl --no-wait -- set-controller br-int ${controller_ip}:6653
    ovs-vsctl --no-wait -- set-manager ${controller_ip}:6640
fi
ovs-appctl -t ovsdb-server ovsdb-server/add-remote db:Open_vSwitch,Open_vSwitch,manager_options

