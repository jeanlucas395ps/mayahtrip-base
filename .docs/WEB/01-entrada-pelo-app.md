# 01 — Entrada pelo app

## Objetivo
Levar o viajante para este site quando ele quer ser PRO ou cuidar do plano, sem cobrar dentro do app.

## Botões
No bloco Plano do perfil (`BUSINESS/28`):

- Conta Free: **Ver PRO**. Abre este site no navegador do aparelho.
- Conta PRO (paga, cupom ou promocional): **Gerenciar plano**. Abre este site no navegador do aparelho.

Os dois saem do app. Não abrem uma tela de pagamento dentro do Flutter.

## Regras
- O app não mostra preço para pagar, não pede cartão e não fala com a loja.
- Convidado não abre o site. O app pede para criar conta (`BUSINESS/04`).
- Se a pessoa não tem sessão no site, cai no login (`02`). Se já tem, cai no plano (`03`).
