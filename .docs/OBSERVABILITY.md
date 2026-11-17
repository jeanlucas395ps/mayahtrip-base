# Observabilidade

Ferramentas já escolhidas em `ARCHITECTURE.md`. Este arquivo diz para que cada uma existe e o mínimo que o primeiro deploy precisa emitir. Dashboards, alertas, retenção e SLO **não** foram definidos: estão em `A DEFINIR` no final. Não crie meta numérica.

## 1. Peças

| Peça | Função |
| --- | --- |
| Prometheus | Métricas numéricas (taxa, latência, uso) |
| node-exporter | CPU, memória, disco e rede da máquina |
| cAdvisor | Uso dos containers |
| Loki | Logs |
| Alloy | Coleta métrica e log e entrega ao Prometheus e ao Loki |
| Grafana | Leitura. Um lugar só para gráfico e busca de log |

Nginx entra na frente da API e do painel. O log de acesso dele também vai para o Loki.

Não adicionar outro coletor, APM ou SaaS sem ADR.

## 2. O que medir desde o primeiro serviço

API (NestJS), por rota:

- Latência (histograma).
- Taxa de resposta por status.
- Taxa de erro dos adaptadores externos (OpenAI, Google, Asaas, SMTP, câmbio), com o nome do fornecedor e sem a query do usuário.
- Tempo de verificação de senha e de sessão, sem o valor da senha.

App: falha de rede ao chamar a API e falha ao abrir documento offline. O evento sobe para a API ou para o log do aparelho; o destino exato é `A DEFINIR`. Não mandar conteúdo de documento.

Fila e cache (quando Kafka e Redis tiverem dono): profundidade do tópico, idade da mensagem mais antiga, erro de consumidor, acerto/erro de cache. Enquanto o papel deles for `A DEFINIR` em `ARCHITECTURE.md` §5, não crie tópico “para ter métrica”.

## 3. Log

- Estruturado (JSON).
- Campo de correlação único do request, repassado ao fornecedor quando a API permitir header próprio.
- Nível, mensagem, módulo, duração.
- Proibido no log: senha, refresh token, access token, código de verificação, documento da viagem, corpo de e-mail, número de cartão, payload bruto da OpenAI com fala do usuário.

Push e notificação in-app são um par (`BUSINESS.md` §4.1). Logar os dois resultados (entregue ao provedor de push / gravada na central). O provedor de push ainda não foi escolhido.

## 4. Saúde

Cada processo expõe saúde de processo (sobe / não sobe) e, separado, saúde das dependências (Postgres, Redis, Kafka). Orquestrador usa só a saúde de processo para reiniciar. Dependência fora não deve gerar restart em loop.

## 5. `A DEFINIR`

- Retenção de métrica e de log.
- Alertas e quem recebe.
- SLO (disponibilidade, latência).
- Ambiente (só produção, ou também staging).
- Se o app móvel envia crash e erro de rede, e para onde.
- Cardinalidade: não rotular métrica com id de usuário, id de viagem ou texto de busca. Confirmar a lista de labels quando a primeira métrica for criada.
