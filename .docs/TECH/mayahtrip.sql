-- MayahTrip — modelo físico do que o produto já fechou.
-- Fonte: BUSINESS/00–35, PANEL/, WEB/ e TECH/TECH.md.
-- Postgres 16. Um banco, schemas por domínio.
--
-- Isto não é a migration aplicada. A API hoje tem conta, sessão e handoff
-- numa forma anterior. Este arquivo é o contrato para as próximas migrations.
--
-- Decisões de 18 nov 2026 estão neste arquivo.
-- Continua de fora, porque ainda não foi fechado:
--   papel padrão do convite por e-mail, papel da criança sem conta,
--   limites da Maya no Free e no PRO, matriz dos sete papéis do painel,
--   lista fechada de licença, quais fontes podem guardar arquivo,
--   provedor de push, algoritmo "Para você", prazo máximo da denúncia.
-- Aparência (claro/noturno) fica no aparelho, não aqui (BUSINESS/33).
-- Access token não fica no Postgres. A revogação do jti fica no Redis.
-- A Maya não tem tabela que grave viagem, gasto ou roteiro.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS identity;
CREATE SCHEMA IF NOT EXISTS geography;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS community;
CREATE SCHEMA IF NOT EXISTS travel;
CREATE SCHEMA IF NOT EXISTS itinerary;
CREATE SCHEMA IF NOT EXISTS finance;
CREATE SCHEMA IF NOT EXISTS organization;
CREATE SCHEMA IF NOT EXISTS notification;
CREATE SCHEMA IF NOT EXISTS subscription;
CREATE SCHEMA IF NOT EXISTS maya;
CREATE SCHEMA IF NOT EXISTS ingestion;
CREATE SCHEMA IF NOT EXISTS moderation;
CREATE SCHEMA IF NOT EXISTS admin;
CREATE SCHEMA IF NOT EXISTS integration;
CREATE SCHEMA IF NOT EXISTS platform;

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

CREATE TYPE identity.user_status AS ENUM ('pending', 'active', 'inactive');
CREATE TYPE identity.auth_provider AS ENUM ('google');
CREATE TYPE identity.verification_purpose AS ENUM ('sign_up', 'password_reset');
CREATE TYPE identity.profile_visibility AS ENUM ('public', 'private');
CREATE TYPE identity.access_tier AS ENUM ('free', 'pro');
CREATE TYPE identity.document_type AS ENUM ('cpf', 'cnh', 'bus_ticket', 'flight_ticket');
CREATE TYPE identity.wallet_provider AS ENUM ('google_wallet', 'apple_wallet');
CREATE TYPE identity.visit_source AS ENUM ('manual', 'trip');

CREATE TYPE travel.trip_visibility AS ENUM ('private', 'public');
CREATE TYPE travel.trip_start_mode AS ENUM ('suggested', 'community', 'from_scratch');
CREATE TYPE travel.participant_role AS ENUM (
  'owner',
  'supreme_traveler',
  'experienced_traveler',
  'junior_assistant'
);
CREATE TYPE travel.invitation_status AS ENUM ('pending', 'accepted', 'declined');
CREATE TYPE travel.party_kind AS ENUM ('adult', 'child');
CREATE TYPE travel.invitation_channel AS ENUM ('email', 'link');

CREATE TYPE itinerary.generation_status AS ENUM (
  'pending',
  'processing',
  'completed',
  'failed',
  'cancelled'
);

CREATE TYPE community.content_status AS ENUM ('draft', 'published', 'hidden', 'removed');
CREATE TYPE community.report_status AS ENUM ('pending', 'reviewing', 'resolved', 'dismissed');
CREATE TYPE community.audience AS ENUM ('public', 'private');
CREATE TYPE community.post_origin AS ENUM ('user', 'review');
CREATE TYPE community.follow_request_status AS ENUM ('pending', 'accepted', 'rejected');
CREATE TYPE community.media_kind AS ENUM ('photo', 'video');

CREATE TYPE finance.expense_context AS ENUM ('before_trip', 'on_trip', 'after_trip', 'planned');
CREATE TYPE finance.allocation_type AS ENUM ('equal', 'percent', 'fixed');

CREATE TYPE notification.delivery_status AS ENUM ('pending', 'sent', 'failed');

CREATE TYPE subscription.subscription_status AS ENUM (
  'trialing',
  'active',
  'past_due',
  'cancelled',
  'expired'
);
CREATE TYPE subscription.billing_period AS ENUM ('free', 'monthly', 'yearly');
CREATE TYPE subscription.payment_method AS ENUM ('credit_card', 'boleto', 'pix');
CREATE TYPE subscription.refund_reason AS ENUM ('trial', 'duplicate_charge');

CREATE TYPE ingestion.job_status AS ENUM ('pending', 'running', 'completed', 'failed', 'cancelled');
CREATE TYPE ingestion.item_status AS ENUM (
  'discovered',
  'processing',
  'ai_validated',
  'pending_review',
  'approved',
  'rejected',
  'published',
  'failed',
  'removal_requested',
  'removed'
);

CREATE TYPE moderation.decision_type AS ENUM ('approved', 'rejected', 'edited', 'escalated');
CREATE TYPE moderation.appeal_channel AS ENUM ('email');

CREATE TYPE platform.job_status AS ENUM ('pending', 'running', 'completed', 'failed');

-- ---------------------------------------------------------------------------
-- identity
-- ---------------------------------------------------------------------------

CREATE TABLE identity.users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar(255) NOT NULL,
  password_hash varchar(255),
  status identity.user_status NOT NULL DEFAULT 'pending',
  email_verified_at timestamptz,
  last_login_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CONSTRAINT users_email_unique UNIQUE (email),
  CONSTRAINT users_password_when_no_google CHECK (password_hash IS NULL OR length(password_hash) > 0)
);

COMMENT ON TABLE identity.users IS
  'Conta do app. Inativa não entra. Exclusão é lógica e pode ser restaurada. Convidado não é linha aqui.';

CREATE TABLE identity.user_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES identity.users (id),
  display_name varchar(120) NOT NULL,
  username varchar(80) NOT NULL,
  home_city_label varchar(150),
  country_id uuid,
  website_url text,
  bio varchar(150),
  avatar_storage_key text,
  visibility identity.profile_visibility NOT NULL DEFAULT 'public',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_profiles_username_check CHECK (
    char_length(username) BETWEEN 1 AND 80
    AND username ~ '^[[:alpha:][:digit:]._-]+$'
  )
);

CREATE UNIQUE INDEX user_profiles_username_lower_idx
  ON identity.user_profiles (lower(username));

COMMENT ON COLUMN identity.user_profiles.display_name IS
  'Um nome só, como a folha de editar perfil. Sem nome e sobrenome separados.';
COMMENT ON COLUMN identity.user_profiles.bio IS 'No máximo 150 caracteres (BUSINESS/34).';
COMMENT ON COLUMN identity.user_profiles.username IS
  'Único sem distinguir maiúscula. Letras, números, ponto, underline e hífen. O @ digitado no início é removido na API.';
COMMENT ON COLUMN identity.user_profiles.visibility IS
  'Público é o padrão. Privado só mostra o conteúdo de perfil para quem já segue. Seguir um privado cria pedido.';

CREATE TABLE identity.user_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  document_type identity.document_type NOT NULL,
  file_name varchar(255) NOT NULL,
  storage_key text NOT NULL,
  mime_type varchar(100) NOT NULL,
  byte_size integer NOT NULL,
  barcode_payload text,
  wallet_provider identity.wallet_provider,
  wallet_object_id varchar(255),
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CONSTRAINT user_documents_mime_check CHECK (
    mime_type IN ('image/jpeg', 'image/png', 'image/webp', 'application/pdf')
  ),
  CONSTRAINT user_documents_wallet_needs_code CHECK (
    wallet_provider IS NULL OR barcode_payload IS NOT NULL
  )
);

COMMENT ON TABLE identity.user_documents IS
  'Documento pessoal do perfil: CPF, CNH, passagem de ônibus ou de avião. Imagem ou PDF. Google Wallet ou Apple Wallet só quando o arquivo tem código de leitura.';

CREATE TABLE identity.user_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE REFERENCES identity.users (id),
  follow_device_locale boolean NOT NULL DEFAULT true,
  locale varchar(10) NOT NULL DEFAULT 'pt-BR',
  follow_device_currency boolean NOT NULL DEFAULT true,
  display_currency char(3) NOT NULL DEFAULT 'BRL',
  timezone varchar(60),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_preferences_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

COMMENT ON TABLE identity.user_preferences IS
  'Idioma e moeda. "Minha localização" é o padrão. A escolha explícita prevalece. Tema claro/noturno não fica aqui.';

CREATE TABLE identity.user_auth_providers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  provider identity.auth_provider NOT NULL,
  provider_user_id varchar(255) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_auth_providers_unique UNIQUE (provider, provider_user_id)
);

CREATE TABLE identity.user_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  family_id uuid NOT NULL,
  refresh_token_hash varchar(255) NOT NULL,
  keep_signed_in boolean NOT NULL DEFAULT true,
  access_tier identity.access_tier NOT NULL DEFAULT 'free',
  device_name varchar(150),
  ip_address varchar(45),
  expires_at timestamptz NOT NULL,
  consumed_at timestamptz,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_sessions_hash_unique UNIQUE (refresh_token_hash)
);

COMMENT ON TABLE identity.user_sessions IS
  'Refresh opaco, com hash. Rotação marca consumed_at e emite outra linha na mesma family_id. Reuso de hash consumido revoga a família. Access JWT de 15 min não é gravado. access_tier é a cópia Free ou PRO entregue ao app nesta sessão. A assinatura vigente é a fonte. Limites da Maya ainda não têm número.';

CREATE INDEX user_sessions_family_idx ON identity.user_sessions (family_id);
CREATE INDEX user_sessions_user_idx ON identity.user_sessions (user_id);

CREATE TABLE identity.user_verification_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  code_hash varchar(255) NOT NULL,
  purpose identity.verification_purpose NOT NULL,
  attempts integer NOT NULL DEFAULT 0,
  expires_at timestamptz NOT NULL,
  last_sent_at timestamptz NOT NULL DEFAULT now(),
  used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_verification_attempts_check CHECK (attempts >= 0 AND attempts <= 5)
);

COMMENT ON TABLE identity.user_verification_codes IS
  'Código de 4 dígitos, 10 minutos, 5 tentativas, reenvio depois de 30 segundos. Cadastro e senha nova. O código em claro não fica aqui.';

CREATE TABLE identity.user_handoff_codes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  code_hash varchar(255) NOT NULL,
  expires_at timestamptz NOT NULL,
  used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_handoff_codes_hash_unique UNIQUE (code_hash)
);

COMMENT ON TABLE identity.user_handoff_codes IS
  'Código opaco de uso único, 60 segundos, para abrir o site já autenticado. used_at queima o código. Access e refresh não vão na URL.';

CREATE TABLE identity.user_visited_countries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  country_id uuid NOT NULL,
  visit_source identity.visit_source NOT NULL DEFAULT 'manual',
  trip_id uuid,
  visited_at date,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_visited_countries_unique UNIQUE (user_id, country_id)
);

CREATE TABLE identity.user_visited_cities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  city_id uuid NOT NULL,
  visit_source identity.visit_source NOT NULL DEFAULT 'manual',
  trip_id uuid,
  visited_at date,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT user_visited_cities_unique UNIQUE (user_id, city_id)
);

COMMENT ON TABLE identity.user_visited_countries IS
  'Marca manual ou a viagem criada para aquele lugar. Um país por pessoa no mapa. A viagem também grava a cidade.';

-- ---------------------------------------------------------------------------
-- geography
-- ---------------------------------------------------------------------------

CREATE TABLE geography.continents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL,
  code varchar(10) UNIQUE
);

CREATE TABLE geography.countries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  continent_id uuid REFERENCES geography.continents (id),
  name varchar(150) NOT NULL,
  iso2 char(2) UNIQUE,
  iso3 char(3) UNIQUE,
  phone_code varchar(10),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE geography.regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id uuid NOT NULL REFERENCES geography.countries (id),
  name varchar(150) NOT NULL,
  region_type varchar(50)
);

CREATE TABLE geography.cities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id uuid NOT NULL REFERENCES geography.countries (id),
  region_id uuid REFERENCES geography.regions (id),
  name varchar(150) NOT NULL,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  timezone varchar(60),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX cities_country_idx ON geography.cities (country_id);

CREATE TABLE geography.geographic_aliases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type varchar(30) NOT NULL,
  entity_id uuid NOT NULL,
  alias varchar(200) NOT NULL,
  locale varchar(10),
  CONSTRAINT geographic_aliases_locale_check CHECK (locale IS NULL OR locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

CREATE TABLE geography.geographic_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type varchar(30) NOT NULL,
  entity_id uuid NOT NULL,
  locale varchar(10) NOT NULL,
  translated_name varchar(200) NOT NULL,
  CONSTRAINT geographic_translations_unique UNIQUE (entity_type, entity_id, locale),
  CONSTRAINT geographic_translations_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

ALTER TABLE identity.user_profiles
  ADD CONSTRAINT user_profiles_country_fk FOREIGN KEY (country_id) REFERENCES geography.countries (id);

ALTER TABLE identity.user_visited_countries
  ADD CONSTRAINT user_visited_countries_country_fk FOREIGN KEY (country_id) REFERENCES geography.countries (id);

ALTER TABLE identity.user_visited_cities
  ADD CONSTRAINT user_visited_cities_city_fk FOREIGN KEY (city_id) REFERENCES geography.cities (id);

-- ---------------------------------------------------------------------------
-- catalog
-- ---------------------------------------------------------------------------

CREATE TABLE catalog.place_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id uuid REFERENCES catalog.place_categories (id),
  slug varchar(120) NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE catalog.place_category_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL REFERENCES catalog.place_categories (id),
  locale varchar(10) NOT NULL,
  name varchar(120) NOT NULL,
  CONSTRAINT place_category_translations_unique UNIQUE (category_id, locale),
  CONSTRAINT place_category_translations_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

CREATE TABLE catalog.places (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  city_id uuid REFERENCES geography.cities (id),
  slug varchar(180) NOT NULL UNIQUE,
  name varchar(255) NOT NULL,
  description text,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  website_url text,
  phone varchar(50),
  status varchar(30) NOT NULL DEFAULT 'active',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT places_status_check CHECK (status IN ('active', 'archived'))
);

CREATE INDEX places_city_status_idx ON catalog.places (city_id, status);

CREATE TABLE catalog.place_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  locale varchar(10) NOT NULL,
  name varchar(255),
  description text,
  CONSTRAINT place_translations_unique UNIQUE (place_id, locale),
  CONSTRAINT place_translations_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

CREATE TABLE catalog.place_category_relations (
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  category_id uuid NOT NULL REFERENCES catalog.place_categories (id),
  PRIMARY KEY (place_id, category_id)
);

CREATE TABLE catalog.place_external_references (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  provider varchar(80) NOT NULL,
  external_id varchar(255) NOT NULL,
  external_url text,
  provider_metadata jsonb,
  last_synced_at timestamptz,
  CONSTRAINT place_external_references_unique UNIQUE (provider, external_id)
);

CREATE TABLE catalog.place_addresses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  line1 varchar(255),
  neighborhood varchar(150),
  postal_code varchar(20),
  city_id uuid REFERENCES geography.cities (id)
);

CREATE TABLE catalog.place_opening_hours (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  weekday smallint NOT NULL,
  opening_time time,
  closing_time time,
  is_closed boolean NOT NULL DEFAULT false,
  CONSTRAINT place_opening_hours_weekday_check CHECK (weekday BETWEEN 0 AND 6)
);

CREATE TABLE catalog.place_price_information (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  currency char(3),
  price_level smallint,
  minimum_price numeric(12, 2),
  maximum_price numeric(12, 2),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE catalog.place_visit_information (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  recommended_duration_minutes integer,
  best_time_to_visit text,
  accessibility_information text,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE catalog.place_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  media_type varchar(30) NOT NULL,
  storage_key text,
  external_url text,
  attribution text,
  sort_order integer,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT place_media_source_check CHECK (storage_key IS NOT NULL OR external_url IS NOT NULL)
);

COMMENT ON TABLE catalog.place_media IS
  'A busca do app lê só este catálogo. Arquivo de fora fica em quarentena até revisão humana. Quais fontes podem guardar o binário ainda não foi fechado.';

CREATE TABLE catalog.place_ratings_summary (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL UNIQUE REFERENCES catalog.places (id),
  average_rating numeric(3, 2),
  total_reviews integer NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE catalog.place_community_tips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  content text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- travel
-- ---------------------------------------------------------------------------

CREATE TABLE travel.trips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id uuid NOT NULL REFERENCES identity.users (id),
  title varchar(255) NOT NULL,
  description text,
  cover_storage_key text,
  start_date date,
  end_date date,
  duration_days integer,
  visibility travel.trip_visibility NOT NULL DEFAULT 'private',
  start_mode travel.trip_start_mode NOT NULL,
  source_itinerary_id uuid,
  adult_count integer NOT NULL DEFAULT 1,
  child_count integer NOT NULL DEFAULT 0,
  budget_amount numeric(14, 2),
  budget_currency char(3),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  is_active boolean NOT NULL DEFAULT true,
  CONSTRAINT trips_dates_or_duration CHECK (
    (start_date IS NULL AND end_date IS NULL AND duration_days IS NOT NULL)
    OR (start_date IS NOT NULL AND end_date IS NOT NULL AND end_date >= start_date)
  ),
  CONSTRAINT trips_duration_positive CHECK (duration_days IS NULL OR duration_days >= 1),
  CONSTRAINT trips_party_check CHECK (adult_count BETWEEN 1 AND 10 AND child_count BETWEEN 0 AND 10),
  CONSTRAINT trips_budget_pair CHECK (
    (budget_amount IS NULL AND budget_currency IS NULL)
    OR (budget_amount IS NOT NULL AND budget_currency IS NOT NULL AND budget_amount >= 0)
  )
);

COMMENT ON TABLE travel.trips IS
  'Status de cartão sai das datas. Não há status cancelada. Orçamento é um teto da viagem inteira. O teto de dias do calendário e o dos dias flexíveis ficam em platform.system_settings, porque o admin ajusta.';
COMMENT ON COLUMN travel.trips.is_active IS
  'O painel desliga a viagem. Desligada não abre no app até voltar a ativa.';
COMMENT ON COLUMN travel.trips.budget_amount IS
  'Teto da viagem toda, na moeda em que foi definido. Não há teto por categoria.';

CREATE INDEX trips_owner_idx ON travel.trips (owner_user_id, created_at);

CREATE TABLE travel.trip_destinations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  city_id uuid REFERENCES geography.cities (id),
  custom_name varchar(150),
  arrival_date date,
  departure_date date,
  sort_order integer NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_destinations_place_check CHECK (city_id IS NOT NULL OR custom_name IS NOT NULL)
);

COMMENT ON COLUMN travel.trip_destinations.custom_name IS
  'Destino digitado quando a busca não acha a cidade (BUSINESS/14).';

CREATE TABLE travel.trip_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  user_id uuid REFERENCES identity.users (id),
  display_name varchar(120) NOT NULL,
  party_kind travel.party_kind NOT NULL DEFAULT 'adult',
  role travel.participant_role,
  joined_at timestamptz,
  removed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_participants_adult_role CHECK (party_kind = 'child' OR role IS NOT NULL)
);

CREATE UNIQUE INDEX trip_participants_user_unique
  ON travel.trip_participants (trip_id, user_id)
  WHERE user_id IS NOT NULL AND removed_at IS NULL;

CREATE UNIQUE INDEX trip_participants_name_unique
  ON travel.trip_participants (trip_id, lower(display_name))
  WHERE removed_at IS NULL;

COMMENT ON TABLE travel.trip_participants IS
  'Cada adulto e cada criança contados nascem aqui com nome Viajante N, sem conta. O nome pode ser editado sem convite. Adulto contado nasce como supreme_traveler. O papel da criança sem conta não foi nomeado e fica nulo. Quem sai ou é removido preenche removed_at e deixa de ver a viagem. Dono e supremo removem. Experiente e supremo convidam. Só o dono passa a posse e altera papel.';

CREATE INDEX trip_participants_user_idx ON travel.trip_participants (user_id);

CREATE TABLE travel.trip_invitations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  participant_id uuid REFERENCES travel.trip_participants (id),
  invited_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  invited_email varchar(255) NOT NULL,
  invited_user_id uuid REFERENCES identity.users (id),
  channel travel.invitation_channel NOT NULL DEFAULT 'email',
  role travel.participant_role NOT NULL,
  status travel.invitation_status NOT NULL DEFAULT 'pending',
  accepted_at timestamptz,
  declined_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_invitations_role_check CHECK (role <> 'owner')
);

COMMENT ON TABLE travel.trip_invitations IS
  'Sempre destinado a um e-mail. Não expira. O passo 3 da viagem nova dispara o convite por e-mail, push e central. O papel desse convite ainda não foi nomeado: a coluna é obrigatória na gravação.';

CREATE TABLE travel.trip_invitation_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  invitation_id uuid NOT NULL UNIQUE REFERENCES travel.trip_invitations (id),
  token_hash varchar(255) NOT NULL,
  opened_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_invitation_tokens_hash_unique UNIQUE (token_hash)
);

COMMENT ON TABLE travel.trip_invitation_tokens IS
  'Link de uso único, sem prazo. Abrir o link ou aceitar o convite preenche opened_at e o mesmo link não serve para outra pessoa.';

CREATE TABLE travel.trip_ownership_transfers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  from_user_id uuid NOT NULL REFERENCES identity.users (id),
  to_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_ownership_transfers_distinct CHECK (from_user_id <> to_user_id)
);

COMMENT ON TABLE travel.trip_ownership_transfers IS
  'O dono passa a posse. A troca dos papéis fica em trip_participants.';

CREATE TABLE travel.trip_clones (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  original_trip_id uuid NOT NULL REFERENCES travel.trips (id),
  cloned_trip_id uuid NOT NULL REFERENCES travel.trips (id),
  cloned_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- itinerary
-- ---------------------------------------------------------------------------

CREATE TABLE itinerary.trip_itineraries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  version integer NOT NULL DEFAULT 1,
  title varchar(255),
  description text,
  is_active boolean NOT NULL DEFAULT false,
  created_by_user_id uuid REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT trip_itineraries_version_unique UNIQUE (trip_id, version)
);

ALTER TABLE travel.trips
  ADD CONSTRAINT trips_source_itinerary_fk
  FOREIGN KEY (source_itinerary_id) REFERENCES itinerary.trip_itineraries (id);

CREATE TABLE itinerary.itinerary_days (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  itinerary_id uuid NOT NULL REFERENCES itinerary.trip_itineraries (id),
  trip_destination_id uuid REFERENCES travel.trip_destinations (id),
  day_number integer NOT NULL,
  date date,
  title varchar(255),
  notes text,
  sort_order integer
);

CREATE TABLE itinerary.itinerary_stops (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  itinerary_day_id uuid NOT NULL REFERENCES itinerary.itinerary_days (id),
  place_id uuid REFERENCES catalog.places (id),
  title varchar(255),
  description text,
  start_time time,
  end_time time,
  duration_minutes integer,
  estimated_cost numeric(12, 2),
  estimated_currency char(3),
  sort_order integer NOT NULL,
  notes text,
  completed_at timestamptz,
  completed_by_user_id uuid REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON COLUMN itinerary.itinerary_stops.completed_at IS
  'Marca Feito no detalhe da parada. Desfazer zera completed_at.';

CREATE INDEX itinerary_stops_day_idx ON itinerary.itinerary_stops (itinerary_day_id, sort_order);

CREATE TABLE itinerary.itinerary_transfers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  itinerary_day_id uuid NOT NULL REFERENCES itinerary.itinerary_days (id),
  from_stop_id uuid REFERENCES itinerary.itinerary_stops (id),
  to_stop_id uuid REFERENCES itinerary.itinerary_stops (id),
  transport_type varchar(50),
  duration_seconds integer,
  distance_meters integer,
  geometry jsonb,
  provider_reference text,
  notes text
);

CREATE TABLE itinerary.itinerary_generation_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  requested_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  status itinerary.generation_status NOT NULL DEFAULT 'pending',
  input_data jsonb,
  error_message text,
  started_at timestamptz,
  finished_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON COLUMN itinerary.itinerary_generation_jobs.input_data IS
  'Interesses e ritmo do roteiro sugerido, ou o roteiro de comunidade copiado. Viagem acima de 14 dias não gera job.';

CREATE TABLE itinerary.itinerary_generation_results (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES itinerary.itinerary_generation_jobs (id),
  itinerary_id uuid REFERENCES itinerary.trip_itineraries (id),
  result_data jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE itinerary.itinerary_optimization_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  itinerary_id uuid NOT NULL REFERENCES itinerary.trip_itineraries (id),
  requested_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  status itinerary.generation_status NOT NULL DEFAULT 'pending',
  input_data jsonb,
  result_data jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);

-- ---------------------------------------------------------------------------
-- finance
-- ---------------------------------------------------------------------------

CREATE TABLE finance.currency_definitions (
  code char(3) PRIMARY KEY,
  name varchar(100) NOT NULL,
  symbol varchar(10),
  decimal_places smallint NOT NULL DEFAULT 2,
  is_display boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true
);

COMMENT ON COLUMN finance.currency_definitions.is_display IS
  'As dez moedas do perfil. O gasto pode usar qualquer moeda ativa.';

ALTER TABLE travel.trips
  ADD CONSTRAINT trips_budget_currency_fk
  FOREIGN KEY (budget_currency) REFERENCES finance.currency_definitions (code);

ALTER TABLE identity.user_visited_countries
  ADD CONSTRAINT user_visited_countries_trip_fk
  FOREIGN KEY (trip_id) REFERENCES travel.trips (id);

ALTER TABLE identity.user_visited_cities
  ADD CONSTRAINT user_visited_cities_trip_fk
  FOREIGN KEY (trip_id) REFERENCES travel.trips (id);

CREATE TABLE finance.expense_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL,
  slug varchar(100) NOT NULL UNIQUE,
  icon varchar(80) NOT NULL,
  legend_color char(7) NOT NULL,
  sort_order integer NOT NULL
);

COMMENT ON TABLE finance.expense_categories IS
  'As dez categorias de BUSINESS.md §4.6. Não é um catálogo livre.';

CREATE TABLE finance.exchange_rates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  base_currency char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  target_currency char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  exchange_rate numeric(20, 10) NOT NULL,
  provider varchar(100) NOT NULL DEFAULT 'frankfurter',
  rate_date date NOT NULL,
  fetched_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT exchange_rates_unique UNIQUE (base_currency, target_currency, rate_date)
);

COMMENT ON TABLE finance.exchange_rates IS
  'Uma tabela só. A fonte é Frankfurter. A taxa de uma data não é reescrita: o gasto continua no câmbio do dia em que foi lançado.';

CREATE TABLE finance.expenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  created_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  paid_by_participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  category_id uuid NOT NULL REFERENCES finance.expense_categories (id),
  title varchar(255) NOT NULL,
  description text,
  amount_original numeric(14, 2) NOT NULL,
  currency_original char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  fx_rate_date date NOT NULL,
  expense_date date,
  context finance.expense_context NOT NULL,
  is_estimate boolean NOT NULL DEFAULT false,
  receipt_storage_key text,
  receipt_mime varchar(100),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CONSTRAINT expenses_amount_positive CHECK (amount_original >= 0),
  CONSTRAINT expenses_receipt_mime_check CHECK (
    receipt_storage_key IS NULL
    OR receipt_mime IN ('image/jpeg', 'image/png', 'image/webp')
  )
);

COMMENT ON TABLE finance.expenses IS
  'Qualquer moeda ativa. A tela mostra a moeda do perfil e, ao lado, o valor original. fx_rate_date congela o câmbio daquele dia. Dá para editar e excluir. A foto do recibo é uma imagem.';

CREATE INDEX expenses_trip_date_idx ON finance.expenses (trip_id, expense_date);

CREATE TABLE finance.expense_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  expense_id uuid NOT NULL REFERENCES finance.expenses (id),
  participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  allocation_type finance.allocation_type NOT NULL DEFAULT 'equal',
  allocation_value numeric(14, 4),
  share_amount numeric(14, 2) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT expense_participants_unique UNIQUE (expense_id, participant_id),
  CONSTRAINT expense_participants_allocation_check CHECK (
    (allocation_type = 'equal' AND allocation_value IS NULL)
    OR (allocation_type = 'percent' AND allocation_value >= 0 AND allocation_value <= 100)
    OR (allocation_type = 'fixed' AND allocation_value >= 0)
  )
);

COMMENT ON TABLE finance.expense_participants IS
  'O padrão é igual. A pessoa pode trocar para percentual ou valor fixo. share_amount é o valor já ajustado na moeda original, e a soma fecha o gasto.';

CREATE TABLE finance.settlements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  payer_participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  receiver_participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  amount numeric(14, 2) NOT NULL,
  currency char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  settled_at timestamptz,
  undone_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT settlements_distinct_people CHECK (payer_participant_id <> receiver_participant_id)
);

COMMENT ON TABLE finance.settlements IS
  'Acerto não entra no total gasto nem nas categorias. Desfazer preenche undone_at.';

-- ---------------------------------------------------------------------------
-- organization
-- ---------------------------------------------------------------------------

CREATE TABLE organization.packing_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL,
  sort_order integer NOT NULL,
  is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE organization.packing_catalog_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid NOT NULL REFERENCES organization.packing_categories (id),
  name varchar(150) NOT NULL,
  description text,
  is_default boolean NOT NULL DEFAULT true,
  sort_order integer NOT NULL
);

COMMENT ON TABLE organization.packing_catalog_items IS
  'Os 30 nomes de BUSINESS/23. O admin edita esta lista. Viagem nova copia a lista ativa para a mala de cada pessoa.';

CREATE TABLE organization.trip_packing_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  catalog_item_id uuid REFERENCES organization.packing_catalog_items (id),
  category_id uuid NOT NULL REFERENCES organization.packing_categories (id),
  name varchar(150) NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  is_packed boolean NOT NULL DEFAULT false,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

COMMENT ON TABLE organization.trip_packing_items IS
  'Uma mala por pessoa. Ninguém vê a mala alheia, em papel nenhum, salvo quem esta pessoa autorizar. Dá para editar, remover um item e esvaziar a mala.';

CREATE TABLE organization.packing_list_viewers (
  owner_participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  viewer_participant_id uuid NOT NULL REFERENCES travel.trip_participants (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (owner_participant_id, viewer_participant_id),
  CONSTRAINT packing_list_viewers_distinct CHECK (owner_participant_id <> viewer_participant_id)
);

COMMENT ON TABLE organization.packing_list_viewers IS
  'Quem o dono da mala escolheu que pode ver. A lista nasce vazia.';

CREATE TABLE organization.shopping_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  created_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  name varchar(200) NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  estimated_price numeric(12, 2),
  currency char(3) REFERENCES finance.currency_definitions (code),
  store_name varchar(150),
  url text,
  is_purchased boolean NOT NULL DEFAULT false,
  expense_id uuid REFERENCES finance.expenses (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE organization.shopping_items IS
  'O item é da viagem, não de uma pessoa. Preço na moeda de exibição, já convertido. Ao marcar comprado, a pessoa pode abrir o gasto preenchido. expense_id fica quando ela salva esse gasto.';

CREATE TABLE organization.trip_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  uploaded_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  name varchar(255) NOT NULL,
  document_type varchar(80),
  storage_key text NOT NULL,
  mime_type varchar(100),
  file_size bigint,
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

COMMENT ON TABLE organization.trip_documents IS
  'Metadado. O arquivo está no storage. O painel não lê o conteúdo. Júnior e o público da viagem clonada não veem.';

CREATE TABLE organization.trip_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid NOT NULL REFERENCES travel.trips (id),
  created_by_user_id uuid NOT NULL REFERENCES identity.users (id),
  title varchar(255) NOT NULL,
  url text NOT NULL,
  description text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- community
-- ---------------------------------------------------------------------------

CREATE TABLE community.posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  content text,
  status community.content_status NOT NULL DEFAULT 'published',
  origin community.post_origin NOT NULL DEFAULT 'user',
  visibility community.audience NOT NULL DEFAULT 'public',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  published_at timestamptz,
  deleted_at timestamptz,
  CONSTRAINT posts_review_is_public CHECK (origin <> 'review' OR visibility = 'public')
);

COMMENT ON TABLE community.posts IS
  'Post criado pela pessoa pode ser público ou privado. Post nascido de avaliação é público. Legenda fica no idioma de quem escreveu.';

CREATE INDEX posts_user_created_idx ON community.posts (user_id, created_at);

CREATE TABLE community.post_places (
  post_id uuid NOT NULL REFERENCES community.posts (id),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  sort_order integer NOT NULL DEFAULT 0,
  PRIMARY KEY (post_id, place_id)
);

COMMENT ON TABLE community.post_places IS
  'Avaliação marca o lugar avaliado. Post da pessoa marca um ou mais lugares. Cidade e país não são marca à parte.';

CREATE TABLE community.post_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL REFERENCES community.posts (id),
  media_type community.media_kind NOT NULL,
  storage_key text NOT NULL,
  thumbnail_key text,
  width integer NOT NULL,
  height integer NOT NULL,
  duration_seconds integer,
  byte_size integer NOT NULL,
  is_cover boolean NOT NULL DEFAULT false,
  sort_order integer,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT post_media_photo_check CHECK (
    media_type <> 'photo'
    OR (
      byte_size <= 10485760
      AND width <= 1920
      AND height <= 1920
      AND duration_seconds IS NULL
    )
  ),
  CONSTRAINT post_media_video_check CHECK (
    media_type <> 'video'
    OR (
      duration_seconds BETWEEN 1 AND 60
      AND width <= 1920
      AND height <= 1920
    )
  )
);

CREATE UNIQUE INDEX post_media_one_cover_idx
  ON community.post_media (post_id)
  WHERE is_cover;

CREATE TABLE community.post_mentions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL REFERENCES community.posts (id),
  mentioned_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT post_mentions_unique UNIQUE (post_id, mentioned_user_id)
);

CREATE TABLE community.comments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL REFERENCES community.posts (id),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  parent_comment_id uuid REFERENCES community.comments (id),
  content varchar(500) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE community.post_likes (
  post_id uuid NOT NULL REFERENCES community.posts (id),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (post_id, user_id)
);

CREATE TABLE community.comment_likes (
  comment_id uuid NOT NULL REFERENCES community.comments (id),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (comment_id, user_id)
);

CREATE TABLE community.user_follows (
  follower_user_id uuid NOT NULL REFERENCES identity.users (id),
  followed_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (follower_user_id, followed_user_id),
  CONSTRAINT user_follows_not_self CHECK (follower_user_id <> followed_user_id)
);

CREATE TABLE community.user_follow_requests (
  requester_user_id uuid NOT NULL REFERENCES identity.users (id),
  target_user_id uuid NOT NULL REFERENCES identity.users (id),
  status community.follow_request_status NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz,
  PRIMARY KEY (requester_user_id, target_user_id),
  CONSTRAINT user_follow_requests_not_self CHECK (requester_user_id <> target_user_id)
);

COMMENT ON TABLE community.user_follow_requests IS
  'Perfil público segue direto. Perfil privado exige este pedido. Aceitar cria a linha em user_follows.';

CREATE TABLE community.user_blocks (
  blocker_user_id uuid NOT NULL REFERENCES identity.users (id),
  blocked_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (blocker_user_id, blocked_user_id),
  CONSTRAINT user_blocks_not_self CHECK (blocker_user_id <> blocked_user_id)
);

COMMENT ON TABLE community.user_blocks IS
  'Mútuo e silencioso na leitura. Bloquear também deixa de seguir. A pessoa bloqueada não é avisada.';

CREATE TABLE community.user_mutes (
  muter_user_id uuid NOT NULL REFERENCES identity.users (id),
  muted_user_id uuid NOT NULL REFERENCES identity.users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (muter_user_id, muted_user_id),
  CONSTRAINT user_mutes_not_self CHECK (muter_user_id <> muted_user_id)
);

CREATE TABLE community.saved_posts (
  user_id uuid NOT NULL REFERENCES identity.users (id),
  post_id uuid NOT NULL REFERENCES community.posts (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, post_id)
);

CREATE TABLE community.place_reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id uuid NOT NULL REFERENCES catalog.places (id),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  post_id uuid UNIQUE REFERENCES community.posts (id),
  rating smallint NOT NULL,
  review_text varchar(500),
  status community.content_status NOT NULL DEFAULT 'published',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT place_reviews_rating_check CHECK (rating BETWEEN 1 AND 5)
);

COMMENT ON TABLE community.place_reviews IS
  'Nota de 1 a 5 e ao menos uma foto ou vídeo. A mesma pessoa pode avaliar o mesmo lugar de novo. Cada avaliação nasce como post público do lugar avaliado.';

CREATE TABLE community.place_review_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  review_id uuid NOT NULL REFERENCES community.place_reviews (id),
  media_type community.media_kind NOT NULL,
  storage_key text NOT NULL,
  width integer NOT NULL,
  height integer NOT NULL,
  duration_seconds integer,
  byte_size integer NOT NULL,
  is_cover boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT review_media_photo_check CHECK (
    media_type <> 'photo'
    OR (
      byte_size <= 10485760
      AND width <= 1920
      AND height <= 1920
      AND duration_seconds IS NULL
    )
  ),
  CONSTRAINT review_media_video_check CHECK (
    media_type <> 'video'
    OR (
      duration_seconds BETWEEN 1 AND 60
      AND width <= 1920
      AND height <= 1920
    )
  )
);

CREATE UNIQUE INDEX review_media_one_cover_idx
  ON community.place_review_media (review_id)
  WHERE is_cover;

-- Um nível de resposta: o pai não pode ser ele mesmo uma resposta.
CREATE OR REPLACE FUNCTION community.comment_one_level()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF NEW.parent_comment_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1
      FROM community.comments parent
      WHERE parent.id = NEW.parent_comment_id
        AND parent.parent_comment_id IS NOT NULL
    ) THEN
      RAISE EXCEPTION 'comentario so tem um nivel de resposta';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER comments_one_level
  BEFORE INSERT OR UPDATE OF parent_comment_id
  ON community.comments
  FOR EACH ROW
  EXECUTE FUNCTION community.comment_one_level();

-- ---------------------------------------------------------------------------
-- notification
-- ---------------------------------------------------------------------------

CREATE TABLE notification.notification_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type varchar(100) NOT NULL,
  locale varchar(10) NOT NULL,
  channel varchar(30) NOT NULL,
  title_template varchar(255),
  body_template text,
  is_active boolean NOT NULL DEFAULT true,
  CONSTRAINT notification_templates_unique UNIQUE (event_type, locale, channel),
  CONSTRAINT notification_templates_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es')),
  CONSTRAINT notification_templates_channel_check CHECK (channel IN ('in_app', 'push', 'email'))
);

CREATE TABLE notification.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  event_type varchar(100) NOT NULL,
  title varchar(255) NOT NULL,
  message text,
  payload jsonb,
  read_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE notification.notifications IS
  'Central do app. Toda notificação de produto também sai em push. Não há preferência por tipo: a pessoa recebe todas.';

CREATE INDEX notifications_user_idx ON notification.notifications (user_id, created_at);

CREATE TABLE notification.notification_deliveries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  notification_id uuid NOT NULL REFERENCES notification.notifications (id),
  channel varchar(30) NOT NULL,
  status notification.delivery_status NOT NULL DEFAULT 'pending',
  provider_message_id varchar(255),
  error_message text,
  sent_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT notification_deliveries_channel_check CHECK (channel IN ('in_app', 'push', 'email'))
);

CREATE TABLE notification.notification_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  notification_id uuid REFERENCES notification.notifications (id),
  event_type varchar(100) NOT NULL,
  detail jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE notification.device_push_tokens (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  device_id varchar(255),
  platform varchar(30) NOT NULL,
  push_token text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  last_used_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE notification.device_push_tokens IS
  'O provedor de push ainda é A DEFINIR. A tabela guarda o token do aparelho, não escolhe o fornecedor.';

-- ---------------------------------------------------------------------------
-- subscription
-- ---------------------------------------------------------------------------

CREATE TABLE subscription.plans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code varchar(80) NOT NULL UNIQUE,
  name varchar(120) NOT NULL,
  description text,
  is_free boolean NOT NULL DEFAULT false,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE subscription.plan_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id uuid NOT NULL REFERENCES subscription.plans (id),
  locale varchar(10) NOT NULL,
  name varchar(120),
  description text,
  CONSTRAINT plan_translations_unique UNIQUE (plan_id, locale),
  CONSTRAINT plan_translations_locale_check CHECK (locale IN ('pt-BR', 'pt-PT', 'en', 'es'))
);

CREATE TABLE subscription.plan_features (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id uuid NOT NULL REFERENCES subscription.plans (id),
  feature_key varchar(100) NOT NULL,
  feature_value jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT plan_features_unique UNIQUE (plan_id, feature_key)
);

CREATE TABLE subscription.plan_prices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plan_id uuid NOT NULL REFERENCES subscription.plans (id),
  currency char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  billing_period subscription.billing_period NOT NULL,
  duration_days integer,
  amount numeric(12, 2) NOT NULL,
  provider_price_id varchar(255),
  is_active boolean NOT NULL DEFAULT true,
  CONSTRAINT plan_prices_amount_check CHECK (amount >= 0)
);

CREATE TABLE subscription.coupons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code varchar(80) NOT NULL UNIQUE,
  free_days integer NOT NULL,
  valid_until date,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT coupons_days_positive CHECK (free_days > 0)
);

CREATE TABLE subscription.promo_grants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  granted_by_admin_id uuid,
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT promo_grants_thirty_days CHECK (ends_at = starts_at + interval '30 days')
);

COMMENT ON TABLE subscription.promo_grants IS
  '30 dias de PRO sem cobrança e sem fatura na Asaas. Não soma com cupom: vale o benefício que vence por último.';

CREATE TABLE subscription.user_subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  plan_id uuid NOT NULL REFERENCES subscription.plans (id),
  plan_price_id uuid REFERENCES subscription.plan_prices (id),
  coupon_id uuid REFERENCES subscription.coupons (id),
  promo_grant_id uuid REFERENCES subscription.promo_grants (id),
  status subscription.subscription_status NOT NULL,
  provider varchar(80),
  provider_subscription_id varchar(255),
  started_at timestamptz,
  current_period_start timestamptz,
  current_period_end timestamptz,
  cancel_at_period_end boolean NOT NULL DEFAULT false,
  cancelled_at timestamptz,
  refunded_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON COLUMN subscription.user_subscriptions.provider IS
  'Asaas, quando houve cobrança. Cupom e PRO promocional não têm identificador na Asaas.';

CREATE TABLE subscription.subscription_payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id uuid NOT NULL REFERENCES subscription.user_subscriptions (id),
  provider_payment_id varchar(255),
  amount numeric(12, 2) NOT NULL,
  currency char(3) NOT NULL REFERENCES finance.currency_definitions (code),
  status varchar(40) NOT NULL,
  paid_at timestamptz,
  refunded_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE subscription.subscription_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id uuid REFERENCES subscription.user_subscriptions (id),
  provider varchar(80) NOT NULL,
  event_type varchar(100) NOT NULL,
  provider_event_id varchar(255),
  payload jsonb,
  processed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE subscription.subscription_events IS
  'Webhook. A assinatura do webhook da Asaas é validada na API antes de gravar efeito.';

CREATE TABLE subscription.refunds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  subscription_id uuid NOT NULL REFERENCES subscription.user_subscriptions (id),
  payment_id uuid REFERENCES subscription.subscription_payments (id),
  approved_by_admin_id uuid,
  status varchar(40) NOT NULL,
  provider_refund_id varchar(255),
  reason subscription.refund_reason NOT NULL,
  failure_reason text,
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);

COMMENT ON TABLE subscription.refunds IS
  'Cupom e PRO promocional não são estornáveis. trial cabe até 7 dias depois do teste. duplicate_charge cabe na janela de 60 dias do painel.';

CREATE TABLE subscription.payment_method_settings (
  method subscription.payment_method PRIMARY KEY,
  is_enabled boolean NOT NULL DEFAULT true,
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE subscription.payment_method_settings IS
  'Cartão, boleto e Pix. O último método ligado não desliga. O app não cobra.';

-- ---------------------------------------------------------------------------
-- maya
-- ---------------------------------------------------------------------------

CREATE TABLE maya.maya_conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  trip_id uuid REFERENCES travel.trips (id),
  title varchar(255),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE maya.maya_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES maya.maya_conversations (id),
  role varchar(30) NOT NULL,
  content text NOT NULL,
  model varchar(100),
  input_tokens integer,
  output_tokens integer,
  latency_ms integer,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT maya_messages_role_check CHECK (role IN ('user', 'assistant'))
);

CREATE TABLE maya.maya_usage (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  conversation_id uuid REFERENCES maya.maya_conversations (id),
  model varchar(100),
  input_tokens integer,
  output_tokens integer,
  estimated_cost numeric(12, 6),
  currency char(3),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE maya.maya_model_configs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider varchar(100) NOT NULL,
  model_name varchar(150) NOT NULL,
  configuration jsonb,
  is_active boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE maya.maya_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES identity.users (id),
  conversation_id uuid REFERENCES maya.maya_conversations (id),
  message_id uuid REFERENCES maya.maya_messages (id),
  rating smallint,
  feedback_text text,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT maya_feedback_rating_check CHECK (rating IS NULL OR rating BETWEEN 1 AND 5)
);

COMMENT ON TABLE maya.maya_messages IS
  'Texto e atalho. Não há caso de uso que grave viagem, gasto ou roteiro a partir daqui. Modelo e limite Free/PRO ainda são A DEFINIR.';

-- ---------------------------------------------------------------------------
-- admin  (antes de ingestão e moderação, que apontam para administrador)
-- ---------------------------------------------------------------------------

CREATE TABLE admin.admin_users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(120) NOT NULL,
  email varchar(255) NOT NULL UNIQUE,
  password_hash varchar(255) NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  last_login_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

COMMENT ON TABLE admin.admin_users IS
  'Conta própria do painel, com nome, e-mail e senha. Não entra no app e não é uma linha de identity.users.';

CREATE TABLE admin.admin_roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL UNIQUE,
  description text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE admin.admin_permissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  permission_key varchar(150) NOT NULL UNIQUE,
  description text
);

CREATE TABLE admin.admin_user_roles (
  admin_user_id uuid NOT NULL REFERENCES admin.admin_users (id),
  role_id uuid NOT NULL REFERENCES admin.admin_roles (id),
  PRIMARY KEY (admin_user_id, role_id)
);

CREATE TABLE admin.admin_role_permissions (
  role_id uuid NOT NULL REFERENCES admin.admin_roles (id),
  permission_id uuid NOT NULL REFERENCES admin.admin_permissions (id),
  PRIMARY KEY (role_id, permission_id)
);

COMMENT ON TABLE admin.admin_roles IS
  'Os sete nomes estão previstos. A matriz ainda é A DEFINIR. Até lá, administrador ativo executa todas as funções e estas tabelas não restringem.';

CREATE TABLE admin.admin_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id uuid NOT NULL REFERENCES admin.admin_users (id),
  token_hash varchar(255) NOT NULL,
  ip_address varchar(45),
  expires_at timestamptz NOT NULL,
  revoked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE admin.admin_audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id uuid REFERENCES admin.admin_users (id),
  action varchar(150) NOT NULL,
  entity_type varchar(100),
  entity_id uuid,
  old_values jsonb,
  new_values jsonb,
  ip_address varchar(45),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX admin_audit_logs_actor_idx ON admin.admin_audit_logs (admin_user_id, created_at);

CREATE TABLE admin.admin_login_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar(255) NOT NULL,
  ip_address varchar(45),
  successful boolean NOT NULL,
  attempted_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE subscription.promo_grants
  ADD CONSTRAINT promo_grants_admin_fk
  FOREIGN KEY (granted_by_admin_id) REFERENCES admin.admin_users (id);

ALTER TABLE subscription.refunds
  ADD CONSTRAINT refunds_admin_fk
  FOREIGN KEY (approved_by_admin_id) REFERENCES admin.admin_users (id);

-- ---------------------------------------------------------------------------
-- ingestion
-- ---------------------------------------------------------------------------

CREATE TABLE ingestion.content_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(150) NOT NULL,
  source_type varchar(50) NOT NULL,
  base_url text,
  provider varchar(100),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ingestion.content_source_policies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid NOT NULL REFERENCES ingestion.content_sources (id),
  license_label varchar(80) NOT NULL DEFAULT 'unknown',
  terms_url text,
  attribution_required boolean NOT NULL DEFAULT false,
  can_store boolean NOT NULL DEFAULT false,
  can_republish boolean NOT NULL DEFAULT false,
  can_embed boolean NOT NULL DEFAULT false,
  rate_limit_per_minute integer,
  valid_from date,
  valid_until date,
  reviewed_at timestamptz,
  reviewed_by_admin_id uuid REFERENCES admin.admin_users (id),
  notes text
);

COMMENT ON COLUMN ingestion.content_source_policies.license_label IS
  'Quais fontes autorizam guardar e republicar o arquivo ainda é A DEFINIR. O padrão não autoriza.';

CREATE TABLE ingestion.ingestion_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid NOT NULL REFERENCES ingestion.content_sources (id),
  status ingestion.job_status NOT NULL DEFAULT 'pending',
  job_type varchar(80),
  started_at timestamptz,
  finished_at timestamptz,
  items_collected integer NOT NULL DEFAULT 0,
  items_failed integer NOT NULL DEFAULT 0,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ingestion.ingestion_job_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id uuid NOT NULL REFERENCES ingestion.ingestion_jobs (id),
  external_item_id varchar(255),
  status ingestion.item_status NOT NULL DEFAULT 'discovered',
  error_message text,
  processed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ingestion.ingestion_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid NOT NULL REFERENCES ingestion.content_sources (id),
  external_id varchar(255),
  place_id uuid REFERENCES catalog.places (id),
  title varchar(255),
  description text,
  original_url text,
  status ingestion.item_status NOT NULL DEFAULT 'discovered',
  content_hash varchar(255),
  collected_at timestamptz,
  reviewed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ingestion_items_status_idx ON ingestion.ingestion_items (status, source_id, created_at);

CREATE TABLE ingestion.ingestion_item_media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  media_type varchar(30),
  original_url text,
  storage_key text,
  license_label varchar(80) NOT NULL DEFAULT 'unknown',
  attribution text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ingestion.ingestion_item_metadata (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  metadata_key varchar(100) NOT NULL,
  metadata_value jsonb
);

CREATE TABLE ingestion.content_licenses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  license_name varchar(150),
  license_url text,
  license_label varchar(80) NOT NULL DEFAULT 'unknown',
  attribution_text text,
  evidence_url text,
  verified_at timestamptz,
  expires_at timestamptz
);

CREATE TABLE ingestion.content_ai_validations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  model varchar(100),
  relevance_score numeric(5, 4),
  quality_score numeric(5, 4),
  duplicate_score numeric(5, 4),
  place_match_score numeric(5, 4),
  result jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ingestion.content_provenance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  source_url text,
  source_name varchar(150),
  collected_at timestamptz,
  attribution text,
  license_evidence text,
  metadata jsonb
);

-- ---------------------------------------------------------------------------
-- moderation
-- ---------------------------------------------------------------------------

CREATE TABLE moderation.report_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL,
  description text,
  is_active boolean NOT NULL DEFAULT true
);

CREATE TABLE moderation.user_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporter_user_id uuid NOT NULL REFERENCES identity.users (id),
  reported_user_id uuid REFERENCES identity.users (id),
  post_id uuid REFERENCES community.posts (id),
  comment_id uuid REFERENCES community.comments (id),
  review_id uuid REFERENCES community.place_reviews (id),
  category_id uuid REFERENCES moderation.report_categories (id),
  description text,
  status community.report_status NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);

CREATE TABLE moderation.content_review_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid REFERENCES ingestion.ingestion_items (id),
  report_id uuid REFERENCES moderation.user_reports (id),
  assigned_admin_id uuid REFERENCES admin.admin_users (id),
  status varchar(30) NOT NULL DEFAULT 'pending',
  priority varchar(20) NOT NULL DEFAULT 'normal',
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  CONSTRAINT content_review_tasks_target_check CHECK (ingestion_item_id IS NOT NULL OR report_id IS NOT NULL)
);

CREATE INDEX content_review_tasks_status_idx ON moderation.content_review_tasks (status, priority);

CREATE TABLE moderation.content_review_decisions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id uuid NOT NULL REFERENCES moderation.content_review_tasks (id),
  admin_user_id uuid NOT NULL REFERENCES admin.admin_users (id),
  decision moderation.decision_type NOT NULL,
  reason text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE moderation.content_publications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid NOT NULL REFERENCES ingestion.ingestion_items (id),
  place_id uuid REFERENCES catalog.places (id),
  published_by_admin_id uuid REFERENCES admin.admin_users (id),
  published_at timestamptz,
  removed_at timestamptz,
  removal_reason text
);

CREATE TABLE moderation.content_removal_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingestion_item_id uuid REFERENCES ingestion.ingestion_items (id),
  publication_id uuid REFERENCES moderation.content_publications (id),
  requester_email varchar(255),
  reason text,
  status varchar(30) NOT NULL DEFAULT 'pending',
  created_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz
);

CREATE TABLE moderation.moderation_actions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id uuid NOT NULL REFERENCES admin.admin_users (id),
  target_user_id uuid REFERENCES identity.users (id),
  target_content_type varchar(50),
  target_content_id uuid,
  action_type varchar(80) NOT NULL,
  reason text,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE moderation.moderation_appeals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  moderation_action_id uuid NOT NULL REFERENCES moderation.moderation_actions (id),
  user_id uuid REFERENCES identity.users (id),
  requester_email varchar(255) NOT NULL,
  channel moderation.appeal_channel NOT NULL DEFAULT 'email',
  reason text,
  status varchar(30) NOT NULL DEFAULT 'pending',
  reviewed_by_admin_id uuid REFERENCES admin.admin_users (id),
  created_at timestamptz NOT NULL DEFAULT now(),
  reviewed_at timestamptz
);

COMMENT ON TABLE moderation.moderation_appeals IS
  'Recurso só por e-mail. Não há fila no app. O prazo máximo da denúncia ainda não foi dito.';

-- ---------------------------------------------------------------------------
-- integration
-- ---------------------------------------------------------------------------

CREATE TABLE integration.external_provider_accounts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider varchar(100) NOT NULL,
  account_name varchar(150),
  credentials_reference text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON COLUMN integration.external_provider_accounts.credentials_reference IS
  'Referência ao segredo, nunca o segredo em texto puro.';

CREATE TABLE integration.external_sync_jobs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider_account_id uuid NOT NULL REFERENCES integration.external_provider_accounts (id),
  sync_type varchar(80),
  status platform.job_status NOT NULL DEFAULT 'pending',
  started_at timestamptz,
  finished_at timestamptz,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE integration.external_references (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type varchar(80) NOT NULL,
  entity_id uuid NOT NULL,
  provider varchar(100) NOT NULL,
  external_id varchar(255) NOT NULL,
  external_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT external_references_unique UNIQUE (entity_type, entity_id, provider)
);

COMMENT ON TABLE integration.external_references IS
  'Referência que não é lugar. Lugar fica em catalog.place_external_references. Câmbio fica em finance.exchange_rates.';

CREATE TABLE integration.integration_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider varchar(100) NOT NULL,
  operation varchar(150),
  status varchar(30),
  request_id varchar(255),
  response_code integer,
  error_message text,
  duration_ms integer,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- platform
-- ---------------------------------------------------------------------------

CREATE TABLE platform.outbox_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  aggregate_type varchar(100) NOT NULL,
  aggregate_id uuid NOT NULL,
  event_type varchar(150) NOT NULL,
  payload jsonb NOT NULL,
  published_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE platform.outbox_events IS
  'Gravado na mesma transação do negócio. Nome de tópico, contrato e retentativa ainda são A DEFINIR.';

CREATE TABLE platform.processed_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  consumer_name varchar(150) NOT NULL,
  event_id uuid NOT NULL,
  processed_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT processed_events_unique UNIQUE (consumer_name, event_id)
);

CREATE TABLE platform.idempotency_keys (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  idempotency_key varchar(255) NOT NULL UNIQUE,
  scope varchar(150),
  response_status integer,
  response_body jsonb,
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE platform.scheduled_job_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_name varchar(150) NOT NULL,
  status platform.job_status NOT NULL DEFAULT 'pending',
  started_at timestamptz,
  finished_at timestamptz,
  result jsonb,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE platform.scheduled_job_runs IS
  'Inclui a expiração diária de assinatura. Essa expiração não é fila Kafka.';

CREATE TABLE platform.system_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key varchar(150) NOT NULL UNIQUE,
  setting_value jsonb,
  description text,
  updated_by_admin_id uuid REFERENCES admin.admin_users (id),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE platform.feature_flags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  flag_key varchar(150) NOT NULL UNIQUE,
  description text,
  is_enabled boolean NOT NULL DEFAULT false,
  configuration jsonb,
  updated_by_admin_id uuid REFERENCES admin.admin_users (id),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------------
-- Seeds do que o negócio já nomeou
-- ---------------------------------------------------------------------------

INSERT INTO finance.currency_definitions (code, name, symbol, decimal_places, is_display) VALUES
  ('BRL', 'Real brasileiro', 'R$', 2, true),
  ('USD', 'Dólar americano', 'US$', 2, true),
  ('GBP', 'Libra esterlina', '£', 2, true),
  ('CAD', 'Dólar canadense', 'C$', 2, true),
  ('AUD', 'Dólar australiano', 'A$', 2, true),
  ('EUR', 'Euro', '€', 2, true),
  ('MXN', 'Peso mexicano', 'MX$', 2, true),
  ('CHF', 'Franco suíço', 'CHF', 2, true),
  ('CNY', 'Yuan chinês', 'CN¥', 2, true),
  ('JPY', 'Iene japonês', '¥', 0, true),
  ('BGN', 'Lev búlgaro', 'BGN', 2, false),
  ('CZK', 'Coroa checa', 'Kč', 2, false),
  ('DKK', 'Coroa dinamarquesa', 'kr', 2, false),
  ('HKD', 'Dólar de Hong Kong', 'HK$', 2, false),
  ('HUF', 'Florim húngaro', 'Ft', 0, false),
  ('IDR', 'Rupia indonésia', 'Rp', 0, false),
  ('ILS', 'Novo shekel', '₪', 2, false),
  ('INR', 'Rupia indiana', '₹', 2, false),
  ('ISK', 'Coroa islandesa', 'kr', 0, false),
  ('KRW', 'Won sul-coreano', '₩', 0, false),
  ('MYR', 'Ringgit', 'RM', 2, false),
  ('NOK', 'Coroa norueguesa', 'kr', 2, false),
  ('NZD', 'Dólar neozelandês', 'NZ$', 2, false),
  ('PHP', 'Peso filipino', '₱', 2, false),
  ('PLN', 'Zloty', 'zł', 2, false),
  ('RON', 'Leu romeno', 'lei', 2, false),
  ('SEK', 'Coroa sueca', 'kr', 2, false),
  ('SGD', 'Dólar de Singapura', 'S$', 2, false),
  ('THB', 'Baht', '฿', 2, false),
  ('TRY', 'Lira turca', '₺', 2, false),
  ('ZAR', 'Rand', 'R', 2, false);

INSERT INTO finance.expense_categories (name, slug, icon, legend_color, sort_order) VALUES
  ('Hospedagem', 'hospedagem', 'bed', '#2B207F', 1),
  ('Transporte', 'transporte', 'plane', '#6A5CE0', 2),
  ('Alimentação', 'alimentacao', 'cutlery', '#A89BFF', 3),
  ('Atividades', 'atividades', 'ticket', '#C9FF27', 4),
  ('Passeios', 'passeios', 'compass', '#7CC243', 5),
  ('Compras', 'compras', 'cart', '#F2B84B', 6),
  ('Transporte local', 'transporte-local', 'bus', '#5BC0EB', 7),
  ('Saúde', 'saude', 'cross', '#FF8A5B', 8),
  ('Comunicação', 'comunicacao', 'wifi', '#2FA88A', 9),
  ('Outros', 'outros', 'dots', '#A6A2BC', 10);

INSERT INTO organization.packing_categories (name, sort_order) VALUES
  ('Documentos', 1),
  ('Roupas', 2),
  ('Cuidados pessoais', 3),
  ('Eletrônicos', 4),
  ('Farmácia', 5),
  ('Acessórios', 6),
  ('Outros', 7);

INSERT INTO organization.packing_catalog_items (category_id, name, sort_order)
SELECT c.id, item.name, item.sort_order
FROM organization.packing_categories c
JOIN (
  VALUES
    ('Documentos', 'RG ou CNH', 1),
    ('Documentos', 'Passaporte', 2),
    ('Documentos', 'Cartão de crédito/débito', 3),
    ('Roupas', 'Camisetas', 1),
    ('Roupas', 'Calças', 2),
    ('Roupas', 'Roupa íntima', 3),
    ('Roupas', 'Tênis/Sapatos confortáveis', 4),
    ('Roupas', 'Meias', 5),
    ('Roupas', 'Jaqueta/Casaco', 6),
    ('Roupas', 'Gorro e cachecol', 7),
    ('Cuidados pessoais', 'Escova de dentes', 1),
    ('Cuidados pessoais', 'Pasta de dentes', 2),
    ('Cuidados pessoais', 'Shampoo', 3),
    ('Cuidados pessoais', 'Desodorante', 4),
    ('Cuidados pessoais', 'Hidratante', 5),
    ('Eletrônicos', 'Celular', 1),
    ('Eletrônicos', 'Carregador de celular', 2),
    ('Eletrônicos', 'Power bank', 3),
    ('Eletrônicos', 'Fone de ouvido', 4),
    ('Eletrônicos', 'Adaptador de tomada', 5),
    ('Farmácia', 'Analgésicos', 1),
    ('Farmácia', 'Medicamentos de uso contínuo', 2),
    ('Farmácia', 'Band-aid', 3),
    ('Acessórios', 'Mochila pequena', 1),
    ('Acessórios', 'Garrafa de água', 2),
    ('Acessórios', 'Cadeado', 3),
    ('Acessórios', 'Guarda-chuva', 4),
    ('Outros', 'Almofada de pescoço', 1),
    ('Outros', 'Saco de roupa suja', 2),
    ('Outros', 'Lanches', 3)
) AS item(category_name, name, sort_order) ON c.name = item.category_name;

INSERT INTO moderation.report_categories (name) VALUES
  ('Spam ou golpe'),
  ('Conteúdo enganoso sobre um lugar'),
  ('Assédio ou discurso de ódio'),
  ('Conteúdo impróprio'),
  ('Perfil falso'),
  ('Outro motivo');

INSERT INTO subscription.plans (code, name, description, is_free, is_active) VALUES
  ('free', 'Free', 'Plano inicial. Não se desativa e não se exclui.', true, true),
  ('pro', 'PRO', 'Plano pago. Sem preço até o admin gravar. Limites da Maya ainda não têm número.', false, false);

INSERT INTO subscription.payment_method_settings (method, is_enabled) VALUES
  ('credit_card', true),
  ('boleto', true),
  ('pix', true);

INSERT INTO platform.system_settings (setting_key, setting_value, description) VALUES
  ('refund_window_days', '60', 'Janela do painel para estornar cobrança duplicada. O admin pode mudar, de 1 a 365.'),
  ('trial_refund_days', '7', 'Estorno comum só até 7 dias depois do teste gratuito.'),
  ('handoff_ttl_seconds', '60', 'Código que abre o site a partir do app. Uso único.'),
  ('refresh_keep_signed_in_days', '30', 'Sessão com manter conectado.'),
  ('refresh_session_days', '1', 'Sessão sem manter conectado.'),
  ('trip_calendar_max_days', '92', 'Teto do calendário, cerca de 3 meses. O admin ajusta.'),
  ('trip_flexible_max_days', '30', 'Teto dos dias flexíveis. O admin ajusta. O valor de partida continua 30.');

INSERT INTO ingestion.content_sources (name, source_type, provider, is_active) VALUES
  ('Google Places', 'place', 'google_places', false),
  ('TikTok', 'video', 'tiktok', false),
  ('YouTube', 'video', 'youtube', false),
  ('Pixabay', 'image', 'pixabay', false),
  ('Unsplash', 'image', 'unsplash', false),
  ('Pexels', 'image', 'pexels', false);

INSERT INTO ingestion.content_source_policies (source_id, license_label, can_store, can_republish, notes)
SELECT id, 'unknown', false, false, 'Candidata. Ainda não autorizada a guardar nem republicar arquivo.'
FROM ingestion.content_sources;
