# Comandos Úteis

## MikroTik - Winbox/Terminal

### Importar config
```routeros
/import file=nome-arquivo.rsc
```

### Export config
```routeros
# Completo
/export file=backup-full

# Sem senhas
/export hide-sensitive file=backup-clean
```

### WireGuard - Status
```routeros
/interface wireguard print
/interface wireguard peers print
```

### Debug WireGuard
```routeros
/system logging add topics=wireguard action=memory
/log print where topics~"wireguard"
```

### Verificar túnel
```routeros
# Do Milão, pingar RJ pelo túnel
/ping 10.255.255.1

# Verificar handshake
/interface wireguard peers print detail
```

### Reset para factory (CUIDADO)
```routeros
/system reset-configuration no-defaults=yes skip-backup=yes
```

## Git
```bash
# Commit padrão
git add -A && git commit -m "feat(milao): adiciona config wireguard"

# Push
git push origin main
```
