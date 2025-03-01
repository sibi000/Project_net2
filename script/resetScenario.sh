#!/bin/bash

sudo ovs-ofctl del-flows s1 
sudo ovs-ofctl del-flows s2
sudo ovs-ofctl del-flows s3 

# SWITCH S1
sudo ovs-vsctl del-port s1 s1-eth1 -- \
add-port s1 s1-eth1
sudo ovs-vsctl del-port s1 s1-eth2 -- \
add-port s1 s1-eth2
sudo ovs-vsctl del-port s1 s1-eth3 -- \
add-port s1 s1-eth3
sudo ovs-vsctl del-port s1 s1-eth4 -- \
add-port s1 s1-eth4


# SWITCH S2
sudo ovs-vsctl del-port s2 s2-eth1 -- \
add-port s2 s2-eth1
sudo ovs-vsctl del-port s2 s2-eth2 -- \
add-port s2 s2-eth2
sudo ovs-vsctl del-port s2 s2-eth3 -- \
add-port s2 s2-eth3

# SWITCH S3
sudo ovs-vsctl del-port s3 s3-eth1 -- \
add-port s3 s3-eth1
sudo ovs-vsctl del-port s3 s3-eth2 -- \
add-port s3 s3-eth2
sudo ovs-vsctl del-port s3 s3-eth3 -- \ 
add-port s3 s3-eth3
sudo ovs-vsctl del-port s3 s3-eth4 -- \
add-port s3 s3-eth4

# MESSAGGIO DI CONFERMA
echo "Cleaned switches!"