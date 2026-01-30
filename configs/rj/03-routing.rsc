# MikroTik RJ - Rotas
# Executar: /import file=03-routing.rsc

/ip route
add dst-address=10.39.2.0/24 gateway=10.255.255.2 comment="Rota para rede PTZ Milao via tunel"
