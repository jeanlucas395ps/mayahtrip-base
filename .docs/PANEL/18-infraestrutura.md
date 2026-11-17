# 18 — Infraestrutura

## Objetivo
Ver se a plataforma está de pé, sem abrir o servidor.

## Serviços
Cada um aparece como saudável, degradado ou fora:

- API
- Postgres
- Redis
- Kafka
- Nginx

## Máquina e containers
- CPU, memória e disco do host.
- CPU e memória dos containers da API, do Postgres, do Redis, do Kafka e do Nginx.

## Chamadas externas
Taxa de erro recente, por fornecedor: OpenAI, Google, Asaas, SMTP, Frankfurter, armazenamento e câmbio. Sem a query do usuário e sem o corpo.

## Logs
Últimos erros da API, com correlation id. Sem senha, token, documento ou e-mail.

## Regras
- Esta tela só observa. Não reinicia serviço, não edita variável e não abre shell.
- Métrica e log vêm de Prometheus, Loki, node-exporter e cAdvisor, pela API. O browser não fala com esses sistemas.
- O que cada banco guarda segue `ARCHITECTURE.md`. Esta tela não decide isso.
