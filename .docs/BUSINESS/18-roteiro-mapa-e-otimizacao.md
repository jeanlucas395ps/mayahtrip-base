# 18 — Roteiro em mapa e otimização

## Mapa do dia
- Caixa de **480 px** de altura, raio 26 px, sombra leve. Mostra **apenas as paradas do dia selecionado**.
- Fundo ilustrativo (`#ECE8DF` com malha de ruas branca, parques `#D3E5C4`, rio/mar `#A9CDEB` com nome do rio em 10 px/700 `#5C8DB8`). No app real: mapa de verdade (`A DEFINIR` provedor).
- **Rota**: linha `#2B207F` de 4,5 px sobre contorno branco 9 px, desenhada de ponta a ponta em 1,4 s.
- **Pinos**: círculo 13 px (selecionado 17 px) com aro branco 3 px; número da parada (12/14 px, 800). Cores: normal `#2B207F`, selecionado `#15122E` com anel pulsante, feito = lima com “✓”. Entram caindo (mola, 70 ms entre eles).
- **Rótulo de deslocamento** no meio de cada trecho (pílula branca 22 px, texto 10,5 px/700): “N min a pé” etc. — oculto se o trecho for curto demais.
- **Topo**: chip “📍 N paradas · X km · Y min” e chip **Maps** (abre a rota completa no Google Maps).
- **Cartão inferior** (branco, raio 20 px): miniatura 52 px · “N de M · {horário}” · nome · duração/preço; botões ‹ › (34 px) para ir à parada anterior/próxima (desativados nas pontas). Toque no cartão → detalhe da parada. Toque num pino → seleciona.
- Distância total = soma das distâncias em linha reta × 1,25.

## Rota no Google Maps
“Por enquanto vamos manter para todos”: o botão de rota está disponível para todos os usuários.

## Otimizar
- Disponível com **3 ou mais paradas** no dia (chip “⚡ Otimizar”).
- Mantém a **primeira parada** e reordena as demais pelo vizinho mais próximo.
- Os **horários ficam nas mesmas posições** (a 1ª nova parada herda o 1º horário etc.) e os deslocamentos são recalculados.
- Se não reduzir o tempo total: aviso “Este dia já está na melhor ordem”.
- Se reduzir: aviso “Ordem otimizada · N min a menos de deslocamento” + **Desfazer**.

## A DEFINIR
- Provedor de mapas e modo de transporte padrão.
- Otimizar considerando horários de funcionamento.
