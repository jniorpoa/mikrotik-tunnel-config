# MikroTik Milão - WireGuard Tunnel
# Executar: /import file=04-wireguard.rsc

/interface wireguard add name=wg-tunel-rj listen-port=51820 comment="Tunel para RJ"

# Chave publica gerada: SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=

/ip address add address=10.255.255.2/30 interface=wg-tunel-rj comment="IP do tunel - lado Milao"

/interface wireguard peers add interface=wg-tunel-rj \
    public-key="IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=" \
    endpoint-address=200.166.233.206 \
    endpoint-port=51820 \
    allowed-address=10.255.255.0/30,10.55.21.0/24 \
    persistent-keepalive=25s \
    comment="Peer RJ"
