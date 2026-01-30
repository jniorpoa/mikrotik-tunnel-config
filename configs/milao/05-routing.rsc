# MikroTik Milão - Rotas
# Executar: /import file=05-routing.rsc

/ip route
add dst-address=10.55.21.0/24 gateway=10.255.255.1 comment="Rota para rede RJ via tunel"
