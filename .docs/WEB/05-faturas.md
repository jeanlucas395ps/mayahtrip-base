# 05 — Faturas

## Objetivo
Ver as últimas cobranças da conta.

## Cada fatura
Data, valor, status (pago, pendente, falho, estornado), meio de pagamento e plano.

## Ações
- Abrir o detalhe.
- Abrir o comprovante quando a Asaas tiver um.

## Regras
- A lista é só da conta logada.
- PRO promocional e cupom não geram fatura.
- Estorno feito no painel aparece aqui como estornado.
- Não dá para estornar nem para pagar uma fatura antiga por outro canal nesta lista. Cobrança nova sai de `04`.
