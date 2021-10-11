export DEBIAN_FRONTEND=noninteractive

sudo sysctl -w net.ipv4.ip_forward=1

# Startup commands for router-2 go here

sudo ip addr add 10.1.1.2/30 dev enp0s9
sudo ip addr add 192.168.4.1/23 dev enp0s8
sudo ip link set dev enp0s9 up
sudo ip link set dev enp0s8 up

#route table
sudo ip route add 192.168.4.0/23 via 10.1.1.2
sudo ip route add 192.168.0.0/21 via 10.1.1.1
