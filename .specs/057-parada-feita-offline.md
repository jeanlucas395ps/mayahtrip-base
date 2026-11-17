# Marcar parada como feita sem rede

- Slug: `parada-feita-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/17-roteiro-lista.md`, `BUSINESS/19-detalhe-da-parada.md`, `BUSINESS/BUSINESS.md` §4.3
- Specs relacionadas: `viagem-sqlite`, `roteiro-lista`, `detalhe-da-parada`, `review-offline`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: marcar uma parada como feita mostra o aviso “{lugar} feito” e oferece Avaliar (`BUSINESS/17` e `BUSINESS/19`). Desmarcar não gera aviso. Júnior só visualiza o roteiro.

Quem sente: quem está no lugar, sem rede, e precisa registrar que a parada foi feita.

Premissa: o estado “feita” grava no SQLite. Publicar a avaliação é `review-offline`. Avisar o servidor não faz parte desta fatia.

## 2. Necessidade de negócio

O roteiro no aparelho precisa aceitar esse ajuste sem internet. O sucesso é a parada continuar marcada depois de reabrir o app sem rede.

## 3. Objetivo e resultado observável

Sem rede, quem pode editar o roteiro marca ou desmarca uma parada da viagem salva. O estado permanece no SQLite. Júnior não altera.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono, viajante supremo, viajante experiente | Marcar e desmarcar a parada offline | Só paradas que já estão na viagem salva |
| Assistente júnior | Ver o estado, sem alterar | Não edita o roteiro |

## 5. Escopo

### 5.1 Dentro do escopo

- Sem rede, marcar como feita uma parada já presente no SQLite.
- Desmarcar, sem rede, e persistir os dois estados.
- O aviso “{lugar} feito” aparece ao marcar, como no roteiro. O botão Avaliar pode abrir, mas o conteúdo da avaliação é `review-offline`.
- Reabrir o app sem rede mostra o último estado gravado.

### 5.2 Fora de escopo

- `review-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `link-offline`, `mala-offline`.
- Incluir parada nova, que pode exigir busca de lugar online.
- Sincronizar o “feita” com a API.

## 6. Comportamento esperado

1. Sem rede, dono, supremo ou experiente abrem uma parada da viagem salva e marcam como feita.
2. O SQLite guarda o estado. A lista mostra a parada como feita e o aviso “{lugar} feito”.
3. Desmarcar grava o estado contrário e não mostra esse aviso.
4. Reabrir sem rede mantém o último estado.
5. Júnior vê o estado e não tem a ação de marcar.
6. Parada que não está na viagem não é criada por esta ação.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado dono, supremo ou experiente, parada já no SQLite e sem rede, quando marca como feita, então o SQLite guarda feita e a lista mostra esse estado; verificado por teste de integração.
- [ ] **AC-2** — Dado a parada feita, quando desmarca sem rede, então o SQLite guarda não feita e o aviso “{lugar} feito” não aparece; verificado por teste de widget.
- [ ] **AC-3** — Dado AC-1, quando o app reabre sem rede, então a parada continua feita; verificado por teste de integração.
- [ ] **AC-4** — Dado assistente júnior, quando abre a parada sem rede, então não consegue gravar mudança de estado; verificado por teste de widget.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Marcar ou desmarcar feito, sem rede, persiste no SQLite da parada já salva. | pedido de 2026-11-17 | AC-1 a AC-3 |
| P-1 | premissa | Quem edita o roteiro é quem `BUSINESS.md` §4.3 marca como pode editar: dono, supremo e experiente. | produto | AC-4 |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Estado da parada no SQLite. Sem chamada à API nesta ação. |
| Dados                  | Um campo de feito na parada local. |
| UI/UX e acessibilidade | Reusa o controle e o aviso de `BUSINESS/17` e `BUSINESS/19`. |
| Segurança              | Júnior não grava. |
| Observabilidade        | Falha de gravação no log, sem nome do lugar se isso for evitável; no mínimo sem token. |

## 10. Plano de testes

- Widget/unitário: AC-2 e AC-4.
- Integração: AC-1 e AC-3.
- Manual no frame 390×844: marcar uma parada em modo avião, matar o app e abrir de novo.
- Casos de borda: marcar duas vezes seguidas não duplica registro; o estado continua feita.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Outro participante não vê o “feita” até existir sincronização | alta | médio | Fora desta fatia, dito na pergunta não bloqueante |

- Rollback: a marcação volta a ser só em memória.
- Critério para abortar: se a parada não estiver no SQLite, não crie parada offline nesta spec.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando o estado feito sobe para a API | não | produto | não bloqueia a cópia local |
| Convidar e remover para supremo e experiente | não | produto | continua `A DEFINIR`; não muda quem edita o roteiro nesta fatia |

## 13. Resultado

Pronto quando marcar ou desmarcar uma parada sem rede continua valendo depois de reabrir o app, e o júnior não altera.

## 14. Definition of Ready

- [x] Problema, usuário e valor claros
- [x] Escopo e fora de escopo explícitos
- [x] Critérios de aceite mensuráveis (`AC-*`)
- [x] Premissas com dono e validação
- [x] Impactos mapeados
- [x] Plano de testes definido
- [x] Riscos e rollback definidos
- [x] Sem pergunta bloqueante em aberto
- [ ] Spec revisada com `refine-spec`
- [ ] Aprovada pelo responsável

Dependências para implementar, não para ler esta spec:

- `viagem-sqlite` em `052-viagem-sqlite.md`
