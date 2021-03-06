#!/bin/bash

if [ -z "$2" ]; then
    echo "Usage: $ ./script_name <num of ovs instances> <controller-ip>"
    exit 1;
fi

echo "Number of Switches specified: " $1
echo "Controller IP: " $2

for ((i=1;i<=$1;i++)); do
    # NOTE:
    # 1. Change your docker image name in below line while using this script
    # 2. --rm flag is to remove the container when it gets stopped. This helps in clean-up.
    docker run -itd --rm --name ovs$i -e MODE=tcp:$2 --cap-add NET_ADMIN docker-ubuntu-ovs-img
    sleep 2
    echo "Started docker container ovs$i."
done

