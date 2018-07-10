#!/bin/sh
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
