# 32 — Onde já estive (mapa-múndi)

## Objetivo
Mostrar os países já visitados e os planejados, com percentuais do mundo e por continente.

## Acesso
Perfil → indicadores Continentes/Países/Cidades, mini mapa, Configurações → Lugares onde já estive.

## Layout
1. Topo: voltar · “Onde já estive” · botão “+” → marcar país.
2. Kicker roxo “SEU MAPA”; percentual em editorial **64 px** + “do mundo” (28 px `#5E5A73`); linha 13 px “N de 195 países visitados · com as próximas viagens, X%”.
3. **Mapa-múndi** (projeção Equal Earth, raio 26 px, fundo `#EEF0F7`):
   - Visitado `#2B207F` · Planejado `#C9FF27` com contorno `#9ACC1F` · Demais `#DAD7E3`; contornos brancos.
   - Arrastar move; roda do mouse/pinça e botões ( + / − / globo para centralizar ) aproximam de 1× a 6× (passo 1,5×, 350 ms).
   - Toque num país → folha do país.
4. Legenda: “● Já visitei · N” e “● Vou visitar · N” + “Toque num país”.
5. **Por continente** (cartão): para cada continente, “**v** de total · %” + selo lima “+N planejado(s)”; barra 10 px com visitados (roxo) e planejados (lima). Ordenados por (visitados + planejados).
   | Continente | Total de países |
   | --- | --- |
   | Europa | 44 |
   | Ásia (inclui Rússia e Turquia) | 48 |
   | África | 54 |
   | América do Norte | 23 |
   | América do Sul | 12 |
   | Oceania | 14 |
6. **Já visitei** (lista): **bandeira circular 42 px** com selo roxo ✓ · nome do país · “{continente} · {origens}” · seta.
7. **Próximos destinos** — mesma lista com selo lima de calendário.
8. Botão **+ Marcar país onde já estive**.

## Folha do país
- Bandeira 56 px · nome · continente.
- Caixa de status: “Você já esteve aqui” (fundo `#EBE8FF`, ícone ✓ em roxo) / “Está nas suas próximas viagens” (fundo `#F1FFD1`, ícone calendário lima) / “Ainda não visitado” — com as origens (ex.: “Paris · mai 2026”, “Marcado por você”).
- Ação: **✓ Já estive aqui** (marca manualmente) · **Remover dos visitados** (só se foi marcado manualmente) · se veio de viagem: “Vem de uma viagem passada. Para remover, edite a viagem.”
- **+ Planejar viagem para cá** → assistente.

## Folha “Marcar países”
Busca + lista alfabética, no idioma da interface ativo (`pt-BR`, `pt-PT`, `en` ou `es`), de todos os países: bandeira 32 px · nome · continente · caixa de seleção. Países que vêm de viagem não podem ser desmarcados (aviso “Já vem de uma viagem sua”).

## Regras de cálculo
1. **Visitado** = país de viagem com data já passada **ou** marcado manualmente.
2. **Planejado** = país de viagem futura que ainda não foi visitado.
3. Percentual do mundo = visitados ÷ **195** (mínimo exibido 1%). Com planejados = (visitados + planejados) ÷ 195.
4. Bandeiras: biblioteca **circle-flags** (licença MIT), formato circular.
