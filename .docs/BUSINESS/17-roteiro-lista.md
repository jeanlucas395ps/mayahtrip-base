# 17 — Roteiro em lista

## Layout
1. **Seletor de dias** (carrossel): botões mín. 96 px, raio 18 px, padding 10/14 px — “Dia N” (13 px/700), data (12 px, 75%) e “· {cidade}” quando a viagem tem várias cidades, e “N paradas” (12 px/700 roxo; lima no ativo). Ativo: fundo `#2B207F`, texto branco. No fim, botão tracejado 56 px “+” → **adicionar dia** (aviso “Dia N adicionado”; nome “Dia livre”).
2. **Lista | Mapa** (segmentado) → mapa em `18`.
3. Título do dia (h2) + “N paradas · {custo} aprox.” (custo = soma dos preços das paradas). Com **3+ paradas**, chip **⚡ Otimizar** (ver `18`).
4. **Paradas** (cartões brancos raio 22 px, padding 12 px):
   - Miniatura 64 px · horário (12 px/700 roxo) · nome 15 px/700 (riscado e `#8C889E` quando feita) · “{duração} · {preço ou grátis} · N vídeos”.
   - Botão **Rota** (36 px, ícone de rota) → abre a rota até o lugar no **Google Maps** (no protótipo, aviso “Abrindo rota até {lugar} no Google Maps (mock)”).
   - **Caixa de feito** (36 px, raio 12): vazia com borda `#CFCCDA`; feita = fundo `#2B207F` com check branco (pop 300 ms).
   - Rodapé do cartão (borda superior, recuo 76 px): “💡 N dicas · ★ nota” + link **Ver mais ›** → página do lugar.
   - Toque no cartão → `19-detalhe-da-parada.md`.
   - **Deslocamento** entre paradas: linha tracejada vertical 2 × 24 px + ícone (a pé / carro / transporte) + “N min · X km” (12 px/700 `#5E5A73`).
5. **+ Adicionar parada** (54 px, tracejado 1,5 px `#BDB8D6`, texto roxo) → `20-adicionar-parada.md`.

## Dia sem paradas
Cartão com ícone de pin 26 px em bloco 56 px `#EBE8FF`: “Dia livre por enquanto” / “Adicione lugares que você viu no feed ou peça sugestões.” + **+ Adicionar** (primário 42 px) e **✨ Sugerir 3** (contorno).
- **Sugerir 3**: adiciona os 3 lugares mais salvos da cidade do dia que ainda não estão na viagem, às 10:00, 13:00 e 16:00, com deslocamento “~10 min a pé”; o dia passa a se chamar “Sugestões para você” se era “Dia livre”; aviso “3 lugares sugeridos. Arraste para ajustar.”

## Regras
1. Marcar como feito → aviso “{lugar} feito” + **Avaliar** (→ `12`). Desmarcar não gera aviso.
2. Itens recém-adicionados piscam com halo lima (1,4 s).
3. Reordenar arrastando: `A DEFINIR` (mencionado no aviso, não implementado).
4. Assistente júnior: vê, mas não marca, não adiciona e não otimiza.
