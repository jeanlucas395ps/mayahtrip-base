# 12 — Estorno

## Objetivo
Aprovar a devolução do dinheiro de uma assinatura elegível. A devolução sai pela Asaas.

## Lista
Assinaturas elegíveis segundo os dias de teste de `13`.

## Ação
Aprovar o estorno. O painel pede confirmação e envia o pedido à Asaas.

## Regras
- Sem aprovação, nada é enviado.
- Estorno aprovado marca a assinatura e o pagamento como estornados e entra no dashboard financeiro.
- Falha da Asaas mantém a assinatura como estava e registra a chamada em `15`.
- PRO promocional e cupom não são estornáveis: não houve cobrança.
