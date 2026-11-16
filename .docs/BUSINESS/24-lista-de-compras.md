# 24 — Lista de compras

## Objetivo
Organizar o que precisa ser comprado antes ou durante a viagem, com preço previsto e loja/link. Substitui a antiga aba Galeria.

## Layout (aba “Compras” da viagem)
1. **Resumo** (cartão, padding 16 px): “X de Y comprados” (h3) · “Total previsto {valor}” (12 px) · barra 8 px roxa (% comprados) · “Falta comprar: **{valor dos itens pendentes}**” (some quando zero).
2. **Lista** (cartão): cada item com
   - caixa de seleção 30 px (comprado = roxa com check);
   - nome 15 px/600 (riscado e `#8C889E` quando comprado);
   - linha 12 px: loja (ou “Sem loja”) + “· link salvo” quando há link;
   - preço 13 px/700 (ou “—” sem preço);
   - botão ✕ 32 px para remover.
   - Vazio: “Nada na lista ainda. Adicione o que precisa comprar antes ou durante a viagem.”
3. **Adicionar** (formulário):
   - Linha 1: “O que comprar” (50 px, flexível) + “Preço” (110 px, teclado decimal, placeholder com o símbolo da moeda de exibição, ex.: “€ 0,00”).
   - Linha 2: “Loja ou link (opcional)” (46 px) + botão primário **+ Adicionar** (46 px).

## Regras
1. Nome obrigatório; preço e loja opcionais. Aviso “Item adicionado à lista de compras”.
2. O preço é digitado na **moeda de exibição** e guardado convertido; aceita “1.234,56”.
3. Se o campo “Loja ou link” parece um link (começa com http(s) ou contém .com/.pt/.br), salva como link e mostra “Link · link salvo”.
4. Remover mostra “{item} removido” + **Desfazer** (volta na mesma posição).
5. A lista é compartilhada pelo grupo. Quem pode editar segue os papéis (`26`).

## A DEFINIR
- Abrir o link salvo (navegador interno ou externo).
- Atribuir item a uma pessoa / quem comprou.
- Transformar item comprado em gasto automaticamente.
