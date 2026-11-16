# 20 — Adicionar parada

## Acesso
“+ Adicionar parada” no roteiro, “+ Adicionar” no dia vazio, Ações rápidas → Adicionar parada.

## Folha alta
1. Título “Adicionar parada”.
2. **EM QUAL VIAGEM?** — chips de viagem (miniatura 40 px + nome + “Em N dias” / “Acontecendo agora” / datas do rascunho). A **viagem é escolhida primeiro**. Dentro de uma viagem, vem pré-selecionada a viagem aberta; senão, a primeira da carteira.
3. **QUAL DIA?** — chips de dia (ativo `#15122E`). Pré-seleção: o dia aberto (se dentro da viagem) ou o Dia 1.
4. Busca “Buscar lugar em {cidade do dia}”.
5. **MAIS SALVOS EM {CIDADE}** — lista: miniatura 52 px · nome · “{categoria} · {cidade} · ★ nota” · botão “+” 36 px (`#EBE8FF`). Lugares já presentes no dia não aparecem. Vazio: “Nenhum lugar encontrado nesta cidade.”

## Regras
1. Trocar de viagem limpa a busca e volta ao dia pré-selecionado.
2. Ao tocar “+”: a parada entra no fim do dia (última + 2 h, máx. 22:00; ou 10:00), com deslocamento calculado a partir da parada anterior; a folha fecha.
3. Se a viagem/dia estão abertos: rola até o fim e mostra “{lugar} no Dia N”. Se não: “{lugar} no Dia N · {viagem}” + **Ver**.
4. Convidado → convite. Assistente júnior não adiciona.
