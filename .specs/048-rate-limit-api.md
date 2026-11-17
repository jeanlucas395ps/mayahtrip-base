# Limite de taxa da API

- Slug: `rate-limit-api`
- Status: `concluída` — um guarda para toda rota HTTP, testado em 2026-11-17 (`mayahtrip-backend`); o teto de produção continua em aberto e o teste injeta o limite
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-backend`
- Docs relacionados: `.docs/ARCHITECTURE.md`, `.docs/DEVELOPMENT.md`, `.docs/OBSERVABILITY.md`, `.docs/RULES.md`
- Specs relacionadas: `sign-up-api`, `confirm-account-api`, `sign-in-api`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o pedido fecha que a API tem um único guard de limite de taxa e que ele protege todas as rotas. Não existe arquivo em `BUSINESS/` com número de requisições, janela ou chave (IP, conta, token).

Fato: `sign-up-api`, `confirm-account-api` e `sign-in-api` cada uma propõe o próprio limite de taxa, com valor numérico ainda não fechado. Isso são três mecanismos. O pedido desta fatia substitui esse desenho por um guard só.

Quem sente: qualquer cliente da API (app, site de planos, painel) e quem opera a plataforma quando uma rota fica exposta sem o mesmo teto das outras.

Premissa, não fato: o número, a janela e a chave do limite ainda não existem em documento. Esta spec não escolhe esses valores.

## 2. Necessidade de negócio

Sem um guard único, cada rota nova pode nascer sem limite ou com um limite diferente. O sucesso é uma rota qualquer, inclusive uma que ainda não existia quando o guard foi ligado, rejeitar acima do mesmo teto e seguir o fluxo normal abaixo dele.

## 3. Objetivo e resultado observável

Toda rota HTTP da API passa pelo mesmo guard de limite de taxa. Abaixo do teto configurado, a rota executa. Acima dele, a rota não executa e a resposta de rejeição é a mesma em qualquer rota.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Cliente da API (app, site, painel, teste) | Chamar qualquer rota dentro do teto | Acima do teto, a chamada é rejeitada antes da rota |
| Operação | Ver que a rejeição aconteceu, sem senha, token ou corpo sensível no log | Não há tela nesta spec |

## 5. Escopo

### 5.1 Dentro do escopo

- Um único guard de limite de taxa na API.
- O guard vale para todas as rotas HTTP da API, as que já existem e as que forem adicionadas depois, sem um segundo guard na rota.
- A rejeição acontece antes da rota. A resposta de rejeição tem o mesmo formato em todas as rotas.
- Métrica da rejeição, sem dado sensível.

### 5.2 Fora de escopo

- Número de requisições, duração da janela e chave do contador (IP, conta, token ou outra). Nenhum doc fecha isso. Não inventar o número.
- Limite de tentativas de negócio que já está escrito: 5 códigos errados e reenvio após 30 s em `confirm-account-api` / `BUSINESS/02`. Isso não é este guard.
- Bloqueio de senha de `BUSINESS/01`, marcado `A DEFINIR`.
- Guard, filtro ou middleware de limite diferente por rota, inclusive os propostos em `sign-up-api` (D-3), `confirm-account-api` (D-1) e `sign-in-api` (D-3).
- Limite no app, no site ou no painel. Eles só recebem a rejeição da API.
- Escolha de Postgres, Redis ou memória para o contador. `ARCHITECTURE.md` §5 deixa isso em aberto. Se a implementação precisar de um deles, o ADR vem antes, fora desta spec.

## 6. Comportamento esperado

O guard é um só e envolve a API inteira. Nenhuma rota registra o seu próprio limite.

Abaixo do teto, a requisição segue para a rota e a resposta é a da rota.

Acima do teto, a rota não roda. Criar conta não grava e não envia e-mail. Login não confere senha. Confirmar código não consome uma tentativa das 5. O mesmo vale para qualquer outra rota.

A rejeição é estável: sem stack trace e sem dado interno (`DEVELOPMENT.md` §3). Duas rotas diferentes, no mesmo estado de limite excedido, devolvem a mesma forma de erro.

O contador deste guard não substitui a regra das 5 tentativas de código. As duas podem existir juntas. Esta spec não redefine a das 5.

Vazio: não se aplica. O guard não tem lista para mostrar.

Erro: a única falha desta fatia é a rejeição por limite. Falha da rota em si pertence à spec da rota.

Permissão: o guard não olha papel de viagem. Corre antes da autorização da rota.

Limite: um teto para a API toda. O número não está nesta spec.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado duas rotas distintas da API e um volume abaixo do teto configurado, quando cada uma é chamada, então as duas executam e devolvem a resposta da própria rota; verificado por teste de integração.
- [ ] **AC-2** — Dado o teto configurado já excedido, quando se chama cadastro, login e uma terceira rota qualquer, então nenhuma das três executa o seu caso de uso e as três devolvem a mesma forma de erro; verificado por teste de integração.
- [ ] **AC-3** — Dado uma rota criada só no teste, sem guard próprio, quando ela é chamada acima do teto, então também é rejeitada pelo mesmo guard; verificado por teste de integração.
- [ ] **AC-4** — Dado o código de confirmação ainda com tentativas das 5 restantes, quando o teto deste guard já estourou, então a confirmação não roda e o contador das 5 tentativas não muda; verificado por teste de integração.
- [ ] **AC-5** — Dado uma rejeição por limite, quando o log e a métrica são emitidos, então há métrica de rejeição e o log não contém senha, token, código de verificação nem corpo de e-mail; verificado por inspeção do log estruturado e da métrica.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | Há um único guard de limite de taxa e ele protege todas as rotas da API. Pedido de 2026-11-16. | produto | AC-2 e AC-3 |
| D-2 | decisão | Os limites de taxa propostos em `sign-up-api`, `confirm-account-api` e `sign-in-api` não viram outro guard. O limite de 5 códigos e o reenvio de 30 s continuam naquelas specs. | produto | AC-4 |
| P-1 | premissa | Número, janela e chave do teto não estão em `BUSINESS/` nem em `ARCHITECTURE.md`. A implementação não escolhe esses valores no lugar do produto. | produto | Pergunta não bloqueante abaixo |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Um guard na borda da API, para toda rota. App, site e painel não ganham contrato novo; passam a poder receber a rejeição. |
| Dados | Nenhum schema nesta spec. Onde o contador mora continua em aberto. |
| UI/UX e acessibilidade | Não se aplica. Não há tela. |
| Segurança | A rota não executa depois do teto. Log sem segredo. |
| Observabilidade | Métrica de rejeição por limite, sem id de usuário, id de viagem ou texto de busca no rótulo (`OBSERVABILITY.md` §5). |

## 10. Plano de testes

- Widget/unitário: não se aplica. Não há tela.
- Integração: AC-1 a AC-5, com o teto injetado pelo teste. O teste não fixa o número de produção.
- Manual no frame 390×844: não se aplica.
- Casos de borda: a chamada exatamente no último pedido permitido executa; a seguinte rejeita. Rota nova sem guard próprio entra no AC-3.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| O teto também atinge a rota de saúde e o orquestrador reinicia o processo | média | alto | AC-2 vale para toda rota, inclusive saúde, porque o pedido disse todas. O número continua com o produto. |
| Cada spec de rota volta a criar o próprio limite | média | alto | D-2 e AC-3 |

- Rollback: tirar o guard. As rotas voltam a responder sem este teto. As 5 tentativas de código não dependem dele.
- Critério para abortar: a implementação precisa inventar número, janela ou chave, ou precisa de um guard por rota para passar nos AC.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Qual é o número de requisições, a janela e a chave (IP, conta, token ou outra)? | não | produto | antes de implementar |
| Qual é o código HTTP da rejeição? O doc não fixa. A forma do erro tem de ser a mesma em toda rota. | não | produto | antes de implementar |

Nenhuma pergunta acima bloqueia o contrato: o guard é um só, cobre todas as rotas, e o número não é inventado aqui.

## 13. Resultado

Pronto quando toda rota da API, inclusive uma rota nova sem guard próprio, passar abaixo do teto e for rejeitada acima dele pela mesma resposta, com AC-1 a AC-5 verdes.

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
