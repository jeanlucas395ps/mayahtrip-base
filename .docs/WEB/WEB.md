# Web de planos — Visão

Fonte da verdade do site em que o viajante assina e gerencia o PRO. O código fica em https://github.com/jeanlucas395ps/mayahtrip-web.git. O app continua em `BUSINESS/`. O administrador continua em `PANEL/`.

A compra não acontece dentro do app. O app não usa a cobrança da loja (App Store nem Google Play). Quem cobra é a Asaas, por este site, através da API.

## 1. Quem usa

O dono da conta do app. Convidado não entra. Administrador do painel não gerencia o próprio plano aqui.

## 2. O que ele faz aqui

- Ver o plano atual.
- Assinar o PRO ou trocar de plano.
- Ver e trocar o cartão e os meios de pagamento liberados.
- Ver as últimas faturas.

Não há roteiro, feed, gasto nem Maya neste site.

## 3. Idioma

Os mesmos quatro da interface: Português (Brasil), Português (Portugal), English e Español. O site abre no idioma da conta.

## 4. Índice

| Nº | Arquivo | Função |
| --- | --- | --- |
| 01 | `01-entrada-pelo-app.md` | Botões do app que abrem este site |
| 02 | `02-login.md` | Entrar com a conta do app |
| 03 | `03-plano.md` | Plano atual e troca |
| 04 | `04-pagamentos.md` | Cartão e meios de pagamento |
| 05 | `05-faturas.md` | Últimas faturas |

## 5. Regras

- O site fala só com a API. Não chama a Asaas no browser.
- Preço, ciclo e features vêm do que o administrador gravou em `PANEL/08-planos.md`.
- Meio de pagamento desligado no painel (`PANEL/14`) não aparece aqui.
- Trocar a senha no app encerra a sessão deste site.
- Endereço público do site: `A DEFINIR`.
- Framework do projeto: `A DEFINIR`.
