# Agentes

Como um agente de código trabalha neste repositório e, depois, nos quatro repositórios de código. Leia antes de planejar ou alterar arquivo.

## 1. Ordem de leitura

1. `RULES.md` — plano, ADR, relatório, o que é proibido.
2. `BUSINESS/BUSINESS.md` — propósito e regras globais. A tela específica está no arquivo numerado.
3. `ARCHITECTURE.md` — stack e fronteiras entre os sistemas.
4. O documento do tipo de tarefa: `DEVELOPMENT.md`, `DESIGN.md`, `DESIGN_SYSTEM.md`, `QA.md` ou `OBSERVABILITY.md`.

## 2. Onde está o código

| Peça | Onde |
| --- | --- |
| Docs e skills | este repositório, pasta `.docs` e `.agents/skills` |
| App Flutter | https://github.com/jeanlucas395ps/mayahtrip-app.git |
| API NestJS | https://github.com/jeanlucas395ps/mayahtrip-backend.git |
| Painel Angular | https://github.com/jeanlucas395ps/mayahtrip-panel.git |
| E2E | https://github.com/jeanlucas395ps/mayahtrip-e2e.git |

Não assuma biblioteca instalada. `ARCHITECTURE.md` lista a stack alvo. Se o repositório de código ainda não tiver a dependência, não instale por conta própria: registre no plano e pergunte.

## 3. Regras invioláveis

- Não implemente item marcado `A DEFINIR`. Pergunte.
- A Maya responde e abre telas. Ela não grava viagem, gasto nem roteiro.
- Não invente comando de terminal. Os comandos válidos estão em `QA.md`; hoje, neste repositório, quase não há.
- Não commita segredo, `.env` ou credencial.
- Não commita nem faz push sem pedido explícito. Quando houver pedido, o único caminho é `/commit`. No Cursor, `.cursor/commands/commit.md`, com co-autor Cursor. No Claude, `.claude/commands/commit.md`, com co-autor Claude.
- Não use `--no-verify` nem force push.
- App não chama fornecedor externo. Painel não chama banco nem Asaas no browser.
- Não crie cor, ícone colorido fora do padrão, emoji ou string solta na UI. Ver `DESIGN_SYSTEM.md`.
- A interface tem só quatro idiomas: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es`. Não crie outro locale.

## 4. Skills que existem aqui

Ficam em `.agents/skills` e estão travadas em `skills-lock.json`. Se a skill ideal não existir, use a mais próxima e diga qual usou. As skills deste repositório são as da tabela abaixo.

| Tarefa | Skill |
| --- | --- |
| Estrutura do app Flutter | `flutter-apply-architecture-best-practices` |
| Textos do app | `flutter-internationalization` |
| Módulo NestJS, auth, erro, teste de API | `nestjs-best-practices` |
| Teste antes da implementação | `tdd` |
| Tela nova ou redesenho | `frontend-design`, depois `impeccable` |
| Polimento de interação | `emil-design-eng`, `animate` |
| Revisar acessibilidade do painel ou do protótipo web | `web-design-guidelines` |
| Fluxo de browser | `playwright` |
| Apertar uma proposta antes de construir | `grill-me` |
| Corrigir gosto visual com aprovação | `learn-taste` |
| Achar ou criar skill | `find-skills`, `skill-creator` |

Não há skill de Angular, Postgres, Kafka nem observabilidade neste repositório. Nesses temas, siga `DEVELOPMENT.md`, `ARCHITECTURE.md` e `OBSERVABILITY.md`.

## 5. Fluxo mínimo

1. Leia o arquivo de negócio da funcionalidade e a fronteira em `ARCHITECTURE.md`.
2. Se a tarefa for não trivial, escreva o plano em `./plan/<slug>-plan.md` (veja `RULES.md`). Tarefa de documentação pode ir sem plano; diga isso no relatório.
3. Implemente uma fatia vertical no repositório certo (app, API ou painel). Não misture os quatro num commit só para “adiantar”.
4. Rode o que `QA.md` já listar para aquele repositório.
5. Se a decisão cruza fronteira (banco, auth, fila, fornecedor novo), grave ADR em `./adrs/`.
6. Se a pessoa pediu commit, execute `/commit` do agente em uso (Cursor: `.cursor/commands/commit.md`; Claude: `.claude/commands/commit.md`). Sem esse pedido, não commite.
7. Entregue o relatório de `RULES.md`.

## 6. Documento e código

Quando os repositórios de código existirem de verdade, o código é o que roda e o documento é o que deveria rodar. Não ignore a diferença: registre no relatório e atualize o documento no mesmo cambio.
