#!/usr/bin/env bash


cd ~/comnetsemu/Project_net2/topologyVisualizer

#run Mininet
sudo mn -c &>/dev/null
echo "Mininet cleaned"
sudo python3 topology.py


# run ryu controller
ryu-manager --observe-links gui_start.py controller.py &
sleep 1

