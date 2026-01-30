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
- IP público RJ: 200.166.233.206/28
- Session log: 2026-01-30-config-inicial.md

### Configurado em Produção
- [x] Milão: interfaces, bridge, IPs, WireGuard, firewall, NAT
- [x] RJ: reset, interfaces, IP público, WireGuard, firewall

### A Fazer
- [ ] Testar túnel (ping 10.255.255.x)
- [ ] Conectar PTZ e validar controle
- [ ] Configs alternativas (EoIP)
