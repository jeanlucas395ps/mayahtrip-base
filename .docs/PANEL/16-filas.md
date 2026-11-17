# 16 — Filas

## Objetivo
Destravar o trabalho assíncrono sem entrar no servidor.

## Filas

O transporte é Kafka. O estado de cada job fica no Postgres. O painel não publica em tópico. O modelo está em `TECH/TECH.md`.

- Geração de roteiro
- Notificação (central do app e push, juntas)
- Ingestão de conteúdo

A expiração de assinatura não é uma dessas filas. É um job diário (`17`).

## O que mostra
Pendentes, processando e falhos, por fila. O resumo também aparece no dashboard (`01`).

## Ações
- Limpar jobs pendentes ou em processamento de uma fila.
- Marcar como falha a viagem cuja geração de roteiro ficou presa.
- Recolocar um job na fila.
- Recolocar todos os falhos de uma fila.
- Apagar um job falho.
- Esvaziar a fila de falhos.

## Regras
- Limpar job em processamento não apaga a viagem. A geração daquele roteiro passa a falha e o usuário vê o roteiro como não concluído.
- Recolocar não duplica um job que ainda está pendente ou processando.
- Apagar job falho não apaga a viagem, o pagamento nem a notificação já entregue.
- O nome do provedor de push continua `A DEFINIR` em `ARCHITECTURE.md`. Esta tela mostra o job de notificação, não a conta do provedor.
