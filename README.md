# MikroTik Tunnel Config

Configuração de túnel WireGuard entre MikroTiks (Milão ↔ RJ) para controle remoto de câmeras PTZ Panasonic.

## Status
🟡 Em desenvolvimento

## Diagrama
```
┌─────────────────────────────────────────────────────────────────────────┐
│                              INTERNET                                    │
└─────────────────────────────────────────────────────────────────────────┘
         │ DHCP                                        │ IP Fixo
         │                                             │
    ┌────┴────┐                                   ┌────┴────┐
    │   MK    │                                   │   MK    │
    │  MILÃO  │◄══════════ WireGuard ══════════►│   RJ    │
    └────┬────┘         10.255.255.0/30           └────┬────┘
         │                                             │
    ┌────┴─────────────────┐                     ┌────┴────┐
    │  BRIDGE (ether2-4)   │                     │  REDE   │
    │    10.39.2.0/24      │                     │   RJ    │
    ├──────────────────────┤                     │10.55.21.0/24
    │ ether2: PTZ 10.39.2.1│                     └─────────┘
    │ ether3: [reserva]    │                          │
    │ ether4: [reserva]    │                     Controlador
    └──────────────────────┘                        PTZ

    ┌──────────────────────┐
    │  GERÊNCIA (ether5)   │  ← FORA do túnel
    │    10.19.4.97/24     │
    └──────────────────────┘
```

## Redes

| Local | Interface | Range | Gateway |
|-------|-----------|-------|---------|
| Milão | ether1 | DHCP (internet) | - |
| Milão | bridge-ptz (ether2-4) | 10.39.2.0/24 | .254 |
| Milão | ether5 (gerência) | 10.19.4.97/24 | - |
| RJ | LAN | 10.55.21.0/24 | .254 |
| Túnel | WireGuard | 10.255.255.0/30 | - |

## Equipamentos

- **PTZ**: Panasonic AW-UE70 (IP: 10.39.2.1)
  - Controle: TCP 80/443, UDP 52380
- **MikroTik Milão**: [modelo a definir]
- **MikroTik RJ**: [modelo a definir]

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
