# Sessão 2026-01-30 - Configuração Inicial

## Resumo
Configuração completa dos dois MikroTik hEX S para túnel WireGuard entre Milão e RJ.

## Equipamentos Configurados

### Milão (hEX S) - Identity: HEX-MILAO
- **MAC**: 48:A9:8A:49:0F:FB (ether1)
- **Gerência**: 10.19.4.97/24 (ether5-mgmt)
- **WAN**: DHCP (ether1-wan)
- **Bridge PTZ**: 10.39.2.254/24 (ether2-4)
- **Túnel**: 10.255.255.2/30
- **Câmera PTZ**: 10.39.2.1 (Panasonic)

### RJ (hEX S) - Identity: HEX-RJ
- **Gerência**: 10.19.4.98/24 (ether5-mgmt)
- **WAN**: 200.166.233.205/28 (ether1-wan)
- **Gateway**: 200.166.233.193
- **Túnel**: 10.255.255.1/30
- **Winbox WAN**: porta 9595

## Chaves WireGuard

| Local | Chave Pública |
|-------|---------------|
| Milão | `SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=` |
| RJ | `IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=` |
| Mac Junior | `VNhVN7vapLi9bIaZ/JPUJBhkt89wfNsowPEt/7/0XWc=` |

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

## Ajustes Pós-Config

### RJ
- IP alterado de .206 para **.205**
- Winbox WAN porta **9595**
- Identity: **HEX-RJ**
- Peer Mac Junior adicionado
- Rota e firewall para 10.255.255.5

## Teste do Túnel (Mac)
- Peer criado no RJ para Mac (10.255.255.5)
- Config WireGuard gerada para Mac
- **Problema encontrado**: Handshake funcionava mas ping não
- **Causa**: Faltava rota para 10.255.255.5 (fora do /30)
- **Solução**: `/ip route add dst-address=10.255.255.5/32 gateway=wg-tunel-milao`
- **Resultado**: Túnel Mac ↔ RJ funcionando ✅

## Teste Túnel Milão ↔ RJ
- Endpoint corrigido de .206 para .205 no Milão
- **Resultado**: Handshake OK, rx/tx funcionando ✅

## Acesso Mac → Milão (via RJ)
- **Problema**: Mac não pingava Milão (10.255.255.2)
- **Causa**: Milão não conhecia IP do Mac no allowed-address
- **Solução**:
  - No Milão: `allowed-address` do peer RJ inclui `10.255.255.5/32`
  - No Milão: rota para 10.255.255.5 via wg-tunel-rj
  - No RJ: regras de forward para Mac
- **Resultado**: Mac ↔ Milão funcionando ✅

## Configuração da Câmera PTZ
- Câmera estava com IP antigo: 172.16.40.3
- Adicionado IP temporário no Milão para acessar
- Configurado allowed-address e rotas para 172.16.40.0/24 temporariamente
- Câmera reconfigurada para IP definitivo: **10.39.2.1**
- Removidas configs temporárias
- **Resultado**: Câmera acessível via túnel ✅

## Pendências
- [x] Testar túnel com ping 10.255.255.x
- [x] Configurar peer do Milão
- [x] Testar túnel Milão ↔ RJ
- [x] Conectar PTZ e configurar IP
- [x] Testar acesso Mac → Câmera
- [ ] Testar controle PTZ do RJ (portas 80/443/52380)
- [ ] Validar na produção final

## Arquivos Criados
- `configs/milao/00-full-config.rsc` - Config completa Milão
- `configs/rj/00-full-config.rsc` - Config completa RJ
- `configs/mac/wg-rj.conf` - Config WireGuard para Mac
- `docs/TROUBLESHOOTING.md` - Guia de troubleshooting
