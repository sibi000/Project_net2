#!/bin/bash

#reset previous configuration, this is done to avoid errors
bash ./script/resetScenario.sh
# S1    
echo ' ---------------------------------------------- '
echo '*** Network Slicing: Creating 3 slices of 5 Mbps, 3 Mbps and 2 Mbps ...'
echo 'Switch 1:'
sudo ovs-vsctl -- \
set port s1-eth1 qos=@newqos -- \
set port s1-eth2 qos=@newqos -- \
set port s1-eth3 qos=@newqos -- \
set port s1-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:123=@1q \
queues:234=@2q \
queues:345=@3q -- \
--id=@1q create queue other-config:min-rate=1000000 other-config:max-rate=5000000 -- \
--id=@2q create queue other-config:min-rate=1000000 other-config:max-rate=3000000 -- \
--id=@3q create queue other-config:min-rate=1000000 other-config:max-rate=2000000

# S2
echo 'Switch 2:'
sudo ovs-vsctl -- \
set port s2-eth1 qos=@newqos -- \
set port s2-eth2 qos=@newqos -- \
set port s2-eth3 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=3000000 \
queues:123=@1q -- \
--id=@1q create queue other-config:min-rate=1000000 other-config:max-rate=3000000 -- \

# S3
echo 'Switch 3:'
sudo ovs-vsctl -- \
set port s3-eth1 qos=@newqos -- \
set port s3-eth2 qos=@newqos -- \
set port s3-eth3 qos=@newqos -- \
set port s3-eth4 qos=@newqos -- \
--id=@newqos create QoS type=linux-htb \
other-config:max-rate=10000000 \
queues:123=@1q \
queues:234=@2q \
queues:345=@3q -- \
--id=@1q create queue other-config:min-rate=1000000 other-config:max-rate=2000000 -- \
--id=@2q create queue other-config:min-rate=1000000 other-config:max-rate=3000000 -- \
--id=@3q create queue other-config:min-rate=1000000 other-config:max-rate=5000000


echo '*** Slices Created!'
echo ' ---------------------------------------------- '

# [SWITCH 1]
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.3,idle_timeout=0,actions=set_queue:234,output:1
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.4,idle_timeout=0,actions=set_queue:234,output:2
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.5,idle_timeout=0,actions=set_queue:234,output:2
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.6,idle_timeout=0,actions=set_queue:345,output:4
sudo ovs-ofctl add-flow s1 ip,priority=65500,nw_src=10.0.0.2,idle_timeout=0,actions=set_queue:123,output:3
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:123,output:2
sudo ovs-ofctl add-flow s1 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:345,output:2

# [SWITCH 2]
sudo ovs-ofctl add-flow s2 ip,priority=65500,nw_src=10.0.0.3,idle_timeout=0,actions=set_queue:123,output:2,output:3
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=2,idle_timeout=0,actions=set_queue:123,output:1,output:3
sudo ovs-ofctl add-flow s2 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:123,output:1,output:2

# [SWITCH 3]
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.7,idle_timeout=0,actions=set_queue:123,output:2
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.1,idle_timeout=0,actions=set_queue:345,output:3
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.4,idle_timeout=0,actions=set_queue:234,output:4
sudo ovs-ofctl add-flow s3 ip,priority=65500,nw_src=10.0.0.5,idle_timeout=0,actions=set_queue:234,output:4
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=2,idle_timeout=0,actions=set_queue:123,output:1
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=3,idle_timeout=0,actions=set_queue:345,output:1
sudo ovs-ofctl add-flow s3 ip,priority=65500,in_port=4,idle_timeout=0,actions=set_queue:234,output:1

