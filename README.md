# MikroTik Tunnel Config

Configuração de túnel WireGuard entre MikroTiks (Milão ↔ RJ) para controle remoto de câmeras PTZ Panasonic.

## Status
🟢 **Operacional** - Túnel funcionando + NAT VLAN 400 configurado

## Diagrama
```
┌─────────────────────────────────────────────────────────────────────────┐
│                              INTERNET                                    │
└─────────────────────────────────────────────────────────────────────────┘
         │ DHCP                                        │ IP Fixo
         │                                             │ 200.166.233.205
    ┌────┴────┐                                   ┌────┴────┐
    │   MK    │                                   │   MK    │
    │  MILÃO  │◄══════════ WireGuard ══════════►│   RJ    │
    └────┬────┘         10.255.255.0/30           └────┬────┘
         │                                             │
    ┌────┴─────────────────┐                     ┌────┴─────────────────────┐
    │  BRIDGE (ether2-4)   │                     │  ether4 (VLAN 400)       │
    │    10.39.2.0/24      │                     │  172.16.40.3 ← NAT       │
    ├──────────────────────┤                     │                          │
    │ ether2: PTZ 10.39.2.1│◄─── NAT ───────────│  DST-NAT: 172.16.40.3    │
    │ ether3: [reserva]    │     traduz         │       → 10.39.2.1        │
    │ ether4: [reserva]    │                     └────┬─────────────────────┘
    └──────────────────────┘                          │
                                                      │ VLAN 400
    ┌──────────────────────┐                     ┌────┴─────────────────────┐
    │  GERÊNCIA (ether5)   │                     │  br06 (porta 31)         │
    │    10.19.4.97/24     │                     │       ↓                  │
    └──────────────────────┘                     │  Core → SW Andares       │
          MILÃO                                  │       ↓                  │
                                                 │  Controlador PTZ         │
                                                 │  (acessa 172.16.40.3)    │
                                                 └──────────────────────────┘
                                                          RJ
```

## Redes

| Local | Interface | Range | Gateway |
|-------|-----------|-------|---------|
| Milão | ether1 | DHCP (internet) | - |
| Milão | bridge-ptz (ether2-4) | 10.39.2.0/24 | .254 |
| Milão | ether5 (gerência) | 10.19.4.97/24 | - |
| RJ | ether4 (VLAN 400) | 172.16.40.3/24 | .1 (CCR) |
| RJ | ether5 (gerência) | 10.19.4.98/24 | - |
| Túnel | WireGuard | 10.255.255.0/30 | - |

## Equipamentos

- **PTZ Panasonic AW-UE70**
  - IP Real: 10.39.2.1 (Milão)
  - IP NAT: 172.16.40.3 (acessível da VLAN 400 no RJ)
  - Controle: TCP 80/443, UDP 52380
- **MikroTik Milão**: hEX S (RB760iGS) - Gerência: 10.19.4.97
- **MikroTik RJ**: hEX S (RB760iGS) - Gerência: 10.19.4.98 - WAN: 200.166.233.205/28 - Winbox: 9595

## Infraestrutura RJ

```
CCR Broadcast (GW VLANs) → Core1/Core2 → br01-br06 → SW Andares
                                              ↓
                                        br06 porta 31
                                        VLAN 400 untagged
                                              ↓
                                        HEX-RJ ether4
```

## Configuração

### Ordem de Execução - Milão

1. `00-reset-config.rsc` - Reset inicial (opcional)
2. `01-interfaces.rsc` - Nomear interfaces
3. `02-bridge.rsc` - Criar bridge PTZ
4. `03-addressing.rsc` - IPs
5. `04-wireguard.rsc` - Túnel
6. `05-routing.rsc` - Rotas
7. `06-firewall.rsc` - Regras de segurança

### Ordem de Execução - RJ

1. `01-wireguard.rsc` - Interface e peer
2. `02-firewall-rules.rsc` - Liberar portas
3. `03-routing.rsc` - Rota para rede Milão

### Alternativa (EoIP)

Se precisar de Layer 2 (broadcast), usar configs em `configs/alternativa-eoip/`

## Links Úteis

- [Panasonic AW-UE70 Manual](https://pro-av.panasonic.net/en/products/aw-ue70/index.html)
- [MikroTik WireGuard](https://help.mikrotik.com/docs/display/ROS/WireGuard)
