# Arquitetura

## 1. Visão

O MayahTrip é uma plataforma para **planejar e viver viagens em um só lugar**. O comportamento de produto está em `BUSINESS/`. Este documento fixa **em quantos sistemas** isso se divide e **com quais ferramentas**.

Cinco repositórios de código:

| Repositório | URL | Responsabilidade |
| --- | --- | --- |
| App | https://github.com/jeanlucas395ps/mayahtrip-app.git | Experiência do viajante (Flutter). Telas `00`–`35`. |
| API | https://github.com/jeanlucas395ps/mayahtrip-backend.git | Regras de negócio, auth, persistência e integrações (NestJS). |
| Painel | https://github.com/jeanlucas395ps/mayahtrip-panel.git | Operação interna (Angular). Funções em `PANEL/`. |
| E2E | https://github.com/jeanlucas395ps/mayahtrip-e2e.git | Fluxos críticos de ponta a ponta (Playwright). |
| Web | https://github.com/jeanlucas395ps/mayahtrip-web.git | Assinatura e gestão do plano do viajante. Funções em `WEB/`. |

Este repositório (`mayahtrip-base`) contém a documentação. Não contém o app, a API nem o painel.

A Maya é um assistente de **dúvidas e atalhos**. Ela não grava viagem, gasto ou roteiro. Quem altera dados é o usuário, pelas telas. Ver `BUSINESS/27-maya.md`.

## 2. Domínios

- **Identidade.** Entrada com Google ou e-mail e senha, sessão e modo convidado.
- **Viagem.** Destinos, dias, pessoas, papéis (dono, viajante supremo, viajante experiente, assistente júnior) e status (rascunho, próxima, acontecendo agora, concluída).
- **Roteiro.** Paradas, deslocamentos, lista e mapa. Viagem com mais de 14 dias não gera roteiro automático.
- **Grupo na viagem.** Gastos divididos, mala, lista de compras e documentos.
- **Comunidade.** Feed, página do lugar, avaliações, comentários, curtidas, seguir, silenciar, bloquear e denunciar.
- **Maya.** Responde dúvidas e oferece atalhos. Não grava viagem, gasto nem roteiro.
- **Notificação.** Cada aviso existe na central do app e em push.
- **Ingestão.** Trilha paralela que enriquece o catálogo servido pela API. Conteúdo em preparação não aparece no app. O modelo está em `TECH/TECH.md`.

O que está fora do produto está em `BUSINESS.md` §9.

## 3. Stack

Versões abaixo são as escolhidas para o projeto. Nada disso está instalado neste repositório de documentação.

### App (Flutter)

- Flutter
- Flutter Internationalization (`gen_l10n`)
- Idiomas da interface, os únicos: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es`

### API (NestJS)

- Node.js 26.13.1
- NestJS 12.4.1
- TypeScript
- DDD e clean architecture
- Vitest
- Argon2id
- i18next, com os mesmos quatro idiomas da interface (`pt-BR`, `pt-PT`, `en`, `es`)
- Versão no caminho. A versão atual é `v1` (`/v1/...`). Rota de produto nova entra nessa versão. `GET /metrics` fica fora dela.

### Web de planos

Site em que o viajante assina e gerencia o PRO (`WEB/`). Fala só com a API. Os textos usam os quatro idiomas da interface.

Framework: `A DEFINIR`.

### Painel (Angular)

- Angular 22
- TypeScript
- Vitest
- NgRx
- Signals
- i18n, com os mesmos quatro idiomas da interface (`pt-BR`, `pt-PT`, `en`, `es`)
- Playwright

### Infraestrutura

- Docker e Docker Compose
- Postgres
- Redis
- Nginx
- Kafka

O Compose local não fica dentro de um repositório. Fica na pasta que contém os clones: `compose/docker-compose.yml`, com `up.sh` e `down.sh` ao lado. O arquivo não cria tabela nem tópico de produto. MongoDB não faz parte da stack.

### Observabilidade

- Prometheus
- Grafana
- Loki
- Alloy
- node-exporter
- cAdvisor

Detalhe de uso: `OBSERVABILITY.md`.

### Pipeline

- GitHub Actions
- GitHub Variables / environments

Os workflows ainda não existem. Não invente nomes de jobs.

### Integrações externas

O app não chama esses serviços. Quem chama é a API.

| Serviço | Função |
| --- | --- |
| Google OAuth | Entrar com Google. A API valida o token. |
| SMTP Hostinger (`smtp.hostinger.com`) | Código de verificação, recuperação de senha e convite por e-mail, no idioma da interface (`BUSINESS/35`) |
| OpenAI API | Respostas da Maya no idioma da interface ativo (`pt-BR`, `pt-PT`, `en` ou `es`). Modelo, contexto e limite Free/PRO: `A DEFINIR` (`BUSINESS/27`) |
| Google Places (find place, nearby, text search, details, photos) | Busca, ficha e fotos dos lugares |
| Google Directions, Distance Matrix e Geocoding | Rota, tempo e distância entre paradas |
| Google Maps JavaScript e Static Maps | Mapa incorporado e imagem estática de mapa |
| Google clima | Clima na capa da viagem e sugestão de mala |
| Frankfurter (`api.frankfurter.dev`) | Câmbio do dia para exibir valores na moeda escolhida |
| ipapi.co | Localização usada como padrão de idioma, moeda e fuso |
| Google Cloud Storage | Foto de perfil, mídias de avaliação e documentos |
| Google Cloud Translation | Tradução de conteúdo dinâmico para um dos quatro idiomas da interface. As strings fixas ficam em `gen_l10n`, i18n e i18next; não passam por esta API |
| Asaas (`api.asaas.com/v3`, sandbox `api-sandbox.asaas.com/v3`) | Cobrança do plano PRO no site de planos (`WEB/`). O app não cobra |
| SerpAPI (`serpapi.com`) | Busca de imagens |
| Pexels (`api.pexels.com/videos`) | Busca de vídeos |
| picsum.photos | Imagem de preenchimento em protótipo e teste |
| ViaCEP (`viacep.com.br`) | Endereço a partir do CEP |

## 4. Limites entre sistemas

- O app não fala com OpenAI, Asaas, Google Places nem SMTP. Fala só com a API. Não cobra pela loja.
- O site de planos também não fala com a Asaas. Fala só com a API.
- A API aplica as regras de `BUSINESS/` (papéis da viagem, status da viagem, roteiro sem geração automática acima de 14 dias, bloqueio mútuo, moeda original do gasto versus moeda de exibição).
- O painel não é um segundo app do viajante. Não reimplementa o roteiro nem o feed. Quem assina é o site de planos, não o painel.
- O e2e exercita os fluxos, não define regra de negócio.
- Segredos ficam em GitHub Environments / variáveis do ambiente. Não entram no app nem no Git.

## 5. Dados e mensageria

Postgres é a fonte da verdade. Redis, hoje, só revoga access token. Kafka transporta geração de roteiro, notificação e ingestão. O estado do job fica no Postgres. A expiração de assinatura é um job diário, não uma fila Kafka. O modelo, os schemas e o que continua `A DEFINIR` estão em `TECH/TECH.md`. A decisão está em `adrs/0001-dados-e-mensageria.md`.

O que o negócio já exige, independente do banco:

- Gasto guardado na **moeda original** do lançamento; a tela converte para a moeda de exibição.
- Documento da viagem disponível **offline** no aparelho.
- Notificação **sempre** in-app e push, juntas.
- Sessão: trocar a senha encerra as outras sessões; “Sair” encerra só a sessão local.
- Bloqueio é mútuo e silencioso.

## 6. Aberto (`A DEFINIR`)

Pontos ainda sem decisão. Não preencha no código.

1. Nome dos tópicos Kafka, contrato dos eventos, e o que mais entra no Redis além da revogação. Lista completa em `TECH/TECH.md` §10.
2. Prazo máximo para analisar uma denúncia (`PANEL/19`).
3. Provedor de push. A notificação in-app e o push saem juntos; o fornecedor do push ainda não tem nome.
4. Modelo, contexto e limite de uso da Maya.
5. Framework do site de planos (`WEB/`).
6. Endereço público desse site.

Preço e features do PRO não têm valor padrão no código. O administrador grava isso em `PANEL/08-planos.md`.
