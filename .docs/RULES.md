# Regras de trabalho

Regras para qualquer mudança neste repositório e, no mesmo espírito, nos repositórios de código do MayahTrip.

## 1. Antes de construir: plano

Para funcionalidade, refactor ou mudança de arquitetura, crie `./plan/<slug>-plan.md` com:

- Contexto e problema, apontando o arquivo em `BUSINESS/` quando houver tela
- Objetivo e critérios de aceite verificáveis
- Escopo e fora de escopo
- Abordagem e alternativas descartadas
- Impacto em arquitetura, dados, UI e segurança
- Como testar
- Riscos e como desfazer

Tarefa trivial (texto de documentação, correção local sem mudança de comportamento) dispensa plano. Diga isso no relatório.

Se o plano depender de um item `A DEFINIR`, pare e pergunte. Não escolha no lugar de quem decide o produto.

## 2. Decisão de arquitetura: ADR

Crie `./adrs/NNNN-titulo-curto.md` (quatro dígitos, em sequência) quando a mudança:

- incluir ou tirar dependência relevante;
- mudar o contrato entre app, API e painel;
- definir o que vai para Postgres, Redis ou Kafka;
- escolher auth, observabilidade ou integração que `ARCHITECTURE.md` ainda marca como aberta;
- tiver alternativa que alguém vai perguntar de novo daqui a um mês.

```markdown
# NNNN — Título

- Status: proposto | aceito | substituído por NNNN
- Data: AAAA-MM-DD

## Contexto

## Decisão

## Alternativas consideradas

## Consequências (positivas e negativas)

## Referências
```

## 3. Relatório ao final

Entregue nesta ordem:

1. **Decisões** — ADR criado ou “não se aplica”.
2. **QA** — o que foi conferido, contra `QA.md`.
3. **Arquivos** — caminhos.
4. **Bibliotecas** — nome, versão e motivo, ou “nenhuma”.
5. **Racional** — por que assim, o que ficou de fora, o que continua `A DEFINIR`.
6. **Git** — se houve pedido de commit, o resultado de `/commit` (branch, hash, mensagem, push). Sem pedido, “não executado”.

## 4. Git

O único procedimento de commit é `/commit`. Cursor e Claude usam o mesmo procedimento, cada um no seu arquivo:

- Cursor: `.cursor/commands/commit.md`
- Claude: `.claude/commands/commit.md`

Agente nenhum, nos dois ambientes, commita por outro caminho. O procedimento é o mesmo. A única diferença é o co-autor: Cursor em `.cursor/commands/commit.md`, Claude em `.claude/commands/commit.md`.

- Commit apenas quando for pedido. O pedido dispara `/commit` no agente que estiver trabalhando.
- A mensagem sai desse comando: Conventional Commits.
- Sem `--no-verify`. Sem `--force` e sem `--force-with-lease`.
- Sem segredo no diff. Se o hook recusar, corrija a causa e faça um commit novo.
- `/commit` inclui o push. Sem remoto, o commit fica local e o relatório diz que o push não rodou.

## 5. Gerais

- Não invente comando, porta, variável de ambiente nem fornecedor. Use `QA.md` e `ARCHITECTURE.md`.
- Não deixe pendência só dentro do código. Ela volta no relatório ou vira pergunta.
- Mudou comportamento: atualize o documento no mesmo cambio.
- Prefira mudança pequena, que dê para reverter.
- Se o documento mentir em relação ao código, corrija o documento e registre.
