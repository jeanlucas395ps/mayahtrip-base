# 19 — Detalhe da parada

## Acesso
Toque num cartão de parada (lista ou cartão do mapa).

## Folha
1. **Mídia**: cartão de vídeo 200 px (raio 22) com duração “▶ 0:48”, botão play e “N vídeos de quem foi” → Explorar. Sem foto: bloco 140 px na cor do lugar com ícone 64 px a 40%.
2. “Dia N · {horário}” (12 px/700 roxo) + nome editorial **34 px**; à direita, ★ nota.
3. Etiquetas: “🕘 {duração}”, “{preço} aprox.” ou “Grátis”, bairro (roxa).
4. Três botões (46 px, 13 px): **✓ Feito** (primário; vira **Desfazer** em contorno quando feito) · **Rota** · **Gasto**.
5. **💡 Dicas de quem foi**: lista numerada (número em quadrado 24 px `#EBE8FF`).
6. **★ Avaliar esta parada** (primário, largura total) → `12-avaliar-parada.md`.
7. **📍 Ver tudo sobre {lugar}** (contorno) → página do lugar.
8. **🗑 Remover do roteiro** (texto `#962A10`, 14 px/700).

## Regras
- **Feito**: fecha a folha, atualiza o roteiro e mostra “{lugar} feito” + **Avaliar**.
- **Gasto**: fecha a folha, muda para a aba Gastos e abre o Novo gasto já com descrição = nome do lugar, valor = preço estimado e vínculo com a parada.
- **Remover**: fecha a folha e remove a parada com a mesma regra do cartão (sem confirmação, com **Desfazer**; ver `17`).
- Assistente júnior: só leitura (sem Feito, Gasto, Remover). Avaliar continua disponível? `A DEFINIR`.
