# Lançar despesa sem rede

- Slug: `despesa-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/21-gastos.md`, `BUSINESS/22-novo-gasto.md`, `BUSINESS/BUSINESS.md` §4.3 e §4.6
- Specs relacionadas: `viagem-sqlite`, `novo-gasto`, `gastos`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o gasto fica na moeda original e a tela converte para exibição (`BUSINESS.md` §4.2). Quem não é dono, supremo ou experiente não vê gastos.

Quem sente: o grupo já em viagem, sem rede, que precisa anotar uma despesa na hora.

Premissa: a despesa nova entra no SQLite da viagem já criada. Subir essa despesa para a API quando a rede voltar não faz parte desta fatia.

## 2. Necessidade de negócio

Sem lançar despesa offline, o SQLite não cobre o uso que a pessoa descreveu. O sucesso é a despesa existir no aparelho depois de lançada sem rede, e continuar lá ao reabrir.

## 3. Objetivo e resultado observável

Com a viagem no SQLite e sem rede, dono, supremo ou experiente lançam uma despesa. Ela aparece na lista de gastos e permanece depois de fechar o app. Júnior não vê e não lança.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono, viajante supremo, viajante experiente | Lançar e ver a despesa offline | Valor na moeda original, categorias fixas de `BUSINESS.md` §4.6 |
| Assistente júnior | Nada de gasto | Não vê gastos |
| Convidado | Nada | Sem viagem própria |

## 5. Escopo

### 5.1 Dentro do escopo

- Abrir o lançamento de gasto já especificado em `novo-gasto`, com a viagem vinda do SQLite.
- Gravar a despesa no SQLite sem rede.
- A lista de gastos dessa viagem mostra o lançamento ao reabrir, ainda sem rede.
- Divisão desigual continua fora, como `A DEFINIR` em `BUSINESS.md` §10. O lançamento offline não inventa essa regra.

### 5.2 Fora de escopo

- `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`, `ver-viagem-offline`.
- Criar a viagem sem rede.
- Converter pela rede no momento do lançamento. A moeda original fica gravada. A taxa, se não estiver no aparelho, não é inventada.
- Enviar a despesa à API. Pergunta não bloqueante.

## 6. Comportamento esperado

1. Sem rede, quem pode ver gastos abre o novo gasto da viagem salva.
2. Informa descrição, valor, moeda original e uma das dez categorias. Confirma.
3. O SQLite guarda esse lançamento ligado à viagem.
4. A lista mostra o item. Fechar e abrir sem rede ainda mostra o mesmo valor e a mesma moeda original.
5. Júnior não encontra a entrada de gastos.
6. Sem viagem no SQLite, não há onde lançar.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado dono, supremo ou experiente, viagem no SQLite e sem rede, quando confirma uma despesa com valor, moeda original e categoria, então essa despesa está no SQLite ligada à viagem; verificado por teste de integração.
- [ ] **AC-2** — Dado AC-1, quando o app reabre sem rede, então a lista de gastos mostra o mesmo valor e a mesma moeda original; verificado por teste de integração.
- [ ] **AC-3** — Dado assistente júnior nessa viagem e sem rede, quando ele percorre a viagem, então não vê nem grava gasto; verificado por teste de widget.
- [ ] **AC-4** — Dado sem viagem no SQLite, quando alguém tenta lançar gasto, então nada é inserido; verificado por teste de integração.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Despesa lançada sem rede persiste no SQLite da viagem. Não depende de chamada à API para aparecer na lista local. | pedido de 2026-11-17 | AC-1 e AC-2 |
| P-1 | premissa | O formulário é o de `novo-gasto`. Esta fatia não redesenha campos. | produto | Layout segue `BUSINESS/22` |
| P-2 | premissa | Se não houver taxa de câmbio já salva no aparelho, a lista mostra o valor na moeda original e não calcula conversão. | produto | Não bloqueia o lançamento |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Gasto local no SQLite. A API de gasto, quando existir, não é chamada nesta fatia. |
| Dados                  | Linha de despesa no banco local, com moeda original. `NUMERIC` no servidor não se aplica ao widget; o valor local não pode ser float solto na regra de negócio. |
| UI/UX e acessibilidade | Mesma folha de novo gasto. Sem rede, o lançamento não fica em espera invisível: a lista já mostra. |
| Segurança              | Júnior não lê o gasto local. Log sem valor se o log for de diagnóstico genérico; não gravar o valor em log. |
| Observabilidade        | Falha ao gravar o SQLite entra no log sem descrição nem valor. |

## 10. Plano de testes

- Widget/unitário: AC-3.
- Integração: AC-1, AC-2 e AC-4, com SQLite de teste e rede desligada.
- Manual no frame 390×844: lançar um gasto em modo avião e reabrir o app.
- Casos de borda: categoria fora das dez; valor vazio não grava.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Despesa só no aparelho e o grupo não vê | alta | médio | Sincronização ficou de fora de propósito; a lista local não promete que o outro aparelho já tem o gasto |

- Rollback: lançar gasto volta a exigir rede. O que já está no SQLite permanece até uma decisão de limpeza.
- Critério para abortar: se o papel de quem vê gasto mudar em `BUSINESS.md` §4.3, pare e não copie a matriz antiga.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando a despesa offline sobe para a API e como dois lançamentos iguais se resolvem | não | produto | não bloqueia o lançamento local |
| Divisão desigual | não | produto | continua `A DEFINIR` em `BUSINESS.md` §10 |

## 13. Resultado

Pronto quando uma despesa lançada sem rede continua na lista depois de reabrir o app, e o júnior não a vê.

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
