# Troubleshooting WireGuard MikroTik

## Checklist Rápido

### 1. Verificar se WireGuard está rodando

**MikroTik:**
```routeros
/interface wireguard print
```
- Flag `R` = Running

**Mac/Linux:**
```bash
sudo wg show
```

### 2. Verificar Peers

**MikroTik:**
```routeros
/interface wireguard peers print detail
```

Procure por:
- `last-handshake` - Se nunca teve handshake, conexão não está estabelecendo
- `rx`/`tx` - Se tem tráfego

**Mac/Linux:**
```bash
sudo wg show
```

Procure por:
- `latest handshake` - Deve mostrar tempo recente (ex: "37 seconds ago")
- `transfer` - Deve mostrar bytes recebidos/enviados

### 3. Handshake funciona mas ping não responde

**Causas comuns:**

1. **Firewall bloqueando** - Verificar se src-address do peer está liberado:
   ```routeros
   /ip firewall filter print
   ```

2. **Falta rota** - Se IP do peer está fora do /30 do túnel:
   ```routeros
   /ip route print
   ```

   Solução: Adicionar rota específica:
   ```routeros
   /ip route add dst-address=10.255.255.X/32 gateway=wg-tunel-nome
   ```

3. **allowed-address incorreto** - Verificar se IPs estão corretos no peer

### 4. Sem handshake

**Verificar:**

1. **Endpoint correto** - IP/porta do servidor está certo?
   ```routeros
   /interface wireguard peers print
   ```

2. **Porta UDP 51820 liberada** no firewall do servidor

3. **Chaves públicas** - Chave pública de A está no peer de B e vice-versa

4. **NAT/Firewall externo** - Porta 51820 UDP precisa chegar no MikroTik

### 5. Debug WireGuard no MikroTik

```routeros
/system logging add topics=wireguard action=memory
/log print where topics~"wireguard"
```

Para remover depois:
```routeros
/system logging remove [find topics=wireguard]
```

## Comandos Úteis

### Testar conectividade

```routeros
# Ping pelo túnel
/ping 10.255.255.X

# Ping com source específico
/ping 10.255.255.X src-address=10.255.255.Y
```

### Ver tráfego em tempo real

```routeros
/tool torch interface=wg-tunel-nome
```

### Resetar peer (força novo handshake)

No MikroTik não tem comando direto, mas pode remover e readicionar o peer.

No Mac/Linux:
```bash
sudo wg-quick down ~/wg-rj.conf && sudo wg-quick up ~/wg-rj.conf
```

## Problemas Específicos

### Túnel cai após algum tempo

- Verificar `persistent-keepalive` está configurado (25s recomendado)
- Se um lado está atrás de NAT, o keepalive mantém a conexão

### Performance ruim

- Verificar MTU (padrão 1420 para WireGuard)
- Testar com pacotes menores:
  ```bash
  ping -s 1000 10.255.255.X
  ```

### Não consegue acessar rede atrás do túnel

1. Verificar rotas:
   ```routeros
   /ip route print
   ```

2. Verificar `allowed-address` inclui a rede de destino

3. Verificar firewall permite forward entre as redes

### Peer A não pinga Peer B (via hub)

Em topologia hub-spoke (RJ como centralizador), para Peer A acessar Peer B:

**No Hub (RJ):**
1. Peer A precisa ter IP do Peer B no `allowed-address` para roteamento
2. Peer B precisa ter IP do Peer A no `allowed-address` para roteamento
3. Firewall precisa permitir forward entre os peers
4. Rotas para ambos os IPs

**No Peer B:**
1. O `allowed-address` do peer hub deve incluir o IP do Peer A
2. Rota para IP do Peer A via túnel
3. Firewall aceitar conexões do IP do Peer A

**Exemplo prático (Mac → Milão via RJ):**

No RJ:
```routeros
# Peer Milão precisa conhecer IP do Mac
/interface wireguard peers set [find comment="Peer Milao"] allowed-address=10.255.255.0/30,10.39.2.0/24

# Forward entre peers
/ip firewall filter add chain=forward action=accept src-address=10.255.255.5 comment="Forward Mac"
/ip firewall filter add chain=forward action=accept dst-address=10.255.255.5 comment="Forward para Mac"
```

No Milão:
```routeros
# Peer RJ precisa incluir IP do Mac
/interface wireguard peers set 0 allowed-address=10.255.255.0/30,10.55.21.0/24,10.255.255.5/32

# Rota para Mac
/ip route add dst-address=10.255.255.5/32 gateway=wg-tunel-rj

# Firewall aceitar Mac
/ip firewall filter add chain=input action=accept src-address=10.255.255.5 comment="Aceita Mac"
```

## Arquitetura da Solução

```
Mac (10.255.255.5) ──────┐
                         │
                         ▼
RJ (200.166.233.205) ◄───┼─── WireGuard UDP 51820
    │                    │
    │ 10.255.255.1/30    │
    │                    │
    └────────────────────┼─── Túnel WG
                         │
                         ▼
Milão (DHCP) ────────────┘
    │
    │ 10.255.255.2/30
    │
    └─► Bridge PTZ (10.39.2.0/24)
            │
            └─► PTZ Camera (10.39.2.1)
```

## IPs e Chaves de Referência

| Local | IP Túnel | Chave Pública |
|-------|----------|---------------|
| RJ | 10.255.255.1 | `IHIbDun/o0cvWiizZ4QuPg6yGZdvSdgTri3PsUFefyM=` |
| Milão | 10.255.255.2 | `SdEiOC6I+VriNU5GgHfC6dXfhLO69iioNDCJQYeeQEk=` |
| Mac | 10.255.255.5 | `VNhVN7vapLi9bIaZ/JPUJBhkt89wfNsowPEt/7/0XWc=` |
