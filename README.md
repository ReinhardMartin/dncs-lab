# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 315 and 214 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 344 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
## Network requirements
- 315 usable adresses for host-A
- 214 usable adresses for host-B
- 344 usable adresses for host-C
- host-C must run a Docker image reachable by host-A and host-B
- use only static routes as generic as possible

## Addressing
there are 4 different subnets:
1. between router-1 and router-2

require only 2 ip addresses, we use the subnet 10.1.1.0/30

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s9 |  router-1 | 10.1.1.1/30 | 
| enp0s9 | router-2 | 10.1.1.2/30 

2. between router-1 and host-a

need to manage 315 ip addresses, we use the subnet 192.168.2.0/23 

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8.2 |  router-1 | 192.168.2.1/23 | 
| enp0s8 | host-a | 192.168.2.2/23  

and create a VLAN with tag "2"

3. between router-1 and host-b

need to manage 214 ip addresses, we use the subnet 192.168.1.0/24

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8.3 |  router-1 | 192.168.1.1/24 | 
| enp0s8 | host-b | 192.168.1.2/24

and create a VLAN with tag "3"

4. between router-2 and host-c

need to manage 344 ip addresses, we use the subnet 192.168.4.0/23

| NETWORK INTERFACE | DEVICE | IP ADDRESS | 
| :---: | :---: | :---:|
| enp0s8 |  router-2 | 192.168.4.1/23 | 
| enp0s8 | host-c | 192.168.4.2/23 

## Network topology

![image](https://user-images.githubusercontent.com/91339156/136593267-e4b3f080-89ee-4b0a-b750-2e84aa2c4c7d.png)

## Vagrant configuration


