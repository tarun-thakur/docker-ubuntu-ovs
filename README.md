# docker-ubuntu-ovs
This repository is to create docker image to have openvswitch i.e. OVS running inside ubuntu image.

## Build
Run docker build on this directory. 'docker build' command will use Dockerfile to create docker image.
 * docker build -t <docker-image-name> .

Once docker build is run successfully, you can check your docker image by running below command:
 * docker images

## Run
The openvswitch manager and bridge controller connections are managed via an environment variable, MODE,
which must be passed in when the container is spun up. This MODE may have one of the following four forms:
 * MODE=none - will result in no manager or controller being set
 * MODE=ptcp - except passive manager tcp conntections 
 * MODE=tcp - set the manager and controller IPs to the value of the default route
 * MODE=tcp:10.10.1.1 manager and controller IPs to the IP specified. Generally speaking, you will not need this option

To run the docker image say,
 * sudo docker run -itd --name <docker-instance-name> -e MODE=none --cap-add NET_ADMIN <name_of_docker_image>
 * sudo docker run -itd --name <docker-instance-name> -e MODE=tcp:<controller-ip> --cap-add NET_ADMIN <name_of_docker_image>

## How to run ovs commands under docker
Below are the sample ovs commands:
* docker exec <docker-instance-name> ovs-vsctl show
* docker exec <docker-instance-name> ovs-vsctl list Open_vSwitch
* docker exec <docker-instance-name> ovs-vsctl set O . other_config:local_ip=192.168.56.101
* docker exec <docker-instance-name> ovs-ofctl dump-flows -O Openflow13 br-int
  
If you want to run large number of instances of this docker images to have large number of OVS running separately and isolated then below two scripts developed along with this docker image, can be of great help.
 * run_docker_ovs.sh
 * stop_rm_docker_ovs.sh

### run_docker_ovs.sh script

### stop_rm_docker_ovs.sh script

## Credits
This work is largely based on followong contributors in github:
* Dave Tucker: https://github.com/dave-tucker/docker-ovs  Thank you Dave.
* Josh Hershberg: https://github.com/jhershberg/docker-centos-ovs Thank you Josh.
