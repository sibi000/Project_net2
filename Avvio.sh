#!/usr/bin/env bash


cd ~/comnetsemu/Project_net2/topologyVisualizer

#cleaning Mininet
sudo mn -c &>/dev/null
echo "Mininet cleaned"

# run ryu controller
ryu-manager --observe-links gui_start.py controller.py &
sleep 1 

#run Mininet
sudo python3 topology.py




