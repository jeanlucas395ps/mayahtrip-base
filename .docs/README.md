# Documentação MayahTrip

Este repositório guarda a documentação e as skills de agente do MayahTrip. O código da plataforma fica em quatro repositórios separados, listados em `ARCHITECTURE.md`.

O produto é um app para planejar e viver uma viagem num só lugar: roteiro, gastos do grupo, mala, documentos e descobertas da comunidade.

## Ordem de leitura

1. `BUSINESS/BUSINESS.md` — por que o produto existe, regras globais e índice das funcionalidades (`00` a `35`). O painel interno está em `PANEL/PANEL.md`. A assinatura do viajante está em `WEB/WEB.md`.
2. `ARCHITECTURE.md` — repositórios, stack e fronteiras entre os sistemas.
3. `TECH/TECH.md` — dados, filas, ingestão e o que a operação técnica acrescenta ao painel. Item `A DEFINIR` não entra no código.
4. `DESIGN.md` — fonte visual (cores, tipo, movimento, componentes). `DESIGN_SYSTEM.md` é o contrato curto para não violar essas regras.
5. `DEVELOPMENT.md` — como escrever código em cada repositório.
6. `QA.md` — o que precisa passar antes de dar uma tarefa por concluída.
7. `OBSERVABILITY.md` — o que observar desde o primeiro deploy.
8. `AGENTS.md` e `RULES.md` — como um agente de código deve trabalhar aqui. Cursor e Claude seguem as mesmas regras. O commit, quando pedido, é `/commit`: `.cursor/commands/commit.md` e `.claude/commands/commit.md`.

## O que não está neste repositório

App Flutter, API NestJS, painel Angular, site de planos e testes e2e ficam cada um no seu Git.

## Regra de ouro

Tudo que o negócio ou a arquitetura ainda não decidiu está marcado como **`A DEFINIR`**. Não implemente esses pontos por suposição. Pergunte.
