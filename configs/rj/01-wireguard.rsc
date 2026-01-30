# MikroTik RJ - WireGuard Tunnel
# Executar: /import file=01-wireguard.rsc

/interface wireguard add name=wg-tunel-milao listen-port=51820 comment="Tunel para Milao"

# Chave publica gerada: IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=

/ip address add address=10.255.255.1/30 interface=wg-tunel-milao comment="IP do tunel - lado RJ"

/interface wireguard peers add interface=wg-tunel-milao \
    public-key="SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=" \
    allowed-address=10.255.255.0/30,10.39.2.0/24 \
    persistent-keepalive=25s \
    comment="Peer Milao"
