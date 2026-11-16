# 11 — Inserir lugar no roteiro

## Origem
Botão “+ Roteiro” no feed e “Inserir em um roteiro” na página do lugar.

## Folha
- Cabeçalho “Inserir no roteiro” / subtítulo com o nome do lugar.
- **VIAGEM** (kicker): carrossel de chips de viagem (padding 8/14 px, raio 18 px): miniatura 40 px (raio 12) + nome (13 px/700) + datas (12 px). Selecionada: borda 2 px `#2B207F`, fundo `#F8F7FF`. No fim, chip **+ Nova** (56 px) → assistente de viagem.
- **DIA**: chips de dia (mín. 86 px): “Dia N” + “{data} · {nº de paradas}”. Selecionado: fundo `#15122E`, texto branco.
- **Dica** (fundo `#F1FFD1`, texto `#2C3A00`, ícone faísca em quadrado `#15122E`): 
  - se já existe parada do mesmo bairro no dia: “Fica perto de **{parada}**, que já está neste dia. Encaixamos logo depois.”
  - senão: “Neste dia você passa por {bairro da 1ª parada}. Colocamos no fim da tarde.” (ou “lugares livres” se o dia está vazio).
- Botão **Adicionar ao Dia N** (54 px).

## Regras
1. Viagem pré-selecionada: a primeira cujo destino inclui a cidade do lugar; senão a primeira da lista. Dia pré-selecionado: primeiro dia daquela cidade.
2. A parada entra no **fim do dia**, com horário = última parada + 2 h (máximo 22:00) ou 10:00 se o dia está vazio; deslocamento padrão “~10 min a pé”.
3. A parada nova pisca com halo lima (1,4 s) ao abrir o roteiro.
4. Aviso: “{lugar} no Dia N · {viagem}” + **Ver** (abre a viagem naquele dia).
5. Convidado → convite para criar conta.
6. Papel “Assistente júnior” não pode inserir (só visualiza). Como a viagem aparece para ele nessa lista: `A DEFINIR`.
