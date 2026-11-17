# Swagger da API

- Slug: `swagger-api`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/ARCHITECTURE.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`, `.docs/RULES.md`
- Specs relacionadas: `sign-up-api`, `readme-api`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o pedido pede Swagger na API Node, cobrindo as features já implementadas, com uma URL pública só em ambiente local e de teste.

Fato: nesta data a API registra duas rotas HTTP: `POST /v1/auth/sign-up` (`sign-up-api`) e `GET /metrics` (scrape descrito em `OBSERVABILITY.md`). Nenhuma outra rota está registrada.

Quem sente: quem implementa ou testa a API e precisa ver o contrato sem ler o código, e quem opera produção, que não deve ter essa URL pública.

Premissa, não fato: o caminho da URL não está em nenhum doc. Esta spec não escolhe `/docs`, `/swagger` nem outro path.

## 2. Necessidade de negócio

Sem Swagger, cada rota implementada fica só no código. O sucesso é abrir uma URL, sem conta, no local e no teste, e ver exatamente as rotas que a API registra naquele momento. Fora desses ambientes, essa URL não serve o documento.

## 3. Objetivo e resultado observável

Em local e em teste, uma URL pública mostra o Swagger de todas as rotas HTTP implementadas. Em qualquer outro ambiente, essa URL não devolve o documento.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Quem testa no local ou no ambiente de teste | Abrir a URL pública e ler o contrato das rotas implementadas | Não precisa de conta nem de token |
| Qualquer um fora de local e de teste | Nada nesta fatia | A URL não serve o Swagger |

## 5. Escopo

### 5.1 Dentro do escopo

- Swagger da API Node com as rotas HTTP já implementadas.
- A lista documentada é a lista registrada na API em execução. Hoje isso é `POST /v1/auth/sign-up` e `GET /metrics`. Uma rota nova só entra aqui quando estiver implementada.
- Uma URL pública de visualização, sem autenticação, somente em local e em teste.
- Fora desses dois ambientes, a mesma URL não serve o documento.

### 5.2 Fora de escopo

- `readme-api`. ReadMe é a outra fatia. Não entra nesta página.
- Implementar `sign-in-api`, `confirm-account-api`, `rate-limit-api` ou qualquer spec ainda sem rota. Documentar o que não está implementado também fica de fora.
- Redefinir o comportamento de `sign-up-api`. O Swagger mostra a rota que já existe; não muda a regra.
- Caminho da URL, nome da variável de ambiente e ferramenta de geração. Nenhum doc fecha isso.
- App, site e painel. Não há tela de produto.

## 6. Comportamento esperado

Em local, abrir a URL sem token mostra o Swagger. Em teste, o mesmo. A página lista cada rota registrada, com o método e o caminho. Não lista rota que a API não registra.

`POST /v1/auth/sign-up` aparece enquanto essa rota existir. `GET /metrics` aparece enquanto essa rota existir. As duas entram porque "feature implementada" nesta fatia significa rota HTTP registrada, não só fluxo de produto. `GET /metrics` é operacional e está no ar.

Em ambiente que não é local nem teste, pedir essa URL não devolve o Swagger. Não há página pública alternativa nesta fatia.

Vazio: se a API não tiver rota nenhuma, a página abre e a lista vem vazia. Hoje esse caso não é o estado real.

Erro: a URL fora de local e teste não é uma página de erro com o contrato vazado. O documento não aparece.

Permissão: a visualização em local e teste não pede sessão. O guard de autorização das rotas de negócio não se aplica a esta página.

Limite: não se aplica à página. O limite das rotas documentadas continua na spec de cada rota.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado a API com `NODE_ENV=development`, quando alguém abre `GET /docs` sem token, então a página e o contrato em `GET /docs-json` mostram `POST /v1/auth/sign-up` e `GET /metrics`; verificado por teste de integração.
- [ ] **AC-2** — Dado a API com `NODE_ENV=test`, quando alguém abre `GET /docs` sem token, então a página mostra as mesmas rotas do AC-1; verificado por teste de integração.
- [ ] **AC-3** — Dado a API com `NODE_ENV=production`, quando alguém pede `GET /docs` e `GET /docs-json` sem token, então a resposta não contém o documento Swagger; verificado por teste de integração.
- [ ] **AC-4** — Dado a API em local com o conjunto atual de rotas, quando a página é gerada, então toda rota registrada aparece e nenhuma rota ausente do registro aparece; verificado por teste de integração que compara a página com as rotas registradas.
- [ ] **AC-5** — Dado uma rota HTTP acrescentada só no teste e registrada na API, quando a página é gerada em local, então essa rota também aparece; verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | Swagger e ReadMe são duas specs. A frase "uma URL pública" não junta os dois na mesma página. Cada um tem a própria URL, pública só em local e teste. Pedido de 2026-11-16. | produto | AC-1 e a spec `readme-api` |
| D-2 | decisão | "Features implementadas" aqui é o conjunto de rotas HTTP registradas na API. Inclui `GET /metrics`. Não inclui spec sem rota. | produto | AC-4 |
| D-3 | decisão | Visualização em `GET /docs` (JSON em `GET /docs-json`). Local é `NODE_ENV=development`. Teste é `NODE_ENV=test`. Os outros valores não montam a URL. Fechado na implementação, ADR `mayahtrip-backend/adrs/0002-documentacao-publica.md`. | produto | AC-1 a AC-3 |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | A API passa a publicar o contrato das rotas já implementadas. App, site e painel não ganham chamada nova. |
| Dados | Nenhum schema. |
| UI/UX e acessibilidade | Não se aplica. A página é a de visualização do contrato, não uma tela do produto. |
| Segurança | A URL é pública só em local e teste. Fora disso o documento não é servido. A página não mostra senha, token nem segredo de ambiente. |
| Observabilidade | `GET /metrics` entra no documento porque a rota existe. Esta fatia não cria métrica nova. |

## 10. Plano de testes

- Widget/unitário: não se aplica. Não há tela de produto.
- Integração: AC-1 a AC-5, subindo a API em local, em teste e em um terceiro ambiente.
- Manual no frame 390×844: não se aplica.
- Casos de borda: API sem rotas mostra lista vazia; rota registrada no teste aparece sem página própria (AC-5); ambiente que não é local nem teste não devolve o documento (AC-3).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| A URL pública fica no ar fora de local e teste | baixa | alto | AC-3 |
| Uma rota implementada fica de fora da página | média | médio | AC-4 e AC-5 |

- Rollback: deixar de servir a URL. As rotas de negócio continuam iguais.
- Critério para abortar: montar `GET /docs` fora de `development` e `test`, ou documentar rota que a API não registra.

## 12. Perguntas em aberto

Nenhuma. Caminho e ambiente foram fechados na ADR `mayahtrip-backend/adrs/0002-documentacao-publica.md`.

## 13. Resultado

Pronto quando, em local e em teste, a URL pública mostrar todas as rotas HTTP registradas, e fora desses ambientes essa URL não servir o Swagger, com AC-1 a AC-5 verdes.

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
