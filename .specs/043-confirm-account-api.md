# Confirmar conta (API)

- Slug: `confirm-account-api`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/BUSINESS/02-cadastro-e-verificacao.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`
- Specs relacionadas: `sign-up-api` (`.specs/042-sign-up-api.md`), `confirm-account` (`.specs/004-confirm-account.md`, mayahtrip-app), `sign-in-api` (próxima da fila)
- ADRs relacionados: nenhum

## 1. Contexto

Fato: `.docs/BUSINESS/02-cadastro-e-verificacao.md` especifica o Passo 2 (Verificação) — confirmar o código de 4 dígitos enviado no cadastro, com limite de 5 tentativas e reenvio liberado após 30 s. `sign-up-api` (`.specs/042-sign-up-api.md`) já cria a conta pendente e envia o primeiro código; falta a contraparte que confirma esse código e ativa a conta, e a que reenvia um novo código.

Quem sente: quem criou conta pela API real e precisa confirmá-la para que ela deixe de ser pendente; `sign-in-api` (próxima fatia) depende de existir uma conta confirmada para logar.

Premissa, não fato: infraestrutura sendo construída em paralelo por outro agente — mesma premissa de `sign-up-api` (P-1 daquela spec).

## 2. Necessidade de negócio

Sem confirmar a conta, ela fica pendente para sempre e ninguém consegue logar. Esta fatia fecha o ciclo de criação de conta começado por `sign-up-api`.

## 3. Objetivo e resultado observável

Ao enviar o código de 4 dígitos correto dentro de 10 minutos e de 5 tentativas, a conta pendente passa a confirmada/ativa. Ao pedir reenvio após 30 s da última geração, um novo código é enviado e as tentativas são zeradas.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Titular da conta pendente | Confirmar o código recebido no e-mail; pedir reenvio | Só para a própria conta pendente, identificada pelo fluxo de cadastro (não por sessão, pois a conta ainda não está ativa) |

## 5. Escopo

### 5.1 Dentro do escopo

- Endpoint de confirmação em `/v1`: recebe os 4 dígitos e confirma/ativa a conta se corretos e dentro da validade. A versão é a atual da API (`.specs/051-versao-da-api.md`).
- Endpoint de reenvio: gera novo código, zera tentativas, reinicia a janela de 30 s, envia por e-mail no idioma da interface ativo.
- Limite de 5 tentativas de confirmação, controlado no servidor (não só na UI).
- Limite de taxa de tentativas também por IP, além de por conta (ver D-1).
- Expiração do código em 10 minutos (gerado por `sign-up-api` ou pelo reenvio desta spec).
- Observabilidade: correlation id, log sem PII/segredo, métricas de latência e erro destes dois endpoints.

### 5.2 Fora de escopo

- `sign-up-api` — criação da conta pendente e primeiro código (já existe, `.specs/042-sign-up-api.md`).
- `sign-in-api` — login e a regra de a conta precisar estar confirmada para logar.
- `forgot-password-api` / `reset-password-api` — usam código parecido, mas é outro endpoint e outra regra de negócio (`BUSINESS/03`); não pedido nesta rodada.
- `sign-up-web` — vai consumir estes mesmos dois endpoints; a tela é outra spec.
- Qualquer tela de UI.
- Envio de e-mail de boas-vindas após confirmação — `A DEFINIR` em `BUSINESS/02`.

## 6. Comportamento esperado

Confirmação: cliente envia os 4 dígitos para a conta pendente → se código correto e dentro dos 10 minutos e das 5 tentativas → conta passa a confirmada/ativa, nome e @usuário já definidos por `sign-up-api` permanecem → resposta de sucesso. Se código incorreto → conta continua pendente, resposta informa quantas tentativas restam (de 5). Na 5ª falha, o servidor recusa qualquer tentativa adicional de confirmação até haver reenvio.

Reenvio: cliente pede novo código → se passaram 30 s ou mais desde a última geração → novo código de 4 dígitos é gerado, tentativas zeradas, nova janela de 10 minutos e novo cronômetro de 30 s começam, e-mail enviado. Se pedido antes dos 30 s → servidor rejeita o reenvio (o controle não é só do cliente).

Código expirado (mais de 10 minutos): qualquer tentativa de confirmação com esse código é tratada como incorreta, consumindo uma tentativa das 5.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado uma conta pendente com código válido, quando os 4 dígitos corretos são enviados ao endpoint de confirmação dentro de 10 minutos e antes da 5ª tentativa, então a conta passa a confirmada/ativa; verificado por teste de integração.
- [ ] **AC-2** — Dado uma conta pendente, quando um código incorreto é enviado, então a conta continua pendente e a resposta informa quantas tentativas restam; verificado por teste de integração.
- [ ] **AC-3** — Dado 5 tentativas incorretas consecutivas para a mesma conta, quando uma 6ª tentativa de confirmação é enviada sem reenvio prévio, então o servidor a recusa sem consultar o código; verificado por teste de integração.
- [ ] **AC-4** — Dado um código gerado há mais de 10 minutos, quando ele é enviado ao endpoint de confirmação, então é tratado como incorreto e consome uma tentativa das 5; verificado por teste de integração com relógio controlado.
- [ ] **AC-5** — Dado uma conta pendente cujo último código foi gerado há 30 s ou mais, quando o reenvio é chamado, então um novo código de 4 dígitos é gerado, as tentativas são zeradas, uma nova janela de 10 minutos começa e um e-mail é enviado no idioma da interface ativo; verificado por teste de integração.
- [ ] **AC-6** — Dado uma conta pendente cujo último código foi gerado há menos de 30 s, quando o reenvio é chamado, então o servidor rejeita o pedido; verificado por teste de integração com relógio controlado.
- [ ] **AC-7** — Dado volume de tentativas de confirmação acima do limite por IP (ver D-1), quando esse limite é excedido, então novas tentativas são rejeitadas independentemente da conta visada; verificado por teste de integração.
- [ ] **AC-8** — Dado qualquer chamada a estes dois endpoints, quando a requisição é processada, então a API propaga/gera correlation id, expõe métrica de latência e erro, e nenhum log contém o código em texto puro; verificado por inspeção do log estruturado e do endpoint de métricas.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | Infraestrutura sendo construída em paralelo por outro agente (mesma premissa de `sign-up-api`) | infra | Confirmar ambiente disponível antes de implementar |
| D-1 | decisão proposta, não bloqueante | Limite de tentativas de confirmação por IP, além do limite de 5 por conta já fechado no negócio — valor numérico não está em nenhum doc | produto/segurança | Confirmar número exato antes de implementar |
| D-2 | decisão | Código e contador de tentativas são persistidos no **Postgres**, na mesma tabela/linha de usuário pendente criada por `sign-up-api` (decisão D-4 daquela spec, confirmada pelo responsável do produto em 2026-11-16) — resolve a antiga P-2 | produto | Nenhuma — decisão fechada |
| D-3 | decisão | Qualquer coluna/tabela nova desta spec é criada por migration, nunca por sincronização automática do ORM (`DEVELOPMENT.md` §3, mesma convenção de `sign-up-api` D-5) | produto | Nenhuma |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Dois novos endpoints no módulo `identidade` (`mayahtrip-backend`); consomem o que `sign-up-api` criou |
| Dados | Atualiza o estado da conta pendente para confirmada (Postgres, D-2); atualiza/substitui o código e o contador de tentativas |
| UI/UX e acessibilidade | Nenhuma nesta spec — é só API |
| Segurança | Limite de tentativas aplicado no servidor (não só na UI), limite por IP, log sem o código em texto puro |
| Observabilidade | Métrica de latência e erro destes dois endpoints, desde a primeira versão |

## 10. Plano de testes

- Widget/unitário: não se aplica (sem UI); unitário de domínio cobre a regra de expiração e de contagem de tentativas isoladamente.
- Integração: AC-1 a AC-8 (repositório, e-mail mockado, relógio controlado, limite de taxa).
- Manual no frame 390×844: não se aplica — spec sem tela.
- Casos de borda: código certo na 5ª tentativa (deve confirmar, não bloquear antes da checagem), reenvio exatamente nos 30 s, código expirando exatamente nos 10 minutos.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Força bruta do código de 4 dígitos (10.000 combinações) sem limite no servidor | média | alto | AC-3 e D-1 — limite por conta e por IP aplicado no servidor |
| Reenvio usado para spam de e-mail à conta de outra pessoa | baixa | médio | AC-6 — janela mínima de 30 s aplicada no servidor, mesma conta pendente identificada pelo fluxo |

- Rollback: endpoints novos e isolados; reverter não afeta `sign-up-api`, que continua funcional sem eles (conta só fica pendente).
- Critério para abortar: se P-1 (infra) não estiver disponível, não implementar.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Envio de e-mail de boas-vindas após confirmação (`A DEFINIR` em `BUSINESS/02`) | não | produto | — |
| Valor exato do limite de tentativas por IP (D-1) | não | produto/segurança | antes de implementar |

## 13. Resultado

Pronto quando uma conta pendente conseguir ser confirmada com o código correto, recusada com o código errado respeitando o limite de 5 tentativas (servidor, não só UI), e reenviada respeitando a janela de 30 s — com AC-1 a AC-8 passando em teste automatizado.

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
