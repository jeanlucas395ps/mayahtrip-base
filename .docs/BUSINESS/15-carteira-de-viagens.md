# 15 — Carteira de viagens

## Objetivo
Listar todas as viagens do usuário, com filtros por momento e status visível em cada cartão.

## Animação de entrada (toda vez que se toca na aba Carteira)
1. Fundo da tela; uma **carteira** 260 × 180 px surge (escala 0,7 + 20 px → normal, mola, 550 ms):
   - Fundo traseiro `#1E1760`, raio 32 px, 160 px de altura.
   - Até **3 cartões de viagem** (204 × 124 px, raio 18 px, foto + nome editorial 24 px + datas), empilhados 6 px um do outro.
   - Frente `#2B207F` (116 px, raio 30 px) com costura tracejada branca 22%, kicker lima “CARTEIRA” e “{N} viagens” (editorial 22 px); fecho lima 70 × 46 px na lateral direita com botão `#15122E`.
2. Aos **520 ms**, os cartões sobem para fora da carteira (78 px + 30 px por cartão) em leque (±5°), 70 ms entre eles.
3. Aos **1250 ms**, a carteira some (escala 0,85) e cada cartão voa e se transforma no cartão real da lista (posição, tamanho, raio 24 px), 700 ms, 60 ms entre eles.
4. Aos **2050 ms** a lista aparece (350 ms) e a sobreposição some; removida aos 2500 ms.
- Os cartões da animação respeitam o filtro ativo.

## Layout
- Kicker roxo “{N} VIAGENS” + título h1 “Carteira de viagens”; botão primário **+ Nova** (42 px) → assistente.
- **Filtros** (chips): **Todas · N** (padrão) · **Próximas · N** · **Rascunhos · N**.
  - Próximas = viagens *acontecendo agora* + *futuras*.
  - Rascunhos = viagens **com duração e sem data**.
- Lista de cartões, espaço 14 px.
- Ao final: link tracejado “Clonar uma viagem da comunidade” / “Use o roteiro de quem já foi como ponto de partida” → Explorar.

## Cartão de viagem
- Branco, raio 24 px, sombra `0 1px 2px rgba(21,18,46,.05), 0 12px 32px rgba(21,18,46,.07)`.
- **Imagem** 150 px (foto do destino ou cor sólida da viagem).
- **Selo de status** (24 px, raio 8 px, 12 px/700):
  | Status | Posição | Visual | Texto |
  | --- | --- | --- | --- |
  | Acontecendo agora | sup. esquerdo (14 px) | fundo lima, texto `#15122E`, ponto 7 px pulsando (opacidade 1 ↔ 0,25 em 1,4 s) | “Acontecendo agora” |
  | Próxima | sup. esquerdo | fundo `#15122E`, texto lima | “Em N dias” |
  | Concluída | sup. esquerdo | fundo `#15122E`, texto lima | “Concluída” |
  | Rascunho | **inf. direito** (14 px) | fundo branco, texto `#15122E`, ícone de lápis 12 px | “Rascunho” |
- Viagem com mais de uma cidade: selo branco 90% “N cidades” no canto superior direito.
- **Corpo** (16/18 px): nome editorial 32 px; linha 13 px “{datas} · N dias · N paradas”; avatares dos participantes (32 px, sobrepostos −9 px).
- **3 mini-indicadores** (grade 3 colunas, fundo `#F4F3F8`, raio 14 px): Gastos (valor, barra = % do orçamento), Mala (“X de Y”, barra = % pronto), Docs (“N salvos”, barra cheia verde `#9ACC1F` se houver docs). Barras 4 px.
- Toque → `16-viagem-capa-e-abas.md`.

## Ordenação
Por data de início crescente; rascunhos no fim.

## Estados vazios
- Sem viagens: ícone de mala em bloco `#EBE8FF` 56 px, “Nenhuma viagem ainda” / “Comece pelo destino. São só 4 toques.” + botão **+ Criar viagem**.
- Filtro sem resultado: “Nenhum rascunho” / “Rascunhos são viagens com duração, mas ainda sem data.” ou “Nenhuma viagem próxima” / “Crie uma viagem para ela aparecer aqui.”

## A DEFINIR
- Filtro para viagens concluídas (hoje só aparecem em “Todas”).
- Como transformar um rascunho em viagem com data (editar viagem).
