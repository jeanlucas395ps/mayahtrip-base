# 15 — Logs da Asaas

## Objetivo
Ver o que a API falou com a Asaas e o que a Asaas devolveu no webhook.

## Duas listas
- Chamadas feitas à Asaas.
- Webhooks recebidos.

## Cada item
Data, operação, status HTTP, identificador na Asaas e o resumo do corpo já sem segredo.

## Detalhe
Abre o registro completo permitido: sem token, sem cartão e sem chave de API.

## Regras
- Só consulta. Não reenvia a chamada.
- Webhook que falhou a validação de assinatura aparece como rejeitado.
