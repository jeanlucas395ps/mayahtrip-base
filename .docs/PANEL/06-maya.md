# 06 — Maya

## Objetivo
Configurar os agentes que respondem no balão da Maya e testar um agente sem gravar nada do usuário.

## Agente
Cada agente tem:

- Nome
- Família: GPT-4 ou GPT-5
- Modelo
- Tipo de conversa
- Máximo de tokens
- Temperatura
- Prompts
- Ordem de uso
- Ativo ou inativo

## Ações
- Criar, editar, ativar, desativar e excluir.
- Criar o conjunto padrão de agentes.
- Rodar um teste sandbox: o administrador escreve uma pergunta e vê a resposta daquele agente.

## Regras
- A resposta da Maya sai no idioma da interface de quem perguntou no app (`BUSINESS/27` e `BUSINESS/35`).
- Nenhum agente cria viagem, lança gasto nem altera roteiro. O teste sandbox também não grava.
- Agente inativo não é chamado pelo app.
- A ordem define a preferência quando mais de um agente ativo serve o mesmo tipo de conversa.
- Limite de uso Free versus PRO: `A DEFINIR`.
