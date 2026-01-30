# MikroTik Milão - Endereçamento IP
# Executar: /import file=03-addressing.rsc

/ip address
add address=10.39.2.254/24 interface=bridge-ptz comment="Gateway rede PTZ"
add address=10.19.4.97/24 interface=ether5-mgmt comment="Gerencia local"

/ip dhcp-client
add interface=ether1-wan disabled=no comment="Internet via DHCP"

/ip dns
set servers=8.8.8.8,8.8.4.4
