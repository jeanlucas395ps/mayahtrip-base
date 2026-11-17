# 0001 — Dados e mensageria

- Status: aceito
- Data: 2026-11-16

## Contexto

`ARCHITECTURE.md` §5 deixava em aberto o que fica em Postgres, MongoDB, Redis e Kafka, e pedia ADR antes de escolher Kafka para notificação. A especificação de dados proposta foi cruzada com `BUSINESS/`, `PANEL/` e as decisões já aceitas de identidade. O responsável do produto fechou, em 16 nov 2026, o que entra agora e o que continua `A DEFINIR`.

## Decisão

1. PostgreSQL é a fonte da verdade. MongoDB fica fora da stack.
2. O ORM é TypeORM, com migration manual e sem `synchronize`, como em `mayahtrip-backend/adrs/0001-identidade-tokens-persistencia.md`.
3. Redis, neste momento, só guarda a revogação de access token. Cache e limite de taxa entram na feature que precisar. Número, janela e chave do limite continuam `A DEFINIR`.
4. Kafka transporta geração de roteiro, notificação e ingestão. O estado do job permanece no Postgres. Nome de tópico e contrato do evento continuam `A DEFINIR`.
5. A expiração de assinatura é um job diário. `PANEL/17` dispara a mesma checagem fora de hora. Não é fila Kafka.
6. A ingestão é uma trilha paralela que enriquece o catálogo servido pela API. Staging não aparece no app. Se a busca do app lê esse catálogo ou chama o Google Places ao vivo continua `A DEFINIR`.
7. Papéis de administrador entram para granularidade futura. A matriz de permissão é `A DEFINIR`. Até lá, administrador ativo executa todas as funções de `PANEL/`.
8. O detalhe do modelo está em `.docs/TECH/TECH.md`. Item marcado `A DEFINIR` nesse arquivo não vira tabela nem código.

## Alternativas consideradas

- Manter MongoDB como opção para feed ou conteúdo flexível. Descartado: o produto cabe em Postgres, e o responsável fechou a saída do Mongo agora.
- Tratar expiração de assinatura como mais uma fila Kafka. Descartado: a checagem é diária, com disparo manual, e não precisa de consumidor contínuo.
- Publicar notificação direto no Kafka, sem outbox. Descartado: o evento precisa sobreviver ao commit do negócio. A outbox fica no Postgres.
- Definir os sete papéis do painel com permissões inventadas. Descartado: a matriz não foi decidida. Um papel efetivo preserva o painel atual.

## Consequências

**Positivas**: o dado durável tem um destino só. A fila do painel lê estado no Postgres, então pendente, falho e recolocação não dependem de inspecionar o tópico. A ingestão pode avançar sem bloquear a identidade e a viagem.

**Negativas**: Kafka passa a ser dependência dos três fluxos assim que eles existirem. Dois armazenamentos continuam no caminho de sessão (Postgres e Redis), como na ADR de identidade. A busca de lugar fica com dois desenhos possíveis até a frase de catálogo versus chamada ao vivo ser fechada.

## Referências

- `.docs/TECH/TECH.md`
- `.docs/ARCHITECTURE.md` §5 e §6
- `.docs/PANEL/16-filas.md`
- `.docs/PANEL/17-expiracao-de-assinaturas.md`
- `mayahtrip-backend/adrs/0001-identidade-tokens-persistencia.md`
