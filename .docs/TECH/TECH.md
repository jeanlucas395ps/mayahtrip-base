# Dados e operação

Fonte técnica de persistência, processamento assíncrono e da operação que ainda não está tela a tela em `PANEL/`.

O comportamento do viajante está em `BUSINESS/`. O que o painel já faz está em `PANEL/`. A stack e os fornecedores estão em `ARCHITECTURE.md`. A decisão de senha, token e revogação está em `mayahtrip-backend/adrs/0001-identidade-tokens-persistencia.md`. A decisão de banco e fila está em `adrs/0001-dados-e-mensageria.md`.

Convenção deste repositório: o que ainda não foi decidido aparece como **`A DEFINIR`**. Isso não vira tabela, tópico, tela nem código.

A API é uma só, NestJS, modular por domínio. Schema no Postgres organiza o dado. Não cria microsserviço.

## 1. O que este documento fecha

| Peça | Decisão |
| --- | --- |
| Banco durável | PostgreSQL. Fonte da verdade de conta, viagem, comunidade, cobrança, ingestão e auditoria |
| MongoDB | Fora da stack |
| ORM | TypeORM. `synchronize` desligado. Toda mudança de estrutura é migration versionada |
| Identificador | UUID nas entidades principais. `gen_random_uuid()` |
| Dinheiro | `NUMERIC`. Sem `FLOAT` e sem `DOUBLE PRECISION` |
| Instante | `TIMESTAMPTZ` para instante absoluto. Data local de viagem fica em campo próprio quando não for um instante universal |
| JSONB | Metadado variável de provedor e de conteúdo externo. Relação que tem dono vira tabela |
| Arquivo | Google Cloud Storage. O Postgres guarda metadado, permissão e a chave do objeto |
| Redis agora | Lista de `jti` revogados do access token, com TTL até o fim da vida do token (no máximo 15 minutos) |
| Redis depois | Cache e limite de taxa entram na feature que precisar. Número, janela, chave e armazenamento do limite de taxa continuam `A DEFINIR` |
| Kafka | Geração de roteiro, notificação e ingestão. O estado do job fica no Postgres |
| Expiração de assinatura | Job diário no Postgres. A tela `PANEL/17` dispara a mesma checagem fora de hora. Não é fila Kafka |
| API | Rota de produto em `/v1`. `GET /metrics`, `GET /docs` e `GET /readme` ficam fora dessa versão |
| Senha | Argon2id. Código de verificação com quatro dígitos e dez minutos. Trocar a senha encerra as outras sessões |
| Cobrança | Asaas, só pela API. O site e o painel não chamam a Asaas no browser |
| Ingestão | Trilha paralela ao app. Enriquece a base que a API entrega. Conteúdo em preparação não aparece no app |
| Papéis do painel | Entram, para granularidade futura. A matriz de permissão é `A DEFINIR`. Até ela existir, administrador ativo executa todas as funções de `PANEL/` |

## 2. Persistência

### PostgreSQL

Um banco. Schemas por domínio, na tabela da seção 3.

Guarda usuários e perfis, geografia, catálogo de lugares, publicações e interações, viagens e roteiros, gastos e acertos, mala, compras, documentos e links, notificações, assinaturas e pagamentos, conteúdo ingerido e o histórico de validação, denúncias e moderação, administradores e auditoria, estado dos jobs e eventos pendentes de publicação.

Convidado não tem linha em `users`. O modo convidado vive no app (`BUSINESS/04`).

### Redis

Hoje, só a revogação imediata do access token.

Cache de consulta, limite de taxa, coordenação temporária e cache de provedor entram quando a feature correspondente for construída. Redis não é a única cópia de uma operação de negócio.

### Kafka

Transporta evento e distribui trabalho. Não substitui o agendador nem a tabela de estado do job.

Fluxos:

1. Geração de roteiro.
2. Notificação (central do app e push, juntas).
3. Ingestão de conteúdo.

Nome de tópico, contrato do evento e parâmetro de retentativa: `A DEFINIR`.

Confiabilidade exigida, sem número inventado:

- Outbox no Postgres. A publicação sai depois do commit do negócio.
- Consumidor idempotente.
- Retentativa com backoff.
- Dead letter.
- Consumer group.
- Limite de concorrência.
- Limite de taxa por fonte de ingestão.
- Correlation id de ponta a ponta.
- Estado do job no Postgres, para o painel mostrar pendente, processando e falho.

O painel fala com a API. Não publica em tópico a partir do browser.

### Google Cloud Storage

Fotos de perfil, mídias de avaliação, mídias do catálogo e documentos da viagem.

Documento de viagem fica disponível offline no aparelho e não aparece no painel. Documento pessoal do perfil é CPF, CNH, passagem de ônibus ou de avião, em imagem ou PDF, e fica em `identity.user_documents`. A carteira digital só entra quando há código legível. O painel não lê essa tabela. A tela “Meus documentos” continua `A DEFINIR`.

Política de retenção e exclusão de mídia: `A DEFINIR`.

## 3. Schemas

| Schema | Responsabilidade |
| --- | --- |
| `identity` | Conta, perfil, sessão, código e provedor |
| `geography` | Continente, país, região e cidade |
| `catalog` | Lugares, categorias, informação e mídia |
| `community` | Publicação, avaliação e interação |
| `travel` | Viagem, destino, participante e convite |
| `itinerary` | Dia, parada, deslocamento e geração |
| `finance` | Gasto, divisão, acerto e câmbio |
| `organization` | Mala, compras, documentos e links |
| `notification` | Notificação e entrega |
| `subscription` | Plano, assinatura, pagamento e Asaas |
| `maya` | Conversa, mensagem e consumo |
| `ingestion` | Fonte, job, staging e validação |
| `moderation` | Revisão editorial, denúncia e decisão |
| `admin` | Administrador, papel e auditoria |
| `integration` | Provedor externo e sincronização |
| `platform` | Outbox, idempotência e job agendado |

## 4. Modelo por domínio

Os campos abaixo são o contrato conceitual. Tipo físico, chave estrangeira, índice definitivo e dicionário completo vêm na migration de cada domínio. Índice sugerido na seção 8 é ponto de partida, validado pelo plano de execução real.

### 4.1. Identity

| Tabela | Responsabilidade |
| --- | --- |
| `users` | Conta. E-mail, `password_hash`, status, `email_verified_at`, `created_at`, `deleted_at` |
| `user_profiles` | Nome, username, bio, avatar |
| `user_preferences` | `locale`, moeda, fuso, aparência, modo de localização |
| `user_auth_providers` | Google e e-mail/senha são métodos distintos |
| `user_sessions` | Refresh opaco, guardado com hash, com rotação. Access token não fica aqui |
| `user_verification_codes` | Código com hash, propósito, expiração, tentativas, uso |
| `user_handoff_codes` | Código opaco de uso único para abrir o site já autenticado. Separado da sessão |
| `user_visited_countries` | País marcado pelo usuário |
| `user_visited_cities` | Cidade marcada pelo usuário |

Regras fechadas:

- Senha com Argon2id.
- Access token JWT, 15 minutos, sem consulta ao banco no caminho feliz.
- Refresh no Postgres. Reuso de refresh já consumido revoga a sessão.
- Código de quatro dígitos, dez minutos, no cadastro e na recuperação de senha.
- Trocar a senha encerra as outras sessões. “Sair” encerra só a sessão local.
- Google OAuth: a API valida o token. Google e e-mail/senha são métodos distintos.
- Handoff: o access token não vai na URL. Só o código opaco. A duração exata do código é `A DEFINIR` (a spec propõe 60 segundos).
- Idioma da conta é um dos quatro: `pt-BR`, `pt-PT`, `en`, `es`. Sem localização, ou país fora da lista de `BUSINESS/35`, o padrão é `pt-BR` e BRL.
- Exclusão de usuário do app é lógica. Dá para restaurar (`PANEL/`).

`A DEFINIR`: pedido de follow em perfil privado.

País e cidade visitados: marcação manual ou a viagem criada para aquele lugar, com `visit_source` `manual` ou `trip`. Um país e uma cidade por pessoa. Viagem com data já passada grava as duas tabelas. Viagem futura não entra nelas; conta como planejada (`BUSINESS/32`).

### 4.2. Geography

| Tabela | Responsabilidade |
| --- | --- |
| `continents` | Continentes |
| `countries` | País e código ISO |
| `regions` | Estado, província, região |
| `cities` | Cidade, coordenada e fuso |
| `geographic_aliases` | Nomes alternativos |
| `geographic_translations` | Tradução. Sem coluna `name_pt`, `name_en`, `name_es` |

Relação: `continents → countries → regions → cities`.

Idiomas oficiais das traduções: `pt-BR`, `pt-PT`, `en`, `es`.

Quem mantém essa base (importação, correção manual, CRUD no painel) é `A DEFINIR`. A ingestão pode gravar coordenada e referência externa sem esperar um mapa-múndi editável.

### 4.3. Catalog

O identificador do lugar é do MayahTrip. Provedor externo é fonte de enriquecimento.

| Tabela | Responsabilidade |
| --- | --- |
| `places` | Ficha. `city_id`, nome de origem, slug, descrição, latitude, longitude, site, telefone, status |
| `place_translations` | Nome e descrição nos quatro idiomas |
| `place_categories` | Categorias |
| `place_category_translations` | Tradução das categorias |
| `place_category_relations` | Lugar e categoria, N:N |
| `place_external_references` | `provider`, `external_place_id`, URL, `last_synced_at`, `provider_metadata` |
| `place_addresses` | Endereço estruturado |
| `place_opening_hours` | Horário |
| `place_price_information` | Faixa de preço |
| `place_visit_information` | Duração e informação de visita |
| `place_media` | Foto e vídeo autorizados |
| `place_ratings_summary` | Resumo das avaliações |
| `place_community_tips` | Dicas da comunidade |

Google Places (find, nearby, text, details, photos), SerpAPI e Pexels continuam sendo as integrações nomeadas em `ARCHITECTURE.md`. A frase que falta, e fica `A DEFINIR`: se a busca do app lê este catálogo ou chama o provedor ao vivo. Os dois caminhos ao mesmo tempo geram duas fichas do mesmo lugar. Até essa frase existir, a ingestão grava staging e referência externa, e não substitui a busca atual.

Conteúdo ingerido não é publicação nem avaliação de usuário MayahTrip.

### 4.4. Community

| Tabela | Responsabilidade |
| --- | --- |
| `posts` | Publicação |
| `post_media` | Mídias |
| `post_mentions` | Menções |
| `comments` | Comentário e resposta, um nível |
| `post_likes` | Curtida em publicação |
| `comment_likes` | Curtida em comentário |
| `user_follows` | Seguir |
| `user_blocks` | Bloqueio |
| `user_mutes` | Silenciar |
| `saved_posts` | Publicação salva |
| `place_reviews` | Avaliação formal |
| `place_review_media` | Mídia da avaliação |

Regras fechadas:

- Avaliação exige nota de 1 a 5 e ao menos uma foto ou vídeo.
- Comentário tem um nível de resposta.
- Bloqueio é mútuo e silencioso. Conteúdo de quem foi bloqueado não aparece para quem bloqueou.
- Silenciar tira as publicações da pessoa do feed de quem silenciou.
- Chat entre usuários, selo Explorador e selo verificado estão fora do produto (`BUSINESS.md` §9).

`A DEFINIR`: o mesmo usuário avaliar o mesmo lugar mais de uma vez. Uma publicação citar vários lugares, cidades ou países (`post_places`, `post_cities`, `post_countries` esperam essa decisão). Ranking “Para você”. Limite de quantidade, tamanho e duração de mídia. Tradução de conteúdo criado pelo usuário.

### 4.5. Travel

| Tabela | Responsabilidade |
| --- | --- |
| `trips` | Viagem |
| `trip_destinations` | Destinos, com ordem |
| `trip_participants` | Pessoa e papel nesta viagem |
| `trip_invitations` | Convite |
| `trip_clones` | Histórico de clonagem |

`trips`: dono, título, descrição, capa, início, fim, duração em dias, pública ou privada, status, datas de criação e atualização.

Status, como em `BUSINESS.md` §4.4:

| Status | Regra |
| --- | --- |
| Rascunho | Tem duração e não tem data |
| Próxima | Início no futuro |
| Acontecendo agora | Hoje está entre o primeiro e o último dia |
| Concluída | O último dia já passou |

Começo da viagem, como em `BUSINESS/14`: roteiro sugerido, roteiro da comunidade, começar do zero. Acima de 14 dias, só do zero.

`trip_destinations`: viagem, cidade, posição, chegada, saída.

`trip_participants`: viagem, usuário, papel, entrada, saída (`removed_at`). O papel é do participante nesta viagem, não do usuário.

| Papel | O que `BUSINESS.md` §4.3 e `BUSINESS/26` já fecham |
| --- | --- |
| Dono | Controle da viagem. Só o dono altera papel e remove pessoas |
| Viajante supremo | Vê e edita tudo, inclusive documentos e gastos |
| Viajante experiente | Vê e edita. Não vê documentos |
| Assistente júnior | Só visualiza roteiro. Não vê documentos nem gastos |

Convidar e remover, para supremo e experiente, continua `A DEFINIR` em `BUSINESS.md` §10. Confirmar a remoção, convite pendente na lista, convite por link além de e-mail e transferir a posse: `A DEFINIR` em `BUSINESS/26`.

Viagem pública pode ser clonada. O clone copia o roteiro. Gasto e documento continuam privados. Onde a viagem pública aparece no app: `A DEFINIR` (`PANEL/03`).

O que permanece visível depois que a pessoa sai da viagem: `A DEFINIR`. A linha do participante permanece, com `removed_at`.

### 4.6. Itinerary

| Tabela | Responsabilidade |
| --- | --- |
| `trip_itineraries` | Roteiro da viagem |
| `itinerary_days` | Dias |
| `itinerary_stops` | Paradas |
| `itinerary_transfers` | Deslocamento entre paradas |
| `itinerary_generation_jobs` | Job de geração. Estado que o painel lê |
| `itinerary_generation_results` | Resultado gerado |
| `itinerary_optimization_runs` | Histórico de otimização |

Relação: `trips → trip_itineraries → itinerary_days → itinerary_stops`.

`itinerary_stops`: dia, lugar, posição, horário, duração em minutos, notas, custo estimado, moeda.

`itinerary_transfers`: parada de origem, parada de destino, modo, distância em metros, duração em segundos, geometria, referência do provedor.

Regras:

- Geração acima de 14 dias não existe. A viagem começa com os dias livres.
- A geração é assíncrona. O estado fica em `itinerary_generation_jobs`. O trabalho sai pela outbox para o Kafka.
- Otimização preserva horário e duração já definidos.
- A Maya não grava nem altera roteiro, gasto ou viagem.
- Rota, tempo e distância usam Google Directions, Distance Matrix e Geocoding, chamados pela API.
- Mapa no app: Google Maps. O fornecedor do mapa desenhado na tela de roteiro, quando for diferente dessa integração, continua `A DEFINIR` em `DESIGN.md`.

### 4.7. Finance

Categorias fixas, as dez de `BUSINESS.md` §4.6. Não há catálogo livre de categoria.

| Tabela | Responsabilidade |
| --- | --- |
| `expense_categories` | As dez categorias. Ícone e cor vêm do negócio, não de um CRUD |
| `expenses` | Gasto |
| `expense_participants` | Quem entra no gasto |
| `expense_splits` | Valor por pessoa, na moeda original |
| `settlements` | Acerto. Entidade separada do gasto |
| `exchange_rates` | Taxa aplicada. Uma tabela só. Integração lê daqui. Não existe segunda cópia em `integration` |
| `currency_definitions` | As moedas de exibição |

`expenses`: viagem, quem lançou, quem pagou, categoria, descrição, `amount_original`, `currency_original`, data do gasto, contexto da data, taxa aplicada, criação e atualização.

Moedas de exibição, de `BUSINESS/35`: `BRL`, `USD`, `GBP`, `CAD`, `AUD`, `EUR`, `MXN`, `CHF`, `CNY`, `JPY`. Sem localização, BRL.

O valor original fica guardado. A tela converte pelo câmbio do dia. A fonte nomeada é Frankfurter (`api.frankfurter.dev`), em `BUSINESS/35` e `ARCHITECTURE.md`. A política de atualização e de por quanto tempo a taxa fica gravada é `A DEFINIR`.

Divisão desigual: `A DEFINIR`. A tabela de split existe para o valor de cada pessoa. A regra de como o usuário informa partes diferentes espera o negócio.

Quem vê gasto: dono, supremo e experiente. Júnior não vê (`BUSINESS.md` §4.3).

### 4.8. Organization

| Tabela | Responsabilidade |
| --- | --- |
| `packing_categories` | Grupos da mala |
| `packing_catalog_items` | Itens da lista padrão |
| `trip_packing_items` | Itens da mala desta viagem |
| `shopping_items` | Lista de compras |
| `trip_documents` | Metadado do documento. O arquivo está no Google Cloud Storage |
| `trip_links` | Links da viagem |

Mala: a lista descrita em `BUSINESS/23` tem 43 itens em sete grupos, compartilhada pela viagem. Qual lista é o padrão definitivo do assistente, mala individual, e remover ou editar item: `A DEFINIR`. CRUD dessa lista no painel não existe em `PANEL/` e fica `A DEFINIR`.

Compras: viagem, nome, preço estimado, moeda, loja, URL, comprado ou não, quem criou.

Documentos: viagem, quem enviou, chave no storage, nome, mime, tamanho, data. O painel não lê esse conteúdo.

### 4.9. Notification

| Tabela | Responsabilidade |
| --- | --- |
| `notifications` | Notificação da central |
| `notification_deliveries` | Entrega por canal |
| `notification_templates` | Texto nos quatro idiomas |
| `device_push_tokens` | Token do aparelho |
| `notification_events` | Histórico do envio |

Toda notificação existe na central e sai em push. Não há canal só de um lado (`BUSINESS.md` §4.1). O usuário recebe todas.

Provedor de push: Firebase FCM. A credencial fica em variável de ambiente e o envio espera essa variável. Preferência por tipo: `A DEFINIR` em `BUSINESS.md` §10. Enquanto isso, não há tabela de preferência.

### 4.10. Subscription

O painel já descreve o comercial em `PANEL/05` a `PANEL/15`. O banco cobre esse comportamento. O site de planos (`WEB/`) é quem o viajante usa para assinar. O app não cobra.

| Tabela | Responsabilidade |
| --- | --- |
| `plans` | Plano. O Free existe desde o início, não se desativa e não se exclui |
| `plan_translations` | Nome e texto nos quatro idiomas |
| `plan_features` | Features gravadas pelo administrador. Sem preço padrão no código |
| `plan_prices` | Preço, duração e ciclo. Plano sem preço não ativa, exceto o Free |
| `user_subscriptions` | Assinatura vigente |
| `subscription_payments` | Pagamento |
| `subscription_events` | Webhook e histórico. A assinatura do webhook da Asaas é validada |
| `promo_grants` | PRO promocional de 30 dias, sem cobrança e sem fatura na Asaas |
| `coupons` | Código de período grátis |
| `refunds` | Estorno. Dias de teste configuráveis, de 1 a 365, em `PANEL/13` |
| `payment_method_settings` | Cartão, boleto e Pix. Ao menos um ligado |

Desativar um plano impede assinatura nova. Quem já assinou fica até o fim do ciclo. Cancelar renovação não estorna. Convidado não abre checkout.

### 4.11. Maya

| Tabela | Responsabilidade |
| --- | --- |
| `maya_conversations` | Conversa |
| `maya_messages` | Mensagens |
| `maya_usage` | Uso e custo |
| `maya_model_configs` | Configuração que o painel gravar (`PANEL/06`) |
| `maya_feedback` | Feedback |

A Maya responde no idioma ativo da interface e oferece atalhos. Não há caso de uso que grave viagem, gasto ou roteiro.

Modelo, contexto e limite Free/PRO: `A DEFINIR` (`BUSINESS/27`, `ARCHITECTURE.md` §6).

### 4.12. Ingestion

Trilha paralela ao app. O resultado aprovado enriquece o catálogo que a API entrega. Staging não é público.

| Tabela | Responsabilidade |
| --- | --- |
| `content_sources` | Fonte. Nome, tipo, URL base, tipo de integração, status, URL dos termos |
| `content_source_policies` | O que a fonte autoriza |
| `ingestion_jobs` | Execução. Estado, contagens, erro |
| `ingestion_job_items` | Item da execução |
| `ingestion_items` | Staging. Id externo, tipo, título, descrição, URL, lugar detectado, status |
| `ingestion_item_media` | Mídia em staging |
| `ingestion_item_metadata` | Metadado de origem |
| `content_licenses` | Licença e evidência |
| `content_ai_validations` | Resultado da validação |
| `content_provenance` | Origem e transformação |

Estados do item: `DISCOVERED`, `PROCESSING`, `AI_VALIDATED`, `PENDING_REVIEW`, `APPROVED`, `REJECTED`, `PUBLISHED`, `FAILED`, `REMOVAL_REQUESTED`, `REMOVED`.

`A DEFINIR`: quais fontes autorizam armazenar e republicar o arquivo. Google Places, SerpAPI e Pexels estão na stack para busca. Republicar o binário deles no app espera essa autorização. A ficha pode guardar a referência externa antes disso.

### 4.13. Moderation

Revisão de conteúdo ingerido e moderação de conteúdo de usuário são filas diferentes.

| Tabela | Responsabilidade |
| --- | --- |
| `content_review_tasks` | Fila editorial do que veio de fora |
| `content_review_decisions` | Decisão |
| `content_publications` | O que foi publicado no catálogo |
| `content_removal_requests` | Pedido de remoção |
| `user_reports` | Denúncia de publicação, comentário ou perfil |
| `report_categories` | Motivos já listados em `BUSINESS/30` |
| `moderation_actions` | Ação aplicada |
| `moderation_appeals` | Recurso. Só existe se o produto definir recurso |

Denúncia procedente pode remover conteúdo e desativar a conta. O denunciante recebe o resultado no app e no push (`PANEL/PANEL.md`). Prazo máximo de análise e o retorno além dessa notificação: `A DEFINIR` (`PANEL/19`).

### 4.14. Admin

Conta separada da conta do app: nome, e-mail e senha. Não entra no app.

| Tabela | Responsabilidade |
| --- | --- |
| `admin_users` | Administrador |
| `admin_roles` | Papel |
| `admin_permissions` | Permissão |
| `admin_user_roles` | Usuário e papel |
| `admin_role_permissions` | Papel e permissão |
| `admin_sessions` | Sessão do painel |
| `admin_audit_logs` | Auditoria |
| `admin_login_attempts` | Tentativa de login |

Papéis previstos, para quando a matriz existir:

- Super Admin
- Content Manager
- Content Reviewer
- Community Moderator
- Customer Support
- Finance Manager
- Analyst

A matriz do que cada um faz nas funções de `PANEL/` é `A DEFINIR`. Até lá, administrador ativo executa todas. Conta inativa não entra. O administrador não exclui a própria conta enquanto for o único ativo.

Credencial de integração não fica em texto puro e não fica em `admin_api_keys` enquanto não houver um caso de uso. Segredo fica em variável de ambiente.

### 4.15. Integration

| Tabela | Responsabilidade |
| --- | --- |
| `external_provider_accounts` | Provedor. Sem segredo em texto puro |
| `external_sync_jobs` | Sincronização |
| `external_references` | Referência que não é lugar (lugar fica em `catalog.place_external_references`) |
| `integration_logs` | Chamada técnica. Sem senha, token, documento nem corpo de e-mail |

Câmbio não se repete aqui. A taxa está em `finance.exchange_rates`.

### 4.16. Platform

| Tabela | Responsabilidade |
| --- | --- |
| `outbox_events` | Evento gravado na mesma transação do negócio, aguardando o Kafka |
| `processed_events` | Evento já consumido, para idempotência |
| `idempotency_keys` | Pedido repetido da API |
| `scheduled_job_runs` | Job diário, inclusive a expiração de assinatura |
| `system_settings` | Configuração não secreta |
| `feature_flags` | Liberação controlada. O mecanismo de flag ainda não tem fornecedor além desta tabela |

## 5. Fluxos

### 5.1. Geração de roteiro

1. A pessoa cria a viagem e escolhe geração.
2. A API recusa geração acima de 14 dias.
3. A API grava o job no Postgres.
4. O evento entra na outbox.
5. O publisher envia ao Kafka.
6. O worker gera o roteiro.
7. O resultado volta ao Postgres.
8. O evento de conclusão entra na outbox.
9. A notificação nasce na central e no push.

### 5.2. Notificação

1. A operação de negócio grava o evento na outbox.
2. O publisher envia ao Kafka.
3. O worker grava a notificação in-app.
4. O worker envia o push pelo provedor que ainda é `A DEFINIR`.
5. A entrega fica em `notification_deliveries`.

### 5.3. Ingestão

1. O agendador cria o job no Postgres.
2. A fonte autorizada devolve os itens.
3. O processamento segue por Kafka.
4. O worker normaliza e grava staging.
5. A validação olha relevância, qualidade, localização e duplicidade.
6. O que precisar de pessoa vai para `content_review_tasks`.
7. Aprovar publica no catálogo. Rejeitar fica no histórico.
8. Origem, licença e decisão permanecem.

### 5.4. Expiração de assinatura

Roda todo dia. `PANEL/17` dispara a mesma checagem agora. O registro fica em `scheduled_job_runs`.

A checagem tira o PRO de quem venceu e não tem renovação paga, cupom vigente nem PRO promocional vigente. Não cobra.

## 6. Painel

O Angular fala só com a API. Não acessa Postgres, Redis, Kafka, Google Cloud Storage nem Asaas no browser.

As telas `PANEL/01` a `PANEL/20` continuam valendo: dashboard, administradores, viagens, usuários, PRO promocional, Maya, financeiro, planos, cupons, pagamentos, assinaturas, estorno, dias de teste, métodos (cartão, boleto, Pix), logs da Asaas, filas, expiração, infraestrutura, denúncias e publicações.

Este documento acrescenta a operação abaixo. Arquivo numerado em `PANEL/` para cada uma dessas telas ainda não existe. O texto de interface delas é `A DEFINIR`. O comportamento é o desta seção.

### 6.1. Filas

`PANEL/16` mostra pendente, processando e falho, por fila Kafka:

- Geração de roteiro
- Notificação
- Ingestão

Ações já descritas em `PANEL/16`: limpar pendente ou em processamento, marcar geração presa como falha, recolocar, apagar falho, esvaziar falhos. Recolocar não duplica job pendente ou em processamento. Apagar falho não apaga viagem, pagamento nem notificação já entregue.

A expiração não entra nessa lista.

### 6.2. Content Hub

Fontes: cadastro, ativar, desativar, frequência, limite de requisição, termos, tipos permitidos.

Jobs: status, descobertos, processados, falhos, reexecução controlada, pausa e cancelamento quando o worker suportar.

Revisão: filtrar por tipo de mídia, país, cidade, lugar, fonte, status da validação, confiança e duplicidade. Ações: aprovar, rejeitar, pedir correção, encaminhar, associar a outro lugar.

Detalhe: preview autorizado, URL de origem, provedor, atribuição, lugar, metadado, licença, resultado da validação, duplicidade, histórico.

Publicado: consulta, remoção da exibição pública, pedido de remoção, reavaliação de licença.

### 6.3. Catálogo e geografia

CRUD de lugar, categoria, tradução, endereço, horário, preço, duração, mídia autorizada, referência externa, unificar duplicata, arquivar.

CRUD geográfico no painel espera a decisão da seção 4.2.

### 6.4. O que o painel não faz

- Montar roteiro, lançar gasto, fazer mala ou publicar no lugar do viajante.
- Ler documento da viagem.
- Publicar em tópico Kafka.
- Chamar Asaas, Google ou OpenAI no browser.

Viagens, no painel, são consulta (`PANEL/03`). Alteração administrativa de viagem exige auditoria e a política daquela tela.

## 7. Regras transversais

- Entrada validada na API. Query parametrizada.
- Autorização por usuário e pelo papel na viagem.
- Autorização de administrador pela regra da seção 4.14.
- Token e código guardados com hash. Segredo fora do banco, ou cifrado se um dia precisar ficar nele.
- Log sem senha, token, documento, código de handoff e corpo de e-mail.
- Auditoria das operações de administrador.
- Exclusão lógica onde o produto já pede restauração (usuário do app). Histórico de decisão e de auditoria permanece.
- Migration versionada. Sem sincronizar schema em produção.

Índices iniciais, a confirmar no plano de execução:

| Tabela | Acesso |
| --- | --- |
| `users` | E-mail e username |
| `places` | Cidade, status e coordenada |
| `posts` | Usuário e data |
| `trips` | Dono, status e data |
| `trip_participants` | Viagem e usuário |
| `itinerary_stops` | Dia e posição |
| `expenses` | Viagem e data |
| `ingestion_items` | Status, fonte e data |
| `content_review_tasks` | Status, prioridade e responsável |
| `notifications` | Usuário, data e leitura |
| `admin_audit_logs` | Ator, entidade e data |

## 8. Ordem de construção

A ingestão pode andar em paralelo ao app desde que o contrato de `places` e de `place_external_references` esteja fechado. Ela não bloqueia identidade nem viagem.

| Fase | Schemas | Entrega |
| --- | --- | --- |
| 1 | `identity`, `platform`, `admin` | Conta, código, Google, refresh, handoff, sessão de administrador, auditoria. Papel efetivo único até a matriz |
| 2 | `geography`, `catalog`, `travel`, `itinerary` | Lugar, viagem, participante, destino, roteiro, parada, deslocamento, geração |
| 3 | `finance`, `organization` | Gasto, acerto, câmbio, mala, compras, documentos, links |
| 4 | `community`, `moderation` | Feed, publicação, avaliação, comentário, curtida, seguir, bloquear, silenciar, denúncia |
| 5 | `ingestion` | Fonte, staging, validação, revisão, publicação, proveniência. Em paralelo, não depois da comunidade |
| 6 | `subscription`, `notification`, `maya`, `integration` | Plano, Asaas, cupom, promocional, estorno, notificação, push, Maya |

Geografia na fase 2 é a estrutura mínima para `places.city_id`. O CRUD administrativo dela continua `A DEFINIR`.

## 9. Antes da migration de um domínio

1. Este arquivo e o `BUSINESS/` daquele domínio dizem a mesma regra.
2. Item `A DEFINIR` daquele domínio não ganha coluna que antecipe a decisão.
3. Tipos, chaves, constraints e índices daquela migration estão no arquivo de migration.
4. Evento Kafka daquele domínio, se houver, tem contrato escrito. Hoje o contrato é `A DEFINIR` para os três fluxos.
5. A migration foi revista e testada. Sem `synchronize`.

O ERD completo de todos os domínios de uma vez antecipa decisão aberta. O dicionário físico acompanha a fase que está sendo construída.

## 10. `A DEFINIR`

Não implementar por suposição.

| Tema | O que falta |
| --- | --- |
| Busca de lugar | Catálogo MayahTrip ou chamada ao vivo ao Google Places |
| Republicação | Quais fontes autorizam guardar e exibir o arquivo |
| Geografia | Quem mantém continentes, países, regiões e cidades, e se o painel edita |
| Vários lugares na publicação | Se um post cita mais de um lugar, cidade ou país |
| Avaliação repetida | Se a mesma pessoa avalia o mesmo lugar mais de uma vez |
| Perfil | Perfil privado e pedido de follow |
| Mídia | Retenção, exclusão, quantidade, tamanho e duração |
| Tradução de conteúdo de usuário | Se passa por Google Cloud Translation |
| Feed | Algoritmo “Para você” |
| Gastos | Regra da divisão desigual |
| Participante | O que fica visível depois da saída |
| Convite | Convidar e remover para supremo e experiente. Confirmação de remoção. Convite pendente. Link. Transferir posse |
| Documentos pessoais | A tela “Meus documentos”. Os tipos e a carteira já estão em `identity.user_documents` |
| Mala | Lista padrão definitiva, mala individual, editar e remover item, CRUD no painel |
| Câmbio | Por quanto tempo a taxa fica gravada e quando atualiza. A fonte já é Frankfurter |
| Visitados | A barra por continente. A marca manual e a viagem passada já gravam `user_visited_*` |
| Denúncia | Prazo máximo e retorno além da notificação já fechada |
| Push | Provedor |
| Notificação | Preferência por tipo. Hoje o usuário recebe todas, nos dois canais |
| Maya | Modelo, contexto e limite Free/PRO |
| Handoff | Duração do código. A spec propõe 60 segundos |
| Papéis do painel | Matriz de permissão. Os sete nomes estão previstos. O efeito hoje é um papel só |
| Kafka | Nome dos tópicos, contrato dos eventos, números de retentativa e de concorrência |
| Rate limit | Número, janela, chave e onde o contador mora |
| Redis além da revogação | O que entra em cache, quando a feature existir |
| Web | Framework do site e endereço público |
| Mapa desenhado do roteiro | Fornecedor, se deixar de ser a integração Google já nomeada |
| Recurso de moderação | Se existe appeal |
