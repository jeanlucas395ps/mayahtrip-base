# Desenvolvimento

Padrões para quando o código existir nos repositórios de código. Este repositório de documentação não tem app, API nem `package.json`.

A fonte de comportamento é `BUSINESS/`. A fonte visual é `DESIGN.md`. A fonte de stack é `ARCHITECTURE.md`. Se um padrão daqui contradisser um desses três, o específico vence e este arquivo deve ser corrigido.

## 1. Princípios

- Resolva o problema da tela atual. O módulo nasce da funcionalidade em `BUSINESS/`.
- Duplicar duas vezes é aceitável. Na terceira, extraia.
- Nomes de domínio saem do glossário de `BUSINESS.md` (viagem, parada, deslocamento, rascunho, carteira, acerto, Maya).
- Regra de negócio mora no domínio da API. Controller, widget e componente de painel só traduzem entrada e saída.
- Teste o comportamento. Um bug corrigido ganha um teste que falharia antes do conserto.
- Texto de interface nunca fica fixo no widget: `gen_l10n` no app, i18n no painel, i18next nas mensagens da API voltadas ao usuário. Os quatro idiomas são Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en` e Español `es`. Toda string de interface existe nos quatro.
- `A DEFINIR` no negócio não vira comportamento inventado.

## 2. App Flutter

Siga a skill `flutter-apply-architecture-best-practices`.

Camadas:

- **UI** — widgets sem regra de negócio. Views finas, ViewModels (`ChangeNotifier` ou equivalente já adotado no repo) com estado imutável.
- **Data** — services falam com a API e com o armazenamento local; repositories devolvem modelos de domínio.
- **Domain** — só quando a regra é complexa ou usada por mais de um ViewModel (por exemplo, status da viagem e conversão de moeda para exibição). CRUD simples não ganha use case.

Organização: UI por funcionalidade (`ui/features/<feature>`), dados e domínio por tipo (`data/`, `domain/`), como na skill.

Regras do produto no cliente:

- Tokens, raios, durações e componentes vêm de `DESIGN.md`. Não crie cor nova na tela.
- Sem emoji na interface.
- Alvo de toque no padrão do design (44 px ou mais; mínimo documentado 36 px).
- Respeitar reduzir movimento.
- Documentos da viagem têm caminho offline. O restante do app pode exigir rede; não prometa offline além do que `BUSINESS/25` pede.
- O app não chama fornecedor externo (OpenAI, Google, Asaas, SMTP).

Idiomas: `flutter-internationalization`, com `pt-BR`, `pt-PT`, `en` e `es`. O formato numérico segue `BUSINESS/35`.

## 3. API NestJS

Siga a skill `nestjs-best-practices` e a decisão de DDD / clean architecture.

Cada módulo de domínio é um feature module do Nest e contém quatro pastas:

```text
src/modules/<dominio>/
  domain/           # entidades, objetos de valor, serviços de domínio, portas
  application/      # casos de uso
  infrastructure/   # Postgres, Redis, Kafka, HTTP de terceiros, storage, e-mail
  interface/        # controllers, DTOs, guards
```

Direção: `interface` → `application` → `domain`. `infrastructure` implementa portas e aponta para dentro. `domain` não importa Nest, driver nem HTTP.

Módulos de domínio: identidade, viagem, roteiro, gasto, comunidade, notificação e maya. Cada um entra quando a funcionalidade correspondente for construída.

Regras:

- Validação na borda (DTO + pipe). Autorização no guard e no caso de uso, pelos papéis de `BUSINESS.md` §4.3 (dono, viajante supremo, experiente, assistente júnior).
- Toda rota de produto fica em `/v1`. A versão atual é `1`. Rota nova sem versão própria entra em `/v1`. `GET /metrics`, `GET /docs` e `GET /readme` ficam fora dessa versão.
- Quem altera papéis e remove pessoas é o dono da viagem. Convidar e remover, para supremo e experiente, permanece fechado enquanto `BUSINESS/26` marcar a permissão como `A DEFINIR`.
- Erros estáveis para o app, sem stack trace e sem dado interno. Filtro único de exceção.
- Lista paginada. Sem N+1.
- Segredo só em variável de ambiente. `.env` não entra no Git.
- Argon2id para senha (`ARCHITECTURE.md` §3 — fonte de stack). Trocar a senha invalida as outras sessões (`BUSINESS.md` §4.7).
- Estrutura do banco (tabela, índice, coluna) é criada e versionada por migrations TypeORM, nunca por sincronização automática (`synchronize: true`). Toda mudança de schema é um arquivo de migration no controle de versão, mesmo em desenvolvimento local. O modelo está em `TECH/TECH.md`. O ORM está em `mayahtrip-backend/adrs/0001-identidade-tokens-persistencia.md`.
- Maya: o caso de uso devolve texto e atalhos no idioma da interface ativo (`pt-BR`, `pt-PT`, `en` ou `es`). Não há caso de uso “Maya grava roteiro”.

Testes com Vitest: domínio e casos de uso sem I/O; adaptadores com banco ou contrato; HTTP do módulo com o testing module do Nest. Nome: `deve <comportamento> quando <condição>`.

Swagger e ReadMe (ADR `mayahtrip-backend/adrs/0002-documentacao-publica.md`): `GET /docs` e `GET /readme` só existem quando `NODE_ENV` é `development` (local) ou `test`. Em `production` essas URLs não são montadas. As duas listam as rotas HTTP registradas. A publicação no ReadMe (`POST https://api.readme.com/v2/branches/stable/apis`) usa `README_API_KEY`, o nome já documentado pelo ReadMe, e só roda nesses dois ambientes. Chave vazia não publica e não impede a API de subir. Falha do ReadMe não derruba o processo.

## 4. Web de planos

O comportamento está em `WEB/`. O site chama a API. Não chama a Asaas no browser. Não há cobrança no app.

## 5. Painel Angular

- Angular 22, signals para estado de tela, NgRx só para estado que atravessa várias telas.
- Textos do painel nos quatro idiomas da interface: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es`.
- O painel consome a API. Não acessa Postgres, Redis, Kafka, Google Cloud Storage nem Asaas direto do browser.
- Playwright no repositório do painel para fluxo de operação; o repositório `mayahtrip-e2e` cobre a jornada do viajante.
- Telas do painel já especificadas: `PANEL/`. A operação de ingestão, catálogo e papéis está em `TECH/TECH.md`. Não crie tela fora desses dois lugares.

## 6. TypeScript (API e painel)

- `strict: true`.
- `type` para união e alias; `interface` para contrato extensível.
- Prefira união de literais a `enum`.
- `unknown` tratado no ponto em que entra. Sem `any` para calar erro.
- Sem `@ts-ignore`. `@ts-expect-error` só com a frase que explica o caso.

## 7. Testes

| Camada | Onde | O quê |
| --- | --- | --- |
| Unitário | App, API, painel | Domínio, ViewModel, caso de uso, sem rede |
| Integração | API | Repositório, fila, contrato HTTP interno |
| E2E de UI do painel | Painel | Playwright |
| E2E da jornada | `mayahtrip-e2e` | Fluxos do viajante |

Ainda não há script gravado. Quando o primeiro repositório tiver runner, o comando real entra em `QA.md`. Até lá, não invente `npm run test`.

## 8. Acessibilidade e layout

- App: frame de referência 390 × 844, margem lateral 20 px, como em `DESIGN.md`. Verificar também tela estreita e o tamanho de fonte do sistema — o comportamento com fonte grande ainda é `A DEFINIR`.
- Painel: WCAG 2.2 AA, teclado, foco visível, contraste 4.5:1, breakpoints 360, 768 e 1280.
- Reduzir movimento zera a duração das animações do app (~0 ms).

## 9. Segurança

- Entrada validada na borda.
- SQL parametrizado, via query builder ou ORM. Sem concatenar SQL.
- Autorização por usuário e pelo papel na viagem, em toda operação que lê ou grava dado de outra pessoa.
- Convidado (`BUSINESS/04`) só acessa o que aquela spec permitir.
- Bloqueio mútuo: conteúdo de quem foi bloqueado não volta em feed, comentário ou curtida.
- Log sem senha, token, documento de viagem ou corpo de e-mail.
- Webhook de cobrança (Asaas) valida assinatura.

## 10. Git

Commit só pelo comando `/commit`, e só quando for pedido. Cursor lê `.cursor/commands/commit.md` e entra como co-autor Cursor. Claude lê `.claude/commands/commit.md` e entra como co-autor Claude. O restante do procedimento é o mesmo.

- Conventional Commits: `<tipo>(<escopo>): <assunto>`.
- Tipos: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`, `perf`, `style`, `revert`.
- Mudança incompatível: `!` no cabeçalho e rodapé `BREAKING CHANGE:`.
- Sem `--no-verify`, sem force push.
- Não commitar segredo, `.env`, `console.log` de depuração nem artefato de build.

## 11. Observabilidade no código

Desde o primeiro endpoint e a primeira tela que chama a API:

- Correlation id propagado do app à API e aos adaptadores externos.
- Log estruturado, sem PII.
- Métrica do próprio processo exposta para o Prometheus (latência, erro, saturação). O desenho dos dashboards está em `OBSERVABILITY.md`.

Não adicione agente, tracer ou SaaS que não esteja em `ARCHITECTURE.md`.

## 12. Infra local

Na pasta que contém os clones, fora de cada repositório:

```bash
./up.sh tudo
./up.sh infra
./up.sh dados
./up.sh borda
./up.sh observabilidade
./up.sh api
./up.sh painel
./up.sh web
./up.sh app
./up.sh e2e
./down.sh tudo
```

`infra` sobe dados, Nginx e observabilidade. `dados` é Postgres, Redis e Kafka. `./up.sh app` sobe o Flutter no macOS desta máquina com `flutter run -d macos`, em segundo plano. O log fica em `.run/app.log`. `./down.sh app` encerra esse processo. O app no macOS não tem volume. API, painel, web e e2e só sobem se aquele repositório já tiver `compose.yaml` ou `docker-compose.yml`. Sem esse arquivo, o script avisa e para. Não há comando inventado de `npm`.

`./down.sh <parte> volumes` apaga os volumes daquela parte. Sem a palavra `volumes`, os dados locais ficam.

Portas publicadas só em `127.0.0.1`: Postgres `5432`, Redis `6379`, Kafka `9092`, Nginx `80`, Prometheus `9090`, Loki `3100`, Grafana `3000`, node-exporter `9100`, cAdvisor `8080`, Alloy `12345`. A `3000` é a do Grafana, não a da API. A API e o painel ainda não têm porta; o Nginx responde em `/` e o log de acesso sai na saída padrão, que o Alloy envia ao Loki.

Senha local fica em `.env`, copiado de `.env.example` na primeira subida. Não é segredo de produção.
