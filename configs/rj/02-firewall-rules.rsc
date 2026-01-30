# MikroTik RJ - Regras de Firewall para WireGuard
# Executar: /import file=02-firewall-rules.rsc
#
# NOTA: Adicionar estas regras ao firewall existente do RJ
# Posicionar ANTES das regras de drop

/ip firewall filter
add chain=input action=accept protocol=udp dst-port=51820 comment="WireGuard UDP - Tunel Milao" place-before=0
add chain=input action=accept src-address=10.255.255.0/30 comment="Aceita do tunel WG Milao" place-before=1
add chain=forward action=accept src-address=10.55.21.0/24 dst-address=10.39.2.0/24 comment="RJ -> PTZ Milao" place-before=0
add chain=forward action=accept src-address=10.39.2.0/24 dst-address=10.55.21.0/24 comment="PTZ Milao -> RJ" place-before=1
