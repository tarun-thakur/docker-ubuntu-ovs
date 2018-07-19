# docker-ubuntu-ovs
This repository is to create docker image to have openvswitch i.e. OVS running inside ubuntu image. It is having few more scripts to use docker image to instantiate large number of docker containers having ovs switch running inside them.

## Pre requisites
Docker should be pre-installed before using this repository. You can refer below link to install docker on Ubuntu machine.
 * https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04

## Build
Run docker build on the current directory. 'docker build' command will use Dockerfile to create docker image.
 * docker build -t <docker_image_name> .

Once docker build is run successfully, you can check your docker image by running below command:
 * docker images

## Run
The openvswitch manager (for ovsdb connection) and bridge controller (for openflow connection) are managed via an environment variable MODE, which must be passed as command-line argument when the container is instantiated. This MODE may have one of the following four forms:
 * MODE=none - will result in no manager or controller being set
 * MODE=ptcp - except passive manager tcp conntections 
 * MODE=tcp - set the manager and controller IPs to the value of the default route
 * MODE=tcp:10.10.1.1 manager and controller IPs to the IP specified. Generally speaking, you will not need this option

To run the docker image, you can use below commands:
 * sudo docker run -itd --name <docker_instance_name> -e MODE=none --cap-add NET_ADMIN <name_of_docker_image>
 * sudo docker run -itd --name <docker_instance_name> -e MODE=tcp:<controller_ip> --cap-add NET_ADMIN <name_of_docker_image>
NOTE: "--cap-add NET_ADMIN" option is provided to add linux capabilities to containers to access network interfaces.

## How to run ovs commands under docker
Below are the sample ovs commands:
* docker exec <docker_instance_name> ovs-vsctl show
* docker exec <docker_instance_name> ovs-vsctl list Open_vSwitch
* docker exec <docker_instance_name> ovs-vsctl set O . other_config:local_ip=192.168.56.101
* docker exec <docker_instance_name> ovs-ofctl dump-flows -O Openflow13 br-int
  
If you want to run large number of instances of this docker images to have large number of OVS running separately and isolated then below two scripts developed along with this docker image, can be of great help.
 * run_docker_ovs.sh
 * stop_rm_docker_ovs.sh

### run_docker_ovs script
This script will run specified number of instances of this docker images.
It will ask few command line arguments and will instantiate specified number of docker instances in which ovs will be running and ovs manager and controller will be connected to controller based on ip-address specified.

Usage: $ ./script_name <num_of_ovs_instances> <controller_ip>

### stop_rm_docker_ovs script
This is a cleanup script for run_docker_ovs script. It will stop docker container and remove it.

Usage: $ ./script_name <num_of_ovs_instances>
  
## NOTES
 * configure_ovs.sh, mk-net-dev.sh, supervisord.conf are taken from the contribution of Josh Hershberg specified in Credits section.
 * You may need to change 'grep 172' in the configure_ovs.sh file as per subnet range of docker networking in the ubuntu container. Currently, it is of subnet 172.17.0.0/16.
 * Try not to use office network while building docker image because due to some restrictions and access issues in the office network, some sites and packages are not accessible, hence build gets failed.
 * You must need to change name of docker image in the run_docker_ovs.sh file at line of 'docker run' command.

## Credits
This docker solution is largely based on following contributors in github:
* Dave Tucker: https://github.com/dave-tucker/docker-ovs  Thank you Dave.
* Josh Hershberg: https://github.com/jhershberg/docker-centos-ovs Thank you Josh.
