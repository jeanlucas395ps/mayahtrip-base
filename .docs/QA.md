# QA

Gates antes de considerar uma mudança pronta. Os comandos abaixo são os que **existem**. Não invente script, porta nem workspace.

## 1. Este repositório

`mayahtrip` é documentação e skills. Não há `package.json`, app Flutter, API nem painel aqui.

| Objetivo | Comando | Observação |
| --- | --- | --- |
| Verificar links e marcadores `A DEFINIR` | leitura | Não há runner de docs |
| Não vazar segredo | revisão do diff | `.env`, token, chave de API |

## 2. Repositórios de código

Ainda não há scripts versionados para copiar aqui. Quando `mayahtrip-app`, `mayahtrip-backend`, `mayahtrip-panel` ou `mayahtrip-e2e` ganharem um comando real, ele entra nesta tabela com o verbo exato do `package.json`, `Makefile` ou `melos`. Até lá:

| Repo | Gate esperado (ainda sem script) |
| --- | --- |
| App | Analisador Dart, testes do ViewModel/repositório, build do flavor que o repo definir |
| API | Vitest, build Nest, lint do TypeScript |
| Painel | Vitest, build Angular, Playwright das telas que existirem |
| E2E | Playwright dos fluxos críticos |

Critério assim que o script existir: o comando do repositório tocado termina sem erro. Teste novo cobre o comportamento alterado. Bug corrigido tem teste que falha sem a correção. Sem `sleep` para “esperar a API”.

## 3. Checklist manual

Use só as linhas do sistema que a mudança tocou.

### App

- [ ] Fluxo conferido contra o arquivo `BUSINESS/` da tela, inclusive estados vazio, erro e carregando
- [ ] Visual conferido contra `DESIGN.md` (cor, tipo, raio, movimento)
- [ ] Sem emoji, sem cor nova, sem string fora do `gen_l10n`
- [ ] Textos da tela existem em `pt-BR`, `pt-PT`, `en` e `es`
- [ ] Toque com área no padrão do design
- [ ] Reduzir movimento desliga a animação
- [ ] Modo claro e noturno, quando a tela não for exceção (feed, abertura, login e foto não mudam)
- [ ] Papel sem permissão não vê ação de escrita
- [ ] Convidado não atravessa o muro de `BUSINESS/04`

### API

- [ ] Entrada inválida rejeitada na borda
- [ ] Quem não é dono nem tem o papel não lê nem grava o recurso
- [ ] Erro estável, sem stack e sem dado interno
- [ ] Lista paginada
- [ ] Log com correlation id e sem senha, token ou documento
- [ ] Maya não persiste viagem, roteiro ou gasto
- [ ] Mensagem ao usuário, e-mail e resposta da Maya estão no idioma da interface (`pt-BR`, `pt-PT`, `en` ou `es`)

### Painel

- [ ] 360, 768 e 1280
- [ ] Teclado e foco visível
- [ ] Contraste AA
- [ ] Loading, erro e vazio
- [ ] Nenhuma chamada direta a Asaas, Google ou banco a partir do browser
- [ ] Textos do painel existem em `pt-BR`, `pt-PT`, `en` e `es`

### Dados e integração

- [ ] Credencial só no servidor
- [ ] Falha do fornecedor não derruba o processo inteiro
- [ ] Retentativa não duplica gasto, convite ou cobrança
- [ ] Dado sensível fora do log

### Documentação

- [ ] `BUSINESS/` ou o doc técnico atualizado no mesmo cambio de comportamento
- [ ] Comando novo escrito em `QA.md` só depois de existir de verdade
- [ ] Decisão de stack ou de fronteira registrada em ADR, se houve alternativa

## 4. Fluxos críticos (quando o e2e existir)

Ainda sem suíte. A ordem de prioridade, tirada do negócio:

1. Abertura com sessão ativa cai no Início; sem sessão cai no login.
2. Entrar com e-mail, criar conta, confirmar código, recuperar senha.
3. Entrar com Google.
4. Explorar como convidado e ser barrado ao tentar ação de conta.
5. Criar viagem em 4 passos e vê-la na carteira com o selo certo (rascunho, em N dias, acontecendo, concluída).
6. Convidar por e-mail, aceitar e recusar.
7. Lançar gasto dividido e desfazer.
8. Inserir lugar no roteiro a partir do feed ou da página do lugar.
9. Trocar senha derruba as outras sessões.

## 5. Pronto quando

- [ ] O arquivo de negócio da funcionalidade está coberto, ou a exceção está escrita
- [ ] Gates do repositório tocado estão verdes (ou a tarefa é só documentação e não há gate)
- [ ] Nenhum item `A DEFINIR` foi “resolvido” no código
- [ ] Documentação atualizada
- [ ] ADR se a mudança cruzar fronteira de `ARCHITECTURE.md`
- [ ] Relatório de `RULES.md`
