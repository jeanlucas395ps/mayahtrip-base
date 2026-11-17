# 04 — Usuários do app

## Objetivo
Achar uma conta do app e ativar, desativar, excluir ou restaurar.

## Lista
Busca e filtros:

- Ativo
- E-mail verificado
- Entrada por Google ou por e-mail e senha
- País
- Data de cadastro

Convidado não é usuário e não entra nesta lista.

## Ficha
Nome, @usuário, e-mail, país, idioma, moeda, plano vigente, e-mail verificado, data de cadastro, ativo ou inativo, excluído ou não.

## Ações
- Abrir a ficha.
- Ativar ou desativar. Inativo não entra no app.
- Excluir. A exclusão é lógica: a conta some do app e pode ser restaurada.
- Restaurar. Volta a entrar com os mesmos dados.

## Regras
- Desativar não apaga viagens nem publicações. Elas continuam no estado em que estavam.
- Excluir não apaga o histórico financeiro. Pagamento e assinatura seguem consultáveis em `10` e `11`.
- PRO promocional desta conta é tratado em `05`.
