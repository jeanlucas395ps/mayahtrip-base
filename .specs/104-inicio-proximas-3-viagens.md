# Início: até 3 próximas viagens

- Slug: `inicio-proximas-3-viagens`
- Status: `rascunho`
- Data: 2026-11-21
- Última atualização: 2026-11-21
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/05-inicio.md`, `.docs/BUSINESS/15-carteira-de-viagens.md`, `.docs/DESIGN.md`, `.specs/007-inicio.md`, `.specs/017-carteira.md`
- Specs relacionadas: `inicio`, `carteira`, `refresh-token-retry-401`, `convite-viagem-notificacoes-kafka`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: `05-inicio.md` e a spec `inicio` dizem que o bloco “Sua viagem agora / Sua próxima viagem” mostra **uma** viagem. O app hoje segue isso (`viagemDestaque`).

Fato (pedido 2026-11-21): o bloco deve mostrar as **próximas 3** viagens que ainda vão acontecer (ou estão acontecendo). A 4ª em diante só aparece na tela de viagens (Carteira).

Quem sente: quem tem várias viagens futuras e abre o Início esperando um resumo curto, sem a lista completa.

## 2. Necessidade de negócio

A home precisa ser um atalho, não a carteira. Limitar a 3 cartões evita poluir o Início quando a pessoa tem muitas viagens futuras; o restante continua em “Todas” / Carteira.

## 3. Objetivo e resultado observável

No Início, o bloco de próximas viagens lista no máximo **3** viagens futuras/em curso, ordenadas pela data de início (mais próxima primeiro). Com 4 ou mais elegíveis, só as 3 primeiras aparecem; as demais só na Carteira. Sem elegíveis, o bloco some (como hoje).

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Titular logado | Ver até 3 cartões de viagem no Início | Só viagens em que participa |
| Convidado | Não vê o bloco (regra atual do Início) | Sem alteração nesta fatia |

## 5. Escopo

### 5.1 Dentro do escopo

- Alterar a regra do bloco “Sua viagem agora / Sua próxima viagem” no Início: de 1 cartão para até **3**.
- Critério de elegibilidade: viagens com status *acontecendo agora* ou *próxima* (ainda vão acontecer). Rascunhos e passadas **não** entram neste bloco.
- Ordenação: data de início ascendente; empate estável por id.
- Título do bloco: “Sua viagem agora” se **alguma** das exibidas estiver acontecendo; senão “Sua próxima viagem” (ou plural se o produto já tiver copy — ver P-1).
- Link “Todas” continua indo à Carteira; Carteira lista o conjunto completo.
- Atualizar testes do Início que assumem um único cartão.

### 5.2 Fora de escopo

- `refresh-token-retry-401` — renovação de sessão.
- `convite-viagem-notificacoes-kafka` — convite por e-mail/push.
- Redesign do cartão (continua o mesmo da Carteira).
- Filtros extras na Carteira.
- Alterar a API `/v1/trips` (o limite de 3 é regra de apresentação do Início; a API pode devolver a lista completa ou a carteira filtrada — o app corta em 3).

## 6. Comportamento esperado

1. Início carrega as viagens do usuário (repo/API já usados).
2. Filtra elegíveis: em curso ou futuras (não rascunho, não passada).
3. Ordena por início; pega `take(3)`.
4. Se a lista filtrada estiver vazia → bloco oculto.
5. Se 1–3 → mostra todos os cartões, empilhados na mesma seção (mesmo estilo de cartão da Carteira).
6. Se ≥4 → mostra só 3; o restante só na Carteira via “Todas”.

Estados:

- Vazio: bloco ausente.
- Erro de carga: o mesmo tratamento atual do Início para falha de viagens (não inventar empty novo).
- Convidado: bloco continua ausente.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado 0 viagens elegíveis, quando o Início abre, então o bloco de próximas viagens não aparece; verificado por teste de view model / widget.
- [ ] **AC-2** — Dado 1, 2 ou 3 viagens elegíveis, quando o Início abre, então aparecem exatamente essas N, na ordem de início; verificado por teste com repositório mockado.
- [ ] **AC-3** — Dado 4 ou mais viagens elegíveis, quando o Início abre, então aparecem só as 3 de início mais próximo; a 4ª+ não está no Início e continua listável na Carteira; verificado por teste Início + Carteira (ou inspeção da lista completa no repo).
- [ ] **AC-4** — Dado ao menos uma viagem “acontecendo agora” entre as elegíveis, quando o Início abre, então o título do bloco é “Sua viagem agora”; caso contrário “Sua próxima viagem”; verificado por teste do view model.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Limite do Início = **3** cartões; altera a regra de “uma viagem” de `05-inicio.md` / `007-inicio`. | produto | pedido 2026-11-21 |
| D-2 | decisão  | Rascunhos e viagens passadas não entram no bloco do Início. | produto | alinhado a “ainda vão acontecer” |
| P-1 | premissa | Copy do título permanece singular (“Sua próxima viagem”) mesmo com 2–3 cartões, salvo o caso “agora”. | produto | confirmar no refine se quiser plural |
| P-2 | premissa | Fonte de dados é a mesma já usada pelo Início/Carteira; o corte é no app. | app | código atual |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | View model do Início passa a expor lista (até 3), não um único destaque |
| Dados                  | Nenhum schema novo |
| UI/UX e acessibilidade | Seção com 1–3 cartões empilhados; espaçamento igual ao padrão do Início |
| Segurança              | nenhum |
| Observabilidade        | nenhum |

## 10. Plano de testes

- Widget/unitário: `inicio_view_model_test` / `inicio_view_test` com 0, 1, 3 e 4+ viagens elegíveis.
- Integração: não obrigatória se o repo for mockado.
- Manual no frame 390×844: criar/listar ≥4 próximas e conferir home vs carteira.
- Casos de borda: só rascunhos; só passadas; mistura agora + futuras.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Home alongar demais com 3 cartões grandes | média | médio | manter cartão da Carteira; validar no frame |
| Divergência com texto antigo de `05-inicio.md` | alta | baixo | atualizar BUSINESS na implementação / refine |

- Rollback: voltar a `take(1)` / `viagemDestaque`.
- Critério para abortar: layout ilegível no frame 390×844 com 3 cartões.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Título no plural (“Suas próximas viagens”) quando N>1? | não | produto | refine |
| Atualizar `05-inicio.md` e o protótipo HTML nesta mesma entrega? | não | produto | junto da implementação |

## 13. Resultado

O Início mostra no máximo as 3 próximas viagens elegíveis; o restante só na Carteira.

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
