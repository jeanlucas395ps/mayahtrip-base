# 22 — Novo gasto

## Acesso
Ações rápidas (destaque), “+ Novo gasto” na aba Gastos, botão Gasto no detalhe da parada, Maya.

## Folha (ordem de cima para baixo)
1. Título “Novo gasto”.
2. **Valor primeiro**: chip de moeda (32 px, “EUR ▾”) + valor em editorial **54 px** (“€ 0”). Abaixo, quando a moeda difere da moeda de exibição: “≈ {valor convertido} no câmbio de hoje”.
3. **EM QUAL VIAGEM?** — chips de viagem (obrigatório escolher; pré-selecionada a viagem aberta ou a primeira).
4. **Quando** — chips 32 px: **📅 Antes da viagem**, cada dia da viagem (datas), **✓ Depois da viagem**. Padrão: o dia aberto no roteiro; fora da viagem, “Antes da viagem”.
5. **Categoria** — chips 34 px com ícone (10 categorias). Padrão: Alimentação.
6. Descrição (opcional, 44 px).
7. **Pagou** — chips com cada participante (padrão: você).
8. **Dividir** — chips com ✓ (padrão: todos). Pelo menos 1 sempre marcado. À direita: “{valor} cada”.
9. **Teclado numérico** próprio (3 colunas, teclas 46 px, raio 16, fundo `#F4F3F8`, número 22 px/600): 1–9, “,” , 0, ⌫.
10. Botão **Salvar em {viagem}** (52 px), desativado enquanto o valor for 0.

## Regras do teclado
- Máximo 7 dígitos e 2 casas decimais; uma vírgula só; “0” inicial é substituído.
- Quando a folha abre com valor sugerido (ex.: preço da parada), o primeiro dígito digitado substitui o valor.
- Moeda: o chip alterna EUR → BRL → USD → GBP. Moeda inicial = moeda de exibição.

## Ao salvar
- Cria o gasto (descrição vazia vira o nome da categoria), muda a viagem para a aba Gastos e fecha.
- Aviso: “Salvo em {viagem} · {Nome} te deve {X}” ou “· você deve {X} a {Nome}” (em viagens de 2 pessoas). Fora da viagem: ação **Ver**.
- Trocar de viagem recalcula participantes, pagador e “quando”.

## A DEFINIR
- Anexar foto do recibo.
- Outras moedas além das 4.
