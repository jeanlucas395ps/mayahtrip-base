# 14 — Nova viagem (assistente em 4 passos)

## Acesso
Cartão “Nova viagem” do Início, botão “+ Nova” da Carteira, Ações rápidas, notificação de boas-vindas, chip “+ Nova” ao inserir no roteiro, Maya. Abre como tela modal (sobe de baixo).

## Estrutura fixa
- **Topo** (52 px): fechar (✕) no 1º passo / voltar (←) nos demais · barra de progresso com 4 segmentos de 5 px (ativos `#2B207F`, pendentes `#DAD8E2`, transição 300 ms) · “N de 4” (12 px/700).
- **Título** editorial 44 px + subtítulo 15 px `#5E5A73`.
- Avançar anima o conteúdo da direita (36 px) e voltar da esquerda, 420 ms.
- **Rodapé** (borda superior, fundo da tela): botão **Continuar** (56 px, 16 px) — desativado (35%) se o passo não está válido; no passo 4, botão lima **✨ Criar viagem**. Abaixo: “Prefere conversar?” + link com avatar da Maya 20 px “Fale com a Maya”.

## Passo 1 — Para onde você vai? (“Pode escolher mais de uma cidade.”)
- Campo “Buscar cidade”. Escolhidas aparecem como chips escuros com ✕.
- Sem busca: “POPULARES AGORA” em grade 2 colunas (espaço 10 px): 1º cartão ocupa 2 colunas, 150 px, nome 34 px e “· 5,8 mil vídeos”; demais 120 px, nome 26 px. Cartão selecionado: contorno lima 3 px e botão ✓ lima (30 px); não selecionado: “+” em branco 25%.
- Com busca: lista de cidades que contêm o texto (nome ou país); se nada encontrado, oferece “{texto} — Adicionar como destino”.
- Válido com ≥ 1 destino. Ordem dos destinos = ordem de escolha.

## Passo 2 — Quando? (“Toque no dia da ida e no da volta.”)
- Segmentado: **📅 Datas definidas** | **Ainda não sei**.
- **Datas definidas**: calendário mensal (semana começa na segunda; S T Q Q S S D), navegação ‹ › entre meses; dias passados desativados (`#C4C1D2`). Ida e volta em círculo 44 px `#2B207F`; intervalo com faixa `#EBE8FF`. Tocar antes da ida redefine a ida. Rodapé: “Período {ida} – {volta}” + etiqueta “N dias”.
- **Ainda não sei**: contador “Quantos dias?” (− / número editorial 52 px / +), de 1 a 30; texto “Você define as datas quando quiser.” → a viagem nasce como **Rascunho**.
- Válido com ida e volta escolhidas ou modo “Ainda não sei”.

## Passo 3 — Quem vai com você? (“Dá para convidar depois também.”)
- 4 atalhos (grade 2 colunas, raio 22 px): **Sozinho** (1 adulto), **Casal** (2, padrão), **Família** (2 adultos · 2 crianças), **Amigos** (4). Selecionado: borda 2 px roxa, fundo `#F8F7FF`.
- Contadores Adultos (1–10) e Crianças (0–10). Mexer nos contadores desmarca o atalho.
- Campo opcional “E-mail de quem vai junto”.

## Passo 4 — Como quer começar? (“Tudo continua editável depois.”)
Três opções (cartões raio 22 px, ícone 44 px):
1. **Roteiro sugerido** (etiqueta lima “Mais rápido”) — “Montamos dia a dia com os lugares mais bem avaliados, organizados por bairro.” Mostra ainda: “O que não pode faltar? (opcional)” (Gastronomia [padrão], História e cultura, Vida noturna, Compras, Natureza, Arte) e **Ritmo** (Tranquilo · Equilibrado [padrão] · Intenso).
2. **Roteiro da comunidade** — “Comece pelo roteiro de quem já foi e ajuste do seu jeito.” Mostra cartões de roteiros (240 × 150 px) com autor, nota e nº de usos.
3. **Começar do zero** — “Dias vazios. Você adiciona os lugares que salvar.”

**Regra dos 14 dias**: se a viagem tem **mais de 14 dias**, aparece a caixa “Viagens com mais de 14 dias não geram roteiro automático. Você começa com os N dias livres e adiciona os lugares do seu jeito.” e as opções 1 e 2 ficam desativadas (40%); “Começar do zero” é selecionada automaticamente.

## Geração (após “Criar viagem”)
Tela cheia com a foto do destino (zoom 1,15 → 1,02 em 4 s) sob véu `rgba(21,18,46,.72)`; kicker lima “MONTANDO SUA VIAGEM” + destino em editorial 52 px. Lista de etapas: cada uma começa a 35% de opacidade, ganha indicador giratório e depois check lima (pop) a cada 620 ms:
- Sugerido: “Separando os lugares mais salvos de {cidade}” → “Agrupando por bairro para andar menos” → “Calculando deslocamentos e horários” → “Pronto!”
- Comunidade: “Copiando o roteiro de @{autor}” → “Ajustando para as suas datas” → “Calculando deslocamentos” → “Pronto!”
- Do zero: “Criando os dias da viagem” → “Preparando gastos e checklist” → “Pronto!”

## Resultado
- Viagem criada com nome = destinos unidos por “ e ”, 1 dia por dia do período, cidades distribuídas proporcionalmente entre os dias.
- Ritmo **Tranquilo** limita a 3 paradas por dia.
- Mala inicial: Essenciais (Documento de identidade, Cartão de crédito, Carregador) e Roupas (Calçado confortável, Casaco leve).
- Participantes: o criador como **Dono**; demais adultos como Viajante supremo (nomes provisórios).
- Abre a viagem e mostra “Viagem criada. Tudo é editável.” (ou “Viagem criada. Adicione lugares pelo feed ou busca.” quando não há roteiro pronto para a cidade).
- Geração real por IA é assíncrona e avisa por notificação (ver `06`).

## A DEFINIR
- Convite por e-mail no passo 3: papel aplicado (o padrão do convite é Viajante experiente?).
- Nomes dos participantes adicionados pelos contadores.
- Limite máximo de dias com datas definidas.
