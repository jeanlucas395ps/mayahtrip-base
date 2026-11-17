# Versão da API

- Slug: `versao-da-api`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/ARCHITECTURE.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`
- Specs relacionadas: `sign-up-api`, `confirm-account-api`, `sign-in-api`, `web-session-handoff-api`, `swagger-api`, `readme-api`
- ADRs relacionados: `mayahtrip-backend/adrs/0003-versao-da-api.md`

## 1. Contexto

Fato: o pedido fecha que a API é versionada e que a versão atual é a v1. As rotas de produto já criadas e as que ainda vão ser criadas ficam nessa versão.

Fato: hoje a rota de produto registrada é `POST /v1/auth/sign-up`. `GET /metrics` é o scrape do Prometheus e não é rota de produto.

Quem sente: o app, o site e o painel, que precisam chamar um caminho estável, e quem for acrescentar uma rota nova.

## 2. Necessidade de negócio

Sem versão no caminho, a próxima mudança de contrato quebra quem já chama a rota. A v1 é o contrato atual. Uma rota nova nasce dentro dela.

## 3. Objetivo e resultado observável

Toda rota de produto responde em `/v1/...`. O mesmo caminho sem `/v1` não atende. Uma rota registrada sem versão própria também cai em `/v1`. `GET /metrics` continua em `/metrics`.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Cliente da API (app, site, painel, teste) | Chamar a rota de produto em `/v1` | O caminho sem versão não é a API de produto |
| Operação | Continuar o scrape em `GET /metrics` | Essa URL não ganha `/v1` |

## 5. Escopo

### 5.1 Dentro do escopo

- Versão no caminho. A versão atual é `v1`.
- `POST /v1/auth/sign-up` atende o cadastro. `POST /auth/sign-up` não atende.
- Rota de produto nova, mesmo sem declarar versão, entra em `/v1`.
- `GET /metrics` permanece sem versão.

### 5.2 Fora de escopo

- Criar uma v2 ou o conteúdo das rotas de `confirm-account-api`, `sign-in-api` e `web-session-handoff-api`. Quando existirem, o caminho delas também fica em `/v1`.
- `GET /docs` e `GET /readme`. São páginas de visualização, não a API de produto, e continuam sem versão.
- Header ou media type como forma de versão.

## 6. Comportamento esperado

O cliente chama `/v1/<rota>`. A rota executa como a spec dela descreve.

O mesmo caminho sem `/v1` não executa a rota de produto.

Uma rota acrescentada sem versão explícita aparece em `/v1`. Só sai da v1 quando a própria rota declarar outra versão. Isso não acontece nesta fatia.

`GET /metrics` responde em `/metrics`.

Vazio: não se aplica.

Erro: chamar a rota de produto sem `/v1` devolve não encontrado, sem executar o caso de uso.

Permissão: a versão não substitui o guard da rota.

Limite: o limite de taxa continua valendo na rota versionada.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado nome, e-mail, senha e termos válidos, quando `POST /v1/auth/sign-up` é chamado, então a conta pendente é criada como em `sign-up-api`; verificado por teste de integração.
- [ ] **AC-2** — Dado o mesmo corpo, quando `POST /auth/sign-up` é chamado, então a resposta é não encontrado e nenhuma conta é criada; verificado por teste de integração.
- [ ] **AC-3** — Dado uma rota HTTP registrada só no teste, sem versão própria, quando a API lista as rotas, então o caminho dela começa com `/v1`; verificado por teste de integração.
- [ ] **AC-4** — Dado o scrape, quando `GET /metrics` é chamado, então a rota responde sem `/v1` no caminho; verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | A versão vai no caminho. A atual é `v1`. Pedido de 2026-11-16. | produto | AC-1 e AC-2 |
| D-2 | decisão | Rota de produto sem versão explícita entra em `v1`. Uma versão nova só existe quando a rota declarar. | produto | AC-3 |
| D-3 | decisão | `GET /metrics` fica fora da versão. É o scrape descrito em `OBSERVABILITY.md`, não uma rota de produto. | produto | AC-4 |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | App, site e painel chamam `/v1`. O caminho sem versão deixa de ser a API de produto. |
| Dados | Nenhum schema. |
| UI/UX e acessibilidade | Não se aplica. |
| Segurança | O caso de uso não roda no caminho sem versão. |
| Observabilidade | `GET /metrics` permanece o endereço do scrape. |

## 10. Plano de testes

- Widget/unitário: não se aplica.
- Integração: AC-1 e AC-2 no teste de cadastro; AC-3 e AC-4 no teste que compara as rotas registradas com o contrato publicado.
- Manual no frame 390×844: não se aplica.
- Casos de borda: rota nova sem versão cai em `/v1` (AC-3). Métrica não cai (AC-4).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Cliente antigo chama `/auth/sign-up` | média | médio | AC-2. Não há cliente publicado nessa URL. |
| Uma rota nova nasce fora da v1 | média | alto | AC-3 e a versão padrão da aplicação |

- Rollback: desligar a versão no caminho. As rotas voltam à raiz.
- Critério para abortar: a implementação deixa rota de produto sem `/v1`, ou move `GET /metrics` para dentro da versão.

## 12. Perguntas em aberto

Nenhuma. A versão atual é a v1, no caminho.

## 13. Resultado

Pronto quando o cadastro só responde em `POST /v1/auth/sign-up`, uma rota nova sem versão própria também fica em `/v1`, e `GET /metrics` continua sem versão, com AC-1 a AC-4 verdes.

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
