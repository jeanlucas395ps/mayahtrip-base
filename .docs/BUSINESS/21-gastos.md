# 21 — Gastos e divisão

## Resumo do grupo (bloco `#2B207F`, raio 26 px, padding 18 px)
- “Gasto do grupo” (13 px `#D4CEFC`) · “N pessoas”.
- Total gasto em editorial **52 px** (42 px se o valor for longo) + “de {orçamento}”.
- Barra 8 px (trilho branco 16%, preenchimento lima) + “X% usado · dentro do orçamento” / “acima do orçamento”.
- Botão lima **+ Novo gasto** (largura total) → `22-novo-gasto.md`.

## Saldo (cartão, só com 2+ pessoas e algum gasto)
- Avatares (40 px) das outras pessoas.
| Situação | Texto | Ação |
| --- | --- | --- |
| Saldo ≈ 0 (< 0,50) | “Contas em dia” / “Ninguém deve nada a ninguém” | etiqueta lima “✓ Quitado” |
| 2 pessoas, te devem | “{Nome} te deve {valor}” / “Toque em acertar quando receber” | **Acertar** |
| 2 pessoas, você deve | “Você deve {valor} a {Nome}” / “Pague e marque como acertado” | **Acertar** |
| 3+ pessoas | “Você tem a receber {valor}” ou “Você deve {valor}” / “Dividido entre N pessoas” | **Acertar** |
- **Acertar** cria um lançamento “Acerto: {quem paga} → {quem recebe}” no grupo “Acertos” que zera o saldo; aviso “Contas acertadas” + **Desfazer**. Acertos não entram no total gasto nem nas categorias.

## Por categoria
- Cabeçalho “Por categoria” + link **Exportar** (`A DEFINIR` formato).
- Barra empilhada 12 px (segmentos raio 6, espaço 3 px) na cor de cada categoria, ordenada do maior para o menor.
- Legenda em **uma coluna**: bolinha 10 px da cor · ícone da categoria 15 px · nome · % (40 px) · valor (mín. 84 px).
- As 10 categorias e ícones estão em `BUSINESS.md` §4.6.

## Dica de hospedagem
Se há gastos e nenhum de Hospedagem: caixa `#F1FFD1` “Ainda falta **hospedagem**. Quem foi gastou em média **{valor}** por 2 noites.” + chip **Adicionar estimativa** (cria “Hospedagem (estimativa)” no grupo “Planejado”, dividida entre todos; aviso “Estimativa adicionada ao orçamento”). Origem da média: `A DEFINIR`.

## Lista de gastos
- Agrupada por **quando**: “Antes da viagem”, cada dia (“5 dez”…), “Depois da viagem”, “Acertos”, “Planejado”. Kicker 11 px por grupo; mais recentes primeiro.
- Linha: ícone da categoria (42 px) · descrição (13 px/700) · “{quem} pagou · dividido por N” · valor (13 px/700) · “te devem {X}” (`#3A6B00`) ou “você deve {X}” (`#962A10`).
- Acerto: ícone check em `#EEFFC2`, texto “Pagamento entre vocês”.
- Lançamento novo pisca com halo lima.
- Vazio: “Nenhum gasto ainda” / “Lance o primeiro e a divisão é automática.”

## Regras
1. Divisão igualitária entre as pessoas marcadas.
2. Valores exibidos na moeda de exibição (ver `35`), convertidos pelo câmbio do dia.
3. Viajante experiente e supremo veem e editam; **Assistente júnior não vê esta aba**.
4. Gasto lançado por outra pessoa gera notificação (app + push) para quem participa da divisão.

## A DEFINIR
- Divisão por valores/percentuais diferentes.
- Editar e excluir gasto.
- Definição/edição do orçamento.
