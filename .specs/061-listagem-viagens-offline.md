# Listar viagens sem rede

- Slug: `listagem-viagens-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/15-carteira-de-viagens.md`, `BUSINESS/BUSINESS.md` §4.4
- Specs relacionadas: `viagem-sqlite`, `ver-viagem-offline`, `carteira`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: a carteira lista as viagens da pessoa, com filtros Todas, Próximas e Rascunhos, e ordena por data de início, rascunhos no fim (`BUSINESS/15`).

Fato: `viagem-sqlite` grava no aparelho a viagem criada online. `ver-viagem-offline` abre uma viagem já escolhida. A lista em si ainda não tinha contrato offline.

Quem sente: a pessoa sem rede que precisa ver quais viagens já estão no aparelho antes de abrir uma.

## 2. Necessidade de negócio

A listagem é a porta de entrada das outras ações offline. Sem ela, a cópia local existe e não se encontra. O sucesso é a carteira mostrar só o que está no SQLite, com os filtros e a ordem já definidos, com a rede desligada.

## 3. Objetivo e resultado observável

Sem rede, a carteira lista as viagens do SQLite, conta os filtros e mantém a ordem. Não cria viagem e não busca a lista na API.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Conta com viagens no SQLite | Ver a própria lista offline | Só viagens gravadas neste aparelho para essa conta |
| Conta sem viagens no SQLite | Ver o estado vazio | Não cria viagem offline |
| Convidado | Ver a carteira vazia | Não tem viagem (`BUSINESS/04`) |

## 5. Escopo

### 5.1 Dentro do escopo

- Ler do SQLite, sem rede, as viagens da conta.
- Filtros Todas, Próximas e Rascunhos, com a contagem de `BUSINESS/15`.
- Ordem: data de início crescente; rascunhos no fim.
- Selo de status calculado com as datas já salvas: rascunho, próxima, acontecendo agora, concluída.
- Estado vazio quando não há viagem, e o texto de filtro sem resultado.
- Toque abre a viagem em `ver-viagem-offline`. Esta fatia não redesenha a capa.

### 5.2 Fora de escopo

- `ver-viagem-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`.
- Criar viagem sem rede. Continua `viagem-sqlite`.
- Baixar viagens de outro aparelho ou da API quando não há rede.
- Filtro de concluídas e transformar rascunho em viagem com data. Continuam `A DEFINIR` em `BUSINESS/15`.
- Sincronizar a lista com a API. Pergunta não bloqueante de `viagem-sqlite`.

## 6. Comportamento esperado

1. Sem rede, a pessoa abre a carteira. A lista sai do SQLite.
2. Todas mostra cada viagem salva. Próximas mostra as que estão acontecendo agora ou com início no futuro. Rascunhos mostra as que têm duração e não têm data.
3. A ordem é a data de início crescente. Rascunho fica depois das que têm data.
4. O selo usa as datas salvas e o dia local do aparelho. Não consulta a rede para saber “hoje”.
5. Sem viagens, aparece “Nenhuma viagem ainda”. Filtro sem item usa o texto já escrito em `BUSINESS/15`.
6. Toque em um cartão abre essa viagem. A capa é a outra spec.
7. A animação de entrada da carteira segue `BUSINESS/15`. Com reduzir movimento, a duração vai a cerca de 0 ms. Se essa redução ainda não estiver na tela, o critério correspondente fica pendente e não bloqueia a lista offline.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado três viagens no SQLite (uma próxima, uma rascunho, uma concluída) e sem rede, quando a carteira abre em Todas, então as três aparecem, a contagem é 3 e a rascunho fica por último; verificado por teste de integração.
- [ ] **AC-2** — Dado as mesmas viagens, quando o filtro Próximas é escolhido sem rede, então a concluída e a rascunho somem e a contagem do chip é a das próximas e das que estão acontecendo; verificado por teste de widget.
- [ ] **AC-3** — Dado só rascunhos, quando o filtro Rascunhos é escolhido sem rede, então a contagem e os cartões batem com as viagens sem data; verificado por teste de widget.
- [ ] **AC-4** — Dado o SQLite sem viagens e sem rede, quando a carteira abre, então o estado “Nenhuma viagem ainda” aparece e nenhuma viagem é criada; verificado por teste de widget.
- [ ] **AC-5** — Dado sem rede, quando a carteira abre, então não há chamada à API para montar a lista; verificado por teste de integração com o cliente HTTP observando zero pedidos.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | A listagem offline é a carteira lendo o SQLite. Não baixa a lista. | pedido de 2026-11-17 | AC-1 e AC-5 |
| P-1 | premissa | Próximas incluem acontecendo agora e futuras, como em `BUSINESS/15`. Concluídas só aparecem em Todas. | produto | AC-2 |
| P-2 | premissa | O “hoje” do selo é o relógio local do aparelho, injetável no teste. | app | AC-1 com data fixa |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | A carteira deixa de depender da rede para listar o que já está no aparelho. |
| Dados                  | Só leitura do SQLite. |
| UI/UX e acessibilidade | Reusa a carteira de `BUSINESS/15`. Sem tela nova. |
| Segurança              | A lista é da conta dona da cópia local. Convidado não vê viagem de outra pessoa. |
| Observabilidade        | Falha ao ler o banco entra no log sem títulos das viagens. |

## 10. Plano de testes

- Widget/unitário: AC-2, AC-3 e AC-4, com relógio fixo.
- Integração: AC-1 e AC-5, com SQLite de teste e cliente HTTP que falha se for chamado.
- Manual no frame 390×844: modo avião, abrir a carteira e trocar os três filtros.
- Casos de borda: viagem acontecendo agora entra em Próximas e em Todas, não em Rascunhos.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| A pessoa espera ver viagens criadas em outro aparelho | alta | médio | AC-5: sem rede não há busca. A cópia é a deste aparelho |

- Rollback: a carteira volta a ler só a memória da sessão e some depois de reabrir sem rede.
- Critério para abortar: se `viagem-sqlite` não gravar a viagem, não invente outra lista local.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Filtro para concluídas | não | produto | continua `A DEFINIR` em `BUSINESS/15` |
| Trazer viagens de outro aparelho quando a rede voltar | não | produto | não bloqueia a lista local |
| Reduzir movimento na animação da carteira | não | produto | não bloqueia os filtros offline |

## 13. Resultado

Pronto quando, sem rede, a carteira lista só as viagens do SQLite, com filtros, contagem e ordem de `BUSINESS/15`, e não chama a API.

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
