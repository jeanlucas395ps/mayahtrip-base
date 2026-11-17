# Criar conta (Web)

- Slug: `sign-up-web`
- Status: `descartada` — decisão de produto revista em 2026-11-16, no mesmo dia da criação: o site mantém só login com conta já existente (`.docs/WEB/02-login.md`), sem cadastro próprio. Ver `.specs/047-web-session-handoff-api.md` para o que resolveu a necessidade original (entrar no site a partir do app sem repetir credenciais). Arquivo mantido como registro histórico da decisão, não como trabalho pendente.
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-web`
- Docs relacionados: `.docs/WEB/WEB.md`, `.docs/WEB/01-entrada-pelo-app.md`, `.docs/WEB/02-login.md`, `.docs/BUSINESS/02-cadastro-e-verificacao.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`
- Specs relacionadas: `sign-up-api` (`.specs/042-sign-up-api.md`), `confirm-account-api` (`.specs/043-confirm-account-api.md`), `sign-up` (`.specs/003-sign-up.md`, mayahtrip-app), `confirm-account` (`.specs/004-confirm-account.md`, mayahtrip-app)
- ADRs relacionados: nenhum

## 1. Contexto

Fato: `.docs/WEB/WEB.md` §1 e §2, `.docs/WEB/01-entrada-pelo-app.md` e `.docs/WEB/02-login.md` descrevem hoje um site que **só** loga com uma conta já criada no app — "o dono da conta do app", acesso só por deep link vindo do perfil do app, convidado é mandado criar conta no app, e não existe nenhum item de índice para "cadastro" em `WEB.md` §4.

Decisão de produto (D-1, fechada nesta conversa com quem decide o produto): o site `mayahtrip-web` passará a ter uma tela de cadastro de conta nova, usando o mesmo sistema de conta do app. Isso contradiz os três documentos acima, que ainda não foram atualizados — ver **Pendência de documentação** abaixo.

Quem sente: quem quiser criar conta diretamente pelo site, sem passar pelo app primeiro.

## 2. Necessidade de negócio

O usuário decidiu que o site deve oferecer um caminho de entrada independente do app. Sem esta fatia, a única forma de obter conta continua sendo o app.

## 3. Objetivo e resultado observável

Ao preencher nome, e-mail, senha e aceitar os termos no site, e confirmar o código de 4 dígitos recebido por e-mail, uma conta é criada e confirmada, pronta para logar em `.docs/WEB/02-login.md`.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Visitante sem conta, direto no site | Criar conta nova com nome, e-mail e senha; confirmar com o código recebido | Mesmas restrições do cadastro no app: e-mail não pode já ter conta (ver `.specs/042-sign-up-api.md`, D-2) |

## 5. Escopo

### 5.1 Dentro do escopo

- Tela/fluxo de cadastro no site: nome, e-mail, senha, aceite de termos — mesmos campos e mesma ordem de validação de `.docs/BUSINESS/02-cadastro-e-verificacao.md`.
- Tela/fluxo de confirmação do código de 4 dígitos no site, com reenvio — mesmo comportamento de `confirm-account-api`.
- Consumo de `sign-up-api` (`.specs/042-sign-up-api.md`) e `confirm-account-api` (`.specs/043-confirm-account-api.md`) em `/v1` — nenhum endpoint novo no backend.
- Encaminhamento para `.docs/WEB/02-login.md` após confirmar (ver D-2 — login automático é pergunta não bloqueante).

### 5.2 Fora de escopo

- `sign-in-web` — login no site com conta existente; não foi pedido nesta rodada, embora `WEB/02-login.md` já descreva o comportamento esperado.
- `sign-up-api`, `confirm-account-api`, `sign-in-api` — backend já especificado, reaproveitado sem mudança.
- Qualquer mudança nas telas de cadastro/confirmação do app (`.specs/003-sign-up.md`, `.specs/004-confirm-account.md`).
- Atualização formal de `.docs/WEB/WEB.md`, `01-entrada-pelo-app.md` e `02-login.md` para refletir a nova decisão — registrada como pendência, não como trabalho desta spec.
- Framework do site e domínio público — `A DEFINIR` em `ARCHITECTURE.md`.
- Referência visual/design do site — não existe protótipo nem `DESIGN.md` para `mayahtrip-web` hoje (ver Perguntas em aberto).
- Login com Google no site — `WEB/02-login.md` já fecha que "login com Google não existe neste site"; o cadastro novo também não oferece Google como método.

## 6. Comportamento esperado

Cadastro: visitante preenche nome, e-mail, senha e aceita os termos no site → mesma validação de borda de `.docs/BUSINESS/02-cadastro-e-verificacao.md` → chamada a `sign-up-api` → se sucesso, segue para a tela de confirmação do código; se erro, mostra a mensagem equivalente, mantendo os valores digitados (mesma regra do app).

Confirmação: visitante digita o código de 4 dígitos → chamada a `confirm-account-api` → código certo confirma a conta e mostra "Conta criada"; código errado mostra quantas tentativas restam (das 5); reenvio segue a janela de 30 s, igual ao app.

Depois de confirmar: encaminha para `.docs/WEB/02-login.md` (ver D-2 sobre logar automático ou não).

## 7. Critérios de aceite

- [ ] **AC-1** — Dado nome, e-mail não cadastrado, senha de 8+ caracteres e termos aceitos, quando o formulário de cadastro do site é enviado, então `sign-up-api` é chamada com esses dados e, em caso de sucesso, a tela de confirmação de código é exibida; verificado por teste de integração/e2e do site.
- [ ] **AC-2** — Dado qualquer campo inválido (nome vazio, e-mail inválido, senha curta, termos não aceitos), quando o formulário é enviado, então a mensagem de erro equivalente à de `.docs/BUSINESS/02-cadastro-e-verificacao.md` é exibida e `sign-up-api` não é chamada; verificado por teste de componente/e2e.
- [ ] **AC-3** — Dado que a conta foi criada e o código enviado, quando o código correto de 4 dígitos é informado, então `confirm-account-api` confirma a conta e a tela "Conta criada" é exibida; verificado por teste de integração/e2e.
- [ ] **AC-4** — Dado um código incorreto, quando informado, então a tela mostra quantas tentativas restam (das 5), replicando o contrato de `confirm-account-api`; verificado por teste de integração/e2e.
- [ ] **AC-5** — Dado que 30 s ou mais passaram desde o último código, quando "Reenviar código" é acionado, então `confirm-account-api` (endpoint de reenvio) é chamada e um novo código é esperado; verificado por teste de integração/e2e.
- [ ] **AC-6** — Dado um e-mail que já tem conta, quando o cadastro é enviado, então o site exibe uma resposta de erro genérica (mesmo contrato de `sign-up-api`, D-2 daquela spec) sem revelar que o e-mail já existe; verificado por teste de integração/e2e.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | Framework do `mayahtrip-web` ainda não está decidido (`A DEFINIR` em `ARCHITECTURE.md` §3/§6) | arquitetura | Decidir e registrar ADR antes de iniciar a implementação desta spec |
| P-2 | premissa | Não existe protótipo nem `DESIGN.md`/`DESIGN_SYSTEM.md` para `mayahtrip-web` — a referência visual usada pelo app (`.docs/prototype`, 390×844) não se aplica a um site | design | Produto/design definir referência visual do site antes ou durante a implementação |
| D-1 | decisão | O site passará a ter cadastro de conta nova, reaproveitando o mesmo backend do app (`sign-up-api` + `confirm-account-api`) — decisão tomada nesta conversa, confirmada explicitamente pelo responsável do produto | produto | Nenhuma — decisão já confirmada; pendência é só atualizar a documentação (ver abaixo) |
| D-2 | decisão proposta, não bloqueante | Depois de confirmar o código, a pessoa é encaminhada para a tela de login (`WEB/02-login.md`) em vez de logar automaticamente — não é fato fechado em nenhum doc | produto | Confirmar se deve logar automático ou pedir login de novo |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Nova superfície de UI em `mayahtrip-web` consumindo contratos já existentes de `mayahtrip-backend`; nenhum contrato novo de API |
| Dados | Nenhum dado novo — mesma conta/registro criado por `sign-up-api` |
| UI/UX e acessibilidade | Tela nova sem referência visual fechada (P-2); seguir, no mínimo, WCAG 2.2 AA como já exigido para o painel em `DEVELOPMENT.md` §8, por ausência de guia específico do site |
| Segurança | Mesma superfície de ataque de `sign-up-api`/`confirm-account-api`; o site não adiciona validação própria de segurança além de repassar o contrato |
| Observabilidade | Fora do escopo desta spec — pertence ao backend (já cobertas em `.specs/042` e `.specs/043`) |

## 10. Plano de testes

- Widget/unitário: validação de formulário client-side (mesma ordem de `.docs/BUSINESS/02-cadastro-e-verificacao.md`).
- Integração: AC-1 a AC-6, com `sign-up-api`/`confirm-account-api` mockadas ou em ambiente de teste.
- Manual no frame 390×844: não se aplica — site, não app; sem frame de referência definido (P-2).
- Casos de borda: e-mail já cadastrado, código expirado, 5ª tentativa de código errada, reenvio antes dos 30 s.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Documentação (`WEB.md`, `01`, `02`) ficar desalinhada com o produto real, confundindo quem ler depois | alta | médio | Ver **Pendência de documentação** — deve ser corrigida assim que esta spec for aprovada |
| Implementar antes do framework do site estar decidido (P-1) | média | alto | Não iniciar a implementação sem ADR do framework |

- Rollback: tela nova e isolada no repositório `mayahtrip-web`; reverter não afeta o backend nem o app.
- Critério para abortar: se P-1 (framework) não estiver decidido, não iniciar a implementação.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Framework do site (P-1, `A DEFINIR` em `ARCHITECTURE.md`) | não (mas bloqueia a implementação) | arquitetura | antes de implementar |
| Referência visual/design do site (P-2) | não | design/produto | antes ou durante a implementação |
| Logar automático após confirmar ou encaminhar para login (D-2) | não | produto | antes de implementar |
| Domínio público do site (`A DEFINIR` em `ARCHITECTURE.md`/`WEB.md`) | não | produto/infra | — |

## Pendência de documentação (fora desta spec, registrar no relatório)

`.docs/WEB/WEB.md` §1 ("Quem usa: o dono da conta do app"), §2 ("O que ele faz aqui", sem item de cadastro) e §4 (índice sem arquivo de cadastro), além de `.docs/WEB/01-entrada-pelo-app.md` ("se a pessoa não tem sessão no site, cai no login") e `.docs/WEB/02-login.md`, descrevem um site sem cadastro próprio. Com D-1 desta spec, esses documentos estão desatualizados e precisam de revisão por quem é dono do produto — esta spec não os altera porque a correção é uma decisão de documentação de produto, não um detalhe de implementação desta fatia.

## 13. Resultado

Pronto quando um visitante conseguir criar e confirmar uma conta nova inteiramente pelo site, usando os mesmos endpoints do app, com AC-1 a AC-6 passando em teste automatizado.

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
