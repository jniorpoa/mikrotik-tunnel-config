# Diagrama de Rede Detalhado

## Visão Geral
```
                           ┌─────────────────┐
                           │    INTERNET     │
                           └────────┬────────┘
                                    │
            ┌───────────────────────┼───────────────────────┐
            │                       │                       │
      ┌─────┴─────┐                 │                ┌──────┴─────┐
      │  MILÃO    │                 │                │     RJ     │
      │  (DHCP)   │                 │                │ (IP Fixo)  │
      └─────┬─────┘                 │                └──────┬─────┘
            │                       │                       │
   ┌────────┴────────┐              │              ┌────────┴────────┐
   │   MikroTik      │              │              │   MikroTik      │
   │   hEX/hAP       │◄═══WireGuard═══════════════►│   RB/CCR        │
   │                 │    10.255.255.0/30          │                 │
   │ ether1: WAN     │    UDP 51820                │                 │
   │ ether2-4: PTZ   │                             │                 │
   │ ether5: Mgmt    │                             │                 │
   └───────┬─────────┘                             └────────┬────────┘
           │                                                │
    ┌──────┴──────┐                                  ┌──────┴──────┐
    │ 10.39.2.0/24│                                  │10.55.21.0/24│
    │             │                                  │             │
    │ PTZ .1      │                                  │ Controller  │
    │ [reserva]   │                                  │             │
    └─────────────┘                                  └─────────────┘
```

## Fluxo de Tráfego PTZ
```
Controlador (10.55.21.x)
        │
        ▼
   MK RJ (rota 10.39.2.0/24 via wg0)
        │
        ▼ WireGuard (criptografado)
        │
   MK Milão (recebe, roteia pra bridge)
        │
        ▼
   PTZ (10.39.2.1:80/443/52380)
```

## Portas PTZ Panasonic AW-UE70

| Porta | Protocolo | Função |
|-------|-----------|--------|
| 80 | TCP | Web interface |
| 443 | TCP | HTTPS |
| 52380 | UDP | Controle PTZ |
| 59152 | UDP | Tally |
