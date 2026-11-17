# Publicar avaliação sem rede

- Slug: `review-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/12-avaliar-parada.md`, `BUSINESS/BUSINESS.md` §4.9
- Specs relacionadas: `viagem-sqlite`, `avaliar-parada`, `parada-feita-offline`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: a avaliação exige pelo menos uma foto ou vídeo e uma nota de 1 a 5. Sem isso, publicar fica desativado (`BUSINESS/12`). A avaliação vira publicação no perfil, na página do lugar e no feed quando está online.

Quem sente: quem acabou de visitar o lugar, sem rede, e quer registrar a avaliação antes de esquecer.

Premissa: sem rede, a avaliação fica no SQLite, com a mídia copiada para o aparelho. Ela não aparece para outras pessoas enquanto não houver rede. Como essa publicação sobe para a API fica fora desta fatia.

## 2. Necessidade de negócio

A avaliação não pode depender de sinal no momento da visita. O sucesso é a pessoa encontrar a própria avaliação, com nota e mídia, depois de reabrir o app sem rede.

## 3. Objetivo e resultado observável

Sem rede, uma conta logada publica uma avaliação de parada já salva, com mídia e nota. A avaliação fica no aparelho e abre de novo sem rede. Sem mídia ou sem nota, nada é gravado. Outras pessoas não recebem essa avaliação nesta fatia.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Conta logada, inclusive os papéis da viagem | Guardar a própria avaliação offline | Precisa de ao menos uma mídia e nota de 1 a 5. A parada precisa já estar na viagem salva |
| Convidado | Nada | Publicar pede conta (`BUSINESS/04`) |
| Outra pessoa | Não vê esta avaliação | O feed e a página do lugar das outras contas não mudam nesta fatia |

## 5. Escopo

### 5.1 Dentro do escopo

- Sem rede, preencher a folha de `avaliar-parada` para uma parada já no SQLite.
- Gravar nota, legenda opcional, etiquetas opcionais e a mídia no aparelho, ligados à avaliação no SQLite.
- A pessoa que publicou vê essa avaliação ao reabrir o app sem rede.
- Publicar continua desativado até existir mídia e nota, como em `BUSINESS/12`.
- Convidado não grava.

### 5.2 Fora de escopo

- Fazer a avaliação aparecer no feed, na página do lugar ou no perfil de outra pessoa. Isso exige a API.
- `despesa-offline`, `arquivo-offline`, `link-offline`, `mala-offline`, `rota-offline`.
- Marcar a parada como feita. Isso é `parada-feita-offline`. Avaliar não exige que a parada esteja feita (`BUSINESS/12`).
- Limite de quantidade, tamanho e duração de mídia, que segue `A DEFINIR` em `BUSINESS.md` §10. O teste usa uma foto pequena.
- Sincronizar a avaliação com a API. Pergunta não bloqueante.

## 6. Comportamento esperado

1. Sem rede, a conta logada abre Avaliar na parada já salva.
2. Escolhe uma foto ou vídeo que já está no aparelho, dá uma nota de 1 a 5 e, se quiser, legenda e etiquetas.
3. Publicar grava a avaliação no SQLite e copia a mídia para a área local do app.
4. Reabrir sem rede mostra, para essa conta, a nota e a mídia.
5. Sem mídia ou sem nota, o botão não grava.
6. Convidado não abre a gravação.
7. Uma segunda conta, neste teste, não vê essa avaliação. O app não finge publicação no feed.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado conta logada, parada no SQLite e sem rede, quando publica com ao menos uma mídia e nota de 1 a 5, então a avaliação e a mídia local estão gravadas e a nota é a escolhida; verificado por teste de integração.
- [ ] **AC-2** — Dado AC-1, quando essa conta reabre o app sem rede, então vê a mesma nota e abre a mesma mídia; verificado por teste de integração.
- [ ] **AC-3** — Dado sem mídia ou sem nota, quando a pessoa tenta publicar sem rede, então nada é gravado; verificado por teste de widget.
- [ ] **AC-4** — Dado modo convidado e sem rede, quando tenta avaliar, então nada é gravado; verificado por teste de widget.
- [ ] **AC-5** — Dado AC-1 gravado só neste aparelho, quando outra conta abre o feed sem que exista sincronização, então essa avaliação não aparece para a outra conta; verificado por teste de integração com duas sessões locais.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Avaliação sem rede fica no aparelho de quem publicou. Não entra no feed das outras pessoas nesta fatia. | pedido de 2026-11-17 | AC-1, AC-2 e AC-5 |
| P-1 | premissa | A folha é a de `BUSINESS/12`, inclusive legenda opcional de até 500 caracteres e o botão desativado sem mídia ou nota. | produto | AC-3 |
| P-2 | premissa | Qualquer papel da viagem que já pode abrir Avaliar também pode gravar offline. O negócio não tira a avaliação do júnior. | produto | Não adicionar bloqueio de papel que `BUSINESS/12` não tem |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Avaliação local no SQLite. O app não chama OpenAI, Google nem a API nesta publicação. |
| Dados                  | Nota, legenda, etiquetas e caminho da mídia no banco local. O arquivo fica na área do app. |
| UI/UX e acessibilidade | Reusa a folha de avaliar. Não promete que a publicação já está no feed. |
| Segurança              | Convidado não grava. Log sem a mídia e sem a legenda. |
| Observabilidade        | Falha ao copiar a mídia entra no log sem o arquivo. |

## 10. Plano de testes

- Widget/unitário: AC-3 e AC-4.
- Integração: AC-1, AC-2 e AC-5, com foto temporária e SQLite de teste.
- Manual no frame 390×844: em modo avião, avaliar uma parada com uma foto e reabrir o app.
- Casos de borda: cancelar a escolha da mídia deixa o botão desativado.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| A pessoa acha que a avaliação já está pública | alta | médio | AC-5 e o texto desta spec: outras contas não veem até existir sincronização |

- Rollback: avaliar volta a exigir rede. Avaliações já gravadas no aparelho não são apagadas por esse rollback.
- Critério para abortar: se `BUSINESS/12` deixar de exigir mídia ou nota, pare e não mantenha a regra velha.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando a avaliação offline sobe para a API e passa a aparecer no feed | não | produto | não bloqueia a cópia local |
| A mesma pessoa avaliar o mesmo lugar mais de uma vez | não | produto | continua em aberto em `TECH/TECH.md` §10 |
| Limite de quantidade, tamanho e duração da mídia | não | produto | continua `A DEFINIR` em `BUSINESS.md` §10 |

## 13. Resultado

Pronto quando uma avaliação com mídia e nota, feita sem rede, continua visível para quem publicou depois de reabrir o app, e não aparece para outra conta.

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
