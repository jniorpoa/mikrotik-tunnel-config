# MikroTik RJ - Configuracao Completa
# Executar apos reset: /import file=00-full-config.rsc
# IP Publico: 200.166.233.205/28
# Gateway: 200.166.233.193
# Winbox WAN: porta 9595

# Identity
/system identity set name=HEX-RJ

# Gerencia
/ip address add address=10.19.4.98/24 interface=ether5 comment="Gerencia RJ"

# Nomear interfaces
/interface ethernet set ether1 name=ether1-wan comment="WAN - IP Publico"
/interface ethernet set ether2 name=ether2-lan comment="LAN RJ"
/interface ethernet set ether3 name=ether3-reserva comment="Reserva"
/interface ethernet set ether4 name=ether4-reserva comment="Reserva"
/interface ethernet set ether5 name=ether5-mgmt comment="Gerencia"

# IP Publico
/ip address add address=200.166.233.205/28 interface=ether1-wan comment="IP Publico"
/ip route add gateway=200.166.233.193 comment="Gateway internet"
/ip dns set servers=8.8.8.8,8.8.4.4

# WireGuard
/interface wireguard add name=wg-tunel-milao listen-port=51820 comment="Tunel para Milao"
/ip address add address=10.255.255.1/30 interface=wg-tunel-milao comment="IP do tunel - lado RJ"

# Peer Milao
/interface wireguard peers add interface=wg-tunel-milao \
    public-key="SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=" \
    allowed-address=10.255.255.0/30,10.39.2.0/24 \
    persistent-keepalive=25s \
    comment="Peer Milao"

# Peer Mac Junior (teste/gerencia remota)
/interface wireguard peers add interface=wg-tunel-milao \
    public-key="VNhVN7vapLi9bIaZ/JPUJBhkt89wfNsowPEt/7/0XWc=" \
    allowed-address=10.255.255.5/32 \
    comment="Mac Junior"

# Rota para PTZ Milao
/ip route add dst-address=10.39.2.0/24 gateway=10.255.255.2 comment="Rota para rede PTZ Milao via tunel"
/ip route add dst-address=10.255.255.5/32 gateway=wg-tunel-milao comment="Rota Mac Junior"

# Firewall
/ip firewall filter
add chain=input action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=input action=drop connection-state=invalid comment="Descarta invalidas"
add chain=input action=accept protocol=icmp comment="Aceita ICMP"
add chain=input action=accept src-address=10.19.4.0/24 in-interface=ether5-mgmt comment="Aceita gerencia local"
add chain=input action=accept protocol=udp dst-port=51820 in-interface=ether1-wan comment="WireGuard UDP"
add chain=input action=accept src-address=10.255.255.0/30 comment="Aceita do tunel WG"
add chain=input action=accept src-address=10.255.255.5 comment="Aceita Mac Junior"
add chain=input action=accept protocol=tcp dst-port=9595 in-interface=ether1-wan comment="Winbox WAN"
add chain=input action=drop in-interface=ether1-wan comment="Bloqueia resto da WAN"

# Winbox porta 9595
/ip service set winbox port=9595
add chain=forward action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=forward action=drop connection-state=invalid comment="Descarta invalidas"
add chain=forward action=accept src-address=10.55.21.0/24 dst-address=10.39.2.0/24 comment="LAN RJ -> PTZ Milao"
add chain=forward action=accept src-address=10.39.2.0/24 dst-address=10.55.21.0/24 comment="PTZ Milao -> LAN RJ"
add chain=forward action=drop in-interface=ether1-wan comment="Bloqueia forward da WAN"
