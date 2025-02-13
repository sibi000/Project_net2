#!/usr/bin/env python3

from mininet.topo import Topo
from mininet.node import RemoteController, OVSKernelSwitch
from mininet.net import Mininet
from mininet.link import TCLink
from mininet.cli import CLI
import os

class TopologyContainer(Topo):
    def __init__(self):
        Topo.__init__(self)

        # two templates for links creation
        link_config = {}
        switch_link_config = {}

        # creates 3 switches
        for i in range(3):
            sconfig = {'dpid': "%016x" % (i + 1)}
            self.addSwitch('s%d' % (i + 1), **sconfig)
        # creates 7 hosts
        for i in range(7):
            self.addHost('h%d' % (i + 1))
        
        # add links between switches
        self.addLink('s1', 's2', **switch_link_config) #switch 1 port 1 (switch 2 port 1)
        self.addLink('s1', 's3', **switch_link_config) #switch 1 port 2 (switch 3 port 1)

        # add links between hosts and switches
        self.addLink('h1', 's1', **link_config) #switch 1 port 3
        self.addLink('h2', 's1', **link_config) #switch 1 port 4
        self.addLink('h3', 's1', **link_config) #switch 1 port 5
        self.addLink('h7', 's1', **link_config) #switch 1 port 6
        self.addLink('h4', 's2', **link_config) #switch 2 port 2
        self.addLink('h5', 's2', **link_config) #switch 2 port 3
        self.addLink('h6', 's3', **link_config) #switch 3 port 2
        

if __name__ == '__main__':
    topo = TopologyContainer() # build the topology  
    # create a Mininet object with the given topology and a RemoteController
    net = Mininet(topo=topo, link=TCLink,
                  controller=RemoteController('c0', ip='127.0.0.1'),
                  switch=OVSKernelSwitch, 
                  build=False,
                  autoSetMacs=True,
                  autoStaticArp=True)
    net.build() # build the netwwork
    net.start() # start the network
    CLI(net) # give the control to the user
    net.stop()
    os.system('sudo mn -c') # destroy the network
