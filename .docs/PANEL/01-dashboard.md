# 01 — Dashboard

## Objetivo
Ver, num relance, o tamanho da base e se a fila está andando.

## O que mostra
- Totais: viagens, usuários do app, administradores, roteiros e agentes de IA ativos.
- Fila: quantos jobs estão pendentes, processando e falhos.
- Workers: em execução ou parados. Worker parado aparece como alerta nesta tela. A ação de recolocar job fica em `16-filas.md`.

## Gráficos
- Novos usuários, novas viagens e aquisições Free versus Pro, no período escolhido.
- Pro ativos no ano escolhido.

## Filtros
- Período dos três primeiros gráficos.
- Ano do gráfico de Pro ativos.

## Regras
- Número é contagem real, não estimativa.
- Free versus Pro usa o plano vigente da conta na data da aquisição.
- Pro promocional (`05`) conta como Pro ativo enquanto os 30 dias não venceram.
