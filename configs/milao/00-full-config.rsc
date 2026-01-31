# MikroTik Milão - Configuracao Completa
# Executar apos reset: /import file=00-full-config.rsc
# WAN: DHCP
# Gerencia: 10.19.4.97/24

# Identity
/system identity set name=HEX-MILAO

# Gerencia
/ip address add address=10.19.4.97/24 interface=ether5 comment="Gerencia local"

# Nomear interfaces
/interface ethernet set ether1 name=ether1-wan comment="WAN - Internet DHCP"
/interface ethernet set ether2 name=ether2-ptz comment="PTZ Camera"
/interface ethernet set ether3 name=ether3-reserva comment="Reserva PTZ"
/interface ethernet set ether4 name=ether4-reserva comment="Reserva PTZ"
/interface ethernet set ether5 name=ether5-mgmt comment="Gerencia - FORA do tunel"

# Bridge PTZ
/interface bridge add name=bridge-ptz comment="Bridge para cameras PTZ"
/interface bridge port add bridge=bridge-ptz interface=ether2-ptz comment="PTZ Camera principal"
/interface bridge port add bridge=bridge-ptz interface=ether3-reserva comment="Reserva"
/interface bridge port add bridge=bridge-ptz interface=ether4-reserva comment="Reserva"

# Enderecos IP
/ip address add address=10.39.2.254/24 interface=bridge-ptz comment="Gateway rede PTZ"
/ip dhcp-client add interface=ether1-wan disabled=no comment="Internet via DHCP"
/ip dns set servers=8.8.8.8,8.8.4.4

# WireGuard
/interface wireguard add name=wg-tunel-rj listen-port=51820 comment="Tunel para RJ"
/ip address add address=10.255.255.2/30 interface=wg-tunel-rj comment="IP do tunel - lado Milao"

# Peer RJ (inclui Mac Junior no allowed-address para roteamento)
/interface wireguard peers add interface=wg-tunel-rj \
    public-key="IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=" \
    endpoint-address=200.166.233.205 \
    endpoint-port=51820 \
    allowed-address=10.255.255.0/30,10.55.21.0/24,10.255.255.5/32 \
    persistent-keepalive=25s \
    comment="Peer RJ"

# Rotas
/ip route add dst-address=10.55.21.0/24 gateway=10.255.255.1 comment="Rota para rede RJ via tunel"
/ip route add dst-address=10.255.255.5/32 gateway=wg-tunel-rj comment="Rota Mac Junior"

# Firewall
/ip firewall filter
add chain=input action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=input action=drop connection-state=invalid comment="Descarta invalidas"
add chain=input action=accept protocol=icmp comment="Aceita ICMP"
add chain=input action=accept src-address=10.19.4.0/24 in-interface=ether5-mgmt comment="Aceita gerencia local"
add chain=input action=accept protocol=udp dst-port=51820 in-interface=ether1-wan comment="WireGuard UDP"
add chain=input action=accept src-address=10.255.255.0/30 comment="Aceita do tunel WG"
add chain=input action=accept src-address=10.255.255.5 comment="Aceita Mac Junior"
add chain=input action=drop in-interface=ether1-wan comment="Bloqueia resto da WAN"
add chain=forward action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=forward action=drop connection-state=invalid comment="Descarta invalidas"
add chain=forward action=accept src-address=10.55.21.0/24 dst-address=10.39.2.0/24 comment="RJ -> PTZ permitido"
add chain=forward action=accept src-address=10.39.2.0/24 dst-address=10.55.21.0/24 comment="PTZ -> RJ permitido"
add chain=forward action=accept src-address=10.255.255.5 dst-address=10.39.2.0/24 comment="Mac -> PTZ permitido"
add chain=forward action=accept src-address=10.39.2.0/24 dst-address=10.255.255.5 comment="PTZ -> Mac permitido"
add chain=forward action=drop in-interface=ether1-wan comment="Bloqueia forward da WAN"

# NAT
/ip firewall nat add chain=srcnat out-interface=ether1-wan action=masquerade comment="NAT para internet"
