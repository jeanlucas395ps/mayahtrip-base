# 17 — Expiração de assinaturas

## Objetivo
Rodar a checagem de quem passou da data fim do plano.

## O que mostra
Data e resultado da última execução: quantas assinaturas venceram e quantas falharam.

## Ação
Disparar a mesma checagem agora, fora do horário diário. O registro fica no histórico do job. Não entra na fila de `16`.

## Regras
- A checagem tira o PRO de quem venceu e não tem renovação paga, cupom vigente nem PRO promocional vigente.
- Não cobra ninguém.
- A execução periódica também existe. Esta tela serve para ver a última e disparar uma fora de hora.
