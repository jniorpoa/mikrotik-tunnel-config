# Changelog

Todas as mudanças notáveis deste projeto.

## [Unreleased]

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

### A Fazer
- [ ] Testar controle PTZ do RJ (portas 80/443/52380)
- [ ] Validação final em produção
- [ ] Configs alternativas (EoIP)
