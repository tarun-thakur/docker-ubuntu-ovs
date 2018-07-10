#!/bin/bash

if [ -z "$2" ]; then
    echo "Usage: $ ./script_name <num of ovs instances> <controller-ip>"
    exit 1;
fi

echo "Number of Switches specified: " $1
echo "Controller IP: " $2

for ((i=1;i<=$1;i++)); do
    docker run -itd --name ovs$i -e MODE=tcp:$2 --cap-add NET_ADMIN tarun-ovs-9
    # Get IP address of container;
    # NOTE: docker networking by default allocates ip-address of subnet 172.17.0.0/16 that is why "grep 172" in search
    local_ip=$(docker exec ovs$i ip a show | awk '/inet / {print $2}' | grep -o ^[^/]* | grep 172)
    sleep 2

    # set local_ip used as TEP IP address if ovs will play role in tunnel
    docker exec ovs$i ovs-vsctl set O . other_config:local_ip=$local_ip
    echo "Started docker container ovs$i."
    sleep 1
done

