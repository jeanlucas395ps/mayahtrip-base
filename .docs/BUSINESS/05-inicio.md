# 05 — Início (home)

## Objetivo
Ponto de partida diário: saudação, busca, atalho para criar viagem, a viagem mais próxima e o que está em alta na comunidade.

## Layout (rolagem vertical, margens 56 px topo / 20 px laterais / 130 px base, espaço 22 px entre blocos)
Os blocos entram em cascata: cada um sobe 14 px e aparece em 500 ms, com 40 ms de atraso entre eles (até 240 ms).

1. **Faixa de convidado** — só no modo convidado (ver `04`).
2. **Cabeçalho**
   - Esquerda: foto do usuário **circular 44 px** com borda branca 2 px (toque → Perfil). Ao lado: saudação 12 px `#5E5A73` + nome 16 px/700.
   - Saudação pelo **horário do celular**: 05:00–11:59 “Bom dia”; 12:00–17:59 “Boa tarde”; 18:00–04:59 “Boa noite”.
   - Direita: sino em botão 44 px branco → `06-notificacoes.md`. Contador de não lidas: pílula `#FF5A36`, 18 px de altura, texto 11 px/800 branco, borda branca 2 px, posicionado no canto superior direito do botão. Some quando zero.
3. **Título editorial** 42 px (line-height 1,02): “Para onde vai sua *curiosidade* hoje?” — “curiosidade” em itálico `#2B207F`.
4. **Campo de busca** (54 px, raio 27 px, borda `#E5E3EC`): ícone de lupa + “Qual a curiosidade do momento?” → `07-busca.md`.
5. **Cartão Nova viagem** (fundo `#2B207F`, raio 26 px, espaçamento 18 px, sombra `0 14px 30px rgba(43,32,127,.25)`) → `14-nova-viagem.md`:
   - Kicker lima “NOVA VIAGEM” + quadrado lima 36 px (raio 12) com “+”.
   - Título editorial 34 px branco “Roteiro pronto em 4 toques”.
   - 4 etiquetas (28 px, fundo branco 12%): “1. Destino”, “2. Datas”, “3. Quem vai”, “4. Pronto”.
6. **Sua viagem agora / Sua próxima viagem**
   - Título h2: “Sua viagem agora” se existir viagem acontecendo; senão “Sua próxima viagem”. Link “Todas” → Carteira.
   - Mostra **uma** viagem: a primeira (por data de início) com status *acontecendo agora* ou *próxima*. Se não houver, a primeira da carteira. Sem viagens: bloco não aparece.
   - Cartão de viagem idêntico ao da Carteira (`15-carteira-de-viagens.md`).
7. **Em alta na semana**
   - Título h2 + subtítulo 12 px “Os mais curtidos dos últimos 7 dias”; link “Ver feed” → Explorar.
   - Carrossel horizontal de cartões de vídeo **236 × 330 px**, raio 26 px, espaço 10 px, recuo inicial de 20 px e encaixe por item.
   - Cartão: foto cheia, degradê escuro de 72% da altura, botão “play” 34 px no canto superior direito (vidro), kicker lima “{Cidade} · {N} curtidas”, título editorial 36 px, frase 13 px `#E4E2EE`.
   - Toque → `08-pagina-do-lugar.md`. Ao passar o dedo/mouse, a foto dá zoom lento (1,06 em 6 s).

## Regra “Em alta”
**Os lugares mais curtidos da semana** (últimos 7 dias). Quantidade exibida no protótipo: 4. Critério de desempate e quantidade final: `A DEFINIR`.

## Balão da Maya
Visível no canto inferior direito (ver `27-maya.md`).
