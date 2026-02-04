# MikroTik RJ - VLAN 500 trunk na ether4 + NAT camera PTZ
# Prerequisito: br06 porta 31 configurada como trunk
#   - VLAN 400 untagged (native, PVID 400)
#   - VLAN 500 tagged
#
# No br06:
# /interface bridge vlan set [find where vlan-ids=500 !dynamic] tagged=sfp-sfpplus1,sfp-sfpplus2,ether31
#
# Executar no HEX-RJ via terminal ou import
# Data: 2026-02-04

# VLAN 500 sobre ether4 (trunk)
/interface vlan add name=vlan500-ptz vlan-id=500 interface=ether4-vlan400 \
    comment="VLAN 500 - PTZ rede 172.16.50.x (trunk ether4)"

# IP da camera na VLAN 500
/ip address add address=172.16.50.171/24 interface=vlan500-ptz \
    comment="IP camera PTZ - NAT para Milao (VLAN 500)"

# NAT - Traducao IP camera PTZ (VLAN 500)
/ip firewall nat add chain=dstnat dst-address=172.16.50.171 action=dst-nat \
    to-addresses=10.39.2.1 comment="NAT camera PTZ Milao - VLAN 500"
# SNAT ja existente cobre (match por dst-address=10.39.2.1)

# Firewall - Input
/ip firewall filter add chain=input action=accept src-address=172.16.50.0/24 \
    comment="Aceita VLAN 500 - PTZ"

# Firewall - Forward
/ip firewall filter add chain=forward action=accept \
    src-address=172.16.50.0/24 dst-address=10.39.2.0/24 \
    comment="VLAN 500 -> PTZ Milao via NAT"
/ip firewall filter add chain=forward action=accept \
    src-address=10.39.2.0/24 dst-address=172.16.50.0/24 \
    comment="PTZ Milao -> VLAN 500"
