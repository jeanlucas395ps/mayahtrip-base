# 03 — Recuperar senha

## Acesso
Link “Esqueci a senha” no login por e-mail.

## Passo 1 — Informar e-mail
- Título editorial 34 px “Esqueceu a senha?”; subtítulo “Sem problema. Enviamos um código de 4 dígitos para o seu e-mail.”; voltar → login e-mail.
- Campo **E-mail da conta** (52 px), pré-preenchido com o e-mail digitado no login.
- Botão **Enviar código**.
- E-mail inválido → “Digite um e-mail válido.” (12 px/700 `#D2462A`).
- Sucesso → aviso “Código enviado para {e-mail}”.

## Passo 2 — Código
- Título “Digite o código”; subtítulo “Enviamos para **{e-mail}**. Ele expira em 10 minutos.”; voltar → passo 1.
- Mesmo componente e regras do código do cadastro (`02-cadastro-e-verificacao.md`): 4 dígitos, **5 tentativas**, reenvio após 30 s, tremor no erro.

## Passo 3 — Nova senha
- Título “Crie uma nova senha”; subtítulo “Use pelo menos 8 caracteres, com número e letra maiúscula.” (sem botão voltar).
- **Nova senha** (52 px, olho) + medidor de força + **Confirmar senha**.
- Validações: < 8 caracteres → “A senha precisa ter pelo menos 8 caracteres.”; diferentes → “As senhas não conferem.”
- O foco vai para “Nova senha” automaticamente.
- Botão **Salvar nova senha**.

> Observação: o subtítulo pede número e maiúscula, mas a validação atual exige só 8 caracteres. Tornar obrigatório número + maiúscula: `A DEFINIR`.

## Passo 4 — Concluído
- Ícone de cadeado 30 px em bloco lima 72 px (pop).
- Título “Senha alterada”; texto “Por segurança, encerramos as sessões em outros aparelhos.”
- Botão **Entrar com a nova senha** → login por e-mail.

## Regras de negócio
1. Ao salvar a nova senha, **todas as outras sessões são encerradas**.
2. Notificação por e-mail avisando da troca de senha: `A DEFINIR`.
