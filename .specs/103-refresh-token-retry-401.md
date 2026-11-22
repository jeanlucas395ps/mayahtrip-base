# Retry com refresh em 401

- Slug: `refresh-token-retry-401`
- Status: `rascunho`
- Data: 2026-11-21
- Última atualização: 2026-11-21
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/01-login.md`, `.docs/ARCHITECTURE.md`, `.docs/TECH/TECH.md` (§ refresh), `.specs/044-sign-in-api.md`
- Specs relacionadas: `sign-in-api`, `sign-in`, `biometric-sign-in`, `inicio-proximas-3-viagens`, `convite-viagem-notificacoes-kafka`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: a API devolve 401 com corpo no formato `{ message, statusCode, correlationId, timestamp, path }` quando o access token expirou ou foi rejeitado (exemplo observado em `GET /v1/trips`: `"Não foi possível entrar."`). O backend já expõe `POST /v1/auth/refresh` (`sign-in-api`).

Fato: o app guarda access e refresh (`SessaoRepository`), mas as chamadas HTTP (ex.: `ViagensApi`) ainda não renovam a sessão nem repetem o pedido ao receber 401.

Quem sente: qualquer pessoa logada cuja sessão de access expire no meio do uso (home, carteira, criar viagem).

## 2. Necessidade de negócio

Sem retry transparente, o app trata access expirado como “deslogado” e quebra fluxos reais (`/v1/trips`). O sucesso é: 401 com refresh válido → um novo access → o mesmo pedido concluído; refresh inválido → tela de login, sem loop.

## 3. Objetivo e resultado observável

Em qualquer chamada autenticada do app, um 401 dispara no máximo uma tentativa de `POST /v1/auth/refresh` com o refresh guardado; se a renovação funcionar, o pedido original é refeito uma vez com o novo access; se falhar, a sessão local é limpa e a pessoa vai para a tela de login.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Titular com sessão ativa | Continuar usando o app após expiração do access, sem digitar senha de novo | Só se o refresh ainda for válido |
| Titular com refresh inválido/revogado | É enviada à tela de login | Não tenta refresh em loop |
| Convidado | Não se aplica — sem tokens | Fora |

## 5. Escopo

### 5.1 Dentro do escopo

- Cliente HTTP do app: ao receber **401** em rota autenticada, tentar refresh uma vez e **retry uma vez** do pedido original.
- Persistir o novo par access/refresh devolvido pelo refresh (rotação já definida em `sign-in-api`).
- Se refresh falhar (401/4xx/rede sem token novo), limpar sessão local e navegar para login.
- Cobrir pelo menos as rotas já usadas de viagens (`/v1/trips` e derivadas), de forma que o mesmo mecanismo sirva às demais APIs autenticadas do app.

### 5.2 Fora de escopo

- `inicio-proximas-3-viagens` — limite de cartões na home.
- `convite-viagem-notificacoes-kafka` — e-mail/push/Kafka de convite.
- Alterar o contrato do endpoint de refresh no backend.
- Biometria (`biometric-sign-in`) além de reutilizar o refresh já guardado.
- Decidir duração do access/refresh (já em `sign-in-api` / TECH).

## 6. Comportamento esperado

1. App chama uma rota autenticada com Bearer access.
2. API responde **401** (corpo com `statusCode: 401`, ex. path `/v1/trips`).
3. Cliente:
   - Se já está no meio de um retry pós-refresh deste pedido → não tenta de novo; trata como falha de sessão.
   - Senão: lê o refresh; chama `POST /v1/auth/refresh`; guarda novos tokens; **repete o pedido original uma vez** com o novo access.
4. Se o refresh falhar ou não houver refresh: apaga tokens locais e abre a tela de login (mesmo destino do fluxo “sair” / sessão inválida).
5. Pedidos concorrentes que tomarem 401 no mesmo instante: no máximo um refresh em voo; os demais aguardam o resultado e reutilizam o novo access (ou caem no login juntos).

Estados:

- Sucesso após retry: o chamador recebe a resposta 2xx/4xx de negócio do pedido original, sem saber do 401 intermediário.
- Sem rede no refresh: mesma regra de falha de sessão → login (não deixa a UI “meio logada”).
- 401 em rotas públicas / no próprio `/auth/refresh`: não entra neste fluxo de retry.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado access expirado e refresh válido, quando o app chama `GET /v1/trips` e recebe 401, então chama refresh, guarda o novo access e conclui o `GET /v1/trips` com sucesso (ou com erro de negócio ≠ 401 de auth); verificado por teste unitário/integração do cliente HTTP com servidor mockado.
- [ ] **AC-2** — Dado 401 e refresh inválido (ou ausente), quando o retry de sessão falha, então a sessão local é limpa e a navegação vai para a tela de login; verificado por teste do cliente + navegação (ou spy de logout/navegação).
- [ ] **AC-3** — Dado um pedido que já foi refeito após um refresh, quando a segunda resposta ainda é 401, então o cliente **não** chama refresh de novo e envia a pessoa ao login; verificado por teste com contador de chamadas a `/auth/refresh` = 1.
- [ ] **AC-4** — Dado dois pedidos paralelos que recebem 401, quando o refresh está em andamento, então ocorre **uma** chamada a `/auth/refresh` e ambos os pedidos usam o access novo (ou ambos caem no login); verificado por teste com contador de refresh = 1.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| P-1 | premissa | `POST /v1/auth/refresh` e a rotação de refresh já existem (`sign-in-api`). | backend | inspeção / e2e auth |
| D-1 | decisão  | Qualquer 401 em rota autenticada do app dispara este fluxo (não só `/v1/trips`). | produto | pedido 2026-11-21 |
| D-2 | decisão  | No máximo um refresh + um retry por pedido; sem fila infinita. | produto | AC-3 |
| P-2 | premissa | Mensagem `"Não foi possível entrar."` é um 401 de auth; o gatilho é o status 401, não o texto. | app | contrato HTTP |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Cliente HTTP central (ou wrapper) no `mayahtrip-app`; consome contrato já existente de refresh |
| Dados                  | Atualiza tokens no cofre/secure storage |
| UI/UX e acessibilidade | Transição para login sem exigir ação extra além do fluxo atual de sessão inválida |
| Segurança              | Não logar tokens; um refresh em voo evita corrida |
| Observabilidade        | Útil correlacionar `correlationId` do 401 original nos logs do cliente (sem PII) |

## 10. Plano de testes

- Widget/unitário: cliente HTTP com mock de 401 → refresh 200 → retry 200; refresh 401 → logout.
- Integração: opcional contra API real com access curto.
- Manual: deixar access expirar (ou forçar token inválido) e abrir Carteira/home; confirmar lista de viagens ou redirect ao login.
- Casos de borda: pedidos paralelos; 401 no próprio refresh; ausência de refresh no cofre.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Loop de refresh se o servidor sempre devolver 401 | baixa | alto | AC-3; flag “já retentou” |
| Dois refresh simultâneos revogarem a família | média | alto | refresh single-flight |

- Rollback: desligar o interceptor e voltar a falhar o pedido no 401.
- Critério para abortar: refresh válido ainda leva a login em loop em produção.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Mostrar um toast “Sessão renovada” ou ficar silencioso? | não | produto | na implementação |
| Tela de login exata (stack reset vs. replace) segue o fluxo atual de logout? | não | app | alinhar com `sign-in` |

## 13. Resultado

401 autenticado no app vira refresh + um retry; se não der, a pessoa cai no login sem ficar presa.

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
