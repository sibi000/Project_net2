from ryu.controller import ofp_event
from ryu.controller.handler import set_ev_cls
from ryu.base import app_manager
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
#Ryu is a framework and works as an SDN controller

class TrafficSlicing(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(TrafficSlicing, self).__init__(*args, **kwargs)

        # The mac_to_port structure describes for each switch the mapping between MAC addresses and the corresponding switch port
        self.mac_to_port = {
            1: {
                "00:00:00:00:00:01": 3, # host 1 port 3
                "00:00:00:00:00:07": 4, # host 7 port 4
            },
            2: {
                
                "00:00:00:00:00:04": 2, # host 4 port 2
                "00:00:00:00:00:05": 3, # host 5 port 3
            },
            3: {
                "00:00:00:00:00:06": 2, # host 6 port 2
                "00:00:00:00:00:02": 3, # host 2 port 3
                "00:00:00:00:00:03": 4, # host 3 port 4
            },
        }



    # Decoration function called when the Ryu controller receives an EventOFPSwitchFeatures event from a switch
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)

    # When a switch connects, it sets a 'table-miss' rule to send unknown packets to the controller
    def switch_features_handler(self, ev): 
        # read some useful information (datapath, OF protocol) and creates the parser object
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        # install the table-miss flow entry
        match = parser.OFPMatch() # matching objects for incoming packets
        actions = [
            parser.OFPActionOutput(ofproto.OFPP_CONTROLLER, ofproto.OFPCML_NO_BUFFER) # action object: the entire packet will be forwarded to the Ryu controller for further processing
        ]
        # add the new flow entry
        self.add_flow(datapath, 0, match, actions)
    
    # Adds a flow rule so that future packets are forwarded directly from the switch
    def add_flow(self, datapath, priority, match, actions):
        # read some useful information
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        # construct OFPFlowMod message
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS, actions)]
        mod = parser.OFPFlowMod(
            datapath=datapath, priority=priority, match=match, instructions=inst
        )
        # sand the OFPFlowMod message
        datapath.send_msg(mod)

    # create and OFPPacketOut packet and sand it to the switch to instruct it to send a packet out a specific port
    def _send_package(self, msg, datapath, in_port, actions):
        # ...
        data = None
        ofproto = datapath.ofproto
        if msg.buffer_id == ofproto.OFP_NO_BUFFER:
            data = msg.data
        # create the OFPPacketOut packet
        out = datapath.ofproto_parser.OFPPacketOut(
            datapath=datapath,
            buffer_id=msg.buffer_id,
            in_port=in_port,
            actions=actions,
            data=data,
        )
        # sand the OFPPacketOut packet
        datapath.send_msg(out)

    # When a packet arrives at the controller, it checks the destination and forwards it to the correct port.
    # Decorator function called when a new packet is received by a switch
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        # reads some useful data
        msg = ev.msg
        datapath = msg.datapath
        in_port = msg.match["in_port"]
        pkt = packet.Packet(msg.data)
        eth = pkt.get_protocol(ethernet.ethernet)
        if eth.ethertype == ether_types.ETH_TYPE_LLDP:
            return
        # find the destination and sand the packet to it
        dst = eth.dst # reading the eth destinaion
        dpid = datapath.id # reading the dpid of the switch
        if dst in self.mac_to_port[dpid]: # if there's a match in the mac_to_port table
            out_port = self.mac_to_port[dpid][dst] # pick the out_port where to sand the packet
            actions = [datapath.ofproto_parser.OFPActionOutput(out_port)] # create an OFPActionOutput object with the picked port
            match = datapath.ofproto_parser.OFPMatch(eth_dst=dst) # create a match object that matches with a the read Ethernet destination
            self.add_flow(datapath, 1, match, actions) # add the flow
            self._send_package(msg, datapath, in_port, actions) # sand the packet