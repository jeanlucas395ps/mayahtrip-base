# Painel — Visão de negócio

Fonte da verdade do painel interno do MayahTrip. Cada funcionalidade tem um arquivo numerado nesta pasta. O app do viajante continua em `BUSINESS/`. A stack está em `ARCHITECTURE.md`.

O painel não é um segundo app. Quem viaja não entra aqui. Quem entra é um **administrador**: conta própria, com nome, e-mail e senha, separada da conta do app.

## 1. Para que existe

Operar a plataforma: ver o que está acontecendo, cuidar de contas e viagens, cobrar o PRO, moderar a comunidade e saber se a infraestrutura e as filas estão de pé.

## 2. Acesso

- Login com e-mail e senha de administrador.
- Conta inativa não entra.
- A interface usa os quatro idiomas do produto: Português (Brasil), Português (Portugal), English e Español.
- O painel fala só com a API. Não chama Asaas, Google, OpenAI, banco, Redis, storage nem Kafka a partir do browser.

## 3. Regras globais

- A autorização do painel será por papel e permissão explícita, para granularidade futura. Os papéis previstos e a regra estão em `TECH/TECH.md`.
- A matriz de qual papel executa qual função desta pasta é `A DEFINIR`.
- Enquanto essa matriz não existir, administrador ativo enxerga e executa todas as funções desta pasta.
- Excluir usuário do app é exclusão lógica. Dá para restaurar.
- A Maya, qualquer que seja o agente configurado, não grava viagem, gasto nem roteiro.
- Denúncia procedente pode remover conteúdo e desativar a conta. O denunciante recebe o resultado no app e no push.
- Documento de viagem (passaporte e afins) não aparece no painel.
- Log de chamada externa não mostra senha, token, documento nem corpo de e-mail.
- Item marcado `A DEFINIR` não vira comportamento no código.

## 4. Índice

| Nº | Arquivo | Função |
| --- | --- | --- |
| 01 | `01-dashboard.md` | Totais, gráficos e saúde da fila |
| 02 | `02-administradores.md` | Contas do painel |
| 03 | `03-viagens.md` | Lista e ações sobre viagens |
| 04 | `04-usuarios.md` | Usuários do app |
| 05 | `05-pro-promocional.md` | 30 dias de PRO sem cobrança |
| 06 | `06-maya.md` | Agentes da Maya |
| 07 | `07-dashboard-financeiro.md` | Receita e assinaturas |
| 08 | `08-planos.md` | Planos e features |
| 09 | `09-cupons.md` | Período grátis |
| 10 | `10-pagamentos.md` | Pagamentos |
| 11 | `11-assinaturas.md` | Assinaturas |
| 12 | `12-estorno.md` | Aprovar estorno na Asaas |
| 13 | `13-configuracao-de-estorno.md` | Dias de teste |
| 14 | `14-metodos-de-pagamento.md` | Ligar e desligar métodos |
| 15 | `15-logs-asaas.md` | Chamadas e webhooks da Asaas |
| 16 | `16-filas.md` | Jobs de roteiro, notificação e ingestão |
| 17 | `17-expiracao-de-assinaturas.md` | Checagem de assinatura vencida |
| 18 | `18-infraestrutura.md` | Saúde da stack |
| 19 | `19-denuncias.md` | Fila de denúncias da comunidade |
| 20 | `20-publicacoes.md` | Avaliações, mídias, comentários e curtidas |

## 5. Fora do painel

- Montar roteiro, lançar gasto, fazer mala ou publicar avaliação no lugar do viajante.
- Ler documento pessoal da viagem.
- Chat entre usuários. O produto não tem.
- Login do app com Facebook. O app entra com Google ou e-mail e senha.

## 6. Catálogo e ingestão

A operação que enriquece o catálogo (fontes, staging, revisão e publicação) está em `TECH/TECH.md`. Ainda não tem arquivo numerado nesta pasta. O texto de interface dessas telas é `A DEFINIR`. O comportamento técnico já está naquele documento.
