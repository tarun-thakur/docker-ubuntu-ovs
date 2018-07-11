#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $ ./script_name <num of ovs instances>"
    exit 1;
fi

echo "Number of Switches specified: " $1

for ((i=1;i<=$1;i++)); do
    docker stop ovs$i
    sleep 1
    echo "Removed docker container ovs$i"
done

