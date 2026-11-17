# 08 — Planos

## Objetivo
Definir o que se vende: nome, preço, duração, ciclo e a lista de features.

## Campos do plano
Nome, preço, duração, ciclo de cobrança, ativo ou inativo.

## Features
Cada plano tem uma lista de features. Dá para adicionar, alterar e remover feature.

## Ações
- Criar plano.
- Editar.
- Ativar ou desativar.

## Regras
- O plano Free existe desde o início e não pode ser desativado nem excluído.
- Plano sem preço não pode ser ativado, exceto o Free.
- Desativar um plano impede nova assinatura nele. Quem já assinou permanece até o fim do ciclo.
- O preço e as features gravados aqui são o que o site de planos mostra (`WEB/03`). O app só mostra o nome do plano e o botão que abre esse site.
