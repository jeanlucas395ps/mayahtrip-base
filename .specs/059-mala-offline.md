# Ajustar a mala sem rede

- Slug: `mala-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/23-mala.md`, `BUSINESS/BUSINESS.md` §4.3
- Specs relacionadas: `viagem-sqlite`, `mala`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: a mala é uma lista compartilhada da viagem. Marcar item atualiza o contador. Item novo entra no último grupo (`BUSINESS/23`). Mala individual, e remover ou editar item, estão `A DEFINIR`.

Quem sente: quem arruma a mala sem rede e precisa marcar o que já guardou ou acrescentar um item.

Premissa: ajustar offline é marcar, desmarcar e adicionar item na mala já salva no SQLite. Não inclui a sugestão da Maya, que depende de clima e rede, nem remover ou editar o nome do item.

## 2. Necessidade de negócio

A mala no aparelho tem de acompanhar o que a pessoa faz sem internet. O sucesso é o marcado e o item novo continuarem certos depois de reabrir o app sem rede.

## 3. Objetivo e resultado observável

Sem rede, quem pode editar a viagem marca ou desmarca itens e adiciona um item na mala salva. O progresso e a lista permanecem no SQLite. Júnior não altera.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono, viajante supremo, viajante experiente | Marcar, desmarcar e adicionar item offline | Não remove nem renomeia item; isso segue `A DEFINIR` |
| Assistente júnior | Ver a lista e o progresso | Não edita |

## 5. Escopo

### 5.1 Dentro do escopo

- Sem rede, marcar e desmarcar item da mala que já está no SQLite.
- Sem rede, adicionar um item pelo campo já especificado. Ele entra no último grupo.
- O contador “X de Y prontos” usa o que está no SQLite.
- Reabrir o app sem rede mantém marcas e itens novos.

### 5.2 Fora de escopo

- Sugestão da Maya por clima. Exige rede e não roda aqui.
- Mala individual, remover item e editar item. Continuam `A DEFINIR` em `BUSINESS/23`.
- `despesa-offline`, `arquivo-offline`, `link-offline`, `review-offline`.
- Enviar a mala à API. Pergunta não bloqueante.

## 6. Comportamento esperado

1. Sem rede, dono, supremo ou experiente abrem a mala da viagem salva.
2. Marcar um item aumenta o contador e grava no SQLite. Desmarcar faz o inverso.
3. Adicionar um nome no campo cria o item no último grupo, desmarcado, e mostra o aviso “Item adicionado”.
4. Nome vazio não cria item.
5. Reabrir sem rede mostra as mesmas marcas e o mesmo item novo.
6. Júnior vê a lista e não dispara essas gravações.
7. Sem mala salva para essa viagem, a tela não inventa a lista padrão nesta fatia. A lista padrão entra quando `viagem-sqlite` ou `mala` a gravar. Se ainda não houver itens, o estado é lista vazia, e adicionar o primeiro item cria o grupo final.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado quem pode editar, mala no SQLite e sem rede, quando marca um item, então o SQLite guarda o item como pronto e o contador sobe; verificado por teste de integração.
- [ ] **AC-2** — Dado o item marcado, quando desmarca sem rede, então o SQLite guarda como não pronto e o contador desce; verificado por teste de integração.
- [ ] **AC-3** — Dado um nome não vazio, quando adiciona o item sem rede, então ele existe no último grupo, desmarcado, e continua lá depois de reabrir o app sem rede; verificado por teste de integração.
- [ ] **AC-4** — Dado nome vazio, quando confirma, então nenhum item novo entra; verificado por teste de widget.
- [ ] **AC-5** — Dado assistente júnior, quando abre a mala sem rede, então não marca nem adiciona item; verificado por teste de widget.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Ajuste offline da mala é marcar, desmarcar e adicionar item no SQLite. Remover, editar e mala individual continuam fora. | pedido de 2026-11-17 | AC-1 a AC-4; `BUSINESS/23` segue `A DEFINIR` no resto |
| P-1 | premissa | Júnior não edita a viagem, então não grava a mala. | produto | AC-5, alinhado a `BUSINESS.md` §4.3 |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Mala local no SQLite. Sem chamada à API nesta fatia. |
| Dados                  | Itens e o marcado no banco local da viagem. |
| UI/UX e acessibilidade | Reusa a tela de `BUSINESS/23`. A sugestão de clima não aparece como ação que funcione sem rede. |
| Segurança              | Júnior não grava. |
| Observabilidade        | Falha de gravação no log sem a lista de itens. |

## 10. Plano de testes

- Widget/unitário: AC-4 e AC-5.
- Integração: AC-1, AC-2 e AC-3.
- Manual no frame 390×844: em modo avião, marcar um item, adicionar outro e reabrir o app.
- Casos de borda: marcar o último item pendente leva o contador a “Y de Y”; o aviso “Mala completa. Boa viagem!” segue `BUSINESS/23` se essa tela já o tiver. Não é critério novo de offline.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Duas pessoas ajustam a mala offline e divergem | alta | médio | Sincronização fora desta fatia |

- Rollback: a mala volta a existir só em memória.
- Critério para abortar: se `BUSINESS/23` passar a impedir adicionar item, pare. Não mantenha o campo por causa desta spec.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando a mala offline sobe para a API | não | produto | não bloqueia o ajuste local |
| Mala individual, remover e editar item | não | produto | continua `A DEFINIR` em `BUSINESS/23` |
| Qual lista padrão definitiva o assistente grava na criação | não | produto | continua `A DEFINIR`; esta fatia não escolhe a lista |

## 13. Resultado

Pronto quando marcar, desmarcar e adicionar item na mala, sem rede, continuam certos depois de reabrir o app.

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
