# Adicionar link da viagem sem rede

- Slug: `link-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/25-documentos-e-links.md`
- Specs relacionadas: `viagem-sqlite`, `arquivo-offline`, `documentos-links`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: a aba Docs lista links importantes com título e domínio (`BUSINESS/25`). Adicionar, editar e remover links está `A DEFINIR` nesse arquivo.

O pedido de 2026-11-17 fecha só uma parte: acrescentar um link tem de funcionar sem rede, na viagem já salva. Editar e remover continuam em aberto.

Quem sente: dono ou supremo sem internet, com um endereço de reserva para guardar na viagem.

## 2. Necessidade de negócio

O link precisa entrar na viagem que já está no aparelho, sem esperar a rede. O sucesso é o link aparecer na lista depois de reabrir o app sem rede.

## 3. Objetivo e resultado observável

Sem rede, dono ou supremo informam um título e uma URL. O link fica no SQLite da viagem e a lista mostra título e domínio. Experiente e júnior não veem Docs.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono e viajante supremo | Adicionar o link offline | URL vazia ou sem esquema http ou https não grava |
| Viajante experiente e assistente júnior | Não veem a aba | Não gravam link |
| Convidado | Nada | Sem viagem |

## 5. Escopo

### 5.1 Dentro do escopo

- Sem rede, adicionar um link com título e URL à viagem que está no SQLite.
- A lista de links mostra título e domínio derivados da URL, no cartão já descrito em `BUSINESS/25`.
- Reabrir o app sem rede mantém o link.
- URL inválida não grava e mostra erro.

### 5.2 Fora de escopo

- Editar e remover link. Continuam `A DEFINIR` em `BUSINESS/25`.
- `arquivo-offline` (foto e PDF), `despesa-offline`, `mala-offline`, `review-offline`.
- Abrir a URL sem rede e esperar o site carregar.
- Enviar o link à API. Pergunta não bloqueante.

## 6. Comportamento esperado

1. Sem rede, dono ou supremo escolhem “Colar link” na aba Docs da viagem salva.
2. Informam título e URL. Confirmam.
3. O SQLite guarda os dois. A lista mostra o título e o domínio.
4. Reabrir sem rede ainda mostra o mesmo link.
5. Título vazio ou URL que não é http ou https não grava.
6. Experiente e júnior não acessam a ação.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado dono ou supremo, viagem no SQLite e sem rede, quando confirma título e uma URL http ou https, então o link está no SQLite e a lista mostra título e domínio; verificado por teste de integração.
- [ ] **AC-2** — Dado AC-1, quando o app reabre sem rede, então o mesmo link continua na lista; verificado por teste de integração.
- [ ] **AC-3** — Dado título vazio ou URL que não é http nem https, quando confirma, então nada é gravado e a pessoa vê erro; verificado por teste de widget.
- [ ] **AC-4** — Dado experiente ou júnior, quando abrem a viagem sem rede, então não há ação de adicionar link e nada é gravado; verificado por teste de widget.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | O pedido libera adicionar link sem rede, com título e URL. Editar e remover não foram decididos e ficam de fora. | pedido de 2026-11-17 | AC-1; `BUSINESS/25` segue `A DEFINIR` para editar e remover |
| P-1 | premissa | O domínio exibido é o host da URL, sem buscar a página. | produto | AC-1 não exige rede para preencher o domínio |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Link local no SQLite. Sem chamada à API nesta fatia. |
| Dados                  | Título e URL na viagem local. |
| UI/UX e acessibilidade | Entra pela opção “Colar link” já desenhada em `BUSINESS/25`. Os campos título e URL não estão desenhados; o teste procura os dois campos e o erro, não um pixel novo. |
| Segurança              | Só dono e supremo gravam. Log sem a URL. |
| Observabilidade        | Falha de gravação no log sem a URL. |

## 10. Plano de testes

- Widget/unitário: AC-3 e AC-4.
- Integração: AC-1 e AC-2.
- Manual no frame 390×844: em modo avião, colar um link https e reabrir o app.
- Casos de borda: URL com espaço nas pontas é recusada ou gravada sem o espaço; o teste aceita os dois desde que não grave URL inválida. Não inventar regra extra além de http e https.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| A tela de colar link ainda não tem layout fechado em `BUSINESS/25` | alta | médio | P-1 e o critério olham título, URL e domínio, não um visual novo |

- Rollback: colar link volta a não existir, como o `A DEFINIR` atual.
- Critério para abortar: se o produto retirar a opção “Colar link” de `BUSINESS/25`, pare.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Editar e remover link | não | produto | continua `A DEFINIR` em `BUSINESS/25` |
| Quando o link local sobe para a API | não | produto | não bloqueia a lista local |
| Layout final dos campos título e URL | não | produto | não bloqueia os critérios desta fatia |

## 13. Resultado

Pronto quando um link http ou https acrescentado sem rede continua na lista depois de reabrir o app, e URL inválida não grava.

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
