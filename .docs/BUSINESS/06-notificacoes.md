# 06 — Notificações

## Regra geral
Toda notificação é **enviada no app e por push** ao mesmo tempo.

## Acesso
Sino do Início. Ao abrir a tela, todas passam a **lidas** após 400 ms (o contador do sino zera).

## Layout
- Cabeçalho (52 px do topo): voltar (44 px) · título “Notificações” (h3) · botão ✓ (44 px) **Marcar todas como lidas** (aviso “Tudo lido”).
- Seções com kicker 11 px/800 `#5E5A73`: **HOJE** e **ESTA SEMANA** (margem 22 px acima, 10 px abaixo). Cartões brancos raio 24 px, espaço 10 px, padding 14 px.
- Não lida: bolinha 8 px `#2B207F` 10 px à esquerda do cartão, alinhada ao título.

## Tipos

### 1. Roteiro sendo gerado
- Ícone 44 px (raio 14) roxo com indicador giratório lima.
- Título “Montando o roteiro de {viagem}”; subtítulo “Organizando N dias por bairro para você andar menos”.
- Barra de progresso 6 px + texto “{p}% · você pode sair, avisamos quando terminar”.
- Ao concluir: ícone vira check; título “Roteiro de {viagem} pronto”; subtítulo “N dias, M paradas organizadas por bairro”; botão lima **Ver roteiro** (40 px) → abre a viagem na aba Roteiro, dia 1. Também aparece o aviso “Roteiro de {viagem} pronto” com ação **Ver**.
- A geração é assíncrona: o usuário pode sair da tela.

### 2. Convite para viagem
- Avatar 44 px de quem convidou; texto “**{Nome}** te convidou para a viagem **{viagem}**”; linha “{datas} · N pessoas”.
- Botões lado a lado (42 px): **Aceitar** (primário) / **Recusar** (contorno).
- Aceitar → viagem entra na Carteira com o papel definido no convite; etiqueta lima “✓ Você entrou na viagem”; aviso “Você entrou em {viagem}” + **Ver**.
- Recusar → etiqueta cinza “Convite recusado”; aviso “Convite recusado. {Nome} será avisada.” **Quem convidou recebe notificação** (app + push).

### 3. Gasto lançado por outra pessoa
- Avatar 44 px com selo lima de carteira (20 px) no canto inferior direito.
- “**{Nome}** adicionou **{descrição}** em {viagem}”; linha 12 px/700 `#962A10`: “{valor} · você deve {sua parte}”.
- Toque → abre a viagem na aba Gastos.

### 4. Boas-vindas
- Ícone: símbolo da marca 24 px em bloco `#15122E`.
- “Bem-vindo ao MayahTrip!” / “Crie sua primeira viagem em 4 toques ou explore o que a comunidade anda postando.”
- Toque → assistente de nova viagem.

## Outras notificações previstas (app + push)
- Comentário, resposta, curtida e menção em publicações (ver `10` e `29`).
- Retorno de denúncia (ver `30`).
- Layout desses itens: `A DEFINIR`.

## A DEFINIR
- Agrupamento por período além de “Hoje” e “Esta semana” (ex.: “Anteriores”).
- Exclusão de notificações individuais.
- Texto exato dos pushes.
