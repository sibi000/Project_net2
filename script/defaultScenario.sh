#!/bin/bash

#reset previous configuration, this is done to avoid errors

# S1
echo ' ---------------------------------------------- '
echo '*** Network Slicing: Creating 1 slice of 10 Mbps ...'
echo 'Switch 1:'
sudo ovs-vsctl -- \
set port s1-eth2 qos=@newqos -- \
set port s1-eth3 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:123=@1q -- \
--id=@1q create queue other-config:min-rate=1000000 other-config:max-rate=10000000 -- \

# S2
echo 'Switch 2:'
sudo ovs-vsctl -- \
set port s2-eth1 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \

# S3
echo 'Switch 3:'
sudo ovs-vsctl -- \
set port s3-eth1 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \


echo '*** Slices Created!'
echo ' ---------------------------------------------- '

# [SWITCH 1]
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:123,output:4
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:123,output:3

# [SWITCH 2]
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=3,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=4,idle_timeout=0,actions=drop

# [SWITCH 3]
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=1,idle_timeout=0,actions=drop
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=2,idle_timeout=0,actions=drop

