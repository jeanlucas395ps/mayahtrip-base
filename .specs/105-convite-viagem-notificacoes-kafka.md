# Convite de viagem: e-mail e notificações via Kafka

- Slug: `convite-viagem-notificacoes-kafka`
- Status: `rascunho`
- Data: 2026-11-21
- Última atualização: 2026-11-21
- Responsável: produto
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/BUSINESS/26-compartilhar-viagem-e-papeis.md`, `.docs/BUSINESS/06-notificacoes.md`, `.docs/TECH/TECH.md` (§5.2 Notificação, outbox/Kafka), `.docs/ARCHITECTURE.md`
- Specs relacionadas: `nova-viagem`, `compartilhar-viagem`, `notificacoes`, `refresh-token-retry-401`, `inicio-proximas-3-viagens`
- ADRs relacionados: nenhum ainda — tópico/contrato Kafka de notificação ainda `A DEFINIR` em TECH §10; esta fatia fecha o mínimo para convite

## 1. Contexto

Fato: ao criar viagem com `invites` (ou convidar depois), o backend já grava o convite e envia e-mail de forma **síncrona** (`ViagemUseCase.enviar` → SMTP). Não publica outbox/Kafka e não cria notificação in-app/push para quem já tem conta.

Fato: `TECH.md` §5.2 define notificação via outbox → Kafka → worker (in-app + push). O módulo `notificacao` já tem template de convite e `publicar()` (hoje com push marcado pending sem FCM).

Fato (pedido 2026-11-21): cadastrar viagem com e-mail de outra pessoa deve disparar e-mail de convite; se o e-mail já tem cadastro, além do e-mail a pessoa recebe push e notificação no app; o processamento de notificações é **assíncrono via Kafka**.

Quem sente: quem convida e quem é convidado (com ou sem conta).

## 2. Necessidade de negócio

Convite sem e-mail não chega a quem não está no app. Convite só por e-mail, para quem já usa o MayahTrip, atrasa o aceite. Kafka evita acoplar SMTP/FCM à latência do `POST /v1/trips`.

## 3. Objetivo e resultado observável

Ao criar (ou convidar em) uma viagem com um ou mais e-mails:

1. Todo convidado recebe **e-mail** de convite (comportamento já existente, mantido).
2. Se o e-mail corresponder a uma conta existente, nasce evento de notificação processado **de forma assíncrona** (outbox → Kafka → worker): **notificação na central** + **push** (canais juntos, `BUSINESS` §4.1 / TECH §5.2).
3. Se o e-mail **não** tiver conta, só o e-mail; sem push/in-app fantasma.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono (e quem a regra de negócio já deixa convidar) | Incluir e-mails no create/invite | Papéis e permissão de convidar seguem a regra já da viagem |
| Convidado com conta | Recebe e-mail + in-app + push | Só se o e-mail bater com a conta |
| Convidado sem conta | Recebe só e-mail | Precisa criar/entrar depois para aceitar no app |

## 5. Escopo

### 5.1 Dentro do escopo

- No fluxo de **criar viagem com invites** e de **convidar** depois: após gravar o(s) convite(s), garantir e-mail de convite.
- Para cada e-mail convidado que já possui conta: gravar evento na **outbox** na mesma transação do negócio (padrão TECH) e publicar no Kafka para o worker de notificação.
- Worker: cria notificação in-app (tipo convite) + registro de entrega push (FCM quando credencial existir; senão status pending/erro explícito como hoje, sem bloquear o create).
- Idempotência básica: reprocessar o mesmo evento de outbox não duplica notificação de convite para o mesmo `(userId, tripInviteId)` (ou chave equivalente).
- Observabilidade: correlation id no create; log do worker sem token de convite em claro se possível (ou mascarado).

### 5.2 Fora de escopo

- `refresh-token-retry-401` e `inicio-proximas-3-viagens`.
- Aceitar/recusar convite na UI (já coberto em parte por `notificacoes` / `compartilhar-viagem`).
- Credencial FCM em produção se ainda não estiver no ambiente (worker pode marcar push pending — P-2).
- Outros tipos de notificação (gasto, roteiro, etc.).
- Redesign do e-mail de convite.
- Nome definitivo do tópico Kafka se TECH ainda marca `A DEFINIR` — fecha-se um nome mínimo nesta fatia (D-2) sem abrir todos os tópicos do produto.

## 6. Comportamento esperado

Fluxo principal (create com invites ou POST invite):

1. API valida e grava viagem + participantes/convites.
2. Para cada convite novo:
   - Enfileira/envia **e-mail** (mantém o canal atual; pode permanecer síncrono nesta fatia ou também ir à fila — ver D-1).
   - Resolve se existe `user` com aquele e-mail.
   - Se existe: grava outbox `trip.invite` (ou nome D-2) com `inviteeUserId`, `tripId`, `inviteId`, nome de quem convida, título.
3. Publisher envia ao Kafka; worker consome e chama o caminho de notificação (in-app + push).
4. Resposta HTTP do create/invite **não espera** o worker terminar.

Casos:

- E-mail inválido: já recusado na validação atual (`email`).
- Conta inexistente: só e-mail.
- Conta existe: e-mail + outbox/Kafka → in-app + push.
- Falha SMTP: não derruba a viagem já criada (comportamento atual de log de falha); notificação Kafka segue independente se a conta existe.
- Falha Kafka/publisher: outbox permanece pendente para reenvio (padrão TECH); create já respondido.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado create/invite com e-mail **sem** conta, quando a operação conclui, então um e-mail de convite é disparado e **não** nasce notificação in-app para nenhum userId; verificado por e2e/integração (SMTP mock + query em `notification.notifications`).
- [ ] **AC-2** — Dado create/invite com e-mail **com** conta, quando a operação conclui, então existe e-mail de convite e, após o worker processar o evento, existe notificação in-app do tipo convite para esse usuário; verificado por e2e com consumer/worker em teste (ou outbox + handler).
- [ ] **AC-3** — Dado AC-2, quando o worker roda, então há entrega `in_app` sent e entrega `push` (sent ou pending com motivo de FCM ausente); verificado por `notification_deliveries`.
- [ ] **AC-4** — Dado o create com invite, quando a API responde 2xx, então a resposta não depende do fim do envio push/Kafka (latência do HTTP não inclui o worker); verificado por teste que mocka worker lento / assert de outbox pendente após o response.
- [ ] **AC-5** — Dado o mesmo evento de outbox reprocessado, quando o worker roda de novo, então não duplica a notificação de convite para o mesmo convite/usuário; verificado por contagem = 1.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | E-mail de convite permanece no caminho atual (SMTP no use case) nesta fatia; só in-app/push vão obrigatoriamente por Kafka. Mover e-mail para a fila fica fora (pergunta não bloqueante). | produto | pedido + TECH §5.2 |
| D-2 | decisão  | Nome mínimo do evento/tópico desta fatia: `notification.trip_invite` (payload com inviteId, tripId, inviteeUserId). Ajuste fino de naming pode vir em ADR depois. | backend | TECH §10 ainda aberto |
| P-1 | premissa | Match de conta é pelo e-mail normalizado (trim + lower) igual ao da identidade. | backend | schema identity |
| P-2 | premissa | Sem FCM no ambiente, push fica `pending` com mensagem explícita; não falha o convite. | backend | código atual `NotificacaoUseCase` |
| P-3 | premissa | Templates de convite in-app já existem no módulo de notificação. | backend | `modelos.ts` |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Outbox + publisher Kafka + consumer de notificação de convite |
| Dados                  | `outbox_events`; `notification.*`; sem mudar o shape do create trip além do já existente `invites` |
| UI/UX e acessibilidade | App só consome a central já especificada em `notificacoes` |
| Segurança              | Token de convite no e-mail; payload Kafka sem senha; não vazar refresh |
| Observabilidade        | Métricas/lags de outbox e worker; correlation id do HTTP no evento |

## 10. Plano de testes

- Widget/unitário: não se aplica (backend).
- Integração/e2e: create com e-mail conhecido / desconhecido; assert e-mail mock; assert outbox; rodar handler; assert notifications/deliveries; reprocessar.
- Manual: criar viagem no painel/app com e-mail de conta de teste; conferir caixa de entrada + sino.
- Casos de borda: dois invites iguais; convidar a si mesmo (já coberto por regras atuais se existirem); Kafka down.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Kafka indisponível | média | médio | outbox retém; create não falha |
| Duplicar notificação | média | médio | AC-5 / chave idempotente |
| E-mail síncrono ainda atrasar o HTTP | média | baixo | D-1; fila de e-mail depois |

- Rollback: parar de gravar outbox no create; manter só e-mail síncrono.
- Critério para abortar: create passa a falhar quando Kafka está fora.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Mover o SMTP de convite também para Kafka nesta mesma entrega? | não | produto | refine |
| Payload exato do push (deep link `/convite/{token}`) | não | app/backend | na implementação |
| ADR formal do tópico `notification.trip_invite` | não | backend | após refine |

## 13. Resultado

Convite sempre gera e-mail; se o e-mail já é conta MayahTrip, in-app + push nascem de forma assíncrona via Kafka/outbox.

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
