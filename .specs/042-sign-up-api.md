# Criar conta (API)

- Slug: `sign-up-api`
- Status: `concluída` — implementada e testada em 2026-11-16 (`mayahtrip-backend`, módulo `identidade`); ver `plan/sign-up-api-plan.md` e `adrs/0001-identidade-tokens-persistencia.md` naquele repositório
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/BUSINESS/02-cadastro-e-verificacao.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`
- Specs relacionadas: `sign-up` (`.specs/003-sign-up.md`, mayahtrip-app), `confirm-account-api` (próxima da fila, mayahtrip-backend)
- ADRs relacionados: nenhum (ver P-2 — pode gerar um antes da implementação)

## 1. Contexto

Fato: `.docs/BUSINESS/02-cadastro-e-verificacao.md` especifica o Passo 1 (Dados) da criação de conta — nome, e-mail, senha, aceite de termos — e descreve que, ao enviar, o sistema dispara um código de verificação de 4 dígitos por e-mail. A spec `.specs/003-sign-up.md` já cobre a tela do app com dados mocados ("não há API nesta fila"). Esta spec é a contraparte real do lado do servidor: sem ela, a tela do app não tem com quem falar.

Quem sente: quem tentar criar conta de verdade no app ou no site (`mayahtrip-web`, ver spec irmã `sign-up-web`), e quem vier a confirmar essa conta (`confirm-account-api`, que depende desta).

Premissa, não fato: a infraestrutura (Postgres/Redis/Kafka, Compose) está sendo construída por outro agente em paralelo a esta spec — ver P-1.

## 2. Necessidade de negócio

Sem conta real persistida, nenhuma outra fatia de autenticação (confirmação, login, recuperação de senha, cadastro web) tem o que consumir. Esta é a fatia fundacional da fila de identidade.

## 3. Objetivo e resultado observável

Ao enviar nome, e-mail e senha válidos para o endpoint de cadastro, uma conta em estado pendente (não confirmada) passa a existir no sistema, a senha nunca é armazenada em texto puro, e um código de 4 dígitos é enviado para o e-mail informado, no idioma da interface ativo.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Visitante sem conta (app ou web) | Chamar o endpoint para criar uma conta nova | Não pode criar conta com e-mail já em uso por outra conta (confirmada ou pendente) |
| Convidado (`BUSINESS/04`) | Mesma ação que o visitante; o modo convidado em si não grava dado além do que esta spec cobre | Continua sem conta até concluir este fluxo |

## 5. Escopo

### 5.1 Dentro do escopo

- Endpoint HTTP de cadastro em `POST /v1/auth/sign-up`: recebe nome, e-mail, senha e aceite de termos. O caminho sem `/v1` não atende (`.specs/051-versao-da-api.md`).
- Validação de borda (nome, formato de e-mail, tamanho mínimo de senha, aceite de termos) com mensagens equivalentes às de `.docs/BUSINESS/02-cadastro-e-verificacao.md`.
- Hash da senha com Argon2id antes de persistir (ver D-1).
- Criação da conta em estado pendente (não confirmada).
- Geração do código de verificação de 4 dígitos, válido por 10 minutos, e envio por e-mail via SMTP Hostinger, no idioma da interface ativo (`pt-BR`, `pt-PT`, `en`, `es`).
- Tratamento de e-mail já existente sem abrir brecha de enumeração de contas (ver D-2).
- Limite de taxa por IP e por e-mail para a criação de conta (ver D-3).
- Correlation id, log estruturado sem PII e métricas de latência/erro deste endpoint, desde já (`DEVELOPMENT.md` §11).

### 5.2 Fora de escopo

- `confirm-account-api` — confirmar o código de 4 dígitos, reenviar código e ativar a conta. Spec seguinte na fila, depende desta.
- `sign-in-api` — login por e-mail/senha e por Google.
- `forgot-password-api` / `reset-password-api` — a API de recuperação de senha não foi pedida nesta rodada; só existe hoje a spec de UI mocada do app (`.specs/005`, `.specs/006`).
- `sign-up-web` — a tela de cadastro no site `mayahtrip-web` consumirá este mesmo endpoint; a tela em si é outra spec.
- Login com Google — fluxo totalmente diferente, tratado em `sign-in-api`.
- Qualquer tela de UI (app ou web).
- Envio de e-mail de boas-vindas — `.docs/BUSINESS/02-cadastro-e-verificacao.md` marca como `A DEFINIR`.
- Geração definitiva da regra de unicidade do `@usuário` — `A DEFINIR` no mesmo doc; esta spec só precisa gerar um valor inicial a partir do e-mail, sem fechar a regra de unicidade (ver Perguntas em aberto).

## 6. Comportamento esperado

Fluxo principal: cliente (app ou web) envia nome, e-mail, senha e aceite de termos → API valida cada campo na ordem de `.docs/BUSINESS/02-cadastro-e-verificacao.md` (nome, e-mail, senha, termos) → se tudo válido, cria conta pendente com senha em hash Argon2id → gera código de 4 dígitos, grava com validade de 10 minutos → envia e-mail com o código, no idioma da interface ativo → responde sucesso ao cliente, que segue para a etapa de confirmação (fora desta spec).

Erro de validação: primeira falha encontrada na ordem acima interrompe o processamento; nenhuma conta é criada; resposta de erro identifica o campo e usa mensagem equivalente à do doc de negócio.

E-mail já cadastrado (confirmado ou pendente): não cria segunda conta nem reenvia código para a conta existente de outra pessoa; resposta não deve permitir que quem chama o endpoint descubra, pela diferença de resposta, se aquele e-mail já tem conta (ver D-2).

Limite de taxa excedido: chamadas além do limite por IP ou e-mail (ver D-3) são rejeitadas antes de qualquer tentativa de criação ou envio de e-mail.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado nome, e-mail válido e não cadastrado, senha com 8+ caracteres e termos aceitos, quando `POST /v1/auth/sign-up` é chamado, então a conta é criada em estado pendente, a senha é armazenada com hash Argon2id (nunca texto puro) e um código de verificação de 4 dígitos é enviado por e-mail no idioma da interface ativo; verificado por teste de integração que inspeciona o registro criado e o disparo de e-mail (SMTP mockado).
- [ ] **AC-2** — Dado nome vazio, quando o endpoint é chamado, então a resposta é um erro de validação equivalente a "Digite seu nome." e nenhuma conta é criada; verificado por teste unitário do DTO.
- [ ] **AC-3** — Dado e-mail em formato inválido, quando o endpoint é chamado, então a resposta é um erro de validação equivalente a "Digite um e-mail válido." e nenhuma conta é criada; verificado por teste unitário do DTO.
- [ ] **AC-4** — Dado senha com menos de 8 caracteres, quando o endpoint é chamado, então a resposta é um erro de validação equivalente a "A senha precisa ter pelo menos 8 caracteres." e nenhuma conta é criada; verificado por teste unitário do DTO.
- [ ] **AC-5** — Dado aceite de termos ausente ou falso, quando o endpoint é chamado, então a resposta é um erro equivalente a "Aceite os termos para continuar." e nenhuma conta é criada; verificado por teste unitário do DTO.
- [ ] **AC-6** — Dado um e-mail que já existe (confirmado ou pendente), quando o endpoint é chamado, então a API não cria um segundo registro, não reenvia código para a conta de terceiro, e a resposta não distingue de forma observável esse caso de um erro de validação comum (ver D-2); verificado por teste de integração.
- [ ] **AC-7** — Dado o código gerado por esta chamada, quando mais de 10 minutos se passam, então esse código deixa de ser aceito por `confirm-account-api` (contrato consumido pela próxima spec); verificado por teste de integração com relógio controlado.
- [ ] **AC-8** — Dado qualquer chamada ao endpoint, quando a requisição é processada, então a API propaga ou gera um correlation id, expõe métrica de latência e taxa de erro para o Prometheus, e nenhum log contém a senha ou o código em texto puro; verificado por inspeção do log estruturado e do endpoint de métricas.
- [ ] **AC-9** — Dado volume de chamadas acima do limite de taxa (ver D-3) para o mesmo IP ou e-mail, quando o limite é excedido, então novas tentativas são rejeitadas antes de qualquer criação de conta ou envio de e-mail; verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | A infraestrutura (Docker/Postgres/Redis/Kafka) está sendo construída por outro agente em paralelo a esta spec | infra | Confirmar ambiente disponível antes de iniciar a implementação desta spec |
| D-1 | decisão | Hash de senha usa Argon2id (`ARCHITECTURE.md` §3), não bcrypt — `DEVELOPMENT.md` §3 menciona bcrypt de forma desatualizada; o documento específico de stack (`ARCHITECTURE.md`) prevalece e será corrigido no mesmo câmbio desta spec | autor da spec | Nenhuma — correção documental já aplicada; confirmado pelo responsável do produto em 2026-11-16 |
| D-2 | decisão proposta, não bloqueante | Resposta da API para e-mail já cadastrado não deve permitir enumeração de contas (mesmo formato/latência de resposta que outros erros) | produto/segurança | Confirmar com o time o texto exato de erro antes de liberar em produção |
| D-3 | decisão proposta, não bloqueante | Limite de taxa de criação de conta por IP e por e-mail — valor numérico não está em nenhum doc de negócio | produto/segurança | Confirmar o número exato (ex.: tentativas por janela de tempo) antes de implementar |
| D-4 | decisão | Usuário pendente e código de verificação são persistidos no **Postgres** (não Redis) — decisão do responsável do produto em 2026-11-16: mesmo um cadastro nunca confirmado tem valor como futuro lead, então o registro não deve expirar/desaparecer como em um cache. Resolve a antiga P-2 (`ARCHITECTURE.md` §6 ainda marca o tema geral como aberto, mas esta fatia específica está decidida) | produto | Nenhuma — decisão fechada; ORM/driver exato de acesso ao Postgres continua `A DEFINIR` |
| D-5 | decisão | A tabela de usuário (e qualquer outra criada por esta spec) é criada e versionada por migration, nunca por sincronização automática do ORM (`DEVELOPMENT.md` §3, atualizado nesta mesma rodada) | produto | Nenhuma — convenção de projeto já registrada em `DEVELOPMENT.md` |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Novo endpoint em `mayahtrip-backend`, módulo de domínio `identidade` (`DEVELOPMENT.md` §3); contrato consumido por `sign-up` (app, via API real) e `sign-up-web` |
| Dados | Novo registro de usuário pendente e de código de verificação, persistidos no Postgres (D-4), criados por migration (D-5) |
| UI/UX e acessibilidade | Nenhuma nesta spec — é só API |
| Segurança | Hash Argon2id, rate limiting, não vazar enumeração de e-mail, log sem PII/segredo, correlation id |
| Observabilidade | Métrica de latência e erro deste endpoint exposta ao Prometheus desde a primeira versão |

## 10. Plano de testes

- Widget/unitário: não se aplica (sem UI); unitário de domínio/DTO cobre AC-2 a AC-5.
- Integração: AC-1, AC-6, AC-7, AC-9 (repositório, envio de e-mail mockado, relógio controlado, limite de taxa).
- Manual no frame 390×844: não se aplica — spec sem tela.
- Casos de borda: e-mail já existente, termos não aceitos, limite de taxa excedido, código expirando no limite dos 10 minutos.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Enumeração de contas via diferença de resposta/latência | média | alto | D-2: resposta uniforme para e-mail já existente |
| Envio de e-mail falhar silenciosamente | média | alto | Métrica de erro por fornecedor externo (`OBSERVABILITY.md`) cobre isso; alerta fica fora desta spec |
| Schema criado fora de migration, divergindo entre ambientes | baixa | médio | D-5: migration obrigatória, nunca sincronização automática |

- Rollback: endpoint novo e isolado; reverter é remover a rota/módulo e a migration correspondente, sem efeito em outras fatias, já que `confirm-account-api` ainda não existe para depender dele.
- Critério para abortar: se P-1 (infra) não estiver disponível, não implementar.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Regra de unicidade do `@usuário` gerado a partir do e-mail (`A DEFINIR` em `BUSINESS/02`) | não | produto | — |
| O que fazer, do ponto de vista de produto, se o e-mail já tiver conta (`A DEFINIR` em `BUSINESS/02`) — esta spec cobre só o aspecto de segurança (D-2) | não | produto | — |
| Envio do e-mail de boas-vindas (`A DEFINIR` em `BUSINESS/02`) | não | produto | — |
| Valor exato do limite de taxa (D-3) | não | produto/segurança | antes de implementar |

## 13. Resultado

Pronto quando um cliente HTTP conseguir criar uma conta pendente com nome, e-mail e senha válidos, receber um código de 4 dígitos por e-mail, e todos os AC-1 a AC-9 passarem em teste automatizado.

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
