#!/usr/bin/env bash

# run ryu controller
cd /media/projects/Project_net2/topologyVisualizer
ryu-manager --observe-links gui_start.py controller.py
sleep 1