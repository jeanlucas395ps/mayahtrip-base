# ReadMe da API

- Slug: `readme-api`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/ARCHITECTURE.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`, `.docs/RULES.md`
- Specs relacionadas: `swagger-api`, `sign-up-api`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o pedido pede o ReadMe (https://readme.com/) na API Node, junto com o Swagger, cobrindo as features já implementadas. A visualização pública fica só em ambiente local e de teste.

Fato: `swagger-api` é a outra fatia e não é esta. Nesta data a API registra `POST /v1/auth/sign-up` e `GET /metrics`.

Quem sente: quem lê o contrato no ReadMe a partir do local ou do teste, e quem opera um ambiente que não é esses dois, onde essa visualização não pode estar pública.

Premissa, não fato: o endereço público do projeto no ReadMe e a forma de publicação não estão em nenhum doc. Esta spec não inventa projeto, chave nem comando.

## 2. Necessidade de negócio

O Swagger sozinho não cumpre o pedido. O ReadMe precisa mostrar as mesmas rotas já implementadas, e a URL dessa visualização só pode ser pública em local e em teste.

## 3. Objetivo e resultado observável

Em local e em teste, uma URL pública do ReadMe mostra todas as rotas HTTP implementadas na API. Em qualquer outro ambiente, essa visualização não é pública.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Quem testa no local ou no ambiente de teste | Abrir a URL pública do ReadMe e ler as rotas implementadas | Não precisa de conta MayahTrip |
| Qualquer um fora de local e de teste | Nada nesta fatia | A visualização pública não está disponível |

## 5. Escopo

### 5.1 Dentro do escopo

- ReadMe (https://readme.com/) da API Node com as rotas HTTP já implementadas.
- A lista publicada é a lista registrada na API. Hoje: `POST /v1/auth/sign-up` e `GET /metrics`. Rota nova só entra quando estiver implementada.
- Uma URL pública de visualização, sem conta MayahTrip, somente em local e em teste.
- Fora desses dois ambientes, essa visualização não é pública.

### 5.2 Fora de escopo

- `swagger-api`. A página Swagger não é o ReadMe.
- Implementar rotas que ainda não existem, nem documentá-las como se existissem.
- Redefinir `sign-up-api`. O ReadMe descreve a rota pronta; não muda a regra.
- Endereço do projeto, chave, comando de publicação e se o ReadMe lê o documento do Swagger. Nenhum doc fecha isso.
- App, site e painel.

## 6. Comportamento esperado

Em local, abrir a URL pública mostra no ReadMe cada rota registrada na API, com método e caminho. Em teste, o mesmo. `POST /v1/auth/sign-up` e `GET /metrics` aparecem enquanto estiverem registradas. Rota não registrada não aparece.

"Feature implementada" é a mesma decisão de `swagger-api` (D-2 daquela spec): rota HTTP registrada, inclusive `GET /metrics`.

Em ambiente que não é local nem teste, a visualização pública do ReadMe não fica disponível. Pedir essa URL não entrega o contrato.

Vazio: sem rotas registradas, o ReadMe abre com a lista vazia. Hoje a API não está nesse estado.

Erro: ambiente fora de local e teste não mostra o contrato numa página de erro.

Permissão: em local e teste a leitura não pede sessão MayahTrip.

Limite: não se aplica a esta página.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado a API com `NODE_ENV=development`, quando alguém abre `GET /readme` sem conta MayahTrip, então a página mostra `POST /v1/auth/sign-up` e `GET /metrics`; verificado por teste de integração.
- [ ] **AC-2** — Dado a API com `NODE_ENV=test`, quando alguém abre `GET /readme` sem conta MayahTrip, então a página mostra as mesmas rotas do AC-1; verificado por teste de integração.
- [ ] **AC-3** — Dado a API com `NODE_ENV=production`, quando alguém pede `GET /readme`, então o contrato não é servido; verificado por teste de integração.
- [ ] **AC-4** — Dado a API em local, quando o ReadMe é publicado, então toda rota registrada aparece e nenhuma rota ausente do registro aparece; verificado por teste de integração que compara a página com as rotas registradas.
- [ ] **AC-5** — Dado uma rota HTTP acrescentada só no teste e registrada na API, quando o ReadMe é publicado em local, então essa rota também aparece; verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O ReadMe é superfície própria, separada do Swagger. A URL pública desta fatia só existe em local e em teste. | produto | AC-1 e AC-3 |
| P-1 | premissa | "Feature implementada" segue `swagger-api` D-2: rota HTTP registrada, inclusive `GET /metrics`. | produto | AC-4 |
| D-2 | decisão | `GET /readme` mostra o mesmo OpenAPI do Swagger. A publicação é `POST https://api.readme.com/v2/branches/stable/apis` com `README_API_KEY`, só em `development` e `test`. Sem chave, a página continua e nada é enviado. ADR `mayahtrip-backend/adrs/0002-documentacao-publica.md`. | produto | AC-1 e AC-3 |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | A API Node passa a ter o contrato implementado também no ReadMe. Nenhum cliente novo é obrigatório. |
| Dados | Nenhum schema. |
| UI/UX e acessibilidade | Não se aplica. Não é tela do produto. |
| Segurança | Visualização pública só em local e teste. A página não mostra senha, token nem segredo. |
| Observabilidade | `GET /metrics` entra porque a rota existe. Nenhuma métrica nova nesta fatia. |

## 10. Plano de testes

- Widget/unitário: não se aplica.
- Integração: AC-1 a AC-5, em local, em teste e em um terceiro ambiente.
- Manual no frame 390×844: não se aplica.
- Casos de borda: lista vazia se não houver rota; rota nova de teste aparece (AC-5); fora de local e teste o contrato não é público (AC-3).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| O ReadMe público continua no ar fora de local e teste | média | alto | AC-3 |
| A página diverge das rotas registradas | média | médio | AC-4 |

- Rollback: tirar a visualização pública. As rotas da API continuam iguais.
- Critério para abortar: servir `GET /readme` fora de `development` e `test`, ou publicar em produção.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| O projeto no ReadMe usa outro branch que não `stable`? O upload está fixo em `stable`. | não | produto | antes de publicar num projeto real |

A visualização em `GET /readme` não depende dessa resposta. Sem `README_API_KEY`, nada é enviado.

## 13. Resultado

Pronto quando, em local e em teste, a URL pública do ReadMe mostrar todas as rotas HTTP registradas, e fora desses ambientes essa visualização não for pública, com AC-1 a AC-5 verdes.

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
