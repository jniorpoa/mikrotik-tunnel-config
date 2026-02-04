# Changelog

Todas as mudanças notáveis deste projeto.

## [2026-02-04] - NAT VLAN 400

### Adicionado
- NAT para câmera PTZ: 172.16.40.3 → 10.39.2.1
- Integração com VLAN 400 corporativa (br06 porta 31)
- Regra firewall para aceitar tráfego da VLAN 400
- Session log: 2026-02-04-nat-vlan400.md

### Configurado em Produção
- [x] ether4 do HEX-RJ conectada ao br06 porta 31 (VLAN 400)
- [x] IP 172.16.40.3/24 na ether4
- [x] DST-NAT: 172.16.40.3 → 10.39.2.1
- [x] SRC-NAT: resposta via túnel (10.255.255.1)
- [x] Ping CCR → 172.16.40.3 funcionando

### Infraestrutura
- CCR_ROUTER_1-BROADCAST: gateway VLAN 400 (172.16.40.1)
- br06: switch de acesso, porta 31 untagged VLAN 400
- HEX-RJ: ether4-vlan400 com IP 172.16.40.3

---

## [2026-01-30] - Configuração Inicial

### Adicionado
- Estrutura inicial do projeto
- README com diagrama de rede
- CLAUDE.md com instruções
- Estrutura de pastas para configs
- Configs completas Milão (WireGuard): 00-06
- Configs completas RJ (WireGuard): 00-03
- Chaves WireGuard geradas e configuradas
- IP público RJ: 200.166.233.205/28
- Winbox WAN porta 9595
- Peer Mac Junior para testes
- Config WireGuard para Mac (`configs/mac/wg-rj.conf`)
- Guia de troubleshooting (`docs/TROUBLESHOOTING.md`)
- Session log: 2026-01-30-config-inicial.md

### Configurado em Produção
- [x] Milão (HEX-MILAO): interfaces, bridge, IPs, WireGuard, firewall, NAT
- [x] RJ (HEX-RJ): reset, interfaces, IP público, WireGuard, firewall
- [x] Túnel Mac ↔ RJ funcionando
- [x] Túnel Milão ↔ RJ funcionando
- [x] Mac ↔ Milão (via RJ) funcionando
- [x] Câmera PTZ configurada (10.39.2.1)
- [x] Acesso Mac → Câmera funcionando

---

## Concluído
- [x] Testar acesso web câmera via 172.16.40.3 ✅
- [x] Testar controle PTZ (portas 80/443/52380) ✅
- [x] Validar com Henrique no controlador ✅

## A Fazer (se necessário)
- [ ] Configs alternativas (EoIP) - apenas se precisar Layer 2
