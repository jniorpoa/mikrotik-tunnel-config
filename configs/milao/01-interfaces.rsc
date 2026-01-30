# MikroTik Milão - Nomeação de Interfaces
# Executar: /import file=01-interfaces.rsc

/interface ethernet
set [ find default-name=ether1 ] name=ether1-wan comment="WAN - Internet DHCP"
set [ find default-name=ether2 ] name=ether2-ptz comment="PTZ Camera"
set [ find default-name=ether3 ] name=ether3-reserva comment="Reserva PTZ"
set [ find default-name=ether4 ] name=ether4-reserva comment="Reserva PTZ"
set [ find default-name=ether5 ] name=ether5-mgmt comment="Gerencia - FORA do tunel"
