# 04 — Explorar como convidado

## Objetivo
Deixar a pessoa conhecer o app sem criar conta e convidá-la a criar conta no momento em que tentar algo que exige identificação.

## Entrada
Login → “Explorar como convidado” (indicador giratório por 900 ms) → Início, com o aviso “Explorando como convidado”.

## O que muda no app
| Área | Comportamento |
| --- | --- |
| Início | Faixa no topo: fundo `#15122E`, raio 18 px, “Você está como convidado” (13 px/700 branco) / “Crie sua conta para salvar viagens e gastos” (12 px `#C9C6DA`) + botão lima “Criar conta” (34 px). Avatar vira círculo cinza `#E9E7F0` com ícone de pessoa; saudação “{Bom dia…}, viajante”. Sem “Sua próxima viagem”. |
| Carteira | Vazia (estado “Nenhuma viagem ainda”). |
| Notificações | Só a de boas-vindas. Sem contador de não lidas além dela. |
| Perfil | Tocar em Perfil abre o convite para criar conta. |

## Ações que pedem conta
Ao tentar qualquer item abaixo, abre a folha **“Crie sua conta para {motivo}”**:

| Ação | Motivo exibido |
| --- | --- |
| Seguir viajante | seguir viajantes |
| Criar viagem (botão final do assistente) | criar sua viagem |
| Novo gasto (ações rápidas) | lançar gastos |
| Adicionar parada (ações rápidas) | montar seu roteiro |
| Inserir lugar no roteiro | salvar no seu roteiro |
| Salvar lugar | salvar lugares |
| Publicar vídeo/review | publicar reviews |
| Curtir | curtir e seguir viajantes |
| Avaliar parada | avaliar paradas |
| Comentar | comentar |
| Abrir Perfil | ter seu perfil |
| Faixa do Início | salvar suas viagens |

## Folha “Crie sua conta”
- Centralizada: símbolo 34 px + logotipo `#15122E` 120 px.
- Título editorial 34 px “Crie sua conta para {motivo}”.
- Texto 13 px (máx. 290 px): “É grátis e leva 10 segundos. Tudo que você explorou continua aqui.”
- **Continuar com Google** · **Criar com e-mail** (primário) · link **Continuar explorando** (fecha).

## Regras de negócio
1. Ao criar conta pela folha, a sessão é criada, o aviso “Conta criada. Bem-vindo, {nome}!” aparece e **a ação que estava pendente é executada automaticamente** 350 ms depois (ex.: o lugar é salvo).
2. Como salvar e curtir já exigem conta, o convidado não acumula dados; a frase “Tudo que você explorou continua aqui” se refere à tela em que ele estava, que é mantida. Persistência de qualquer dado do convidado após fechar o app: `A DEFINIR`.
3. “Criar com e-mail” na folha leva direto ao cadastro? No protótipo cria a conta direto. Fluxo real: `A DEFINIR` (sugestão: abrir `02-cadastro-e-verificacao.md` e voltar à ação pendente).
