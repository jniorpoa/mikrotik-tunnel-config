# MikroTik Milão - WireGuard Tunnel
# Executar: /import file=04-wireguard.rsc
#
# IMPORTANTE: Trocar ENDPOINT_RJ pelo IP público ou DDNS do RJ
# IMPORTANTE: Trocar CHAVE_PUBLICA_RJ pela chave gerada no RJ

/interface wireguard
add name=wg-tunel-rj listen-port=51820 private-key="GERAR_NO_MIKROTIK" comment="Tunel para RJ"

# Após criar a interface, gerar chaves:
# /interface wireguard print (copiar public-key para usar no RJ)

/ip address
add address=10.255.255.2/30 interface=wg-tunel-rj comment="IP do tunel - lado Milao"

/interface wireguard peers
add interface=wg-tunel-rj \
    public-key="CHAVE_PUBLICA_RJ" \
    endpoint-address=ENDPOINT_RJ \
    endpoint-port=51820 \
    allowed-address=10.255.255.0/30,10.55.21.0/24 \
    persistent-keepalive=25s \
    comment="Peer RJ"
