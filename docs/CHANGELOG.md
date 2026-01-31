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
- [x] Milão: interfaces, bridge, IPs, WireGuard, firewall, NAT
- [x] RJ: reset, interfaces, IP público, WireGuard, firewall
- [x] Túnel testado com Mac (funcionando)

### A Fazer
- [ ] Testar túnel Milão ↔ RJ (quando Milão tiver internet)
- [ ] Conectar PTZ e validar controle
- [ ] Configs alternativas (EoIP)
