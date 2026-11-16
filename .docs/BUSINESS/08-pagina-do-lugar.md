# 08 — Página do lugar

## Objetivo
Mostrar tudo sobre um lugar (vídeos, informações, dicas) e levá-lo ao roteiro.

## Layout
1. **Capa** 420 px: foto do lugar (ou cor + ícone 120 px a 30% se não houver foto); degradê de baixo `rgba(12,10,28,.92)` até transparente em 60%.
   - Topo (52 px): voltar (botão vidro 44 px, branco 88% + desfoque 12 px) · **Salvar** (marcador; salvo = preenchido `#2B207F`) · **Compartilhar** (aviso “Link copiado”).
   - Base (20 px laterais, 22 px base): kicker lima “{categoria} · {cidade}”; nome editorial **50 px** branco; linha 13 px: estrela + nota + (avaliações) · “Aberto agora” em lima.
2. Etiquetas: roxa “▶ N vídeos”, cinzas “Em N roteiros” e “{duração} em média”.
3. **Vídeos e fotos** (h2 + “Ver todos” → Explorar): até 4 cartões 138 × 214 px, raio 20 px, duração no canto (“▶ 0:30”), autor 12 px/700 na base.
4. **Informações do local** (cartão com linhas 13 px, ícones 18 px `#2B207F`, divisórias `#EEECF3`):
   - 📍 “{bairro}, {cidade} · N min a pé do metrô”
   - 🕘 “Hoje: {horário} · fila média {N} min”
   - 💳 faixa de preço por pessoa (ou “Grátis”)
   - 👥 “Quem foi ficou em média {duração}”
5. **Dicas de quem foi**: até 3 cartões com avatar 32 px, nome, estrelas (5 ou 4) e texto 13 px.
6. **Barra fixa inferior** (fundo `rgba(244,243,248,.94)` + desfoque 16 px, borda superior): botão de mapa 44 px (contorno) + botão lima **Inserir em um roteiro** (52 px) → `11-inserir-no-roteiro.md`.

## Regras
1. Salvar/remover → aviso “Salvo em Salvos” / “Removido dos salvos”. Lista aparece na aba “Salvos” do Explorar.
2. Convidado ao salvar ou inserir → convite para criar conta.
3. “Aberto agora”, horário e fila vêm de dados do local. Fonte dos dados: `A DEFINIR`.
4. Botão de mapa: abrir o local num app de mapas. Comportamento real: `A DEFINIR`.
