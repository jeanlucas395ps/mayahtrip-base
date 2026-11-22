# 17 — Roteiro em lista

## Layout
1. **Seletor de dias** (carrossel): botões mín. 96 px, raio 18 px, padding 10/14 px — “Dia N” (13 px/700), data (12 px, 75%) e “· {cidade}” quando a viagem tem várias cidades, e “N paradas” (12 px/700 roxo; lima no ativo). Ativo: fundo `#2B207F`, texto branco. No fim, botão tracejado 56 px “+” → **adicionar dia** (aviso “Dia N adicionado”; nome “Dia livre”).
2. **Lista | Mapa** (segmentado) → mapa em `18`.
3. Título do dia (h2) + “N paradas · {custo} aprox.” (custo = soma dos preços das paradas). Com **3+ paradas**, chip **⚡ Otimizar** (ver `18`).
   - Com **2+ paradas**, linha de dica discreta logo abaixo (12 px, `#8C889E`): ícone de alça + “Arraste para reordenar · ” + ícone de lixeira + “para remover”.
4. **Paradas** (cartões brancos raio 22 px, padding 12 px):
   - **Alça de arrastar** (à esquerda, 22 px de largura, altura do cartão, ícone de 6 pontos 18 px em `#BDB8D6`; ao passar/tocar fica `#2B207F` com fundo `#F4F3F8`) → ver “Reordenar”.
   - Miniatura 64 px · horário (12 px/700 roxo) · nome 15 px/700 (riscado e `#8C889E` quando feita) · “{duração} · {preço ou grátis} · N vídeos”.
   - Botão **Rota** (36 px, ícone de rota) → abre a rota até o lugar no **Google Maps** (no protótipo, aviso “Abrindo rota até {lugar} no Google Maps (mock)”).
   - **Caixa de feito** (36 px, raio 12): vazia com borda `#CFCCDA`; feita = fundo `#2B207F` com check branco (pop 300 ms).
   - Rodapé do cartão (borda superior, recuo 24 px, **alinhado à borda esquerda da imagem** do lugar): dicas e nota à esquerda; à direita, **lixeira** discreta (30 px, ícone 15 px `#9A97AB`; ao passar/tocar fica `#D2462A` com fundo `#FFE6E0`) → ver “Remover”, e o link **Ver mais ›** → página do lugar.
   - Toque no cartão → `19-detalhe-da-parada.md`.
   - **Deslocamento** entre paradas: linha tracejada vertical 2 × 24 px + ícone (a pé / carro / transporte) + “N min · X km” (12 px/700 `#5E5A73`).
5. **+ Adicionar parada** (54 px, tracejado 1,5 px `#BDB8D6`, texto roxo) → `20-adicionar-parada.md`.

## Dia sem paradas
Cartão com ícone de pin 26 px em bloco 56 px `#EBE8FF`: “Dia livre por enquanto” / “Adicione lugares que você viu no feed ou peça sugestões.” + **+ Adicionar** (primário 42 px) e **✨ Sugerir 3** (contorno).
- **Sugerir 3**: adiciona os 3 lugares mais salvos da cidade do dia que ainda não estão na viagem, às 10:00, 13:00 e 16:00, com deslocamento “~10 min a pé”; o dia passa a se chamar “Sugestões para você” se era “Dia livre”; aviso “3 lugares sugeridos. Arraste para ajustar.”

## Reordenar (arrastar)
1. Todo cartão de parada tem a alça. O arraste **só começa pela alça** (o resto do cartão continua abrindo o detalhe e a lista continua rolando normalmente).
2. Ao pegar: o cartão sobe (escala 1,02, sombra `0 18px 40px rgba(21,18,46,.2)`, mola 200 ms), vibração curta (8 ms) quando o aparelho suporta, e as linhas de deslocamento somem (opacidade 0, 150 ms).
3. Enquanto arrasta, os outros cartões abrem espaço deslizando (240 ms, curva principal) quando o centro do cartão arrastado passa do centro deles.
4. Perto do topo ou da base visível (70 px, descontando a barra inferior), a tela **rola sozinha**.
5. Ao soltar numa nova posição:
   - os **horários ficam nas posições** (a parada que vai para a 1ª posição recebe o 1º horário etc.), igual ao Otimizar;
   - os deslocamentos são recalculados;
   - o cartão movido pisca com halo lima (1,4 s);
   - aviso “{lugar} agora é a parada N” + **Desfazer**.
6. Soltar na mesma posição não muda nada nem mostra aviso.
7. **Acessibilidade**: a alça é focável; com ela em foco, **seta para cima/baixo** move a parada uma posição (o foco acompanha a parada). Rótulo: “Reordenar {lugar}. Arraste ou use as setas para cima e para baixo”.
8. Disponível só na visão **Lista** (o mapa segue a ordem resultante).

## Remover
1. Todo cartão tem a lixeira no rodapé. Tocar remove **na hora, sem confirmação**: o cartão encolhe e some (260 ms) e aparece “{lugar} removido do Dia N” + **Desfazer** (devolve a parada na mesma posição, com o mesmo horário).
2. Os horários das demais paradas **não mudam**; os deslocamentos são recalculados.
3. “Remover do roteiro” no detalhe da parada (`19`) usa a mesma regra.
4. Com “reduzir movimento” ativo, a remoção acontece sem animação.

## Regras
1. Marcar como feito → aviso “{lugar} feito” + **Avaliar** (→ `12`). Desmarcar não gera aviso.
2. Itens recém-adicionados piscam com halo lima (1,4 s).
3. Reordenar e remover: ver seções acima.
4. Assistente júnior: vê, mas não marca, não adiciona, não otimiza, **não reordena e não remove** (alça e lixeira não aparecem para ele).
