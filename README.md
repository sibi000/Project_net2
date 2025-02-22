# Project_net2

Project for "Networking mod.2" course held by Dr. Granelli, Universiti of Trento.

It is one of the project presented by the professor.
`On Demand SDN Slices in ComNetsEmu`: implement a network slicing approach to enable dynamic activation/de-activation of network slices to observe the traffic and its BW.

This project consists of a network slicing, based on different switchs and host to observe and study how it works. The idea is to handle different BW in different scenario between tre slices.

## Table of Contents

- [Requirements](#requirements)
- [Project Structure](#project-structure)
- [Installation Procedure](#installation-procedure)
- [Topology and slicing](#topology-and-slicing)
  - [Default scenario](#default-scenario)
  - [Slice 2 scenario](#slice-2-scenario)
  - [Slice 3 scenario](#slice-3-scenario)
  - [Both scenario](#both-scenario)
- [Useful Mininet commands](#useful-mininet-commands)
- [Documentation](#documentation)

## Requirements

- ComNetsEmu
- Vagrant
- VirtualBox
- python3
- Mininet

## Project Structure

Here is represented the project tree expanding only the relevant files:

```bash
📦Project_net2
 ┣ 📂images
 ┣ 📂node_modules
 ┣ 📂script
 ┃ ┣ 📜defaultScenario.sh
 ┃ ┣ 📜resetScenario.sh
 ┃ ┣ 📜slice2+3Scenario.sh
 ┃ ┣ 📜slice2Scenario.sh
 ┃ ┣ 📜slice3Scenario.sh
 ┃ ┗ 📜start.sh
 ┣ 📂topologyVisualizer
 ┃ ┣ 📂__pycache__
 ┃ ┣ 📂frontend
 ┃ ┃ ┣ 📜host.svg
 ┃ ┃ ┣ 📜index.html
 ┃ ┃ ┣ 📜router.svg
 ┃ ┃ ┣ 📜ryu.topology.js
 ┃ ┃ ┗ 📜style.css
 ┃ ┣ 📜controller.py
 ┃ ┣ 📜gui_start.py
 ┃ ┗ 📜topology.py
 ┣ 📜.gitignore
 ┣ 📜README.md

```


**The most important folders and file are:**

- `launch.sh`: program that clears mininet and starts the application.
- `topologyVisualizer/`: contains the controller, the gui_start needed and the topology generator of the network.
- `script/`: folder that contains all the scenarios needed to setup the simulations.

## Installation procedure

Assuming already have npm (for javascript), python3 and nodejs on your machine.

Since it is **Strongly advised** to set up **Comnetsemu** and **Vagrant** in a Virtual Machine in order to ensure portability, you should follow these steps:

1. Install [Vagrant](https://www.vagrantup.com) and [VirtualBox](https://www.virtualbox.org)
2. Install [Comnetsemu](https://git.comnets.net/public-repo/comnetsemu#installation)

Another option is to start all this setup on a Linux machine and not on a Virtualbox on Window.

## Topology and Slicing

In this section we can see the topologies, their connections and also the results obtained by the simulations:

### 1. Default Scenario

<img src="images/defaultScenario/topologyDefault.png"
width=100% height=100%></img>

In the Default Scenario we can notice 2 hosts, 2 switches and 1 slice of 10 Mbps between h1 and h2. All the BW is dedicated on this slice in this specific scenario:

- Slice 1 between h1 and h2, using 10 Mbps link.

Doing a `pingall` command are cleary showed all the connection between all the host in this scenario.

<img src="images/defaultScenario/defaultPingAll.png" width="80%" height="80%"></img>

If we test the connection among the hosts, using the `iperf` command, the followed results are obtained:

<img src="images/defaultScenario/default-iperf-h1-h2.png" width="80%" height="80%"></img>

### 2. Slice 2 Scenario

<img src="images/slice2Scenario/topologySlice2.png" 
width=100% height=100%></img>

In the Slice 2 Scenario we can notice 5 hosts, 3 switches and 2 slices. The BW is shared between the two active slice in this specific scenario:

- Slice 1 between h1 and h2, using 6 Mbps link.
- Slice 2 between h3, h4 and h5, using 4 Mbps link.

Doing a `pingall` command are cleary showed all the connection between all the host in this scenario.

<img src="images/slice2Scenario/slice2PingAll.png" width="80%" height="80%"></img>

If we test the connection among the hosts, using the `iperf` command, the followed results are obtained:

<img src="images/slice2Scenario/slice2-iperf-h1-h2.png" width="80%" height="80%"></img>

<img src="images/slice2Scenario/slice2-iperf-h3-h4.png" width="80%" height="80%"></img>

<img src="images/slice2Scenario/slice2-iperf-h3-h5.png" width="80%" height="80%"></img>

<img src="images/slice2Scenario/slice2-iperf-h4-h5.png" width="80%" height="80%"></img>

### 3. Slice 3 Scenario

<img src="images/slice3Scenario/topologySlice3.png"
width=100% height=100%></img>

In the Slice 3 Scenario we can notice 4 hosts, 2 switches and 2 slices. The BW is shared between the two active slice in this specific scenario:

- Slice 1 between h1 and h2, using 6 Mbps link.
- Slice 3 between h6 and h7, using 4 Mbps link.

Doing a `pingall` command are cleary showed all the connection between all the host in this scenario.

<img src="images/slice3Scenario/slice3PingAll.png"
width="80%" height="80%"></img>

If we test the connection among the hosts, using the `iperf` command, the followed results are obtained:

<img src="images/slice3Scenario/slice3-iperf-h1-h2.png" width="80%" height="80%"></img>

<img src="images/slice3Scenario/slice3-iperf-h6-h7.png" width="80%" height="80%"></img>

### 4. All the slice active

<img src="images/slice2+3Scenario/topologyBoth.png"
width=100% height=100%></img>

In the Slice last Scenario, whene all the slices are active, we can notice 7 hosts, 3 switches and 3 slices. The BW is shared between all the tre slices present in this scenario:

- Slice 1 between h1 and h2, using 6 Mbps link.
- Slice 2 between h3, h4 and h5, using 3 Mbps link.
- Slice 3 between h6 and h7, using 4 Mbps link.

Doing a `pingall` command are cleary showed all the connection between all the host in this scenario.

<img src="images/slice2+3Scenario/slice2+3PingAll.png" width="80%" height="80%"></img>

If we test the connection among the hosts, using the `iperf` command, the followed results are obtained:

<img src="images/slice2+3Scenario/slice2+3-iperf-h1-h2.png" width="80%" height="80%"></img>

<img src="images/slice2+3Scenario/slice2+3-iperf-h3-h4.png" width="80%" height="80%"></img>

<img src="images/slice2+3Scenario/slice2+3-iperf-h3-h5.png" width="80%" height="80%"></img>

<img src="images/slice2+3Scenario/slice2+3-iperf-h4-h5.png" width="80%" height="80%"></img>

<img src="images/slice2+3Scenario/slice2+3-iperf-h6-h7.png" width="80%" height="80%"></img>

## Useful Mininet commands

In this GIT you can find everything you need to run these situations in the given network. Of course you can run other tests (or even modifications), and in order to test the various slices here are some of the most useful commands.

NB: The therm `mininet>` is used instead of `~$` to underline that we are inside the mininet CLI while the application is running.

The most useful commands are:

- `mininet> pingall`, which lets all hosts ping each other, it's quite long execution.
- `mininet> iperf <src_host> <dst_host>` e.g. `iperf h1 h3` which lets an host check the avaiable bandwidth between two hosts.
- `mininet> nodes` to check the available nodes in the network.
- `mininet> links ` to display network's links.
- `mininet> <src_host> ping <dst_host>` e.g. `h1 ping h3` which lets an host send some packets through the network to check its reachability.

## Documentation

For more information on the tools used please read these:

- [Mininet](http://mininet.org/walkthrough)
- [RYU Documentation](https://ryu.readthedocs.io/en/latest/)
- [OpenSwitch Command reference](https://docs.pica8.com/display/PICOS2111cg/PicOS+Open+vSwitch+Command+Reference)

