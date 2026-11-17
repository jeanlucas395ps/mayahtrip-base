# 02 — Login

## Objetivo
Entrar com a mesma conta do app.

## Campos
E-mail e senha da conta do app.

## Ações
- Entrar.
- Esqueci a senha. Usa o mesmo fluxo de recuperar senha do app (`BUSINESS/03`).
- Sair. Encerra só a sessão deste site.

## Regras
- A senha é a da conta do app. Não existe senha separada para o site.
- Conta que só entrou com Google ainda não tem senha. Antes de usar o site, a pessoa cria uma pelo “Esqueci a senha”.
- Conta inativa ou excluída não entra.
- Convidado não tem conta e não entra.
- Login com Google não existe neste site.
