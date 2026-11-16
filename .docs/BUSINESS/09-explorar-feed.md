# 09 — Explorar (feed de vídeos)

## Objetivo
Descobrir lugares por vídeos curtos da comunidade (estilo TikTok) e levar o lugar ao roteiro em um toque.

## Estrutura
- Tela cheia, fundo preto, rolagem vertical **com encaixe por vídeo** (um post por tela).
- Barra inferior escura (ver `BUSINESS.md` §6). Balão da Maya escondido nesta tela.

### Abas (topo, 50 px do topo, 16 px laterais)
Pílulas de 36 px, raio 18 px, 14 px: **Seguindo · Para você (padrão) · Próximas viagens · Salvos**. Ativa: fundo branco, texto `#15122E`, 800. Inativa: `rgba(21,18,46,.35)` + desfoque, texto branco 600. A fila rola na horizontal e esmaece na borda direita. À direita, lupa 40 px (`rgba(21,18,46,.4)`) → Busca.

| Aba | Conteúdo |
| --- | --- |
| Seguindo | Posts de pessoas que o usuário segue |
| Para você | Todos (algoritmo `A DEFINIR`) |
| Próximas viagens | Posts de cidades das viagens futuras do usuário, ordenados pela viagem mais próxima. Selo `#15122E`/lima no topo: “🧳 Para sua viagem · {viagem} em N dias” |
| Salvos | Lugares salvos pelo usuário |

Trocar de aba volta ao primeiro post. Posts de pessoas **bloqueadas ou silenciadas** não aparecem.

### Post
- Foto/vídeo em tela cheia; zoom lento de 1,02 → 1,14 em 9 s enquanto o post está ativo (≥ 60% visível).
- Degradê: escuro no topo (55% → 0 em 20%) e forte na base (62% em 55% → 95% em 100%).
- **Trilho de ações** (direita, 12 px da borda, 290 px da base; botões 48 px redondos, branco 16% + desfoque; rótulo 12 px/700):
  1. **Curtir** (coração 24 px; curtido = preenchido `#FF5A6A`, “pulo” de escala 0,6→1,25→1 em 450 ms). Contador: total; curtido mostra “+1”.
  2. **Comentários** (balão 22 px) com o total de comentários → abre `10-comentarios-e-curtidas.md`.
  3. **Salvar** (marcador; salvo = preenchido lima).
  4. **Enviar** (aviso “Link copiado”).
- **Bloco de conteúdo** (16 px esquerda, 76 px direita, 116 px da base, espaço 12 px):
  - Autor: avatar 36 px + @usuário (13 px/700) + “esteve aqui em {mês ano}” (12 px `#D8D6E4`); toque → perfil público. Botão **Seguir** (30 px, contorno branco) se ainda não segue.
  - Kicker lima “{cidade} · {lugar}”; título editorial **40 px**; texto 13 px `#E4E2EE`.
  - **Cartão do lugar** (branco, raio 20 px): miniatura 40 px + nome + estrela/nota/categoria (toque → página do lugar) + botão primário **+ Roteiro** (38 px) → `11-inserir-no-roteiro.md`.
- **Botão de progresso** (canto inferior direito, 12 px da borda, 118 px da base): círculo 48 px escuro com seta para baixo balançando (1,6 s). Anel lima de 3 px desenha 0 → 360° em **9 s** enquanto o post está ativo.

## Regras
1. **Avanço automático**: ao completar o anel (9 s), o feed rola sozinho para o próximo post; no último, volta ao primeiro.
2. Tocar no botão de progresso pula para o próximo imediatamente.
3. Curtir, salvar e seguir exigem conta (convidado → convite).
4. Aba vazia: tela `#120F2A` com ícone de marcador 28 px (bloco 64 px), título editorial 32 px “Nada salvo ainda” (Salvos) ou “Nada por aqui” (outras), texto explicativo e botão lima **Ver Para você**.

## A DEFINIR
- Duração real por vídeo (o anel de 9 s é do protótipo com fotos; para vídeo, sugerido: duração do vídeo).
- Som (ligado/desligado por padrão).
- Algoritmo do “Para você”.
