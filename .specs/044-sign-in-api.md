# Entrar (API)

- Slug: `sign-in-api`
- Status: `concluída` — e-mail/senha, Google, refresh com rotação e revogação da família testados em 2026-11-17 (`mayahtrip-backend`); duração do refresh continua a proposta do ADR 0001
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/BUSINESS/01-login.md`, `.docs/WEB/02-login.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`
- Specs relacionadas: `sign-in` (`.specs/002-sign-in.md`, mayahtrip-app), `sign-up-api` (`.specs/042-sign-up-api.md`), `confirm-account-api` (`.specs/043-confirm-account-api.md`), `sign-up-web` (`.specs/045-sign-up-web.md`, descartada), `biometric-sign-in` (`.specs/046-biometric-sign-in.md`, mayahtrip-app), `web-session-handoff-api` (`.specs/047-web-session-handoff-api.md`, mayahtrip-backend)
- ADRs relacionados: nenhum ainda — D-4/D-5/D-7 (JWT stateless + refresh em Postgres + revogação via Redis) são escolha de auth e de onde cada dado mora, que `ARCHITECTURE.md` marcava como aberta; devem virar ADR em `./adrs/` antes da implementação real (`RULES.md` §2)

## 1. Contexto

Fato: `.docs/BUSINESS/01-login.md` especifica uma única tela com dois métodos de entrada — Google e e-mail/senha — ambos resultando em sessão criada. `.specs/002-sign-in.md` já cobre essa tela no app com dados mocados. Esta spec é a contraparte real do servidor para os dois métodos.

Fato: `.docs/WEB/02-login.md` (mesma conta entre app e web) estabelece que "conta que só entrou com Google ainda não tem senha" — ou seja, o provedor Google pode ser a própria origem da conta, sem passar pelo fluxo de `sign-up-api`/`confirm-account-api`.

Quem sente: quem já tem conta confirmada (e-mail/senha) ou conta Google (nova ou existente) e precisa entrar para usar o app ou o site.

Premissa, não fato: infraestrutura sendo construída em paralelo por outro agente, mesma premissa das specs anteriores desta fila.

## 2. Necessidade de negócio

Sem login real, nenhuma conta criada por `sign-up-api`/`confirm-account-api` é utilizável, e o acesso por Google (único jeito hoje de entrar sem criar senha) não existe. Esta fatia fecha a ponta de entrada da identidade.

## 3. Objetivo e resultado observável

Ao enviar e-mail e senha de uma conta confirmada, ou um token Google válido (de conta nova ou existente), a API devolve um **access token** de curta duração e um **refresh token** de duração maior (ver D-4). Credenciais erradas, conta inexistente ou conta não confirmada não emitem nenhum token. Um refresh token válido permite obter um novo access token sem repetir e-mail/senha ou Google.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Titular de conta confirmada (e-mail/senha) | Entrar com e-mail e senha | Só se a conta estiver confirmada; `BUSINESS/01` não define ainda bloqueio por tentativas (ver D-3) |
| Titular de conta Google (nova ou existente) | Entrar com token Google | Conta é criada automaticamente no primeiro acesso, já confirmada, sem senha |
| Convidado | Não se aplica — convidado não tem conta e não chama este endpoint (`.specs/041-modo-convidado.md`) | Fora de escopo |

## 5. Escopo

### 5.1 Dentro do escopo

- Endpoint de login por e-mail/senha em `/v1`: valida credenciais contra conta confirmada, emite access token + refresh token. A versão é a atual da API (`.specs/051-versao-da-api.md`).
- Endpoint de login por Google: a API valida o token do provedor (`ARCHITECTURE.md` §3 — "a API valida o token", nunca o app); se a conta não existir, cria uma nova já confirmada e sem senha; se existir, autentica nela; emite access token + refresh token em ambos os casos.
- Endpoint de refresh: troca um refresh token válido e não usado por um novo access token (e, por rotação, um novo refresh token — ver D-4).
- Contrato de erro genérico para credenciais inválidas, sem expor se o e-mail existe ou não (ver D-1).
- Limite de taxa proposto por IP e por conta para o caminho e-mail/senha (ver D-3), mesmo padrão das specs anteriores.
- Observabilidade: correlation id, log sem senha/token, métricas de latência e erro para os três endpoints.
- Persistência do refresh token no Postgres, por sessão, para permitir rotação e revogação (ver D-5).
- Checagem de revogação imediata de access token no Redis (`jti` na lista de bloqueio), em todo endpoint autenticado — ver D-7.

### 5.2 Fora de escopo

- `sign-up-api`, `confirm-account-api` — já existem, cobrem a criação/confirmação da conta pelo caminho e-mail/senha.
- `forgot-password-api` / `reset-password-api` — não pedidos nesta rodada.
- `sign-up-web` (`.specs/045-sign-up-web.md`) — **descartada**: decisão revista nesta mesma conversa, o site mantém só login com conta já existente, conforme `WEB/02-login.md`.
- `sign-in-web` — login no site; não foi pedido como spec nesta rodada (o site reaproveita este mesmo endpoint quando a tela existir).
- `web-session-handoff-api` (`.specs/047-web-session-handoff-api.md`) — entrar direto no site a partir de uma sessão já ativa no app, sem repetir e-mail/senha; é outro contrato, que consome os tokens emitidos aqui mas não os expõe no request.
- `biometric-sign-in` (`.specs/046-biometric-sign-in.md`, mayahtrip-app) — desbloqueio por Face ID/digital usa o refresh token já emitido por este endpoint; não é um método de autenticação novo no servidor, é outra fatia porque tem comportamento e tela próprios.
- Login com Facebook ou Apple — `BUSINESS/01` diz que não existem hoje; Apple fica `A DEFINIR`.
- Endpoint de login para convidado — convidado não tem conta; não se cria endpoint para isso.
- Duração exata do refresh token quando "manter conectado" está desmarcado — valor proposto em D-5, não fechado no negócio (a duração do access token, 15 min, já está fechada em D-4).
- Revogação de refresh token por troca de senha ou "Sair em todos os lugares" — pertence a `reset-password-api`/`28-perfil`, não foi pedida nesta rodada; esta spec só garante que o token é revogável (D-5).
- Limite exato de tentativas e duração de bloqueio — `A DEFINIR` em `BUSINESS/01`; esta spec só propõe um valor não bloqueante (D-3).
- Qualquer tela de UI.

## 6. Comportamento esperado

Login e-mail/senha: cliente envia e-mail e senha → API busca conta por e-mail → se não existe, ou existe mas não está confirmada, ou a senha não confere → resposta de erro genérica (ver D-1), sem token nenhum → se confere e está confirmada → emite access token + refresh token e devolve ao cliente.

Login Google: cliente envia o token do Google → API valida o token junto ao provedor → busca conta vinculada a esse Google ID/e-mail → se não existe, cria uma nova conta já confirmada, sem senha, com nome e e-mail vindos do Google (mesma regra de @usuário de `sign-up-api`) → se existe, usa a conta encontrada → emite access token + refresh token e devolve ao cliente. Token Google inválido ou expirado → resposta de erro, sem token nenhum, sem criar conta.

Refresh: cliente envia um refresh token → API confirma que ele existe, não expirou e não foi usado/revogado (Postgres) → emite novo access token (JWT, 15 min, D-4) e um novo refresh token, e invalida o refresh token recebido (rotação, ver D-5) → devolve ambos. Refresh token inválido, expirado ou já usado → erro, nenhum token novo emitido; se o mesmo refresh token já consumido for reapresentado, é sinal de possível roubo de token e a sessão correspondente é revogada por completo (ver D-5).

"Manter conectado": quando o cliente indica essa preferência, o refresh token emitido tem validade mais longa (valor proposto em D-5); quando não indica, usa a validade padrão (também proposta em D-5, já que `BUSINESS/01` não fecha nenhum valor). A duração do access token em si (15 min) não muda com essa preferência — ela só afeta o refresh token.

Revogação imediata (fora do ciclo normal de expiração): quando é preciso invalidar um access token antes dos seus 15 minutos (ex.: reuso de refresh detectado no AC-11, ou ação manual de segurança), o `jti` desse token é colocado numa lista de bloqueio no Redis com TTL igual ao tempo restante até a expiração natural → qualquer chamada autenticada com esse access token passa a ser rejeitada enquanto o `jti` estiver na lista, mesmo que a assinatura e a expiração do JWT ainda sejam válidas (ver D-7). Fora desse caso, validar um access token é só checagem local de assinatura/expiração, sem consulta a Postgres nem Redis.

Uso offline do app (contexto, não comportamento novo desta API): o app pode continuar tratando o usuário como autenticado enquanto o access token armazenado localmente não expirar, mesmo sem rede — essa é uma leitura local do token, não uma chamada a este endpoint. Sem rede e com o access token expirado, o app não tem como chamar o endpoint de refresh; nesse caso ele simplesmente não libera a funcionalidade que dependia de um access token válido (ex.: qualquer tela que exige dado atualizado do servidor), igual a qualquer outra chamada de API sem rede — não se cria aqui nenhum fluxo de "login offline" (ver D-6).

## 7. Critérios de aceite

- [ ] **AC-1** — Dado e-mail e senha de uma conta confirmada e corretos, quando o endpoint de login e-mail/senha é chamado, então um access token e um refresh token são emitidos e devolvidos; verificado por teste de integração.
- [ ] **AC-2** — Dado e-mail de uma conta confirmada com senha incorreta, quando o endpoint é chamado, então nenhum token é emitido e a resposta é o erro genérico de D-1; verificado por teste de integração.
- [ ] **AC-3** — Dado um e-mail sem conta ou com conta ainda pendente (não confirmada), quando o endpoint de login e-mail/senha é chamado, então nenhum token é emitido e a resposta é indistinguível, de fora, do caso de senha incorreta (ver D-1); verificado por teste de integração.
- [ ] **AC-4** — Dado um token Google válido de uma conta que ainda não existe no sistema, quando o endpoint de login Google é chamado, então uma conta nova é criada já confirmada e sem senha, e um access token e um refresh token são devolvidos; verificado por teste de integração com provedor Google mockado.
- [ ] **AC-5** — Dado um token Google válido de uma conta já existente (criada via Google ou com e-mail já associado), quando o endpoint de login Google é chamado, então nenhuma conta duplicada é criada, a conta existente é usada e um access token e um refresh token são devolvidos; verificado por teste de integração.
- [ ] **AC-6** — Dado um token Google inválido ou expirado, quando o endpoint de login Google é chamado, então nenhum token é emitido, nenhuma conta é criada, e a resposta é um erro; verificado por teste de integração com provedor Google mockado.
- [ ] **AC-7** — Dado volume de chamadas de login e-mail/senha acima do limite de taxa proposto (D-3) para o mesmo IP ou conta, quando esse limite é excedido, então novas tentativas são rejeitadas antes de checar a senha; verificado por teste de integração.
- [ ] **AC-8** — Dado qualquer chamada a estes três endpoints, quando a requisição é processada, então a API propaga/gera correlation id, expõe métrica de latência e erro, e nenhum log contém senha, access token, refresh token ou token do Google em texto puro; verificado por inspeção do log estruturado e do endpoint de métricas.
- [ ] **AC-9** — Dado um refresh token válido, não expirado e não usado, quando o endpoint de refresh é chamado, então um novo access token e um novo refresh token são emitidos, e o refresh token recebido é invalidado (rotação); verificado por teste de integração.
- [ ] **AC-10** — Dado um refresh token expirado, inválido ou já revogado, quando o endpoint de refresh é chamado, então nenhum token novo é emitido e a resposta é um erro; verificado por teste de integração.
- [ ] **AC-11** — Dado um refresh token que já foi usado uma vez (consumido pela rotação do AC-9), quando ele é apresentado de novo ao endpoint de refresh, então nenhum token novo é emitido e a sessão associada a ele é marcada como revogada no Postgres (nenhum refresh futuro dessa cadeia volta a funcionar); verificado por teste de integração.
- [ ] **AC-12** — Dado um access token válido e ainda dentro dos 15 minutos de validade, cujo `jti` foi colocado na lista de revogação imediata do Redis (ex.: reuso de refresh detectado no AC-11, ou ação manual de segurança), quando esse access token é usado em qualquer endpoint autenticado, então a requisição é rejeitada mesmo antes da expiração natural do token; verificado por teste de integração com Redis mockado/real.
- [ ] **AC-13** — Dado um access token válido cujo `jti` NÃO está na lista de revogação do Redis, quando ele é usado em qualquer endpoint autenticado, então a requisição passa sem nenhuma consulta ao Postgres para validar a sessão (o JWT é autocontido; só o Redis é consultado, e só para a lista de revogação); verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | Infraestrutura sendo construída em paralelo por outro agente | infra | Confirmar ambiente disponível antes de implementar |
| D-1 | decisão | Resposta de erro para e-mail/senha incorreta e para conta inexistente/não confirmada é a mesma, de fora, para não permitir enumeração de contas nem descobrir se uma conta está pendente; mensagem final de UI (`A DEFINIR` em `BUSINESS/01`) é decisão de produto separada | autor da spec | Nenhuma — decisão de segurança já aplicável independente da mensagem final |
| D-2 | decisão | Login por Google cria conta automaticamente no primeiro acesso, já confirmada e sem senha, inferido de `WEB/02-login.md` ("conta que só entrou com Google ainda não tem senha") | autor da spec | Nenhuma — já decorre de doc de negócio existente |
| D-3 | decisão proposta, não bloqueante | Limite de taxa de tentativas de login por IP e por conta — valor numérico não está em nenhum doc; `BUSINESS/01` marca "limite de tentativas e bloqueio" como `A DEFINIR` | produto/segurança | Confirmar número exato antes de implementar |
| D-4 | decisão | Access token é **JWT assinado, stateless, duração fixa de 15 minutos** (confirmado pelo responsável do produto em 2026-11-16). Nenhuma consulta a banco é feita para validar um access token no caminho feliz — só a assinatura e a expiração são checadas. Resolve a antiga P-2 | produto | Nenhuma — decisão fechada |
| D-5 | decisão | Refresh token é **opaco, aleatório**, persistido **hashed no Postgres** (mesma decisão de banco de `sign-up-api` D-4/`confirm-account-api` D-2), uma linha por sessão, com rotação a cada uso (AC-9); tabela criada por migration (`DEVELOPMENT.md` §3). Duração do refresh (proposta: 30 dias com "manter conectado", 1 dia sem) continua não fechada — ver Perguntas em aberto | produto | Confirmar duração exata do refresh antes de produção |
| D-6 | decisão | Este endpoint não cria um "login offline": a tolerância a uso sem rede vem de o app guardar localmente um access token ainda válido, não de uma chamada a este contrato. Funcionalidade que exige um access token válido e a rede estiver fora, e o token tiver expirado, simplesmente fica indisponível — igual a qualquer chamada de API sem rede, não é um caso novo desta spec | autor da spec | Nenhuma — já decorre do comportamento padrão de um token com expiração |
| D-7 | decisão | **Redis é usado só para revogação imediata de access token**: uma lista de `jti` revogados, com TTL igual ao tempo restante até a expiração natural do token (no máximo 15 min, D-4). Todo endpoint autenticado consulta essa lista antes de aceitar o access token; fora desse caso, nenhuma chamada autenticada consulta Redis nem Postgres para o access token em si (decisão confirmada pelo responsável do produto em 2026-11-16) | produto | ADR necessário antes de implementar — `RULES.md` §2 exige ADR para "definir o que vai para... Redis" |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Três endpoints no módulo `identidade` (login e-mail/senha, login Google, refresh); depende de `confirm-account-api` para o caminho e-mail/senha; cria conta por conta própria no caminho Google; todo endpoint autenticado desta e de outras specs passa a checar a lista de revogação no Redis (D-7) |
| Dados | Nova linha de refresh token por login no Postgres (D-5); lista de `jti` revogados no Redis, só em caso de revogação imediata (D-7, TTL curto, não é cache de uso geral); possível novo registro de conta no caminho Google |
| UI/UX e acessibilidade | Nenhuma nesta spec — é só API |
| Segurança | Resposta uniforme contra enumeração (D-1), validação de token Google no servidor, rate limiting proposto (D-3), JWT stateless de 15 min (D-4), refresh com rotação em Postgres (D-5), revogação imediata via Redis (D-7), log sem credencial nem token |
| Observabilidade | Métrica de latência e erro dos três endpoints, desde a primeira versão; métrica de quantos acessos são rejeitados pela lista de revogação (D-7) ajuda a saber se o mecanismo está sendo usado |

## 10. Plano de testes

- Widget/unitário: não se aplica (sem UI); unitário de domínio cobre a regra de criação lazy de conta Google e a rotação de refresh token isoladamente.
- Integração: AC-1 a AC-13 (repositório Postgres, Redis para revogação, provedor Google mockado, limite de taxa, relógio controlado para expiração de token).
- Manual no frame 390×844: não se aplica — spec sem tela.
- Casos de borda: conta pendente tentando logar por e-mail/senha (deve falhar como AC-3), conta criada por Google tentando logar depois por e-mail/senha sem ter senha definida (fora de escopo desta spec — fica para quando a conta usar "Esqueci a senha" para criar uma, conforme `WEB/02`; registrar como nota, não como AC aqui), reuso de refresh token já rotacionado (AC-11), access token revogado exatamente no limite da própria expiração natural (AC-12).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Força bruta de senha sem limite de tentativas no servidor | média | alto | AC-7 e D-3 |
| Enumeração de contas via diferença de resposta entre "senha errada" e "conta não existe/pendente" | média | alto | AC-3 e D-1 |
| Criação duplicada de conta ao logar por Google mais de uma vez | baixa | médio | AC-5 |
| Refresh token roubado sendo reusado sem o dono notar | média | alto | AC-11 — reuso de token já rotacionado revoga a sessão inteira |
| Access token comprometido continuar válido até os 15 min naturais, sem mecanismo de parar antes | baixa (com D-7) | alto (sem D-7) | D-7/AC-12 — lista de revogação imediata no Redis cobre exatamente esse caso |
| Redis indisponível no momento da checagem de revogação | baixa | alto | Fora do escopo desta spec decidir o comportamento de falha (falhar aberto vs fechado); registrar como pergunta não bloqueante |

- Rollback: endpoints novos e isolados; reverter não afeta `sign-up-api`/`confirm-account-api`, que continuam funcionais sem este endpoint (conta fica confirmada mas sem forma de logar).
- Critério para abortar: se P-1 (infra) não estiver disponível, não implementar.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Valor exato de duração do refresh token, com e sem "manter conectado" (D-5 propõe 30 dias / 1 dia; o access token já está fechado em 15 min, D-4) | não | produto/segurança | antes de implementar |
| Limite de tentativas e bloqueio temporário por senha errada (`A DEFINIR` em `BUSINESS/01`) — D-3 propõe um valor | não | produto/segurança | antes de implementar |
| Mensagem final de erro de login exibida na UI (`A DEFINIR` em `BUSINESS/01`) | não | produto | — |
| Apple como provedor de login (`A DEFINIR` em `BUSINESS/01`) | não | produto | — |
| Comportamento quando o Redis da lista de revogação (D-7) está indisponível: falhar aberto (aceita o token, risco de não revogar a tempo) ou falhar fechado (rejeita tudo, risco de indisponibilidade geral)? | não | produto/segurança | antes de implementar |

## 13. Resultado

Pronto quando um cliente HTTP conseguir logar com e-mail/senha de conta confirmada, logar com token Google (criando conta na primeira vez), trocar um refresh token válido por um novo par de tokens, ter um access token revogado antes da hora via Redis, e todos os caminhos recusarem corretamente credenciais/tokens inválidos — com AC-1 a AC-13 passando em teste automatizado.

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
