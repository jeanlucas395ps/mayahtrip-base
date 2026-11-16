# 07 — Busca

## Acesso
Campo de busca do Início; lupa no Explorar.

## Layout
- Topo (52 px): voltar 44 px + campo 48 px “Lugar, restaurante, cidade” (teclado abre sozinho 450 ms após entrar).
- **Filtros** (chips 38 px, 14 px de espaço interno): Tudo (ativo) · Restaurantes · Atrações · À noite · Grátis. Chip ativo: fundo `#15122E`, texto claro.
- **Dica da comunidade**: caixa `#15122E`, raio 20 px, ícone de faísca em quadrado lima 34 px; texto 13 px: “Em Roma, quem já foi recomenda **Monti e Trastevere** para comer bem gastando pouco.”
- **Resultados** (espaço 10 px): cartão branco raio 22 px, padding 12 px — miniatura 64 × 80 px (raio 16) · nome (h3) · “{categoria} · {cidade}” · estrela `#F5A524` + nota + (nº de avaliações) + etiqueta roxa “▶ {nº de vídeos}” · seta.

## Regras
1. A busca filtra a cada tecla por nome, categoria, bairro e cidade (sem diferenciar maiúsculas).
2. Sem resultado: cartão “Nada por aqui ainda” / “Tente “pizza”, “museu” ou “Trastevere”.”
3. Toque num resultado → `08-pagina-do-lugar.md`.

## A DEFINIR
- Comportamento real dos filtros (no protótipo só mostram aviso).
- Regra da dica da comunidade (de qual cidade/qual texto mostrar).
- Ordenação dos resultados.
- Busca por pessoas e por roteiros.
