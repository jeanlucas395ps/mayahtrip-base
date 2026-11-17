---
name: MayahTrip
description: App mobile para planejar e viver viagens em um só lugar — roteiro, gastos do grupo e descobertas da comunidade.
colors:
  roxo-mayah: "#2B207F"
  roxo-mayah-hover: "#3B2F91"
  roxo-profundo: "#1E1760"
  lima-eletrico: "#C9FF27"
  lima-hover: "#B8E821"
  lima-escuro: "#9ACC1F"
  lima-suave: "#EEFFC2"
  lima-dica: "#F1FFD1"
  oliva-texto: "#2C3A00"
  oliva-forte: "#3A4D00"
  tinta-noite: "#15122E"
  noite-splash: "#120F2A"
  ardosia: "#5E5A73"
  ardosia-clara: "#8C889E"
  cinza-icone: "#9A97AB"
  nevoa: "#F4F3F8"
  nevoa-funda: "#E9E7F0"
  linha: "#E5E3EC"
  linha-suave: "#EEECF3"
  lavanda: "#EBE8FF"
  lavanda-clara: "#F8F7FF"
  lavanda-texto: "#D4CEFC"
  branco: "#FFFFFF"
  vermelho-erro: "#D2462A"
  ferrugem-deve: "#962A10"
  coral-alerta: "#FFE6E0"
  verde-recebe: "#3A6B00"
  verde-sucesso: "#3A9A2E"
  coral-badge: "#FF5A36"
  rosa-curtida: "#FF5A6A"
  ambar-estrela: "#F5A524"
  azul-agua: "#A9CDEB"
  noite-fundo: "#0E0C1D"
  noite-cartao: "#19162E"
  noite-texto: "#F1EFFA"
  noite-mut: "#A6A2BC"
  noite-linha: "#2B2747"
  noite-linha-suave: "#221F3B"
  noite-lavanda: "#26214D"
  noite-lavanda-texto: "#C9C1FF"
  noite-soft-btn: "#24203E"
typography:
  display:
    fontFamily: "Instrument Serif, Georgia, serif"
    fontSize: 64px
    fontWeight: 400
    lineHeight: 0.95
    letterSpacing: -0.01em
  headline:
    fontFamily: "Instrument Serif, Georgia, serif"
    fontSize: 42px
    fontWeight: 400
    lineHeight: 1.02
    letterSpacing: -0.01em
  title-editorial:
    fontFamily: "Instrument Serif, Georgia, serif"
    fontSize: 32px
    fontWeight: 400
    lineHeight: 1
  h1:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 30px
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: -0.035em
  h2:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 19px
    fontWeight: 800
    letterSpacing: -0.025em
  h3:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 16px
    fontWeight: 700
    letterSpacing: -0.01em
  body:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 15px
    fontWeight: 500
    lineHeight: 1.45
  body-sm:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 13px
    fontWeight: 500
    lineHeight: 1.5
  caption:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 12px
    fontWeight: 500
  label-kicker:
    fontFamily: "Plus Jakarta Sans, system-ui, sans-serif"
    fontSize: 11px
    fontWeight: 800
    letterSpacing: 0.14em
rounded:
  xs: 8px
  sm: 12px
  md: 16px
  lg: 18px
  xl: 22px
  card: 24px
  hero: 26px
  sheet: 30px
  pill: 999px
spacing:
  "1": 4px
  "2": 6px
  "3": 8px
  "4": 10px
  "5": 12px
  "6": 14px
  "7": 16px
  "8": 18px
  "9": 20px
  "10": 22px
  screen-x: 20px
  screen-top: 52px
  screen-bottom: 120px
components:
  button-primary:
    backgroundColor: "{colors.roxo-mayah}"
    textColor: "{colors.branco}"
    rounded: "{rounded.pill}"
    height: 50px
    padding: 0 20px
  button-primary-hover:
    backgroundColor: "{colors.roxo-mayah-hover}"
  button-lime:
    backgroundColor: "{colors.lima-eletrico}"
    textColor: "{colors.tinta-noite}"
    rounded: "{rounded.pill}"
    height: 50px
  button-ghost:
    backgroundColor: "{colors.branco}"
    textColor: "{colors.tinta-noite}"
    rounded: "{rounded.pill}"
    height: 50px
  button-danger:
    backgroundColor: "{colors.vermelho-erro}"
    textColor: "{colors.branco}"
    rounded: "{rounded.pill}"
    height: 50px
  chip:
    backgroundColor: "{colors.branco}"
    textColor: "{colors.tinta-noite}"
    rounded: "{rounded.pill}"
    height: 38px
    padding: 0 14px
  chip-selected:
    backgroundColor: "{colors.tinta-noite}"
    textColor: "{colors.nevoa}"
  input:
    backgroundColor: "{colors.branco}"
    textColor: "{colors.tinta-noite}"
    rounded: "{rounded.md}"
    height: 52px
    padding: 0 16px
  card:
    backgroundColor: "{colors.branco}"
    rounded: "{rounded.card}"
  tag-dark:
    backgroundColor: "{colors.tinta-noite}"
    textColor: "{colors.lima-eletrico}"
    rounded: "{rounded.xs}"
    height: 24px
    padding: 0 8px
  tag-purple:
    backgroundColor: "{colors.lavanda}"
    textColor: "{colors.roxo-mayah}"
    rounded: "{rounded.xs}"
    height: 24px
  tag-lime:
    backgroundColor: "{colors.lima-suave}"
    textColor: "{colors.oliva-forte}"
    rounded: "{rounded.xs}"
    height: 24px
  icon-tile:
    backgroundColor: "{colors.roxo-mayah}"
    textColor: "{colors.lima-eletrico}"
    rounded: "{rounded.sm}"
  category-tile:
    backgroundColor: "{colors.lavanda}"
    textColor: "{colors.roxo-mayah}"
    rounded: "{rounded.md}"
  toast:
    backgroundColor: "{colors.tinta-noite}"
    textColor: "{colors.branco}"
    rounded: "{rounded.lg}"
---

# Design System: MayahTrip

> Fonte da verdade **visual** para agentes de IA e pessoas que constroem telas do MayahTrip (app Flutter em `mayahtrip-app`). O comportamento de cada tela está em `.docs/BUSINESS/`; este arquivo diz **como as coisas parecem e se movem**. Valores extraídos do protótipo interativo aprovado “MayahTrip · protótipo interativo” (16 nov 2026), desenhado num frame de **390 × 844 px** (iPhone 14/15). Unidades `px` = pontos lógicos (no Flutter, `double` sem conversão).
>
> Itens ainda não decididos aparecem como **`A DEFINIR`**. Não invente valores para eles.

## Overview

**Creative North Star: “Planeje menos. Viaje mais.”** (slogan do produto)

O MayahTrip mistura duas vozes: a **revista de viagem** (títulos grandes em serifa editorial, fotos sangrando até a borda, degradês escuros sobre imagem) e o **app utilitário calmo** (cartões brancos arredondados sobre fundo névoa, uma única cor de ação roxa, um acento lima elétrico usado com parcimônia). A sensação desejada é de leveza e confiança: poucos elementos por tela, toques grandes, nada de enfeite gratuito.

A densidade é média-baixa: margens laterais de 20 px, blocos separados por 14–22 px, alvos de toque de no mínimo 36 px (o padrão é 44–54 px). A IA (Maya) é discreta — um balão, nunca o centro da tela. A comunidade aparece em cartões de vídeo editoriais (estilo Framer) e num feed vertical em tela cheia.

**Key Characteristics:**
- Roxo `#2B207F` para ação; lima `#C9FF27` como acento (selos, CTA secundário, progresso, ícones sobre roxo).
- Serifa editorial (Instrument Serif) para nomes de lugares, viagens e números de destaque; Plus Jakarta Sans para todo o resto.
- Cantos generosos (16–30 px), formas em pílula para botões e chips.
- Fotos com degradê escuro de baixo para cima e texto branco por cima.
- Movimento com curva “iOS-like” `cubic-bezier(.32,.72,0,1)`; toque comprime para 0,96.
- Modo claro e noturno com a mesma identidade.

## Colors

Paleta de duas cores de marca (roxo e lima) sobre neutros levemente lavanda; cores semânticas só para dinheiro, erro e social.

### Primary
- **Roxo MayahTrip** (`#2B207F`): botões primários, item ativo da navegação, dia selecionado, rota do mapa, pinos, caixas de seleção marcadas, cartão “Nova viagem”, resumo de gastos, fundo dos ícones padronizados. Hover/pressionado: `#3B2F91`. Variante profunda `#1E1760` só no fundo traseiro da carteira animada.

### Secondary
- **Lima Elétrico** (`#C9FF27`): acento. Botão secundário (texto `#15122E`), selo “Acontecendo agora”, barra de progresso sobre roxo, ícones sobre roxo, kicker sobre foto, anel de progresso do feed, país “planejado” no mapa. Hover `#B8E821`; contorno/escuro `#9ACC1F`.
- **Lima Suave** (`#EEFFC2`, texto `#3A4D00`): etiquetas positivas (“Offline”, “Quitado”, “Mais rápido”).
- **Lima Dica** (`#F1FFD1`, texto `#2C3A00`): caixas de dica/sugestão (IA, hospedagem, mala, regra dos 14 dias).

### Neutral
- **Tinta Noite** (`#15122E`): texto principal; toasts; balão da Maya; chip selecionado; selo escuro (`tag-dark`); faixas informativas escuras.
- **Noite Splash** (`#120F2A`): fundo da abertura, do login e de estados vazios do feed.
- **Ardósia** (`#5E5A73`): texto secundário. **Ardósia Clara** (`#8C889E`): texto riscado/concluído, divisor “ou”, legendas do mapa. **Cinza Ícone** (`#9A97AB`): setas › de linhas.
- **Névoa** (`#F4F3F8`): fundo de todas as telas; fundo de botões-ícone “soft”, teclado numérico, mini-indicadores. **Névoa Funda** (`#E9E7F0`): trilho do segmentado.
- **Linha** (`#E5E3EC`): bordas de campos, chips e botões contorno. **Linha Suave** (`#EEECF3`): divisórias dentro de cartões. Tracejados: `#BDB8D6` (1–1,5 px) e `#CFCCDA` (2 px).
- **Lavanda** (`#EBE8FF`): fundo suave de ícones, halo de foco, faixa de intervalo no calendário. **Lavanda Clara** (`#F8F7FF`): fundo de opção selecionada (com borda roxa 2 px). **Lavanda Texto** (`#D4CEFC`): texto secundário sobre roxo.
- **Branco** (`#FFFFFF`): cartões, folhas, campos.

### Semânticas
| Papel | Cor | Uso |
| --- | --- | --- |
| Erro / destrutivo | `#D2462A` | Mensagens de erro, botão Excluir, “Sair”, caixa OTP com erro |
| Você deve | `#962A10` (fundo `#FFE6E0` em `t-red`) | Valores devidos, “Remover do roteiro” |
| Te devem | `#3A6B00` | Valores a receber |
| Sucesso | `#3A9A2E` | OTP correto, senha “Forte” |
| Medidor de senha | `#D2462A` → `#E2A92A` → `#5FB8A2` → `#3A9A2E` | Fraca → Razoável → Boa → Forte |
| Contador de notificações | `#FF5A36` | Pílula no sino |
| Curtida | `#FF5A6A` | Coração preenchido |
| Estrela | `#F5A524`; vazia `#D5D3DE` | Notas |
| Online | `#7BD389` | Ponto “Online” da Maya |
| Água no mapa | `#A9CDEB`, texto `#5C8DB8` | Rio/mar do mapa ilustrativo |
| Parque no mapa | `#D3E5C4` | Áreas verdes |
| Terreno do mapa | `#ECE8DF` | Fundo do mapa do roteiro |
| País sem visita | `#DAD7E3` | Mapa-múndi |

### Cores de avatar (pessoas sem foto)
| Classe | Fundo | Texto |
| --- | --- | --- |
| a1 | `#2B207F` | branco |
| a2 | `#FF8A5B` | `#15122E` |
| a3 | `#C9FF27` | `#15122E` |
| a4 | `#5BC0EB` | `#15122E` |
| a5 | `#F2C14E` | `#15122E` |

### Cores das categorias de gasto (só na barra e na bolinha da legenda)
Hospedagem `#2B207F` · Transporte `#6A5CE0` · Alimentação `#A89BFF` · Atividades `#C9FF27` · Passeios `#7CC243` · Compras `#F2B84B` · Transporte local `#5BC0EB` · Saúde `#FF8A5B` · Comunicação `#2FA88A` · Outros `#A6A2BC`.

### Named Rules
**A Regra da Voz Única.** Só existe uma cor de ação: o roxo. O lima nunca é cor de texto sobre fundo claro — ele é fundo (com texto `#15122E`) ou ícone/texto sobre roxo/escuro/foto.

**A Regra do Ícone Uniforme.** Conjuntos de ícones lado a lado (categorias, Jornada até aqui, ações rápidas, papéis) usam **o mesmo bloco e a mesma cor**; a variação de cor fica fora do ícone (legendas, barras). Nunca um ícone de cada cor.

**A Regra do Lima sobre Roxo.** Ícone dentro de bloco roxo é sempre lima; ícone dentro de bloco lavanda é sempre roxo.

## Typography

**Display Font:** Instrument Serif 400 (regular e *itálico*), fallback Georgia, serif.
**Body Font:** Plus Jakarta Sans 400/500/600/700/800, fallback system-ui, sans-serif.
Ambas do Google Fonts (licença OFL).

**Character:** a serifa editorial dá o tom de revista de viagem aos nomes de lugares e às frases de impacto; a Jakarta, geométrica e pesada nos títulos, mantém a interface direta e legível.

### Hierarquia
| Papel | Fonte | Tamanho / peso | Line-height | Onde |
| --- | --- | --- | --- | --- |
| Display | Instrument Serif | 64 px / 400 | 0,95 | Percentual “do mundo” |
| Hero | Instrument Serif | 50–56 px / 400 | 1 | Nome do lugar e da viagem nas capas (44 px se nome > 9 caracteres), valor do gasto (52 px; 42 px se longo), valor no novo gasto (54 px) |
| Headline | Instrument Serif | 42–46 px / 400 | 1–1,02 | Título do Início, login, assistente (44 px) |
| Título editorial | Instrument Serif | 32–40 px / 400 | 1 | Nome no cartão de viagem (32), feed (40), perfil (36), folhas de confirmação (34–36) |
| Editorial pequeno | Instrument Serif | 22–28 px / 400 | 1 | Cartões de cidade (26), carteira animada (22–24), frase da abertura (22) |
| h1 | Jakarta | 30 px / 800, −0,035em | 1,1 | “Carteira de viagens” |
| h2 | Jakarta | 19 px / 800, −0,025em | — | Títulos de seção e de folha |
| h3 | Jakarta | 16 px / 700, −0,01em | — | Títulos de cartão/linha |
| Corpo | Jakarta | 15 px / 500–700 | 1,45 | Nome de parada, mensagens da Maya, campos |
| Corpo pequeno (sm) | Jakarta | 13 px | 1,45–1,5 | Subtítulos, dicas, legendas |
| Legenda (xs) | Jakarta | 12 px | — | Metadados, rótulos de campo (700) |
| Kicker | Jakarta | 11 px / 800, +0,14em (+0,1em em seções), MAIÚSCULAS | — | Rótulos acima de títulos e de grupos |
| Micro | Jakarta | 10–11 px / 700–800 | — | Contadores de badge, rótulos do mapa |

Itálico da serifa é usado para **uma palavra de ênfase** por frase (“*curiosidade*”, “*inteira*”, “*Viaje mais.*”), muitas vezes colorida (roxo no claro, lima no escuro). Números do dia a dia (valores em linhas, contadores) ficam em Jakarta 700.

### Named Rules
**A Regra da Serifa com Propósito.** Instrument Serif só para nomes próprios (lugares, viagens, pessoas no perfil), grandes números de destaque e frases de marca. Nunca em botões, rótulos, campos ou listas.

## Layout

- **Frame base**: 390 × 844 (escala para outros tamanhos). Margem lateral de tela **20 px**; topo do conteúdo **52–56 px** (abaixo da status bar); folga inferior **120–130 px** nas telas com barra de navegação (88 px) para nada ficar escondido.
- **Ritmo vertical**: 22 px entre blocos do Início; 14 px na Carteira e abas; 12 px entre título de seção e conteúdo; 10 px entre cartões de lista; 8 px entre chips.
- **Escala de espaçamento observada**: 2 · 4 · 6 · 8 · 10 · 12 · 14 · 16 · 18 · 20 · 22 · 24 px. Mais usados: 8, 12, 6, 10, 14.
- **Padding de cartão**: 12–18 px (listas 2 × 14 px com linhas de 12 px vertical).
- **Carrosséis horizontais**: sangram até a borda da tela (margem −20 px) mas o **primeiro item começa alinhado em 20 px** e há 10 px de respiro ao final; encaixe por item (`scroll-snap` proximity). Sem barra de rolagem visível.
- **Grades**: 2 colunas (cidades, atalhos “quem vai”), 3 colunas (indicadores da jornada, mini-indicadores do cartão de viagem, botões do detalhe, mídias 4:5 com 4 px de vão).
- **Listas em cartão**: linhas separadas por divisória 1 px `#EEECF3`, padding vertical 12–14 px.
- **Barra fixa inferior de ação** (ex.: página do lugar): padding 14/20/30 px, fundo névoa 94% + desfoque 16 px, borda superior.
- **Rodapé de passo** (assistente): padding 12/20/30 px com borda superior.

## Elevation & Depth

Híbrido: superfícies separam-se principalmente por **tom** (cartão branco sobre névoa); sombras são suaves, longas e tingidas de tinta/roxo. Vidro (branco 88–94% + desfoque 10–18 px) para elementos sobre foto e barras flutuantes.

### Shadow Vocabulary
| Papel | Valor | Uso |
| --- | --- | --- |
| Cartão elevado | `0 1px 2px rgba(21,18,46,.05), 0 12px 32px rgba(21,18,46,.07)` | Cartão de viagem |
| Mapa | `0 1px 2px rgba(21,18,46,.06), 0 10px 28px rgba(21,18,46,.08)` | Caixa do mapa do roteiro |
| CTA roxo | `0 14px 30px rgba(43,32,127,.25)` | Cartão “Nova viagem” |
| FAB | `0 8px 20px rgba(43,32,127,.35)` | Botão + da navegação |
| Ícone padronizado | `0 4px 10px rgba(43,32,127,.18)` | Blocos roxos de ícone |
| Avatar grande | `0 8px 24px rgba(21,18,46,.18)` | Foto do perfil |
| Flutuante | `0 12px 28px/32px rgba(21,18,46,.3)` | Balão da Maya, toasts |
| Folha | `0 -16px 48px rgba(21,18,46,.2)` | Bottom sheets |
| Painel de login | `0 -12px 40px rgba(18,15,42,.25)` | Folha fixa do login |
| Cartão no mapa | `0 8px 24px rgba(21,18,46,.18)` | Cartão inferior do mapa |
| Chip sobre mapa | `0 2px 8px rgba(21,18,46,.1)` | Chips/botões sobre mapa |
| Segmento ativo | `0 1px 3px rgba(21,18,46,.12)` | Item ativo do segmentado |
| Foco | `0 0 0 4px #EBE8FF` + borda `#2B207F` | Campos, busca, OTP |

Sobreposição de folhas: `rgba(21,18,46,.5)`. No noturno, sombras ficam `rgba(0,0,0,.5)` nas folhas e desaparecem no segmentado.

### Named Rules
**A Regra do Tom Primeiro.** Separe com cor de fundo antes de usar sombra. Cartões de lista dentro de telas não levam sombra; só o cartão de viagem, CTAs e elementos flutuantes.

## Shapes

Forma macia e amigável: nenhum canto vivo em superfície interativa.

| Elemento | Raio |
| --- | --- |
| Botão, chip, campo de busca, toast de ação | pílula (altura ÷ 2) |
| Etiqueta (`tag`) | 8 px |
| Botão-ícone | círculo (44 px → 22) |
| Ícone em bloco | ≈ 1/3 do lado (32 → 11, 40 → 13, 44 → 14, 48 → 16, 52 → 18) |
| Campo de texto | 16 px (18 px no login) |
| Caixa de seleção | 10 px (30 px) / 12 px (36 px) / redonda em seleção única |
| Cartão de lista | 22–24 px |
| Cartão de vídeo / hero | 20–26 px |
| Folha | 30 px no topo (login 32 px) |
| Carteira animada | 32 / 30 / 18 px |
| Moldura do frame | 46 px (só no protótipo) |

Bordas: 1 px `#E5E3EC` (contorno), 2 px `#2B207F` (selecionado), 3 px lima por dentro (`outline-offset −3px`) para cartão de foto selecionado. Avatares de pessoas e a **foto do usuário são sempre circulares**. Mídias em grade usam proporção **4:5**. Bandeiras são **circulares**.

## Motion

| Token | Valor | Uso |
| --- | --- | --- |
| `ease` | `cubic-bezier(.32,.72,0,1)` | Entrada de telas, folhas, passos, transições de layout |
| `out` | `cubic-bezier(.2,.8,.2,1)` | Feedback de toque, cores, saídas curtas |
| `spring` | `cubic-bezier(.3,1.5,.5,1)` | “Pop” de checks, ícones, carteira, OTP preenchido |

| Interação | Duração | Detalhe |
| --- | --- | --- |
| Toque (botão, chip, cartão) | 160 ms | escala 0,96 (navegação 0,92; trilho do feed 0,9) |
| Push de tela | 480 ms | entra de 100% à direita; anterior vai a −26% com brilho 0,9 |
| Modal (assistente) | 480 ms | sobe de 100%; anterior escala 0,94, brilho 0,8, cantos 40 px |
| Troca de aba raiz | 320 ms | fade cruzado |
| Folha abre/fecha | 500 / 460 ms | translateY; overlay fade 400 ms; fecha com arraste > 110 px ou > 0,6 px/ms |
| Entrada em cascata | 500 ms | sobe 14 px + fade; +40 ms por item (máx. 240 ms) |
| Passo do assistente | 420 ms | desliza 36 px na direção da navegação |
| Toast | 450 ms entra / 300 ms sai | sobe 24 px + escala 0,94; vive 3,2 s |
| Check / pop | 300–500 ms | escala 0,4 → 1 com mola |
| Curtir | 450 ms | escala 0,6 → 1,25 → 1 |
| Item recém-criado | 1,4 s | halo lima 4 px que some (`flash`) |
| Barras de progresso | 500 ms | largura com `out` |
| Rota no mapa | 1,4 s | desenho do traço |
| Pinos | 450 ms, +70 ms cada | caem 10 px com mola |
| Indicador giratório | 800 ms/volta | 18 px, borda 2,5 px |
| Erro (shake) | 400 ms | ±8 px horizontal |
| Ponto “ao vivo” | 1,4 s loop | opacidade 1 ↔ 0,25 |
| Zoom de foto (hover/ativo) | 6–9 s linear | escala 1,06–1,14 |

Abertura, login, carteira e geração de roteiro têm coreografias próprias descritas em `BUSINESS/00`, `01`, `15` e `14`.

**Acessibilidade:** com “reduzir movimento” ativo, todas as animações e transições caem para ~0 ms.

### Named Rules
**A Regra do Movimento com Motivo.** Animação só para orientar (de onde veio/para onde foi), confirmar (check, curtida) ou mostrar progresso. Nada pisca ou se move em loop sem indicar estado (exceções: ponto “ao vivo” e seta do feed).

## Iconografia

- Estilo **linha**, grade 24 × 24, traço **2 px**, pontas e junções **arredondadas**, `currentColor` (equivalente ao estilo Lucide). Ícones preenchidos só para: estrela, play, coração curtido.
- Tamanhos: 12–14 (dentro de tags/chips), 16–18 (botões e linhas), 20–22 (navegação, ícones de lista), 24–28 (destaques, ações do feed).
- Conjunto usado: search, home, compass, bag, user, users, plus, minus, back, right, down, arrowr, close, check, share, bell, pin, map, route, walk, car, cal, clock, heart, heartf, chat, bookmark, send, star, play, wallet, file, link, upload, copy, trash, camera, edit, eye, eyeoff, lock, mail, globe, flag, city, bed, plane, ticket, bus, health, wifi, food, landmark, coin, cloud, plug, bulb, spark, zap, crown, moon, sun, settings, filter, undo, dots, shirt.
- **Ícone padronizado (“jicon”)**: bloco roxo `#2B207F`, ícone lima, sombra roxa leve, raio ≈ 1/3. Usado em ações rápidas (48 px), Jornada (32 px), papéis (36 px), dica de 14 dias (32 px).
- **Ícone de categoria**: bloco `#EBE8FF`, ícone roxo, raio 1/3 do lado (padrão 42 px, ícone 45% do lado).
- Biblioteca Flutter de ícones: `A DEFINIR` (precisa ter o estilo acima).
- **Sem emoji** em nenhuma parte da interface.

## Imagery

- Fotos reais de destinos, sempre `cover`, sangrando até a borda em capas (300–420 px de altura) e cartões de vídeo.
- Degradê de legibilidade: de baixo `rgba(12,10,28,.9–.95)` até transparente em 60–72%; topo escuro curto (`.45–.55` → 0 em 20–45%) quando há botões sobre a foto.
- Sem foto: bloco na cor do lugar/viagem com ícone grande a 30–40% de opacidade branca.
- Símbolo e logotipo: SVG do repositório (pontos + avião em lima; logotipo “mayahtrip” em branco ou `#15122E`).
- Avatar da Maya: imagem própria em círculo com fundo `#E9E4FF` (borda lima 2 px no balão).
- Bandeiras: **circle-flags** (MIT), circulares, sombra `0 0 0 1.5px rgba(21,18,46,.08), 0 2px 6px rgba(21,18,46,.12)`.
- Mapa-múndi: projeção Equal Earth (dados world-atlas / Natural Earth).

## Components

### Buttons
- **Shape:** pílula; altura padrão **50 px** (CTA de tela 54–56 px; compactos 46/42/40/38/34 px); padding 0 20 px (compactos 0 14 px); texto 15 px/700 (compactos 13–14 px); ícone 16–18 px à esquerda com 8 px de vão.
- **Primário:** fundo `#2B207F`, texto branco; hover `#3B2F91`.
- **Lima (secundário de destaque):** fundo `#C9FF27`, texto `#15122E`; hover `#B8E821`. Usado em CTA sobre roxo/escuro e ações de “fazer agora” (Inserir em um roteiro, Criar viagem, Acertar, Copiar).
- **Contorno (ghost):** fundo branco, borda 1 px `#E5E3EC`, texto `#15122E`.
- **Escuro:** fundo `#15122E`, texto branco.
- **Destrutivo:** fundo `#D2462A`, texto branco (só em confirmações). Ações destrutivas em lista: texto `#D2462A`/`#962A10` sem fundo.
- **Desativado:** opacidade 35% (no “Publicar avaliação”, 45% + motivo abaixo), sem interação.
- **Carregando:** indicador giratório no lugar do texto; botão desativado.
- **Link:** texto `#2B207F` 700, sem fundo.
- **Botão Google:** 54 px, fundo branco, borda `#E5E3EC`, logo colorido 20 px.

### Icon Buttons
- 44 × 44 px circulares, fundo branco (padrão), `soft` = `#F4F3F8`, `glass` = branco 88% + desfoque 12 px (sobre foto). Compactos 32–40 px.

### Chips
- Altura 38 px (filtros), 32–34 px (dentro de formulários), raio pílula, padding 0 14 px, 13 px/600, borda `#E5E3EC`, fundo branco.
- **Selecionado:** fundo `#15122E`, texto `#F4F3F8`, borda igual.
- Podem levar ícone 12–14 px à esquerda e contador (“Todas · 5”).
- Nunca quebram linha: em grupo, rolam na horizontal.

### Segmented Control
- Trilho `#E9E7F0`, padding 4 px, raio 18 px; itens 42 px (38 px compacto), raio 14 px, 14 px/700 `#5E5A73`; ativo branco, texto `#15122E`, sombra `0 1px 3px rgba(21,18,46,.12)`.
- Usado para abas de conteúdo (viagem, perfil, comentários/curtidas), Lista/Mapa, Privada/Pública, Aparência.

### Tags
- 24 px de altura, raio 8 px, padding 0 8 px, 12 px/700, ícone 12 px. Variações: `t-dark` (`#15122E`/lima), `t-pur` (`#EBE8FF`/`#2B207F`), `t-lime` (`#EEFFC2`/`#3A4D00`), `t-gray` (`#F0EFF4`/`#5E5A73`), `t-red` (`#FFE6E0`/`#962A10`).
- Sobre foto: branco 90% com texto `#15122E`; vidro escuro `rgba(12,10,28,.55)` para duração de vídeo (raio 12).

### Cards / Containers
- **Corner Style:** 24 px (lista), 22 px (paradas, ações), 26 px (blocos de destaque).
- **Background:** branco; destaque roxo `#2B207F` com texto branco/lavanda; destaque escuro `#15122E`; dica `#F1FFD1`.
- **Shadow Strategy:** sem sombra por padrão (ver Elevation).
- **Border:** nenhuma; tracejado `#BDB8D6`/`#CFCCDA` para “adicionar”.
- **Internal Padding:** 12–18 px.

### Cartão de vídeo editorial (signature)
- Raio 20–26 px, foto `cover`, degradê de 72% da altura, botão play de vidro 34 px no canto superior direito, duração no superior esquerdo, kicker lima + título serifado + frase 13 px `#E4E2EE` na base (16 px de margem). Tamanhos: 236 × 330 (Em alta), 138 × 214 (página do lugar), 240 × 150 (roteiros da comunidade), 200 px de altura (detalhe da parada).

### Cartão de viagem (signature)
- Imagem 150 px + selo de status + corpo 16/18 px com nome serifado 32 px, meta 13 px, avatares sobrepostos (−9 px, borda branca 2 px) e 3 mini-indicadores (fundo névoa, raio 14, barra 4 px). Ver `BUSINESS/15`.

### Inputs / Fields
- **Style:** 52 px (50/48/46/44 em contextos compactos), raio 16 px, borda 1 px `#E5E3EC`, fundo branco, padding 0 16 px, texto 15 px; placeholder `#7A768C`.
- **Rótulo:** acima, 12 px/700 `#5E5A73`, 6 px de vão (ou oculto para leitor de tela quando o placeholder basta).
- **Focus:** borda `#2B207F` + halo 4 px `#EBE8FF` (transição 200 ms).
- **Error:** mensagem 12 px/700 `#D2462A` acima do botão; OTP com borda `#D2462A` + shake.
- **Senha:** botão olho 40 px dentro do campo, à direita.
- **Busca:** pílula 54 px (48/46 compacta), ícone de lupa à esquerda, mesma regra de foco.
- **OTP:** 4 caixas 62 × 70 px, raio 18 px, borda 1,5 px, 30 px/800.
- **Área de texto:** mesma aparência, padding 14/16 px, sem redimensionar.
- **Caixa de seleção:** 30 × 30 px raio 10 (lista) / 36 × 36 raio 12 (parada); vazia borda 2 px `#CFCCDA`; marcada `#2B207F` com check branco (noturno: lima com check escuro).
- **Interruptor:** 50 × 30 px, bolinha 24 px; ligado `#2B207F`, desligado `#D5D3DE`.
- **Teclado numérico próprio:** grade 3 colunas, vão 8 px, teclas 46–52 px raio 16, fundo névoa, 22 px/600.

### Navigation
- **Barra inferior:** 88 px, padding 0 8 px 22 px, fundo branco 92% + desfoque 18 px, borda superior `#ECEAF2`. Itens 62 px: ícone 22 + rótulo 11 px/600 `#6E6A82`; ativo `#2B207F`. **FAB central** 54 × 54, raio 20, roxo com “+” lima. Variante escura no feed. Some (desliza 110%) fora das telas raiz.
- **Cabeçalho de tela empilhada:** botão voltar 44 px · título h3 centralizado · ação 44 px (ou espaço de 44 px para manter o centro).
- **Abas sobre vídeo:** pílulas 36 px; ativa branca/`#15122E` 800; inativa `rgba(21,18,46,.35)` + desfoque, branco 600; fila com máscara de esmaecimento à direita.

### Bottom Sheets
- Fundo branco (noturno `#19162E`), raio 30 px no topo, alça 40 × 5 px `#DAD8E2` com 10/6 px de padding, corpo com padding 6/20/34 px, altura máxima 92% (variante `tall` = 88% fixa; variante `gray` com fundo névoa para conversa).
- Cabeçalho padrão: h2 + subtítulo 13 px `#5E5A73` + fechar (ícone soft 40 px).
- Rodapé fixo (comentários): fundo do cartão, borda superior, padding 10/20/12 px.

### Toasts
- Fundo `#15122E` (noturno `#2B207F`), raio 18 px, min. 48 px, padding 10/10/10/16 px, 14 px/600 branco; ícone check lima 26 px; ação opcional em pílula 32 px branco 14%. Máx. 2 empilhados, 110 px acima da base (56 px do topo no login).

### Balão da Maya
- 52 px, raio 26, fundo `#15122E`, avatar 38 px com borda lima 2 px + “Dúvidas? Maya” 14 px/700; versão mini 52 × 52 a 24 px da base fora das telas raiz.
- Mensagens: IA branco raio 20/20/20/6; usuário roxo raio 20/20/6/20; 15 px; largura máx. 84%.

### Lists
- Linha: elemento visual à esquerda (thumb 40–64 px, avatar 32–44 px, ícone em bloco 40–44 px) · bloco de texto flexível (título 13–15 px/700, meta 12 px `#5E5A73`) · ação/valor/seta à direita. Vão 12–14 px.

### Avatars
- Usuário: **foto circular** (44 Início, 104 Perfil, 64 edição, 32–40 listas), fundo `#DCD6FF` quando sem foto, borda branca 2 px (5 px na cor do fundo no perfil).
- Outras pessoas: círculo colorido (a1–a5) com inicial 12 px/800 (proporcional).
- Grupo: sobreposição −9 px, borda na cor do fundo.

### Badges & Status
- Contador: pílula `#FF5A36` 18 px, texto 11 px/800 branco, borda branca 2 px.
- Não lida: ponto 8 px `#2B207F`.
- Selo em avatar/bandeira: círculo 20 px (ou 45% do lado) com borda 2 px, lima ou roxo.

### Progress
- Barra 8 px (4 px em mini, 6 px em notificação), raio metade, trilho `#ECEAF2`, preenchimento roxo (lima sobre roxo, `#9ACC1F` para docs).
- Barra empilhada de categorias 12 px com segmentos raio 6 e 3 px de vão.
- Passos: segmentos 4–5 px com 6 px de vão + “N de M”.
- Anel do feed: círculo 48 px, traço 3 px lima sobre branco 22%.

### Empty States
- Cartão centralizado: ícone 26–28 px em bloco 56–64 px (raio 18–22, `#EBE8FF` ou branco 8% no escuro), título h3 (ou serifa 32 px no feed), texto 13 px `#5E5A73`, CTA opcional 42–44 px.

### Maps
- Mapa do roteiro: caixa 480 px, raio 26; rota roxa 4,5 px sobre branco 9 px; pinos numerados; chips de vidro no topo; cartão branco na base. Fornecedor de mapa real: `A DEFINIR`.
- Mapa-múndi: visitado roxo, planejado lima com contorno `#9ACC1F`, demais `#DAD7E3`, contornos brancos; controles 36 px raio 12 no canto superior direito.

## Dark Mode

Ativação: **Automático (padrão, segue o sistema)**, Claro ou Noturno. Mesma identidade; fundos viram tinta e acentos se mantêm.

| Token | Claro | Noturno |
| --- | --- | --- |
| bg | `#F4F3F8` | `#0E0C1D` |
| card / sheet | `#FFFFFF` | `#19162E` |
| ink | `#15122E` | `#F1EFFA` |
| mut | `#5E5A73` | `#A6A2BC` |
| line | `#E5E3EC` | `#2B2747` |
| line2 | `#EEECF3` | `#221F3B` |
| soft | `#EBE8FF` | `#26214D` |
| ícone sobre soft | `#2B207F` | `#C9FF27` |
| link / texto roxo | `#2B207F` | `#C9C1FF` |
| botão soft | `#F4F3F8` | `#24203E` |
| segmentado | `#E9E7F0` / ativo branco | `#1D1A33` / ativo `#2C2850` |
| chip selecionado | `#15122E` | `#F1EFFA` com texto `#15122E` |
| toast, Maya, tag escura | `#15122E` | `#2B207F` |
| check marcado | roxo + check branco | lima + check `#15122E` |
| barra inferior | branco 92% | `rgba(18,16,34,.92)`, ativo lima |
| mapa-múndi | `#EEF0F7` | `#131126` |

Feed, abertura, login e fotos não mudam. Transição de fundo 400 ms.

## Accessibility

- Alvo de toque mínimo 36 px (padrão 44+).
- Todo botão só de ícone tem rótulo acessível (“Voltar”, “Fechar”, “Curtir”…). Seleções expõem estado (`aria-pressed`/`selected`/`checked`); progresso do assistente expõe valor atual.
- Contraste: texto secundário `#5E5A73` sobre `#F4F3F8`/branco; nunca lima como texto sobre fundo claro.
- Respeitar “reduzir movimento” e o tamanho de fonte do sistema (comportamento com fontes grandes: `A DEFINIR`).
- Leitor de tela anuncia toasts (região “polite”).

## Flutter mapping (app-mobile)

| Design | Flutter |
| --- | --- |
| Tokens de cor | `ThemeExtension` próprio (`MayahTripColors`), registrado em `ThemeData.extensions` para claro e noturno, com os nomes de `DESIGN.md` (roxo, lima, tinta noite, névoa etc.) — decidido em 2026-11-16, ver ADR em `mayahtrip-app/adrs/` |
| Fontes | Plus Jakarta Sans e Instrument Serif empacotadas como assets (OFL) em `assets/fonts/` — decidido em 2026-11-16 (sem dependência de rede na abertura/telas iniciais), ver ADR em `mayahtrip-app/adrs/` |
| Curvas | `Cubic(0.32, 0.72, 0, 1)`, `Cubic(0.2, 0.8, 0.2, 1)`, `Cubic(0.3, 1.5, 0.5, 1)` |
| Folhas | `showModalBottomSheet` com `isScrollControlled`, raio 30, alça própria |
| Tema | `ThemeMode.system` como padrão |
| Textos | sempre via `gen_l10n` (nenhuma string fixa no widget), em `pt-BR`, `pt-PT`, `en` e `es` |
| Bandeiras | SVG circle-flags como assets |

Referência visual executável: protótipo HTML (artefato “MayahTrip · protótipo interativo”); em caso de dúvida, o protótipo e `BUSINESS/` vencem este resumo — e a divergência deve ser registrada.

## Tools, skills e plugins

### Skills do repositório (`.agents/skills`, travadas em `skills-lock.json`)
| Skill | Origem | Quando usar em UI |
| --- | --- | --- |
| `impeccable` | pbakaus/impeccable | Desenhar, revisar, polir, auditar telas e componentes; comando `document` regenera este DESIGN.md (seguir o formato do spec DESIGN.md e perguntar antes de sobrescrever) |
| `emil-design-eng` | emilkowalski/skills | Polimento de interação: estados de toque, timing, origem de animação, detalhes invisíveis |
| `animate` | emilkowalski/skills | Criar uma animação do zero (se deve animar, propriedade, curva, duração, interrupção) — usar os tokens de Motion |
| `learn-taste` | emilkowalski/skills | Ao fim de sessões com correções de design: transformar correções do Jean em regras neste arquivo (só com aprovação) |
| `frontend-design` | anthropics/skills | Direção estética para UI nova, evitando visual genérico |
| `web-design-guidelines` | vercel-labs/agent-skills | Revisão de acessibilidade/UX (útil no painel Angular e no protótipo web) |
| `flutter-apply-architecture-best-practices` | flutter/agent-plugins | Estruturar camadas UI/Logic/Data no app |
| `flutter-internationalization` | MADTeacher/mad-agents-skills | Strings de UI com `gen_l10n`: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es` |
| `playwright` | openai/skills | Capturar e comparar telas do protótipo/painel |
| `grill-me` | mattpocock/skills | Pressionar uma proposta de design antes de implementar |
| `find-skills` / `skill-creator` | vercel-labs / anthropics | Descobrir ou criar novas skills |

### Ferramentas e bibliotecas de referência
- **Google Fonts** — Plus Jakarta Sans, Instrument Serif (OFL).
- **circle-flags** (MIT) — bandeiras circulares.
- **d3-geo + world-atlas + topojson-client + i18n-iso-countries** — geração do mapa-múndi (`world.json`) do protótipo.
- **Playwright** — screenshots de verificação (deviceScaleFactor 2 para revisão humana).
- Ícones: estilo Lucide; pacote Flutter `A DEFINIR`.

### Plugins
- Nenhum plugin de design instalado no repositório. A skill Flutter vem do repositório `flutter/agent-plugins`. Integração com Figma: não utilizada.

## Do's and Don'ts

Regras confirmadas pelo Jean durante o desenho do protótipo.

### Do:
- **Do** começar todo carrossel horizontal com **20 px de espaço à esquerda** (alinhado à margem da tela) e deixar o fim respirar.
- **Do** manter conjuntos de ícones **uniformes** (mesmo bloco, mesma cor, mesmo tamanho) — Jornada até aqui, categorias, ações rápidas.
- **Do** mostrar a **foto do usuário sempre redonda** (Início e Perfil).
- **Do** colocar moeda, fuso, clima e tomada como **pílulas discretas com ícone** na capa da viagem, com detalhe numa folha — não como cartões grandes.
- **Do** usar legenda de categorias em **uma coluna**.
- **Do** manter abas e chips **sem quebra de linha** (rolam na horizontal).
- **Do** deixar o campo de mensagem da Maya **fixo na base** da conversa.
- **Do** perguntar **a viagem primeiro** em fluxos de adicionar parada e gasto, e o **valor primeiro** (com moeda) no novo gasto.
- **Do** usar cartões de vídeo editoriais (estilo Framer) para conteúdo da comunidade.
- **Do** oferecer **Desfazer** no toast após qualquer remoção.
- **Do** usar o anel de progresso circular com seta (canto inferior direito, anel lima) para avançar o feed.
- **Do** mostrar status de viagem como selo sobre a imagem: “Em N dias”/“Acontecendo agora” no canto superior esquerdo; “Rascunho” no canto inferior direito.

### Don't:
- **Don't** usar **emoji** na interface (nem em mapas, rótulos ou títulos).
- **Don't** colocar a IA como caminho principal: a Maya é um balão de dúvidas; criação de viagem é um assistente de 4 passos.
- **Don't** dar uma cor diferente para cada ícone de uma mesma família.
- **Don't** usar lima como texto sobre fundo claro.
- **Don't** usar Instrument Serif em botões, rótulos ou campos.
- **Don't** adicionar selos “Explorador”/verificado nem botão de mensagem/chat no perfil.
- **Don't** recolocar botões “Editar / Compartilhar / Meu mapa” soltos no topo do perfil (o perfil tem só **Editar perfil** + ícone de compartilhar ao lado da foto).
- **Don't** criar telas fora da paleta e dos tokens acima; valor novo precisa ser adicionado aqui primeiro.

## A DEFINIR
- Pacote de ícones no Flutter (estratégia de fontes já decidida — ver seção Flutter mapping).
- Fornecedor de mapas reais e estilo do mapa (claro/noturno).
- Comportamento com fonte grande do sistema (Dynamic Type).
- Layout para tablets e telas pequenas (< 360 px).
- Ilustrações para estados vazios além de ícones.
- Logo/ícone do app e tela de splash nativa.
