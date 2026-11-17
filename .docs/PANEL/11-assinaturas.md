# 11 — Assinaturas

## Objetivo
Consultar quem está com um plano e em que estado.

## Filtros
- Status
- Plano
- E-mail
- Cancelada
- Estornada
- Tem identificador no provedor (Asaas)

## Detalhe
Usuário, plano, status, início, fim, cancelada ou não, estornada ou não, identificador na Asaas, se o período atual veio de cupom ou de PRO promocional.

## Regras
- Consulta apenas. Cancelar na Asaas e estornar ficam em `12`.
- Assinatura sem identificador na Asaas é promocional ou de cupom.
