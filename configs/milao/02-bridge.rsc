# MikroTik Milão - Bridge PTZ
# Executar: /import file=02-bridge.rsc

/interface bridge
add name=bridge-ptz comment="Bridge para cameras PTZ"

/interface bridge port
add bridge=bridge-ptz interface=ether2-ptz comment="PTZ Camera principal"
add bridge=bridge-ptz interface=ether3-reserva comment="Reserva"
add bridge=bridge-ptz interface=ether4-reserva comment="Reserva"
