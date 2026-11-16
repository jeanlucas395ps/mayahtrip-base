# Desenvolvimento

Padrões para quando o código existir nos quatro repositórios. Este repositório de documentação não tem app, API nem `package.json`.

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
  infrastructure/   # Postgres, MongoDB, Redis, Kafka, HTTP de terceiros, storage, e-mail
  interface/        # controllers, DTOs, guards
```

Direção: `interface` → `application` → `domain`. `infrastructure` implementa portas e aponta para dentro. `domain` não importa Nest, driver nem HTTP.

Módulos de domínio: identidade, viagem, roteiro, gasto, comunidade, notificação e maya. Cada um entra quando a funcionalidade correspondente for construída.

Regras:

- Validação na borda (DTO + pipe). Autorização no guard e no caso de uso, pelos papéis de `BUSINESS.md` §4.3 (dono, viajante supremo, experiente, assistente júnior).
- Quem altera papéis e remove pessoas é o dono da viagem. Convidar e remover, para supremo e experiente, permanece fechado enquanto `BUSINESS/26` marcar a permissão como `A DEFINIR`.
- Erros estáveis para o app, sem stack trace e sem dado interno. Filtro único de exceção.
- Lista paginada. Sem N+1.
- Segredo só em variável de ambiente. `.env` não entra no Git.
- bcrypt para senha. Trocar a senha invalida as outras sessões (`BUSINESS.md` §4.7).
- Maya: o caso de uso devolve texto e atalhos no idioma da interface ativo (`pt-BR`, `pt-PT`, `en` ou `es`). Não há caso de uso “Maya grava roteiro”.

Testes com Vitest: domínio e casos de uso sem I/O; adaptadores com banco ou contrato; HTTP do módulo com o testing module do Nest. Nome: `deve <comportamento> quando <condição>`.

## 4. Painel Angular

- Angular 22, signals para estado de tela, NgRx só para estado que atravessa várias telas.
- Textos do painel nos quatro idiomas da interface: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es`.
- O painel consome a API. Não acessa Postgres, MongoDB nem Asaas direto do browser.
- Playwright no repositório do painel para fluxo de operação; o repositório `mayahtrip-e2e` cobre a jornada do viajante.
- Escopo de telas do painel: `A DEFINIR`. Até essa definição, o painel não ganha tela.

## 5. TypeScript (API e painel)

- `strict: true`.
- `type` para união e alias; `interface` para contrato extensível.
- Prefira união de literais a `enum`.
- `unknown` tratado no ponto em que entra. Sem `any` para calar erro.
- Sem `@ts-ignore`. `@ts-expect-error` só com a frase que explica o caso.

## 6. Testes

| Camada | Onde | O quê |
| --- | --- | --- |
| Unitário | App, API, painel | Domínio, ViewModel, caso de uso, sem rede |
| Integração | API | Repositório, fila, contrato HTTP interno |
| E2E de UI do painel | Painel | Playwright |
| E2E da jornada | `mayahtrip-e2e` | Fluxos do viajante |

Ainda não há script gravado. Quando o primeiro repositório tiver runner, o comando real entra em `QA.md`. Até lá, não invente `npm run test`.

## 7. Acessibilidade e layout

- App: frame de referência 390 × 844, margem lateral 20 px, como em `DESIGN.md`. Verificar também tela estreita e o tamanho de fonte do sistema — o comportamento com fonte grande ainda é `A DEFINIR`.
- Painel: WCAG 2.2 AA, teclado, foco visível, contraste 4.5:1, breakpoints 360, 768 e 1280.
- Reduzir movimento zera a duração das animações do app (~0 ms).

## 8. Segurança

- Entrada validada na borda.
- SQL parametrizado, via query builder ou ORM. Sem concatenar SQL.
- Autorização por usuário e pelo papel na viagem, em toda operação que lê ou grava dado de outra pessoa.
- Convidado (`BUSINESS/04`) só acessa o que aquela spec permitir.
- Bloqueio mútuo: conteúdo de quem foi bloqueado não volta em feed, comentário ou curtida.
- Log sem senha, token, documento de viagem ou corpo de e-mail.
- Webhook de cobrança (Asaas) valida assinatura.

## 9. Git

Commit só pelo comando `/commit`, e só quando for pedido. Cursor lê `.cursor/commands/commit.md` e entra como co-autor Cursor. Claude lê `.claude/commands/commit.md` e entra como co-autor Claude. O restante do procedimento é o mesmo.

- Conventional Commits: `<tipo>(<escopo>): <assunto>`.
- Tipos: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`, `ci`, `perf`, `style`, `revert`.
- Mudança incompatível: `!` no cabeçalho e rodapé `BREAKING CHANGE:`.
- Sem `--no-verify`, sem force push.
- Não commitar segredo, `.env`, `console.log` de depuração nem artefato de build.

## 10. Observabilidade no código

Desde o primeiro endpoint e a primeira tela que chama a API:

- Correlation id propagado do app à API e aos adaptadores externos.
- Log estruturado, sem PII.
- Métrica do próprio processo exposta para o Prometheus (latência, erro, saturação). O desenho dos dashboards está em `OBSERVABILITY.md`.

Não adicione agente, tracer ou SaaS que não esteja em `ARCHITECTURE.md`.
