# Instruções para Claude Code

## Contexto
Projeto de configuração de túnel WireGuard entre dois MikroTiks para controle remoto de PTZ.

## Antes de Qualquer Ação
1. Ler README.md para entender estado atual
2. Verificar estrutura de pastas existente
3. Consultar configs relacionadas antes de modificar

## Padrões MikroTik
- Arquivos .rsc com sintaxe RouterOS
- Comentar TODAS as regras: `comment="Propósito da regra"`
- Nomes descritivos em português: `bridge-ptz`, `wg-tunel-rj`, `ether1-wan`
- Firewall: chain input/forward com default drop

## Estrutura de Configs
```
configs/
├── milao/          # Numerados 00-99 por ordem de execução
├── rj/             # Apenas configs incrementais do túnel
└── alternativa-eoip/  # Fallback Layer 2
```

## Ao Criar/Modificar .rsc
- Testar sintaxe quando possível
- Manter idempotência (pode rodar múltiplas vezes)
- Incluir comandos de remoção antes de criar (quando seguro)

## Ao Final de Sessão
- Atualizar README.md com novo status
- Adicionar entrada no CHANGELOG.md
- Criar session log em docs/sessions/YYYY-MM-DD-descricao.md
- Commit com mensagem descritiva

## Não Fazer
- Modificar arquivos fora do escopo da tarefa
- Usar placeholders como "INSERIR_IP_AQUI"
- Alterar configs de gerência sem confirmação explícita
- Remover comentários existentes nas configs
