#!/usr/bin/env bash

# run ryu controller
# cd ~/comnetsemu/Project_2/topologyVisualizer
cd /media/projects/Project_2/topologyVisualizer
ryu-manager --observe-links gui_start.py controller.py
sleep 1