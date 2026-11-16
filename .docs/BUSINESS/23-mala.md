# 23 — Mala

## Layout
1. **Progresso** (cartão): “X de Y prontos” (h3) · à direita “{viagem} · {clima}” (12 px) · barra 8 px roxa.
2. **Sugestão** (enquanto não aceita): caixa `#F1FFD1` com ícone faísca em `#15122E`: “Pelo clima e pelo roteiro, sugerimos **4 itens** que faltam.” + chip **Adicionar** → cria o grupo “Sugestões da Maya” no topo (ex.: Guarda-chuva compacto — “Março tem chuva em 1 a cada 4 dias”; Garrafa reutilizável; Moedas para a Fontana di Trevi; Cópia digital do passaporte). Aviso “4 itens adicionados”. A caixa some depois.
3. **Grupos** (kicker + “x/y” à direita), cada um num cartão: caixa de seleção 30 px (raio 10) + nome 15 px/600 (riscado e `#8C889E` quando pronto) + observação opcional 12 px.
4. Campo “Adicionar item à mala” (50 px) + botão “+” 50 × 50 px.

## Lista padrão (43 itens, 7 grupos)
- **Documentos**: RG ou CNH, Passaporte, Cartão de crédito/débito
- **Roupas**: Camisetas, Calças, Roupa íntima, Tênis/Sapatos confortáveis, Meias, Jaqueta/Casaco, Gorro e cachecol
- **Cuidados pessoais**: Escova de dentes, Pasta de dentes, Shampoo, Desodorante, Hidratante
- **Eletrônicos**: Celular, Carregador de celular, Power bank, Fone de ouvido, Adaptador de tomada
- **Farmácia**: Analgésicos, Medicamentos de uso contínuo, Band-aid
- **Acessórios**: Mochila pequena, Garrafa de água, Cadeado, Guarda-chuva
- **Outros**: Almofada de pescoço, Saco de roupa suja, Lanches

> Viagens criadas pelo assistente começam com uma lista curta (ver `14`). Qual lista usar como padrão definitivo: `A DEFINIR`.

## Regras
1. Marcar/desmarcar atualiza contador e barra. Ao completar tudo: aviso “Mala completa. Boa viagem!”.
2. Item novo entra no **último grupo**; o campo continua focado; aviso “Item adicionado”.
3. A mala é **compartilhada** pelo grupo (uma lista por viagem). Mala individual por pessoa: `A DEFINIR`.
4. Remover/editar item: `A DEFINIR`.
5. Sugestões são geradas a partir de clima e roteiro (não alteram nada sem o toque em “Adicionar”).
