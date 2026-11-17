# Entrar no site a partir do app (handoff seguro)

- Slug: `web-session-handoff-api`
- Status: `concluída` — código opaco de uso único e troca por access+refresh testados em 2026-11-17 (`mayahtrip-backend`); os 60 s continuam a proposta, não uma decisão fechada
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/WEB/01-entrada-pelo-app.md`, `.docs/WEB/02-login.md`, `.docs/WEB/WEB.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`
- Specs relacionadas: `sign-in-api` (`.specs/044-sign-in-api.md`), `sign-up-web` (`.specs/045-sign-up-web.md`, descartada — contexto da reviravolta)
- ADRs relacionados: nenhum (ver P-1)

## 1. Contexto

Fato: `.docs/WEB/01-entrada-pelo-app.md` diz que os botões "Ver PRO"/"Gerenciar plano" do app abrem o site no navegador do aparelho e que, "se a pessoa não tem sessão no site, cai no login". Hoje isso significa digitar e-mail/senha de novo, mesmo já estando logado no app.

Decisão de produto (revisão explícita desta conversa): a tentativa anterior de resolver a fricção de entrada no site era dar um cadastro próprio ao site (`.specs/045-sign-up-web.md`); essa decisão foi revertida. A necessidade real era outra: entrar direto no site a partir do app já logado, "de forma segura sem expor dados no request". Esta spec substitui `045-sign-up-web.md` na fila.

Quem sente: quem toca em "Ver PRO"/"Gerenciar plano" no app e tem que digitar a senha de novo no navegador, mesmo com o app já autenticado.

## 2. Necessidade de negócio

Remover uma fricção desnecessária (reautenticar manualmente) sem comprometer segurança — o pedido explícito foi "sem expor dados no request", ou seja, sem colocar o token real na URL que abre o navegador.

## 3. Objetivo e resultado observável

Ao tocar em "Ver PRO"/"Gerenciar plano" no app (sessão ativa), o navegador abre no site já com uma sessão criada, sem pedir login — e em nenhum momento o access token ou o refresh token reais do app aparecem na URL ou em qualquer request visível pelo navegador.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Titular de conta com sessão ativa no app | Pedir um código de handoff e abrir o site já autenticado | Só com access token válido; convidado não tem conta e não chama este endpoint (`WEB/WEB.md` §1: "convidado não entra") |

## 5. Escopo

### 5.1 Dentro do escopo

- Endpoint de emissão em `/v1`: recebe o access token do app (header/corpo de chamada HTTPS normal, nunca na URL) e devolve um **código de handoff** — opaco, aleatório, de uso único, curta duração (proposto 60 s, ver D-1). A versão é a atual da API (`.specs/051-versao-da-api.md`).
- Endpoint de troca: recebe o código de handoff (vindo da URL que o navegador abriu) e devolve/cria uma sessão do site, invalidando o código imediatamente após o uso.
- Código de handoff rejeitado se: não existir, já tiver sido usado, ou tiver expirado.
- Persistência do código de handoff no Postgres (mesma decisão de banco das specs anteriores desta fila), criado por migration.
- Observabilidade: correlation id, log sem o código nem os tokens em texto puro, métricas de latência e erro dos dois endpoints.

### 5.2 Fora de escopo

- `sign-up-web` (`.specs/045-sign-up-web.md`) — descartada, não ressuscitar.
- `sign-in-web` — login direto no site com e-mail/senha, sem vir do app; não foi pedido nesta rodada.
- `sign-in-api`, `sign-up-api`, `confirm-account-api` — já existem, não mudam.
- O botão no app que abre o navegador (`WEB/01-entrada-pelo-app.md` já descreve isso); esta spec cobre só o que acontece no backend quando esse botão é tocado.
- Framework do site e onde o front-end do site consome o endpoint de troca — `A DEFINIR` em `ARCHITECTURE.md`.
- Formato exato da sessão do site (cookie vs token, duração) — só o fato de que uma sessão é criada ao final da troca está dentro do escopo; o formato fica a cargo de quem implementar o site.

## 6. Comportamento esperado

Emissão: app, com access token válido, chama o endpoint de handoff → API confirma o access token → gera um código opaco de uso único, associa à conta, grava com expiração curta (D-1) → devolve o código ao app na resposta da chamada (não na URL) → app monta a URL do site com esse código (`https://<site>/handoff?code=...`, domínio exato `A DEFINIR` em `WEB.md`) e abre no navegador.

Troca: site chama o endpoint de troca com o código recebido na URL → API confirma que o código existe, não expirou e não foi usado → invalida o código (uso único) → cria/devolve uma sessão do site para a conta associada → site segue para o plano (`WEB/03`), sem pedir login.

Código inválido, expirado ou já usado: endpoint de troca responde erro, nenhuma sessão de site é criada; se o código já tiver sido usado antes, é tratado como erro (mesmo princípio de reuso suspeito do refresh token em `sign-in-api`).

Access token inválido/expirado ao pedir o código: nenhum código é emitido; o app trata isso como qualquer outra chamada autenticada que falhou (ex.: tenta refresh primeiro, fora do escopo desta spec).

## 7. Critérios de aceite

- [ ] **AC-1** — Dado um access token válido, quando o endpoint de emissão é chamado, então um código de handoff opaco, de uso único, é gerado e devolvido na resposta (nunca em uma URL nessa chamada); verificado por teste de integração.
- [ ] **AC-2** — Dado um access token inválido ou expirado, quando o endpoint de emissão é chamado, então nenhum código é gerado; verificado por teste de integração.
- [ ] **AC-3** — Dado um código de handoff válido, não expirado e não usado, quando o endpoint de troca é chamado com esse código, então uma sessão de site é criada/devolvida e o código passa a inválido para qualquer chamada futura; verificado por teste de integração.
- [ ] **AC-4** — Dado um código de handoff já usado uma vez, quando o endpoint de troca é chamado de novo com o mesmo código, então nenhuma sessão nova é criada e a resposta é um erro; verificado por teste de integração.
- [ ] **AC-5** — Dado um código de handoff expirado (passado o tempo de D-1), quando o endpoint de troca é chamado, então nenhuma sessão é criada e a resposta é um erro; verificado por teste de integração com relógio controlado.
- [ ] **AC-6** — Dado qualquer chamada aos dois endpoints, quando a requisição é processada, então a API propaga/gera correlation id, expõe métrica de latência e erro, e nenhum log contém o código de handoff, o access token ou o refresh token em texto puro; verificado por inspeção do log estruturado e do endpoint de métricas.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | Infraestrutura sendo construída em paralelo por outro agente, mesma premissa das specs anteriores desta fila | infra | Confirmar ambiente disponível antes de implementar |
| D-1 | decisão proposta, não bloqueante | Código de handoff opaco, aleatório, uso único, validade curta — proposto 60 segundos | produto/segurança | Confirmar o valor exato antes de implementar |
| D-2 | decisão | Código de handoff persistido no Postgres, criado por migration — mesma convenção de banco das specs anteriores desta fila (`.specs/042` D-4, `.specs/044` D-5) | produto | Nenhuma — decisão fechada |
| D-3 | decisão | O access/refresh token do app nunca viaja na URL do navegador nem em query string — só o código opaco de handoff viaja ali; o access token real só é usado na chamada de emissão, feita como requisição HTTPS normal (header/corpo), não como parte de uma URL de navegação | autor da spec | Nenhuma — decorre direto do pedido explícito "sem expor dados no request" |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Dois novos endpoints no módulo `identidade`; depende de `sign-in-api` para o access token; o site (`mayahtrip-web`) passa a ter um endpoint/rota que consome a troca |
| Dados | Novo registro de código de handoff, uso único, vida curta (Postgres, D-2) |
| UI/UX e acessibilidade | Nenhuma nesta spec — é só API; o botão que já existe no app (`WEB/01`) não muda de aparência |
| Segurança | Código opaco de uso único e curta duração (D-1/D-3) evita expor o token real; detecção de reuso do código (AC-4) é o mesmo princípio de segurança já aplicado ao refresh token |
| Observabilidade | Métrica de latência e erro dos dois endpoints, desde a primeira versão |

## 10. Plano de testes

- Widget/unitário: não se aplica (sem UI); unitário de domínio cobre geração e expiração do código isoladamente.
- Integração: AC-1 a AC-6 (repositório, relógio controlado).
- Manual no frame 390×844: não se aplica — spec sem tela de app; o botão que dispara isso já existe e não muda.
- Casos de borda: código usado exatamente no limite da expiração, duas chamadas de troca quase simultâneas com o mesmo código (apenas uma deve vencer).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Código de handoff interceptado entre a emissão e a troca (ex.: histórico do navegador, proxy) | baixa | médio | D-1 — validade curta e uso único reduzem a janela de ataque a segundos |
| Corrida entre duas trocas simultâneas do mesmo código | baixa | médio | AC-4 — invalidação atômica no primeiro uso |

- Rollback: endpoints novos e isolados; reverter não afeta `sign-in-api` nem o fluxo manual de login do site (`WEB/02`), que continua funcionando sem o handoff.
- Critério para abortar: se P-1 (infra) não estiver disponível, não implementar.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Valor exato de validade do código de handoff (D-1 propõe 60 s) | não | produto/segurança | antes de implementar |
| Domínio público do site onde a URL de handoff é aberta (`A DEFINIR` em `WEB.md`/`ARCHITECTURE.md`) | não | produto/infra | — |
| Framework do site e como ele consome o endpoint de troca (`A DEFINIR` em `ARCHITECTURE.md`) | não | arquitetura | antes de implementar o lado do site |

## 13. Resultado

Pronto quando um app com sessão ativa conseguir abrir o site já autenticado via código de handoff de uso único, sem o token real aparecer em nenhuma URL, e todos os casos de código inválido/expirado/reusado forem recusados — com AC-1 a AC-6 passando em teste automatizado.

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
