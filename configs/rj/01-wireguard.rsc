# MikroTik RJ - WireGuard Tunnel
# Executar: /import file=01-wireguard.rsc
#
# IMPORTANTE: Trocar CHAVE_PUBLICA_MILAO pela chave gerada no Milão

/interface wireguard
add name=wg-tunel-milao listen-port=51820 private-key="GERAR_NO_MIKROTIK" comment="Tunel para Milao"

# Após criar a interface, gerar chaves:
# /interface wireguard print (copiar public-key para usar no Milão)

/ip address
add address=10.255.255.1/30 interface=wg-tunel-milao comment="IP do tunel - lado RJ"

/interface wireguard peers
add interface=wg-tunel-milao \
    public-key="CHAVE_PUBLICA_MILAO" \
    allowed-address=10.255.255.0/30,10.39.2.0/24 \
    persistent-keepalive=25s \
    comment="Peer Milao"
