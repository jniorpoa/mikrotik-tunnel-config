# MikroTik Milão - Firewall
# Executar: /import file=06-firewall.rsc

/ip firewall filter

# --- INPUT ---
add chain=input action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=input action=drop connection-state=invalid comment="Descarta invalidas"
add chain=input action=accept protocol=icmp comment="Aceita ICMP"
add chain=input action=accept src-address=10.19.4.0/24 in-interface=ether5-mgmt comment="Aceita gerencia local"
add chain=input action=accept protocol=udp dst-port=51820 in-interface=ether1-wan comment="WireGuard UDP"
add chain=input action=accept src-address=10.255.255.0/30 comment="Aceita do tunel WG"
add chain=input action=drop in-interface=ether1-wan comment="Bloqueia resto da WAN"

# --- FORWARD ---
add chain=forward action=accept connection-state=established,related comment="Aceita conexoes estabelecidas"
add chain=forward action=drop connection-state=invalid comment="Descarta invalidas"
add chain=forward action=accept src-address=10.55.21.0/24 dst-address=10.39.2.0/24 comment="RJ -> PTZ permitido"
add chain=forward action=accept src-address=10.39.2.0/24 dst-address=10.55.21.0/24 comment="PTZ -> RJ permitido"
add chain=forward action=drop in-interface=ether1-wan comment="Bloqueia forward da WAN"

# --- NAT ---
/ip firewall nat
add chain=srcnat out-interface=ether1-wan action=masquerade comment="NAT para internet"
