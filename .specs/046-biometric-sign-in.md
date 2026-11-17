# Entrar com biometria (Face ID / digital)

- Slug: `biometric-sign-in`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: TODO: pessoa/agente
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/00-abertura.md`, `.docs/BUSINESS/01-login.md`, `.docs/ARCHITECTURE.md`, `.docs/RULES.md`, `.docs/DEVELOPMENT.md`
- Specs relacionadas: `sign-in-api` (`.specs/044-sign-in-api.md`), `sign-in` (`.specs/002-sign-in.md`), `abertura` (`.specs/001-abertura.md`)
- ADRs relacionados: nenhum

## 1. Contexto

Fato: nem `.docs/BUSINESS/00-abertura.md` nem `.docs/BUSINESS/01-login.md` mencionam biometria. A decisão de ter Face ID/digital no app foi pedida diretamente pelo responsável do produto nesta conversa ("devemos ter no APP login com Face ID/Digital"), junto com a exigência de que segurança é prioridade. A documentação de negócio ainda não reflete essa decisão — ver **Pendência de documentação** abaixo, no mesmo espírito do que já foi registrado para a decisão do site web.

Quem sente: quem já logou uma vez no aparelho e não quer digitar e-mail/senha a cada abertura, mas também não marcou "manter conectado" por tempo indefinido, ou cujo access token expirou.

Premissa, não fato: depende do mecanismo de access/refresh token já decidido em `.specs/044-sign-in-api.md` (D-4/D-5); sem ele, não há nada para a biometria desbloquear.

## 2. Necessidade de negócio

Reduzir fricção de reentrada no app sem abrir mão de segurança — a biometria do sistema é mais rápida que digitar senha e, combinada com o refresh token já emitido, não exige reautenticar contra o servidor a cada abertura.

## 3. Objetivo e resultado observável

Com a biometria habilitada e um refresh token válido armazenado no cofre seguro do aparelho, abrir o app e passar pela biometria do sistema libera o uso do app sem pedir e-mail/senha. Biometria recusada, cancelada ou indisponível leva à tela de login normal.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Titular de conta que já logou no aparelho | Habilitar biometria; desbloquear com biometria nas aberturas seguintes | Só funciona enquanto o refresh token armazenado continuar válido no servidor (`sign-in-api`) |
| Convidado | Não se aplica — não tem conta nem refresh token | Fora de escopo |

## 5. Escopo

### 5.1 Dentro do escopo

- Opção para habilitar Face ID/digital após um login bem-sucedido (e-mail/senha ou Google).
- No fluxo de abertura (`.specs/001-abertura.md`), quando a biometria está habilitada e existe refresh token armazenado: solicitar a biometria do sistema antes de liberar o Início.
- Em caso de sucesso na biometria: trocar o refresh token armazenado por um novo access token junto a `sign-in-api` (endpoint de refresh, `.specs/044-sign-in-api.md`) e seguir para o Início.
- Em caso de falha, cancelamento ou indisponibilidade da biometria: cair para a tela de login normal (`.specs/002-sign-in.md`), sem travar o app.
- Armazenamento do refresh token no cofre seguro do sistema operacional (Keychain no iOS, Keystore no Android) — nunca em `SharedPreferences`/armazenamento não criptografado.
- Desabilitar a biometria remove o refresh token do cofre seguro do aparelho (mas não revoga a sessão no servidor; revogação de sessão é de outra spec).

### 5.2 Fora de escopo

- `sign-in-api`, `sign-up-api`, `confirm-account-api` — backend não muda; a biometria consome o endpoint de refresh que já existe.
- `sign-in` (`.specs/002-sign-in.md`) — a tela de login em si não muda; esta spec só adiciona o que acontece antes dela, quando a biometria está habilitada.
- Onde exatamente mora o toggle de habilitar/desabilitar (tela de login, abertura, ou perfil `BUSINESS/28`) — não está fechado em doc nenhum (ver Perguntas em aberto); esta spec cobre o comportamento de desbloqueio, não a tela de configuração.
- Qualquer leitura de dado biométrico pelo app ou pela API — a biometria nunca sai do sistema operacional do aparelho; o app só recebe um resultado sim/não.
- Revogação de refresh token por troca de senha ou "sair em todos os lugares" — já é consequência natural do design de `sign-in-api` (D-4/D-5), não precisa de trabalho novo aqui: se o refresh estiver revogado no servidor, a troca por access token simplesmente falha e o app cai para login normal.
- Fallback por PIN do sistema quando a biometria falha repetidas vezes — comportamento do próprio sistema operacional, não controlado pelo app; não especificado aqui.

## 6. Comportamento esperado

Habilitar: depois de um login bem-sucedido, a pessoa opta por habilitar Face ID/digital → app verifica que o aparelho tem biometria disponível e configurada → se sim, guarda o refresh token já emitido no cofre seguro do sistema e marca a preferência como habilitada → se o aparelho não tiver biometria disponível, a opção não é oferecida (ou fica desabilitada, ver Perguntas em aberto).

Abertura com biometria habilitada: `.specs/001-abertura.md` detecta que existe refresh token guardado e a preferência está habilitada → solicita a biometria do sistema → sucesso → chama o endpoint de refresh de `sign-in-api` com o refresh token guardado → sucesso do refresh → segue para o Início com o novo access token → qualquer falha no refresh (token revogado/expirado) → remove o refresh guardado e cai para a tela de login normal.

Abertura com biometria recusada/cancelada pela pessoa: cai para a tela de login normal, sem apagar o refresh token guardado (pode tentar de novo na próxima abertura).

Abertura sem biometria habilitada: comportamento inalterado, segue `.specs/001-abertura.md` como já especificado (sessão ativa → Início; sem sessão → Login).

## 7. Critérios de aceite

- [ ] **AC-1** — Dado um login bem-sucedido e um aparelho com biometria disponível, quando a pessoa opta por habilitar Face ID/digital, então o refresh token é guardado no cofre seguro do sistema operacional e a preferência fica habilitada; verificado por teste de integração no app.
- [ ] **AC-2** — Dado um aparelho sem biometria disponível ou configurada, quando a tela de habilitar é mostrada, então a opção não aparece ou aparece desabilitada; verificado por teste manual/widget com biometria mockada como indisponível.
- [ ] **AC-3** — Dado biometria habilitada e refresh token guardado válido, quando o app abre e a biometria é aceita, então um novo access token é obtido via refresh e a pessoa chega ao Início sem ver a tela de login; verificado por teste de integração com biometria e API mockadas.
- [ ] **AC-4** — Dado biometria habilitada, quando a biometria é recusada ou cancelada na abertura, então a pessoa cai na tela de login normal e o refresh token guardado permanece intacto; verificado por teste de integração.
- [ ] **AC-5** — Dado biometria habilitada mas o refresh token guardado foi revogado no servidor, quando a biometria é aceita na abertura, então a troca por access token falha, o refresh guardado é removido do cofre seguro, e a pessoa cai na tela de login normal; verificado por teste de integração com API mockada retornando refresh inválido.
- [ ] **AC-6** — Dado que a pessoa desabilita a biometria, quando a ação é confirmada, então o refresh token é removido do cofre seguro do aparelho; verificado por teste de integração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| P-1 | premissa | Depende do mecanismo de access/refresh token de `.specs/044-sign-in-api.md` (D-4/D-5) já estar implementado | — | `sign-in-api` precisa estar pronta antes desta spec |
| D-1 | decisão | Refresh token armazenado no cofre seguro do sistema operacional (Keychain iOS / Keystore Android), nunca em armazenamento não criptografado — pedido explícito do responsável do produto (segurança é prioridade) | autor da spec | Nenhuma — decisão de segurança fechada |
| D-2 | decisão proposta, não bloqueante | Local do toggle de habilitar/desabilitar biometria (tela de login, abertura, ou perfil) | produto/design | Confirmar antes de desenhar a tela |
| D-3 | decisão proposta, não bloqueante | Comportamento exato quando o aparelho tem biometria mas ela está temporariamente indisponível (ex.: rosto coberto) — repetir prompt, quantas vezes, antes de cair para login | produto/design | Confirmar antes de implementar |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Nenhum contrato novo de API; consome o endpoint de refresh de `sign-in-api` |
| Dados | Refresh token replicado no cofre seguro local do aparelho (já existia no servidor via `sign-in-api`) |
| UI/UX e acessibilidade | Novo passo na abertura quando biometria habilitada; precisa de fallback claro para quem não usa/não tem biometria |
| Segurança | Uso do cofre seguro do sistema operacional é central nesta spec (D-1); nenhum dado biométrico chega à API ou ao domínio do app |
| Observabilidade | Falhas de refresh por token revogado já são cobertas pela observabilidade de `sign-in-api`; nenhuma métrica nova específica desta spec |

## 10. Plano de testes

- Widget/unitário: lógica de decidir "mostrar prompt de biometria vs ir direto para login", com biometria mockada em cada estado (disponível, indisponível, recusada).
- Integração: AC-1, AC-3, AC-5, AC-6 (cofre seguro e API mockados).
- Manual no frame 390×844: AC-2, AC-4 em dispositivo/simulador real com biometria configurada e sem configurar.
- Casos de borda: app aberto sem nunca ter logado (sem refresh token, biometria não se aplica); refresh token expirado mas não revogado (deve comportar-se como AC-5, já que o refresh simplesmente falha).

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| Refresh token em armazenamento inseguro, acessível por outro app ou backup | baixa | alto | D-1 — cofre seguro do sistema operacional, nunca `SharedPreferences` |
| Pessoa trocar de aparelho/restaurar backup e a biometria "herdar" acesso indevido | baixa | alto | Refresh token no cofre seguro normalmente não migra em restauração de backup não criptografado; comportamento exato depende da plataforma, fora do controle desta spec |

- Rollback: funcionalidade aditiva e isolada; desabilitar é só não oferecer a opção, sem afetar login normal.
- Critério para abortar: se `sign-in-api` (P-1) não estiver implementada com refresh token, não implementar esta spec.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| Local do toggle de habilitar/desabilitar (D-2) | não | produto/design | antes de desenhar a tela |
| Comportamento de retry quando a biometria falha temporariamente (D-3) | não | produto/design | antes de implementar |
| `BUSINESS/00-abertura.md` e `01-login.md` não mencionam biometria — precisam de atualização formal de produto | não | produto | — |

## 13. Resultado

Pronto quando habilitar, usar e desabilitar a biometria funcionarem de ponta a ponta no app, incluindo os casos de refresh token revogado e biometria indisponível, com AC-1 a AC-6 passando em teste automatizado.

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
