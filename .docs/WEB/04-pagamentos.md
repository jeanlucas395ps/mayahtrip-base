# 04 — Pagamentos

## Objetivo
Guardar o cartão e escolher o meio de pagamento da assinatura.

## O que mostra
- Cartão atual, se houver: bandeira e últimos quatro dígitos. Sem o número completo e sem o código de segurança.
- Meios ligados pelo administrador: cartão de crédito, boleto e Pix (`PANEL/14`).

## Ações
- Adicionar cartão.
- Substituir cartão.
- Escolher o meio da próxima cobrança, entre os que estão ligados.
- Confirmar a assinatura escolhida em `03`.

## Regras
- O número completo do cartão não volta para a tela depois de salvo. Quem guarda é a Asaas, via API.
- Meio desligado no painel some desta tela.
- Boleto e Pix seguem o fluxo da Asaas para aquela cobrança. O site mostra o estado (aguardando, pago, falhou) e não marca o plano como pago antes da confirmação.
- Falha de pagamento não troca o plano vigente.
