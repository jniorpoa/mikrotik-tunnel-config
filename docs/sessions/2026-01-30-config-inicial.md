# Sessão 2026-01-30 - Configuração Inicial

## Resumo
Configuração completa dos dois MikroTik hEX S para túnel WireGuard entre Milão e RJ.

## Equipamentos Configurados

### Milão (hEX S)
- **MAC**: 48:A9:8A:49:0F:FB (ether1)
- **Gerência**: 10.19.4.97/24 (ether5-mgmt)
- **WAN**: DHCP (ether1-wan)
- **Bridge PTZ**: 10.39.2.254/24 (ether2-4)
- **Túnel**: 10.255.255.2/30

### RJ (hEX S)
- **Gerência**: 10.19.4.98/24 (ether5-mgmt)
- **WAN**: 200.166.233.206/28 (ether1-wan)
- **Gateway**: 200.166.233.193
- **Túnel**: 10.255.255.1/30

## Chaves WireGuard

| Local | Chave Pública |
|-------|---------------|
| Milão | `SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=` |
| RJ | `IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=` |

## Comandos Executados

### Milão
1. IP gerência ether5
2. Nomeação interfaces (ether1-wan, ether2-ptz, ether3-4 reserva, ether5-mgmt)
3. Bridge PTZ (ether2-4)
4. IPs (bridge 10.39.2.254, DHCP client WAN)
5. WireGuard interface + IP túnel
6. Rota para rede RJ (10.55.21.0/24)
7. Firewall (input/forward) + NAT masquerade
8. Peer RJ adicionado

### RJ
1. Reset completo (no-defaults)
2. Conectado via MAC Winbox
3. Config completa em bloco único:
   - Gerência, interfaces, IP público, WireGuard, peer Milão, rota, firewall

## Pendências
- [ ] Testar túnel com ping 10.255.255.x
- [ ] Conectar PTZ na ether2 do Milão
- [ ] Testar controle PTZ do RJ
- [ ] Validar portas 80/443/52380

## Arquivos Criados
- `configs/milao/00-full-config.rsc` - Config completa Milão
- `configs/rj/00-full-config.rsc` - Config completa RJ
